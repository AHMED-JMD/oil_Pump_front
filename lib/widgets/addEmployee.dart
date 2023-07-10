import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
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
                    child: Container(
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: FormBuilder(
                                // Define the form key to identify the form
                                key: _formKey,
                                // Define the form fields
                                child: Column(
                                  children: [
                                    // Add a text field
                                    FormBuilderTextField(
                                      name: 'name',
                                      decoration: InputDecoration(labelText: 'Name'),
                                      onChanged: (val) {
                                        print(val); // Print the text value write into TextField
                                      },
                                    ),
                                    // Add another text field
                                    FormBuilderTextField(
                                      name: 'email',
                                      decoration: InputDecoration(labelText: 'Email'),
                                      onChanged: (val) {
                                        print(val); // Print the text value write into TextField
                                      },
                                    ),
                                    // Add a dropdown field
                                    FormBuilderDropdown(
                                      name: 'gender',
                                      decoration: InputDecoration(labelText: 'Gender'),
                                      onChanged: (val) {
                                        print(val); // Print the text value write into TextField
                                      },
                                      items: ['Male', 'Female', 'Other']
                                          .map((gender) => DropdownMenuItem(
                                        value: gender,
                                        child: Text('$gender'),
                                      ))
                                          .toList(),
                                    ),
                                    // Add a submit button
                                    TextButton(
                                      child: Text('Submit'),
                                      onPressed: () {
                                        // if (_formKey.currentState.saveAndValidate()) {
                                        //   print(_formKey.currentState.value);
                                        // }
                                      },
                                    ),
                                  ],
                                ),
                              )
                            ),
                          )
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
