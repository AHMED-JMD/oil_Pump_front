import 'package:OilEnergy_System/API/reading.dart';
import 'package:flutter/material.dart';
import 'package:OilEnergy_System/API/daily.dart';
import 'package:OilEnergy_System/API/outgoing.dart';
import 'package:OilEnergy_System/SharedService.dart';
import 'package:OilEnergy_System/components/appBar.dart';
import 'package:OilEnergy_System/components/outgoings.dart';
import 'package:OilEnergy_System/components/side_bar.dart';
import 'package:OilEnergy_System/components/tables/daily_table.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:OilEnergy_System/API/pump.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class Dailys extends StatefulWidget {
  const Dailys({super.key});

  @override
  State<Dailys> createState() => _DailysState();
}

class _DailysState extends State<Dailys> {
  SidebarXController controller = SidebarXController(selectedIndex: 2, extended: true);
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  bool isLoading = false;
  bool nw_daily = false;
  DateTime today_date = DateTime.now();
  late String formattedDate = formatDate(today_date);
  List readings = [];
  String? selectedPump;
  List daily_data = [];
  List outg_data = [];
  int total_benz = 0;
  int total_gas = 0;
  int total_dailys = 0;
  int total_outgs = 0;

  //initial state function
  @override
  void initState() {
    super.initState();
    getAllReadings();
    getDailys();
    get_OutG();
  }

  //function to format date
  String formatDate(DateTime dateTime) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String formattedDate = "${dateTime.year}-${twoDigits(dateTime.month)}-${twoDigits(dateTime.day)}";
    return "$formattedDate";
  }

  //server side function
  Future getDailys() async {
    setState(() {
      isLoading = true;
    });
    //send to server

    final datas = {};
    datas['date'] = today_date.toIso8601String();
    final auth = await SharedServices.LoginDetails();
    API_Daily.get_Trans(datas, auth.token).then((response){
      setState(() {
        isLoading = false;
        daily_data = response['trans'];
        total_dailys = response['total'];
      });
    });
  }

  Future addDaily() async{
    setState(() {
      isLoading = true;
    });

    //call server
    Map date = {};
    date['date'] = today_date.toIso8601String();
    date['total_pumps'] = total_benz + total_gas;
    date['total_dailys'] = total_dailys;
    date['total_outgs'] = total_outgs;
    final auth = await SharedServices.LoginDetails();
    final response = await API_Daily.Add_Daily(date ,auth.token);

    response != false ?
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text('اليوميات'),
            content: Row(
              children: [
                Icon(Icons.warning, color: Colors.blue,size: 40,),
                Text('تم حساب يومية جديدة بنجاح',
                  style: TextStyle(fontSize: 19),
                ),
              ],
            ),
            actions: [],
          ),
        );
      },
    )
        :
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text('اليوميات'),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.warning, color: Colors.blue,size: 40,),
                SizedBox(width: 7,),
                Text("تم تعديل اليومية بنجاح",
                  style: TextStyle(fontSize: 19),
                ),
              ],
            ),
            actions: [],
          ),
        );
      },
    );
  }

  Future getAllReadings() async{
    setState(() {
      isLoading = true;
    });

    //call server
    Map datas = {};
    datas['date'] = today_date.toIso8601String();
    final auth = await SharedServices.LoginDetails();
    final response = await API_Reading.GetReading(datas, auth.token);

    setState(() {
      isLoading = false;
      readings = response['reading'];
      total_benz = response['total_benz'];
      total_gas = response['total_gas'];
    });
  }

  Future get_OutG() async {
    setState(() {
      isLoading = false;
    });
    //post to server
    final datas = {};
    datas['date'] = today_date.toIso8601String();

    final auth = await SharedServices.LoginDetails();
    final response = await API_OutG.Get_OutG(datas, auth.token);

    response != false ?
    setState(() {
      isLoading = false;
      outg_data = response['outgoing'];
      total_outgs = response['total'];
    }) :
    setState(() {
      isLoading = false;
      outg_data = [];
    });
  }

  Future addOutgoing (data) async {
    setState(() {
      isLoading = true;
    });
    //post to server
    final auth = await SharedServices.LoginDetails();
    final response = await API_OutG.Add_OutG(data, auth.token);
    setState(() {
      isLoading = false;
    });

    response != false ? ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم اضافة المنصرف بنجاح', textAlign: TextAlign.center, style: TextStyle(fontSize: 17),),
        backgroundColor: Colors.green,
      ),
    ) :
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$response', textAlign: TextAlign.center, style: TextStyle(fontSize: 17),),
          backgroundColor: Colors.red,
        )
    );

    //refresh
    get_OutG();
    await Future.delayed(Duration(milliseconds: 700));
    Navigator.pushReplacementNamed(context, '/dailys');
  }

  Future updateReading (data) async {
    setState(() {
      isLoading = true;
    });
    //send to server
    final auth = await SharedServices.LoginDetails();
    final response = await API_Pump.UpdatePump(data, auth.token);

    response != false ?
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم تعديل بيانات القراءة بنجاح', textAlign: TextAlign.center, style: TextStyle(fontSize: 17),),
          backgroundColor: Colors.green,
        )
    )  :
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('تم تسجيل القراءة مسبقا', textAlign: TextAlign.center, style: TextStyle(fontSize: 17),),
      backgroundColor: Colors.red,
    )
    );

    //refresh
    getAllReadings();
  }

  Future deleteReading (reading_id) async {
    setState(() {
      isLoading = true;
    });
    //send to server
    Map data = {};
    data['reading_id'] = reading_id;

    final auth = await SharedServices.LoginDetails();
    final response = await API_Reading.DeleteOne(data, auth.token);

    response != false ?
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم حذف القراءة بنجاح', textAlign: TextAlign.center, style: TextStyle(fontSize: 17),),
          backgroundColor: Colors.green,
        )
    )  :
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم تسجيل القراءة مسبقا', textAlign: TextAlign.center, style: TextStyle(fontSize: 17),),
          backgroundColor: Colors.red,
        )
    );

    //refresh
    getAllReadings();
  }
  //-----------------------------------------------

  
  //widgget Function
  Widget Pumps(BuildContext context, data, height){
         return
           Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 40),
              child: Container(
                height: 500,
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: data['type'] == 'جازولين' ? Colors.green : Colors.red,
                      width: 3
                    )
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(' ${data['f_reading']}', style: TextStyle(fontSize: 18)),
                    Text(' ${data['last_reading']}', style: TextStyle(fontSize: 18)),
                    Text('راجع التنك: ${data['returned']}', style: TextStyle(fontSize: 18)),
                    Text('عدد اللترات : ${data['amount']}'),
                    Text('القيمة : ${data['value']}', style: TextStyle(fontSize: 18),),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: (){
                              _updateReading(context, data);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black54
                            ),
                            child: Text('تعديل البيانات')
                        ),
                        SizedBox(width: 5,),
                        InkWell(
                            onTap: (){
                              _deleteReading(context, data);
                            },
                            child: Icon(Icons.delete, color: Colors.redAccent,)
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                  ],
                ),
              ),
            );
  }

  void _updateReading(BuildContext context, machine) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter SetState){
            return Directionality(
              textDirection: TextDirection.rtl,
              child: SimpleDialog(
                  title: Text("تعديل القراءة"),
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: FormBuilder(
                        // Define the form key to identify the form
                        key: _formKey,
                        // Define the form fields
                        child: Column(
                          children: [
                            // Add a dropdown field
                            FormBuilderTextField(
                              name: 'machine',
                              decoration: InputDecoration(labelText: 'المكنة'),
                              initialValue: machine.isNotEmpty? '${machine['pump_name']}' : '',
                              readOnly: true,
                              validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                            ),
                            // Add a text field

                            FormBuilderTextField(
                              name: 'reading',
                              decoration: InputDecoration(labelText: 'القراءة'),
                              readOnly: true,
                              initialValue: machine.isNotEmpty? '${machine['f_reading']}' : '',
                              validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                            ),
                            // Add another text field
                            FormBuilderTextField(
                              name: 'nw_read',
                              decoration: InputDecoration(labelText: 'القراءة الجديدة'),
                              initialValue: machine.isNotEmpty? '${machine['last_reading']}' : '',
                              validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                            ),
                            SizedBox(height: 40,),
                            // Add a submit button
                            SizedBox(
                              width: 100,
                              height: 40,
                              child: ElevatedButton(
                                child: Text('ارسال'),
                                style: ElevatedButton.styleFrom(
                                    textStyle: TextStyle(fontSize: 18)
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.saveAndValidate()) {
                                    var data = {};
                                    data['pump_id'] = machine['pumpPumpId'];
                                    data['reading'] = _formKey.currentState!.value['reading'];
                                    data['nw_reading'] = _formKey.currentState!.value['nw_read'];
                                    data['date'] = today_date.toIso8601String();

                                    //call backend------------
                                    updateReading(data);
                                    Navigator.pop(context);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        TextButton.icon(
                          icon: Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                          label: Text('الغاء'),
                        ),
                      ],
                    ),
                  ],
                ),
            );

          },

        );
      },
    );
  }

  void _deleteReading(BuildContext context, data){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text('حذف القراءة'),
            content: Text(' هل انت متأكد برغبتك في حذف قراءة ${data['pump_name']}'),
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
                          deleteReading(data['reading_id']);
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

  void _outgoingModel(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: SimpleDialog(
            title: Text('منصرف جديد'),
            children:[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: FormBuilder(
                  key: _formKey,
                  child: Column(
                    children: [
                      FormBuilderTextField(
                          name: 'comment',
                          decoration: InputDecoration(labelText: 'البيان'),
                          validator: FormBuilderValidators.required(errorText: 'الرجاء ادخال جميع الحقول'),
                      ),
                      FormBuilderTextField(
                        name: 'amount',
                        decoration: InputDecoration(labelText: 'المبلغ'),
                        validator: FormBuilderValidators.required(errorText: 'الرجاء ادخال جميع الحقول'),
                      ),
                      FormBuilderDateTimePicker(
                          name: 'date',
                          decoration: InputDecoration(labelText: "التاريخ"),
                          validator: FormBuilderValidators.required(errorText: 'الرجاء ادخال جميع الحقول'),
                          inputType: InputType.date,
                          initialValue: DateTime.now(),
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
                                primary: Colors.white,
                              ),
                              child: Text('اضافة'),
                              onPressed: (){
                                if(_formKey.currentState!.saveAndValidate()){
                                  //send to server ---
                                  final date = _formKey.currentState!.value['date'];
                                  final amount = _formKey.currentState!.value['amount'];
                                  final comment = _formKey.currentState!.value['comment'];

                                  final data = {};
                                  data['comment'] = comment;
                                  data['amount'] = amount;
                                  data['date'] = date.toIso8601String();

                                  addOutgoing(data);
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
//--------------------------------------------------------

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
                  children:[Column(
                    children: [
                          SizedBox(height: 10,),
                          Container(
                            color: Colors.blueGrey,
                            width: MediaQuery.of(context).size.width/3,
                            height: 40,
                            child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      ' تاريخ اليومية : ',
                                      style: TextStyle(fontSize: 19, color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      ' ${formattedDate} ',
                                      style: TextStyle(fontSize: 19, color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )

                          ),
                          SizedBox(height: 20,),
                          LayoutBuilder(
                            builder: (BuildContext context, BoxConstraints constraints ){
                              if(constraints.maxWidth > 800){
                                return GridView.builder(
                                      shrinkWrap: true,
                                      physics: ScrollPhysics(),
                                      itemCount: readings.length,
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 5,
                                        childAspectRatio: 0.75,
                                      ),
                                      itemBuilder: (context, index) =>
                                          Pumps(context, readings[index], 430.0)
                                    );
                              }else{
                                return GridView.builder(
                                    shrinkWrap: true,
                                    physics: ScrollPhysics(),
                                    itemCount: readings.length,
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      childAspectRatio: 0.75,
                                    ),
                                    itemBuilder: (context, index) =>
                                        Pumps(context, readings[index], 300.0)
                                );
                              }
                            }
                          ),
                      Container(
                        color: Colors.grey[200],
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Text('قراءة الجاز',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 21
                                        ),
                                      ),
                                      Text('= ${total_gas}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 21,
                                            color: Colors.green
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 9,),
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Text('قراءة البنزين',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 21
                                        ),
                                      ),
                                      Text('= ${total_benz}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 21,
                                            color: Colors.red
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 17,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text('مجموع القراءات',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 21
                                    ),
                                  ),
                                  Text('= ${total_benz + total_gas}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 21,
                                        color: Colors.black
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      ElevatedButton.icon(
                          onPressed: (){
                            Navigator.pushReplacementNamed(context, '/add_reading');
                          },
                          icon: Icon(Icons.add, size: 30,),
                          label: Text('قراءة جديدة'),
                      ),
                      SizedBox(height: 150,),
                      Container(
                          width: 280,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(12)
                          ),
                          child: Text('المعاملات و الديون', textAlign: TextAlign.center, style: TextStyle(fontSize: 22, color: Colors.black),),

                      ),
                      SizedBox(height: 20,),
                      daily_data.length != 0 ?
                      Container(
                          color: Colors.grey.shade100,
                          child: Column(
                            children: [
                              DailyTable(total: total_dailys,daily_data: daily_data,),
                              SizedBox(height: 15,),
                            ],
                          )
                      ) : Container(
                          color: Colors.grey[100],
                          child: DailyTable(total: total_dailys ,daily_data: daily_data,)),
                      SizedBox(height: 150,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                              width: 280,
                              height: 50,
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(12)
                              ),
                              child: Text('المنصرفات', textAlign: TextAlign.center, style: TextStyle(fontSize: 22, color: Colors.black),)
                          ),
                          ElevatedButton(
                              onPressed: (){
                                _outgoingModel(context);
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(50, 40)
                              ),
                              child: Text('اضافة منصرف'))
                        ],
                      ),
                      SizedBox(height: 10,),
                      outg_data.length != 0 ?
                      Outgoings(total: total_outgs, data: outg_data,)
                      : Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Card(
                          child: ListTile(
                            leading: Icon(Icons.outbond),
                            title: Text('لا يوجد منصرفات اليوم'),
                          ),
                        ),
                      ),
                      SizedBox(height: 25,),
                      SizedBox(
                        width: MediaQuery.of(context).size.width/1.2,
                        height: 40,
                        child: ElevatedButton(
                            onPressed: (){
                              addDaily();
                            },
                            child: Text('حفظ اليومية', style: TextStyle(fontSize: 18),)
                        ),
                      ),
                      SizedBox(height: 25,),
                    ],
                  ),
                  ]
                )
            )
          ],
        ),
      ),
    );
  }
}
