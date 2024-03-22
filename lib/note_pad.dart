import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';

class NotePad extends StatefulWidget {
  const NotePad({super.key});

  @override
  State<NotePad> createState() => _NotePadState();
}

class _NotePadState extends State<NotePad> {
  Box? notepads;
  TextEditingController _controller = TextEditingController();
  TextEditingController _updatecontroller = TextEditingController();
  @override
  void initState() {
    notepads = Hive.box('notepad');
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text(
            'Note Pad',
            style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 50),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(hintText: 'Write Somting'),
              ),
            ),
            SizedBox(
                width: 300,
                child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () async {
                      try {
                        final userinput = _controller.text;
                        await notepads!.add(userinput);
                        _controller.clear();
                        Fluttertoast.showToast(msg: 'Add Successfull');
                      } catch (e) {
                        Fluttertoast.showToast(msg: e.toString());
                      }
                    },
                    child: Text(
                      'add new data',
                      style: TextStyle(color: Colors.white),
                    ))),
            Expanded(
                child: ValueListenableBuilder(
                    valueListenable: Hive.box('notepad').listenable(),
                    builder: (context, box, widget) {
                      return ListView.builder(
                          itemCount: notepads!.keys.toList().length,
                          itemBuilder: (_, Index) {
                            return Card(
                              elevation: 5,
                              child: ListTile(
                                title: Text(notepads!.getAt(Index).toString()),
                                trailing: SizedBox(
                                  width: 100,
                                  child: Row(
                                    children: [
                                      IconButton(
                                          onPressed: () async {
                                            showDialog(
                                                context: context,
                                                builder: (_) {
                                                  return Dialog(
                                                    child: Container(
                                                      height: 200,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Column(
                                                          children: [
                                                            TextField(
                                                              controller:
                                                                  _updatecontroller,
                                                              decoration:
                                                                  InputDecoration(
                                                                hintText:
                                                                    'Write Somthing',
                                                              ),
                                                            ),
                                                            ElevatedButton(
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                        backgroundColor:
                                                                            Colors
                                                                                .green),
                                                                onPressed:
                                                                    () async {
                                                                  final updateData =
                                                                      _updatecontroller
                                                                          .text;
                                                                  notepads!.putAt(
                                                                      Index,
                                                                      updateData);
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: Text(
                                                                  'Update Data',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ))
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                });
                                          },
                                          icon: Icon(Icons.edit)),
                                      IconButton(
                                          onPressed: () async {
                                            await notepads!.deleteAt(Index);
                                            Fluttertoast.showToast(
                                                msg: 'Delete Successfull');
                                          },
                                          icon: Icon(Icons.delete))
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    }))
          ],
        ));
  }
}
