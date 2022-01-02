import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class PhoneNumberField extends StatefulWidget {
  const PhoneNumberField({required TextEditingController controller, Key? key})
      : _controller = controller,
        super(key: key);
  final TextEditingController _controller;
  @override
  State<PhoneNumberField> createState() => _PhoneNumberFieldState();
}

class _PhoneNumberFieldState extends State<PhoneNumberField> {
  void _onListener() => setState(() {});
  @override
  void initState() {
    widget._controller.addListener(_onListener);
    super.initState();
  }

  @override
  void dispose() {
    widget._controller.removeListener(_onListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InternationalPhoneNumberInput(
      onInputChanged: (PhoneNumber number) {
        widget._controller.text = number.phoneNumber!;
      },
      onInputValidated: (bool value) {
        print(value);
      },
      selectorConfig: SelectorConfig(
        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
        trailingSpace: true,
        leadingPadding: 0,
      ),
      ignoreBlank: true,
      // textFieldController: controller,
      formatInput: false,
      keyboardType: TextInputType.numberWithOptions(
        signed: false,
        decimal: true,
      ),
      inputBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      onSaved: (PhoneNumber number) {
        print('On Saved: $number');
      },
    );
  }
}
