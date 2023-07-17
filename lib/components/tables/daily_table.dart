import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:oil_pump_system/API/daily.dart';
import 'package:oil_pump_system/models/daily_data.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:http/http.dart';
import 'dart:convert';

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
  bool isLoading = false;

  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    _searchController.text = '';
  }

  //server side delete Function
  Future deleteDaily() async {
    setState(() {
      isLoading = true;
    });

    //send to server
    if(selectedIds.length != 0){
      API_Daily.Delete_Daily(selectedIds).then((response){
        setState(() {
          isLoading = false;
        });
        print(response);
        if(response == true){
          print(response);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('تم الحذف بنجاح', textAlign: TextAlign.center, style: TextStyle(fontSize: 17),),
              backgroundColor: Colors.red,
            ),
          );
        }else{
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$response', textAlign: TextAlign.center, style: TextStyle(fontSize: 17),),
              backgroundColor: Colors.red,
            ),
          );
        }
      });
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('الرجاء اختيار يومية من الجدول', textAlign: TextAlign.center, style: TextStyle(fontSize: 17),),
          backgroundColor: Colors.red,
        ),
      );
    }
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
                        initialValue: 'جاز',
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
                        decoration: InputDecoration(labelText: 'القراءة'),
                        // onChanged: (val) {
                        //   print(val); // Print the text value write into TextField
                        // },
                        initialValue: selectedIds.length != 0 ? '2950713' : '',
                        validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                      ),
                      // Add another text field
                      FormBuilderTextField(
                        name: 'nw_read',
                        decoration: InputDecoration(labelText: 'القراءة الجديدة'),
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
  //delete modal
  void _deleteModal(BuildContext context){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text('حذف اليومية'),
            content: Text('هل انت متأكد برغبتك في جذف اليومية'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Center(
                  child: SizedBox(
                    height: 30,
                    child: TextButton(
                      child: Text('حذف'),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        primary: Colors.white
                      ),
                      onPressed: (){
                        deleteDaily();
                        Navigator.of(context).pop();
                      }
                    ),
                  ),
                ),
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
                    TextButton.icon(
                      onPressed: (){
                        _deleteModal(context);
                      } ,
                      icon: Icon(
                        Icons.delete,
                        ),
                      label: Text(''),
                    ),
                    SizedBox(width: 3,),
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
                  label: const Text('الاسم'),
                    onSort: setSort
                ),
                DataColumn(
                    label: const Text('البيان'),
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
                  label: const Text('التاريخ'),
                    onSort: setSort
                ),
                DataColumn(
                  label: const Text('عرض/ تعديل'),
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

  @override
  DataRow? getRow(int index) {
    final currentRowData = lastDetails!.rows[index];
    return DataRow(
        selected: selectedIds.contains(currentRowData.tranId),
        onSelectChanged: (selected) {
          if(selected != null){
            selectedRow(currentRowData.tranId, selected);
          }
        },
        cells: [
      DataCell(
        Text(currentRowData.name),
      ),
      DataCell(
        Text(currentRowData.comment),
      ),
      DataCell(
        Text(currentRowData.amount.toString()),
      ),
      DataCell(
        Text(currentRowData.type),
      ),
      DataCell(
        Text(currentRowData.date),
      ),
          DataCell(
            Center(
              child: InkWell(
                  onTap: (){},
                  child: Icon(Icons.remove_red_eye, color: Colors.grey[500],)
              ),
            ),
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
    //--------------get request to server -----------
    final url = Uri.parse('http://localhost:5000/transaction/');
    Map<String,String> requestHeaders = {
      'Content-Type' : 'application/json',
      'x-auth-token' : 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImMyNGQ2ZTMwLTE5NzAtMTFlZS05MTczLWZiMjA5ZjI2YWQyMyIsImlhdCI6MTY4ODM2ODMxNH0.FuZln5gldCx3LWd_ylaxHDyiwt0oSId_98MvrKfCvOA'
    };

    Response response = await get(url, headers: requestHeaders);
    if(response.statusCode == 200){
      final data = jsonDecode(response.body);

      await Future.delayed(Duration(seconds: 1));
      return RemoteDataSourceDetails(
        data.length,
        (data as List<dynamic>)
            .map((json) => Daily.fromJson(json))
            .skip(pageRequest.offset)
            .take(pageRequest.pageSize)
            .toList(),
        filteredRows: lastSearchTerm.isNotEmpty
            ? (data as List<dynamic>).length
            : null,
      );
    }else{
      throw Exception('Unable to query remote server');
    }

  }
}

//selected list here
List<String> selectedIds = [];