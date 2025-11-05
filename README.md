# Projeto de CRUD com Spring Boot e Flutter

Este é um projeto full-stack que demonstra a integração entre um backend RESTful desenvolvido com Spring Boot e um frontend multikplataforma (Web e Windows) construído com Flutter. O objetivo da aplicação é realizar um CRUD (Create, Read, Update, Delete) completo de usuários.

## Visão Geral

O projeto é dividido em duas pastas principais:

1.  **`demo`**: Contém a aplicação backend em Spring Boot.
2.  **`flutter_app`**: Contém a aplicação frontend em Flutter.

---

## 1. Backend (`demo`)

A aplicação backend é responsável por toda a lógica de negócio, validações e persistência dos dados.

### Tecnologias Utilizadas

* **Java 17**
* **Spring Boot**: Framework principal para criação da API REST.
* **Spring Data JPA**: Para persistência de dados e comunicação com o banco.
* **H2 Database**: Um banco de dados em memória para facilitar a execução e testes.
* **Maven**: Gerenciador de dependências.
* **Lombok**: Para reduzir código boilerplate (como Getters, Setters, etc.).

### Entidade Principal: `Usuario`

O modelo de dados central é o `Usuario`, que possui os seguintes campos:

* `id` (Long)
* `nomeCompleto` (String)
* `cpf` (String)
* `dataNascimento` (LocalDate)
* `sexo` (String: "M" ou "H")
* `dataCadastro` (LocalDate)

### Regras de Negócio (`UsuarioService`)

O service aplica validações importantes antes de salvar ou atualizar um usuário:

1.  **CPF Único**: Não permite o cadastro de dois usuários com o mesmo CPF.
2.  **Idade Mínima**: O usuário deve ter pelo menos 18 anos de idade.
3.  **Sexo Válido**: O campo sexo deve ser "M" (Mulher) ou "H" (Homem).

### API Endpoints (`UsuarioController`)

A API expõe os seguintes endpoints para gerenciamento dos usuários, com CORS habilitado (`@CrossOrigin(origins = "*")`):

| Método | Rota | Descrição |
| :--- | :--- | :--- |
| `POST` | `/usuarios` | Cria um novo usuário. |
| `GET` | `/usuarios` | Lista todos os usuários cadastrados. |
| `GET` | `/usuarios/{id}` | Busca um usuário específico pelo ID. |
| `GET` | `/usuarios/cpf/{cpf}` | Busca um usuário específico pelo CPF. |
| `PUT` | `/usuarios/{id}` | Atualiza um usuário existente pelo ID. |
| `DELETE` | `/usuarios/{id}` | Exclui um usuário pelo ID. |

---

## 2. Frontend (`flutter_app`)

O frontend é uma aplicação Flutter (configurada para web e windows) que consome a API Spring Boot para fornecer uma interface gráfica de gerenciamento.

### Tecnologias Utilizadas

* **Flutter**: Framework para desenvolvimento da interface.
* **Dart**: Linguagem de programação.
* **http**: Pacote para realizar as chamadas HTTP para o backend.
* **intl**: Pacote para formatação de datas.

### Estrutura e Telas

* **`main.dart`**: Ponto de entrada da aplicação, que inicializa a `HomePage`.
* **`models/usuario_model.dart`**: Classe modelo do `Usuario` no Flutter, usada para desserializar os dados vindos da API.
* **`services/api_service.dart`**:
    * Classe central que gerencia toda a comunicação com o backend.
    * Define a `_baseUrl = "http://localhost:8080"`.
    * Implementa métodos para `getUsuarios`, `cadastrarUsuario`, `atualizarUsuario` e `excluirUsuario`.
* **`pages/home_page.dart`**: Tela inicial de boas-vindas com um botão que leva o usuário para a tela de listagem.
* **`pages/listar_page.dart`**:
    * Tela principal do CRUD, intitulada "Gerenciamento de Funcionários".
    * Usa um `FutureBuilder` para buscar e exibir a lista de usuários da API.
    * Permite **editar** (levando à `CadastroPage`) e **excluir** (com um diálogo de confirmação) cada usuário da lista.
    * Possui um `FloatingActionButton` para adicionar novos usuários.
* **`pages/cadastro_page.dart`**:
    * Formulário para **criar** ou **editar** um usuário.
    * Contém campos para nome, CPF, data de nascimento (com um `showDatePicker`) e sexo (com `Radio` buttons).
    * Ao submeter, chama o `apiService` para criar ou atualizar o usuário.

---

## Como Executar

### Pré-requisitos

* Java 17 (ou superior) e Maven instalados.
* Flutter SDK instalado.

### 1. Executando o Backend (Spring Boot)

1.  Navegue até a pasta do backend:
    ```sh
    cd demo
    ```
2.  Execute a aplicação usando o Maven:
    ```sh
    mvn spring-boot:run
    ```
3.  A API estará disponível em `http://localhost:8080`.

### 2. Executando o Frontend (Flutter)

1.  Abra outro terminal e navegue até a pasta do frontend:
    ```sh
    cd flutter_app
    ```
2.  Instale as dependências do Flutter:
    ```sh
    flutter pub get
    ```
3.  Execute a aplicação (exemplo para Web):
    ```sh
    flutter run -d chrome
    ```
    *(Você também pode rodar como desktop: `flutter run -d windows`)*
