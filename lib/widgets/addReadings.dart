import 'package:OilEnergy_System/API/reading.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:OilEnergy_System/API/pump.dart';
import 'package:OilEnergy_System/SharedService.dart';
import 'package:OilEnergy_System/components/appBar.dart';
import 'package:OilEnergy_System/components/side_bar.dart';
import 'package:sidebarx/sidebarx.dart';

class AddReading extends StatefulWidget {
  const AddReading({super.key});

  @override
  State<AddReading> createState() => _AddReadingState();
}

class _AddReadingState extends State<AddReading> {
  GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  SidebarXController controller = SidebarXController(selectedIndex: 2, extended: true);

  bool isLoading = false;
  List data = [];
  Map pump = {};
  String? selectedPump_id;

  @override
  void initState() {
    getAllPumps();
    super.initState();
  }

//server side add
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
    });
  }

  Future getPump(pump_id) async{
    setState(() {
      isLoading = true;
      pump = {};
    });

    //call server
    Map datas = {};
    datas['pump_id'] = pump_id;
    final auth = await SharedServices.LoginDetails();
    final response = await API_Pump.GetPump(datas, auth.token);

    setState(() {
      isLoading = false;
      pump = response;
    });
  }

  Future addReading (data) async {
    setState(() {
      isLoading = true;
      pump.clear();
    });
    //send to server
    final auth = await SharedServices.LoginDetails();
    final response = await API_Reading.AddReading(data, auth.token);
    print(response);
    response == true ?
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم تعديل بيانات المكنة بنجاح', textAlign: TextAlign.center, style: TextStyle(fontSize: 17),),
          backgroundColor: Colors.green,
        )
    )  :
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم تسجيل القراءة مسبقا', textAlign: TextAlign.center, style: TextStyle(fontSize: 17),),
          backgroundColor: Colors.red,
        )
    );
    //delete when you figure the issue
    Navigator.pushReplacementNamed(context, "/add_reading");
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
                    Padding(
                      padding: const EdgeInsets.all(50.0),
                      child: FormBuilder(
                        key: _formKey,
                        child: Column(
                          children: [
                            CircleAvatar(
                              child: Icon(Icons.gas_meter),
                              backgroundColor: Colors.grey[300],
                              radius: 50,
                            ),
                            FormBuilderDropdown(
                              name: 'pump_id',
                              decoration: InputDecoration(labelText: 'اسم المكنة'),
                              onChanged: (val) {
                               setState(() {
                                 selectedPump_id = val;
                                 pump = {};
                                 //make sure val != ''
                                 if(val != ''){
                                   getPump(val);
                                 }
                               });
                              },
                              initialValue: '',
                              items: data
                                  .map((pump) => DropdownMenuItem(
                                  value: pump['pump_id'].toString(),
                                  child: Text('${pump['name']}')
                              )).toList(),
                            ),
                            pump.isNotEmpty ?
                            Column(
                              children: [
                                FormBuilderTextField(
                                  name: 'reading',
                                  decoration: InputDecoration(
                                      labelText: 'قراءة العداد'
                                  ),
                                  initialValue: pump.isNotEmpty ? pump['reading'].toString() : '',
                                  validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الحقول"),
                                ),
                                FormBuilderTextField(
                                  name: 'nw_read',
                                  decoration: InputDecoration(
                                      labelText: 'القراءة الجديدة'
                                  ),
                                  validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الحقول"),
                                ),
                                FormBuilderDateTimePicker(
                                  name: 'date',
                                  decoration: InputDecoration(
                                      labelText: 'التاريخ',
                                      suffixIcon: Icon(Icons.calendar_month, color: Colors.blueAccent,)
                                  ),
                                  validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الحقول"),
                                  initialDate: DateTime.now(),
                                  initialValue: DateTime.now(),
                                  inputType: InputType.date,
                                ),
                              ],
                            ) : Text(''),
                            SizedBox(height: 40,),
                            // Add a submit button
                            SizedBox(
                              width: 100,
                              height: 40,
                              child: ElevatedButton(
                                child: Text('ارسال', style: TextStyle(fontSize: 18, color: Colors.white),),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.saveAndValidate()) {
                                    var data = {};
                                    data['pump_id'] = selectedPump_id;
                                    data['reading'] = _formKey.currentState!.value['reading'];
                                    data['nw_reading'] = _formKey.currentState!.value['nw_read'];
                                    data['date'] = _formKey.currentState!.value['date'].toIso8601String();
                                    //------
                                    addReading(data);
                                    //reset form
                                    _formKey.currentState!.reset();
                                    //setState
                                    setState(() {
                                      pump = {};
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
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
