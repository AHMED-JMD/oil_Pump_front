import 'package:flutter/material.dart';
import 'package:OilEnergy_System/API/daily.dart';
import 'package:OilEnergy_System/SharedService.dart';
import 'package:OilEnergy_System/API/client.dart';
import 'package:OilEnergy_System/components/appBar.dart';
import 'package:OilEnergy_System/components/side_bar.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:sidebarx/sidebarx.dart';

class TransDetails extends StatefulWidget {
  final String tran_id;
  TransDetails({Key? key, required this.tran_id}) : super(key: key);

  @override
  State<TransDetails> createState() => _TransDetailsState(tran_id: tran_id);
}

class _TransDetailsState extends State<TransDetails> {
  final String tran_id;
  _TransDetailsState({required this.tran_id});

  SidebarXController controller = SidebarXController(selectedIndex: 0, extended: true);

  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  bool isLoading = false;
  List clients = [];
  Map data = {};

  @override
  void initState() {
    super.initState();
    getById();
    GetClients();
  }

  @override
  void dispose() {
    super.dispose();
  }
//server side functions
  //on submit form
  Future _OnSubmit(data) async {
    setState(() {
      isLoading = true;
    });

    //call backend
    final auth = await SharedServices.LoginDetails();

    API_Daily.UpdateTrans(data, auth.token).then((response){
      setState(() {
        isLoading = false;
      });
      if(response == true){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تم تحديث الايصال بنجاح', textAlign: TextAlign.center, style: TextStyle(fontSize: 17),),
            backgroundColor: Colors.green,
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
    });
    //set state
    getById();
  }
  //get clients data
  Future GetClients() async {
    setState(() {
      isLoading = true;
    });

    //get data
    final auth = await SharedServices.LoginDetails();
    final response = await API_Client.getClients(auth.token);

    setState(() {
      clients = response;
    });
  }
  //server side function
  Future getById() async {
    setState(() {
      isLoading = true;
      data = {};
    });

    //send to server
    var datas = {};
    datas['tran_id'] = tran_id;
    final auth = await SharedServices.LoginDetails();
    final response = await API_Daily.Get_byId(datas, auth.token);

    if(response != false){
      setState(() {
        isLoading = false;
        data = response;
      });
    }else{
      setState(() {
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: APPBAR(context),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: Row(
            children: [
              Row(
                children: [
                  Navbar(controller: controller,)
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    child: data.isNotEmpty ? Padding(
                        padding: const EdgeInsets.all(50.0),
                        child: FormBuilder(
                          // Define the form key to identify the form
                          key: _formKey,
                          // Define the form fields
                          child: Column(
                            children: [
                              CircleAvatar(
                                child: Icon(Icons.edit_calendar_outlined),
                                radius: 50,
                                backgroundColor: Colors.grey.shade300,
                              ),
                              // Add a text field
                              FormBuilderDropdown(
                                name: 'name',
                                decoration: InputDecoration(labelText: 'اختر العميل'),
                                initialValue: data['name'].toString(),
                                items: clients
                                    .map((client) => DropdownMenuItem(
                                    value: client['name'].toString(),
                                    child: Text('${client['name']}')
                                )).toList(),
                                validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                              ),
                              FormBuilderDropdown(
                                name: 'type',
                                decoration: InputDecoration(labelText: 'الحالة'),
                                validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                                initialValue: data['type'].toString(),
                                items: ['عليه','له']
                                    .map((type) => DropdownMenuItem(
                                  value: type,
                                  child: Text('$type'),
                                ))
                                    .toList(),
                              ),
                              FormBuilderDropdown(
                                name: 'gas_type',
                                decoration: InputDecoration(labelText: 'نوع الوقود'),
                                validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                                initialValue: data['gas_type'].toString(),
                                items: ['بنزين', 'جازولين', 'none']
                                    .map((type) => DropdownMenuItem(
                                  value: type,
                                  child: Text('$type'),
                                ))
                                    .toList(),
                              ),
                              data['gas_type'] == 'none'?
                              FormBuilderTextField(
                                name: 'amount',
                                decoration: InputDecoration(
                                    labelText: 'المبلغ',
                                    suffixIcon: Icon(Icons.gas_meter, color: Colors.blueAccent,)
                                ),
                                initialValue: data['amount'].toString(),
                              ):
                              Column(
                                children: [
                                  FormBuilderTextField(
                                    name: 'gas_amount',
                                    decoration: InputDecoration(
                                        labelText: 'كمية الوقود باللتر',
                                        suffixIcon: Icon(Icons.gas_meter, color: Colors.blueAccent,)
                                    ),
                                    initialValue: data['gas_amount'].toString(),
                                  ),
                                  FormBuilderTextField(
                                    name: 'price',
                                    decoration: InputDecoration(
                                        labelText: 'سعر اللتر',
                                        suffixIcon: Icon(Icons.gas_meter, color: Colors.blueAccent,)
                                    ),
                                  ),
                                ],
                              ),

                              FormBuilderDateTimePicker(
                                name: 'date',
                                decoration: InputDecoration(
                                    labelText: 'التاريخ',
                                    suffixIcon: Icon(Icons.calendar_month, color: Colors.blueAccent,)
                                ),
                                validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                                initialValue: DateTime.parse(data['date']),
                                initialDate: DateTime.now(),
                                inputType: InputType.date,
                              ),
                              FormBuilderTextField(
                                name: 'comment',
                                decoration: InputDecoration(
                                    labelText: 'البيان',
                                    suffixIcon: Icon(Icons.comment, color: Colors.blueAccent,)
                                ),
                                initialValue: data['comment'].toString(),
                                validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                              ), // Add another text field
                              SizedBox(height: 40,),
                              // Add a submit button
                              SizedBox(
                                width: 300,
                                height: 50,
                                child: ElevatedButton(
                                  child: Text('ارسال'),
                                  style: ElevatedButton.styleFrom(
                                      textStyle: TextStyle(fontSize: 18)
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState!.saveAndValidate()) {
                                      //call to backend
                                      var nw_date = _formKey.currentState!.value['date'];
                                      Map data = {};
                                      data['tran_id'] = tran_id;
                                      data['name'] = _formKey.currentState!.value['name'];
                                      data['type'] = _formKey.currentState!.value['type'];
                                      data['gas_type'] = _formKey.currentState!.value['gas_type'];
                                      data['gas_amount'] = _formKey.currentState!.value['gas_amount'];
                                      data['amount'] = _formKey.currentState!.value['amount'];
                                      data['price'] = _formKey.currentState!.value['price'];
                                      data['date'] = nw_date!.toIso8601String();
                                      data['comment'] = _formKey.currentState!.value['comment'];

                                      //------
                                      _OnSubmit(data);
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                    ): Center(child: Text('loading data...')),
                  ),
                ),
              )
            ],
          ),
        )
    );
  }
}
