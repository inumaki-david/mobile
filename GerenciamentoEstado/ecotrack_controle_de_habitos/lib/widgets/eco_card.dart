import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/models/habito.dart';
import '/providers/eco_provider.dart';

class EcoCard extends StatelessWidget {
  final Habito habito;

  const EcoCard({Key? key, required this.habito}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Lê o provedor para saber se o tema atual é escuro ou claro.
    final isDarkMode = context.watch<EcoProvider>().isDarkMode;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Checkbox(
          value: habito.isConcluido,
          activeColor: Colors.green,
          onChanged: (bool? valor) {
            // Marca ou desmarca o hábito chamando o Provider
            context.read<EcoProvider>().alternarStatusHabito(habito.id);
          },
        ),
        title: Text(
          habito.titulo,
          style: TextStyle(
            // Operadores ternários
            decoration: habito.isConcluido ? TextDecoration.lineThrough : null,
            // Lógica: Se estiver concluído ? (então usa cinza) : (senão, verifica se é modo escuro)
            color: habito.isConcluido ? Colors.grey : (isDarkMode ? Colors.white : Colors.black87),
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.redAccent),
          onPressed: () {
            // Remove o hábito
            context.read<EcoProvider>().removerHabito(habito.id);
          },
        ),
      ),
    );
  }
}