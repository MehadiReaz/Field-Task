import 'package:shared_preferences/shared_preferences.dart';

class ThemeRepository {
  static const _kThemeModeKey = 'theme_mode';

  final SharedPreferences sharedPreferences;

  ThemeRepository(this.sharedPreferences);

  Future<void> saveThemeMode(String mode) async {
    await sharedPreferences.setString(_kThemeModeKey, mode);
  }

  String? getThemeMode() {
    return sharedPreferences.getString(_kThemeModeKey);
  }
}
