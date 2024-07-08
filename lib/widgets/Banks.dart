import 'package:OilEnergy_System/components/MoneyFormatter.dart';
import 'package:flutter/material.dart';
import 'package:OilEnergy_System/API/banks.dart';
import 'package:OilEnergy_System/SharedService.dart';
import 'package:OilEnergy_System/components/appBar.dart';
import 'package:OilEnergy_System/components/side_bar.dart';
import 'package:OilEnergy_System/components/tables/BanksTable.dart';
import 'package:sidebarx/sidebarx.dart';

class Banks extends StatefulWidget {
  const Banks({super.key});

  @override
  State<Banks> createState() => _BanksState();
}

class _BanksState extends State<Banks> {
  SidebarXController controller = SidebarXController(selectedIndex: 9, extended: true);
  bool isLoading = false;
  List data = [];
  int total = 0;

  @override
  void initState() {
    get_all_banks();
    super.initState();
  }
  //future request to server
  Future get_all_banks () async {
    setState(() {
      isLoading = true;
    });
    // post to server
    final auth = await SharedServices.LoginDetails();
    final response = await API_Bank.Get_All_Banks(auth.token);

    setState(() {
      isLoading = false;
      data = response['banks'];
      total = response['total'];
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
                Expanded(
                    child: ListView(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width/1.3,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.blue[800]
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('اجمالي الخزنة', style: TextStyle(fontSize: 24, color: Colors.white),),
                              Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text('${myFormat(total)}', style: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold),),
                                  )),
                            ],
                          ),
                        ),
                        SizedBox(height: 90,),
                        data.length !=0 ?
                        Container(
                          color: Colors.grey[100],
                          child: BanksTable(data: data,),
                        ) : BanksTable(data: data)
                      ]
                    ))
              ],
            )
      ),
    );
  }
}
