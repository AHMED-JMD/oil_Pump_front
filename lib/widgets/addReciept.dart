import 'package:flutter/material.dart';
import 'package:oil_pump_system/API/reciept.dart';
import 'package:oil_pump_system/components/appBar.dart';
import 'package:oil_pump_system/components/side_bar.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:sidebarx/sidebarx.dart';

class AddReciept extends StatefulWidget {
  const AddReciept({super.key});

  @override
  State<AddReciept> createState() => _AddRecieptState();
}

class _AddRecieptState extends State<AddReciept> {
  SidebarXController controller = SidebarXController(selectedIndex: 0, extended: true);

  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  bool isLoading = false;
  String? driver;
  String? car_plate;
  String? fuel_type;
  String? amount;
  DateTime? date;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: APPBAR(context),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          children: [
            Navbar(controller: controller,),
            Expanded(child:
            ListView(
              children: [
                FormBuilder(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Column(
                        children: [
                          CircleAvatar(
                            child: Icon(Icons.money),
                            radius: 60,
                              backgroundColor: Colors.grey[300]
                          ),
                          FormBuilderTextField(
                            name: "driver",
                            decoration: InputDecoration(
                              labelText: 'اسم السائق'
                              ),
                            onChanged: (val){
                              driver = val;
                            },
                            validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                        ),
                          FormBuilderTextField(
                            name: "car_plate",
                            decoration: InputDecoration(
                                labelText: 'رقم اللوحة'
                            ),
                            onChanged: (val){
                              car_plate = val;
                            },
                            validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                          ),
                          // Add a dropdown field
                          FormBuilderDropdown(
                            name: 'fuel_type',
                            decoration: InputDecoration(labelText: 'نوع الوقود'),
                            validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                            onChanged: (val){
                              fuel_type = val;
                            },
                            items: ['بنزين', 'جاز']
                                .map((type) => DropdownMenuItem(
                              value: type,
                              child: Text('$type'),
                            ))
                                .toList(),
                          ),
                          FormBuilderTextField(
                            name: "amount",
                            decoration: InputDecoration(
                                labelText: 'كمية الوقود'
                            ),
                            onChanged: (val){
                              amount = val;
                            },
                            validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                          ),
                          FormBuilderDateTimePicker(
                            name: 'date',
                            decoration: InputDecoration(
                              labelText: 'التاريخ',
                            ),
                            onChanged: (val){
                              date = val;
                            },
                            validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                            initialDate: DateTime.now(),
                            inputType: InputType.date,
                          ),
                          SizedBox(height: 40,),
                          SizedBox(
                            height: 35,
                            child: ElevatedButton(
                              onPressed: (){
                                if(_formKey.currentState!.saveAndValidate()){
                                  setState(() {
                                    isLoading = true;
                                  });

                                  //call to server
                                  final data = {};
                                  data['driver'] = driver;
                                  data['car_plate'] = car_plate;
                                  data['fuel_type'] = fuel_type;
                                  data['amount'] = amount;
                                  data['date'] = date!.toIso8601String();

                                  API_Reciept.Add_Reciept(data).then((response){
                                    setState(() {
                                      isLoading = false;
                                    });
                                    if(response == true){
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('تم اضافة الايصال بنجاح', textAlign: TextAlign.center, style: TextStyle(fontSize: 17),),
                                          backgroundColor: Colors.green,
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
                              },
                              child: Text('ارسال'),
                              style: ElevatedButton.styleFrom(
                                textStyle: TextStyle(fontSize: 18)
                              ),
                            ),
                          )
                  ],
                ),
                    ))
              ],
            ))
          ],
        ),
      ),
    );
  }
}
