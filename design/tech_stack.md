# 技術スタック確定 — Meshilog

## 変更経緯

当初 SwiftUI を想定していたが、開発環境が Windows のため **Flutter** に変更。
Flutter は iOS / Android 単一コードベースで対応でき、Ph.8（Android対応）も自動解決する。

---

## 確定技術スタック

| 項目 | 採用技術 | 理由 |
|---|---|---|
| **UI フレームワーク** | **Flutter（Dart）** | Windows開発可・iOS+Android単一コード |
| **ローカル開発環境** | VS Code + Flutter SDK | Windows対応・無料 |
| **認証** | Firebase Auth | 無料・Google/Apple Sign-in対応 |
| **クラウドDB** | Firestore | リアルタイム同期・無料枠大 |
| **ローカルDB** | sqflite（Flutter SQLite） | 文科省DB高速検索 |
| **バーコードスキャン** | mobile_scanner パッケージ | iOS/Android対応・最新 |
| **iOS ビルド（CI）** | Codemagic 無料枠 | Mac不要・月500分無料 |
| **パッケージ管理** | pub.dev | Flutter公式 |
| **状態管理** | Riverpod | Flutter標準的・テスタブル |

---

## 開発フロー（Windows環境）

```
[Windows PC / VS Code]
    ↓ コード編集（Dart / Flutter）
    ↓ flutter run → Android Emulator or 実機(Android)でローカル確認
    ↓ git push → GitHub
    ↓ Codemagic CI
         ├─ iOS ビルド（macOS runner） → TestFlight
         └─ Android ビルド → Play Console（Ph.8）
```

---

## Windows セットアップ手順

```
1. Flutter SDK インストール
   https://docs.flutter.dev/get-started/install/windows

2. VS Code + Flutter拡張
   - Flutter (by Dart Code)
   - Dart (by Dart Code)

3. Android Studio（エミュレータ用のみ・SDK Manager）

4. firebase_cli インストール
   npm install -g firebase-tools

5. FlutterFire CLI
   dart pub global activate flutterfire_cli
   flutterfire configure
```

---

## 主要 Flutter パッケージ（pubspec.yaml）

```yaml
dependencies:
  flutter:
    sdk: flutter

  # Firebase
  firebase_core: ^3.0.0
  firebase_auth: ^5.0.0
  cloud_firestore: ^5.0.0
  firebase_storage: ^12.0.0

  # スキャン
  mobile_scanner: ^5.0.0

  # 状態管理
  flutter_riverpod: ^2.5.0
  riverpod_annotation: ^2.3.0

  # ローカルDB
  sqflite: ^2.3.0
  path: ^1.9.0

  # HTTP
  dio: ^5.4.0

  # UI
  fl_chart: ^0.68.0        # グラフ（週次レポート）
  percent_indicator: ^4.2.3 # カロリーリング

dev_dependencies:
  flutter_test:
    sdk: flutter
  riverpod_generator: ^2.4.0
  build_runner: ^2.4.0
  flutter_lints: ^4.0.0
```

---

## Codemagic 無料枠（iOSビルド）

| プラン | 月間分数 | iOS対応 | 料金 |
|---|---|---|---|
| **Free** | **500分** | ✅ | **無料** |
| Pro | 2000分 | ✅ | $99/月 |

→ MVP段階（月数回のビルド）は **無料枠で十分**

---

## Flutter プロジェクト構造

```
meshilog/
├── lib/
│   ├── main.dart
│   ├── app.dart                    # MaterialApp + Router
│   │
│   ├── features/
│   │   ├── dashboard/
│   │   │   ├── dashboard_screen.dart
│   │   │   ├── calorie_ring_widget.dart
│   │   │   └── nutrient_bar_widget.dart
│   │   │
│   │   ├── scanner/
│   │   │   ├── scanner_screen.dart
│   │   │   └── scan_result_sheet.dart
│   │   │
│   │   ├── meal_log/
│   │   │   ├── meal_log_screen.dart
│   │   │   └── add_meal_screen.dart
│   │   │
│   │   ├── report/
│   │   │   └── weekly_report_screen.dart
│   │   │
│   │   └── settings/
│   │       └── settings_screen.dart
│   │
│   ├── services/
│   │   ├── auth_service.dart
│   │   ├── meal_repository.dart
│   │   ├── food_lookup_service.dart      # Open Food Facts + ローカルDB
│   │   └── open_food_facts_api.dart
│   │
│   ├── models/
│   │   ├── meal.dart
│   │   ├── food_item.dart
│   │   ├── nutrition_facts.dart
│   │   └── daily_summary.dart
│   │
│   └── utils/
│       ├── theme.dart              # カラー定義（エメラルドグリーン）
│       └── constants.dart
│
├── assets/
│   └── foods.db                   # 文科省DB（SQLite）
│
├── ios/                           # Codemagicがビルド
├── android/                       # ローカル確認用
├── pubspec.yaml
└── codemagic.yaml                 # CI設定
```

---

最終更新：2026-05-17 | Ph.1 設計フェーズ（Windows対応版）
