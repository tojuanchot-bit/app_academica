import 'configuracion_escala.dart';

class Perfil {
  const Perfil({
    required this.nombre,
    this.institucion = '',
    this.programa = '',
  });

  /// Perfil inicial antes de que el usuario lo llene.
  static const vacio = Perfil(nombre: '');

  final String nombre;
  final String institucion;
  final String programa;

  Perfil copyWith({String? nombre, String? institucion, String? programa}) {
    return Perfil(
      nombre: nombre ?? this.nombre,
      institucion: institucion ?? this.institucion,
      programa: programa ?? this.programa,
    );
  }

  /// Solo el nombre es obligatorio.
  bool get esValido => nombre.trim().isNotEmpty;

  @override
  bool operator ==(Object other) =>
      other is Perfil &&
      other.nombre == nombre &&
      other.institucion == institucion &&
      other.programa == programa;

  @override
  int get hashCode => Object.hash(nombre, institucion, programa);
}

/// Perfil y escala juntos: es lo que guarda y lee la pantalla de configuración.
typedef ConfiguracionUsuario = ({Perfil perfil, ConfiguracionEscala escala});

const ConfiguracionUsuario configuracionInicial = (
  perfil: Perfil.vacio,
  escala: ConfiguracionEscala.itm,
);
