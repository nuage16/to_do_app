import 'package:flutter/material.dart';
import 'package:to_do_app/provider/date_provider.dart';
import 'package:to_do_app/utils/cust_material_color.dart';
import 'package:to_do_app/pages/home_page.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/provider/todo_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<ToDoProvider>(create: (_) => ToDoProvider()),
          ChangeNotifierProvider<DateProvider>(create: (_) => DateProvider())
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter To-Do App',
            theme: ThemeData(
                primarySwatch: CustomMaterialColor.defaultSwatch,
                scaffoldBackgroundColor:
                    CustomMaterialColor.defaultSwatch.shade600,
                floatingActionButtonTheme: FloatingActionButtonThemeData(
                    backgroundColor:
                        CustomMaterialColor.defaultSwatch.shade600),
                appBarTheme: AppBarTheme(
                  backgroundColor: CustomMaterialColor.defaultSwatch.shade600,
                )),
            home: const Home()));
  }
}


//  static const MaterialColor defaultSwatch = const MaterialColor(
//     // 0xffE91E63, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
//     0xfffb421e,
//     const <int, Color>{
//       50: const Color(0xfffbe7e6), //10%
//       100: const Color(0xffffa38c), //20%
//       200: const Color(0xfffe7e5f), //30%
//       300: const Color(0xfffc613e), //40%
//       400: const Color(0xfffb421e), //50%
//       500: const Color(0xfff03c1a), //60%
//       600: const Color(0xff451c16), //70%
//       700: const Color(0xffe33615), //80%
//       800: const Color(0xffd42e11), //90%
//       900: const Color(0xffbb2007), //100%
//     },
//   );