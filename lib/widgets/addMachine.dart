import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:OilEnergy_System/API/pump.dart';
import 'package:OilEnergy_System/SharedService.dart';
import 'package:OilEnergy_System/components/appBar.dart';
import 'package:OilEnergy_System/components/side_bar.dart';
import 'package:sidebarx/sidebarx.dart';

class AddMachine extends StatefulWidget {
  const AddMachine({super.key});

  @override
  State<AddMachine> createState() => _AddMachineState();
}

class _AddMachineState extends State<AddMachine> {
  GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  SidebarXController controller = SidebarXController(selectedIndex: 5, extended: true);

  bool isLoading = false;

//server side add
  Future _OnSubmit (data) async {
    setState(() {
      isLoading = true;
    });
    //call server here
    final auth = await SharedServices.LoginDetails();
    final response = await API_Pump.AddPump(data, auth.token);

    setState(() {
      isLoading = false;
    });
    response != false ?
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم اضافة المكنة بنجاح', textAlign: TextAlign.center, style: TextStyle(fontSize: 17),),
          backgroundColor: Colors.green,
        ),
      ) :
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('جدث خطأ ما', textAlign: TextAlign.center, style: TextStyle(fontSize: 17),),
        backgroundColor: Colors.red,
      ),
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
                                    validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                                  ),
                                  FormBuilderTextField(
                                    name: 'reading',
                                    decoration: InputDecoration(
                                      labelText: 'قراءة العداد'
                                    ),
                                    validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                                  ),
                                  FormBuilderTextField(
                                    name: 'price',
                                    decoration: InputDecoration(
                                        labelText: 'سعر اللتر'
                                    ),
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
                                          final data = _formKey.currentState!.value;

                                          //------
                                          _OnSubmit(data);
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
