import 'package:flutter/material.dart';

Widget customTextFormField({
  required String label ,
  required TextEditingController controller ,
  bool obscure = false,
  Widget? suffixIcon ,
  Function(String?)? validator ,

}) => Container(
  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
  child: TextFormField(
        validator: (text) {
          if(validator != null) {
            return validator(text);
          }
        },
        obscureText: obscure,
        controller: controller,
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(),
          labelText: label,
        ),
      ),
);


Widget customElevatedButton({
 required Widget child ,
 required Function() onPress,
}) {
  return Container(
      height: 50,

      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: ElevatedButton(
        style: ButtonStyle(shape:MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.red)
            )
        )),
        child: child,
        onPressed:() => onPress,
      ));
}

