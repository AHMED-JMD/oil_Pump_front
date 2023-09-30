import 'package:OilEnergy_System/components/Print.dart';
import 'package:flutter/material.dart';
import 'package:OilEnergy_System/API/client.dart';
import 'package:OilEnergy_System/SharedService.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:OilEnergy_System/models/client_data.dart';
import 'package:OilEnergy_System/widgets/ClientsDetails.dart';


class ClientsTable extends StatefulWidget {
  // late void Function(int) setPage;
  final List clients;
  ClientsTable({Key? key, required this.clients}) : super(key: key);

  @override
  State<ClientsTable> createState() => _ClientsTableState(clients: clients);
}

class _ClientsTableState extends State<ClientsTable> {
  List clients;
  _ClientsTableState({required this.clients});

  bool isLoading = false;
  var rowsPerPage = 10;
  List filteredClients = [];
  final _searchController = TextEditingController();
  late final source = ExampleSource(context: context, clients: clients, filtered: filteredClients);
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    _searchController.text = '';
  }

  //server ---- function to delete employee
  Future deleteClient() async{
    setState(() {
      isLoading = true;
    });

    //send response to server
    if(selectedIds.length != 0) {
      final auth = await SharedServices.LoginDetails();
      API_Client.Delete_Client(selectedIds, auth.token).then((response) async{
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
          Navigator.pushReplacementNamed(context, '/clients');
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
  //update clients
  Future updateClient(data) async{
    setState(() {
      isLoading = true;
    });

    //send response to server
    final auth = await SharedServices.LoginDetails();
    final response = await API_Client.EditClient(data, auth.token);

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
      Navigator.pushReplacementNamed(context, '/clients');
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
  Future findClient(name) async{
    setState(() {
      isLoading = true;
    });

    //send response to server
    Map data = {};
    data['name'] = name;

    final auth = await SharedServices.LoginDetails();
    final response = await API_Client.FindClient(data, auth.token);

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
                        deleteClient();
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
            title: Text('معاملة نقدية'),
            children:[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: FormBuilder(
                 key: _formKey,
                 child: Column(
                  children: [
                    FormBuilderDropdown(
                        name: 'emp_id',
                        decoration: InputDecoration(labelText: 'اختر العميل'),
                        validator: FormBuilderValidators.required(errorText: 'الرجاء ادخال جميع الحقول'),
                        items: clients
                        .map((client) =>
                            DropdownMenuItem(
                              value: client['emp_id'],
                              child: Text('${client['name']}'),
                            )).toList()
                        ),
                    FormBuilderDropdown(
                        name: 'edit_type',
                        decoration: InputDecoration(labelText: 'نوع التعديل'),
                        validator: FormBuilderValidators.required(errorText: 'الرجاء ادخال جميع الحقول'),
                        items: ['ايراد', 'خصم',]
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
                    FormBuilderTextField(
                      name: 'comment',
                      decoration: InputDecoration(
                          labelText: 'التعليق',
                          suffixIcon: Icon(Icons.comment, color: Colors.blueAccent,)
                      ),
                      initialValue: 'نقدا',
                      validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
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
                                data['emp_id'] = _formKey.currentState!.value['emp_id'];
                                data['edit_type'] = _formKey.currentState!.value['edit_type'];
                                data['amount'] = _formKey.currentState!.value['amount'];
                                data['date'] = _formKey.currentState!.value['date'].toIso8601String();
                                data['comment'] = _formKey.currentState!.value['comment'];

                                //server
                                updateClient(data);
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
                                ElevatedButton(
                                    onPressed: (){
                                      Navigator.pushNamed(context, '/add_daily');
                                    },
                                    child: Text('معاملة وقود')
                                ),
                                SizedBox(width: 10,),
                              ElevatedButton(
                                  onPressed: (){
                                    _EditAccount(context);
                                  },
                                  child: Text('معاملة نقدية')
                              ),
                              SizedBox(width: 5,),
                              ElevatedButton(
                                  onPressed: (){
                                    Navigator.pushNamed(context, '/add_client');
                                  } ,
                                  child: Text('+ اضافة عميل')
                              ),
                                SizedBox(width: 13,),
                                ElevatedButton(
                                    onPressed: (){
                                      PrintPage();
                                    },
                                    style : ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey[500]
                                    ),
                                    child: Text('طباعة')
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
                                    _EditAccount(context);
                                  },
                                  child: Text('تعديل حساب')
                              ),
                              SizedBox(width: 5,),
                              ElevatedButton(
                                  onPressed: (){
                                    Navigator.pushNamed(context, '/add_employee');
                                  } ,
                                  child: Text('+ اضافة عميل')
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
                        label: const Text('رقم الهاتق'),
                        numeric: true,
                      ),
                      DataColumn(
                        label: const Text('وقود بنزين'),
                      ),
                      DataColumn(
                        label: const Text('وقود جازولين'),
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
      );
  }
}

class ExampleSource extends AdvancedDataTableSource<Clients> {
  final BuildContext context;
  List clients;
  List filtered;
  ExampleSource({required this.context, required this.clients, required this.filtered});

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
        Text('${currentRowData.benz_amount.toString()} لتر'),
      ),
      DataCell(
        Text('${currentRowData.gas_amount.toString()} لتر'),
      ),
          DataCell(
            Text(currentRowData.account.toString()),
          ),
          DataCell(
            Center(
              child: InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => ClientDetails(emp_id: currentRowData.empId,))
                    );
                  },
                  child: Icon(Icons.remove_red_eye, color: Colors.grey[500],size: 25,)
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

print(filtered);
      await Future.delayed(Duration(milliseconds: 300));
      return RemoteDataSourceDetails(
        clients.length,
        (clients as List<dynamic>)
            .map((json) => Clients.fromJson(json))
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