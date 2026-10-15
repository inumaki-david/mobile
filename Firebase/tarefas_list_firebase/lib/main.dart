import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tarefas_list_firebase/firebase_options.dart';

void main(List<String> args) async {
  //garantir o carregamento widgets do flutter
  WidgetsFlutterBinding.ensureInitialized();
  //inicializar o carregamento do firebase
  await Firebase.initializeApp(
    //garante o carregamento do firebase na plataforma android
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(home: AuthScreen()));

  
}
