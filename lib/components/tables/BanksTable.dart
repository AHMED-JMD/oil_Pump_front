import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:OilEnergy_System/API/banks.dart';
import 'package:OilEnergy_System/SharedService.dart';
import 'package:OilEnergy_System/models/banks_data.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:OilEnergy_System/widgets/banksDetails.dart';

class BanksTable extends StatefulWidget {
  List data;
  BanksTable({Key? key, required this.data}) : super(key: key);

  @override
  State<BanksTable> createState() => _BanksTableState(data: data);
}

class _BanksTableState extends State<BanksTable> {
  List data;
  _BanksTableState({required this.data});

  GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  var rowsPerPage = 5;
  late final source = ExampleSource(data: data, context: context);
  final _searchController = TextEditingController();

  bool isLoading = false;


  @override
  void initState() {
    super.initState();
    _searchController.text = '';
  }
  //server side Functions ------------------
  //------delete--
  Future deleteBank() async {
    setState(() {
      isLoading = true;
    });
    //send to server
    if(selectedIds.length != 0){
      final auth = await SharedServices.LoginDetails();
      API_Bank.Delete_Bank(selectedIds, auth.token).then((response) async{
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
          Navigator.pushReplacementNamed(context, '/banks');
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
          content: Text('الرجاء اختيار بنك من الجدول', textAlign: TextAlign.center, style: TextStyle(fontSize: 17),),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  //------add--
  Future addBank(data) async {
    setState(() {
      isLoading = true;
    });
    //send to server
    final auth = await SharedServices.LoginDetails();
    final response = await API_Bank.Add_Banks(data, auth.token);

    setState(() {
      isLoading = false;
    });

    response != false ?
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم اضافة البنك بنجاح', textAlign: TextAlign.center, style: TextStyle(fontSize: 17),),
        backgroundColor: Colors.green,
      ),
    ) :
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$response', textAlign: TextAlign.center, style: TextStyle(fontSize: 17),),
          backgroundColor: Colors.red,
      ),
    );
    await Future.delayed(Duration(milliseconds: 300));
    Navigator.pushReplacementNamed(context, '/banks');

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
            title: Text('حذف البنك'),
            content: Text('هل انت متأكد برغبتك في حذف حساب'),
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
                          deleteBank();
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

  void _addBankModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: SimpleDialog(
            title: Text('منصرف جديد'),
            children:[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: FormBuilder(
                  key: _formKey,
                  child: Column(
                    children: [
                      FormBuilderTextField(
                        name: 'bank_name',
                        decoration: InputDecoration(labelText: 'اسم البنك'),
                        validator: FormBuilderValidators.required(errorText: 'الرجاء ادخال جميع الحقول'),
                      ),
                      FormBuilderTextField(
                        name: 'amount',
                        decoration: InputDecoration(labelText: 'اجمالي الحساب'),
                        validator: FormBuilderValidators.required(errorText: 'الرجاء ادخال جميع الحقول'),
                      ),
                      FormBuilderDateTimePicker(
                        name: 'date',
                        decoration: InputDecoration(labelText: "التاريخ"),
                        validator: FormBuilderValidators.required(errorText: 'الرجاء ادخال جميع الحقول'),
                        inputType: InputType.date,
                        initialValue: DateTime.now(),
                      ),
                      SizedBox(height: 20,),
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
                              child: Text('اضافة'),
                              onPressed: (){
                                if(_formKey.currentState!.saveAndValidate()){
                                  //send to server ---
                                  final date = _formKey.currentState!.value['date'];
                                  final amount = _formKey.currentState!.value['amount'];
                                  final bank_name = _formKey.currentState!.value['bank_name'];

                                  final data = {};
                                  data['bank_name'] = bank_name;
                                  data['amount'] = amount;
                                  data['date'] = date.toIso8601String();

                                  addBank(data);
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
//--------------------------------------------------------

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
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(width: 5,),
                          TextButton.icon(
                            onPressed: (){
                              _deleteModal(context);
                            } ,
                            icon: Icon(Icons.delete),
                            label: Text(''),
                          ),
                          ElevatedButton.icon(
                            onPressed: (){
                              _addBankModal(context);
                            } ,
                            icon: Icon(Icons.add),
                            label: Text('حساب بنك جديد'),
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
                              _deleteModal(context);
                            } ,
                            icon: Icon(Icons.delete),
                            label: Text(''),
                          ),
                          ElevatedButton.icon(
                            onPressed: (){
                              _addBankModal(context);
                            } ,
                            icon: Icon(Icons.add),
                            label: Text('حساب بنك جديد'),
                          ),
                        ],
                      ),
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
                  label: const Text('اسم البنك'),
                ),
                DataColumn(
                  label: const Text('المبلغ الكلي'),
                ),
                DataColumn(
                  label: const Text('التاريخ'),
                ),
                DataColumn(
                  label: const Text('تعديل'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ExampleSource extends AdvancedDataTableSource<Banks> {
  List data;
  BuildContext context;
  ExampleSource({required this.data, required this.context});

  String lastSearchTerm = '';

  @override
  DataRow? getRow(int index) {
    final currentRowData = lastDetails!.rows[index];
    return DataRow(
        selected: selectedIds.contains(currentRowData.banks_id),
        onSelectChanged: (selected) {
          if(selected != null){
            selectedRow(currentRowData.banks_id, selected);
          }
        },
        cells: [
          DataCell(
              Text(currentRowData.bank_name,)
          ),
          DataCell(
            Text(currentRowData.amount.toString(),),
          ),
          DataCell(
            Text(currentRowData.date,),
          ),
          DataCell(
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => BanksDetails(banks_id: currentRowData.banks_id)));
              },
              child: Icon(Icons.remove_red_eye, color:  Colors.grey.shade500,),
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
  Future<RemoteDataSourceDetails<Banks>> getNextPage(
      NextPageRequest pageRequest) async {

    await Future.delayed(Duration(seconds: 1));
    return RemoteDataSourceDetails(
      data.length,
      (data as List<dynamic>)
          .map((json) => Banks.fromJson(json))
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

