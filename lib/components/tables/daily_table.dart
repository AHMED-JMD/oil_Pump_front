import 'package:flutter/material.dart';
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
          content: Column(
            children: [
              Text('This is the modal content.'),
            ],
          ),
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
                ),
                DataColumn(
                  label: const Text('الاسم'),
                ),
                DataColumn(
                  label: const Text('المبلغ'),
                ),
                DataColumn(
                  label: const Text('الحالة'),
                ),
                DataColumn(
                  label: const Text('التعليق'),
                ),
                DataColumn(
                  label: const Text('التاريخ'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ExampleSource extends AdvancedDataTableSource<Daily> {
  String lastSearchTerm = '';
  bool isSelected = false;

  final data = List<Daily>.generate(
      13, (index) => Daily(ID: "ID", name: "شركة نبتة للبترول", amount: "1798500", status: "دائن", comment: "لصالح شركة نبتة", date: "7-5-2023"));

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
  int get selectedRowCount => 0;

  void filterServerSide(String filterQuery) {
    lastSearchTerm = filterQuery.toLowerCase().trim();
    setNextView();
  }

  @override
  Future<RemoteDataSourceDetails<Daily>> getNextPage(
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

