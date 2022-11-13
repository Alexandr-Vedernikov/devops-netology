# DevOps-netology-23
## Vedernikov Alexandr
## Домашнее задание к занятию "3.5. Файловые системы"

**1. Узнайте о sparse (разряженных) файлах.**

Решение:
> Не занятые части файла формируют перечень дыр. Пустая информация в виде нулей, будет хранится в блоке метаданных ФС.
> На диск пишется только оставшаяся часть. Поэтому, разреженные файлы изначально занимают меньший объем носителя, чем
> их реальный объем.

**2. Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?**

Решение:
>Этот тип ссылок реализован на более низком уровне файловой системы. Файл >размещен только в определенном месте жесткого диска. Но на это место могут >ссылаться несколько ссылок из файловой системы. Каждая из ссылок - это >отдельный файл, но ведут они к одному участку жесткого диска. Файл можно >перемещать между каталогами, и все ссылки останутся рабочими, поскольку для >них неважно имя.
>    • Имеют ту же информацию inode и набор разрешений что и у исходного файла;
>    • Разрешения на ссылку изменяться при изменении разрешений файла;

**3. Сделайте vagrant destroy на имеющийся инстанс Ubuntu. Замените содержимое Vagrantfile следующим:**

Vagrant.configure("2") do |config|\
  config.vm.box = "bento/ubuntu-20.04"\
  config.vm.provider :virtualbox do |vb| \
    lvm_experiments_disk0_path = "/tmp/lvm_experiments_disk0.vmdk"\
    lvm_experiments_disk1_path = "/tmp/lvm_experiments_disk1.vmdk"\
    vb.customize ['createmedium', '--filename', lvm_experiments_disk0_path, '--size', 2560]\
    vb.customize ['createmedium', '--filename', lvm_experiments_disk1_path, '--size', 2560]\
    vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk0_path]\
    vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk1_path]\
  end\
end

Данная конфигурация создаст новую виртуальную машину с двумя дополнительными неразмеченными дисками по 2.5 Гб.

Решение:
>vagrant@vagrant:~$ lsblk\
NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT\
loop0                       7:0    0 61.9M  1 loop /snap/core20/1328\
loop1                       7:1    0 43.6M  1 loop /snap/snapd/14978\
loop2                       7:2    0 67.2M  1 loop /snap/lxd/21835\
sda                           8:0    0   64G  0 disk \
├─sda1                    8:1    0    1M  0 part \
├─sda2                    8:2    0  1.5G  0 part /boot\
└─sda3                    8:3    0 62.5G  0 part \
  └─ubuntu--vg-ubuntu--lv 253:0    0 31.3G  0 lvm  /\
sdb                            8:16   0  2.5G  0 disk\
sdc                            8:32   0  2.5G  0 disk

**4. Используя fdisk, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство.**

Решение:
>vagrant@vagrant:~$ lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT\
loop0                       7:0    0 67.2M  1 loop /snap/lxd/21835\
loop1                       7:1    0 61.9M  1 loop /snap/core20/1328\
loop2                       7:2    0 43.6M  1 loop /snap/snapd/14978\
loop3                       7:3    0 63.2M  1 loop /snap/core20/1623\
loop4                       7:4    0   48M  1 loop /snap/snapd/17336\
loop5                       7:5    0 67.8M  1 loop /snap/lxd/22753\
sda                         8:0    0   64G  0 disk \
├─sda1                      8:1    0    1M  0 part \
├─sda2                      8:2    0  1.5G  0 part /boot\
└─sda3                      8:3    0 62.5G  0 part \
  └─ubuntu--vg-ubuntu--lv 253:0    0 31.3G  0 lvm  /\
sdb                         8:16   0  2.5G  0 disk \
├─sdb1                      8:17   0    2G  0 part \
└─sdb2                      8:18   0  509M  0 part \
sdc                         8:32   0  2.5G  0 disk

**5. Используя sfdisk, перенесите данную таблицу разделов на второй диск.**

Решение:

Необходимо создать дамп диска копию которого нужно создать
>vagrant@vagrant:$ sudo sfdisk -d /dev/sdb > sdb.out

Применяем файл дамп
>vagrant@vagrant:$ sudo sfdisk /dev/sdc < sdb.out\
Checking that no-one is using this disk right now ... OK\
Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors\
Disk model: VBOX HARDDISK   \
Units: sectors of 1 * 512 = 512 bytes\
Sector size (logical/physical): 512 bytes / 512 bytes\
I/O size (minimum/optimal): 512 bytes / 512 bytes\
Script header accepted.\
Script header accepted.\
Script header accepted.\
Script header accepted.\
Created a new DOS disklabel with disk identifier 0x063d59c4.\
/dev/sdc1: Created a new partition 1 of type 'Linux' and of size =2 GiB.\
/dev/sdc2: Created a new partition 2 of type 'Linux' and of size 558 MiB.\
/dev/sdc3: Done.\
New situation:\
Disklabel type: dos\
Disk identifier: 0x063d59c4\
Device     Boot   Start     End Sectors  Size Id Type\
/dev/sdc1          2048 4100000 4097953    2G 83 Linux\
/dev/sdc2       4100096 5242879 1142784  558M 83 Linux\
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.

Проверяем
>vagrant@vagrant:$ lsblk\
NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT\
loop0                       7:0    0 61.9M  1 loop /snap/core20/1328\
loop1                       7:1    0 43.6M  1 loop /snap/snapd/14978\
loop2                       7:2    0 67.2M  1 loop /snap/lxd/21835\
loop3                       7:3    0   48M  1 loop /snap/snapd/17336\
loop4                       7:4    0 63.2M  1 loop /snap/core20/1623\
loop5                       7:5    0 67.8M  1 loop /snap/lxd/22753\
sda                         8:0    0   64G  0 disk \
├─sda1                      8:1    0    1M  0 part \
├─sda2                      8:2    0  1.5G  0 part /boot\
└─sda3                      8:3    0 62.5G  0 part \
  └─ubuntu--vg-ubuntu--lv 253:0    0 31.3G  0 lvm  /\
sdb                         8:16   0  2.5G  0 disk \
├─sdb1                      8:17   0    2G  0 part \
└─sdb2                      8:18   0  558M  0 part \
sdc                         8:32   0  2.5G  0 disk \
├─sdc1                      8:33   0    2G  0 part \
└─sdc2                      8:34   0  558M  0 part \

**6. Соберите mdadm RAID1 на паре разделов 2 Гб.**

Решение:

Необходимо обнулить суперблоки на дисках, которые мы будем использовать для построения RAID 
>vagrant@vagrant:$ sudo mdadm --zero-superblock --force /dev/sdb1
mdadm: Unrecognised md component device - /dev/sdb1
vagrant@vagrant:$ sudo mdadm --zero-superblock --force /dev/sdc1
mdadm: Unrecognised md component device - /dev/sdc1

Удаляем старые метаданные и подпись на дисках:
>vagrant@vagrant:$ sudo wipefs --all --force /dev/sd{b1,c1}\

Сборка избыточного массива, где:
  * /dev/md0 — устройство RAID, которое появится после сборки; 
  * -l 1 — уровень RAID; 
  * -n 2 — количество дисков, из которых собирается массив; 
  * /dev/sd{b1,c1} — сборка выполняется из дисков sdb1 и sdc1.
>vagrant@vagrant:$ sudo mdadm --create --verbose /dev/md0 -l 1 -n 2 /dev/sd{b1,c1}\
mdadm: Note: this array has metadata at the start and\
    may not be suitable as a boot device.  If you plan to\
    store '/boot' on this device please ensure that\
    your boot-loader understands md/v1.x metadata, or use\
    --metadata=0.90\
mdadm: size set to 2095872K\
Continue creating array? y\
mdadm: Defaulting to version 1.2 metadata\
mdadm: array /dev/md0 started.\

Проверяем результат
>vagrant@vagrant:~$ lsblk\
NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT\
loop0                       7:0    0 63.2M  1 loop  /snap/core20/1634\
loop1                       7:1    0 63.2M  1 loop  /snap/core20/1623\
loop2                       7:2    0 43.6M  1 loop  /snap/snapd/14978\
loop3                       7:3    0 67.2M  1 loop  /snap/lxd/21835\
loop4                       7:4    0   48M  1 loop  /snap/snapd/17336\
loop5                       7:5    0 67.8M  1 loop  /snap/lxd/22753\
sda                         8:0    0   64G  0 disk  \
├─sda1                      8:1    0    1M  0 part  \
├─sda2                      8:2    0  1.5G  0 part  /boot\
└─sda3                      8:3    0 62.5G  0 part  \
  └─ubuntu--vg-ubuntu--lv 253:0    0 31.3G  0 lvm   /\
sdb                         8:16   0  2.5G  0 disk  \
├─sdb1                      8:17   0    2G  0 part  \
│ └─md0                     9:0    0    2G  0 raid1 \
└─sdb2                      8:18   0  509M  0 part  \
sdc                         8:32   0  2.5G  0 disk  \
├─sdc1                      8:33   0    2G  0 part  \
│ └─md0                     9:0    0    2G  0 raid1 \
└─sdc2                      8:34   0  509M  0 part  

**7. Соберите mdadm RAID 0 на второй паре маленьких разделов.**

Решение:
Необходимо обнулить суперблоки на дисках, которые мы будем использовать для построения RAID0
>vagrant@vagrant:/etc/mdadm$ sudo mdadm --zero-superblock --force /dev/sd{b2,c2}\
mdadm: Unrecognised md component device - /dev/sdb2\
mdadm: Unrecognised md component device - /dev/sdc2\

Удаляем старые метаданные и подпись на дисках:
>vagrant@vagrant:/etc/mdadm$ sudo wipefs --all --force /dev/sd{b2,c2}

Сборка избыточного массива, где:
  * /dev/md0 — устройство RAID, которое появится после сборки; 
  * -l 0 — уровень RAID; 
  * -n 2 — количество дисков, из которых собирается массив; 
  * /dev/sd{b2,c2} — сборка выполняется из дисков sdb2 и sdc2.
>vagrant@vagrant:/etc/mdadm$ sudo mdadm --create --verbose /dev/md1 -l 0 -n 2 /dev/sd{b2,c2}\
mdadm: chunk size defaults to 512K\
mdadm: Defaulting to version 1.2 metadata\
mdadm: array /dev/md1 started.\

Проверяем результат
>vagrant@vagrant:/etc/mdadm$ lsblk\
NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT\
loop0                       7:0    0 63.2M  1 loop  /snap/core20/1634\
loop1                       7:1    0 63.2M  1 loop  /snap/core20/1623\
loop2                       7:2    0 43.6M  1 loop  /snap/snapd/14978\
loop3                       7:3    0 67.2M  1 loop  /snap/lxd/21835\
loop4                       7:4    0   48M  1 loop  /snap/snapd/17336\
loop5                       7:5    0 67.8M  1 loop  /snap/lxd/22753\
sda                         8:0    0   64G  0 disk  \
├─sda1                      8:1    0    1M  0 part  \
├─sda2                      8:2    0  1.5G  0 part  /boot\
└─sda3                      8:3    0 62.5G  0 part  \
  └─ubuntu--vg-ubuntu--lv 253:0    0 31.3G  0 lvm   /\
sdb                         8:16   0  2.5G  0 disk  \
├─sdb1                      8:17   0    2G  0 part  \
│ └─md0                     9:0    0    2G  0 raid1 \
└─sdb2                      8:18   0  509M  0 part  \
  └─md1                     9:1    0 1014M  0 raid0 \
sdc                         8:32   0  2.5G  0 disk  \
├─sdc1                      8:33   0    2G  0 part  \
│ └─md0                     9:0    0    2G  0 raid1 \
└─sdc2                      8:34   0  509M  0 part  \
  └─md1                     9:1    0 1014M  0 raid0

**8. Создайте 2 независимых PV на получившихся md-устройствах.**

Решение:
>vagrant@vagrant:/etc/mdadm$ sudo pvcreate /dev/md0 /dev/md1\
  Physical volume "/dev/md0" successfully created.\
  Physical volume "/dev/md1" successfully created.

Проверяем создание:
>vagrant@vagrant:/etc/mdadm$ sudo pvscan\
  PV /dev/sda3   VG ubuntu-vg       lvm2 [<62.50 GiB / 31.25 GiB free]\
  PV /dev/md0    VG vg1             lvm2 [<2.00 GiB / <2.00 GiB free]\
  PV /dev/md1    VG vg1             lvm2 [1012.00 MiB / 1012.00 MiB free]\
  Total: 3 [65.48 GiB] / in use: 3 [65.48 GiB] / in no VG: 0 [0   ]

**9. Создайте общую volume-group на этих двух PV.**

Решение:
>vagrant@vagrant:/etc/mdadm$ sudo vgcreate vg1 /dev/md0 /dev/md1\
  Volume group "vg1" successfully created

Проверяем создание:
>vagrant@vagrant:/etc/mdadm$ sudo vgdisplay\
  --- Volume group ---\
  VG Name               ubuntu-vg\
  System ID             \
  Format                lvm2\
  Metadata Areas        1\
  Metadata Sequence No  2\
  VG Access             read/write\
  VG Status             resizable\
  MAX LV                0\
  Cur LV                1\
  Open LV               1\
  Max PV                0\
  Cur PV                1\
  Act PV                1\
  VG Size               <62.50 GiB\
  PE Size               4.00 MiB\
  Total PE              15999\
  Alloc PE / Size       7999 / <31.25 GiB\
  Free  PE / Size       8000 / 31.25 GiB\
  VG UUID               4HbbNB-kISH-fXeQ-qzbV-XeNd-At34-cCUUuJ\
  --- Volume group ---\
  VG Name               vg1\
  System ID             \
  Format                lvm2\
  Metadata Areas        2\
  Metadata Sequence No  1\
  VG Access             read/write\
  VG Status             resizable\
  MAX LV                0\
  Cur LV                0\
  Open LV               0\
  Max PV                0\
  Cur PV                2\
  Act PV                2\
  VG Size               2.98 GiB\
  PE Size               4.00 MiB\
  Total PE              764\
  Alloc PE / Size       0 / 0   \
  Free  PE / Size       764 / 2.98 GiB\
  VG UUID               u0IEjg-DO9P-Mg0K-66Ua-innc-JlXf-VptQtH

**10. Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.**

Решение:
>vagrant@vagrant:/etc/mdadm$ sudo lvcreate -L 100M vg1 /dev/md1\
  Logical volume "lvol0" created.

Проверяем результат:
>vagrant@vagrant:/etc/mdadm$ sudo vgs\
  VG        #PV #LV #SN Attr   VSize   VFree \
  ubuntu-vg   1   1   0 wz--n- <62.50g 31.25g\
  vg1         2   1   0 wz--n-   2.98g <2.89g\
vagrant@vagrant:/etc/mdadm$ sudo lvs\
  LV        VG        Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert\
  ubuntu-lv ubuntu-vg -wi-ao----31.25g  lvol0     vg1    wi-a----- 100.00m

**11. Создайте mkfs.ext4 ФС на получившемся LV.**

Решение:

Создаем FS ext4 /dev/volume group/логический раздел:
>vagrant@vagrant:/etc/mdadm$ sudo mkfs.ext4 /dev/vg1/lvol0\
mke2fs 1.45.5 (07-Jan-2020)\
Creating filesystem with 25600 4k blocks and 25600 inodes\
Allocating group tables: done                            \
Writing inode tables: done                            \
Creating journal (1024 blocks): done\
Writing superblocks and filesystem accounting information: done\

**12. Смонтируйте этот раздел в любую директорию, например, /tmp/new.**

Решение:

Создаем и переходим в директорию, в которую будем монтировать:
>vagrant@vagrant:/etc/mdadm$ cd /tmp\
vagrant@vagrant:/tmp$ sudo mkdir ./new\
vagrant@vagrant:/tmp$ cd ./new\

Монтируем. После restart нужно снова монтировать. Для автоматического монтирования нужно прописать в файл /etc/fstab
>vagrant@vagrant:/tmp/new$ sudo mount /dev/vg1/lvol0 /tmp/new\
vagrant@vagrant:/tmp/new$ lsblk\
NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT\
loop0                       7:0    0 63.2M  1 loop  /snap/core20/1634\
loop1                       7:1    0 63.2M  1 loop  /snap/core20/1623\
loop2                       7:2    0 43.6M  1 loop  /snap/snapd/14978\
loop3                       7:3    0 67.2M  1 loop  /snap/lxd/21835\
loop4                       7:4    0   48M  1 loop  /snap/snapd/17336\
loop5                       7:5    0 67.8M  1 loop  /snap/lxd/22753\
sda                         8:0    0   64G  0 disk  \
├─sda1                      8:1    0    1M  0 part  \
├─sda2                      8:2    0  1.5G  0 part  /boot\
└─sda3                      8:3    0 62.5G  0 part  \
  └─ubuntu--vg-ubuntu--lv 253:0    0 31.3G  0 lvm   /\
sdb                         8:16   0  2.5G  0 disk  \
├─sdb1                      8:17   0    2G  0 part  \
│ └─md0                     9:0    0    2G  0 raid1 \
└─sdb2                      8:18   0  509M  0 part  \
  └─md1                     9:1    0 1014M  0 raid0 \
    └─vg1-lvol0           253:1    0  100M  0 lvm   /tmp/new\
sdc                         8:32   0  2.5G  0 disk  \
├─sdc1                      8:33   0    2G  0 part  \
│ └─md0                     9:0    0    2G  0 raid1 \
└─sdc2                      8:34   0  509M  0 part  \
  └─md1                     9:1    0 1014M  0 raid0 \
    └─vg1-lvol0           253:1    0  100M  0 lvm   /tmp/new

**13. Поместите туда тестовый файл, например wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz.**

Решение:
>vagrant@vagrant:/tmp/new$ sudo wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz\
--2022-11-03 22:29:21--  https://mirror.yandex.ru/ubuntu/ls-lR.gz\
Resolving mirror.yandex.ru (mirror.yandex.ru)... 213.180.204.183, 2a02:6b8::183\
Connecting to mirror.yandex.ru (mirror.yandex.ru)|213.180.204.183|:443...\ connected.\
HTTP request sent, awaiting response... 200 OK\
Length: 22609492 (22M) [application/octet-stream]\
Saving to: ‘/tmp/new/test.gz’\
/tmp/new/test.gz          100%[=====================================>]  21.56M \ 3.72MB/s    in 5.2s    \
2022-11-03 22:29:27 (4.16 MB/s) - ‘/tmp/new/test.gz’ saved [22609492/22609492]\
vagrant@vagrant:/tmp/new$ ls -la\
total 22104\
drwxr-xr-x  3 root root     4096 Nov  3 22:29 .\
drwxrwxrwt 13 root root     4096 Nov  3 22:31 ..\
drwx------  2 root root    16384 Nov  3 22:16 lost+found\
-rw-r--r--  1 root root 22609492 Nov  3 21:46 test.gz\

**14. Прикрепите вывод lsblk.**

Решение:
>vagrant@vagrant:/tmp/new$ lsblk\
NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT\
loop0                       7:0    0 63.2M  1 loop  /snap/core20/1634\
loop1                       7:1    0 63.2M  1 loop  /snap/core20/1623\
loop2                       7:2    0 43.6M  1 loop  /snap/snapd/14978\
loop3                       7:3    0 67.2M  1 loop  /snap/lxd/21835\
loop4                       7:4    0   48M  1 loop  /snap/snapd/17336\
loop5                       7:5    0 67.8M  1 loop  /snap/lxd/22753\
sda                         8:0    0   64G  0 disk  \
├─sda1                      8:1    0    1M  0 part  \
├─sda2                      8:2    0  1.5G  0 part  /boot\
└─sda3                      8:3    0 62.5G  0 part  \
  └─ubuntu--vg-ubuntu--lv 253:0    0 31.3G  0 lvm   /\
sdb                         8:16   0  2.5G  0 disk  \
├─sdb1                      8:17   0    2G  0 part  \
│ └─md0                     9:0    0    2G  0 raid1 \
└─sdb2                      8:18   0  509M  0 part  \
  └─md1                     9:1    0 1014M  0 raid0 \
    └─vg1-lvol0           253:1    0  100M  0 lvm   /tmp/new\
sdc                         8:32   0  2.5G  0 disk  \
├─sdc1                      8:33   0    2G  0 part  \
│ └─md0                     9:0    0    2G  0 raid1 \
└─sdc2                      8:34   0  509M  0 part  \
  └─md1                     9:1    0 1014M  0 raid0 \
    └─vg1-lvol0           253:1    0  100M  0 lvm   /tmp/new

**15. Протестируйте целостность файла:**

Решение:
>vagrant@vagrant:/tmp/new$ gzip -t /tmp/new/test.gz\
vagrant@vagrant:/tmp/new$ echo $?\
0


**16. Используя pvmove, переместите содержимое PV с RAID0 на RAID1.**

Решение:

Перенос содержимого из /dev/md1 в /dev/md0
>vagrant@vagrant:/tmp/new$ sudo pvmove /dev/md1 /dev/md0\
  /dev/md1: Moved: 16.00%\
  /dev/md1: Moved: 100.00%

Проверяем
>vagrant@vagrant:/tmp/new$ lsblk\
NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT\
loop0                       7:0    0 63.2M  1 loop  /snap/core20/1634\
loop1                       7:1    0 63.2M  1 loop  /snap/core20/1623\
loop2                       7:2    0 43.6M  1 loop  /snap/snapd/14978\
loop3                       7:3    0 67.2M  1 loop  /snap/lxd/21835\
loop4                       7:4    0   48M  1 loop  /snap/snapd/17336\
loop5                       7:5    0 67.8M  1 loop  /snap/lxd/22753\
sda                         8:0    0   64G  0 disk  \
├─sda1                      8:1    0    1M  0 part  \
├─sda2                      8:2    0  1.5G  0 part  /boot\
└─sda3                      8:3    0 62.5G  0 part  \
  └─ubuntu--vg-ubuntu--lv 253:0    0 31.3G  0 lvm   /\
sdb                         8:16   0  2.5G  0 disk  \
├─sdb1                      8:17   0    2G  0 part  \
│ └─md0                     9:0    0    2G  0 raid1 \
│   └─vg1-lvol0           253:1    0  100M  0 lvm   /tmp/new\
└─sdb2                      8:18   0  509M  0 part  \
  └─md1                     9:1    0 1014M  0 raid0 \
sdc                         8:32   0  2.5G  0 disk  \
├─sdc1                      8:33   0    2G  0 part  \
│ └─md0                     9:0    0    2G  0 raid1 \
│   └─vg1-lvol0           253:1    0  100M  0 lvm   /tmp/new\
└─sdc2                      8:34   0  509M  0 part  \
  └─md1                     9:1    0 1014M  0 raid0

**17. Сделайте --fail на устройство в вашем RAID1 md.**

Решение:

Смотрим какие есть массивы в системе
>vagrant@vagrant:/tmp/new$ sudo cat /proc/mdstat\
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] \
md1 : active raid0 sdc2[1] sdb2[0]\
      1038336 blocks super 1.2 512k chunks      \
md0 : active raid1 sdc1[1] sdb1[0]\
      2095872 blocks super 1.2 [2/2] [UU] \
unused devices: <none>

Помечаем один диск в RAID1  сбойным
>vagrant@vagrant:/tmp/new$ sudo mdadm /dev/md0 -f /dev/sdc1\
mdadm: set /dev/sdc1 faulty in /dev/md0

Проверяем отображение проблемы в RAID1
>vagrant@vagrant:/tmp/new$ sudo cat /proc/mdstat\
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] \
md1 : active raid0 sdc2[1] sdb2[0]\
      1038336 blocks super 1.2 512k chunks      
md0 : active raid1 sdc1[1](F) sdb1[0]\
      2095872 blocks super 1.2 [2/1] [U_]\
unused devices: <none>

Удаляем диска из массива
>vagrant@vagrant:/tmp/new$ sudo mdadm /dev/md0 -r /dev/sdc1\
mdadm: hot removed /dev/sdc1 from /dev/md0

**18. Подтвердите выводом dmesg, что RAID1 работает в деградированном состоянии.**

Решение:
>vagrant@vagrant:/tmp/new$ dmesg | grep raid1\
[ 1700.327018]  md/raid1:md0: not clean -- starting background reconstruction\
[ 1700.327020]  md/raid1:md0: active with 2 out of 2 mirrors\
[60745.838100] md/raid1:md0: Disk failure on sdc1, disabling device.\
                             md/raid1:md0: Operation continuing on 1 devices.\

**19. Протестируйте целостность файла, несмотря на "сбойный" диск он должен продолжать быть доступен:**

  >root@vagrant:# gzip -t /tmp/new/test.gz\
	root@vagrant:# echo $?\
	0

Решение:
>vagrant@vagrant:/tmp/new$ dir\
lost+found  test.gz\
vagrant@vagrant:/tmp/new$ gzip -t /tmp/new/test.gz && echo $?\
0

**20. Погасите тестовый хост, vagrant destroy.**

Решение:
>vagrant@vagrant:$ exit\
logout\
home@home:/Vagrant$ vagrant halt\
==> default: Attempting graceful shutdown of VM...\
home@home:/Vagrant$ vagrant destroy \
    default: Are you sure you want to destroy the 'default' VM? [y/N] y\
==> default: Destroying VM and associated drives...
