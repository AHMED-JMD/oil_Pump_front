import 'package:OilEnergy_System/API/BankTrans.dart';
import 'package:flutter/material.dart';
import 'package:OilEnergy_System/API/banks.dart';
import 'package:OilEnergy_System/SharedService.dart';
import 'package:OilEnergy_System/components/appBar.dart';
import 'package:OilEnergy_System/components/side_bar.dart';
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
  List BankTrans = [];
  Map bank = {};
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetTrans();
  }

  //server functions
  Future GetTrans () async{
    setState(() {
      isLoading = true;
      BankTrans = [];
    });

    //post to server
    Map datas = {};
    datas['banks_id'] = banks_id;

    final auth = await SharedServices.LoginDetails();
    final response = await API_Bank.Get_One(datas, auth.token);

    response.length != 0 ?
    setState((){
      bank = response;
      BankTrans = response['BankTrans'];
      isLoading = false;
    })
      :
    setState((){
      isLoading = false;
    });

  }

  Future deleteBankTrans(trans_id) async {
    setState(() {
      isLoading = true;
    });
    //send to server
    Map data = {};
    data['id'] = trans_id;
    data['banks_id'] = banks_id;

    final auth = await SharedServices.LoginDetails();
    API_BankTrans.Delete(data, auth.token).then((response){
      setState(() {
        isLoading = false;
      });

      print(response);

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

    //refresh page
    GetTrans();
  }

  //modal goes here
  void _deleteModal(BuildContext context, bankTrans){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text('حذف المعامبة'),
            content: Text(' حذف معاملة البنك "${bankTrans['date']}"'),
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
                        ),
                        onPressed: (){
                          deleteBankTrans(bankTrans['id']);
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
                    BankTrans.length != 0 ?
                    Container(
                      height: 400,
                      width: MediaQuery.of(context).size.width/1.3,
                      child: ListView.builder(
                        itemCount: BankTrans.length,
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
                                        title: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(' المبلغ :  ${BankTrans[index]['amount']} جنيه', style: TextStyle(fontSize: 18)),
                                            Text(' التعليق :  ${BankTrans[index]['comment']} ', style: TextStyle(fontSize: 18)),

                                          ],
                                        ),
                                        subtitle: Padding(
                                          padding: const EdgeInsets.only(top: 10.0),
                                          child: Center(child: Text(' التاريخ : ${BankTrans[index]['date'].toString()}', style: TextStyle(fontWeight: FontWeight.bold),)),
                                        ),
                                        trailing: SizedBox(
                                          width: 200,
                                          child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children:[
                                                SizedBox(width: 5,),
                                                TextButton.icon(
                                                    onPressed: (){
                                                      _deleteModal(context, BankTrans[index]);
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
