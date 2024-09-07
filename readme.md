## Amaç?
Tek bir kod betiği ile ubuntu-server üzerinde sorunsuz proje yayınlamak.

## Proje Tamamlanır mı?
En azından dosya yöneticisi bölümü tamamlanır. 

## Kurulum
```
sudo rm -f /tmp/lamp.sh
sudo wget -O /tmp/lamp.sh https://raw.githubusercontent.com/duran004/TRPanel/main/setup.sh
sudo chmod +x /tmp/lamp.sh
sudo /tmp/lamp.sh
```

## Nasıl?
* Bash komutları ile apache2, mysql, phpmyadmin, php paketleri kurulur.
* TRPanel-Laravel projesi kurulur ve ip-adres:8000 portunda çalıştırılır.
* Kullanıcı kayıt olur /home/{kullanıcı adı} şeklinde klasörü oluşturulur.
* (@todo: Bu klasöre Apache yetkileri verilir projesini yayınlaması için.)


### BETA VERSİONDUR!
![önizleme](src/img/github.png)