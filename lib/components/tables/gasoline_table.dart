import 'package:flutter/material.dart';
import 'package:oil_pump_system/API/gas.dart';
import 'package:oil_pump_system/SharedService.dart';
import 'package:oil_pump_system/models/gas_data.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:advanced_datatable/advanced_datatable_source.dart';

class GasolineTable extends StatefulWidget {
  List data;
  GasolineTable({Key? key, required this.data}) : super(key: key);

  @override
  State<GasolineTable> createState() => _GasolineTableState(data: data);
}

class _GasolineTableState extends State<GasolineTable> {
  List data;
  _GasolineTableState({required this.data});

  var rowsPerPage = 5;
  late final source = ExampleSource(data: data);
  final _searchController = TextEditingController();

  bool isLoading = false;


  @override
  void initState() {
    super.initState();
    _searchController.text = '';
  }
  //server side Functions ------------------
  //------delete--
  Future deleteGas() async {
    setState(() {
      isLoading = true;
    });
    //send to server
    if(selectedIds.length != 0){
      final auth = await SharedServices.LoginDetails();
      API_Gas.Delete_Gas(selectedIds, auth.token).then((response){
        setState(() {
          isLoading = false;
        });

        if(response == true){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('تم الحذف بنجاح', textAlign: TextAlign.center, style: TextStyle(fontSize: 17),),
              backgroundColor: Colors.red,
            ),
          );
          selectedIds = [];
        }else{
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$response', textAlign: TextAlign.center, style: TextStyle(fontSize: 17),),
              backgroundColor: Colors.red,
            ),
          );
          selectedIds = [];
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
//-------------------------------------

  //delete modal
  void _deleteModal(BuildContext context){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text('حذف حالة الوقود'),
            content: Text('هل انت متأكد برغبتك في حذف يومية الوقود'),
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
                          deleteGas();
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
                    SizedBox(width: 5,),
                    TextButton.icon(
                      onPressed: (){
                        _deleteModal(context);
                      } ,
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

class ExampleSource extends AdvancedDataTableSource<Gas> {
  List data;
  ExampleSource({required this.data});

  String lastSearchTerm = '';

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
            fontWeight: FontWeight.w900,
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
            Text(currentRowData.comment.toString(),
              style: TextStyle(
                color: currentRowData.status == 'داخل' ?Colors.green : Colors.red,
              ),),
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
  }
}
//selected list goes here
List<String> selectedIds = [];

