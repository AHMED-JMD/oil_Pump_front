import 'package:OilEnergy_System/API/BankTrans.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:OilEnergy_System/API/banks.dart';
import 'package:OilEnergy_System/API/daily.dart';
import 'package:OilEnergy_System/API/reading.dart';
import 'package:OilEnergy_System/SharedService.dart';
import 'package:OilEnergy_System/components/appBar.dart';
import 'package:OilEnergy_System/components/outgoings.dart';
import 'package:OilEnergy_System/components/side_bar.dart';
import 'package:OilEnergy_System/components/tables/daily_table.dart';
import 'package:OilEnergy_System/components/tables/reading_table.dart';
import 'package:sidebarx/sidebarx.dart';

class DailyDetails extends StatefulWidget {
  final date;
  DailyDetails({super.key, required this.date});

  @override
  State<DailyDetails> createState() => _DailyDetailsState(date: date);
}

class _DailyDetailsState extends State<DailyDetails> {
  var date;
  _DailyDetailsState({required this.date});

  SidebarXController controller = SidebarXController(selectedIndex: 1, extended: true);
  GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  bool isLoading = false;
  int safe_append = 0;
  List bank_data = [];
  List trans_data = [];
  List outg_data = [];
  List readings = [];
  int total = 0;
  int total_benz = 0;
  int total_gas = 0;
  int total_count = 0;
  String daily_id = '';
  String banks_id = '';


  @override
  void initState() {
    GetDaily(date);
    GetReadings(date);
    get_all_banks();
    super.initState();
  }
  //server side function
  Future GetDaily (date) async{
    setState(() {
       isLoading = true;
    });

    //post to server
    Map datas = {};
    datas['date'] = date;

    final auth = await SharedServices.LoginDetails();
    final response = await API_Daily.Get_Daily(datas, auth.token);

    setState(() {
      isLoading = false;
      trans_data = response['daily_trans'][0]['transactions'];
      outg_data = response['daily_trans'][0]['outgoings'];
      total = response['daily_trans'][0]['amount'];
      daily_id = response['daily_trans'][0]['daily_id'];
      safe_append = response['daily_trans'][0]['safe'];
      // total_outgs = response['total'];
    });
  }
  //get readings
  Future GetReadings (date) async{
    setState(() {
      isLoading = true;
    });

    //post to server
    Map datas = {};
    datas['date'] = date;
    final auth = await SharedServices.LoginDetails();
    final response = await API_Reading.GetReading(datas, auth.token);

    setState(() {
      isLoading = false;
      readings = response['reading'];
      total_benz = response['total_benz'];
      total_gas = response['total_gas'];
    });
  }
  //get banks data
  Future get_all_banks () async {
    setState(() {
      isLoading = true;
    });
    // post to server
    final auth = await SharedServices.LoginDetails();
    final response = await API_Bank.Get_All_Banks(auth.token);

    setState(() {
      isLoading = false;
      bank_data = response['banks'];
    });
  }
  //append daily to banks
  Future appendDaily (data) async {
    setState(() {
      isLoading = true;
    });
    // post to server
    final auth = await SharedServices.LoginDetails();
    final response = await API_BankTrans.Add(data,auth.token);

    setState(() {
      isLoading = false;
    });

    response != false ?
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم توريد اليومية بنجاح', textAlign: TextAlign.center, style: TextStyle(fontSize: 17),),
        backgroundColor: Colors.green,
      ),
    ) :
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('عذرا جدث خطأ ما', textAlign: TextAlign.center, style: TextStyle(fontSize: 17),),
        backgroundColor: Colors.red,
      ),
    );
    await Future.delayed(Duration(milliseconds: 700));
    Navigator.pushReplacementNamed(context, '/old_daily');
  }
//--------------------------------------------

  //modals here
  void _appendModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: SimpleDialog(
            title: Text('توريد اليومية'),
            children:[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: FormBuilder(
                  key: _formKey,
                  child: Column(
                    children: [
                      FormBuilderDropdown(
                        name: 'name',
                        decoration: InputDecoration(labelText: 'اختر البنك'),
                        onChanged: (val) {
                          banks_id = val.toString(); // Print the text value write into TextField
                        },
                        items: bank_data
                            .map((client) => DropdownMenuItem(
                            value: client['banks_id'].toString(),
                            child: Text('${client['bank_name']}')
                        )).toList(),
                        validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                      ),
                      FormBuilderTextField(
                        name: 'amount',
                        decoration: InputDecoration(
                            labelText: 'المبلغ المتاح',
                        ),
                        initialValue: safe_append.toString(),
                        validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                      ),
                      FormBuilderDateTimePicker(
                        name: 'date',
                        decoration: InputDecoration(labelText: "التاريخ"),
                        validator: FormBuilderValidators.required(errorText: 'الرجاء ادخال جميع الحقول'),
                        inputType: InputType.date,
                        initialValue: DateTime.now(),
                      ),
                      FormBuilderTextField(
                        name: 'comment',
                        decoration: InputDecoration(
                          labelText: 'البيان',
                        ),

                        initialValue: 'توريد نقدي/شيك',
                        validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                      ),
                      SizedBox(height: 20,),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Center(
                          child: SizedBox(
                            height: 30,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                              ),
                              child: Text('اضافة'),
                              onPressed: (){
                                if(_formKey.currentState!.saveAndValidate()){
                                  //send to server ---
                                  final data = {};
                                   data['bank_id'] = banks_id;
                                   data['daily_id'] = daily_id;
                                   data['amount'] = _formKey.currentState!.value['amount'];
                                   data['date'] = _formKey.currentState!.value['date'].toIso8601String();
                                   data['comment'] = _formKey.currentState!.value['comment'];

                                   appendDaily(data);
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
                    Column(
                      children: [
                        SizedBox(height: 40,),

                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text('التاريخ : $date', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                Text(' المبلغ الكلي : $total', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                              ],
                            ),
                            SizedBox(height: 60,),
                            readings.length !=0 ?
                            Container(
                                color: Colors.grey[100],
                                child: ReadingTable(total: total_benz + total_gas, readings: readings,)
                            )
                                : Center(child: Text('الرجاء حساب قراءات اليوم', style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 19
                            ),),),
                            SizedBox(height: 60,),
                            trans_data.length != 0 ?
                                Container(
                                    color: Colors.grey[100],
                                    child: DailyTable(total: total_count ,daily_data: trans_data,)
                                )
                                : Center(
                                    child: Text('لا يوجد معاملات يومية في هذا اليوم',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 18, color: Colors.black),)

                                ),
                            SizedBox(height: 30,),
                            outg_data.length != 0 ?
                            Outgoings(total: total_count, data: outg_data,)
                            : Center(
                                child: Text('لا يوجد منصرفات في هذا اليوم',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 18, color: Colors.black),)

                            ),
                            SizedBox(height: 60,),
                            safe_append == 0 ?
                            Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width/1.3,
                                decoration: BoxDecoration(
                                    color: Colors.blueGrey,
                                    borderRadius: BorderRadius.circular(12)
                                ),
                                child: Center(
                                  child: Text('تم توريد اليومية بنجاح',
                                    style: TextStyle(fontSize: 20, color: Colors.white),),)
                            )
                            : Container(
                              width: MediaQuery.of(context).size.width/1.2,
                              height: 40,
                              child: ElevatedButton(
                                onPressed: (){
                                  _appendModal(context);
                                },
                                child: Text('توريد اليومية', style: TextStyle(fontSize: 22),),
                              ),
                            ),
                            SizedBox(height: 40,),
                          ],
                        )

                      ],
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
