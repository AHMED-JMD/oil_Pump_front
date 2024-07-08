import 'package:OilEnergy_System/components/MoneyFormatter.dart';
import 'package:flutter/material.dart';
import 'package:OilEnergy_System/API/reciept.dart';
import 'package:OilEnergy_System/SharedService.dart';
import 'package:OilEnergy_System/models/income_data.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:advanced_datatable/advanced_datatable_source.dart';

import 'package:OilEnergy_System/widgets/receiptDetails.dart';

class IncomeTable extends StatefulWidget {
  IncomeTable({Key? key,}) : super(key: key);

  @override
  State<IncomeTable> createState() => _IncomeTableState();
}

class _IncomeTableState extends State<IncomeTable> {
  var rowsPerPage = 10;
  bool isLoading = false;
  final _searchController = TextEditingController();
  List data = [];

  late var source = ExampleSource(context: context, data: data);
  DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();
    GetAll();
    _searchController.text = '';
  }

  Future GetAll() async {
    setState(() {
      isLoading = true;
    });

    //send to server
    final auth = await SharedServices.LoginDetails();
    final response = await API_Reciept.GetAll(auth.token);

    if(response != false){
      setState(() {
        isLoading = false;
        data = response;
      });
    }
  }
  Future Search(datas) async {
    setState(() {
      isLoading = true;
      data = [];
      source = ExampleSource(context: context, data: []);
    });

    //send to server
    final auth = await SharedServices.LoginDetails();
    final response = await API_Reciept.Search(auth.token, datas);

    if(response != false){
      setState(() {
        isLoading = false;
        data = response;
        source = ExampleSource(context: context, data: response);
      });
    }
  }

  //modal open
  void _openModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text('حذف الايصال'),
            content: Text('هل انت متأكد برغبتك في حذف الايصال.'),
            actions: [
              Center(
                child: SizedBox(
                  height: 30,
                  width: 100,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red
                    ),
                    child: Text('حذف', style: TextStyle(color: Colors.white),),
                    onPressed: (){
                      deleteReciept();
                      Navigator.of(context).pop();
                    }
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  //function to delete from server
  Future deleteReciept ()async {
    setState(() {
      isLoading = true;
    });
    if(selectedIds.length != 0){
      //call server
      final auth = await SharedServices.LoginDetails();
      API_Reciept.Delete_Reciept(selectedIds, auth.token).then((response) async{
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
          await Future.delayed(Duration(milliseconds: 600));
          Navigator.pushReplacementNamed(context, '/incomes');
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
          content: Text('الرجاء اختيار ايصال من الجدول', textAlign: TextAlign.center, style: TextStyle(fontSize: 17),),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String numCheck (int number) {
    if(number < 10){
      return '0$number';
    }else{
      return '$number';
    }
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
                          SizedBox(width: 40,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                width: 130,
                                child: DropdownButtonFormField(
                                    decoration: InputDecoration(
                                        labelText: 'الفترة',
                                        suffixIcon: Icon(Icons.date_range_outlined, color: Colors.blue,),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        )
                                    ),
                                    items: [
                                      DropdownMenuItem(child: Text('شهر'), value: 'month',),
                                      DropdownMenuItem(child: Text('اسبوع'), value: 'week',),
                                      DropdownMenuItem(child: Text('يوم'), value: 'day',),
                                    ],
                                    onChanged: (val){
                                      if(val == 'month'){
                                        //custom start date to get data from beginning of the month till now
                                        String startDate = '${now.year}-${numCheck(now.month)}-01';
                                        String endDate = '${now.year}-${numCheck(now.month)}-${numCheck(now.day)}';
                                        //call server
                                        Map thedata = {};
                                        thedata['start_date'] = startDate;
                                        thedata['end_date'] = endDate;
                                        // call server
                                        Search(thedata);

                                      } else if(val == 'week'){
                                        //custom start date for week
                                        DateTime startDate = now.subtract(Duration(days: 7));
                                        //call server
                                        Map thedata = {};
                                        thedata['start_date'] = startDate.toIso8601String();
                                        thedata['end_date'] = now.toIso8601String();
                                        // call server
                                        Search(thedata);
                                      }else {
                                        //call server
                                        Map thedata = {};
                                        thedata['start_date'] = now.toIso8601String();
                                        thedata['end_date'] = now.toIso8601String();
                                        // call server
                                        Search(thedata);
                                      }
                                    }
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: (){
                              _openModal(context);
                            } ,
                            icon: Icon(Icons.delete, color: Colors.redAccent,),
                            tooltip: 'جذف الايصال',
                          ),
                          SizedBox(width: 5,),
                          ElevatedButton.icon(
                              onPressed: (){
                                Navigator.pushReplacementNamed(context, '/add_reciept');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue
                              ),
                              icon: Icon(Icons.add, color: Colors.white,),
                              label: Text('ايصال جديد', style: TextStyle(color: Colors.white),)
                          ),
                          SizedBox(width: 5,),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                width: 130,
                                child: DropdownButtonFormField(
                                    decoration: InputDecoration(
                                        labelText: 'الفترة',
                                        suffixIcon: Icon(Icons.date_range_outlined, color: Colors.blue,),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        )
                                    ),
                                    items: [
                                      DropdownMenuItem(child: Text('شهر'), value: 'month',),
                                      DropdownMenuItem(child: Text('اسبوع'), value: 'week',),
                                      DropdownMenuItem(child: Text('يوم'), value: 'day',),
                                    ],
                                    onChanged: (val){
                                      if(val == 'month'){
                                        //custom start date to get data from beginning of the month till now
                                        String startDate = '${now.year}-${numCheck(now.month)}-01';
                                        String endDate = '${now.year}-${numCheck(now.month)}-${numCheck(now.day)}';
                                        //call server
                                        Map thedata = {};
                                        thedata['start_date'] = startDate;
                                        thedata['end_date'] = endDate;
                                        // call server
                                        Search(thedata);

                                      } else if(val == 'week'){
                                        //custom start date for week
                                        DateTime startDate = now.subtract(Duration(days: 7));
                                        //call server
                                        Map thedata = {};
                                        thedata['start_date'] = startDate.toIso8601String();
                                        thedata['end_date'] = now.toIso8601String();
                                        // call server
                                        Search(thedata);

                                      }else {
                                        //call server
                                        Map thedata = {};
                                        thedata['start_date'] = now.toIso8601String();
                                        thedata['end_date'] = now.toIso8601String();
                                        // call server
                                        Search(thedata);

                                      }
                                    }
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: (){
                              _openModal(context);
                            } ,
                            icon: Icon(Icons.delete, color: Colors.redAccent),
                          ),
                          SizedBox(width: 5,),
                          ElevatedButton.icon(
                              onPressed: (){
                                Navigator.pushReplacementNamed(context, '/add_reciept');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue
                              ),
                              icon: Icon(Icons.add,),
                              label: Text('ايصال جديد', style: TextStyle(color: Colors.white),)
                          ),
                          SizedBox(width: 5,),
                        ],
                      ),
                      SizedBox(height: 20,)
                    ],
                  );
                }
              },
            ),
            data.length !=0 ?
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
                  label: const Text('اسم الشركة'),
                ),
                DataColumn(
                  label: const Text('نوع الوقود'),
                ),
                DataColumn(
                  label: const Text('الكمية'),
                ),
                DataColumn(
                  label: const Text('العجز'),
                ),
                DataColumn(
                  label: const Text('تاريخ الوصول'),
                ),
                DataColumn(
                  label: const Text('عرض/ تعديل'),
                ),

              ],
            ) : Center(
                child: CircularProgressIndicator()
            ),
          ],
        ),
      ),
    );
  }
}

class ExampleSource extends AdvancedDataTableSource<Receipt> {
  String lastSearchTerm = '';
  final BuildContext context;
  final List data;
  ExampleSource({required this.context, required this.data});

  @override
  DataRow? getRow(int index) {
    final currentRowData = lastDetails!.rows[index];
    return DataRow(
        selected: selectedIds.contains(currentRowData.recieptId),
        onSelectChanged: (selected) {
          if(selected != null){
            selectedRow(currentRowData.recieptId, selected);
          }
        },
        cells: [
      DataCell(
        Text(currentRowData.company),
      ),
      DataCell(
        Text(currentRowData.fuelType),
      ),
      DataCell(
        Text("${myFormat(currentRowData.amount)}", style: TextStyle(fontWeight: FontWeight.w800)),
      ),
          DataCell(
            Text(currentRowData.shortage.toString()),
          ),
          DataCell(
            Text(currentRowData.arrive_date),
          ),
          DataCell(
            Center(
              child: InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => ReceiptDetails(reciept_id: currentRowData.recieptId,) ));
                  },
                  child: Icon(Icons.remove_red_eye,)
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
  Future<RemoteDataSourceDetails<Receipt>> getNextPage(
      NextPageRequest pageRequest) async {
    //--------------get request to server -----------
    return RemoteDataSourceDetails(
      data.length,
      (data as List<dynamic>)
          .map((json) => Receipt.fromJson(json))
          .skip(pageRequest.offset)
          .take(pageRequest.pageSize)
          .toList(),
      filteredRows: lastSearchTerm.isNotEmpty
          ? (data as List<dynamic>).length
          : null,
    );
  }
}
//selected ids
List<String> selectedIds = [];
