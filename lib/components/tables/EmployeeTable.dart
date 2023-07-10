import 'package:flutter/material.dart';
import 'package:oil_pump_system/models/company.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:advanced_datatable/advanced_datatable_source.dart';

class EmployeeTable extends StatefulWidget {
  // late void Function(int) setPage;
  EmployeeTable({Key? key,}) : super(key: key);

  @override
  State<EmployeeTable> createState() => _EmployeeTableState();
}

class _EmployeeTableState extends State<EmployeeTable> {


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
                          padding: const EdgeInsets.only(left: 10),
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
                      SizedBox(width: 5,),
                      TextButton.icon(
                          onPressed: (){
                            _openModal(context);
                          } ,
                          icon: Icon(Icons.delete),
                          label: Text(''),
                      ),
                      SizedBox(width: 5,),
                      ElevatedButton(
                          onPressed: (){
                            Navigator.pushNamed(context, '/add_employee');
                          } ,
                          child: Text('+ اضافة موظف')
                      ),
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
                    label: const Text('الاسم'),
                  ),
                  DataColumn(
                    label: const Text('رقم الهاتق'),
                  ),
                  DataColumn(
                    label: const Text('السكن'),
                  ),
                  DataColumn(
                    label: const Text('الراتب'),
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
      13, (index) => Company(ID: '$index', company: "علوبة", fname: "010018816", lname: "حي الدناقلة", phone: "71500"));

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

