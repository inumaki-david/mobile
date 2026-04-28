# EcoTrack – Controle de Hábitos Sustentáveis

O **EcoTrack** é um aplicativo Flutter desenvolvido para auxiliar usuários no monitoramento de ações sustentáveis cotidianas. O projeto foca em gamificar a preservação ambiental, permitindo que o usuário visualize seu impacto positivo através de um dashboard interativo.

---

## Especificação de Requisitos de Software (SyRS) - ISO 29148

### 1. Introdução
#### 1.1 Escopo do Sistema
Este documento define os requisitos para o aplicativo **EcoTrack**, uma solução mobile desenvolvida em Flutter. O software destina-se ao monitoramento de hábitos sustentáveis, fornecendo feedback visual imediato sobre o impacto ambiental do usuário através de um sistema de gerenciamento de estado reativo.

#### 1.2 Propósito
O propósito do EcoTrack é incentivar a adoção de comportamentos ecológicos (como economia de água e reciclagem) através de uma interface organizada, intuitiva e gamificada.

---

### 2. Descrição Geral
#### 2.1 Funções do Produto
O sistema deve realizar as seguintes funções principais:
* Catalogar e exibir hábitos sustentáveis.
* Processar a transição de status de hábitos (Pendente para Concluído).
* Consolidar métricas de desempenho em um Dashboard visual.
* Prover navegação multidirecional (Lateral e Inferior).

#### 2.2 Características dos Usuários
* **Usuário Comum:** Pessoas que buscam melhorar sua pegada ecológica. Requerem uma interface simples e clara.
* **Perfil Técnico:** Avaliadores que verificarão a integridade do gerenciamento de estado e a arquitetura do código.

---

### 3. Requisitos do Sistema (ISO 29148)

#### 3.1 Requisitos Funcionais (Capacidades)

| ID | Título | Descrição | Prioridade |
| :--- | :--- | :--- | :--- |
| **RF01** | **Gestão de Estado Reativa** | O sistema deve utilizar o pacote `Provider` para atualizar a UI sem necessidade de rebuilds manuais de página. | Crítica |
| **RF02** | **Lista de Hábitos (ListView)** | Exibir hábitos pendentes e concluídos em abas distintas (`TabBarView`). | Alta |
| **RF03** | **Dashboard de Impacto** | Apresentar um resumo das ações em formato de grade (`GridView`) com dados calculados em tempo real. | Alta |
| **RF04** | **Sincronização de Navegação** | O `BottomNavigationBar` e o `Drawer` devem estar sincronizados com o estado atual do `Provider`. | Média |
| **RF05** | **Controle de Configurações** | O sistema deve permitir a redefinição de progresso e alteração de parâmetros do usuário. | Baixa |

#### 3.2 Requisitos de Dados e Atributos (Modelagem)
O objeto **Hábito** deve possuir obrigatoriamente:
* `id`: Identificador único (String).
* `titulo`: Nome curto da ação.
* `isConcluido`: Estado booleano da tarefa.

#### 3.3 Requisitos Não Funcionais (Atributos de Qualidade)

* **RNF01 - Usabilidade:** A interface deve ser responsiva, garantindo que o `GridView` se ajuste a diferentes densidades de pixels (DP).
* **RNF02 - Arquitetura:** O código deve seguir a separação de responsabilidades (pastas `models`, `providers`, `screens`).
* **RNF03 - Desempenho:** A transição entre abas e o processamento de conclusão de hábitos devem ocorrer em tempo inferior a 100ms.

---

### 4. Estrutura de Pastas

```text
lib/
├── models/          # Representação das entidades de dados
├── providers/       # Lógica de negócio e gerência de estado (ChangeNotifier)
├── screens/         # Telas da aplicação (Home, Dashboard, Hábitos, Config)
├── widgets/         # Componentes visuais reutilizáveis
└── main.dart        # Inicialização do App e Configuração do Provider
```
---

### 5. Interfaces e Navegação
#### 5.1 Interface de Usuário
O sistema deve seguir o guia de estilo Material Design 3, com foco em:
* **AppBar:** Título centralizado e ícones de ação.
* **BottomNavigationBar:** 3 destinos (Dashboard, Hábitos, Configurações).
* **Drawer:** Acesso rápido às mesmas funcionalidades e informações de ajuda.

---

### 6. Verificação e Critérios de Aceitação
Para que o software seja considerado em conformidade com os requisitos:
1.  A marcação de um hábito como concluído **deve** atualizar instantaneamente o contador no Dashboard.
2.  O aplicativo **não deve** perder o estado da lista ao navegar entre as abas do `BottomNavigationBar`.
3.  A estrutura de pastas **deve** refletir a separação entre lógica (Provider) e visual (Widgets).

---

### 7. Prototipagem Figma
Link: https://www.figma.com/design/CkIxCr5wNuNmdgej61YZJP/EcoTrack---Controle-de-H%C3%A1bitos-Sustent%C3%A1veis?node-id=0-1&t=gMzx0zzR7hF8WOuu-1

---

**Status do Documento:** Versão 1.0 - Protótipo Funcional
**Data:** 28 de Abril de 2026