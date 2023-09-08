import 'package:flutter/material.dart';
import 'package:OilEnergy_System/API/daily.dart';
import 'package:OilEnergy_System/SharedService.dart';
import 'package:OilEnergy_System/models/daily_data.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:advanced_datatable/advanced_datatable_source.dart';


class DailyTable extends StatefulWidget {
  int total;
  List daily_data;
  DailyTable({Key? key, required this.total, required this.daily_data}) : super(key: key);

  @override
  State<DailyTable> createState() => _DailyTableState(total: total, daily_data: daily_data);
}

class _DailyTableState extends State<DailyTable> {
   int total;
   List daily_data;
  _DailyTableState({required this.total, required this.daily_data});

  var rowsPerPage = 10;
  var sortIndex = 0;
  var sortAsc = true;
  late final source = ExampleSource(daily_data: daily_data);
  final _searchController = TextEditingController();
  bool isLoading = false;

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
    if(selectedIds.length != 0){
      final auth = await SharedServices.LoginDetails();
      API_Daily.Delete_Trans(selectedIds, auth.token).then((response){
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
      await Future.delayed(Duration(milliseconds: 600));
      Navigator.pushReplacementNamed(context, '/dailys');
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
            content: Text('هل انت متأكد برغبتك في حذف اليومية'),
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
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints ){
                if (constraints.maxWidth > 700) {
                  return Row(
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
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.blue,
                            ),
                            label: Text(''),
                          ),
                          SizedBox(width: 3,),
                          ElevatedButton(
                              onPressed: (){
                                Navigator.pushNamed(context, '/add_daily');
                              } ,
                              child: Text('معاملة جديدة')
                          ),
                          SizedBox(width: 5,),
                        ],
                      )
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 300,
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
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton.icon(
                            onPressed: (){
                              _deleteModal(context);
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.blue,
                            ),
                            label: Text(''),
                          ),
                          SizedBox(width: 3,),
                          ElevatedButton(
                              onPressed: (){
                                Navigator.pushNamed(context, '/add_daily');
                              } ,
                              child: Text('معاملة جديدة')
                          ),
                          SizedBox(width: 5,),
                        ],
                      ),
                      SizedBox(height: 20,),
                    ],
                  );
                }
              },

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
                    label: const Text('الوقود باللتر'),
                    onSort: setSort
                ),
                DataColumn(
                  label: const Text('نوع الوقود'),
                    onSort: setSort
                ),
                DataColumn(
                  label: const Text('التاريخ'),
                ),
              ],
            ),
            SizedBox(height: 12,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('مجموع المعاملات و الديون',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 21
                  ),
                ),
                Text('$total',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 21,
                      color: Colors.red
                  ),
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
  List daily_data;
  ExampleSource({ required this.daily_data});

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
            Text(currentRowData.gas_amount.toString()),
          ),
          DataCell(
        Text(currentRowData.gas_type),
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
    //--------------get request to server -----------
      await Future.delayed(Duration(milliseconds: 700));
      return RemoteDataSourceDetails(
        daily_data.length,
        (daily_data as List<dynamic>)
            .map((json) => Daily.fromJson(json))
            .skip(pageRequest.offset)
            .take(pageRequest.pageSize)
            .toList(),
        filteredRows: lastSearchTerm.isNotEmpty
            ? (daily_data as List<dynamic>).length
            : null,
      );


  }
}
//selected list here
List<String> selectedIds = [];