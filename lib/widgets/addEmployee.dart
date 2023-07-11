import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:oil_pump_system/components/appBar.dart';
import 'package:oil_pump_system/components/side_bar.dart';

class AddEmployee extends StatefulWidget {
  const AddEmployee({Key? key,}) : super(key: key);

  @override
  State<AddEmployee> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
            appBar: APPBAR(),
            body: Directionality(
              textDirection: TextDirection.rtl,
              child: Row(
                children: [
                  Row(
                    children: [
                      Navbar(),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: Padding(
                                padding: const EdgeInsets.all(50.0),
                                child: FormBuilder(
                                  // Define the form key to identify the form
                                  key: _formKey,
                                  // Define the form fields
                                  child: Column(
                                    children: [
                                      CircleAvatar(
                                        child: Icon(Icons.person),
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
                                        name: 'Ssn',
                                        decoration: InputDecoration(labelText: 'الرقم الوطني'),
                                        // onChanged: (val) {
                                        //   print(val); // Print the text value write into TextField
                                        // },
                                        validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                                      ),

                                      FormBuilderTextField(
                                        name: 'phoneNum',
                                        decoration: InputDecoration(labelText: 'رقم الهاتف'),
                                        // onChanged: (val) {
                                        //   print(val); // Print the text value write into TextField
                                        // },
                                        validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                                      ),
                                      FormBuilderTextField(
                                        name: 'address',
                                        decoration: InputDecoration(labelText: 'السكن'),
                                        // onChanged: (val) {
                                        //   print(val); // Print the text value write into TextField
                                        // },
                                        validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                                      ),
                                      FormBuilderTextField(
                                        name: 'salary',
                                        decoration: InputDecoration(labelText: 'الراتب'),
                                        // onChanged: (val) {
                                        //   print(val); // Print the text value write into TextField
                                        // },
                                        validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                                      ),
                                      // Add a dropdown field
                                      FormBuilderDropdown(
                                        name: 'gender',
                                        decoration: InputDecoration(labelText: 'Gender'),
                                        validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                                        // onChanged: (val) {
                                        //   print(val); // Print the text value write into TextField
                                        // },
                                        items: ['Male', 'Female',]
                                            .map((gender) => DropdownMenuItem(
                                          value: gender,
                                          child: Text('$gender'),
                                        ))
                                            .toList(),
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
                            )
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

const canvasColor = Color(0xFF2E2E48);