import 'package:flutter/material.dart';

class private_room extends StatefulWidget {
  const private_room({super.key});

  @override
  State<private_room> createState() => _private_roomState();
}

class _private_roomState extends State<private_room> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Private Room"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(170, 15),
                backgroundColor: Color(0xff0a3a0b),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                showDialog(context: context, builder: (context)=>AlertDialog(
                  shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  title: Text("Create room",style: TextStyle(color:Color(0xff0a3a0b),fontWeight: FontWeight.bold),),
                  content: Container(
                    height: 150,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextField(
                            decoration: InputDecoration(
                              labelText: "Room ID",
                            ),
                          ),
                          TextField(
                            decoration: InputDecoration(
                              labelText: "Room Pass",
                            ),
                          ),
                          ]
                      ),
                  ),
                  actions: [
                    TextButton(onPressed: ()
                    {
                      Navigator.pop(context);
                    }, child: Text("Cancel")),

                    TextButton(onPressed: ()
                    {
                      Navigator.pop(context);
                    }, child: Text("Create"))
                  ],

                ));
                // Navigator.of(context).pushReplacement(
                //   MaterialPageRoute(builder: (context) => ),
                // );
              },
              child: const Text(
                "Create Room",
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(170, 15),
                backgroundColor: Color(0xff0a3a0b),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                showDialog(context: context, builder: (context)=>AlertDialog(
                  shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  title: Text("Join room",style: TextStyle(color:Color(0xff0a3a0b),fontWeight: FontWeight.bold),),
                  content: Container(
                    height: 150,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextField(
                            decoration: InputDecoration(
                              labelText: "Room ID",
                            ),
                          ),
                          TextField(
                            decoration: InputDecoration(
                              labelText: "Room Pass",
                            ),
                          ),
                        ]
                    ),
                  ),
                  actions: [
                    TextButton(onPressed: ()
                    {
                      Navigator.pop(context);
                    }, child: Text("Cancel")),

                    TextButton(onPressed: ()
                    {
                      Navigator.pop(context);
                    }, child: Text("Enter"))
                  ],

                ));
                // Navigator.of(context).pushReplacement(
                //   MaterialPageRoute(builder: (context) => ),
                // );
              },
              child: const Text(
                "Enter Room",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
