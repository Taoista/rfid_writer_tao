import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:ndef/ndef.dart' as ndef;
import 'package:nfc_manager/nfc_manager.dart';

class CreateScreens extends StatefulWidget {
  const CreateScreens({Key? key});

  @override
  State<CreateScreens> createState() => _CreateScreensState();
}

class _CreateScreensState extends State<CreateScreens> {
  final TextEditingController _controller = TextEditingController();

  Future<void> _writeToTag() async {

   NfcManager.instance.startSession(onDiscovered: (tag) async {
    Ndef? ndef = Ndef.from(tag);

    NdefMessage message = NdefMessage([
      NdefRecord.createExternal('android.com', 'pkg', Uint8List.fromList('com.example'.codeUnits)),
    ]);
    
    try {
      await ndef!.write(message);
      NfcManager.instance.stopSession();
    } catch (e) {
      print("error $e");
    }

   });

  }

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Ingresa el código a registrar',
                labelText: 'Text',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16), // Separación entre el TextField y el botón
            ElevatedButton(
              onPressed: _writeToTag,
              child: const Text('Grabar CHIP'),
            ),
          ],
        ),
      ),
    );
  }
}
