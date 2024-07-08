import 'package:OilEnergy_System/components/MoneyFormatter.dart';
import 'package:OilEnergy_System/components/SearchInDates.dart';
import 'package:flutter/material.dart';
import 'package:OilEnergy_System/API/daily.dart';
import 'package:OilEnergy_System/SharedService.dart';
import 'package:OilEnergy_System/components/appBar.dart';
import 'package:OilEnergy_System/components/side_bar.dart';
import 'package:OilEnergy_System/widgets/dailyDetails.dart';
import 'package:sidebarx/sidebarx.dart';

class OldDailys extends StatefulWidget {
  const OldDailys({super.key});

  @override
  State<OldDailys> createState() => _OldDailysState();
}

class _OldDailysState extends State<OldDailys> {
  SidebarXController controller =
      SidebarXController(selectedIndex: 1, extended: true);

  bool isLoading = false;
  List dailys = [];
  List trans_data = [];
  List outg_data = [];
  int total = 0;
  int total_outgs = 0;
  int total_dailys = 0;
  DateTime? date = DateTime.now();

  @override
  void initState() {
    GetAllDaily();
    super.initState();
  }
  //server side function
  Future GetDaily(datas) async {
    setState(() {
      isLoading = true;
    });

    //post to server
    final auth = await SharedServices.LoginDetails();
    final response = await API_Daily.Get_One_Daily(datas, auth.token);

    response.length != 0
        ? setState(() {
            dailys = response['daily_trans'];
            total = response['total'];
            isLoading = false;
          })
        : ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'عفوا لا يوجد يومية في هذا اليوم',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17),
              ),
              backgroundColor: Colors.red,
            ),
          );
  }

  Future GetAllDaily() async {
    setState(() {
      isLoading = true;
    });

    //post to server
    final auth = await SharedServices.LoginDetails();
    final response = await API_Daily.Get_All_Daily(auth.token);

    setState(() {
      isLoading = false;
      dailys = response['daily_trans'];
      total = response['total'];
    });
  }

  Future deleteDaily(daily_id) async {
    setState(() {
      isLoading = true;
    });
    //send to server
    Map data = {};
    data['daily_id'] = daily_id;
    data['date'] = date!.toIso8601String();

    final auth = await SharedServices.LoginDetails();
    API_Daily.Delete_Daily(data, auth.token).then((response) async {
      setState(() {
        isLoading = false;
      });
      if (response == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'تم حذف اليومية بنجاح',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 17),
            ),
            backgroundColor: Colors.red,
          ),
        );
        await Future.delayed(Duration(milliseconds: 600));
        Navigator.pushReplacementNamed(context, '/old_daily');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '$response',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 17),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }
  //-----------------------


  //model widgets
  void _deleteModal(BuildContext context, daily) {
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
                    width: 100,
                    child: TextButton(
                        child: Text('حذف', style: TextStyle(color: Colors.white),),
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                        ),
                        onPressed: () {
                          deleteDaily(daily['daily_id']);
                          Navigator.of(context).pop();
                        }),
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
              child: ListView(children: [
                Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage('assets/Curve_Line.png'),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                            Colors.blueAccent, BlendMode.difference),
                      )),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'اليوميات السابقة',
                            style: TextStyle(fontSize: 26, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 70,
                    ),
                    SearchDates(Search: GetDaily),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.blue[700],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        ' اجمالي قيمة اليوميات = (${myFormat(total)})',
                        style: TextStyle(fontSize: 21, color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    dailys.length != 0
                        ? Container(
                            height: 400,
                            width: MediaQuery.of(context).size.width / 1.3,
                            child: ListView.builder(
                              itemCount: dailys.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.all(4),
                                  child: Card(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: ListTile(
                                              leading: Icon(Icons.view_agenda),
                                              title: Text(
                                                  ' المبلغ :  ${myFormat((dailys[index]['amount']))} جنيه',
                                                  style:
                                                      TextStyle(fontSize: 18)),
                                              subtitle: Text(
                                                ' التاريخ : ${dailys[index]['date'].toString()}',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              trailing: SizedBox(
                                                width: 200,
                                                child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      TextButton.icon(
                                                        onPressed: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      DailyDetails(
                                                                          date: dailys[index]
                                                                              [
                                                                              'date'])));
                                                        },
                                                        style: TextButton
                                                            .styleFrom(
                                                                backgroundColor:
                                                                    Colors.grey[
                                                                        200],
                                                                minimumSize:
                                                                    Size(60,
                                                                        45)),
                                                        icon: Icon(
                                                            Icons.mode_edit,
                                                            color: Colors.blue),
                                                        label: Text(
                                                          'التفاصيل',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      TextButton.icon(
                                                          onPressed: () {
                                                            _deleteModal(
                                                                context,
                                                                dailys[index]);
                                                          },
                                                          icon: Icon(
                                                            Icons
                                                                .delete_forever,
                                                            color: Colors.red,
                                                          ),
                                                          label: Text(''))
                                                    ]),
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : Center(
                            child: Container(
                                width: 280,
                                height: 50,
                                decoration: BoxDecoration(
                                    color: Colors.blueAccent,
                                    borderRadius: BorderRadius.circular(12)),
                                child: Center(
                                    child: Text(
                                  'لا يوجد يوميات سابقة',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ))))
                  ],
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
