# Firestore スキーマ設計 — Meshilog（メシログ）

## コレクション構造

```
/users/{uid}
/users/{uid}/meals/{mealId}
/users/{uid}/daily_summary/{date}
/foods/{janCode}
/restaurant_menus/{restaurantId}/items/{itemId}
```

---

## コレクション詳細

### `/users/{uid}` — ユーザープロフィール

```json
{
  "display_name": "string",
  "email": "string",
  "created_at": "timestamp",
  "target": {
    "calories": 2000,
    "protein_g": 80,
    "fat_g": 65,
    "carbs_g": 260,
    "fiber_g": 20
  },
  "plan": "free | premium",
  "premium_until": "timestamp | null",
  "linked_services": {
    "paypay": false,
    "line_pay": false,
    "seven_id": false,
    "fami_pay": false,
    "ponta": false
  }
}
```

---

### `/users/{uid}/meals/{mealId}` — 食事記録（メイン）

```json
{
  "recorded_at": "timestamp",
  "meal_type": "breakfast | lunch | dinner | snack",
  "source": "barcode | ocr | paypay | manual | photo_ai | convenience_api",
  "items": [
    {
      "food_name": "サラダチキンプレーン",
      "jan_code": "4902430432986",
      "calories": 116,
      "protein_g": 24.7,
      "fat_g": 1.3,
      "carbs_g": 0.0,
      "fiber_g": 0.0,
      "quantity": 1.0,
      "unit": "個"
    }
  ],
  "total_calories": 116,
  "total_protein_g": 24.7,
  "total_fat_g": 1.3,
  "total_carbs_g": 0.0,
  "memo": "string | null",
  "payment_ref": "string | null"
}
```

---

### `/users/{uid}/daily_summary/{date}` — 日次集計（date = "2026-05-17"）

```json
{
  "date": "2026-05-17",
  "total_calories": 1580,
  "total_protein_g": 68.0,
  "total_fat_g": 45.0,
  "total_carbs_g": 185.0,
  "total_fiber_g": 8.0,
  "meal_count": 3,
  "auto_recorded_count": 3,
  "manual_recorded_count": 1,
  "target_achievement": {
    "calories_pct": 79,
    "protein_pct": 85,
    "fat_pct": 69,
    "carbs_pct": 71
  }
}
```

---

### `/foods/{janCode}` — 食品マスタ（JANコードDB）

```json
{
  "jan_code": "4902430432986",
  "name": "サラダチキンプレーン 115g",
  "brand": "セブンプレミアム",
  "maker": "伊藤ハム",
  "retailer": "セブンイレブン",
  "per_100g": {
    "calories": 101,
    "protein_g": 21.5,
    "fat_g": 1.1,
    "carbs_g": 0.0,
    "fiber_g": 0.0,
    "salt_g": 0.8
  },
  "per_unit": {
    "weight_g": 115,
    "calories": 116,
    "protein_g": 24.7,
    "fat_g": 1.3,
    "carbs_g": 0.0,
    "fiber_g": 0.0
  },
  "image_url": "string | null",
  "source": "calorie_slism | open_food_facts | manual",
  "verified": true,
  "updated_at": "timestamp"
}
```

---

### `/restaurant_menus/{restaurantId}/items/{itemId}` — 外食チェーンメニュー

```json
{
  "restaurant_id": "mcdonalds_jp",
  "restaurant_name": "マクドナルド",
  "item_name": "ビッグマック",
  "category": "burger",
  "calories": 525,
  "protein_g": 26.0,
  "fat_g": 29.0,
  "carbs_g": 43.0,
  "fiber_g": 2.0,
  "salt_g": 2.6,
  "price_yen": 450,
  "available": true,
  "updated_at": "timestamp"
}
```

---

## Firestore セキュリティルール（基本）

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // ユーザーは自分のデータのみ読み書き可
    match /users/{uid}/{document=**} {
      allow read, write: if request.auth != null && request.auth.uid == uid;
    }
    // 食品マスタは認証済みユーザーなら読み取り可
    match /foods/{janCode} {
      allow read: if request.auth != null;
      allow write: if false; // 管理者のみ（Cloud Functions経由）
    }
    // 外食メニューも読み取りのみ
    match /restaurant_menus/{restaurantId}/{document=**} {
      allow read: if request.auth != null;
      allow write: if false;
    }
  }
}
```

---

## JANコードDB 候補

| DB名 | 特徴 | 料金 | 収録数 |
|---|---|---|---|
| **カロリーSlism API** | 日本食品特化・精度高 | 要問い合わせ | 約10万件 |
| **Open Food Facts** | OSS・無料・グローバル | 無料 | 300万件+ |
| **食品DB（文科省）** | 公式・信頼性最高 | 無料 | 約2500品目 |
| **独自収集** | コンビニ3社スクレイピング | 開発工数 | 随時更新 |

→ **MVP推奨：Open Food Facts（無料）+ 文科省DB を組み合わせ**。不足分は手動補完。

---

最終更新：2026-05-17 | Ph.1 設計フェーズ
