import 'package:flutter/material.dart';
import 'package:oil_pump_system/API/employee.dart';
import 'package:oil_pump_system/SharedService.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:oil_pump_system/models/employee_data.dart';


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
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    _searchController.text = '';
  }

  //server ---- function to delete employee
  Future<void> deleteEmploye() async{
    setState(() {
      isLoading = true;
    });


    if(selectedIds.length != 0) {
      final auth = await SharedServices.LoginDetails();
      API_Emp.Delete_Emp(selectedIds, auth.token).then((response){
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

  //delete open
  void deleteModal(BuildContext context) {
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
  //open modal
  void _openModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: SimpleDialog(
            title: Text('خصم الراتب'),
            children:[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: FormBuilder(
                 key: _formKey,
                 child: Column(
                  children: [
                    FormBuilderDropdown(
                        name: 'employee',
                        decoration: InputDecoration(labelText: 'اختر الموظف'),
                        validator: FormBuilderValidators.required(errorText: 'الرجاء ادخال جميع الحقول'),
                        items: ['items', 'item2', 'item3']
                        .map((value) =>
                            DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            )).toList()
                        ),
                    FormBuilderTextField(
                        name: 'amount',
                        decoration: InputDecoration(labelText: 'المبلغ'),
                        validator: FormBuilderValidators.required(errorText: 'الرجاء ادخال جميع الحقول'),
                    )
                  ],
                ),
            ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Center(
                  child: SizedBox(
                    height: 30,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        primary: Colors.white,
                      ),
                      child: Text('خصم'),
                      onPressed: (){
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
                              deleteModal(context);
                            } ,
                            icon: Icon(Icons.delete),
                            label: Text(''),
                        ),
                        ElevatedButton(
                            onPressed: (){
                              _openModal(context);
                            },
                            child: Text('خصم حساب')
                        ),
                        SizedBox(width: 5,),
                        ElevatedButton(
                            onPressed: (){
                              Navigator.pushNamed(context, '/add_employee');
                            } ,
                            child: Text('+ اضافة عميل')
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
                        label: const Text('الاسم'),
                      ),
                      DataColumn(
                        label: const Text('رقم الهاتق'),
                        numeric: true,
                      ),
                      DataColumn(
                        label: const Text('السكن'),
                      ),
                      DataColumn(
                        label: const Text('تعليق'),
                      ),
                      DataColumn(
                        label: const Text('الحساب'),
                      ),
                      DataColumn(
                        label: const Text('عرض/ تعديل'),
                      ),
                    ],
                  ),
              ],
            ),
          ),
      ),
    );
  }
}

class ExampleSource extends AdvancedDataTableSource<Clients> {
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
        Text(currentRowData.phoneNum.toString()),
      ),
      DataCell(
        Text(currentRowData.address),
      ),
      DataCell(
        Text(currentRowData.comment.toString()),
      ),
          DataCell(
            Text(currentRowData.account.toString()),
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
  Future<RemoteDataSourceDetails<Clients>> getNextPage(
      NextPageRequest pageRequest) async {
    //--------------get request to server -----------
    final url = Uri.parse('http://localhost:5000/clients/');
    final auth = await SharedServices.LoginDetails();
    Map<String,String> requestHeaders = {
      'Content-Type' : 'application/json',
      'x-auth-token' : '${auth.token}'
    };
    Response response = await get(url, headers: requestHeaders);
    if(response.statusCode == 200){
      final _data = jsonDecode(response.body);

      await Future.delayed(Duration(milliseconds: 700));
      return RemoteDataSourceDetails(
        _data.length,
        (_data as List<dynamic>)
            .map((json) => Clients.fromJson(json))
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