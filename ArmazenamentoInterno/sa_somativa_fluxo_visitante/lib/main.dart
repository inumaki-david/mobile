import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';
import 'theme/theme_manager.dart';

void main() async {
  // Garante que os widgets estão iniciados antes de chamar o SharedPreferences
  WidgetsFlutterBinding.ensureInitialized();
  
  ThemeManager themeManager = ThemeManager();
  await themeManager.loadTheme(); // Carrega o tema antes de rodar o app
  
  runApp(MyApp(themeManager: themeManager));
}

class MyApp extends StatelessWidget {
  final ThemeManager themeManager;
  
  const MyApp({Key? key, required this.themeManager}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Cores Base
    const colorPrimary = Color(0xFF1275E2);
    const colorSecondary = Color(0xFFF65C0E);

    // ================= TEMA DARK =================
    final darkTheme = ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF121414),
      primaryColor: colorPrimary,
      colorScheme: const ColorScheme.dark(
        primary: colorPrimary, secondary: colorSecondary,
        surface: Color(0xFF121414), onSurface: Color(0xFFE2E2E2),
      ),
      dividerColor: const Color(0xFF333535),
      textTheme: _buildTextTheme(Colors.white, const Color(0xFFC1C6D5)),
      cardTheme: const CardThemeData(
        color: Color(0xFF1E2020), elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          side: BorderSide(color: Color(0xFF282A2B), width: 1),
        ),
      ),
      appBarTheme: _buildAppBarTheme(const Color(0xFF121414), Colors.white),
      inputDecorationTheme: _buildInputTheme(const Color(0xFF1E2020), const Color(0xFF414753), colorPrimary, const Color(0xFFC1C6D5)),
      elevatedButtonTheme: _buildButtonTheme(colorPrimary),
    );

    // ================= TEMA LIGHT =================
    final lightTheme = ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF5F7FA), // Fundo cinza bem claro
      primaryColor: colorPrimary,
      colorScheme: const ColorScheme.light(
        primary: colorPrimary, secondary: colorSecondary,
        surface: Color(0xFFFFFFFF), onSurface: Color(0xFF121414),
      ),
      dividerColor: const Color(0xFFE2E8F0),
      textTheme: _buildTextTheme(const Color(0xFF121414), const Color(0xFF64748B)),
      cardTheme: const CardThemeData(
        color: Colors.white, elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          side: BorderSide(color: Color(0xFFE2E8F0), width: 1),
        ),
      ),
      appBarTheme: _buildAppBarTheme(colorPrimary, Colors.white), // AppBar azul no modo claro
      inputDecorationTheme: _buildInputTheme(Colors.white, const Color(0xFFCBD5E1), colorPrimary, const Color(0xFF64748B)),
      elevatedButtonTheme: _buildButtonTheme(colorPrimary),
    );

    // O ListenableBuilder escuta as mudanças do botão de trocar tema
    return ListenableBuilder(
      listenable: themeManager,
      builder: (context, child) {
        return MaterialApp(
          title: 'Controle de Condomínio',
          debugShowCheckedModeBanner: false,
          themeMode: themeManager.themeMode, // Define se é Dark ou Light
          theme: lightTheme,
          darkTheme: darkTheme,
          home: HomeScreen(themeManager: themeManager), // Passamos o manager para a tela inicial
        );
      },
    );
  }

  // ================= MÉTODOS AUXILIARES DE ESTILIZAÇÃO =================
  TextTheme _buildTextTheme(Color colorPrimaryText, Color colorSecondaryText) {
    return TextTheme(
      headlineMedium: GoogleFonts.ubuntu(fontSize: 24, fontWeight: FontWeight.w600, color: colorPrimaryText),
      titleLarge: GoogleFonts.ubuntu(fontSize: 20, fontWeight: FontWeight.w600, color: colorPrimaryText),
      bodyLarge: GoogleFonts.questrial(fontSize: 16, fontWeight: FontWeight.w400, color: colorPrimaryText),
      bodyMedium: GoogleFonts.questrial(fontSize: 14, fontWeight: FontWeight.w400, color: colorSecondaryText),
      labelSmall: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600),
      labelLarge: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
    );
  }

  AppBarTheme _buildAppBarTheme(Color bgColor, Color textColor) {
    return AppBarTheme(
      backgroundColor: bgColor, elevation: 0, centerTitle: false,
      titleTextStyle: GoogleFonts.ubuntu(fontSize: 24, fontWeight: FontWeight.w600, color: textColor),
      iconTheme: IconThemeData(color: textColor),
    );
  }

  InputDecorationTheme _buildInputTheme(Color fill, Color border, Color focus, Color label) {
    return InputDecorationTheme(
      filled: true, fillColor: fill,
      labelStyle: GoogleFonts.questrial(color: label),
      prefixIconColor: label,
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: border, width: 1)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: focus, width: 1.5)),
    );
  }

  ElevatedButtonThemeData _buildButtonTheme(Color primary) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary, foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    );
  }
}