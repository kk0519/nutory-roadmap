# SwiftUI プロジェクト構造設計 — Meshilog

## Xcode プロジェクト構成

```
Meshilog/
├── App/
│   ├── MeshilogApp.swift          # @main エントリーポイント
│   └── ContentView.swift          # TabView ルート
│
├── Features/                      # 機能別モジュール
│   ├── Dashboard/
│   │   ├── DashboardView.swift    # 今日の栄養収支
│   │   ├── CalorieRingView.swift  # カロリーリング
│   │   └── NutrientBarView.swift  # PFCバー
│   │
│   ├── Scanner/
│   │   ├── ScannerView.swift      # バーコードスキャン画面
│   │   ├── ScannerViewModel.swift
│   │   └── ProductResultView.swift
│   │
│   ├── MealLog/
│   │   ├── MealLogView.swift      # 食事記録一覧
│   │   ├── MealLogViewModel.swift
│   │   └── AddMealView.swift      # 手動追加フォーム
│   │
│   ├── Report/
│   │   ├── WeeklyReportView.swift # 週次レポート
│   │   └── ReportViewModel.swift
│   │
│   └── Settings/
│       ├── SettingsView.swift
│       └── TargetSettingView.swift # 目標カロリー設定
│
├── Services/                      # データ・API層
│   ├── Firebase/
│   │   ├── AuthService.swift      # Firebase Auth
│   │   ├── MealRepository.swift   # Firestore CRUD
│   │   └── FoodRepository.swift   # /foods コレクション
│   │
│   ├── FoodDB/
│   │   ├── OpenFoodFactsService.swift  # API呼び出し
│   │   ├── LocalFoodDBService.swift    # SQLite（文科省DB）
│   │   └── FoodLookupService.swift    # フォールバック統合
│   │
│   └── Scanner/
│       └── BarcodeService.swift   # AVFoundation ラッパー
│
├── Models/                        # データモデル
│   ├── Meal.swift
│   ├── FoodItem.swift
│   ├── NutritionFacts.swift
│   ├── DailySummary.swift
│   └── UserProfile.swift
│
├── Utils/
│   ├── Extensions/
│   │   ├── Color+Theme.swift      # アクセントカラー定義
│   │   └── Date+Format.swift
│   └── Constants.swift            # Magic numbers 排除
│
└── Resources/
    ├── Assets.xcassets
    ├── foods.sqlite               # 文科省DB（バンドル）
    └── GoogleService-Info.plist   # Firebase設定
```

---

## タブ構成（TabView）

```
TabView
├── [🏠] Dashboard    — 今日の栄養収支
├── [📷] Scanner      — バーコードスキャン
├── [📋] MealLog      — 食事記録
├── [📊] Report       — 週次レポート
└── [⚙️] Settings    — 設定・目標
```

---

## 画面遷移フロー

```
起動
  └─ 未ログイン → LoginView（Firebase Auth）
  └─ ログイン済み → DashboardView

DashboardView
  ├─ + ボタン → ScannerView
  │              └─ スキャン成功 → ProductResultView
  │                               └─ 追加確認 → MealLog更新
  ├─ 記録一覧タップ → MealLogView
  └─ レポートタブ → WeeklyReportView
```

---

## 技術スタック確定

| 項目 | 採用技術 | 理由 |
|---|---|---|
| UI | SwiftUI | 最新・宣言的・Apple推奨 |
| 認証 | Firebase Auth | 無料・Google/Apple Sign-in対応 |
| DB（クラウド） | Firestore | リアルタイム同期・無料枠大 |
| DB（ローカル） | SQLite (GRDB) | 文科省DB高速検索 |
| バーコード | AVFoundation | iOS標準・追加ライブラリ不要 |
| 画像認識（Ph.6） | Vision Framework | iOS標準 |
| パッケージ管理 | Swift Package Manager | Xcode統合 |
| CI/CD | GitHub Actions + Fastlane | 自動ビルド・TestFlight配布 |

---

## GitHub ブランチ戦略

```
main          ← リリース済みコード（App Store）
develop       ← 統合ブランチ
feature/*     ← 機能開発
hotfix/*      ← 緊急バグ修正
```

---

最終更新：2026-05-17 | Ph.1 設計フェーズ
