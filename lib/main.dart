import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:greengrocer/src/pages/auth/controller/auth_controller.dart';
import 'package:greengrocer/src/pages_routes/app_pages.dart';
import 'package:flutter/services.dart';

void main() {
  //inicializar todos os plugins necessários
  WidgetsFlutterBinding.ensureInitialized();

  Get.put(AuthController());

  //Questoes de acessibilidade
  RendererBinding.instance.ensureSemantics();
  runApp(const MyApp());

  // Aqui definimos apenas o modo retrato, fazendo com que todo nosso app fique
  //apenas nessa orientação, evitando o overflow
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Greengrocer',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white.withAlpha(190),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: PagesRoutes.splashRoute,
      getPages: AppPages.pages,
    );
  }
}
