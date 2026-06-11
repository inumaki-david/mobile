# Controle de Entrada de Visitantes

Este projeto consiste numa aplicação mobile desenvolvida com o ecossistema **Flutter** e linguagem **Dart**, utilizando o banco de dados **SQLite** para persistência de dados local. A aplicação simula um cenário real de controle de acessos, permitindo gerir o cadastro de visitantes e o histórico detalhado das suas respetivas visitas (entradas e saídas).

A documentação apresentada nesta especificação segue as diretrizes da norma **ISO 29148:2018** (*Systems and software engineering — Life cycle processes — Requirements engineering*), garantindo a clareza, rastreabilidade e integridade dos requisitos do sistema.

---

## 1. Introdução e Propósito (ISO 29148 - Seção 5.2.2)

### 1.1 Objetivo do Sistema
O objetivo primordial deste sistema é informatizar e simplificar o fluxo de monitorização de fluxo de pessoas em ambientes restritos (como portarias de condomínios, empresas ou instituições de ensino). O aplicativo resolve o problema do registo manual em papel, mitigando falhas humanas, perda de dados e oferecendo um histórico rastreável em tempo real de forma totalmente offline.

### 1.2 Público-Alvo
Operadores de portaria, recepcionistas, seguranças ou administradores responsáveis pela triagem, identificação e autorização de entrada de indivíduos externos em instalações privadas.

---

## 2. Escopo do Produto e Contexto (ISO 29148 - Seção 5.2.3)

O aplicativo funciona de forma autónoma (standalone) através do armazenamento local gerenciado pelo `sqflite`. A modelagem suporta uma relação de cardinalidade de **1:N (Um para Muitos)**, onde um visitante pode possuir múltiplos registos de visitas associados ao seu identificador único.

---

## 3. Especificação de Requisitos (ISO 29148 - Seção 6.2)

De acordo com os padrões formais de engenharia de requisitos, as sentenças abaixo utilizam o verbo condicional **"deve"** para expressar obrigatoriedade regulamentar.

### 3.1 Requisitos Funcionais (RF)

| Identificador | Título | Descrição |
| :--- | :--- | :--- |
| **[RF-001]** | Registo Inicial de Visitante | O sistema deve permitir o registo de novos visitantes capturando obrigatoriamente: Nome Completo, Documento de Identificação (RG/CPF), Idade e Endereço Residencial. |
| **[RF-002]** | Listagem de Visitantes | O sistema deve exibir uma lista dinâmica de todos os visitantes cadastrados na base de dados local, ordenados alfabeticamente. |
| **[RF-003]** | Pesquisa/Filtro de Visitantes | O sistema deve permitir que o operador filtre a lista de visitantes inserindo o nome ou documento no campo de busca. |
| **[RF-004]** | Visualização da Ficha Detalhada | O sistema deve disponibilizar uma tela de perfil para o visitante selecionado, expondo todos os seus dados cadastrais e a lista cronológica do seu histórico de visitas. |
| **[RF-005]** | Registo de Entrada de Visita | O sistema deve permitir anexar um novo registo de entrada para um visitante específico, armazenando a data/hora atual e o motivo da visita. |
| **[RF-006]** | Registo de Saída (Check-out) | O sistema deve permitir atualizar um registo de visita em aberto, adicionando a data e hora exata da saída do visitante. |
| **[RF-007]** | Eliminação de Registos | O sistema deve permitir a exclusão de um visitante, aplicando restrição de integridade referencial para remover em cascata as suas visitas associadas. |

### 3.2 Requisitos Não-Funcionais (RNF)

| Identificador | Categoria | Descrição |
| :--- | :--- | :--- |
| **[RNF-001]** | Persistência de Dados | O sistema deve utilizar o banco de dados embutido SQLite através do pacote `sqflite` para garantir a persistência mesmo após o fecho da app. |
| **[RNF-002]** | Portabilidade | A aplicação deve ser construída sobre a framework Flutter, garantindo compatibilidade multiplataforma (Android e iOS). |
| **[RNF-003]** | Conetividade | O sistema deve operar de forma 100% offline, dispensando conexões com APIs externas para o seu núcleo funcional. |
| **[RNF-004]** | Desempenho | As consultas ao banco de dados SQLite não devem bloquear a Main Thread (UI Thread), utilizando programação assíncrona (`Future`/`async`/`await`). |
| **[RNF-005]** | Usabilidade (UX) | A interface deve apresentar mensagens claras (Toasts ou SnackBars) confirmando o sucesso ou erro de qualquer operação de escrita. |

---

## 4. Regras de Negócio (RN)

* **[RN-001] - Validação de Maioridade Simples:** O campo "Idade" deve aceitar apenas valores numéricos inteiros positivos superiores a 0 e inferiores a 120.
* **[RN-002] - Unicidade do Registo:** Não deve ser permitido o cadastro de dois visitantes com o mesmo número de documento de identificação.
* **[RN-003] - Visitas Simultâneas Bloqueadas:** Um visitante não pode ter um novo registo de entrada criado se já houver uma visita em andamento (sem data de saída definida). É obrigatório encerrar a visita atual antes de iniciar outra.

---

## 5. Arquitetura do Software e Estrutura de Pastas

O projeto adota uma variação da arquitetura **MVC (Model-View-Controller)** para garantir o isolamento completo entre a interface gráfica e o acesso à base de dados.

```text
lib/
├── database/
│   └── database_helper.dart  # Configuração, criação de tabelas e conexões SQLite
├── models/
│   ├── visitante_model.dart  # Objeto de Negócio Visitante (mapeamento Map/JSON)
│   └── visita_model.dart       # Objeto de Negócio Visita (chave estrangeira vinculada)
├── controllers/
│   ├── visitante_controller.dart # Lógica de manipulação e estado dos visitantes
│   └── visita_controller.dart      # Lógica de controle de check-in e check-out
├── screens/
│   ├── home_screen.dart            # Listagem de visitantes cadastrados e busca
│   ├── cadastro_visitante_screen.dart # Formulário com validações de inputs
│   └── detalhe_visitante_screen.dart  # Perfil do visitante e gestão do histórico
└── widgets/
    ├── visitante_card.dart         # Componente visual para listagem
    └── visita_tile.dart            # Componente visual para a linha do histórico
```

## 6. Tecnologias e Pacotes Utilizados

Flutter & Dart - Framework e Linguagem base.

sqflite (^2.3.0) - Plugin Flutter para SQLite que suporta transações e versionamento de esquemas.

path (^1.9.0) - Manipulação e concatenação de caminhos de ficheiros de forma independente de plataforma.