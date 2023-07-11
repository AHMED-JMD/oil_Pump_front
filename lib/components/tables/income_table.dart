import 'package:flutter/material.dart';
import 'package:oil_pump_system/models/company.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:advanced_datatable/advanced_datatable_source.dart';

class IncomeTable extends StatefulWidget {
  IncomeTable({Key? key}) : super(key: key);

  @override
  State<IncomeTable> createState() => _IncomeTableState();
}

class _IncomeTableState extends State<IncomeTable> {
  var rowsPerPage = 5;
  final source = ExampleSource();
  final _searchController = TextEditingController();

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
        return AlertDialog(
          title: Text('Modal Title'),
          content: Text('This is the modal content.'),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
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
                        _openModal(context);
                      } ,
                      icon: Icon(Icons.delete),
                      label: Text(''),
                    ),
                    SizedBox(width: 5,),
                    ElevatedButton(
                        onPressed: (){} ,
                        child: Text('+ ايصال جديد')
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
                ),
                DataColumn(
                  label: const Text('اسم السائق'),
                ),
                DataColumn(
                  label: const Text('رقم اللوحة'),
                ),
                DataColumn(
                  label: const Text('نوع الوقود'),
                ),
                DataColumn(
                  label: const Text('الكمية'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ExampleSource extends AdvancedDataTableSource<Company> {
  String lastSearchTerm = '';
  bool isSelected = false;

  final data = List<Company>.generate(
      13, (index) => Company(ID: '$index', company: "محمد بنزين", fname: "خ5 13266", lname: "بنزين", phone: "71500"));

  @override
  DataRow? getRow(int index) {
    final currentRowData = lastDetails!.rows[index];
    return DataRow(
        selected: isSelected,
        onSelectChanged: (value) {
          print(value);
        },
        cells: [
      DataCell(
        Text(currentRowData.ID.toString()),
      ),
      DataCell(
        Text(currentRowData.company),
      ),
      DataCell(
        Text(currentRowData.fname),
      ),
      DataCell(
        Text(currentRowData.lname),
      ),
      DataCell(
        Text(currentRowData.phone),
      ),
    ]);
  }

  @override
  int get selectedRowCount => 0;

  void filterServerSide(String filterQuery) {
    lastSearchTerm = filterQuery.toLowerCase().trim();
    setNextView();
  }

  @override
  Future<RemoteDataSourceDetails<Company>> getNextPage(
      NextPageRequest pageRequest) async {
    return RemoteDataSourceDetails(
      data.length,
      data
          .skip(pageRequest.offset)
          .take(pageRequest.pageSize)
          .toList(), //again in a real world example you would only get the right amount of rows
    );
  }
}

