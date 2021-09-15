# Query User Account ldap  
*** {"username":"tkeaw","password":"12345"} เป็น user และ password ***

```
curl -d '{"username":"tkeaw","password":"12345"}' -H 'Content-Type: application/json' http://thanyakon.tech:3000/api/login
```

```
curl -d 'username=tkeaw&password=12345' http://thanyakon.tech:3000/api/login
```

*** ดูข้อมูลแบบ Token ***

```
curl -k -X POST -H "Authorization: Bearer <TOKEN>" http://thanyakon.tech:3000/api/posts
```

# Run in Droplet
*** ถ้า run API in Droplet ให้ใช้ Domain Name ***


# Run ข้างนอก droplet
*** ถ้า run API ข้างนอก droplet ให้ใช้ localhost ***


# RUN 
*** --DOMAINS ก็คือ DOMAINS url ที่เชื่อมต่อกับ ldap ***
*** --PORTLDAP 389 ก็คือ port ที่เรา deploy ldap ที่กำหนด port ***
*** --PORT 4000 ถ้าเรากำหนด port ได้ ถ้าไม่ใส่ มันจะ default port 3000 ของ backend ***
```
./run_script.sh --IP thanyakon.tk --DOMAINS thanyakon.tk --PORTLDAP 389 --PORT 4000
```
or
# default port 3000
```
./run_script.sh --IP thanyakon.tk --DOMAINS thanyakon.tk --PORTLDAP 389
```

# ถ้าขึ้นแบบนี้ ใน git Bash ในเครื่องเรา เราสามารถกด ctrl+C ได้ 
*** server 3000 ***
*** Client connected to redis... ***
*** Client connected to redis and ready to use... ***

# ถ้าเราอยากดู redis-commander GUI ต้อง run in server
```
redis-commander
```
# PORT redis-commander GUI
```
http://127.0.0.1:8081

```

# ดู port run backend in server
```
sudo lsof -i :3000
```
# ยกเลิก run backend in server
```
kill -9 {PID}
```


