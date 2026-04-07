# 🚀 Flutter Study: Navegação e Formulários

Este projeto é um aplicativo desenvolvido em Flutter para fins educacionais. O foco principal é demonstrar a implementação de **rotas nomeadas** para navegação entre páginas e o uso avançado de **elementos de formulário** com validação de dados.

## 📱 Funcionalidades do Projeto

### 1. Sistema de Rotas Nomeadas
O aplicativo utiliza um sistema de rotas centralizado no ficheiro `main.dart`, permitindo uma navegação organizada:
* `/`: Página inicial (**HomePage**).
* `/form`: Página de cadastro (**FormularioPage**).
* `/contato`: Página de suporte (**ContatoPage**).

### 2. Validação de Formulários
No ecrã de formulário, são aplicadas técnicas de validação em tempo real utilizando a `GlobalKey<FormState>`:
* **Campo Obrigatório:** Verifica se o nome foi preenchido.
* **Validação de E-mail:** Verifica a presença do caractere `@`.
* **Segurança de Senha:** Mínimo de 6 caracteres e confirmação de igualdade entre campos.
* **Interatividade:** Botão para ocultar/exibir a senha.

### 3. Componentes de Interface (Widgets)
Foram explorados diversos widgets de entrada de dados:
* `TextFormField`: Entradas de texto com validação.
* `RadioGroup`: Seleção única (ex: Sexo).
* `Slider`: Seleção numérica em barra (ex: Idade).
* `Checkbox`: Seleção múltipla (ex: Interesses).
* `DropdownButtonFormField`: Menu suspenso (ex: Cidade).
* `Switch`: Alternância booleana (ex: Termos de Uso).

## Como Executar o Projeto

1. Certifica-te de que tens o ambiente Flutter configurado.
2. Clona este repositório.
3. No terminal, dentro da pasta do projeto, executar:
`flutter run -v`