# PXE
## Description
* Установка образа ubuntu с [cloud-init](https://documentation.ubuntu.com/lxd/en/latest/cloud-init/).
* Поддержка загрузчиков bios и grub.
* DNS сервер - dnsmasq.
  * Корень tftp - /tftpboot/
* WEB сервер установлен заранее.
* __*Следует ограничить доступ к WEB серверу, ключи и пароли хранятся в открытом виде.*__
* __*Сохранить id_ed25519 и пароль в надёжном месте.*__

## Dependency
| Soft        | Comment                                      |
|:------------|:---------------------------------------------|
| git         | Загрузка репозитория.                        | 
| web server  | Раздаёт образ и настройки.                   |         
| dnsmasq     | tftp + dhcp.                                 |                                                                                             |                                                                                            |
| ssh-keygen  | Создаёт единый сертификат для всех серверов. |                                                                                               |
| openssl     | Шифрует начальный пароль сервера.            |                                

## Deploy
## Variables
| Description        | Value      | Comment                                                 |
|:-------------------|:-----------|:--------------------------------------------------------|
| Корень web сервера | /var/www/  | Образ хранится в корне;<br/>настройки в ./pxe/user-data |
| Пароль             | [password] | Пароль пользователя ubuntu                              |
## Script
```shell
mkdir /tmp/pxi && cd /tmp/pxi
git clone https://github.com/FZEN475/PXE.git
chmod +x ./init.sh
./init.sh /var/www/ password
```

## DNS server
### OpenWrt
```
config dnsmasq
        ...
        option tftp_root '/tftpboot'
        option enable_tftp '1'
        ...
...
#Проверка версии биоса
config match
        option networkid 'bios'
        option match '60,PXEClient:Arch:00000'

config match
        option networkid 'efi32'
        option match '60,PXEClient:Arch:00006'

config match
        option networkid 'efi64'
        option match '60,PXEClient:Arch:00007'

config match
        option networkid 'efi64'
        option match '60,PXEClient:Arch:00009'

#Расположение бинарника в зависимости от биоса
config boot
        option filename 'tag:bios,bios/pxelinux.0'
        option serveraddress '192.168.2.1'
        option servername 'OpenWrt_bios'
        
config boot
        option filename 'tag:efi64,uefi/pxelinux.0'
        option serveraddress '192.168.2.1'
        option servername 'OpenWrt_uefi'
```







