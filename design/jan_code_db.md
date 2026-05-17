# JANコードDB 調査・選定 — Meshilog

## 選定結果（MVP採用）

| 優先度 | DB | 用途 | 料金 |
|---|---|---|---|
| ★★★ | **Open Food Facts** | メイン食品DB（バーコードスキャン） | **無料** |
| ★★★ | **文科省 食品成分DB** | 栄養素精度補完（一般食材） | **無料** |
| ★★☆ | カロリーSlism スクレイピング | コンビニ商品補完 | 無料（自前） |
| ★☆☆ | JANコード.com API | JAN→商品名のみ（栄養なし） | 有料→不採用 |

---

## 採用DB詳細

### 1. Open Food Facts（メイン）
- **URL:** https://world.openfoodfacts.org/
- **API:** `https://world.openfoodfacts.org/api/v0/product/{barcode}.json`
- **収録数:** 300万件以上（日本食品も充実）
- **ライセンス:** ODbL（商用利用可）
- **レスポンス例:**
```json
{
  "product": {
    "product_name": "サラダチキンプレーン",
    "nutriments": {
      "energy-kcal_100g": 101,
      "proteins_100g": 21.5,
      "fat_100g": 1.1,
      "carbohydrates_100g": 0.0,
      "fiber_100g": 0.0
    }
  }
}
```
- **Swift実装:**
```swift
let url = URL(string: "https://world.openfoodfacts.org/api/v0/product/\(janCode).json")!
```

### 2. 文科省 食品成分データベース（補完）
- **URL:** https://fooddb.mext.go.jp/
- **形式:** CSV / Excel ダウンロード（API なし）
- **収録数:** 約2500品目（米・肉・魚・野菜等の基本食材）
- **活用法:** アプリバンドル用 SQLite に変換してローカル参照
- **更新頻度:** 数年に1回（安定）

### 3. コンビニ商品補完（スクレイピング）
- **セブン:** https://7premium.jp/ （商品ページに栄養成分あり）
- **ファミマ:** https://www.family.co.jp/goods.html
- **ローソン:** https://www.lawson.co.jp/recommend/original/
- **更新:** 週1回 Cloud Functions でクロール → Firestore `/foods` に自動反映

---

## MVP実装フロー

```
バーコードスキャン（JAN取得）
    ↓
① ローカルSQLite（文科省DB）→ ヒット → 即表示
    ↓ ミス
② Firestore /foods/{jan} → ヒット → キャッシュ済み表示
    ↓ ミス
③ Open Food Facts API → ヒット → Firestoreに保存 → 表示
    ↓ ミス
④ 手動入力フォールバック → ユーザー入力 → Firestoreに保存
```

→ **ヒット率目標: 85%以上自動解決**（コンビニ商品はほぼ③でカバー）

---

## 将来拡張（Ph.3以降）

| フェーズ | 追加DB | 効果 |
|---|---|---|
| Ph.3 | コンビニ購入履歴API（7iD/ファミペイ/Ponta） | 商品名→栄養自動マッピング |
| Ph.6 | ユーザー投稿DB（コミュニティ） | 長尾品目のカバー率向上 |
| Ph.8 | Edamam / USDA（グローバル展開用） | 英語圏対応 |

---

最終更新：2026-05-17 | Ph.1 設計フェーズ
