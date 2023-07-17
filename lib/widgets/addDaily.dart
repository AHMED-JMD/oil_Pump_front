import 'package:flutter/material.dart';
import 'package:oil_pump_system/API/daily.dart';
import 'package:oil_pump_system/components/appBar.dart';
import 'package:oil_pump_system/components/side_bar.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:sidebarx/sidebarx.dart';

class AddDaily extends StatefulWidget {
  const AddDaily({Key? key}) : super(key: key);

  @override
  State<AddDaily> createState() => _AddDailyState();
}

class _AddDailyState extends State<AddDaily> {
  SidebarXController controller = SidebarXController(selectedIndex: 0, extended: true);

  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  bool isLoading = false;
  DateTime? nw_date;
  String? name;
  String? type;
  String? amount;
  String? comment;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: APPBAR(context),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: Row(
            children: [
              Row(
                children: [
                  Navbar(controller: controller,)
                ],
              ),
              Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                        child:  Padding(
                              padding: const EdgeInsets.all(50.0),
                              child: FormBuilder(
                                // Define the form key to identify the form
                                key: _formKey,
                                // Define the form fields
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      child: Icon(Icons.edit_calendar_outlined),
                                      radius: 50,
                                      backgroundColor: Colors.grey.shade300,
                                    ),
                                    // Add a text field
                                    FormBuilderTextField(
                                      name: 'name',
                                      decoration: InputDecoration(labelText: 'الاسم'),
                                      onChanged: (val) {
                                        name = val; // Print the text value write into TextField
                                      },
                                      validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                                    ),
                                    FormBuilderDropdown(
                                      name: 'type',
                                      decoration: InputDecoration(labelText: 'الحالة'),
                                      validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                                      onChanged: (val) {
                                        type = val; // Print the text value write into TextField
                                      },
                                      items: ['مدين', 'دائن',]
                                          .map((type) => DropdownMenuItem(
                                        value: type,
                                        child: Text('$type'),
                                      ))
                                          .toList(),
                                    ),
                                    // Add another text field
                                    FormBuilderTextField(
                                      name: 'amount',
                                      decoration: InputDecoration(labelText: 'المبلغ'),
                                      onChanged: (val) {
                                        amount = val; // Print the text value write into TextField
                                      },
                                      validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                                    ),
                                    FormBuilderDateTimePicker(
                                      name: 'date',
                                      decoration: InputDecoration(
                                        labelText: 'التاريخ',
                                      ),
                                      onChanged: (value){
                                        nw_date = value;
                                      },
                                      validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                                      initialDate: DateTime.now(),
                                      inputType: InputType.date,
                                    ),
                                    FormBuilderTextField(
                                      name: 'comment',
                                      decoration: InputDecoration(labelText: 'البيان'),
                                      onChanged: (val) {
                                        comment = val; // Print the text value write into TextField
                                      },
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
                                            setState(() {
                                              isLoading = true;
                                            });

                                            //call to backend
                                            Map data = {};
                                            data['name'] = name;
                                            data['type'] = type;
                                            data['amount'] = amount;
                                            data['date'] = nw_date!.toIso8601String();
                                            data['comment'] = comment;

                                            API_Daily.Add_Daily(data).then((response){
                                              setState(() {
                                                isLoading = false;
                                              });

                                              if(response == true){
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text('تم اضافة اليومية بنجاح', textAlign: TextAlign.center, style: TextStyle(fontSize: 17),),
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
                                      ),
                                    ),
                                  ],
                                ),
                              )
                          ),
                    ),
                  ),
              )
            ],
          ),
        )
    );
  }
}
