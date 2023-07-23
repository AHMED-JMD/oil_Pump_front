import 'package:flutter/material.dart';
import 'package:oil_pump_system/components/appBar.dart';
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
  List data = [];

  //initial state function
  @override
  void initState() {
    super.initState();
    getAllPumps();
  }

  //server side function
  Future getAllPumps() async{
    setState(() {
      isLoading = true;
    });

    //call server
    final response = await API_Pump.GetAllPump();
    setState(() {
      isLoading = false;
      data = response;
    });
  }

  //widgget Function
  Widget Pumps(BuildContext context, data){
         return
           Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 20, 0),
              child: Container(
                height: 120,
                width: 300,
                decoration: BoxDecoration(
                    color: data['type'] == 'جاز' ? Colors.lightGreenAccent : Colors.lightBlueAccent,
                    borderRadius: BorderRadius.circular(12)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${data['name']}'),
                    Text('${data['reading']}'),
                    Text('${data['type']}'),
                    SizedBox(height: 10,),
                    ElevatedButton(
                        onPressed: (){
                          _openModal(context, data);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black54
                        ),
                        child: Text('قراءة جديدة')
                    ),
                    SizedBox(height: 10,),
                  ],
                ),
              ),
            );
  }

  //modal open
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
                        // onChanged: (val) {
                        //   print(val); // Print the text value write into TextField
                        // },
                        validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                      ),
                      FormBuilderTextField(
                        name: 'amount',
                        decoration: InputDecoration(labelText: 'المباع'),
                        // onChanged: (val) {
                        //   print(val); // Print the text value write into TextField
                        // },
                        initialValue: '0',
                        validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                      ),
                      FormBuilderTextField(
                        name: 'value',
                        decoration: InputDecoration(labelText: 'القيمة'),
                        // onChanged: (val) {
                        //   print(val); // Print the text value write into TextField
                        // },
                        initialValue: '0',
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
                Navbar(controller: controller),
              ],
            ),
            Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      GridView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: data.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3
                        ),
                        itemBuilder: (context, index) =>Row(
                          children: [
                            Pumps(context, data[index])
                          ]
                        ),
                      ),
                      Container(
                          color: Colors.grey.shade100,
                          child: DailyTable()
                      ),
                      SizedBox(height: 50,)
                    ],
                  ),
                )
            )
          ],
        ),
      ),
    );
  }
}
