# Ponto Certo — Registro de ponto com geolocalização e biometria

Aplicativo Flutter demonstrativo para autenticação de funcionários e registro de
ponto com data, hora e coordenadas. O registro só é enviado quando o aparelho
está a até 100 metros do local de trabalho configurado na API.

## Relatório de implementação

### Funcionalidades

- Login por NIF ou e-mail e senha, consultando a coleção `users` do Json-Server.
- Acesso biométrico do sistema (por exemplo, rosto ou impressão digital) após o
  primeiro login. O aplicativo salva localmente somente o ID do último usuário,
  nunca sua senha.
- Verificação da permissão de localização, leitura do GPS e cálculo da distância
  até o local de trabalho. Um registro a mais de 100 metros é recusado.
- Registro no Json-Server da identificação do funcionário, tipo do ponto,
  data/hora do aparelho, latitude, longitude e distância calculada.
- Consulta dos registros do funcionário no dia, com indicação de entrada,
  início do intervalo, retorno do intervalo e saída. A lista pode ser atualizada
  com gesto de arrastar para baixo.

### Organização e decisões técnicas

- `lib/screens`: telas de login e registro.
- `lib/services`: comunicação HTTP com a API e acesso à localização.
- `lib/models`: modelos e validação dos dados recebidos.
- `lib/config/app_config.dart`: endereço da API, limite de distância e timeout.
- A biometria é verificada pela API nativa do dispositivo por meio do pacote
  `local_auth`; o aplicativo não captura nem armazena imagens biométricas.
- O endereço da empresa e os funcionários são dados da API, e não valores
  embutidos na interface. O raio de validação é fixo em 100 metros.

### API e estrutura de dados

O Json-Server disponibiliza os seguintes recursos:

| Recurso | Uso |
| --- | --- |
| `GET /users?email=<email>` ou `GET /users?nif=<nif>` | Localizar e validar o funcionário |
| `GET /users/<id>` | Recuperar a conta salva para o acesso biométrico |
| `GET /workplaces` | Carregar o local e as coordenadas do trabalho |
| `GET /attendances?employeeId=<id>` | Consultar os registros do funcionário |
| `POST /attendances` | Salvar um novo registro de ponto |

O arquivo `backend/db.json` contém dados de demonstração e o esquema esperado:

- Funcionário: `id`, `name`, `email`, `nif`, `password`.
- Local: `id`, `name`, `latitude`, `longitude`.
- Registro: `employeeId`, `employeeName`, `type`, `timestamp`, `latitude`,
  `longitude`, `distanceMeters` (o Json-Server acrescenta `id`).

**Limitação importante:** Json-Server é um backend de protótipo, não um serviço de
autenticação seguro. A senha de demonstração é armazenada em texto simples e os
recursos não têm autorização. Não use dados reais nem publique esse servidor em
produção. Para produção, substitua-o por uma API com senha armazenada com hash,
sessões/tokens, autorização por usuário e HTTPS. O HTTP sem TLS configurado no
Android serve apenas para desenvolvimento local.

## Instalação e execução

### Pré-requisitos

- Flutter SDK e Android SDK configurados.
- Node.js e npm.
- Um emulador Android ou aparelho Android com acesso à rede do computador.

### Iniciar o Json-Server

No PowerShell, na pasta do projeto:

```powershell
cd backend
npm install
npm start
```

O servidor fica disponível na porta `3000`. Os dados iniciais para testar o login
são:

- E-mail: `davi@example.com`
- NIF: `123456789`
- Senha: `ponto123`

O local de demonstração em `backend/db.json` está configurado para o SENAI
Americana (Avenida Brasil), nas coordenadas `-22.7539202, -47.3510963`. Ajuste
essas coordenadas se o ponto escolhido no emulador ou no local de avaliação for
outro. Use latitude entre -90 e 90 e longitude entre -180 e 180. O aplicativo
usa o primeiro local da coleção `workplaces`.

### Executar o aplicativo

Em outro terminal, a partir da pasta do aplicativo:

```powershell
flutter pub get
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000
```

No navegador e no Flutter Desktop, o endereço padrão é `http://localhost:3000`.
No emulador Android, o endereço padrão é `http://10.0.2.2:3000` (o endereço do
computador visto pelo emulador). Em aparelho físico, substitua-o pelo endereço
IP local do computador na rede Wi-Fi, por exemplo:

```powershell
flutter run --dart-define=API_BASE_URL=http://192.168.1.10:3000
```

Permita que o firewall do computador aceite conexões na porta `3000` da rede
local. Para apontar para outro servidor, passe seu endereço em
`API_BASE_URL`; a porta padrão é `3000`.

### Permissões e teste dos recursos

- **Localização:** o Android solicita a permissão quando o funcionário toca em
  “Registrar”. Ative o serviço de localização e conceda a permissão durante o
  uso. Coordenadas indisponíveis ou permissão negada impedem o envio do ponto.
- **Emulador:** configure uma localização nas opções estendidas do emulador.
  Para testar o sucesso, use coordenadas dentro de 100 m do local em
  `backend/db.json`; para testar a recusa, escolha coordenadas mais distantes.
- **Biometria:** cadastre uma biometria nas configurações do Android/emulador.
  Faça primeiro um login por NIF/e-mail e senha; depois, use “Entrar com
  biometria”. O recurso requer Android 6.0 (API 23) ou superior e hardware/
  biometria configurados.
- **Rede:** o aparelho e o computador que executa o Json-Server precisam estar
  na mesma rede. O Json-Server de demonstração escuta em `0.0.0.0` para permitir
  o acesso pelo emulador/aparelho.

## Avaliação

O projeto demonstra integração Flutter com API REST, validação por hardware
(geolocalização e biometria), estado assíncrono, estados de erro/carregamento e
uma interface adaptável em Material 3. Para uma implantação real, a distância
também deve ser verificada pelo backend e a localização deve ser tratada como
um dado sujeito a falsificação no dispositivo.
