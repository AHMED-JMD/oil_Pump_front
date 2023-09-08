import 'package:flutter/material.dart';
import 'package:OilEnergy_System/API/reading.dart';
import 'package:OilEnergy_System/SharedService.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:OilEnergy_System/models/reading_data.dart';


class ReadingTable extends StatefulWidget {
  int total;
  List readings;
  ReadingTable({Key? key, required this.total, required this.readings}) : super(key: key);

  @override
  State<ReadingTable> createState() => _ReadingTableState(total: total, readings: readings);
}

class _ReadingTableState extends State<ReadingTable> {
  int total;
  List readings;
  _ReadingTableState({required this.total, required this.readings});

  var rowsPerPage = 10;
  var sortIndex = 0;
  var sortAsc = true;
  late final source = ExampleSource(daily_data: readings);
  final _searchController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _searchController.text = '';
  }

  //server side Functions ------------------
  //------delete--
  Future deleteReading() async {
    setState(() {
      isLoading = true;
    });
    //send to server
    if(selectedIds.length != 0){
      final auth = await SharedServices.LoginDetails();
      API_Reading.Delete(selectedIds, auth.token).then((response){
        setState(() {
          isLoading = false;
        });
        print(response);
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
      // await Future.delayed(Duration(milliseconds: 600));
      // Navigator.pushReplacementNamed(context, '/dailys');
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
            title: Text('حذف القراءة'),
            content: Text('هل انت متأكد برغبتك في حذف القراءة'),
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
                          deleteReading();
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
                if(constraints.maxWidth > 700){
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
                        ],
                      )
                    ],
                  );
                }else{
                  return Column(
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
                        ],
                      ),
                      SizedBox(height: 20,)
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
                    label: const Text('اسم المكنة'),
                    onSort: setSort
                ),
                DataColumn(
                    label: const Text('القراءة السابقة'),
                    onSort: setSort
                ),
                DataColumn(
                    label: const Text('القراءة الجديدة'),
                    onSort: setSort
                ),
                DataColumn(
                    label: const Text('عدد اللترات'),
                    onSort: setSort
                ),
                DataColumn(
                    label: const Text('المبلغ'),
                    onSort: setSort
                ),
              ],
            ),
            SizedBox(height: 12,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(' مجموع القراءات ',
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
class ExampleSource extends AdvancedDataTableSource<Reading> {
  List daily_data;
  ExampleSource({ required this.daily_data});

  String lastSearchTerm = '';

  @override
  DataRow? getRow(int index) {
    final currentRowData = lastDetails!.rows[index];
    return DataRow(
        selected: selectedIds.contains(currentRowData.readingId),
        onSelectChanged: (selected) {
          if(selected != null){
            selectedRow(currentRowData.readingId, selected);
          }
        },
        cells: [
          DataCell(
            Text(currentRowData.pump_name),
          ),
          DataCell(
            Text(currentRowData.fReading.toString()),
          ),
          DataCell(
            Text(currentRowData.lastReading.toString()),
          ),
          DataCell(
            Text(currentRowData.amount.toString()),
          ),
          DataCell(
              Text(currentRowData.value.toString())
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
  Future<RemoteDataSourceDetails<Reading>> getNextPage(
      NextPageRequest pageRequest) async {
    //--------------get request to server -----------
    await Future.delayed(Duration(milliseconds: 700));
    return RemoteDataSourceDetails(
      daily_data.length,
      (daily_data as List<dynamic>)
          .map((json) => Reading.fromJson(json))
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