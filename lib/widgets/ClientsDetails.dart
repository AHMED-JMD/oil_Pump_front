import 'package:OilEnergy_System/API/daily.dart';
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

  SidebarXController controller = SidebarXController(selectedIndex: 2, extended: true);
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

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
    final response = await API_Emp.getOneClients(data, auth.token);

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
    final response = await API_Daily.client_Trans(datas, auth.token);
    print(response);
    if(response != false){
      setState(() {
        isLoading = false;
        trans = response;
      });
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
                      Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width/1.3,
                        height: 290,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(12)
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                               children: [
                                 Container(
                                   height:70,
                                   width: 500,
                                     decoration: BoxDecoration(
                                       color: Colors.blueGrey,
                                       borderRadius: BorderRadius.circular(12)
                                     ),
                                     child: Center(
                                       child: Row(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: [
                                           Icon(
                                             Icons.person,
                                             color: Colors.black,
                                           ),
                                           Text(
                                             '  الاسم : ${client['name']}',
                                             style: TextStyle(color: Colors.white, fontSize: 19),
                                           ),
                                         ],
                                       ),
                                     )
                                 ),
                                 Container(
                                   height:70,
                                   width: 300,
                                     decoration: BoxDecoration(
                                         color: Colors.blueGrey,
                                         borderRadius: BorderRadius.circular(12)
                                     ),
                                     child: Center(
                                         child: Row(
                                           mainAxisAlignment: MainAxisAlignment.center,
                                           children: [
                                             Icon(Icons.place, color: Colors.black,),
                                             Text(' العنوان : ${client['address']}', style: TextStyle(color: Colors.white, fontSize: 19),),
                                           ],
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
                                        color: Colors.blueGrey,
                                        borderRadius: BorderRadius.circular(12)
                                    ),
                                    child: Center(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.phone_android, color: Colors.black,),
                                            Text(' رقم الهاتف : 0${client['phoneNum']}', style: TextStyle(color: Colors.white, fontSize: 19),),
                                          ],
                                        )),
                                ),

                                Container(
                                  height:70,
                                  width: 300,
                                  decoration: BoxDecoration(
                                      color: Colors.blueAccent,
                                      borderRadius: BorderRadius.circular(12)
                                  ),
                                  child: Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.monetization_on, color: Colors.black,),
                                          Text('  اجمالي الحساب : ${client['account']}', style: TextStyle(color: Colors.white, fontSize: 19),),
                                        ],
                                      )),
                                ),
                              ],
                            ),
                            SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  height:70,
                                  width: 220,
                                  decoration: BoxDecoration(
                                      color: Colors.greenAccent,
                                      borderRadius: BorderRadius.circular(12)
                                  ),
                                  child: Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.gas_meter_outlined, color: Colors.black,),
                                          Text('  الجاز باللتر : ${client['gas_amount']}', style: TextStyle(color: Colors.white, fontSize: 19),),
                                        ],
                                      )),
                                ),
                                Container(
                                  height:70,
                                  width: 220,
                                  decoration: BoxDecoration(
                                      color: Colors.redAccent,
                                      borderRadius: BorderRadius.circular(12)
                                  ),
                                  child: Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.gas_meter_outlined, color: Colors.black,),
                                          Text('  البنزين باللتر : ${client['benz_amount']}', style: TextStyle(color: Colors.white, fontSize: 19),),
                                        ],
                                      )),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
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
