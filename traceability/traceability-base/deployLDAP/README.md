## deploy LDAP 

```
./run_script.sh --help
```

```
./run_script.sh -i example.com -p 4000 --admin admin --adminpw pass"
```

## วิธีการใช้งานระบบ เข้าไปที่ example.com:80

## ตัวอย่าง ลงชื่อใช้งานระบบ
### Login DN
```
cn=admin,dc=example,dc=com
```
### password
```
pass
```
** หมายเหตุ **
### cn ต้องตรงกับ --admin
### password ต้องตรงกับ --adminpw
