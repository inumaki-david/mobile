# Projeto Biblioteca APP Json

## 1. Identificação do Projeto

- **Nome do Projeto**: Biblioteca App
- **Descrição**: Aplicativo móvel multiplataforma (Flutter) para gerenciamento de bibliotecas, com funcionalidade de CRUD (Criar, Ler, Atualizar, Deletar) para Usuários, livros e empréstimos.

## 2. Propósito e Escopo

O Sisteam tem como Objetivo digitalizar e simplificar a gestão de acervos bibliotecários. Ele permite o cadastro e controle de livros, usuários e empréstimos, oferecendo uma interface intuitiva ara administradores. o escopo atual inclui operações básicas de gerenciamento, com dados persistidos em um backend simulado via Json Server.

## 3. Requisitos Funcionais (RF)

| Id | Requisito | Descrição |
| --- | --- | --- |
| **RF01* | Gerenciar Livros | Listar, Cadastrar, Editar e Exclusir Livros do Acervo. | 
| **RF02* | Gerenciar Usuários | Listar, Cadastrar, Editar e Excluir Usuáarios do Sistema. |
| **RF03* | Gerenciar Empréstimos | Visualizar e Gerenciar Empréstimos de Livros. | 
| **RF04* | Navegação | Interface com Navegação para Abas (Livros, Usuários e Empréstimos). |

## 4. Requisitos Não-Funcionais (RNF)

| Id | Requisito | Descrição |
| --- | --- | --- |
| **RNF01* | Arquitetura | Baseada em Camadas (Model, Service, Controllers, Views) seguindo o Padrão MVC. |
| **RNF02* | Persistência | Utiliza um arquivo *db.json* como fonte de dados acessando via APIRest. | 
| **RNF03* | Tecnologia | Desenvolvimento em Flutter/Dart, com consumo de API via pacote HTTP. |
| **RNF04* | Comunicação | A Comunicação com o backend é feita através de requisições HTTP sincronas (GET, POST, PUT, DELETE). |

## 5. Endpoints da API (Backend)

| Método | Endpoint | Descrição |
| --- | --- | --- | 
| GET | */users* | Lista todos os usuários. |
| GET | */users/{id}* | Busca um usuário por Id. |
| POST | */users* | Cria um novo usuário. |
| PUT | */users/{id}* | Atualiza um usuário. | 
| DELETE | */users/{id}* | Remove um usuário. |
| GET | */books* | Lista todos os livros. |
| GET | */books/{id}* | Busca um livro por Id. |
| POST | */books* | Cria um novo livro. |
| PUT | */books{id}* | Atualiza um livro. |
| DELETE | */books/{id}* | Remove um livro do acervo. |
| GET | */loans* | Lista todos os empréstimos. |
| POST | */loans* | Registra um novo empréstimo. |

## 6. Diagramas 

### 6.1 Diagramas de Entidade Relacional (DER)

```mermaid

erDiagram
    USER {
        int id PK
        string name
        string email
    }

    BOOK {
        int id PK
        string title
        string author
        boolean avaliable
    }

    LOAN {
        int id PK
        int userId FK
        int bookId FK
        date startDate
        date dueDate
        boolean returned
    }

    USER ||--o{ LOAN : "do" 
    BOOK ||--o{ LOAN : "is loan in "  

```

### 6.2 Diagrama de Classe

```mermaid

classDiagram
    class ApiService{
        <<static>>
        _String _baseURL
        +getList(String path) Future~List~
        +getOne(String path, String id) Future~Map~
        +post(String path, Map body) Future~Map~
        +put(String path, Map body, String id) Future~Map~
        +delete(String path, String id) Future~void~
    }

    class UserModel {

    }

    class BookModel {

    }

    class LoanModel {

    }

```