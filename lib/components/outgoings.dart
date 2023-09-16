import 'package:flutter/material.dart';
import 'package:OilEnergy_System/API/outgoing.dart';
import 'package:OilEnergy_System/SharedService.dart';

class Outgoings extends StatefulWidget {
  final int total;
  final List data;
  Outgoings({super.key, required this.total, required this.data});

  @override
  State<Outgoings> createState() => _OutgoingsState(total: total, data: data);
}

class _OutgoingsState extends State<Outgoings> {
  int total;
  List data;
  _OutgoingsState({required this.total, required this.data});

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  //server side function
  Future delete_OutG (outg_id) async {

    setState(() {
      isLoading = true;
    });
    //server post
    final data = {};
    data['outg_id'] = outg_id;
    final auth = await SharedServices.LoginDetails();
    final response = await API_OutG.Delete_OutG(data, auth.token);

    setState(() {
      isLoading = false;
    });
    response != false ? ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم الحذف بنجاح', textAlign: TextAlign.center, style: TextStyle(fontSize: 17),),
        backgroundColor: Colors.red,
      ),
    ) :
    SnackBar(
      content: Text('$response', textAlign: TextAlign.center, style: TextStyle(fontSize: 17),),
      backgroundColor: Colors.red,
    );

    await Future.delayed(Duration(milliseconds: 700));
    Navigator.pushReplacementNamed(context, '/dailys');
  }

  //modal widgets
  void _deleteModal(BuildContext context, data){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text('حذف المنصرف'),
            content: Text(' هل انت متأكد برغبتك في حذف المنصرف ${data['comment']}'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Center(
                  child: SizedBox(
                    height: 30,
                    child: TextButton(
                        child: Text('حذف'),
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            primary: Colors.white
                        ),
                        onPressed: (){
                          delete_OutG(data['outg_id']);
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

  @override
  Widget build(BuildContext context) {
    return data.length !=0 ?
    Column(
      children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('مجموع المنصرفات = ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 21
                    ),
                  ),
                  Text('$total',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 21,
                        color: Colors.red
                    ),
                  ),
                ],
              ),
          ),
        SizedBox(height: 10,),
        Container(
              width: MediaQuery.of(context).size.width/1.3,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8)
              ),
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index){
                  return Padding(
                    padding: EdgeInsets.all(5),
                    child: Card(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: ListTile(
                              leading: Icon(Icons.outbond),
                              title: Row(
                                children: [
                                  Text('${data[index]['comment']}', style: TextStyle(fontSize: 18)),
                                  SizedBox(width: 20,),
                                  Text('${data[index]['date']}',),
                                ],
                              ),
                              subtitle: Text(' القيمة : ${data[index]['amount'].toString()}', style: TextStyle(fontWeight: FontWeight.bold),),
                              trailing: InkWell(
                                  onTap: (){
                                    _deleteModal(context, data[index]);
                                  },
                                  child: Icon(Icons.delete, color: Colors.blue,)
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
      ],
    ) :
         Padding(
           padding: const EdgeInsets.all(10.0),
           child: Card(
             child: ListTile(
               leading: Icon(Icons.outbond),
               title: Text('لا يوجد منصرفات اليوم'),
             ),
           ),
         );
  }
}
