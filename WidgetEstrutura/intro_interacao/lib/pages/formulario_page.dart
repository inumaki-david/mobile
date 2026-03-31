// tela com elementos de formulário para interação do usuário
// textField -> entrada de dados
// checkbox -> seleção de opções
// radio button ->  uma única opção
// slider -> barra de seleção
//switch -> botão de alternância
 // dropdown => menu suspenso

 // usar elemento form para validação de campos

import 'package:flutter/material.dart';

class FormularioPage extends StatefulWidget {
  const FormularioPage({super.key});

  @override
  State<FormularioPage> createState() => _FormularioPageState();
}

class _FormularioPageState extends State<FormularioPage> {
  //atributos (nome, email, senha, validação de senha, termos de uso(switch), sexo(radio), idade(slider), interesses(chechbox), Cidade(dropdown) )
  String _nome = "";
  String _email = "";
  String _senha = "";
  String _confirmarSenha = "";
  bool _aceitarTermos = false;
  String _sexo = "Feminino";
  double _idade = 18;
  List<String> _interesses = [];
  String _cidade = "Americana";

  //chave global de validação do formulário
  final formKey = GlobalKey<FormState>(); // formulário somente será enviado se a chave estiver validada
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Formulário de Cdastro"),),
      body: Padding(
        padding: EdgeInsets.all(8), //espaçamento geral de 8px em toda a tela 
        child: Form(
          key: formKey, //chave de validação
          child: SingleChildScrollView(
            child: Column(
              children: [
                //campo do nome
                TextFormField(
                  //validação do campo
                  validator: (value) => value.isEmpty,
                )
              ],
            ),
          )
        )
      )
    );
  }
}
