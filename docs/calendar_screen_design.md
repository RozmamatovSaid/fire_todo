# Kalendar (Daily Task) Ekrani Dizayni va Arxitekturasi

Ushbu hujjat loyihaning mavjud arxitekturasi va UI tizimidan kelib chiqib, **Kalendar (Daily Task) ekrani** dizayni hamda uning amalga oshirilishini batafsil tushuntiradi.

---

## 1. Umumiy Maqsad

Kalendar ekrani foydalanuvchiga vazifalarni oylik taqvim ko'rinishida ko'rish, kunlar bo'yicha saralash va boshqarish imkonini beradi.
Dizayn loyihadagi mavjud ranglar palitrasi, shriftlar va widgetlar bilan to'liq mos kelishi kerak.

---

## 2. UI/UX Komponentlari va Tuzilishi

Ekran to'rtta asosiy qismdan tashkil topadi:

### A. Yuqori qism (Header)
* **Ma'lumotlar:** Tanlangan kunning nomi (hafta kuni, masalan: `Thursday`) va sana formatlangan holda (masalan: `7,June,2023`).
  * Hafta kuni uchun `AppFonts.recoleta` shrifti ishlatiladi (o'lchami: 24, qalinligi: `FontWeight.w600`, rangi: `AppColors.white`).
  * Sana matni `AppColors.grey400` yoki `AppColors.white` rangda ko'rsatiladi.
* **Navigatsiya:** Oy va kunlarni o'zgartirish uchun chap (`<`) va o'ng (`>`) aylanma tugmalari mavjud. Ushbu tugmalar tanlangan kunni mos ravishda oldingi yoki keyingi kunga o'tkazadi (yoki oy bo'yicha harakatlanadi).

### B. Hafta Kunlari Satri (Weekdays Row)
* **Format:** `M  T  W  T  F  S  S` (Dushanbaday Yakshanbagacha).
* **Ko'rinish (Active State):**
  * Barcha hafta kunlari oq rangli doira ichida qora matn ko'rinishida bo'ladi.
  * Tanlangan kunning hafta kuni esa **oltin (oltin-sariq, `AppColors.gold`)** rangli doira ichida qora matn bilan ajratib ko'rsatiladi.
  * *Eslatma:* Kalendar yopiq yoki nofaol holatda bo'lganda, ushbu doiralar to'q kulrang (`AppColors.grey`) ko'rinishga keladi.

### C. Oylik Kalendar Setkasi (Monthly Calendar Grid)
* **Tuzilishi:** `GridView` yordamida 7 ta ustundan iborat setka yaratiladi.
* **Kunlarning holatlari:**
  * **Joriy tanlangan kun:** Oq rangli aylanma chegara (border) bilan o'raladi.
  * **Vazifalari mavjud kunlar:** Ushbu kunlar ustida (yoki orqa fonida) loyihadagi mavjud sariq rangli chizilgan zigzag rasmi (`AppAssets.zigzag`) ko'rsatiladi.
  * **Boshqa oydan bo'lgan kunlar:** Matni xiralashtirilgan (`AppColors.grey500` yoki opacity bilan) ko'rsatiladi.
  * **Kun ustiga bosilganda:** `selectedDate` yangilanadi va pastdagi vazifalar ro'yxati o'sha kunga mos ravishda yuklanadi.

### D. Vazifalar Ro'yxati (Your Tasks)
* **Sarlavha:** "Your Task" sarlavhasi (`AppStrings.yourTask` yoki mos tarjima).
* **Ro'yxat:** Tanlangan kunga tegishli vazifalar `TaskItemCard` widgeti yordamida ko'rsatiladi.
  * Ushbu widget loyihada tayyor bo'lib, uning ichida vazifani bajarilgan deb belgilash, o'chirish (Dismissible swipe-to-delete) va batafsil sahifaga o'tish funksiyalari mavjud.
* **Bo'sh holat:** Agar tanlangan kunda hech qanday vazifa bo'lmasa, loyihadagi `TaskNotAvailableWidget` widgeti ko'rsatiladi.

---

## 3. Loyihadagi Mavjud Resurslardan Foydalanish

Ekranni amalga oshirishda quyidagi tayyor komponent va resurslardan foydalaniladi:

| Resurs nomi | Turi | Ishlatilishi |
| :--- | :--- | :--- |
| `AppColors` | Class / Ranglar | `AppColors.background`, `AppColors.gold`, `AppColors.white`, `AppColors.grey`, `AppColors.grey400` |
| `AppAssets.zigzag` | Asset (SVG) | Vazifasi bor kunlar ustiga chiziladigan sariq chiziq (zigzag) |
| `GlobalText` | Widget | Loyihada matnlar uchun ishlatiladigan universal widget |
| `GlobalImage` | Widget | SVG va PNG rasmlarni ko'rsatish uchun ishlatiladigan universal widget |
| `TaskItemCard` | Widget | Vazifalarni kartochka ko'rinishida ko'rsatuvchi widget |
| `TaskNotAvailableWidget` | Widget | Vazifalar bo'lmaganda ko'rsatiladigan bo'sh holat sahifasi |
| `TaskBloc` | BLoC | Vazifalarni yuklash, yangilash va o'chirishni boshqarish uchun |

---

## 4. Arxitektura va Ma'lumotlar Oqimi (BLoC & Isar)

1. Ekranda tanlangan oy o'zgarganda yoki kalendar ochilganda, loyihadagi barcha vazifalar (`getAllTasks`) ma'lumotlar omboridan (Isar) yuklab olinadi va qaysi kunlarda vazifa borligi (zigzag belgisini qo'yish uchun) aniqlanadi.
2. Foydalanuvchi biror kunni tanlaganda, `GetTasksByDateEvent(date: selectedDate)` hodisasi (event) `TaskBloc`-ga yuboriladi.
3. `TaskBloc` tanlangan kunga tegishli vazifalarni yuklaydi va ekranga uzatami.
4. Foydalanuvchi vazifani o'zgartirganda (`UpdateTaskEvent`) yoki o'chirganda (`DeleteTaskEvent`), `TaskBloc` o'zgarishlarni saqlaydi va kalendar filtrini buzmasdan joriy kun vazifalarini qayta yuklaydi.
