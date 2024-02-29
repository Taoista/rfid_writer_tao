import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

class CreateScreens extends StatefulWidget {
  const CreateScreens({Key? key}) : super(key: key);

  @override
  State<CreateScreens> createState() => _CreateScreensState();
}

class _CreateScreensState extends State<CreateScreens> {

  TextEditingController _textFieldController = TextEditingController();

  void _showAlertDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Mensaje"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Aceptar"),
            ),
          ],
        );
      },
    );
  }


  void _writeHelloWorldToNFC() {
    String data = _textFieldController.text;

    if(data == ""){
      _showAlertDialog(context,"debe agregar un dato para grabar");
    }else{
        NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
          var ndef = Ndef.from(tag);
          if (ndef == null || !ndef.isWritable) {
            _showAlertDialog(context,"El tag no es compatible con NDEF o no es escribible");
            return;
          }
          // Crea un mensaje NDEF con un registro de texto "Hola Mundo"
          NdefMessage message = NdefMessage([
            NdefRecord.createText('Hola Mundo')
          ]);
          try {
            // Intenta escribir el mensaje en el tag NFC
            await ndef.write(message);
            _showAlertDialog(context,"escrito en el tag RFID con éxito");
          } catch (e) {
            _showAlertDialog(context,"$e");
          } finally {
            // Detiene la sesión NFC
            NfcManager.instance.stopSession();
          }
        });
    }

  }

  @override
  Widget build(BuildContext context) {
    return  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                controller: _textFieldController,
                decoration: const InputDecoration(
                  hintText: 'Ingresa el dato',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _writeHelloWorldToNFC,
              child: const Text('Grabar "Hola Mundo" en RFID'),
            ),
          ],
        ),
      );
  }
}
// https://parzibyte.me/blog/2021/06/04/leer-escribir-etiquetas-rfid-mfrc522-rfid-rc522/
