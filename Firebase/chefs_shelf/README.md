# 🍳 Chef's Shelf — Caderno de Receitas Digital

> **Chef's Shelf** é uma aplicação móvel full-stack desenvolvida em **Flutter** e **Firebase** que funciona como um caderno de receitas pessoal na nuvem. O aplicativo permite que entusiastas da culinária explorem receitas internacionais da API pública **TheMealDB**, salvem suas favoritas com dados estruturados no **Cloud Firestore** e gerenciem seu caderno em tempo real com segurança e privacidade.

---

## 📋 Sumário
- [Visão Geral e Contexto](#-visão-geral-e-contexto)
- [Funcionalidades Principais](#-funcionalidades-principais)
- [Arquitetura de Software](#-arquitetura-de-software)
- [Tecnologias Utilizadas](#-tecnologias-utilizadas)
- [Modelagem de Dados & Backend](#-modelagem-de-dados--backend)
- [Regras de Segurança (Firestore Security Rules)](#-regras-de-segurança-firestore-security-rules)
- [Instalação e Execução](#-instalação-e-execução)
- [Guia de Uso da Aplicação](#-guia-de-uso-da-aplicação)
- [Matriz de Conformidade com o Projeto](#-matriz-de-conformidade-com-o-projeto)
- [Autor](#-autor)

---

## 🎯 Visão Geral e Contexto

Este projeto foi construído para solucionar o desafio proposto pela startup fictícia **GourmetGo** (*Situação de Aprendizagem 1: O Caderno de Receitas Digital*). 

O principal desafio técnico é manipular dados estruturados complexos (listas de ingredientes e sequências de passos do modo de preparo), consumindo-os de uma API externa RESTful e convertendo-os em documentos NoSQL de alta performance salvos no Firebase sob o perfil individual de cada usuário.

---

## ✨ Funcionalidades Principais

* **🔐 Autenticação Isolada e Segura:**
  * Login e cadastro com e-mail e senha via **Firebase Authentication**.
  * Persistência do estado de login com escuta ativa através de `StreamBuilder`.
* **🔍 Busca e Exploração de Receitas (API Externa):**
  * Pesquisa dinâmica de pratos por nome ou palavra-chave integrada à API **TheMealDB**.
  * Carregamento assíncrono com feedback visual de carregamento (`CircularProgressIndicator`) e tratamento de erros de rede.
* **📖 Caderno Pessoal no Cloud Firestore (CRUD Completo):**
  * **Create:** Salva receitas diretamente no banco NoSQL do usuário.
  * **Read:** Lista atualizada em tempo real via `StreamBuilder` das receitas salvas.
  * **Delete:** Remoção intuitiva de receitas com gesto de deslizar (*Swipe to Delete* via widget `Dismissible`).
* **📱 Interface e UX (Material 3):**
  * Design responsivo e limpo seguindo as diretrizes do Material 3.
  * Navegação facilitada por barra inferior (`NavigationBar`).
  * Notificações contextuais via `SnackBar` informando o sucesso ou falha nas operações.

---

## 🏗 Arquitetura de Software

A aplicação adota os princípios da **Clean Architecture** (Arquitetura Limpa) e o padrão **DRY** (*Don't Repeat Yourself*), separando estritamente a interface visual, as regras de negócio e os serviços externos.

```text
lib/
 ├── core/                  # Configurações globais, constantes e tema visual
 │    └── app_theme.dart    # Tema unificado com suporte a Material 3
 │
 ├── models/                # Camada de Modelagem de Dados
 │    └── recipe_model.dart # Parser JSON da API e conversor NoSQL do Firestore
 │
 ├── screens/               # Interfaces de Usuário (Views/UI)
 │    ├── auth_screen.dart          # Tela de Login/Cadastro
 │    ├── home_screen.dart          # Tela de Busca de Receitas
 │    ├── main_screen.dart          # Tela Mestre com NavigationBar
 │    ├── my_notebook_screen.dart   # Tela do Caderno Pessoal
 │    └── recipe_detail_screen.dart # Tela de Detalhes da Receita
 │
 ├── services/              # Camada de Serviços e Regras de Negócio
 │    ├── auth_service.dart      # Gerenciamento de sessão com Firebase Auth
 │    ├── firestore_service.dart # Operações CRUD no Cloud Firestore
 │    └── meal_api_service.dart  # Integração HTTP REST com TheMealDB
 │
 ├── widgets/               # Componentes Visuais Reutilizáveis
 │    └── recipe_card.dart  # Cartão padronizado para exibição de receitas
 │
 ├── firebase_options.dart  # Configurações auto-geradas pela CLI do FlutterFire
 └── main.dart              # Ponto de entrada e inicialização do app