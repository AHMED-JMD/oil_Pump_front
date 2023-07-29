import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:oil_pump_system/API/daily.dart';
import 'package:oil_pump_system/SharedService.dart';
import 'package:oil_pump_system/components/appBar.dart';
import 'package:oil_pump_system/components/side_bar.dart';
import 'package:oil_pump_system/components/tables/clientDetailsTable.dart';
import 'package:sidebarx/sidebarx.dart';

class OldDailys extends StatefulWidget {
  const OldDailys({super.key});

  @override
  State<OldDailys> createState() => _OldDailysState();
}

class _OldDailysState extends State<OldDailys> {
  SidebarXController controller = SidebarXController(selectedIndex: 0, extended: true);
  GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  bool isLoading = false;
  List data = [];

  //server side function
  Future GetDaily (date) async{
    setState(() {
      isLoading = true;
    });
    //post to server
    Map datas = {};
    datas['date'] = date.toIso8601String();

    final auth = await SharedServices.LoginDetails();
    final response = await API_Daily.get_Daily(datas, auth.token);

    setState(() {
      isLoading = false;
      data = response;
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
            Navbar(controller: controller),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: FormBuilder(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 400,
                          child: FormBuilderDateTimePicker(
                              name: "date",
                              decoration: InputDecoration(
                                labelText: "اختر اليوم",
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 5,
                                  ),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                suffixIcon: Icon(Icons.calendar_month, color: Colors.blueAccent,)
                              ),
                              onChanged: (value){
                                GetDaily(value);
                              },
                              validator: FormBuilderValidators.required(errorText: "الرجاء اختيار تاريخ محدد"),
                              initialDate: DateTime.now(),
                              inputType: InputType.date,
                          ),
                        ),
                        SizedBox(height: 40,),
                        data.length != 0 ?
                            Container(
                                color: Colors.grey[100],
                                child: ClientDetailsTable(data: data)
                            )
                            : Center(
                              child: Text('لا يوجد يومية في هذا اليوم', style: TextStyle(fontSize: 18),))
                      ],
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
