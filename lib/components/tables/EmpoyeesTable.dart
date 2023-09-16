import 'package:OilEnergy_System/API/employee.dart';
import 'package:OilEnergy_System/models/employe_data.dart';
import 'package:OilEnergy_System/widgets/EmployeDetails.dart';
import 'package:flutter/material.dart';
import 'package:OilEnergy_System/SharedService.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';


class EmployeeTable extends StatefulWidget {
  // late void Function(int) setPage;
  final List employees;
  EmployeeTable({Key? key, required this.employees}) : super(key: key);

  @override
  State<EmployeeTable> createState() => _EmployeeTableState(employees: employees);
}

class _EmployeeTableState extends State<EmployeeTable> {
  List employees;
  _EmployeeTableState({required this.employees});

  bool isLoading = false;
  var rowsPerPage = 10;
  List filteredClients = [];
  final _searchController = TextEditingController();
  late final source = ExampleSource(context: context, employees: employees, filtered: filteredClients);
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    _searchController.text = '';
  }

  //server ---- function to delete employee
  Future deleteEmp() async{
    setState(() {
      isLoading = true;
    });

    //send response to server
    if(selectedIds.length != 0) {
      final auth = await SharedServices.LoginDetails();
      API_Emp.Delete_Emp(selectedIds, auth.token).then((response) async{
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
          Navigator.pushReplacementNamed(context, '/employees');
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
    } else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('الرجاء اختيار موظف من الجدول', textAlign: TextAlign.center, style: TextStyle(fontSize: 17),),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  //new month function
  Future new_month() async{
    setState(() {
      isLoading = true;
    });

    //send response to server
      final auth = await SharedServices.LoginDetails();
      final response = await API_Emp.New_month(auth.token);
        setState(() {
          isLoading = false;
        });
        if(response == true){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('بداية شهر جديد بنجاح', textAlign: TextAlign.center, style: TextStyle(fontSize: 17),),
              backgroundColor: Colors.green,
            ),
          );
          await Future.delayed(Duration(milliseconds: 400));
          Navigator.pushReplacementNamed(context, '/employees');
        }else{
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$response', textAlign: TextAlign.center, style: TextStyle(fontSize: 17),),
              backgroundColor: Colors.red,
            ),
          );
          selectedIds = [];
        }
  }
  //update clients
  Future updateEmp(data) async{
    setState(() {
      isLoading = true;
    });

    //send response to server
    final auth = await SharedServices.LoginDetails();
    final response = await API_Emp.EditEmp(data, auth.token);
    if(response != false){
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم التعديل بنجاح', textAlign: TextAlign.center, style: TextStyle(fontSize: 17, color: Colors.white),),
          backgroundColor: Colors.green,
        ),
      );
      await Future.delayed(Duration(milliseconds: 600));
      Navigator.pushReplacementNamed(context, '/employees');
    }else{
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$response', textAlign: TextAlign.center, style: TextStyle(fontSize: 17, color: Colors.white),),
          backgroundColor: Colors.red,
        ),
      );
    }

  }
  //find client
  Future findEmp(name) async{
    setState(() {
      isLoading = true;
    });

    //send response to server
    Map data = {};
    data['name'] = name;

    final auth = await SharedServices.LoginDetails();
    final response = await API_Emp.FindEmp(data, auth.token);

    if(response != false){
      setState(() {
        isLoading = false;
        filteredClients = response;
      });
    }else{
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('لايوجد عميل بهدا الاسم', textAlign: TextAlign.center, style: TextStyle(fontSize: 17, color: Colors.white),),
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
                        deleteEmp();
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
  void _EditAccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: SimpleDialog(
            title: Text('تعديل المرتب'),
            children:[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: FormBuilder(
                  key: _formKey,
                  child: Column(
                    children: [
                      FormBuilderDropdown(
                          name: 'id',
                          decoration: InputDecoration(labelText: 'اختر الموظف'),
                          validator: FormBuilderValidators.required(errorText: 'الرجاء ادخال جميع الحقول'),
                          items: employees
                              .map((client) =>
                              DropdownMenuItem(
                                value: client['id'],
                                child: Text('${client['name']}'),
                              )).toList()
                      ),
                      FormBuilderTextField(
                        name: 'amount',
                        decoration: InputDecoration(labelText: 'المبلغ'),
                        validator: FormBuilderValidators.required(errorText: 'الرجاء ادخال جميع الحقول'),
                      ),
                      FormBuilderDateTimePicker(
                        name: 'date',
                        decoration: InputDecoration(
                            labelText: 'التاريخ',
                            suffixIcon: Icon(Icons.calendar_month, color: Colors.blueAccent,)
                        ),
                        validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                        initialDate: DateTime.now(),
                        inputType: InputType.date,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0, top: 30),
                        child: Center(
                          child: SizedBox(
                            height: 30,
                            width: 70,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                primary: Colors.white,
                              ),
                              child: Text('خصم'),
                              onPressed: (){
                                if(_formKey.currentState!.saveAndValidate()){
                                  Map data = {};
                                  data['id'] = _formKey.currentState!.value['id'];
                                  data['amount'] = _formKey.currentState!.value['amount'];
                                  data['date'] = _formKey.currentState!.value['date'].toIso8601String();

                                  //server
                                  updateEmp(data);
                                  Navigator.of(context).pop();
                                }

                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  //New Month modat
  void New_month(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text('شهر جديد !!'),
            content: Text('هل انت متأكد من رغبتك في تفعيل بداية الشهر '),
            actions: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Center(
                  child: SizedBox(
                    height: 30,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.green,
                        primary: Colors.white,
                      ),
                      child: Text('تفعيل'),
                      onPressed: (){
                        new_month();
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


  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints ){
                if(constraints.maxWidth > 700){
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(width: 5,),
                      TextButton.icon(
                        onPressed: (){
                          deleteModal(context);
                        } ,
                        icon: Icon(Icons.delete),
                        label: Text(''),
                      ),
                      SizedBox(width: 10,),
                      ElevatedButton(
                          onPressed: (){
                            New_month(context);
                          },
                          child: Text('شهر جديد')
                      ),
                      SizedBox(width: 10,),
                      ElevatedButton(
                          onPressed: (){
                            _EditAccount(context);
                          },
                          child: Text('خصم المرتب')
                      ),
                      SizedBox(width: 5,),
                      ElevatedButton(
                          onPressed: (){
                            Navigator.pushNamed(context, '/add_employes');
                          } ,
                          child: Text('+ اضافة موظف')
                      ),
                    ],
                  );
                }else{
                  return Column(
                    children: [
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
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
                                New_month(context);
                              },
                              child: Text('شهر جديد')
                          ),
                          SizedBox(width: 10,),
                          ElevatedButton(
                              onPressed: (){
                                _EditAccount(context);
                              },
                              child: Text('خصم المرتب')
                          ),
                          SizedBox(width: 5,),
                          ElevatedButton(
                              onPressed: (){
                                Navigator.pushNamed(context, '/add_employes');
                              },
                              child: Text('+ اضافة موظف')
                          ),
                        ],
                      ),
                      SizedBox(height: 20,)
                    ],
                  );
                }
              },
            ),
            SizedBox(height: 20,),
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
                  label: const Text('رقم الهاتف'),
                  numeric: true,
                ),
                DataColumn(
                  label: const Text('المرتب'),
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

class ExampleSource extends AdvancedDataTableSource<Employee> {
  final BuildContext context;
  List employees;
  List filtered;
  ExampleSource({required this.context, required this.employees, required this.filtered});

  String lastSearchTerm = '';

  @override
  DataRow? getRow(int index) {
    final currentRowData = lastDetails!.rows[index];
    return DataRow(
        selected: selectedIds.contains(currentRowData.id.toString()),
        onSelectChanged: (selected) {
          if(selected != null){
            selectedRow(currentRowData.id.toString(), selected);
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
            Text(currentRowData.salary.toString()),
          ),
          DataCell(
            InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => EmployeeDetail(id: currentRowData.id.toString(),))
                    );
                  },
                  child: Icon(Icons.remove_red_eye, color: Colors.grey[500],size: 25,)
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

    await Future.delayed(Duration(milliseconds: 700));
    return RemoteDataSourceDetails(
      employees.length,
      (employees as List<dynamic>)
          .map((json) => Employee.fromJson(json))
          .skip(pageRequest.offset)
          .take(pageRequest.pageSize)
          .toList(),
      filteredRows: filtered.length != 0
          ? (filtered as List<dynamic>).length
          : null,
    );
    //---------------------//------------------------
  }
}

//selected list here
List<String> selectedIds = [];