import 'package:get/get.dart';

final Map strings = {
  // Cart
  'Səbət': ['Cart', 'Корзина'],
  'Səbətiniz boşdur': ['Your cart is empty', 'Ваша корзина пуста'],
  'Səhifəni yenilə': ['Refresh page', 'Обновить страницу'],
  'Toplam qiymət:': ['Price:', 'Цена:'],
  'Endirim:': ['Sale:', 'Скидка:'],
  'Yekun qiymət:': ['Total price:', 'Итоговая цена:'],
  'Toplam': ['Total', 'Всего'],
  'Sifarişi tamamla': ['Checkout', 'Оформить заказ'],

  // Checkout
  'Sifarişi təsdiqlə': ['Complete order', 'Подтвердить заказ'],
  'Səbətinizdə düzəldilməsi vacib məqamlar var.': ['There are some important things to correct in your cart.', 'В вашей корзине есть важные исправления.'],
  'Səbətə qayıt': ['Return cart', 'Вернуться в корзину'],
  'Adınız': ['First name', 'Имя'],
  'Adınızı qeyd etməmisiniz.': ['You must add a first name.', 'Вы должны указать имя.'],
  'Soyadınız': ['Last name', 'Фамилия'],
  'Soyadınızı qeyd etməmisiniz.': ['You must add a last name.', 'Вы должны указать фамилию.'],
  'Telefon': ['Phone', 'Телефон'],
  'Telefon qeyd etməmisiniz.': ['You must add a phone number.', 'Вы должны указать номер телефона.'],
  'Çatdırılma ünvanı': ['Delivery address', 'Адрес доставки'],
  'Çatdırılma ünvanı qeyd etməmisiniz.': ['You must add a delivery address.', 'Вы должны указать адрес доставки.'],
  'Email': ['Email', 'Эл. почта'],
  'Email qeyd etməmisiniz.': ['You must add an email.', 'Вы должны указать адрес электронной почты.'],
  'Əlavə qeydiniz': ['Your note', 'Ваш комментарий'],
  'Ödəniş forması': ['Payment method', 'Способ оплаты'],
  'Qapıda nağd ödəniş': ['Cash on delivery', 'Оплата наличными при доставке'],
  'Onlayn ödəniş': ['Credit card', 'Оплата кредитной картой'],

  // Wishlist
  'İstək listi': ['Wishlist', 'Список желаемого'],
  'İstək listiniz boşdur': ['Your wishlist is empty', 'Ваш список желаемого пуст'],

  // Add comment
  'Serverlə əlaqə yaratmaq mümkün olmadı.': ['Could not connect to the server.', 'Не удалось подключиться к серверу.'],
  'İnternet bağlantısı problemi var.': ['There is an internet connection problem.', 'Проблема с интернет-соединением.'],
  'Şərh bildirin': ['Write comment', 'Написать комментарий'],
  'Ad və soyadınız': ['Name and surname', 'Имя и фамилия'],
  'Ad və soyadınızı qeyd etməmisiniz.': ['You must add name and surname', 'Вы должны указать имя и фамилию'],
  'Email düzgün deyil.': ['Email is not valid', 'Неверный адрес электронной почты'],
  'Qiymətləndirmə': ['Rating', 'Рейтинг'],
  'Heç bir şərh qeyd etməmisiniz.': ['You must add a comment.', 'Вы должны добавить комментарий.'],
  'Göndər': ['Send', 'Отправить'],

  // Categories
  'Kateqoriyalar': ['Categories', 'Категории'],
  'Heç bir kateqoriya tapılmadı': ['No categories found', 'Категории не найдены'],

  // Filter
  'Filter': ['Filter', 'Фильтр'],
  'Təmizlə': ['Clear', 'Очистить'],
  'İmtina et': ['Cancel', 'Отмена'],
  'Təsdiqlə': ['Confirm', 'Подтвердить'],
  'Qiymət aralığı': ['Price range', 'Диапазон цен'],
  'Filterlə': ['Filter', 'Фильтр'],

  // Order completed
  'Sifariş qeydə alındı': ['Order completed', 'Заказ принят'],
  'Sifarişiniz uğurla qeydə alındı': ['Your order has been successfully received', 'Ваш заказ успешно принят'],
  'Sifarişə bax': ['View order', 'Просмотреть заказ'],

  // Payment canceled
  'Ödəmə problemi': ['Payment problem', 'Проблема с оплатой'],
  'Ödənişdən imtina edildi.': ['Payment canceled', 'Оплата отменена'],
  'Geriyə qayıt': ['Return back', 'Вернуться обратно'],

  // Payment declined
  'Ödəniş zamanı xəta baş verdi.': ['Error during payment', 'Ошибка при оплате'],

  // Payment
  'Ödəniş səhifəsindən çıxış edirsiniz. Çıxış etdiyinizdə ödənişdən imtina etmiş olacaqsınız.': ['You are leaving the payment page. Exiting will cancel the payment.', 'Вы покидаете страницу оплаты. Выход отменит платеж.'],

  // Single product
  'Məhsul uğurla səbətə əlavə edildi.': ['Product successfully added to the cart', 'Товар успешно добавлен в корзину'],
  'Səbətə at': ['Add to cart', 'Добавить в корзину'],

  // Change password
  'Şifrə dəyişdirilməsi': ['Change password', 'Изменение пароля'],
  'Şifrənizi dəyişdirmək istərmisinizsə, bu hissədə heç bir əməliyyat icra etməyin.': ['If you want to change your password, do not perform any operations in this section.', 'Если вы хотите изменить свой пароль, не выполняйте никаких операций в этом разделе.'],
  'Hazırkı şifrəniz': ['Current password', 'Текущий пароль'],
  'Hazırkı şifrənizi qeyd etməmisiniz.': ['You have not entered your current password.', 'Вы не ввели текущий пароль.'],
  'Yeni şifrə': ['New password', 'Новый пароль'],
  'Yeni şifrə qeyd etməmisiniz.': ['You have not entered a new password.', 'Вы не ввели новый пароль.'],
  'Yeni şifrənin təkrarı': ['Repeat new password', 'Повторите новый пароль'],
  'Yeni şifrənizin təkrarını qeyd etməmisiniz.': ['You have not entered a repeat of the new password.', 'Вы не ввели повтор нового пароля.'],
  'Yadda saxla': ['Save changes', 'Сохранить'],

  // Confirm account
  'Hesabınız təsdiqlənmişdir.': ['Your account is confirmed.', 'Ваш аккаунт подтвержден.'],
  'Emailinizə gələn kodu daxil edin.': ['Enter the code sent to your email.', 'Введите код, полученный на вашу почту.'],
  'Heç bir email almamısınızsa, "SPAM" qovluğuna nəzər yetirin': ['If you have not received any emails, check your "SPAM" folder.', 'Если вы не получили письма, проверьте папку "СПАМ".'],
  'Buraya əlavə et': ['Add here', 'Добавить здесь'],
  'Kopyalanmış kodu əlavə etmək istəyirsiniz': ['Do you want to add the copied code?', 'Хотите добавить скопированный код?'],
  'Daxil et': ['Enter', 'Ввести'],
  'İmtina': ['Cancel', 'Отмена'],
  'Təsdiq kodunu tam qeyd etməmisiniz.': ['You have not entered the confirmation code.', 'Вы не ввели код подтверждения.'],
  'Hələ də email ala bilməmisinizsə, vaxt bitdikdən sonra təkrar istək göndərin.': ['If you still haven\'t received the email, send the request again after the time has expired.', 'Если вы так и не получили письмо, отправьте запрос еще раз после истечения времени.'],
  'Təkrar göndər': ['Resend', 'Отправить повторно'],

  // Forgot password
  'Şifrənizi unutmusunuz?': ['Forgot your password?', 'Забыли пароль?'],
  'Aşağıdakı hissəyə email ünvanınızı daxil edərək şifrənizi sıfırlayın': ['Enter your email address below to reset your password', 'Введите свой адрес электронной почты ниже, чтобы сбросить пароль'],
  'İstifadəçi adı və ya email qeyd etməlisiniz.': ['You must enter a username or email.', 'Вы должны ввести имя пользователя или адрес электронной почты.'],
  'Sıfırla': ['Reset', 'Сброс'],

  // Login
  'Hesabınız aktiv deyil.': ['Your account is not active.', 'Ваш аккаунт неактивен.'],
  'Xoş gəlmisiniz!': ['Welcome!', 'Добро пожаловать!'],
  'Email ünvanı': ['Email address', 'Адрес электронной почты'],
  'Şifrə': ['Password', 'Пароль'],
  'Hesab şifrəsi': ['Account password', 'Пароль аккаунта'],
  'Şifrə qeyd etməmisiniz.': ['You have not entered a password.', 'Вы не ввели пароль.'],
  'Daxil ol': ['Log in', 'Войти'],
  'Sistem üzərində hesabınız yoxdur?': ['Don\'t have an account on the system?', 'У вас нет аккаунта в системе?'],
  'Qeydiyyatdan keç': ['Register', 'Зарегистрироваться'],

  // Orders
  'Sifarişləriniz': ['Your orders', 'Ваши заказы'],
  'Sifariş:': ['Order:', 'Заказ:'],
  'Toplam:': ['Total:', 'Итого:'],
  'Məhsul:': ['Product:', 'Товар:'],
  'Detallar': ['Details', 'Детали'],
  'Göstəriləcək başqa sifariş yoxdur.': ['No other orders to display.', 'Нет других заказов для отображения.'],

  // Registration
  'Yeni hesab yaradın': ['Create a new account', 'Создайте новый аккаунт'],
  'Adınızı qeyd etməlisiniz.': ['You must enter your name.', 'Вы должны ввести свое имя.'],
  'Soyadınızı qeyd etməlisiniz.': ['You must enter your surname.', 'Вы должны ввести свою фамилию.'],
  'Şifrənin təkrarı': ['Repeat password', 'Повторите пароль'],
  'Şifrənizin təkrarını qeyd etməmisiniz.': ['You have not entered a repeat of the password.', 'Вы не ввели повтор пароля.'],
  'Şifrəniz təkrarı ilə eyni deyil.': ['Your password repeat does not match.', 'Повтор вашего пароля не совпадает.'],
  'Artıq qeydiyyatdan keçmisiniz?': ['Already registered?', 'Уже зарегистрированы?'],

  // Single order
  'Sifariş detalları': ['Order details', 'Детали заказа'],
  'Heç bir sifariş tapılmadı': ['No orders found', 'Заказов не найдено'],
  'Sifariş tarixi': ['Order date', 'Дата заказа'],
  'Sifariş nömrəsi': ['Order number', 'Номер заказа'],
  'Ödəniş üsulu': ['Payment method', 'Способ оплаты'],
  'Toplam ödəniş': ['Total payment', 'Общая сумма к оплате'],
  'Sifariş etdikləriniz:': ['Your orders:', 'Ваши заказы:'],
  'Sifarişçi məlumatları:': ['Customer information:', 'Информация о клиенте:'],

  // Userinfo
  'Şəxsi məlumatlarınız': ['Your personal information', 'Ваши личные данные'],
  'Dəyişdir': ['Change', 'Изменить'],

  // About
  'Haqqımızda': ['About us', 'О нас'],
  'Versiya:': ['Version:', 'Версия:'],

  // Campaigns
  'Kampaniyalar': ['Campaigns', 'Акции'],
  'Göstəriləcək başqa xəbər yoxdur.': ['No other news to display.', 'Других новостей для отображения нет.'],
  'Heç bir kampaniya tapılmadı.': ['No campaigns found.', 'Кампаний не найдено.'],

  // FAQ
  'Ən çox soruşulan suallar': ['Frequently asked questions', 'Часто задаваемые вопросы'],
  'Mesaj göndərin': ['Send a message', 'Отправить сообщение'],
  'Əlavə sual və təkliflərinizlə bağlı aşağıdakı formdan bizə yaza bilərsiniz. Ən qısa zamanda əməkdaşlarımız sizə geri dönüş edəcəklər.': ['You can write to us using the form below for additional questions and suggestions. Our colleagues will get back to you as soon as possible.', 'Вы можете написать нам, используя форму ниже, для дополнительных вопросов и предложений. Наши коллеги свяжутся с вами в кратчайшие сроки.'],
  'Mesajınız': ['Your message', 'Ваше сообщение'],
  'Heç bir mesaj qeyd etməmisiniz.': ['You have not written any messages.', 'Вы не написали ни одного сообщения.'],

  // Policy
  'Məxfilik siyasəti': ['Privacy policy', 'Политика конфиденциальности'],

  // Search
  'Axtarış': ['Search', 'Поиск'],
  'Məhsullar üzrə axtarış...': ['Search for products...', 'Поиск товаров...'],
  'Son axtarışlar': ['Recent searches', 'Последние поисковые запросы'],
  'Keçmişi təmizlə': ['Clear history', 'Очистить историю'],

  // Settings
  'Parametrlər': ['Settings', 'Настройки'],
  'Mənim hesabım': ['My account', 'Мой аккаунт'],
  'Şifrə dəyişdirmək': ['Change password', 'Изменить пароль'],
  'Qeydiyyat': ['Registration', 'Регистрация'],
  'Tətbiq parametrləri': ['App settings', 'Настройки приложения'],
  'Qaranlıq rejim': ['Dark mode', 'Темный режим'],
  'Bildirişlər': ['Notifications', 'Уведомления'],
  'İnterfeys dili': ['Interface language', 'Язык интерфейса'],
  'Bizim haqqımızda': ['About us', 'О нас'],
  'Bizə yazın': ['Contact us', 'Свяжитесь с нами'],
  'Mağazalarımız': ['Our stores', 'Наши магазины'],
  'Bizimlə əlaqə': ['Contact us', 'Свяжитесь с нами'],
  'Digər': ['Other', 'Другое'],
  'Çıxış': ['Log out', 'Выйти'],

  // Single campaign
  'Bu barədə heç bir məlumat tapılmadı.': ['No information found about this.', 'Информации по этому вопросу не найдено.'],

  // Stores
  'Xəritədə bax': ['View on the map', 'Посмотреть на карте'],

  // Theme ecommerce
  'Ən yenilər': ['New arrivals', 'Новинки'],
  'Əvvəlcə baha': ['Expensive first', 'Дорогие сначала'],
  'Əvvəlcə ucuz': ['Cheap first', 'Дешевые сначала'],
  'Gözləyir': ['Pending', 'В ожидании'],
  'Təsdiqləndi': ['Confirmed', 'Подтверждено'],
  'Tamamlandı': ['Completed', 'Завершено'],
  'Ləğv edildi': ['Canceled', 'Отменено'],
  'Whatsapp sifarişi': ['WhatsApp order', 'Заказ по WhatsApp'],
  'Ödəniş edilməyib': ['Not paid', 'Не оплачено'],
  'Kuryerə verildi': ['Sent to courier', 'Отправлено курьеру'],

  // Component Home AppBar
  'Xoş gördük!': ['Welcome!', 'Добро пожаловать!'],

  // Component Home Brands
  'Populyar brendlər': ['Popular brands', 'Популярные бренды'],

  // Component Login Alternative
  'və ya alternativ olaraq': ['or alternatively', 'или альтернативно'],
  'Google': ['Google', 'Google'],
  'Facebook': ['Facebook', 'Facebook'],

  // Component Login Profile Picture
  'Qalereyadan yüklə': ['Upload from gallery', 'Загрузить из галереи'],
  'Kamera ilə çək': ['Take with camera', 'Сделать с камеры'],
  'Profil şəklini sil': ['Delete profile picture', 'Удалить фотографию профиля'],

  // Component Login Social Buttons
  'Google ilə qeydiyyat': ['Register with Google', 'Зарегистрироваться через Google'],
  'Facebook ilə qeydiyyat': ['Register with Facebook', 'Зарегистрироваться через Facebook'],

  // Component Orders Order Info
  'Məlumat panoya kopyalandı.': ['Information copied to the clipboard.', 'Информация скопирована в буфер обмена'],

  // Component Posts Load Posts
  'Heç bir nəticə tapılmadı.': ['No results found.', 'Результатов не найдено'],

  // Component Products Load Products
  'Göstəriləcək başqa məhsul yoxdur.': ['No other products to display.', 'Отображаемых других продуктов нет.'],

  // Component Products Carousel Products
  'Hamısı': ['View all', 'Все'],

  // Component Products Single Product Item
  'Bitib': ['Out of stock', 'Распродано'],

  // Component Settings BottomSheets Contact
  'Whatsapp': ['Whatsapp', 'WhatsApp'],
  'Instagram': ['Instagram', 'Instagram'],
  'Telegram': ['Telegram', 'Telegram'],

  // Component Settings Logout Alert
  'Hesabınızdan çıxış etmək istədiyinizə əminsinizmi?': ['Are you sure you want to log out from your account?', 'Вы уверены, что хотите выйти из своей учетной записи?'],
  'Xeyr': ['No', 'Нет'],
  'Bəli': ['Yes', 'Да'],

  // Component Single Product Comments
  'Hazırda heç bir rəy bildirilməmişdir.': ['Currently, no comments have been made.', 'В настоящее время комментариев нет.'],
  'Şərhlər': ['Comments', 'Комментарии'],
  'Şərh bildir': ['Leave a comment', 'Оставить комментарий'],

  // Component Single Product Components
  'Məhsul haqqında': ['About the product', 'О продукте'],
  'Müştəri rəyləri': ['Customer reviews', 'Отзывы клиентов'],
  'Çatdırılma şərtləri': ['Delivery terms', 'Условия доставки'],

  // Component Single Product Variation
  'Məhsul bitib': ['Out of stock', 'Распродано'],

  // Component Single Product Combine Related Products
  'Birgə ala biləcəkləriniz': ['What you can buy together', 'Что можно купить вместе'],

  // Main
  'Çıxış etmək istəyirsiniz?': ['Do you want to log out?', 'Хотите выйти?'],
  'Əsas səhifə': ['Main page', 'Главная страница'],
  'Kataloq': ['Catalog', 'Каталог'],
  'Hesabım': ['My account', 'Мой аккаунт'],

  // Home
  'Ən yaxşı məhsul kataloqları': ['Best product catalogs', 'Лучшие каталоги товаров'],
  'Yeni əlavə olunanlar': ['Newly added', 'Новые добавленные'],
  'Populyar məhsullar': ['Popular products', 'Популярные товары'],

  // Variables
  // OrdersPage
  'order_products_count': ['@count units', '@count единиц'],

  // Single Product
  'single_product_rating': ['@rating (@count votes)', '@rating (@count голоса)'],

  // Components Single Product Variation
  'product_stock': ['@count is left', '@count осталось'],

  // DarkMode Controller
  'Sistemə uyğun': ['System Default', 'По умолчанию системы'],
  'Aydınlıq rejim': ['Light Mode', 'Светлый режим'],
};

class TranslationService extends Translations {
  @override
  Map<String, Map<String, String>> get keys {
    Map<String, Map<String, String>> translatedKeys = {};

    translatedKeys['az_AZ'] = {};
    translatedKeys['en_EN'] = {};
    translatedKeys['ru_RU'] = {};

    strings.forEach((key, value) {
      translatedKeys['en_EN']![key] = (value[0] != '') ? value[0] : key;
      translatedKeys['ru_RU']![key] = (value[1] != '') ? value[1] : key;
    });

    translatedKeys['az_AZ']!['order_products_count'] = '@count ədəd';
    translatedKeys['az_AZ']!['single_product_rating'] = '@rating (@count səs)';
    translatedKeys['az_AZ']!['product_stock'] = '@count ədəd qalıb';

    return translatedKeys;
  }
}
