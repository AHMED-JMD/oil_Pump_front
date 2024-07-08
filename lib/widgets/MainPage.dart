import 'package:OilEnergy_System/components/MoneyFormatter.dart';
import 'package:flutter/material.dart';
import 'package:OilEnergy_System/API/gas.dart';
import 'package:OilEnergy_System/SharedService.dart';
import 'package:OilEnergy_System/components/BarChart.dart';
import 'package:OilEnergy_System/components/appBar.dart';
import 'package:OilEnergy_System/components/side_bar.dart';
import 'package:sidebarx/sidebarx.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  SidebarXController controller = SidebarXController(selectedIndex: 0, extended: true);
  bool isLoading = false;
  String user = '';
  int avail_benz = 0;
  int avail_gas = 0;

  @override
  void initState() {
    super.initState();
    getAllGas();
    getUser();
  }

  //server side Functions ------------------
  //------get--
  Future getAllGas () async {
    setState(() {
      isLoading = true;
    });
    //post to server
    final auth = await SharedServices.LoginDetails();
    final response = await API_Gas.Get_All_Gas(auth.token);

    response != false ?
    setState(() {
      isLoading = false;
      avail_benz = response['available_benz'];
      avail_gas = response['available_gas'];
    }) : setState(() {
      isLoading = false;
      avail_benz = 0;
      avail_gas = 0;
    });

  }
  //get user
  getUser () async {
    final auth = await SharedServices.LoginDetails();
    setState(() {
      user = auth.user.username;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: APPBAR(context),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          children: [
            Navbar(controller: controller,),
            Expanded(child:
             ListView(
              children:[
                SizedBox(height: 5,),
                Container(
                  color: Colors.grey[200],
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(' المستخدم : ${user}', style: TextStyle(
                        fontSize: 20, color: Colors.deepPurpleAccent
                      ),),
                      Text('${DateTime.now().day} / ${DateTime.now().month} / ${DateTime.now().year} (${DateTime.now().hour > 6 ? "PM" : "AM"} ${DateTime.now().hour}:${DateTime.now().minute} )', style: TextStyle(
                          fontSize: 19
                      ))
                    ],
                  ),
                ),
                 SizedBox(height: 50,),
                SizedBox(
                    width: MediaQuery.of(context).size.width/2,
                    child: DailyBarChart()
                ),
                Padding(
                  padding: const EdgeInsets.only(top : 20, right: 24.0),
                  child: Text('تقرير اليوميات', textAlign: TextAlign.right, style: TextStyle(
                      fontSize: 22,
                    fontWeight: FontWeight.bold
                      ),
                    ),
                ),
                SizedBox(height: 60,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width/3.5,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: Colors.green,
                              width: 2
                          )
                      ),
                      child: Center(
                        child: Text(' بئر الجازولين = ${myFormat(avail_gas)} لتر', style: TextStyle(
                            fontSize: 22,
                            color: Colors.black
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width/3.5,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.redAccent,
                          width: 2
                        )
                      ),
                      child: Center(
                        child: Text(' بئر البنزين = ${myFormat(avail_benz)} لتر', style: TextStyle(
                            fontSize: 22,
                            color: Colors.black
                        ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 90,),
              ]
            ))
          ],
        ),
      ),
    );
  }
}
