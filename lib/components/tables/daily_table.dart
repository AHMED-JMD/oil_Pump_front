import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:oil_pump_system/models/daily_data.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:advanced_datatable/advanced_datatable_source.dart';

class DailyTable extends StatefulWidget {
  DailyTable({Key? key}) : super(key: key);

  @override
  State<DailyTable> createState() => _DailyTableState();
}

class _DailyTableState extends State<DailyTable> {
  var rowsPerPage = 5;
  final source = ExampleSource();
  var sortIndex = 0;
  var sortAsc = true;
  final _searchController = TextEditingController();
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    _searchController.text = '';
  }

  //modal open
  void _openModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: SimpleDialog(
            title: Text("قراءة جديدة"),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: FormBuilder(
                  // Define the form key to identify the form
                  key: _formKey,
                  // Define the form fields
                  child: Column(
                    children: [
                      // Add a dropdown field
                      FormBuilderDropdown(
                        name: 'machine',
                        decoration: InputDecoration(labelText: 'المكنة'),
                        validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                        // onChanged: (val) {
                        //   print(val); // Print the text value write into TextField
                        // },
                        items: ['بنزين', 'جاز','جاز دوشكا']
                            .map((gender) => DropdownMenuItem(
                          value: gender,
                          child: Text('$gender'),
                        ))
                            .toList(),
                      ),
                      // Add a text field
                      FormBuilderTextField(
                        name: 'old_read',
                        decoration: InputDecoration(labelText: 'القراءة 1'),
                        // onChanged: (val) {
                        //   print(val); // Print the text value write into TextField
                        // },
                        validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                      ),
                      // Add another text field
                      FormBuilderTextField(
                        name: 'nw_read',
                        decoration: InputDecoration(labelText: 'القراءة 2'),
                        // onChanged: (val) {
                        //   print(val); // Print the text value write into TextField
                        // },
                        validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                      ),
                      FormBuilderTextField(
                        name: 'value',
                        decoration: InputDecoration(labelText: 'القيمة'),
                        // onChanged: (val) {
                        //   print(val); // Print the text value write into TextField
                        // },
                        validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                      ),
                      FormBuilderTextField(
                        name: 'amount',
                        decoration: InputDecoration(labelText: 'المبلغ'),
                        // onChanged: (val) {
                        //   print(val); // Print the text value write into TextField
                        // },
                        validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                      ),
                      SizedBox(height: 40,),
                      // Add a submit button
                      SizedBox(
                        width: 100,
                        height: 40,
                        child: ElevatedButton(
                          child: Text('ارسال'),
                          style: ElevatedButton.styleFrom(
                              textStyle: TextStyle(fontSize: 18)
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.saveAndValidate()) {
                              print(_formKey.currentState!.value);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  TextButton.icon(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                    label: Text('الغاء'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 400,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            labelText: 'ابحث',
                          ),
                          onSubmitted: (vlaue) {
                            source.filterServerSide(_searchController.text);
                          },
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _searchController.text = '';
                        });
                        source.filterServerSide(_searchController.text);
                      },
                      icon: const Icon(Icons.clear),
                    ),
                    IconButton(
                      onPressed: () =>
                          source.filterServerSide(_searchController.text),
                      icon: const Icon(Icons.search),
                    ),
                  ],
                ),
                Row(
                  children: [
                    ElevatedButton(
                        onPressed: (){
                          _openModal(context);
                        } ,
                        child: Text('قراءة عداد')
                    ),
                    SizedBox(width: 5,),
                    ElevatedButton(
                        onPressed: (){
                          Navigator.pushNamed(context, '/add_daily');
                        } ,
                        child: Text('يومية جديدة')
                    ),
                    SizedBox(width: 5,),
                  ],
                )

              ],
            ),
            AdvancedPaginatedDataTable(
              addEmptyRows: false,
              source: source,
              showFirstLastButtons: true,
              rowsPerPage: rowsPerPage,
              availableRowsPerPage: [ 5, 10, 25],
              onRowsPerPageChanged: (newRowsPerPage) {
                if (newRowsPerPage != null) {
                  setState(() {
                    rowsPerPage = newRowsPerPage;
                  });
                }
              },
              columns: [
                DataColumn(
                  label: const Text('ID'),
                  numeric: true,
                    onSort: setSort
                ),
                DataColumn(
                  label: const Text('الاسم'),
                    onSort: setSort
                ),
                DataColumn(
                  label: const Text('المبلغ'),
                    onSort: setSort
                ),
                DataColumn(
                  label: const Text('الحالة'),
                    onSort: setSort
                ),
                DataColumn(
                  label: const Text('التعليق'),
                    onSort: setSort
                ),
                DataColumn(
                  label: const Text('التاريخ'),
                    onSort: setSort
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //sorting function
  void setSort(int i, bool asc) => setState(() {
    sortIndex = i;
    sortAsc = asc;
  });
}

class ExampleSource extends AdvancedDataTableSource<Daily> {
  String lastSearchTerm = '';
  //selected list here
  List<String> selectedIds = [];
  //original data
  final data = List<Daily>.generate(
      13, (index) => Daily(ID: "$index ", name: "شركة نبتة للبترول$index", amount: "1798500", status: "دائن", comment: "لصالح شركة نبتة", date: "7-5-2023"));

  @override
  DataRow? getRow(int index) {
    final currentRowData = lastDetails!.rows[index];
    return DataRow(
        selected: selectedIds.contains(currentRowData.ID),
        onSelectChanged: (selected) {
          if(selected != null){
            selectedRow(currentRowData.ID, selected);
          }
        },
        cells: [
      DataCell(
        Text(currentRowData.ID.toString()),
      ),
      DataCell(
        Text(currentRowData.name),
      ),
      DataCell(
        Text(currentRowData.amount),
      ),
      DataCell(
        Text(currentRowData.status),
      ),
      DataCell(
        Text(currentRowData.comment),
      ),
      DataCell(
        Text(currentRowData.date),
      ),
    ]);
  }

  @override
  int get selectedRowCount => selectedIds.length;

  void selectedRow(String id, bool newSelectState) {
    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      selectedIds.add(id);
    }
    notifyListeners();
  }

  void filterServerSide(String filterQuery) {
    lastSearchTerm = filterQuery.toLowerCase().trim();
    setNextView();
  }

  @override
  Future<RemoteDataSourceDetails<Daily>> getNextPage(
      NextPageRequest pageRequest) async {
    await Future.delayed(Duration(seconds: 1));
    return RemoteDataSourceDetails(
      data.length,
      data
          .skip(pageRequest.offset)
          .take(pageRequest.pageSize)
          .toList(),
    );
  }
}
