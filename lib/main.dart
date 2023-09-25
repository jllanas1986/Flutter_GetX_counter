import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MiControlador extends GetxController {
  final contador = 0.obs;
  final nombre = ''.obs;
  incrementar() {
    if (contador > 10) {
      contador.value = 0;
    } else {
      contador.value++;
    }
  }
}

Future<String> llamadaApi() async {
  await Future.delayed(Duration(seconds: 3));
  //await 3.delay();
  return 'datos recibidos';
}

class ApiController extends GetxController with StateMixin<String> {
  ApiController() {
    change('', status: RxStatus.empty());
  }

  void consultar(conError) async {
    try {
      change(null, status: RxStatus.loading());
      String resp = await llamadaApi();
      if (conError)
        change(null, status: RxStatus.error('Error en la identificación'));
      else
        change(resp, status: RxStatus.success());
    } catch (err) {
      change(null, status: RxStatus.error(err.toString()));
    }
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Pagina(),
  ));
}

class Pagina extends StatelessWidget {
  final controlador = Get.put(MiControlador());
  final apiControlador = Get.put(ApiController());
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GetX'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          Obx(() => Text(
                'contador: ${controlador.contador.value}',
              )),
          ElevatedButton(
              onPressed: () => controlador.incrementar(),
              child: const Text('aumentar contador')),
          apiControlador.obx(
            (datos) => Text('Resultado: $datos'),
            onLoading: const CircularProgressIndicator(),
            onError: (error) => Text('Error: $error'),
          ),
          ElevatedButton(
            onPressed: () => apiControlador.consultar(false),
            child: const Text('Consultar')),
          ElevatedButton(
            onPressed: () => apiControlador.consultar(true),
            child: const Text('Llamada Error')),
        ],
      )),
    );
  }
}
