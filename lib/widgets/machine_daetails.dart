import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:OilEnergy_System/API/pump.dart';
import 'package:OilEnergy_System/SharedService.dart';
import 'package:OilEnergy_System/components/appBar.dart';
import 'package:OilEnergy_System/components/side_bar.dart';
import 'package:sidebarx/sidebarx.dart';

class Machine_Detail extends StatefulWidget {
  String pump_id;
  Machine_Detail({super.key, required this.pump_id});

  @override
  State<Machine_Detail> createState() => _Machine_DetailState(pump_id: pump_id);
}

class _Machine_DetailState extends State<Machine_Detail> {
  String pump_id;
  _Machine_DetailState({required this.pump_id});

  GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  SidebarXController controller = SidebarXController(selectedIndex: 5, extended: true);

  bool isLoading = false;
  Map pump_data = {};

  @override
  void initState() {
    GetPump();
    super.initState();
  }

//server side add
  Future GetPump() async{
    setState(() {
      isLoading = true;
    });
    //call server here
    Map data = {};
    data['pump_id'] = pump_id;

    final auth = await SharedServices.LoginDetails();
    final response = await API_Pump.GetPump(data, auth.token);

    setState(() {
      isLoading = false;
      pump_data = response;
    });
  }
  Future _OnSubmit (data) async {
    setState(() {
      isLoading = true;
    });
    //call server here
    final auth = await SharedServices.LoginDetails();
    final response = await API_Pump.UpdatePumpData(data, auth.token);

    setState(() {
      isLoading = false;
    });

    response != false ?
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم تعديل المكنة بنجاح', textAlign: TextAlign.center, style: TextStyle(fontSize: 17),),
        backgroundColor: Colors.green,
      ),
    ) :
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('حدث خطأ ما', textAlign: TextAlign.center, style: TextStyle(fontSize: 17),),
        backgroundColor: Colors.red,
      ),
    );
    GetPump();
  }
//--------------------------------------------

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
                    pump_data.isNotEmpty ?
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
                                name: 'type',
                                decoration: InputDecoration(
                                    labelText: 'نوع المكنة'
                                ),
                                validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                                initialValue: pump_data.isNotEmpty ? '${pump_data['type']}': '',
                                items: ['جازولين', 'بنزين'].map((value) =>
                                    DropdownMenuItem(
                                      value: value,
                                      child: Text('$value'),
                                    )
                                ).toList()
                            ),
                            FormBuilderTextField(
                              name: 'name',
                              decoration: InputDecoration(
                                  labelText: 'اسم / رقم المكنة'
                              ),
                              initialValue: pump_data.isNotEmpty ? '${pump_data['name']}': '',
                              validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                            ),
                            FormBuilderTextField(
                              name: 'reading',
                              decoration: InputDecoration(
                                  labelText: 'قراءة العداد'
                              ),
                              initialValue: pump_data.isNotEmpty ? '${pump_data['reading']}': '',
                              validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                            ),
                            FormBuilderTextField(
                              name: 'price',
                              decoration: InputDecoration(
                                  labelText: 'سعر اللتر'
                              ),
                              initialValue: pump_data.isNotEmpty ? '${pump_data['price']}': '',
                              validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                            ),
                            SizedBox(height: 40,),
                            // Add a submit button
                            SizedBox(
                              width: 100,
                              height: 40,
                              child: ElevatedButton(
                                child: Text('تعديل'),
                                style: ElevatedButton.styleFrom(
                                    textStyle: TextStyle(fontSize: 18)
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.saveAndValidate()) {
                                    final data = {};
                                    data['pump_id'] = pump_id;
                                    data['type'] = _formKey.currentState!.value['type'];
                                    data['name'] = _formKey.currentState!.value['name'];
                                    data['reading'] = _formKey.currentState!.value['reading'];
                                    data['price'] = _formKey.currentState!.value['price'];

                                    //------
                                    _OnSubmit(data);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ) : Center(
                      child: CircularProgressIndicator(),
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
