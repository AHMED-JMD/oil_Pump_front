import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:oil_pump_system/SharedService.dart';
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
                    SizedBox(width: 5,),
                    TextButton.icon(
                      onPressed: (){} ,
                      icon: Icon(Icons.delete),
                      label: Text(''),
                    ),
                    SizedBox(width: 3,),
                    ElevatedButton(
                        onPressed: (){
                          Navigator.pushReplacementNamed(context, '/add_machine');
                        } ,
                        child: Text('اضافة مكنة')
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
                  label: const Text('النوع'),
                ),
                DataColumn(
                  label: const Text('الحالة'),
                ),
                DataColumn(
                  label: const Text('الكمية'),
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
  List<String> selectedIds = [];

  @override
  DataRow? getRow(int index) {
    final currentRowData = lastDetails!.rows[index];
    return DataRow(
        selected: selectedIds.contains(currentRowData.gasId),
        onSelectChanged: (selected) {
          if(selected != null){
            selectedRow(currentRowData.gasId, selected);
          }
        },
        cells: [
      DataCell(
        Text(currentRowData.fuelType,
          style: TextStyle(
          color: currentRowData.status == 'داخل' ?Colors.green : Colors.red,
        ),
        )
      ),
      DataCell(
        Text(currentRowData.status,
          style: TextStyle(
            color: currentRowData.status == 'داخل' ?Colors.green : Colors.red,
          ),
        ),
      ),
      DataCell(
        Text(currentRowData.total.toString(),
          style: TextStyle(
            color: currentRowData.status == 'داخل' ?Colors.green : Colors.red,
          ),
        ),
      ),
      DataCell(
        Text(currentRowData.date,
          style: TextStyle(
            color: currentRowData.status == 'داخل' ?Colors.green : Colors.red,
          ),),
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
  Future<RemoteDataSourceDetails<Gas>> getNextPage(
      NextPageRequest pageRequest) async {
    //--------------get request to server -----------
    final url = Uri.parse('http://localhost:5000/gas/');
    final auth = await SharedServices.LoginDetails();

    Map<String,String> requestHeaders = {
      'Content-Type' : 'application/json',
      'x-auth-token' : '${auth.token}'
    };

    Response response = await get(url, headers:  requestHeaders);

    if(response.statusCode == 200){
      final data = jsonDecode(response.body);

      await Future.delayed(Duration(seconds: 1));
      return RemoteDataSourceDetails(
        data.length,
        (data as List<dynamic>)
            .map((json) => Gas.fromJson(json))
            .skip(pageRequest.offset)
            .take(pageRequest.pageSize)
            .toList(),
        filteredRows: lastSearchTerm.isNotEmpty
            ? (data as List<dynamic>).length
            : null, //again in a real world example you would only get the right amount of rows
      );
    }else{
      throw Exception('Unable to query remote server');
    }

  }
}

