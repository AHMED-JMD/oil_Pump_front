import 'package:OilEnergy_System/API/pump.dart';
import 'package:flutter/material.dart';
import 'package:OilEnergy_System/API/gas.dart';
import 'package:OilEnergy_System/SharedService.dart';
import 'package:OilEnergy_System/models/gas_data.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class GasolineTable extends StatefulWidget {
  final List data;
  GasolineTable({Key? key, required this.data}) : super(key: key);

  @override
  State<GasolineTable> createState() => _GasolineTableState(data: data);
}

class _GasolineTableState extends State<GasolineTable> {
  List data;
  _GasolineTableState({required this.data});

  var rowsPerPage = 10;
  late final source = ExampleSource(data: data);
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final _searchController = TextEditingController();

  bool isLoading = false;
  List pumps = [];


  @override
  void initState() {
    super.initState();
    getAllPumps();
    _searchController.text = '';
  }
  //server side Functions ------------------
  //-------get pumps-
  Future getAllPumps() async{
    setState(() {
      isLoading = true;
    });

    //call server
    final auth = await SharedServices.LoginDetails();
    final response = await API_Pump.GetAllPump(auth.token);

    setState(() {
      isLoading = false;
      pumps = response['pumps'];
    });
  }
  //------delete--
  Future deleteGas() async {
    setState(() {
      isLoading = true;
    });
    //send to server
    if(selectedIds.length != 0){
      final auth = await SharedServices.LoginDetails();
      API_Gas.Delete_Gas(selectedIds, auth.token).then((response) async {
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
          Navigator.pushReplacementNamed(context, '/gasolines');
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
          content: Text('الرجاء اختيار يومية من الجدول', textAlign: TextAlign.center, style: TextStyle(fontSize: 17),),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  //---gas returned
  Future returnedGas (datas) async {
    setState(() {
      isLoading = true;
    });

    //post to server
    final auth = await SharedServices.LoginDetails();
    final response = await API_Gas.Return_Gas(datas, auth.token);

    if(response != false){
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم اضافة الراجع بنجاح', textAlign: TextAlign.center, style: TextStyle(fontSize: 17, color: Colors.white),),
          backgroundColor: Colors.green,
        ),
      );
      await Future.delayed(Duration(milliseconds: 600));
      Navigator.pushReplacementNamed(context, '/gasolines');
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
//-------------------------------------

  //delete modal
  void _deleteModal(BuildContext context){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text('حذف حالة الوقود'),
            content: Text('هل انت متأكد برغبتك في حذف يومية الوقود'),
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
                          deleteGas();
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
//open modal
  void _EditGas(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: SimpleDialog(
            title: Text('راجع البئر'),
            children:[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: FormBuilder(
                  key: _formKey,
                  child: Column(
                    children: [
                      FormBuilderDropdown(
                          name: 'fuel_type',
                          decoration: InputDecoration(labelText: 'نوع الوقود'),
                          validator: FormBuilderValidators.required(errorText: 'الرجاء ادخال جميع الحقول'),
                          items: ['بنزين', 'جازولين',]
                              .map((value) =>
                              DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              )).toList()
                      ),
                      FormBuilderDropdown(
                        name: 'pump_name',
                        decoration: InputDecoration(labelText: 'اسم العداد'),
                        items: pumps
                            .map((pump) => DropdownMenuItem(
                            value: pump['name'].toString(),
                            child: Text('${pump['name']}')
                        )).toList(),
                      ),
                      FormBuilderTextField(
                        name: 'amount',
                        decoration: InputDecoration(labelText: 'الكمية باللتر'),
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
                                  data['fuel_type'] = _formKey.currentState!.value['fuel_type'];
                                  data['pump_name'] = _formKey.currentState!.value['pump_name'];
                                  data['amount'] = _formKey.currentState!.value['amount'];
                                  data['date'] = _formKey.currentState!.value['date'].toIso8601String();

                                  //server
                                  returnedGas(data);
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
          children: [
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints ){
                if(constraints.maxWidth > 700){
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                              onPressed: (){
                                _EditGas(context);
                              },
                              child: Text('وقود راجع')
                          ),
                          SizedBox(width: 5,),
                          TextButton.icon(
                            onPressed: (){
                              _deleteModal(context);
                            } ,
                            icon: Icon(Icons.delete),
                            label: Text(''),
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
                          ElevatedButton(
                              onPressed: (){
                                _EditGas(context);
                              },
                              child: Text('وقود راجع')
                          ),
                          SizedBox(width: 5,),
                          TextButton.icon(
                            onPressed: (){
                              _deleteModal(context);
                            } ,
                            icon: Icon(Icons.delete),
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
                  label: const Text('النوع'),
                ),
                DataColumn(
                  label: const Text('الحالة'),
                ),
                DataColumn(
                  label: const Text('الكمية'),
                ),
                DataColumn(
                  label: const Text('التعليق'),
                ),
                DataColumn(
                  label: const Text('التاريخ'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ExampleSource extends AdvancedDataTableSource<Gas> {
  List data;
  ExampleSource({required this.data});

  String lastSearchTerm = '';

  @override
  DataRow? getRow(int index) {
    final currentRowData = lastDetails!.rows[index];
    return DataRow(
        selected: selectedIds.contains(currentRowData.gasId),
        onSelectChanged: (selected) {
          if(selected != null){
            selectedRow(currentRowData.gasId, selected);
          }
        },
        cells: [
      DataCell(
        Text(currentRowData.fuelType,
          style: TextStyle(
            fontWeight: FontWeight.w900,
          color: currentRowData.status == 'تفريغ' ?Colors.green : Colors.red,
        ),
        )
      ),
      DataCell(
        Text(currentRowData.status,
          style: TextStyle(
            color: currentRowData.status == 'تفريغ' ?Colors.green : Colors.red,
          ),
        ),
      ),
      DataCell(
        Text(currentRowData.total.toString(),
          style: TextStyle(
            color: currentRowData.status == 'تفريغ' ?Colors.green : Colors.red,
          ),
        ),
      ),
          DataCell(
            Text(currentRowData.comment.toString(),
              style: TextStyle(
                color: currentRowData.status == 'تفريغ' ?Colors.green : Colors.red,
              ),),
          ),
      DataCell(
        Text(currentRowData.date,
          style: TextStyle(
            color: currentRowData.status == 'تفريغ' ?Colors.green : Colors.red,
          ),),
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
  Future<RemoteDataSourceDetails<Gas>> getNextPage(
      NextPageRequest pageRequest) async {

      await Future.delayed(Duration(seconds: 1));
      return RemoteDataSourceDetails(
        data.length,
        (data as List<dynamic>)
            .map((json) => Gas.fromJson(json))
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

