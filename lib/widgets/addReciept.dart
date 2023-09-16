import 'package:flutter/material.dart';
import 'package:OilEnergy_System/API/reciept.dart';
import 'package:OilEnergy_System/SharedService.dart';
import 'package:OilEnergy_System/components/appBar.dart';
import 'package:OilEnergy_System/components/side_bar.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:sidebarx/sidebarx.dart';

class AddReciept extends StatefulWidget {
  const AddReciept({super.key});

  @override
  State<AddReciept> createState() => _AddRecieptState();
}

class _AddRecieptState extends State<AddReciept> {
  SidebarXController controller = SidebarXController(selectedIndex: 7, extended: true);

  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  bool isLoading = false;
  String? company;
  String? source;
  String? driver;
  String? car_plate;
  String? fuel_type;
  String? amount;
  DateTime? ship_date;
  DateTime? arrive_date;

  Future _OnSubmit(data) async {
    setState(() {
      isLoading = true;
    });

    //call backend
    final auth = await SharedServices.LoginDetails();

    API_Reciept.Add_Reciept(data, auth.token).then((response){
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
                            name: "company",
                            decoration: InputDecoration(
                                labelText: 'اسم الشركة',
                                suffixIcon: Icon(Icons.home_work, color: Colors.blueAccent,)
                            ),
                            onChanged: (val){
                              company = val;
                            },
                            validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                          ),
                          FormBuilderTextField(
                            name: "source",
                            decoration: InputDecoration(
                                labelText: 'مصدر الشحن',
                                suffixIcon: Icon(Icons.location_on, color: Colors.blueAccent,)
                            ),
                            onChanged: (val){
                              source = val;
                            },
                            validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                          ),
                          FormBuilderTextField(
                            name: "driver",
                            decoration: InputDecoration(
                              labelText: 'السائق',
                                suffixIcon: Icon(Icons.person, color: Colors.blueAccent,)
                              ),
                            onChanged: (val){
                              driver = val;
                            },
                            validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                        ),
                          FormBuilderTextField(
                            name: "car_plate",
                            decoration: InputDecoration(
                                labelText: 'رقم اللوحة',
                                suffixIcon: Icon(Icons.car_crash_outlined, color: Colors.blueAccent,)
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
                            items: ['بنزين', 'جازولين']
                                .map((type) => DropdownMenuItem(
                              value: type,
                              child: Text('$type'),
                            ))
                                .toList(),
                          ),
                          FormBuilderTextField(
                            name: "amount",
                            decoration: InputDecoration(
                                labelText: 'كمية الوقود باللتر',
                              suffixIcon: Icon(Icons.gas_meter_outlined, color: Colors.blueAccent,)
                            ),
                            onChanged: (val){
                              amount = val;
                            },
                            validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                          ),
                          FormBuilderDateTimePicker(
                            name: 'ship_date',
                            decoration: InputDecoration(
                              labelText: 'تاريخ الشحن',
                              suffixIcon: Icon(Icons.calendar_month,  color: Colors.blueAccent)
                            ),
                            onChanged: (val){
                              ship_date = val;
                            },
                            validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                            initialDate: DateTime.now(),
                            inputType: InputType.date,
                          ),
                          FormBuilderDateTimePicker(
                            name: 'arrive_date',
                            decoration: InputDecoration(
                                labelText: 'تاريخ الوصول',
                                suffixIcon: Icon(Icons.calendar_month,  color: Colors.blueAccent)
                            ),
                            onChanged: (val){
                              arrive_date = val;
                            },
                            validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                            initialDate: DateTime.now(),
                            inputType: InputType.date,
                          ),
                          SizedBox(height: 40,),
                          SizedBox(
                            height: 45,
                            width: 200,
                            child: ElevatedButton(
                              onPressed: (){
                                if(_formKey.currentState!.saveAndValidate()){
                                  //call to server
                                  final data = {};
                                  data['company'] = company;
                                  data['source'] = source;
                                  data['driver'] = driver;
                                  data['car_plate'] = car_plate;
                                  data['fuel_type'] = fuel_type;
                                  data['amount'] = amount;
                                  data['ship_date'] = ship_date!.toIso8601String();
                                  data['arrive_date'] = arrive_date!.toIso8601String();

                                  _OnSubmit(data);
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
