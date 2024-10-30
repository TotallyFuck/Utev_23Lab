import 'package:flutter/material.dart';

void main() {
  runApp(UnitConverterApp());
}

class UnitConverterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unit Converter',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final List<UnitType> unitTypes = [
    UnitType('Вес', ['Килограмм', 'Грамм', 'Фунт']),
    UnitType('Длина', ['Сантиметр', 'Метр', 'Километр']),
    UnitType('Температура', ['Цельсий', 'Фаренгейт', 'Кельвин']),
    UnitType('Площадь', ['Квадратный метр', 'Гектар', 'Акр']),
    UnitType('Валюта', ['Доллар', 'Евро', 'Рубль']),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Конвертер величин')),
      body: ListView.builder(
        itemCount: unitTypes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(unitTypes[index].name),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ConversionScreen(unitTypes[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ConversionScreen extends StatefulWidget {
  final UnitType unitType;

  ConversionScreen(this.unitType);

  @override
  _ConversionScreenState createState() => _ConversionScreenState();
}

class _ConversionScreenState extends State<ConversionScreen> {
  String? fromUnit;
  String? toUnit;
  String inputValue = '';
  String result = '';
  TextEditingController inputController = TextEditingController();

  void convert() {
    if (fromUnit == null || toUnit == null) {
      setState(() {
        result = 'Пожалуйста, выберите величины для конвертации';
      });
      return;
    }
    if (inputValue.isEmpty) {
      setState(() {
        result = 'Введите значение для конвертации';
      });
      return;
    }

    double value = double.tryParse(inputValue) ?? 0;

    // Пример конвертации
    if (widget.unitType.name == 'Длина') {
      if (fromUnit == 'Сантиметр' && toUnit == 'Метр') {
        value /= 100;
      } else if (fromUnit == 'Метр' && toUnit == 'Сантиметр') {
        value *= 100;
      } else if (fromUnit == 'Километр' && toUnit == 'Метр') {
        value *= 1000;
      } else if (fromUnit == 'Метр' && toUnit == 'Километр') {
        value /= 1000;
      } else if (fromUnit == 'Километр' && toUnit == 'Сантиметр') {
        value *= 100000;
      } else if (fromUnit == 'Сантиметр' && toUnit == 'Километр') {
        value /= 100000;
      }
    } else if (widget.unitType.name == 'Вес') {
      if (fromUnit == 'Килограмм' && toUnit == 'Грамм') {
        value *= 1000;
      } else if (fromUnit == 'Грамм' && toUnit == 'Килограмм') {
        value /= 1000;
      } else if (fromUnit == 'Фунт' && toUnit == 'Килограмм') {
        value *= 0.453592;
      } else if (fromUnit == 'Килограмм' && toUnit == 'Фунт') {
        value /= 0.453592;
      } else if (fromUnit == 'Фунт' && toUnit == 'Грамм') {
        value *= 453.592;
      } else if (fromUnit == 'Грамм' && toUnit == 'Фунт') {
        value /= 453.592;
      }
    } else if (widget.unitType.name == 'Температура') {
      if (fromUnit == 'Цельсий' && toUnit == 'Фаренгейт') {
        value = (value * 9 / 5) + 32;
      } else if (fromUnit == 'Фаренгейт' && toUnit == 'Цельсий') {
        value = (value - 32) * 5 / 9;
      } else if (fromUnit == 'Цельсий' && toUnit == 'Кельвин') {
        value += 273.15;
      } else if (fromUnit == 'Кельвин' && toUnit == 'Цельсий') {
        value -= 273.15;
      } else if (fromUnit == 'Фаренгейт' && toUnit == 'Кельвин') {
        value = (value - 32) * 5 / 9 + 273.15;
      } else if (fromUnit == 'Кельвин' && toUnit == 'Фаренгейт') {
        value = (value - 273.15) * 9 / 5 + 32;
      }
    } else if (widget.unitType.name == 'Площадь') {
      if (fromUnit == 'Квадратный метр' && toUnit == 'Гектар') {
        value /= 10000;
      } else if (fromUnit == 'Гектар' && toUnit == 'Квадратный метр') {
        value *= 10000;
      } else if (fromUnit == 'Квадратный метр' && toUnit == 'Акр') {
        value /= 4047;
      } else if (fromUnit == 'Акр' && toUnit == 'Квадратный метр') {
        value *= 4047;
      } else if (fromUnit == 'Гектар' && toUnit == 'Акр') {
        value /= 2.471;
      } else if (fromUnit == 'Акр' && toUnit == 'Гектар') {
        value *= 2.471;
      }
    } else if (widget.unitType.name == 'Валюта') {
      if (fromUnit == 'Доллар' && toUnit == 'Евро') {
        value *= 0.92;
      } else if (fromUnit == 'Евро' && toUnit == 'Доллар') {
        value /= 0.92;
      } else if (fromUnit == 'Доллар' && toUnit == 'Рубль') {
        value *= 96.67;
      } else if (fromUnit == 'Рубль' && toUnit == 'Доллар') {
        value /= 96.67;
      } else if (fromUnit == 'Евро' && toUnit == 'Рубль') {
        value *= 104.81;
      } else if (fromUnit == 'Рубль' && toUnit == 'Евро') {
        value /= 104.81;
      }
    }

    setState(() {
      result = double.parse(value.toString()).toString();
    });
  }

  void clearInput() {
    setState(() {
      inputValue = '';
      result = '';
      inputController.clear();
    });
  }

  void deleteLastSymbol() {
    if (inputValue.isNotEmpty) {
      setState(() {
        inputValue = inputValue.substring(0, inputValue.length - 1);
        inputController.text = inputValue;
      });
    }
  }

  void swapUnits() {
    setState(() {
      String temp = fromUnit!;
      fromUnit = toUnit;
      toUnit = temp;
    });
  }

  void addDecimalPoint() {
    if (!inputValue.contains('.')) {
      setState(() {
        inputValue += '.';
        inputController.text = inputValue;
      });
    }
  }

  void addDigit(String digit) {
    setState(() {
      inputValue += digit;
      inputController.text = inputValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.unitType.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField(
              value: fromUnit,
              onChanged: (value) {
                setState(() {
                  fromUnit = value as String?;
                });
              },
              items: widget.unitType.units.map((unit) {
                return DropdownMenuItem(
                  value: unit,
                  child: Text(unit),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField(
              value: toUnit,
              onChanged: (value) {
                setState(() {
                  toUnit = value as String?;
                });
              },
              items: widget.unitType.units.map((unit) {
                return DropdownMenuItem(
                  value: unit,
                  child: Text(unit),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: inputController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Введите значение',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        inputValue = value;
                      });
                    },
                  ),
                ),
                SizedBox(width: 16),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: swapUnits,
                      child: Text(' ⇄'),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            Column(
              children: [
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => addDigit('7'),
                      child: Text('7'),
                    ),
                    ElevatedButton(
                      onPressed: () => addDigit('8'),
                      child: Text('8'),
                    ),
                    ElevatedButton(
                      onPressed: () => addDigit('9'),
                      child: Text('9'),
                    ),
                  ],
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => addDigit('4'),
                      child: Text('4'),
                    ),
                    ElevatedButton(
                      onPressed: () => addDigit('5'),
                      child: Text('5'),
                    ),
                    ElevatedButton(
                      onPressed: () => addDigit('6'),
                      child: Text('6'),
                    ),
                  ],
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => addDigit('1'),
                      child: Text('1'),
                    ),
                    ElevatedButton(
                      onPressed: () => addDigit('2'),
                      child: Text('2'),
                    ),
                    ElevatedButton(
                      onPressed: () => addDigit('3'),
                      child: Text('3'),
                    ),
                  ],
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: addDecimalPoint,
                      child: Text('.'),
                    ),
                    ElevatedButton(
                      onPressed: () => addDigit('0'),
                      child: Text('0'),
                    ),
                    ElevatedButton(
                      onPressed: deleteLastSymbol,
                      child: Text('⌫'),
                    ),
                    ElevatedButton(
                      onPressed: clearInput,
                      child: Text('C'),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: convert,
              child: Text('Конвертировать'),
            ),
            SizedBox(height: 20),
            Text(
              result,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UnitType {
  String name;
  List<String> units;

  UnitType(this.name, this.units);
}
