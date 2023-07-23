import 'package:flutter/material.dart';
import 'package:oil_pump_system/API/daily.dart';
import 'package:oil_pump_system/SharedService.dart';
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
  //selected list here
  List<String> selectedIds = [];

  var rowsPerPage = 5;
  final source = ExampleSource();
  var sortIndex = 0;
  var sortAsc = true;
  final _searchController = TextEditingController();
  bool isLoading = false;
  List data = [];

  @override
  void initState() {
    super.initState();
    _searchController.text = '';
  }

  //server side Functions ------------------
  //------delete--
  Future deleteDaily() async {
    setState(() {
      isLoading = true;
    });

    //send to server
    print(selectedIds);
    if(selectedIds.length != 0){
      final auth = await SharedServices.LoginDetails();
      API_Daily.Delete_Daily(selectedIds, auth.token).then((response){
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
//-------------------------------------------

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
                          Navigator.pushReplacementNamed(context, '/reports');
                        } ,
                        child: Text('المنصرفات')
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

//class of data models and Rows
class ExampleSource extends AdvancedDataTableSource<Daily> {
  String lastSearchTerm = '';

  @override
  DataRow? getRow(int index) {
    final currentRowData = lastDetails!.rows[index];
    return DataRow(
        selected: select.selectedIds.contains(currentRowData.tranId),
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
  int get selectedRowCount => select.selectedIds.length;

  void selectedRow(String id, bool newSelectState) {
    if (select.selectedIds.contains(id)) {
      select.selectedIds.remove(id);
    } else {
      select.selectedIds.add(id);
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
    final auth = await SharedServices.LoginDetails();

    Map<String,String> requestHeaders = {
      'Content-Type' : 'application/json',
      'x-auth-token' : '${auth.token}'
    };

    Response response = await get(url, headers: requestHeaders);
    if(response.statusCode == 200){
      final data = jsonDecode(response.body);

      await Future.delayed(Duration(milliseconds: 700));
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
_DailyTableState select = _DailyTableState();