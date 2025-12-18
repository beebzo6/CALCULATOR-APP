import 'package:flutter/material.dart';
import 'buttons.dart';
import 'calculator_history.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String number1 = "";
  String number2 = "";
  String operand = "";
  List<String> calculation_History = [];
  String Lastcalculation = "";
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CalculatorHistory(calculatedHistory: calculation_History),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              reverse: true,
              child: Container(
                // height: screenSize.height / 4,
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Opacity(
                      opacity: 0.7,
                      child: Text(
                        Lastcalculation.isEmpty
                            ? "NO HISTORY"
                            : calculation_History[calculation_History.length -
                                  1],
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "$number1$operand$number2".isEmpty
                          ? "0"
                          : "$number1$operand$number2",
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Wrap(
            children: buttons
                .map(
                  (button) => SizedBox(
                    width: button == Btn.zero
                        ? screenSize.width / 2
                        : screenSize.width / 4,
                    height: screenSize.width / 5,
                    child: buildButton(button),
                  ),
                )
                .toList(),
          ),
          // Text(buttons[0]),
        ],
      ),
    );
  }

  Widget buildButton(String buttonText) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Material(
        color: getBtnColor(buttonText),
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide(
            color: const Color.fromARGB(255, 237, 231, 231),
            width: 1,
          ),
        ),
        child: InkWell(
          onTap: () => onBtnTap(buttonText),
          child: Center(
            child: Text(
              buttonText,
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  void onBtnTap(String value) {
    if (value == Btn.delete) {
      delete();
      return;
    }
    if (value == Btn.clear) {
      clearAll();
      return;
    }

    if (value == Btn.percentage) {
      convertTopercentage();
      return;
    }

    if (value == Btn.equals) {
      calculate();
      return;
    }
    ;

    appendValue(value);
  }

  /// claculate
  void calculate() {
    if (number1.isEmpty) return;
    if (operand.isEmpty) return;
    if (number2.isEmpty) return;
    double num1 = double.parse(number1);
    double num2 = double.parse(number2);

    var result = 0.0;
    switch (operand) {
      case Btn.add:
        result = num1 + num2;
        break;
      case Btn.subtract:
        result = num1 - num2;
        break;
      case Btn.multiply:
        result = num1 * num2;
        break;
      case Btn.divide:
        if (num2 == 0) {
          // cannot divide by zero
          return;
        }
        result = num1 / num2;
        break;
      default:
        return;
    }
    Lastcalculation =
        """
        $number1$operand$number2
        =$result
""";
    calculation_History.add(Lastcalculation);
    setState(() {
      number1 = result.toString();
      operand = "";
      number2 = "";
    });
  }

  /// convert current number to percentage
  void convertTopercentage() {
    if (number1.isNotEmpty && operand.isNotEmpty && number2.isNotEmpty) {
      // calculate befroe conversion
      calculate();
    }

    if (operand.isNotEmpty) {
      // cannot be converted
      return;
    }

    final number = double.parse(number1);

    setState(() {
      number1 = (number / 100).toString();
      operand = "";
      number2 = "";
    });
  }

  /// clear all
  void clearAll() {
    setState(() {
      number1 = "";
      operand = "";
      number2 = "";
    });
  }

  /// delete one from the end
  void delete() {
    setState(() {
      if (number2.isNotEmpty) {
        number2 = number2.substring(0, number2.length - 1);
      } else if (operand.isNotEmpty) {
        operand = "";
      } else if (number1.isNotEmpty) {
        number1 = number1.substring(0, number1.length - 1);
      }
    });
  }
  //// appends vlaue

  void appendValue(String buttonText) {
    setState(() {
      //ifisoperand not dot
      if (buttonText != Btn.point && int.tryParse(buttonText) == null
      // &&
      //buttonText != Btn.clear &&
      // buttonText != Btn.delete &&
      // buttonText != Btn.equals &&
      // buttonText != Btn.percentage
      ) {
        // operator (+ - × ÷)
        if (operand.isNotEmpty && number2.isNotEmpty) {
          // TODO calculate the equation before assigning new operator
        }
        operand = buttonText;
      } else if (number1.isEmpty || operand.isEmpty) {
        // typing number1
        if (buttonText == Btn.point && number1.contains(Btn.point)) return;

        if ((buttonText == Btn.point && number1.isEmpty) ||
            number1 == Btn.zero) {
          // assign number1 to "0." if user starts with dot or 0
          buttonText = "0.";
        }

        number1 += buttonText;
      } else {
        // typing number2
        if (buttonText == Btn.point && number2.contains(Btn.point)) return;

        if ((buttonText == Btn.point && number2.isEmpty) ||
            number2 == Btn.zero) {
          buttonText = "0.";
        }

        number2 += buttonText;
      }
    });
  }
}

Color getBtnColor(value) {
  return [buttons[0], buttons[1]].contains(value)
      ? Colors.blueGrey
      : [
          Btn.add,
          Btn.subtract,
          Btn.multiply,
          Btn.divide,
          Btn.equals,
          Btn.percentage,
        ].contains(value)
      ? Colors.orange
      : Colors.grey;
}
