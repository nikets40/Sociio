import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nixmessenger/UI/Shared/styles.dart';

class MobileNumberField extends StatelessWidget {
  final TextEditingController textEditingController;
  final Function(String) countryCode;
  final String initialSelection;

  MobileNumberField(
      {@required this.textEditingController,
      this.countryCode,
      this.initialSelection});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screenWidth(context),
      child: Row(
        children: [
          CountryCodePicker(
            searchStyle: TextStyle(color: Colors.black),
            onChanged: (code) {
              print("Selected Country code is $code");
              countryCode(code.toString());
            },
            textStyle: TextStyle(color: Colors.white),
            dialogTextStyle: TextStyle(color: Colors.black),
            initialSelection: initialSelection,
            showCountryOnly: false,
            showOnlyCountryWhenClosed: false,
            alignLeft: false,
          ),
          Flexible(
              child: TextField(
            style: TextStyle(color: Colors.white),
            inputFormatters: [LengthLimitingTextInputFormatter(10)],
            controller: textEditingController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
                hintText: "phone number",
                hintStyle: TextStyle(color: Colors.white54)),
          ))
        ],
      ),
    );
  }

}
