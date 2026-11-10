# BIM493 Mobile Programming I - Assignment #2: Smart Home Controller App

## 📱 Proje Özeti (Project Overview)
Bu proje, **BIM493 Mobile Programming I** dersinin 2. ödevi kapsamında geliştirilmiş bir **Smart Home Controller (Akıllı Ev Kontrolcüsü)** Flutter uygulamasıdır. 

Uygulama, nesne yönelimli programlama (OOP) prensiplerini ve Dart dilinin temel özelliklerini kapsamlı bir şekilde sergiler. Kullanıcıların farklı akıllı ev cihazlarını (akıllı lamba, termostat, akıllı hoparlör) görüntülemesine, durumlarını takip etmesine ve cihazlarla etkileşime girmesine olanak tanır.

---

## 🎯 Gereksinimlerin Gerçekleştirilmesi (Implementation Matrix)

Ödev şartnamesinde (`HW2.pdf`) istenen tüm isterler eksiksiz olarak karşılanmıştır:

| Kavram (Concept) | Şartname Gereksinimi (Requirement) | Gerçekleştirilen Kod & Dosya (Implementation) |
| :--- | :--- | :--- |
| **Class** | `SmartDevice` adında bir temel sınıf ve `SmartLight`, `Thermostat`, `SmartSpeaker` alt sınıfları oluşturulmalıdır. | [`lib/models/smart_device.dart`](file:///c:/Users/%C3%B6mer%20faruk/Desktop/estu%20dersler/2.%20y%C4%B1l/mobile/moble%20HW2/lib/models/smart_device.dart), [`lib/models/smart_light.dart`](file:///c:/Users/%C3%B6mer%20faruk/Desktop/estu%20dersler/2.%20y%C4%B1l/mobile/moble%20HW2/lib/models/smart_light.dart), [`lib/models/thermostat.dart`](file:///c:/Users/%C3%B6mer%20faruk/Desktop/estu%20dersler/2.%20y%C4%B1l/mobile/moble%20HW2/lib/models/thermostat.dart), [`lib/models/smart_speaker.dart`](file:///c:/Users/%C3%B6mer%20faruk/Desktop/estu%20dersler/2.%20y%C4%B1l/mobile/moble%20HW2/lib/models/smart_speaker.dart) |
| **Objects** | Birden çok cihaz nesnesi oluşturulmalı ve her alt sınıftan en az bir örnek ekranda gösterilmelidir. | `main.dart` içerisinde birden fazla `SmartLight`, `Thermostat` ve `SmartSpeaker` örneği oluşturulup arayüzde kartlar halinde listelenmektedir. |
| **Constructor** | Cihaz nesneleri oluşturulurken hem **varsayılan (default)** hem de **isimlendirilmiş (named)** kurucular kullanılmalıdır. | • Default: `SmartLight(...)`, `Thermostat(...)`, `SmartSpeaker(...)`<br>• Named: `SmartLight.off(...)`, `SmartLight.preset(...)`, `Thermostat.eco(...)`, `SmartSpeaker.active(...)` |
| **Inheritance** | `SmartLight`, `Thermostat` ve `SmartSpeaker` sınıfları `SmartDevice` temel sınıfından türetilmelidir (`extends`). | `class SmartLight extends SmartDevice ...`<br>`class Thermostat extends SmartDevice ...`<br>`class SmartSpeaker extends SmartDevice ...` |
| **Abstraction** | `SmartDevice` soyut (`abstract`) bir sınıf yapılmalı ve en az bir soyut metot içermelidir (`getStatus()`, `performAction()`). | `abstract class SmartDevice`<br>Soyut metotlar: `getStatus()`, `performAction()`, `getPrimaryProperty()` |
| **Interface** | Bir arayüz (ör. `Connectable`) tanımlanmalı ve cihaz sınıflarında uygulanmalıdır (`implements`). En az bir metot içermelidir. | [`lib/models/connectable.dart`](file:///c:/Users/%C3%B6mer%20faruk/Desktop/estu%20dersler/2.%20y%C4%B1l/mobile/moble%20HW2/lib/models/connectable.dart): `isConnected()`, `connect()`, `disconnect()` metotlarını içerir ve cihaz sınıflarında uygulanır. |
| **Mixin** | Bir mixin (ör. `Schedulable`) oluşturulmalı ve en az bir uygun cihaz sınıfında kullanılmalıdır (`with`). | [`lib/models/schedulable.dart`](file:///c:/Users/%C3%B6mer%20faruk/Desktop/estu%20dersler/2.%20y%C4%B1l/mobile/moble%20HW2/lib/models/schedulable.dart): `setSchedule()`, `clearSchedule()`, `getScheduleSummary()` içerir; `SmartLight` ve `Thermostat` sınıflarında `with Schedulable` olarak kullanılır. |
| **Keywords** | `static`, `super` ve `this` anahtar kelimelerinin kullanımı gösterilmelidir. | • `static`: `SmartDevice.totalDevices` sayaç değişkeni ve metotları.<br>• `super`: Alt sınıf kurucularında üst sınıf kurucusuna parametre aktarımı (`super(...)`).<br>• `this`: Sınıf alanlarının atanması ve metot parametre ayrımı. |

---

## 🖥️ Arayüz Özellikleri (UI Features)

- **Device List:** `SmartLight`, `Thermostat` ve `SmartSpeaker` kartlarını şık bir listeyle sunar.
- **Device Information:** Her kart cihazın adını, türe özgü ana özelliğini (Örn: `Brightness: 75%`, `Temperature: 22°C`, `Volume: 40%`) ve yeşil/gri durum noktası ile çalışma durumunu (Örn: `Status: ON`, `Status: Heating`, `Status: Paused`) gösterir.
- **Etkileşimli Kontroller (Interactions):**
  - **Akıllı Lamba (Smart Light):** Açma/Kapama Switch anahtarı. Kapatıldığında parlaklık 0% ve durum OFF olur, açıldığında önceki parlaklık geri yüklenir.
  - **Termostat (Thermostat):** `(-)` ve `(+)` dairesel butonları ile sıcaklık artırıp azaltma.
  - **Akıllı Hoparlör (Smart Speaker):** Dairesel mavi Oynat/Duraklat (Play/Pause) butonu.
- **Alt Metin (Bottom Text):** Ekranın altında `Total Devices: X` ifadesi yer alır. **Bu değer doğrudan `SmartDevice.totalDevices` statik değişkeninden okunmaktadır.**
- **Ekstra Kolaylıklar:**
  - Sağ üstteki açılır menü (menü ikonu) ile PDF'teki **Sample 1 (3 Cihaz)** ve **Sample 2 (5 Cihaz)** görünümleri arasında anında geçiş yapılabilir.
  - "Add Device" butonu ile yeni cihazlar (default veya named constructor seçilerek) dinamik olarak eklenebilir ve statik sayacın anlık arttığı gözlemlenebilir.
  - OOP bilgi penceresi ile projedeki tüm OOP kriterleri tek tıkla incelenebilir.

---

## 🧪 Testler ve Doğrulama (Tests & Verification)

Proje kapsamında hem OOP mantığını hem de widget arayüz etkileşimlerini test eden birim testleri hazırlanmıştır:

```bash
# Kod analizi (0 hata, 0 uyarı)
dart analyze

# Birim ve Widget testlerini çalıştırma (Tüm testler geçer)
flutter test
```

---

## 🚀 Projeyi Çalıştırma (How to Run)

```bash
# Bağımlılıkları yükleme
flutter pub get

# Uygulamayı başlatma (Chrome, Windows veya bağlı Android cihaz)
flutter run
```
