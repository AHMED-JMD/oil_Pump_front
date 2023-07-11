import 'package:flutter/material.dart';
import 'package:oil_pump_system/components/appBar.dart';
import 'package:oil_pump_system/components/side_bar.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class AddDaily extends StatefulWidget {
  const AddDaily({Key? key}) : super(key: key);

  @override
  State<AddDaily> createState() => _AddDailyState();
}

class _AddDailyState extends State<AddDaily> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: APPBAR(),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: Row(
            children: [
              Row(
                children: [
                  Navbar()
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
                                      // onChanged: (val) {
                                      //   print(val); // Print the text value write into TextField
                                      // },
                                      validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                                    ),
                                    // Add another text field
                                    FormBuilderTextField(
                                      name: 'amount',
                                      decoration: InputDecoration(labelText: 'المبلغ'),
                                      // onChanged: (val) {
                                      //   print(val); // Print the text value write into TextField
                                      // },
                                      validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                                    ),
                                    FormBuilderDropdown(
                                      name: 'status',
                                      decoration: InputDecoration(labelText: 'الحالة'),
                                      validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                                      // onChanged: (val) {
                                      //   print(val); // Print the text value write into TextField
                                      // },
                                      items: ['مدين', 'دائن',]
                                          .map((status) => DropdownMenuItem(
                                        value: status,
                                        child: Text('$status'),
                                      ))
                                          .toList(),
                                    ),
                                    FormBuilderDateTimePicker(
                                      name: 'date',
                                      decoration: InputDecoration(
                                        labelText: 'التاريخ',
                                      ),
                                      validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                                      initialDate: DateTime.now(),
                                      inputType: InputType.date,
                                    ),
                                    FormBuilderTextField(
                                      name: 'comment',
                                      decoration: InputDecoration(labelText: 'التعليق'),
                                      // onChanged: (val) {
                                      //   print(val); // Print the text value write into TextField
                                      // },
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
                                            print(_formKey.currentState!.value);
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
