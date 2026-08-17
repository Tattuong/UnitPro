# Google Play IAP — UnitPro

Package: `com.UnitProMNG.UnitPro`

## Coin packs (consumable)
| Product ID | Coins |
|------------|-------|
| unp_pack_1 | 50 |
| unp_pack_2 | 100 |
| unp_pack_3 | 200 |
| unp_pack_4 | 350 |
| unp_pack_5 | 500 |
| unp_pack_6 | 750 |
| unp_pack_7 | 1000 |
| unp_pack_8 | 1500 |
| unp_pack_9 | 2200 |
| unp_pack_10 | 3000 |

## Premium (non-consumable)
- `unp_remove_ads` — Remove ads

## Remote kill-switch
GET `https://api2.blwsmartware.net/N233.json`

If `disable=1`: hide Google Billing UI, shop with coins still works.

Expected JSON fields: `name`, `id`, `version`, `disable`, `code`, `status`, `msg`
