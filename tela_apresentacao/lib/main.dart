import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final Color azulFundoCard = const Color(0xFF1E3A8A);
  final Color azulBotaoIcone = const Color(0xFF5A95E2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: Column(
          children: [
            const UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF283593)),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                  'https://via.placeholder.com/150',
                ),
              ),
              accountName: Text('Nome Usuário'),
              accountEmail: Text('usuario@email.com'),
            ),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Editar Perfil'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Sair'),
              onTap: () {},
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        //permite que o usuário role a tela se o conteúdo for maior que o celular
        child: Column(
          children: [
            Container(
              width: double
                  .infinity, //faz o container ocupar a largura inteira da tela
              padding: const EdgeInsets.only(
                top: 40,
                bottom: 30,
                left: 20,
                right: 20,
              ),
              color: const Color(0xFF283593),
              child: Row(
                children: [
                  const CircleAvatar(
                    //cria a moldura circular para a foto de perfil
                    radius: 45,
                    backgroundColor: Colors.white24,
                    backgroundImage: NetworkImage(
                      'https://via.placeholder.com/150',
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    //faz o texto ocupar o resto do espaço da linha sem "dar erro" de transbordamento
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Nome Usuário',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Breve descrição sobre o usuário',
                          style: TextStyle(fontSize: 14, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            //seção de Estatísticas
            _buildSectionContainer(
              child: Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween, // Distribui os cartões igualmente no espaço
                children: [
                  _buildStatCard(Icons.favorite_border, '728.925', 'Likes'),
                  _buildStatCard(Icons.groups_outlined, '16.586', 'Followers'),
                  _buildStatCard(Icons.star_border, '2.574', 'Conquests'),
                ],
              ),
            ),

            //seção de Informações
            _buildSectionContainer(
              child: Column(
                children: [
                  _buildListTile('Habilidades'),
                  _buildListTile('Localização'),
                  _buildListTile('Empresa'),
                  _buildListTile('Formação'),
                  _buildListTile(
                    'Equipe',
                    hasDivider: false,
                  ), // O último item não precisa da linha divisória embaixo
                ],
              ),
            ),

            //seção de Redes Sociais
            _buildSectionContainer(
              child: Column(
                children: [
                  const Text(
                    'Siga-me nas Redes Sociais',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceEvenly, // Espaçamento igual entre os ícones sociais
                    children: [
                      _buildSocialButton(Icons.camera_alt_outlined),
                      _buildSocialButton(Icons.facebook),
                      _buildSocialButton(Icons.play_circle_outline),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),

      //a barra de navegação que em embaixo
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, //fixa os ícones
        currentIndex:
            4, //define que o ícone de perfil o 5º, índice 4 é o que está selecionado agora
        backgroundColor: const Color(0xFF283593),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          if (index == 0) {
            _scaffoldKey.currentState?.openDrawer();
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.mail_outline), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: ''),
        ],
      ),
    );
  }

  //esse método cria a caixinha azul arredondada que envolve cada seção
  Widget _buildSectionContainer({required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: azulFundoCard,
        borderRadius: BorderRadius.circular(12), //deixa as bordas arredondadas
      ),
      child: child,
    );
  }

  //cria os cartões pequenos de estatísticas do topo
  Widget _buildStatCard(IconData icon, String value, String label) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: azulBotaoIcone,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.black, size: 28),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 13,
            ),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Colors.white),
          ),
        ],
      ),
    );
  }

  //cria cada linha da lista
  Widget _buildListTile(String title, {bool hasDivider = true}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 5),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
        if (hasDivider)
          const Divider(
            color: Colors.white,
            height: 1,
          ), //desenha a linha se não for o último item
      ],
    );
  }

  //cria os containers das redes sociais
  Widget _buildSocialButton(IconData icon) {
    return Container(
      height: 60,
      width: 95,
      decoration: BoxDecoration(
        color: azulBotaoIcone,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: Colors.black, size: 30),
    );
  }
}
