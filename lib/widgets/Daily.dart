import 'package:flutter/material.dart';
import 'package:oil_pump_system/API/daily.dart';
import 'package:oil_pump_system/API/outgoing.dart';
import 'package:oil_pump_system/SharedService.dart';
import 'package:oil_pump_system/components/appBar.dart';
import 'package:oil_pump_system/components/outgoings.dart';
import 'package:oil_pump_system/components/side_bar.dart';
import 'package:oil_pump_system/components/tables/daily_table.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:oil_pump_system/API/pump.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class Dailys extends StatefulWidget {
  const Dailys({super.key});

  @override
  State<Dailys> createState() => _DailysState();
}

class _DailysState extends State<Dailys> {
  SidebarXController controller = SidebarXController(selectedIndex: 0, extended: true);
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  bool isLoading = false;
  bool nw_daily = false;
  DateTime today_date = DateTime.now();
  List data = [];
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
    getAllPumps();
    getDailys();
    get_OutG();
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

  Future getAllPumps() async{
    setState(() {
      isLoading = true;
    });

    //call server
    final auth = await SharedServices.LoginDetails();
    final response = await API_Pump.GetAllPump(auth.token);

    setState(() {
      isLoading = false;
      data = response['pumps'];
      total_benz = response['total_benz'];
      total_gas = response['total_gas'];
    });
  }

  Future deletePump (pumpId) async {
    setState(() {
      isLoading = true;
    });
    //server post
    final data = {};
    data['pump_id'] = pumpId;
    final auth = await SharedServices.LoginDetails();
    final response = await API_Pump.DeletePump(data, auth.token);

    setState(() {
      isLoading = false;
    });
    response != false ? ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم الحذف بنجاح', textAlign: TextAlign.center, style: TextStyle(fontSize: 17),),
        backgroundColor: Colors.red,
      ),
    )
        :
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$response', textAlign: TextAlign.center, style: TextStyle(fontSize: 17),),
          backgroundColor: Colors.red,
        )
    );

    //refresh
    getAllPumps();
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
      data = [];
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
  }

  Future updatePump (data) async {
    setState(() {
      isLoading = true;
    });
    //send to server
    final auth = await SharedServices.LoginDetails();
    final response = await API_Pump.UpdatePump(data, auth.token);

    response != false ?
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم تعديل بيانات المكنة بنجاح', textAlign: TextAlign.center, style: TextStyle(fontSize: 17),),
          backgroundColor: Colors.green,
        )
    )  :
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('$response', textAlign: TextAlign.center, style: TextStyle(fontSize: 17),),
      backgroundColor: Colors.red,
    )
    );

    //refresh
    getAllPumps();
  }
  //-----------------------------------------------

  
  //widgget Function
  Widget Pumps(BuildContext context, data){
         return
           Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 40),
              child: Container(
                decoration: BoxDecoration(
                    color: data['type'] == 'جاز' ? Colors.green : Colors.blue,
                    borderRadius: BorderRadius.circular(12)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${data['name']}'),
                    SizedBox(height: 5,),
                    Text('القراءة : ${data['reading']}'),
                    Text('عدد اللترات : ${data['amount']}'),
                    Text('القيمة : ${data['value']} جنيه ', style: TextStyle(fontSize: 18),),

                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: (){
                              _openModal(context, data);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black54
                            ),
                            child: Text('قراءة جديدة')
                        ),
                         SizedBox(width: 10,),
                         InkWell(
                           onTap: (){
                             _deleteModal(context, data);
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

  // modals functions
  void _deleteModal(BuildContext context, data){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text('حذف المكنة'),
            content: Text(' هل انت متأكد برغبتك في حذف المكنة ${data['name']}'),
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
                          deletePump(data['pump_id']);
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

  void _openModal(BuildContext context, machine) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: SimpleDialog(
            title: Text("قراءة جديدة"),
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
                        initialValue: machine.isNotEmpty? '${machine['name']}' : '',
                        readOnly: true,
                        validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                      ),
                      // Add a text field
                      FormBuilderTextField(
                        name: 'old_read',
                        decoration: InputDecoration(labelText: 'القراءة'),
                        readOnly: true,
                        initialValue: machine.isNotEmpty? '${machine['reading']}' : '',
                        validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                      ),
                      // Add another text field
                      FormBuilderTextField(
                        name: 'nw_read',
                        decoration: InputDecoration(labelText: 'القراءة الجديدة'),
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
                              data['pump_id'] = machine['pump_id'];
                              data['nw_reading'] = _formKey.currentState!.value['nw_read'];

                              //call backend------------
                              updatePump(data);
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
                          GridView.builder(
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            itemCount: data.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 5
                              ),
                            itemBuilder: (context, index) =>
                              Pumps(context, data[index])
                          ),
                      Container(
                        color: Colors.grey[300],
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Container(
                                color: Colors.green,
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
                                            color: Colors.black
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 9,),
                              Container(
                                color: Colors.blue,
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
                                            color: Colors.black
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
                                        color: Colors.red
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
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
                            child: Text('حساب اليومية', style: TextStyle(fontSize: 18),)
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
