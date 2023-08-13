import 'package:flutter/material.dart';
import 'package:oil_pump_system/API/reciept.dart';
import 'package:oil_pump_system/SharedService.dart';
import 'package:oil_pump_system/models/income_data.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:http/http.dart';
import 'dart:convert';

import 'package:oil_pump_system/widgets/receiptDetails.dart';

class IncomeTable extends StatefulWidget {
  IncomeTable({Key? key}) : super(key: key);

  @override
  State<IncomeTable> createState() => _IncomeTableState();
}

class _IncomeTableState extends State<IncomeTable> {
  var rowsPerPage = 5;
  bool isLoading = false;
  final _searchController = TextEditingController();
  var source;

  @override
  void initState() {
    super.initState();
    _searchController.text = '';
    setState(() {
      source = ExampleSource(context: context);
    });
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
                  child: TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Colors.red
                    ),
                    child: Text('حذف'),
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
      API_Reciept.Delete_Reciept(selectedIds, auth.token).then((response){
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
          content: Text('الرجاء اختيار ايصال من الجدول', textAlign: TextAlign.center, style: TextStyle(fontSize: 17),),
          backgroundColor: Colors.red,
        ),
      );
    }
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
                        onPressed: (){
                          Navigator.pushReplacementNamed(context, '/add_reciept');
                        } ,
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
                  label: const Text('مصدر الوقود'),
                ),
                DataColumn(
                  label: const Text('اسم الشركة'),
                ),
                DataColumn(
                  label: const Text('اسم السائق'),
                ),
                DataColumn(
                  label: const Text('نوع الوقود'),
                ),
                DataColumn(
                  label: const Text('الكمية'),
                ),
                DataColumn(
                  label: const Text('تاريخ الوصول'),
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
}

class ExampleSource extends AdvancedDataTableSource<Receipt> {
  String lastSearchTerm = '';
  final BuildContext context;
  ExampleSource({required this.context});

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
        Text(currentRowData.source),
      ),
      DataCell(
        Text(currentRowData.company),
      ),
      DataCell(
        Text(currentRowData.driver),
      ),
      DataCell(
        Text(currentRowData.fuelType),
      ),
      DataCell(
        Text(currentRowData.amount.toString()),
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
                  child: Icon(Icons.remove_red_eye, color: Colors.grey[500],)
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
    final url = Uri.parse('http://localhost:5000/reciept/');
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
            .map((json) => Receipt.fromJson(json))
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
//selected ids
List<String> selectedIds = [];
