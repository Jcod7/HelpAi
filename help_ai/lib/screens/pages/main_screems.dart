import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:help_ai/screens/auth/login_screen.dart';
import 'package:help_ai/screens/pages/agenda_screen.dart';
import 'package:help_ai/screens/pages/chat_screen.dart';
import 'package:help_ai/screens/pages/home_screen.dart';
import 'package:help_ai/screens/pages/user_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PersistentTabController _controller = PersistentTabController(initialIndex: 0);

  // Pantallas de las pestañas
  List<Widget> _buildScreens() {
    return const [
      HomeScreen(title: 'Inicio'),
      AgendaScreen(title: 'Agenda'),
      HomeScreen(title: 'Inicio'),
      ChatScreen(title: 'Chat'),
      UserProfileScreen(title: 'Usuario'),
    ];
  }

  // Configuración de los elementos de la barra
  List<PersistentBottomNavBarItem> _navBarItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),
        inactiveIcon: const Icon(Icons.home_outlined),
        title: "Inicio",
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.calendar_today),
        inactiveIcon: const Icon(Icons.calendar_today_outlined),
        title: "Agenda",
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.chat),
        inactiveIcon: const Icon(Icons.chat_outlined),
        title: "Chat",
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.medical_services),
        inactiveIcon: const Icon(Icons.medical_services_outlined),
        title: "Tratamiento",
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.person),
        inactiveIcon: const Icon(Icons.person_outline),
        title: "Perfil",
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {

    const userData = {
      "name": "José Alfredo Romero Guillén",
      "profileImage": "assets/images/profile.jpg",
      "healthIndicators": [
        {"label": "Peso", "value": "85.5 kg"},
        {"label": "Glucosa", "value": "125 ml/dL"},
        {"label": "Tipo de sangre", "value": "O+"}
      ],
      "personalInfo": {
        "Edad": "65",
        "Altura": "1.85 cm",
        "Correo": "joseromero@gmail.com",
        "Dirección": "18 de Noviembre y Mercadillo"
      },
      "nextAppointment": {"date": "25/10/2024", "time": "10:15"},
      "prescription": {
        "medication": "Metformina 500 mg",
        "instructions": "Tomar 1 tableta después del desayuno"
      }
    };
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            iconSize: 50,
            color: const Color(0xFF4CC2FF),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                Image.asset(
                  'assets/images/logo1.png',
                  height: 50,
                ),
                ],
              ),
              ],
            ),
            ],
          ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 4,
      ),
       drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF4CC2FF),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage:
                        AssetImage(userData["profileImage"] as String),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    userData["name"]! as String,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Perfil'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Tratamiento'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar Sesión'),
              onTap: () async {
                try {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                    // ignore: use_build_context_synchronously
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                  );
                } catch (e) {
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al cerrar sesión: $e')),
                  );
                }
              },
            ),
          ],
        ),
      ),
      body: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarItems(),
        confineToSafeArea: true,
        backgroundColor: Colors.white,
        navBarHeight: kBottomNavigationBarHeight,
        handleAndroidBackButtonPress: true,
        stateManagement: true,
        hideNavigationBarWhenKeyboardAppears: true,
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
          colorBehindNavBar: const Color(0xFF4CC2FF),
        ),
        popBehaviorOnSelectedNavBarItemPress: PopBehavior.once,
        navBarStyle: NavBarStyle.style1,
        animationSettings: const NavBarAnimationSettings(
          navBarItemAnimation: ItemAnimationSettings(
            duration: Duration(milliseconds: 400),
            curve: Curves.ease,
          ),
          screenTransitionAnimation: ScreenTransitionAnimationSettings(
            animateTabTransition: true,
            duration: Duration(milliseconds: 300),
            screenTransitionAnimationType: ScreenTransitionAnimationType.fadeIn,
          ),
        ),
      ),
    );
  }
}
