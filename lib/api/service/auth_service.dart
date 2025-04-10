class MockAuthService {
  Future<bool> login(String username, String password) async {
    // Verifica que las credenciales no sean nulas ni vacías
    if (username.isEmpty || password.isEmpty) {
      return false;
    }

    // Simula un retraso de red
    await Future.delayed(const Duration(seconds: 1));

    // Retorna true para simular un inicio de sesión exitoso
    return true;
  }
}