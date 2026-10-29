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
  core/finanzas/            fórmulas en Dart puro, sin interfaz
  features/rendimiento/     pantalla de cálculo de rendimiento
test/                       pruebas unitarias y de widgets
android/                    proyecto Android generado por Flutter
```

Cada módulo nuevo (ingresos, egresos, inversiones, tarjeta, simulador) va en su propia carpeta dentro de `lib/features/`, y sus fórmulas en `lib/core/finanzas/` con su prueba en `test/core/`.

## Otras plataformas

Se agregan en la fase 6 del plan con:

```bash
flutter create --platforms=ios,macos,windows,web .
```
