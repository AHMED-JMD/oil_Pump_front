import 'package:OilEnergy_System/API/pump.dart';
import 'package:OilEnergy_System/SharedService.dart';
import 'package:OilEnergy_System/components/appBar.dart';
import 'package:OilEnergy_System/components/side_bar.dart';
import 'package:OilEnergy_System/widgets/machine_daetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:sidebarx/sidebarx.dart';

class Machine_Pumps extends StatefulWidget {
  const Machine_Pumps({super.key});

  @override
  State<Machine_Pumps> createState() => _Machine_PumpsState();
}

class _Machine_PumpsState extends State<Machine_Pumps> {

  SidebarXController controller = SidebarXController(selectedIndex: 6, extended: true);
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  DateTime today_date = DateTime.now();
  bool isLoading = false;
  List data = [];
  int benz_price = 0;
  int gas_price = 0;

  @override
  void initState() {
    getAllPumps();
    super.initState();
  }

  //server side function
  Future getAllPumps() async{
    setState(() {
      isLoading = true;
      data = [];
    });

    //call server
    final auth = await SharedServices.LoginDetails();
    final response = await API_Pump.GetAllPump(auth.token);

    setState(() {
      isLoading = false;
      data = response['pumps'];
      benz_price = response['benz_price'];
      gas_price = response['gas_price'];
    });
  }
  //update price
  Future update_price(data) async{
    setState(() {
      isLoading = true;
    });

    //call server
    final auth = await SharedServices.LoginDetails();
    final response = await API_Pump.Update_Price(data, auth.token);

    response != false ? ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم تعديل السعر', textAlign: TextAlign.center, style: TextStyle(fontSize: 17),),
        backgroundColor: Colors.green,
      ),
    )
        :
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$response', textAlign: TextAlign.center, style: TextStyle(fontSize: 17),),
          backgroundColor: Colors.red,
        )
    );

    //refresh page
    getAllPumps();
  }

  Future deletePump (pumpId) async {
    setState(() {
      isLoading = true;
    });
    //server post
    final data = {};
    data['pump_id'] = pumpId;
    final auth = await SharedServices.LoginDetails();
    final response = await API_Pump.DeletePump(data, auth.token);

    setState(() {
      isLoading = false;
    });
    response != false ? ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم الحذف بنجاح', textAlign: TextAlign.center, style: TextStyle(fontSize: 17),),
        backgroundColor: Colors.red,
      ),
    )
        :
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$response', textAlign: TextAlign.center, style: TextStyle(fontSize: 17),),
          backgroundColor: Colors.red,
        )
    );

    //refresh
    getAllPumps();
  }
  //---------------------------------------

  //widgget Function
  Widget Pumps(BuildContext context, data, height){
    return
      Padding(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 40),
        child: Container(
          height: height,
          decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: data['type'] == 'جازولين' ? Colors.green : Colors.red,
                  width: 3
              )
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${data['type']}'),
              SizedBox(height: 5,),
              Text('اسم المكنة : ${data['name']}'),
              Text('القراءة : ${data['reading']}'),
              Text('السعر : ${data['price']}', style: TextStyle(fontSize: 18)),

              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => Machine_Detail(pump_id: data['pump_id'],))
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black54
                      ),
                      child: Text('تعديل البيانات', style: TextStyle(color: Colors.white),)
                  ),
                  SizedBox(width: 10,),
                  InkWell(
                      onTap: (){
                        _deleteModal(context, data);
                      },
                      child: Icon(Icons.delete, color: Colors.redAccent,)
                  ),

                ],
              ),
              SizedBox(height: 10,),
            ],
          ),
        ),
      );
  }

  // modals functions
  void _deleteModal(BuildContext context, data){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text('حذف المكنة'),
            content: Text(' هل انت متأكد برغبتك في حذف المكنة ${data['name']}'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Center(
                  child: SizedBox(
                    height: 30,
                    width: 100,
                    child: TextButton(
                        child: Text('حذف', style: TextStyle(color: Colors.white),),
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                        ),
                        onPressed: (){
                          deletePump(data['pump_id']);
                          Navigator.of(context).pop();
                        }
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  //-------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: APPBAR(context),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          children: [
            Navbar(controller: controller,),
            data.length !=0 ?
            Expanded(
                child:ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width/6,
                            height: 50,
                            child: ElevatedButton.icon(
                                onPressed: (){
                                  Navigator.pushReplacementNamed(context, '/add_machine');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue
                                ),
                                icon: Icon(Icons.add),
                                label: Text('اضافة عداد', style: TextStyle(fontSize: 18, color: Colors.white),)
                            ),
                          ),
                          FormBuilder(
                            key: _formKey,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    height:70,
                                    width: 200,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Center(
                                      child: FormBuilderTextField(
                                        name: 'benz_price',
                                        decoration: InputDecoration(labelText: 'سعر لتر البنزين'),
                                        initialValue: benz_price.toString(),
                                        validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                                      ),
                                    )
                                ),
                                SizedBox(width: 15,),
                                Container(
                                  height:70,
                                  width: 200,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12)
                                  ),
                                  child: Center(
                                    child: FormBuilderTextField(
                                      name: 'gas_price',
                                      decoration: InputDecoration(labelText: 'سعر لتر الجازولين'),
                                      initialValue: gas_price.toString(),
                                      validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20,),
                                ElevatedButton(
                                    onPressed: (){
                                      if(_formKey.currentState!.saveAndValidate()){
                                        //call backend function
                                        update_price(_formKey.currentState!.value);
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        minimumSize: Size(100, 50),
                                        backgroundColor: Colors.blueGrey
                                    ),
                                    child: Text('تعديل', style: TextStyle(color: Colors.white),),
                                )
                              ],
                            ),
                          ),
                        ],
                      )
                    ),
                    SizedBox(height: 40,),
                    LayoutBuilder(
                        builder: (BuildContext context, BoxConstraints constraints ){
                          if(constraints.maxWidth > 800){
                            return GridView.builder(
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                itemCount: data.length,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  childAspectRatio: 0.75,
                                ),
                                itemBuilder: (context, index) =>
                                    Pumps(context, data[index], 300.0)
                            );
                          }else if(constraints.maxWidth > 600){
                            return GridView.builder(
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                itemCount: data.length,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: 0.75,
                                ),
                                itemBuilder: (context, index) =>
                                    Pumps(context, data[index], 200.0)
                            );
                          }else{
                            return GridView.builder(
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                itemCount: data.length,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.75,
                                ),
                                itemBuilder: (context, index) =>
                                    Pumps(context, data[index], 300.0)
                            );
                          }
                        }
                    )
                  ],
                )
            ) : Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Center(
                      child: Text('لا يوجد مكنات', style: TextStyle(fontSize: 22),),
                    ),
                    ElevatedButton.icon(
                        onPressed: (){
                          Navigator.pushReplacementNamed(context, '/add_machine');
                        },
                        icon: Icon(Icons.add),
                        label: Text('اضافة مكنة')
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
