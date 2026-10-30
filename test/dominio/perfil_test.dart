import 'package:flutter_test/flutter_test.dart';
import 'package:app_academica/dominio/perfil.dart';

void main() {
  test('el perfil vacío no es válido', () {
    expect(Perfil.vacio.esValido, isFalse);
  });

  test('un nombre con solo espacios no es válido', () {
    expect(const Perfil(nombre: '   ').esValido, isFalse);
  });

  test('con nombre es válido aunque falten institución y programa', () {
    expect(const Perfil(nombre: 'Juan David').esValido, isTrue);
  });

  test('copyWith e igualdad', () {
    final p = Perfil.vacio.copyWith(nombre: 'Juan David', institucion: 'ITM');
    expect(p, equals(const Perfil(nombre: 'Juan David', institucion: 'ITM')));
  });
}
