import 'package:flutter/material.dart';
import 'package:OilEnergy_System/API/banks.dart';
import 'package:OilEnergy_System/API/daily.dart';
import 'package:OilEnergy_System/SharedService.dart';
import 'package:OilEnergy_System/components/appBar.dart';
import 'package:OilEnergy_System/components/side_bar.dart';
import 'package:OilEnergy_System/widgets/dailyDetails.dart';
import 'package:sidebarx/sidebarx.dart';

class BanksDetails extends StatefulWidget {
  final String banks_id;
  BanksDetails({super.key, required this.banks_id});

  @override
  State<BanksDetails> createState() => _BanksDetailsState(banks_id: banks_id);
}

class _BanksDetailsState extends State<BanksDetails> {
  String banks_id;
  _BanksDetailsState({required this.banks_id});

  SidebarXController controller = SidebarXController(selectedIndex: 9, extended: true);
  List dailys = [];
  Map bank = {};
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetDaily();
  }

  //server functions
  Future GetDaily () async{
    setState(() {
      isLoading = true;
    });

    //post to server
    Map datas = {};
    datas['banks_id'] = banks_id;

    final auth = await SharedServices.LoginDetails();
    final response = await API_Bank.Get_One(datas, auth.token);

    response.length != 0 ?
    setState((){
      bank = response;
      dailys = response['dailies'];
      isLoading = false;
    })
      :
    setState((){
      isLoading = false;
    });

  }

  Future deleteDaily(daily_id) async {
    setState(() {
      isLoading = true;
    });
    //send to server
    Map data = {};
    data['daily_id'] = daily_id;
    final auth = await SharedServices.LoginDetails();
    API_Daily.Delete_Daily(data, auth.token).then((response){
      setState(() {
        isLoading = false;
      });
      if(response == true){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تم حذف اليومية بنجاح', textAlign: TextAlign.center, style: TextStyle(fontSize: 17),),
            backgroundColor: Colors.red,
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
  }

  //modal goes here
  void _deleteModal(BuildContext context, daily){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text('حذف اليومية'),
            content: Text(' حذف اليومية "${daily['date']}"'),
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
                          deleteDaily(daily['daily_id']);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: APPBAR(context),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          children: [
            Navbar(controller: controller),
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
                          Text('${bank['bank_name']}', style: TextStyle(fontSize: 24, color: Colors.white),),
                          Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text('${bank['amount']}', style: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold),),
                              )),
                        ],
                      ),
                    ),
                    SizedBox(height: 90,),
                    dailys.length != 0 ?
                    Container(
                      height: 400,
                      width: MediaQuery.of(context).size.width/1.3,
                      child: ListView.builder(
                        itemCount: dailys.length,
                        itemBuilder: (context, index){
                          return Padding(
                            padding: EdgeInsets.all(4),
                            child: Card(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: ListTile(
                                        leading: Icon(Icons.view_agenda),
                                        title: Text(' المبلغ :  ${dailys[index]['amount']} جنيه', style: TextStyle(fontSize: 18)),
                                        subtitle: Text(' التاريخ : ${dailys[index]['date'].toString()}', style: TextStyle(fontWeight: FontWeight.bold),),
                                        trailing: SizedBox(
                                          width: 200,
                                          child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children:[
                                                TextButton.icon(
                                                  onPressed: (){
                                                    Navigator.push(context, MaterialPageRoute(
                                                        builder: (context) => DailyDetails(date: dailys[index]['date'])
                                                    ));
                                                  },
                                                  style: TextButton.styleFrom(
                                                      backgroundColor: Colors.grey[200],
                                                      minimumSize: Size(60, 45)
                                                  ),
                                                  icon: Icon(Icons.mode_edit, color: Colors.blue),
                                                  label: Text('التفاصيل', style: TextStyle(color: Colors.black),),
                                                ),
                                                SizedBox(width: 5,),
                                                TextButton.icon(
                                                    onPressed: (){
                                                      _deleteModal(context, dailys[index]);
                                                    },
                                                    icon: Icon(Icons.delete_forever, color: Colors.red,),
                                                    label: Text('')
                                                )
                                              ]
                                          ),
                                        )
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ): Center(
                        child: Container(
                            width: 280,
                            height: 50,
                            decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                borderRadius: BorderRadius.circular(12)
                            ),
                            child: Center(
                                child: Text('لم يتم توريد اي يومية في هذا البنك',textAlign: TextAlign.center, style: TextStyle(fontSize: 18, color: Colors.white),)
                            )
                        )
                    )
                  ],
                )
            )
          ],
        ),
      ),
    );
  }
}
