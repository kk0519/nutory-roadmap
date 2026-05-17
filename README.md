# 🍚 Meshilog（メシログ）

> 栄養の家計簿 — コンビニ・QR決済連携で栄養を自動管理するiOSアプリ

## コンセプト

マネーフォワードが「銀行・クレカ連携で家計を自動管理」したように、  
Meshilog は「コンビニ・QR決済・外食チェーン連携で栄養を自動管理」する。

**目標：食事記録の80%以上を自動化**

## 技術スタック

| 項目 | 採用 |
|---|---|
| UI | SwiftUI |
| 認証・DB | Firebase（Spark無料プラン） |
| ローカルDB | SQLite / GRDB |
| バーコード | AVFoundation |
| パッケージ管理 | Swift Package Manager |

## フェーズ

| フェーズ | 内容 | 時期 |
|---|---|---|
| Ph.0 ✅ | コンセプト確定 | 2026-05 |
| Ph.1 🔨 | 設計・UI/UX | 2026-06〜07 |
| Ph.2 | コア開発 MVP | 2026-07〜09 |
| Ph.3 | コンビニ・QR連携 | 2026-09〜11 |
| Ph.4 | TestFlight β | 2026-11〜2027-01 |
| Ph.5 🎯 | App Store ローンチ | 2027-01〜03 |

## ロードマップ

[▶ WEBロードマップを見る](https://kk0519.github.io/nutory-roadmap/)

## ディレクトリ構成

```
NutriLedger/
├── docs/              # GitHub Pages ロードマップ
├── design/            # 設計ドキュメント
│   ├── firestore_schema.md
│   ├── jan_code_db.md
│   └── project_structure.md
└── Meshilog/          # Xcodeプロジェクト（Ph.2〜）
```
