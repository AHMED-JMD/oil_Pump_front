import 'package:flutter/material.dart';
import 'package:oil_pump_system/API/client.dart';
import 'package:oil_pump_system/SharedService.dart';
import 'package:oil_pump_system/components/appBar.dart';
import 'package:oil_pump_system/components/side_bar.dart';
import 'package:oil_pump_system/components/tables/clientDetailsTable.dart';
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
                        height: 230,
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
                                   width: 300,
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
                                  width: 300,
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
                                child: ClientDetailsTable(data: trans)
                            )
                        ),
                      ],
                    ) : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.cancel_rounded, size: 30, color: Colors.redAccent,),
                            SizedBox(width: 10,),
                            Text('لا يوجد تفاصيل معاملات', style: TextStyle(
                              fontSize: 22,
                              color: Colors.black
                            ),),
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
