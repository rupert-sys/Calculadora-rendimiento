# Calculadora de Rendimiento

Calculadora financiera con ingresos, egresos, inversiones, tarjeta de crédito y un simulador en el tiempo. Está hecha en Flutter para correr en Android, iOS, macOS, Windows y web con un solo código. La primera plataforma es Android.

## Requisitos

- [Flutter](https://docs.flutter.dev/get-started/install) (canal stable)
- Android Studio con el SDK de Android y un emulador, o un teléfono con depuración USB

## Correr en Android

```bash
flutter pub get
flutter run            # elige el emulador o el teléfono conectado
```

## Pruebas y análisis

```bash
flutter analyze
flutter test
flutter build apk --debug   # genera build/app/outputs/flutter-apk/app-debug.apk
```

GitHub Actions corre estos tres pasos en cada PR y deja el APK como artefacto descargable.

## Estructura

```
lib/
  main.dart                 punto de entrada (ProviderScope de Riverpod)
  app/app.dart              MaterialApp y tema
  app/app_shell.dart        navegación: barra inferior en teléfono, menú lateral en tablet
  core/finanzas/            fórmulas en Dart puro, sin interfaz
  data/                     base de datos local (Drift + SQLite) y proveedores de Riverpod
  features/resumen/         resumen del mes por categoría
  features/movimientos/     lista y formulario de ingresos y egresos
  features/inversiones/     inversiones con proyección a 1, 5 y 10 años
  features/tarjetas/        tarjetas de crédito y comparador de pagos
  features/simulador/       proyección de patrimonio y escenarios "qué pasa si"
  features/comun/           campos y textos compartidos
  features/rendimiento/     pantalla de cálculo de rendimiento
test/                       pruebas unitarias y de widgets
android/                    proyecto Android generado por Flutter
```

Cada módulo nuevo (ingresos, egresos, inversiones, tarjeta, simulador) va en su propia carpeta dentro de `lib/features/`, y sus fórmulas en `lib/core/finanzas/` con su prueba en `test/core/`.

## Base de datos

El esquema está en `lib/data/base_datos.dart`. Después de cambiarlo, regenera el código:

```bash
dart run build_runner build
```

## Otras plataformas

Se agregan en la fase 6 del plan con:

```bash
flutter create --platforms=ios,macos,windows,web .
```

## Publicar en Google Play

Play pide un Android App Bundle (`.aab`) firmado con tu llave de subida.

1. Crea la llave una sola vez y guárdala fuera del repo:

   ```bash
   keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA \
     -keysize 2048 -validity 10000 -alias upload
   ```

2. En GitHub, en Settings > Secrets and variables > Actions, agrega:
   - `ANDROID_KEYSTORE_BASE64`: la salida de `base64 -i ~/upload-keystore.jks` (en Linux, `base64 -w0`)
   - `ANDROID_KEYSTORE_PASSWORD`: la contraseña del keystore
   - `ANDROID_KEY_ALIAS`: `upload`
   - `ANDROID_KEY_PASSWORD`: la contraseña de la llave (si es la misma, puedes omitirlo)

3. En la pestaña Actions, corre **Release Android** y descarga el artefacto `app-release-aab-N`.

Para compilarlo en tu máquina, crea `android/key.properties` (no se sube a git):

```properties
storePassword=...
keyPassword=...
keyAlias=upload
storeFile=/ruta/a/upload-keystore.jks
```

y corre `flutter build appbundle --release`. El aviso de privacidad que pide Play está en `docs/privacidad.md`.
