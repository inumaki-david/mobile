## Introdução ao Desenvolvolvimento Mobile

### Tipo de Desenvolvimento

- Nativo
    - Android:
        - SDK : Android SDK
        - IDE : Android Studio
        - Linguagens: Kotlin e Java
        - Ambientes: Mac, Win, Linux

    - Ios:
        - SDK: Cocoa Touch
        - IDE: Xcode
        - Liguagens: Swift / Objectype-C
        - Ambientes: Mac

- Multiplataforma
    - React Native:
        - SDK: Node.JS
        - IDE: VSCode, 
        - JavaScript / TypeScript
        - Ambientes: Mac, WIn, Linux

    - Flutter
        - SDK: Flutter SDK
        - IDE: VSCode, Android Studio
        - Linguagens: Dart
        - Ambientes: Mac, Win, Linux

    ## Preparação do Ambiente de Desenvolvimento

    ### Instalação do FlutterSDK
        - download do arquivo ZIP na página flutter.dev
        - inclusão do flutter na pasta C:\src
        - inclusão do flutter\bin nas varáveis de ambiente
        - teste o flutter --version
    
    ### Instalação do AndroidSDK
        - download do Android SDK - Command Line Tools
        - adicionar o Command-line ao c:\src\AndroidSDK
        - adicionar o SDKManager as Variáveis de Ambiente
        - download dos pacotes
            - emulador
            - platforms
            - platform-tools
            - build-tools
        - adicionar ADB e o Emulator as Variáveis de Ambiente
        - Criação da Imagem do Emulador - via sdkmanager
        - Build do Emulador - via sdkmanager

    ### Criação de Projetos e Códigos da Linha e Comando

    - Criação de projetos
        - flutter create nome_do_app
            - flags
                - --empty : Cria um aplicativo "vazio"(hello world)
                - --platforms : Permite a seleção de plataforma de desenvolvimento
                    -Exemplo: --platforms=android (a criação do projeto será somente para a plataforma android)
        - Exemplo de criação de uma plataforma android vazia
            - flutter create nome_do_app --empty --plataforms=android
            - OBS O nome do aplicativo tem que que ter todas as letras minúsculas e separação de palavras com "_".
        - flutter doctor
            - Permite a correção de pequenos prolemas no flutter e identificação dos paâmetros funcionais em relação as plataforsmas de desenvolvimento.
            - Sempre rodar o flutter doctor no começo do desenvolvimento.
        - flutter clean
            - Limpa o cachê da build (apaga o apk anterior).
        - flutter run -v
            - -v = Verbaliza o que está acontecendo, etapa por etapa.
            - Build do aplicativo (apk).

    - gerenciamento de dependências do PubSpec()
        - instalação
            - flutter pub add nome_dependencia
        - baixar e instalar dependências projetadas 
            - flutter pub get
        - outros comando do flutter pub(dependências)
            - flutter pub outdated (verifica se as dependências estão desatualizadas)
            - flutter pub upgrade (atualiza as dependências do flutter pub)