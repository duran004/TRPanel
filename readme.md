## Neden?
Çünkü linux komutlarından nefret ediyorum ve benim gibi nefret edenler vardır. Ve Cpanel artık dolar kuru ile çok pahalı. 

## Proje Tamamlanır mı?
En azından dosya yöneticisi bölümü tamamlanır. 

## Kurulum
```
sudo rm -f /tmp/lamp.sh
sudo wget -O /tmp/lamp.sh https://raw.githubusercontent.com/duran004/TRPanel/main/lamp.sh
sudo chmod +x /tmp/lamp.sh
sudo /tmp/lamp.sh
```

## Nasıl?
* komut ile tmp klasörünüze bash dosyası indirilir. (varsa önce silinir)
* LAMP dediğimiz php apache2 mysql-server git curl paketleri yüklenir.
* mysql ve php eklentileri yüklenir.
* apache ve mysql başlatılır.
* composer yüklenir.
* proje /var/www/html dizinine klonlanır.
* projeye gerekli yetkiler verilir ve composer çalıştırılır.
* ip-adress/TRPanel adresinden yönetim başlar.

(en azından şimdilik hedef bu şekilde.)

### BETA VERSİONDUR!
![önizleme](src/img/github.png)