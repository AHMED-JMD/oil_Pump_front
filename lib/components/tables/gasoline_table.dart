import 'package:flutter/material.dart';
import 'package:oil_pump_system/models/gas_data.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:advanced_datatable/advanced_datatable_source.dart';

class GasolineTable extends StatefulWidget {
  GasolineTable({Key? key}) : super(key: key);

  @override
  State<GasolineTable> createState() => _GasolineTableState();
}

class _GasolineTableState extends State<GasolineTable> {
  var rowsPerPage = 5;
  final source = ExampleSource();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.text = '';
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
                      onPressed: (){} ,
                      icon: Icon(Icons.delete),
                      label: Text(''),
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
                  label: const Text('النوع'),
                ),
                DataColumn(
                  label: const Text('استهلاك المكنة'),
                ),
                DataColumn(
                  label: const Text('استهلاك المعاملات'),
                ),
                DataColumn(
                  label: const Text('الكمية المتوفرة'),
                ),
                DataColumn(
                  label: const Text('تعليق'),
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

class ExampleSource extends AdvancedDataTableSource<Gas> {
  String lastSearchTerm = '';
  bool isSelected = false;

  final data = List<Gas>.generate(
      13, (index) =>  Gas(ID: "ID", type: "جاز", d_gas: "5230 لبر", trans_gas: "15000 لتر", total: "22370 لتر",comment: "تعليق جديد", date: "5-7-2023"));

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
        Text(currentRowData.type),
      ),
      DataCell(
        Text(currentRowData.d_gas),
      ),
      DataCell(
        Text(currentRowData.trans_gas),
      ),
      DataCell(
        Text(currentRowData.total),
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
  Future<RemoteDataSourceDetails<Gas>> getNextPage(
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

