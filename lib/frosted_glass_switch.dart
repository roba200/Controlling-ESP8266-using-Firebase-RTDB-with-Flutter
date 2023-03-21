import 'dart:ui';

import 'package:flutter/material.dart';

class FrostedGlassSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const FrostedGlassSwitch({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  _FrostedGlassSwitchState createState() => _FrostedGlassSwitchState();
}

class _FrostedGlassSwitchState extends State<FrostedGlassSwitch> {
  bool _value = false;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _value = !_value;
        });
        widget.onChanged(_value);
      },
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white.withOpacity(0.1),
          ),
          padding: EdgeInsets.all(8),
          child: Row(
            children: [
              Switch(
                value: _value,
                onChanged: (value) {
                  setState(() {
                    _value = value;
                  });
                  widget.onChanged(_value);
                },
              ),
              Text(
                _value ? 'On' : 'Off',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
