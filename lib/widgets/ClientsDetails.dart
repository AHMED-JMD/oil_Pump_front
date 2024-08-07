import 'package:OilEnergy_System/API/transaction.dart';
import 'package:OilEnergy_System/components/printing/client_trans.dart';
import 'package:flutter/material.dart';
import 'package:OilEnergy_System/API/client.dart';
import 'package:OilEnergy_System/SharedService.dart';
import 'package:OilEnergy_System/components/appBar.dart';
import 'package:OilEnergy_System/components/side_bar.dart';
import 'package:OilEnergy_System/components/tables/clientDetailsTable.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:sidebarx/sidebarx.dart';

class ClientDetails extends StatefulWidget {
  final String emp_id;
  ClientDetails({super.key, required this.emp_id});

  @override
  State<ClientDetails> createState() => _ClientDetailsState(emp_id: emp_id);
}

class _ClientDetailsState extends State<ClientDetails> {
  final String emp_id;
  _ClientDetailsState({required this.emp_id});

  SidebarXController controller = SidebarXController(selectedIndex: 4, extended: true);
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> _SecondKey = GlobalKey<FormBuilderState>();


  bool isLoading = false;
  Map client = {};
  List trans = [];

  @override
  void initState() {
    super.initState();
    getClient();
  }

  //function to get the client and his transactions
  Future getClient () async {
    setState(() {
      isLoading = true;
    });
    //send to server
    final auth = await SharedServices.LoginDetails();
    Map data = {};
    data['emp_id'] = emp_id;
    final response = await API_Client.getOneClients(data, auth.token);

    setState(() {
      isLoading = false;
      client = response;
      trans = response['transactions'];
    });
  }
  //function to find transaction
  Future _OnSubmit(datas) async {
    setState(() {
      isLoading = true;
    });

    //send to server
    final auth = await SharedServices.LoginDetails();
    final response = await API_Trans.client_Trans(datas, auth.token);

    if(response != false){
      setState(() {
        isLoading = false;
        trans = response;
      });
    }
  }
  //handle update data
  Future _UpdateClient(data) async {
    setState(() {
      isLoading = true;
    });

    //send to server
    final auth = await SharedServices.LoginDetails();
    final response = await API_Client.UpdateCLient(data, auth.token);
    print(response);
    if(response != false){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم التعديل بنجاح بنجاح', textAlign: TextAlign.center, style: TextStyle(fontSize: 17),),
          backgroundColor: Colors.green,
        ),
      );
      setState(() {
        client = {};
      });
      //call get emp again
      getClient();
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: APPBAR(context),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          children: [
            Navbar(controller: controller),
            Expanded(
              child: ListView(
                children:[
                  Column(
                    children: [
                      client.isNotEmpty ?
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: FormBuilder(
                          key: _SecondKey,
                          child: Container(
                            width: MediaQuery.of(context).size.width/1.3,
                            height: 475,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.grey[300]
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text('البيانات الاساسية', style: TextStyle(fontSize: 22),),
                                    Container(
                                        // width: 300,
                                        // height: 400,
                                        child: PrintClient(client: client, client_trans: trans)
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                        height:70,
                                        width: 300,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Center(
                                          child: FormBuilderTextField(
                                            name: 'name',
                                            decoration: InputDecoration(labelText: 'الاسم'),
                                            initialValue: client['name']!= null ? client['name'].toString() : '',
                                          ),
                                        )
                                    ),
                                    Container(
                                      height:70,
                                      width: 300,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12)
                                      ),
                                      child: Center(
                                        child: FormBuilderTextField(
                                          name: 'address',
                                          decoration: InputDecoration(labelText: 'العنوان'),
                                          initialValue: client['address']!= null ? client['address'].toString(): '',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      height:70,
                                      width: 280,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12)
                                      ),
                                      child: Center(
                                        child: FormBuilderTextField(
                                          name: 'phoneNum',
                                          decoration: InputDecoration(labelText: 'رقم الهاتف'),
                                          initialValue: client['phoneNum'] != null ? '0${client['phoneNum']}': '',
                                        ),
                                      ),
                                    ),

                                    Container(
                                      height:70,
                                      width: 300,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12)
                                      ),
                                      child: Center(
                                          child: FormBuilderTextField(
                                            name: 'account',
                                            decoration: InputDecoration(
                                                labelText: 'الحساب الحالي',
                                                filled: true,
                                                fillColor: Colors.lightBlue
                                            ),
                                            initialValue: client['account'] != null ? client['account'].toString(): '',
                                          )
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      height:70,
                                      width: 280,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12)
                                      ),
                                      child: Center(
                                        child: FormBuilderTextField(
                                          name: 'benz_amount',
                                          decoration: InputDecoration(
                                              labelText: 'البنزين باللتر',
                                              filled: true,
                                              fillColor: Colors.redAccent
                                          ),
                                          initialValue: client['benz_amount'] != null ? client['benz_amount'].toString(): '',
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height:70,
                                      width: 300,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12)
                                      ),
                                      child: Center(
                                          child: FormBuilderTextField(
                                            name: 'gas_amount',
                                            decoration: InputDecoration(
                                              labelText: 'الجاز باللتر',
                                              filled: true,
                                              fillColor: Colors.greenAccent
                                            ),
                                            initialValue: client['gas_amount'] != null ? client['gas_amount'].toString(): '',
                                          )
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      height:70,
                                      width: 450,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12)
                                      ),
                                      child: Center(
                                          child: FormBuilderTextField(
                                            name: 'comment',
                                            decoration: InputDecoration(labelText: 'التعليق'),
                                            initialValue: client['comment'] != null ?client['comment'].toString() : '',
                                          )
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20,),
                                ElevatedButton(
                                    onPressed: (){
                                      if(_SecondKey.currentState!.saveAndValidate()){
                                        final data = {};
                                        data['emp_id'] = client['emp_id'];
                                        data['name'] = _SecondKey.currentState!.value['name'];
                                        data['address'] = _SecondKey.currentState!.value['address'];
                                        data['phoneNum'] = _SecondKey.currentState!.value['phoneNum'];
                                        data['account'] = _SecondKey.currentState!.value['account'];
                                        data['benz_amount'] = _SecondKey.currentState!.value['benz_amount'];
                                        data['gas_amount'] = _SecondKey.currentState!.value['gas_amount'];
                                        data['comment'] = _SecondKey.currentState!.value['comment'];
                                        //call server
                                        _UpdateClient(data);
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        minimumSize: Size(200, 40),
                                        backgroundColor: Colors.blue
                                    ),
                                    child: Text('تحديث', style: TextStyle(color: Colors.white),)
                                )
                              ],
                            ),
                          ),
                        ),
                      ): Text(''),
                    SizedBox(height: 50,),
                    trans.length != 0 ?Row(
                      children: [
                        Expanded(
                            child: Container(
                                color: Colors.grey[100],
                                child: Column(
                                  children: [
                                    FormBuilder(
                                        key: _formKey,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 8.0, right: 20),
                                                  child: Row(
                                                    children: [
                                                      Text('من : ', style: TextStyle(fontSize: 17),),
                                                      SizedBox(width: 10,),
                                                      Container(
                                                        width: MediaQuery.of(context).size.width/7,
                                                        child: FormBuilderDateTimePicker(
                                                          name: "start_date",
                                                          onChanged: (value){},
                                                          decoration: InputDecoration(
                                                            labelText: "اختر اليوم",
                                                            suffixIcon: Icon(Icons.calendar_month, color: Colors.blue,)
                                                          ),
                                                          validator: FormBuilderValidators.required(errorText: "الرجاء اختيار تاريخ محدد"),
                                                          initialDate: DateTime.now(),
                                                          inputType: InputType.date,
                                                        ),
                                                      ),
                                                      SizedBox(width: 10,),
                                                      Text('الى : ', style: TextStyle(fontSize: 17),),
                                                      SizedBox(width: 10,),
                                                      Container(
                                                        width: MediaQuery.of(context).size.width/7,
                                                        child: FormBuilderDateTimePicker(
                                                          name: "end_date",
                                                          onChanged: (value){},
                                                          decoration: InputDecoration(
                                                              labelText: "اختر اليوم",
                                                              suffixIcon: Icon(Icons.calendar_month, color: Colors.blue,)
                                                          ),
                                                          validator: FormBuilderValidators.required(errorText: "الرجاء اختيار تاريخ محدد"),
                                                          initialDate: DateTime.now(),
                                                          inputType: InputType.date,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(width: 10,),
                                                // Add a submit button
                                                TextButton.icon(
                                                  onPressed: (){
                                                    if(_formKey.currentState!.saveAndValidate()){
                                                      //send to server
                                                      Map datas = {};
                                                      datas['start_date'] = _formKey.currentState!.value['start_date'].toIso8601String();
                                                      datas['end_date'] = _formKey.currentState!.value['end_date'].toIso8601String();
                                                      datas['emp_id'] = emp_id;

                                                      _OnSubmit(datas);
                                                      setState(() {
                                                        trans = [];
                                                      });
                                                    }
                                                  },
                                                  style: TextButton.styleFrom(
                                                    minimumSize: Size(50, 50)
                                                  ),
                                                  icon: Icon(Icons.search, size: 30,),
                                                  label: Text('بحث'),
                                                ),
                                                SizedBox(width: 20,),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 8.0),
                                                  child: TextButton.icon(
                                                    onPressed: () {
                                                      getClient();
                                                      setState(() {
                                                        trans = [];
                                                      });
                                                    },
                                                    style: TextButton.styleFrom(
                                                        backgroundColor: Colors.grey[300],
                                                        minimumSize: Size(70, 50)
                                                    ),
                                                    label: Text('الكل', style: TextStyle(color: Colors.black, fontSize: 17),),
                                                    icon: const Icon(Icons.person_search_outlined, size: 30, color: Colors.red,),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                    ),
                                    ClientDetailsTable(data: trans),
                                  ],
                                )
                            )
                        ),
                      ],
                    ) : Column(
                      children: [
                        FormBuilder(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0, right: 20),
                                      child: Container(
                                        width: MediaQuery.of(context).size.width/3.2,
                                        child: FormBuilderDateTimePicker(
                                          name: "date",
                                          onChanged: (value){},
                                          decoration: InputDecoration(
                                            labelText: "اختر اليوم",
                                          ),
                                          validator: FormBuilderValidators.required(errorText: "الرجاء اختيار تاريخ محدد"),
                                          initialDate: DateTime.now(),
                                          inputType: InputType.date,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10,),
                                    // Add a submit button
                                    IconButton(
                                      onPressed: (){
                                        if(_formKey.currentState!.saveAndValidate()){
                                          //send to server
                                          Map datas = {};
                                          datas['date'] = _formKey.currentState!.value['date'].toIso8601String();
                                          datas['emp_id'] = emp_id;

                                          _OnSubmit(datas);
                                          setState(() {
                                            trans = [];
                                          });
                                        }
                                      },
                                      icon: Icon(Icons.search, size: 30,),
                                    ),
                                    SizedBox(width: 20,),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: TextButton.icon(
                                        onPressed: () {
                                          getClient();
                                          setState(() {
                                            trans = [];
                                          });
                                        },
                                        style: TextButton.styleFrom(
                                            backgroundColor: Colors.grey[300],
                                            minimumSize: Size(70, 50)
                                        ),
                                        label: Text('الكل', style: TextStyle(color: Colors.black, fontSize: 17),),
                                        icon: const Icon(Icons.person_search_outlined, size: 30, color: Colors.red,),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                        ),
                        SizedBox(height: 30,),
                        Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.cancel_rounded, size: 30, color: Colors.redAccent,),
                                SizedBox(width: 10,),
                                Text('لا يوجد تفاصيل معاملات', style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.black
                                ),),
                              ],
                            ),
                      ],
                    )
                    ],
                ),
                ]
              ),
            ),
          ],
        ),
      ),
    );
  }
}
