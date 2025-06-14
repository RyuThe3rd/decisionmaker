import 'package:flutter/material.dart';

class LabeledTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;

  const LabeledTextField({
    required this.label,
    required this.hintText,
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.loose,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            //width: double.infinity, //adicionei agora
            decoration: BoxDecoration(
              color: Color.fromARGB(200, 175, 160, 221),
              border: Border(
                  bottom: BorderSide(color: Colors.black)),

              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(6),
                topRight: Radius.circular(6),
                bottomLeft: Radius.circular(0),
                bottomRight: Radius.circular(0),
              ),
            ),
            child: Container(
              child: Column(
                children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 1.0, bottom: 0, ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 13.0, bottom: 2, top: 12),
                            child: Container(
                              child: FittedBox(
                                child: Text(
                                  label,
                                  softWrap: true,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFD373333),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  ///quando adiciono Flexible como pai do textfield dá erro
                  TextField(
                    controller: controller,
                    decoration: InputDecoration(

                      hint: Row(
                        children: [
                          Text(hintText, style: TextStyle(
                            fontSize: 22,
                            color: Colors.black,
                          ),),
                        ],
                      ),
                      isDense: true,
                      border: InputBorder.none,
                      /*hintText: hintText,
                      hintStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                      ),*/
                      contentPadding: EdgeInsets.only (left: 14, top: 0, bottom: 20),
                    ),
                    style: TextStyle(

                      fontSize: 22,
                      color: Colors.black,
                    ),

                  ),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}