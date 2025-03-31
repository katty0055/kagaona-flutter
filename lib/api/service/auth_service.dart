class MockAuthService {
  Future<bool> login(String username, String password) async {
    // Verifica que las credenciales no sean nulas ni vacías
    if (username.isEmpty || password.isEmpty) {
      print('Error: Usuario o contraseña no pueden estar vacíos.');
      return false;
    }

    // Simula un retraso de red
    await Future.delayed(Duration(seconds: 1));

    // Imprime las credenciales en la consola
    print('Intentando iniciar sesión con:');
    print('Usuario: $username');
    print('Contraseña: $password');

    // Retorna true para simular un inicio de sesión exitoso
    return true;
  }
}