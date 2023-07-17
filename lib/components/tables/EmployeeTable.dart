import 'package:flutter/material.dart';
import 'package:oil_pump_system/API/employee.dart';
import 'package:oil_pump_system/models/employee_data.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:http/http.dart';
import 'dart:convert';

class EmployeeTable extends StatefulWidget {
  // late void Function(int) setPage;
  EmployeeTable({Key? key,}) : super(key: key);

  @override
  State<EmployeeTable> createState() => _EmployeeTableState();
}

class _EmployeeTableState extends State<EmployeeTable> {
  bool isLoading = false;
  var rowsPerPage = 5;
  final source = ExampleSource();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.text = '';
  }

  //function to delete employee
  Future<void> deleteEmploye() async{
    setState(() {
      isLoading = true;
    });


    if(selectedIds.length != 0) {
      // Set<List<String>> emp_id = {selectedIds};

      API_Emp.Delete_Emp(selectedIds).then((response){
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
        return ;
      });
    } else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('الرجاء اختيار موظف من الجدول', textAlign: TextAlign.center, style: TextStyle(fontSize: 17),),
          backgroundColor: Colors.red,
        ),
      );
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
            title: Text('حذف الموظفين'),
            content: Text('هل انت متأكد من رغبتك في حذف الموظفين'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Center(
                  child: SizedBox(
                    height: 30,
                    child: TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          primary: Colors.white,
                      ),
                      child: Text('حذف'),
                      onPressed: (){
                        deleteEmploye();
                        Navigator.of(context).pop();
                      },
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

  //refresher for refreshing page
  Future _refresher () async {
    setState(() {
      rowsPerPage = 6;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  RefreshIndicator(
      onRefresh: _refresher,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                              _openModal(context);
                            } ,
                            icon: Icon(Icons.delete),
                            label: Text(''),
                        ),
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
                RefreshIndicator(
                  onRefresh: deleteEmploye,
                    child: AdvancedPaginatedDataTable(
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
                      ),
                      DataColumn(
                        label: const Text('الرقم الوطني'),
                      ),
                      DataColumn(
                        label: const Text('رقم الهاتق'),
                        numeric: true,
                      ),
                      DataColumn(
                        label: const Text('السكن'),
                      ),
                      DataColumn(
                        label: const Text('الراتب'),
                      ),
                      DataColumn(
                        label: const Text('تعليق'),
                      ),
                      DataColumn(
                        label: const Text('عرض/ تعديل'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ),
    );
  }
}

class ExampleSource extends AdvancedDataTableSource<Employee> {
  String lastSearchTerm = '';

  @override
  DataRow? getRow(int index) {
    final currentRowData = lastDetails!.rows[index];
    return DataRow(
        selected: selectedIds.contains(currentRowData.empId),
        onSelectChanged: (selected) {
          if(selected != null){
            selectedRow(currentRowData.empId, selected);
          }
        },
        cells: [
      DataCell(
        Text(currentRowData.name),
      ),
      DataCell(
        Text(currentRowData.Ssn),
      ),
      DataCell(
        Text(currentRowData.phoneNum.toString()),
      ),
      DataCell(
        Text(currentRowData.address),
      ),
      DataCell(
        Text(currentRowData.salary),
      ),
          DataCell(
            Text(currentRowData.comment),
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
  Future<RemoteDataSourceDetails<Employee>> getNextPage(
      NextPageRequest pageRequest) async {
    //--------------get request to server -----------
    final url = Uri.parse('http://localhost:5000/employees/');
    Map<String,String> requestHeaders = {
      'Content-Type' : 'application/json',
      'x-auth-token' : 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImMyNGQ2ZTMwLTE5NzAtMTFlZS05MTczLWZiMjA5ZjI2YWQyMyIsImlhdCI6MTY4ODM2ODMxNH0.FuZln5gldCx3LWd_ylaxHDyiwt0oSId_98MvrKfCvOA'
    };
    Response response = await get(url, headers: requestHeaders);
    if(response.statusCode == 200){
      final _data = jsonDecode(response.body);

      await Future.delayed(Duration(seconds: 1));
      return RemoteDataSourceDetails(
        _data.length,
        (_data as List<dynamic>)
            .map((json) => Employee.fromJson(json))
            .skip(pageRequest.offset)
            .take(pageRequest.pageSize)
            .toList(),
        filteredRows: lastSearchTerm.isNotEmpty
            ? (_data as List<dynamic>).length
            : null,
      );
    } else{
      throw Exception('Unable to query remote server');
    }
    //---------------------//------------------------
  }
}

//selected list here
List<String> selectedIds = [];