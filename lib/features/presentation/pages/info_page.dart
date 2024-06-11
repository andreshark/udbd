import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    width: 200,
                    height: 200,
                    child: Image.asset('assets/images/image.png'),
                  ),
                ),
                RichText(
                    text: const TextSpan(
                        style: TextStyle(color: Colors.black, fontSize: 15),
                        children: [
                      TextSpan(
                          text: '"Fastfood Delivery"\n',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: '''Выполнил студент группы 7221-12 Шведов Н.

База данных: PostgreSQL
Фреймворк: Flutter
Язык программирования: Dart''')
                    ])),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return Scaffold(
                        appBar: AppBar(
                          title: const Text('Модель базы данных'),
                        ),
                        body: Center(
                            child: PhotoView(
                          imageProvider:
                              Image.asset('assets/images/bd.jpg').image,
                        )),
                      );
                    }));
                  },
                  child: Container(
                    width: 200,
                    height: 200,
                    child: Image.asset('assets/images/bd.jpg'),
                  ),
                ),
              ],
            )));
  }
}
