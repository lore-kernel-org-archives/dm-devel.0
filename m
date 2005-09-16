From: Nicola Murino <n.murino@theorematica.it>
Subject: [SUMMARY] My EMC CX300 and multipath-tools setup
Date: Fri, 16 Sep 2005 09:17:11 +0200
Message-ID: <432A7177.2090309@theorematica.it>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2033029760=="
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, christophe.varoqui@free.fr
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--===============2033029760==
Content-Type: multipart/alternative;
	boundary="------------070902030005040102060209"

This is a multi-part message in MIME format.
--------------070902030005040102060209
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

*Hardware*

2 poweredge 2850, dual xeon, 2Gb Ram, 2x36Gb scsi Raid 1
1 EMC CX 300, about 500Gb Raid 5
each poweredge is connected to EMC by two fibre channel paths

*Software*

Gentoo Linux, installed on poweredge internal disks
kernel-2.6.13-gentoo-r1
udev-0.68-r1
device-mapper-1.01.03
multipath-tools-0.4.5

I setup a *pure udev enviroment*:

/etc/conf.d/rc:

RC_DEVICES="udev"
RC_DEVICE_TARBALL="no"

I load the following modules at boot time

dm-emc
qla2300

my mutipath-tools configuration file is the following:

grep -v "#" */etc/multipath.conf*
defaults {
        multipath_tool  "/sbin/multipath -v0"
        udev_dir        /dev
        polling_interval 5
        default_selector        "round-robin 0"
        default_getuid_callout  "/sbin/scsi_id -g -u -s /block/%n"
        default_prio_callout    "/bin/true"
        failback        immediate
}
multipaths {

        multipath {
                wwid                    3600601608c901200ccfe543f4053d911
                alias                   200Gb
                path_grouping_policy    failover
                path_checker            readsector0
                path_selector           "round-robin 0"
                failback                immediate
        }
        multipath {
                wwid                    3600601608c9012006269b8f63b87d911
                alias                   5Gb
                path_grouping_policy    failover
                path_checker            readsector0
                path_selector           "round-robin 0"
                failback                immediate
        }
        multipath {
                wwid                    3600601608c9012008ae5de2cc985d911
                alias                   300Gb
                path_grouping_policy    failover
                path_checker            readsector0
                path_selector           "round-robin 0"
                failback                immediate
        }
}

multipathd start at boot time

*rc-update add multipathd default
*
this is what system see after boot

*multipath -l*
5Gb (3600601608c9012006269b8f63b87d911)
[size=5 GB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [enabled]
 \_ 1:0:0:4 sdf 8:80  [active][ready]
\_ round-robin 0 [enabled]
 \_ 2:0:0:4 sdk 8:160 [active][ready]

3600601608c901200a8b8972f4053d911
[size=100 MB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [enabled]
 \_ 1:0:0:2 sdd 8:48  [active][ready]
\_ round-robin 0 [enabled]
 \_ 2:0:0:2 sdi 8:128 [active][ready]

200Gb (3600601608c901200ccfe543f4053d911)
[size=200 GB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [enabled]
 \_ 1:0:0:1 sdc 8:32  [active][ready]
\_ round-robin 0 [enabled]
 \_ 2:0:0:1 sdh 8:112 [active][ready]

300Gb (3600601608c9012008ae5de2cc985d911)
[size=300 GB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [enabled]
 \_ 1:0:0:0 sdb 8:16  [active][ready]
\_ round-robin 0 [enabled]
 \_ 2:0:0:0 sdg 8:96  [active][ready]

3600601608c901200bc7680294053d911
[size=100 MB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [enabled]
 \_ 2:0:0:3 sdj 8:144 [active][ready]
\_ round-robin 0 [enabled]
 \_ 1:0:0:3 sde 8:64  [active][ready]


*dmsetup table*
vg00-portage: 0 4096000 linear 8:4 16384384
vg00-tmp: 0 4096000 linear 8:4 4096384
vg00-log: 0 8192000 linear 8:4 26624384
vg00-usr: 0 8192000 linear 8:4 8192384
vg00-var: 0 6144000 linear 8:4 20480384
vg00-root: 0 2048000 linear 8:4 2048384
5Gb: 0 10485760 multipath 0 1 emc 2 1 round-robin 0 1 1 8:80 1000 round-robin 0 1 1 8:160 1000
3600601608c901200a8b8972f4053d911: 0 204800 multipath 0 1 emc 2 1 round-robin 0 1 1 8:48 1000 round-robin 0 1 1 8:128 1000
vg00-admin: 0 2048000 linear 8:4 384
200Gb: 0 419430400 multipath 0 1 emc 2 2 round-robin 0 1 1 8:32 1000 round-robin 0 1 1 8:112 1000
300Gb: 0 629145600 multipath 0 1 emc 2 1 round-robin 0 1 1 8:16 1000 round-robin 0 1 1 8:96 1000
3600601608c901200bc7680294053d911: 0 204800 multipath 0 1 emc 2 1 round-robin 0 1 1 8:144 1000 round-robin 0 1 1 8:64 1000

*df -h*
Filesystem            Size  Used Avail Use% Mounted on
/dev/sda2             965M  534M  432M  56% /
udev                 1014M  144K 1014M   1% /dev
/dev/sda1              54M  5.2M   46M  11% /boot
/dev/mapper/vg00-admin
                     1000M   33M  968M   4% /admin
/dev/mapper/vg00-root
                     1000M   33M  968M   4% /root
/dev/mapper/vg00-usr  4.0G  868M  3.1G  22% /usr
/dev/mapper/vg00-var  3.0G   74M  2.9G   3% /var
/dev/mapper/vg00-tmp  2.0G   33M  2.0G   2% /tmp
/dev/mapper/vg00-log  4.0G   40M  3.9G   1% /var/log
/dev/mapper/vg00-portage
                      2.0G  234M  1.8G  12% /usr/portage
none                 1014M     0 1014M   0% /dev/shm
/dev/dm-2             5.0G   33M  5.0G   1% /mnt/web
/dev/dm-1             200G   33M  200G   1% /mnt/mysql
/dev/dm-4             300G   71M  300G   1% /mnt/mail


I have the following in /dev:

nodob admin # cd /dev/
nodob dev # ls -la
total 1
drwxr-xr-x  12 root root      3440 Sep 14 19:21 .
drwxr-xr-x  21 root root       624 Sep 14 19:21 ..
-rw-r--r--   1 root root         0 Sep 14  2005 .udev
drwxr-xr-x   2 root root       760 Sep 14  2005 .udevdb
lrwxrwxrwx   1 root root         4 Sep 14  2005 *200Gb -> dm-4*
lrwxrwxrwx   1 root root         4 Sep 14  2005 *300Gb -> dm-3*
lrwxrwxrwx   1 root root         4 Sep 14  2005 3600601608c901200a8b8972f4053d911 -> dm-2
lrwxrwxrwx   1 root root         4 Sep 14  2005 3600601608c901200bc7680294053d911 -> dm-0
lrwxrwxrwx   1 root root         4 Sep 14  2005 *5Gb -> dm-1*

and in /dev/mapper:

nodob mapper # ls -la
total 0
drwxr-xr-x   2 root root     300 Sep 14  2005 .
drwxr-xr-x  12 root root    3440 Sep 14 19:29 ..
*brw-------   1 root root 254,  1 Sep 14  2005 200Gb
brw-------   1 root root 254,  4 Sep 14  2005 300Gb*
brw-------   1 root root 254,  3 Sep 14  2005 3600601608c901200a8b8972f4053d911
brw-------   1 root root 254,  0 Sep 14  2005 3600601608c901200bc7680294053d911
*brw-------   1 root root 254,  2 Sep 14  2005 5Gb*
crw-rw----   1 root root  10, 63 Sep 14  2005 control
brw-------   1 root root 254,  5 Sep 14  2005 vg00-admin
brw-------   1 root root 254, 11 Sep 14  2005 vg00-log
brw-------   1 root root 254,  9 Sep 14  2005 vg00-portage
brw-------   1 root root 254,  6 Sep 14  2005 vg00-root
brw-------   1 root root 254,  7 Sep 14  2005 vg00-tmp
brw-------   1 root root 254,  8 Sep 14  2005 vg00-usr
brw-------   1 root root 254, 10 Sep 14  2005 vg00-var


some tests:

*1) one path failure*

/var/log/messages

Sep 14 19:33:21 nodob multipathd: 8:96: emc_clariion_checker: query command indicates error
Sep 14 19:33:21 nodob multipathd: checker failed path 8:96 in map 300Gb
Sep 14 19:33:21 nodob multipathd: 8:112: emc_clariion_checker: query command indicates error
Sep 14 19:33:21 nodob multipathd: checker failed path 8:112 in map 200Gb
Sep 14 19:33:21 nodob multipathd: 8:128: emc_clariion_checker: query command indicates error
Sep 14 19:33:21 nodob multipathd: checker failed path 8:128 in map 3600601608c901200a8b8972f4053d911
Sep 14 19:33:21 nodob multipathd: 8:144: emc_clariion_checker: query command indicates error
Sep 14 19:33:21 nodob multipathd: checker failed path 8:144 in map 3600601608c901200bc7680294053d911
Sep 14 19:33:21 nodob multipathd: 8:160: emc_clariion_checker: query command indicates error
Sep 14 19:33:21 nodob multipathd: checker failed path 8:160 in map 5Gb
Sep 14 19:33:21 nodob multipathd: remove sdg path checker
Sep 14 19:33:21 nodob multipathd: remove sdh path checker
Sep 14 19:33:21 nodob multipathd: remove sdi path checker
Sep 14 19:33:21 nodob multipathd: remove sdj path checker
Sep 14 19:33:21 nodob multipathd: remove sdk path checker
Sep 14 19:33:22 nodob multipathd: 8:160: mark as failed
Sep 14 19:33:43 nodob multipathd: 300Gb: switch to path group #1
Sep 14 19:33:43 nodob multipathd: 3600601608c901200a8b8972f4053d911: switch to path group #1
Sep 14 19:33:43 nodob multipathd: 3600601608c901200bc7680294053d911: switch to path group #1
Sep 14 19:33:43 nodob multipathd: 5Gb: switch to path group #1
Sep 14 19:33:43 nodob multipathd: 8:96: mark as failed
Sep 14 19:33:43 nodob multipathd: 8:128: mark as failed
Sep 14 19:33:43 nodob multipathd: 8:144: mark as failed
Sep 14 19:33:43 nodob multipathd: 8:160: mark as failed


multipath -l
5Gb (3600601608c9012006269b8f63b87d911)
[size=5 GB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [enabled]
 \_ 1:0:0:4 sdf 8:80 [active][ready]
\_ round-robin 0 [enabled]
 \_ #:#:#:#      8:160 [failed]

3600601608c901200a8b8972f4053d911
[size=100 MB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [enabled]
 \_ 1:0:0:2 sdd 8:48 [active][ready]
\_ round-robin 0 [enabled]
 \_ #:#:#:#      8:128 [failed]

200Gb (3600601608c901200ccfe543f4053d911)
[size=200 GB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [enabled]
 \_ 1:0:0:1 sdc 8:32 [active][ready]
\_ round-robin 0 [active]
 \_ #:#:#:#      8:112 [failed]

300Gb (3600601608c9012008ae5de2cc985d911)
[size=300 GB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [enabled]
 \_ 1:0:0:0 sdb 8:16 [active][ready]
\_ round-robin 0 [enabled]
 \_ #:#:#:#      8:96 [failed]

3600601608c901200bc7680294053d911
[size=100 MB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [enabled]
 \_ #:#:#:#      8:144 [failed]
\_ round-robin 0 [enabled]
 \_ 1:0:0:3 sde 8:64 [active][ready]


I can write to the storage without problem

*2) the failed path turn up

*multipath -l
5Gb (3600601608c9012006269b8f63b87d911)
[size=5 GB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [active]
 \_ 1:0:0:4 sdf 8:80  [active][ready]
\_ round-robin 0 [enabled]
 \_ 2:0:0:4 sdp 8:240 [active][ready]

3600601608c901200a8b8972f4053d911
[size=100 MB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [enabled]
 \_ 1:0:0:2 sdd 8:48  [active][ready]
\_ round-robin 0 [enabled]
 \_ 2:0:0:2 sdn 8:208 [active][ready]

200Gb (3600601608c901200ccfe543f4053d911)
[size=200 GB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [enabled]
 \_ 1:0:0:1 sdc 8:32  [active][ready]
\_ round-robin 0 [enabled]
 \_ 2:0:0:1 sdm 8:192 [active][ready]

300Gb (3600601608c9012008ae5de2cc985d911)
[size=300 GB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [enabled]
 \_ 1:0:0:0 sdb 8:16  [active][ready]
\_ round-robin 0 [enabled]
 \_ 2:0:0:0 sdl 8:176 [active][ready]

3600601608c901200bc7680294053d911
[size=100 MB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [enabled]
 \_ 2:0:0:3 sdo 8:224 [active][ready]
\_ round-robin 0 [enabled]
 \_ 1:0:0:3 sde 8:64  [active][ready]

I read and write without problem

every few seconds I have the following messages in /var/log/messages

Sep 14 19:36:58 nodob multipathd: 300Gb: switch to path group #1
Sep 14 19:36:58 nodob multipathd: 200Gb: switch to path group #2
Sep 14 19:36:58 nodob multipathd: 3600601608c901200a8b8972f4053d911: switch to path group #1
Sep 14 19:36:58 nodob multipathd: 3600601608c901200bc7680294053d911: switch to path group #1
Sep 14 19:36:58 nodob multipathd: 5Gb: switch to path group #1


*Cristophe is ok?*

*3) other path failure*

multipath -l
5Gb (3600601608c9012006269b8f63b87d911)
[size=5 GB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [enabled]
 \_ #:#:#:#      8:80  [failed]
\_ round-robin 0 [active]
 \_ 2:0:0:4 sdp 8:240 [active][ready]

3600601608c901200a8b8972f4053d911
[size=100 MB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [enabled]
 \_ #:#:#:#      8:48  [failed]
\_ round-robin 0 [enabled]
 \_ 2:0:0:2 sdn 8:208 [active][ready]

200Gb (3600601608c901200ccfe543f4053d911)
[size=200 GB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [enabled]
 \_ #:#:#:#      8:32  [failed]
\_ round-robin 0 [enabled]
 \_ 2:0:0:1 sdm 8:192 [active][ready]

300Gb (3600601608c9012008ae5de2cc985d911)
[size=300 GB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [enabled]
 \_ #:#:#:#      8:16  [failed]
\_ round-robin 0 [enabled]
 \_ 2:0:0:0 sdl 8:176 [active][ready]

3600601608c901200bc7680294053d911
[size=100 MB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [enabled]
 \_ 2:0:0:3 sdo 8:224 [active][ready]
\_ round-robin 0 [enabled]
 \_ #:#:#:#      8:64  [failed]


dmsetup table
vg00-portage: 0 4096000 linear 8:4 16384384
vg00-tmp: 0 4096000 linear 8:4 4096384
vg00-log: 0 8192000 linear 8:4 26624384
vg00-usr: 0 8192000 linear 8:4 8192384
vg00-var: 0 6144000 linear 8:4 20480384
vg00-root: 0 2048000 linear 8:4 2048384
5Gb: 0 10485760 multipath 0 1 emc 2 2 round-robin 0 1 1 8:80 1000 round-robin 0 1 1 8:240 1000
3600601608c901200a8b8972f4053d911: 0 204800 multipath 0 1 emc 2 1 round-robin 0 1 1 8:48 1000 round-robin 0 1 1 8:208 1000
vg00-admin: 0 2048000 linear 8:4 384
200Gb: 0 419430400 multipath 0 1 emc 2 2 round-robin 0 1 1 8:32 1000 round-robin 0 1 1 8:192 1000
300Gb: 0 629145600 multipath 0 1 emc 2 1 round-robin 0 1 1 8:16 1000 round-robin 0 1 1 8:176 1000
3600601608c901200bc7680294053d911: 0 204800 multipath 0 1 emc 2 1 round-robin 0 1 1 8:224 1000 round-robin 0 1 1 8:64 1000


*4) reboot with one path failed:*

multipath -l
5Gb (3600601608c9012006269b8f63b87d911)
[size=5 GB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [active]
 \_ 2:0:0:4 sdf 8:80 [active][ready]

3600601608c901200a8b8972f4053d911
[size=100 MB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [active]
 \_ 2:0:0:2 sdd 8:48 [active][ready]

200Gb (3600601608c901200ccfe543f4053d911)
[size=200 GB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [active]
 \_ 2:0:0:1 sdc 8:32 [active][ready]

300Gb (3600601608c9012008ae5de2cc985d911)
[size=300 GB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [active]
 \_ 2:0:0:0 sdb 8:16 [active][ready]

3600601608c901200bc7680294053d911
[size=100 MB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [active]
 \_ 2:0:0:3 sde 8:64 [active][ready]


df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/sda2             965M  534M  432M  56% /
udev                 1014M  124K 1014M   1% /dev
/dev/sda1              54M  5.2M   46M  11% /boot
/dev/mapper/vg00-admin
                     1000M   33M  968M   4% /admin
/dev/mapper/vg00-root
                     1000M   33M  968M   4% /root
/dev/mapper/vg00-usr  4.0G  868M  3.1G  22% /usr
/dev/mapper/vg00-var  3.0G   74M  2.9G   3% /var
/dev/mapper/vg00-tmp  2.0G   33M  2.0G   2% /tmp
/dev/mapper/vg00-log  4.0G   40M  3.9G   1% /var/log
/dev/mapper/vg00-portage
                      2.0G  234M  1.8G  12% /usr/portage
none                 1014M     0 1014M   0% /dev/shm
/dev/dm-6             5.0G  476M  4.6G  10% /mnt/web
/dev/dm-10            200G   33M  200G   1% /mnt/mysql
/dev/dm-3             300G   71M  300G   1% /mnt/mail

*NOTE*: the dm device name (dm-*) change every reboot the symbolic name (web,mysql,mail) remane the same

dmsetup table
vg00-portage: 0 4096000 linear 8:4 16384384
vg00-tmp: 0 4096000 linear 8:4 4096384
vg00-log: 0 8192000 linear 8:4 26624384
vg00-usr: 0 8192000 linear 8:4 8192384
vg00-var: 0 6144000 linear 8:4 20480384
vg00-root: 0 2048000 linear 8:4 2048384
5Gb: 0 10485760 multipath 0 1 emc 1 1 round-robin 0 1 1 8:80 1000
3600601608c901200a8b8972f4053d911: 0 204800 multipath 0 1 emc 1 1 round-robin 0 1 1 8:48 1000
vg00-admin: 0 2048000 linear 8:4 384
200Gb: 0 419430400 multipath 0 1 emc 1 1 round-robin 0 1 1 8:32 1000
300Gb: 0 629145600 multipath 0 1 emc 1 1 round-robin 0 1 1 8:16 1000
3600601608c901200bc7680294053d911: 0 204800 multipath 0 1 emc 1 1 round-robin 0 1 1 8:64 1000

*5) the failed path return up*

multipath -l
5Gb (3600601608c9012006269b8f63b87d911)
[size=5 GB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [enabled]
 \_ 2:0:0:4 sdf 8:80  [active][ready]
\_ round-robin 0 [enabled]
 \_ 1:0:0:4 sdk 8:160 [active][ready]

3600601608c901200a8b8972f4053d911
[size=100 MB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [enabled]
 \_ 1:0:0:2 sdi 8:128 [active][ready]
\_ round-robin 0 [enabled]
 \_ 2:0:0:2 sdd 8:48  [active][ready]

200Gb (3600601608c901200ccfe543f4053d911)
[size=200 GB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [enabled]
 \_ 2:0:0:1 sdc 8:32  [active][ready]
\_ round-robin 0 [enabled]
 \_ 1:0:0:1 sdh 8:112 [active][ready]

300Gb (3600601608c9012008ae5de2cc985d911)
[size=300 GB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [enabled]
 \_ 2:0:0:0 sdb 8:16  [active][ready]
\_ round-robin 0 [enabled]
 \_ 1:0:0:0 sdg 8:96  [active][ready]

3600601608c901200bc7680294053d911
[size=100 MB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [enabled]
 \_ 2:0:0:3 sde 8:64  [active][ready]
\_ round-robin 0 [enabled]
 \_ 1:0:0:3 sdj 8:144 [active][ready]


6) If I set multibus instead of failover in multipath.conf I have read-only filesystem after a path failure

*Conclusion*

For me multipath-tools on EMC CX300 works fine, there are only issue if i try multibus instead of failover, but I don't need multibus

thanks for multipath-tools,

Nicola


--------------070902030005040102060209
Content-Type: text/html; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html;charset=ISO-8859-15"
 http-equiv="Content-Type">
  <title></title>
</head>
<body bgcolor="#ffffff" text="#000000">
<big><b>Hardware</b></big><br>
<br>
2 poweredge 2850, dual xeon, 2Gb Ram, 2x36Gb scsi Raid 1<br>
1 EMC CX 300, about 500Gb Raid 5<br>
each poweredge is connected to EMC by two fibre channel paths<br>
<br>
<big><b>Software</b></big><br>
<br>
Gentoo Linux, installed on poweredge internal disks<br>
kernel-2.6.13-gentoo-r1<br>
udev-0.68-r1<br>
device-mapper-1.01.03<br>
multipath-tools-0.4.5<br>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="Generator" content="Kate, the KDE Advanced Text Editor">
<pre>I setup a <b>pure udev enviroment</b>:

/etc/conf.d/rc:

RC_DEVICES="udev"
RC_DEVICE_TARBALL="no"

I load the following modules at boot time

dm-emc
qla2300

my mutipath-tools configuration file is the following:

grep -v "#" <b>/etc/multipath.conf</b>
defaults {
        multipath_tool  "/sbin/multipath -v0"
        udev_dir        /dev
        polling_interval 5
        default_selector        "round-robin 0"
        default_getuid_callout  "/sbin/scsi_id -g -u -s /block/%n"
        default_prio_callout    "/bin/true"
        failback        immediate
}
multipaths {

        multipath {
                wwid                    3600601608c901200ccfe543f4053d911
                alias                   200Gb
                path_grouping_policy    failover
                path_checker            readsector0
                path_selector           "round-robin 0"
                failback                immediate
        }
        multipath {
                wwid                    3600601608c9012006269b8f63b87d911
                alias                   5Gb
                path_grouping_policy    failover
                path_checker            readsector0
                path_selector           "round-robin 0"
                failback                immediate
        }
        multipath {
                wwid                    3600601608c9012008ae5de2cc985d911
                alias                   300Gb
                path_grouping_policy    failover
                path_checker            readsector0
                path_selector           "round-robin 0"
                failback                immediate
        }
}

multipathd start at boot time

<b>rc-update add multipathd default
</b>
this is what system see after boot

<b>multipath -l</b>
5Gb (3600601608c9012006269b8f63b87d911)
[size=5 GB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [enabled]
 \_ 1:0:0:4 sdf 8:80  [active][ready]
\_ round-robin 0 [enabled]
 \_ 2:0:0:4 sdk 8:160 [active][ready]

3600601608c901200a8b8972f4053d911
[size=100 MB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [enabled]
 \_ 1:0:0:2 sdd 8:48  [active][ready]
\_ round-robin 0 [enabled]
 \_ 2:0:0:2 sdi 8:128 [active][ready]

200Gb (3600601608c901200ccfe543f4053d911)
[size=200 GB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [enabled]
 \_ 1:0:0:1 sdc 8:32  [active][ready]
\_ round-robin 0 [enabled]
 \_ 2:0:0:1 sdh 8:112 [active][ready]

300Gb (3600601608c9012008ae5de2cc985d911)
[size=300 GB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [enabled]
 \_ 1:0:0:0 sdb 8:16  [active][ready]
\_ round-robin 0 [enabled]
 \_ 2:0:0:0 sdg 8:96  [active][ready]

3600601608c901200bc7680294053d911
[size=100 MB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [enabled]
 \_ 2:0:0:3 sdj 8:144 [active][ready]
\_ round-robin 0 [enabled]
 \_ 1:0:0:3 sde 8:64  [active][ready]


<b>dmsetup table</b>
vg00-portage: 0 4096000 linear 8:4 16384384
vg00-tmp: 0 4096000 linear 8:4 4096384
vg00-log: 0 8192000 linear 8:4 26624384
vg00-usr: 0 8192000 linear 8:4 8192384
vg00-var: 0 6144000 linear 8:4 20480384
vg00-root: 0 2048000 linear 8:4 2048384
5Gb: 0 10485760 multipath 0 1 emc 2 1 round-robin 0 1 1 8:80 1000 round-robin 0 1 1 8:160 1000
3600601608c901200a8b8972f4053d911: 0 204800 multipath 0 1 emc 2 1 round-robin 0 1 1 8:48 1000 round-robin 0 1 1 8:128 1000
vg00-admin: 0 2048000 linear 8:4 384
200Gb: 0 419430400 multipath 0 1 emc 2 2 round-robin 0 1 1 8:32 1000 round-robin 0 1 1 8:112 1000
300Gb: 0 629145600 multipath 0 1 emc 2 1 round-robin 0 1 1 8:16 1000 round-robin 0 1 1 8:96 1000
3600601608c901200bc7680294053d911: 0 204800 multipath 0 1 emc 2 1 round-robin 0 1 1 8:144 1000 round-robin 0 1 1 8:64 1000

<b>df -h</b>
Filesystem            Size  Used Avail Use% Mounted on
/dev/sda2             965M  534M  432M  56% /
udev                 1014M  144K 1014M   1% /dev
/dev/sda1              54M  5.2M   46M  11% /boot
/dev/mapper/vg00-admin
                     1000M   33M  968M   4% /admin
/dev/mapper/vg00-root
                     1000M   33M  968M   4% /root
/dev/mapper/vg00-usr  4.0G  868M  3.1G  22% /usr
/dev/mapper/vg00-var  3.0G   74M  2.9G   3% /var
/dev/mapper/vg00-tmp  2.0G   33M  2.0G   2% /tmp
/dev/mapper/vg00-log  4.0G   40M  3.9G   1% /var/log
/dev/mapper/vg00-portage
                      2.0G  234M  1.8G  12% /usr/portage
none                 1014M     0 1014M   0% /dev/shm
/dev/dm-2             5.0G   33M  5.0G   1% /mnt/web
/dev/dm-1             200G   33M  200G   1% /mnt/mysql
/dev/dm-4             300G   71M  300G   1% /mnt/mail


I have the following in /dev:

nodob admin # cd /dev/
nodob dev # ls -la
total 1
drwxr-xr-x  12 root root      3440 Sep 14 19:21 .
drwxr-xr-x  21 root root       624 Sep 14 19:21 ..
-rw-r--r--   1 root root         0 Sep 14  2005 .udev
drwxr-xr-x   2 root root       760 Sep 14  2005 .udevdb
lrwxrwxrwx   1 root root         4 Sep 14  2005 <b>200Gb -&gt; dm-4</b>
lrwxrwxrwx   1 root root         4 Sep 14  2005 <b>300Gb -&gt; dm-3</b>
lrwxrwxrwx   1 root root         4 Sep 14  2005 3600601608c901200a8b8972f4053d911 -&gt; dm-2
lrwxrwxrwx   1 root root         4 Sep 14  2005 3600601608c901200bc7680294053d911 -&gt; dm-0
lrwxrwxrwx   1 root root         4 Sep 14  2005 <b>5Gb -&gt; dm-1</b>

and in /dev/mapper:

nodob mapper # ls -la
total 0
drwxr-xr-x   2 root root     300 Sep 14  2005 .
drwxr-xr-x  12 root root    3440 Sep 14 19:29 ..
<b>brw-------   1 root root 254,  1 Sep 14  2005 200Gb
brw-------   1 root root 254,  4 Sep 14  2005 300Gb</b>
brw-------   1 root root 254,  3 Sep 14  2005 3600601608c901200a8b8972f4053d911
brw-------   1 root root 254,  0 Sep 14  2005 3600601608c901200bc7680294053d911
<b>brw-------   1 root root 254,  2 Sep 14  2005 5Gb</b>
crw-rw----   1 root root  10, 63 Sep 14  2005 control
brw-------   1 root root 254,  5 Sep 14  2005 vg00-admin
brw-------   1 root root 254, 11 Sep 14  2005 vg00-log
brw-------   1 root root 254,  9 Sep 14  2005 vg00-portage
brw-------   1 root root 254,  6 Sep 14  2005 vg00-root
brw-------   1 root root 254,  7 Sep 14  2005 vg00-tmp
brw-------   1 root root 254,  8 Sep 14  2005 vg00-usr
brw-------   1 root root 254, 10 Sep 14  2005 vg00-var


some tests:

<big><b>1) one path failure</b></big>

/var/log/messages

Sep 14 19:33:21 nodob multipathd: 8:96: emc_clariion_checker: query command indicates error
Sep 14 19:33:21 nodob multipathd: checker failed path 8:96 in map 300Gb
Sep 14 19:33:21 nodob multipathd: 8:112: emc_clariion_checker: query command indicates error
Sep 14 19:33:21 nodob multipathd: checker failed path 8:112 in map 200Gb
Sep 14 19:33:21 nodob multipathd: 8:128: emc_clariion_checker: query command indicates error
Sep 14 19:33:21 nodob multipathd: checker failed path 8:128 in map 3600601608c901200a8b8972f4053d911
Sep 14 19:33:21 nodob multipathd: 8:144: emc_clariion_checker: query command indicates error
Sep 14 19:33:21 nodob multipathd: checker failed path 8:144 in map 3600601608c901200bc7680294053d911
Sep 14 19:33:21 nodob multipathd: 8:160: emc_clariion_checker: query command indicates error
Sep 14 19:33:21 nodob multipathd: checker failed path 8:160 in map 5Gb
Sep 14 19:33:21 nodob multipathd: remove sdg path checker
Sep 14 19:33:21 nodob multipathd: remove sdh path checker
Sep 14 19:33:21 nodob multipathd: remove sdi path checker
Sep 14 19:33:21 nodob multipathd: remove sdj path checker
Sep 14 19:33:21 nodob multipathd: remove sdk path checker
Sep 14 19:33:22 nodob multipathd: 8:160: mark as failed
Sep 14 19:33:43 nodob multipathd: 300Gb: switch to path group #1
Sep 14 19:33:43 nodob multipathd: 3600601608c901200a8b8972f4053d911: switch to path group #1
Sep 14 19:33:43 nodob multipathd: 3600601608c901200bc7680294053d911: switch to path group #1
Sep 14 19:33:43 nodob multipathd: 5Gb: switch to path group #1
Sep 14 19:33:43 nodob multipathd: 8:96: mark as failed
Sep 14 19:33:43 nodob multipathd: 8:128: mark as failed
Sep 14 19:33:43 nodob multipathd: 8:144: mark as failed
Sep 14 19:33:43 nodob multipathd: 8:160: mark as failed


multipath -l
5Gb (3600601608c9012006269b8f63b87d911)
[size=5 GB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [enabled]
 \_ 1:0:0:4 sdf 8:80 [active][ready]
\_ round-robin 0 [enabled]
 \_ #:#:#:#      8:160 [failed]

3600601608c901200a8b8972f4053d911
[size=100 MB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [enabled]
 \_ 1:0:0:2 sdd 8:48 [active][ready]
\_ round-robin 0 [enabled]
 \_ #:#:#:#      8:128 [failed]

200Gb (3600601608c901200ccfe543f4053d911)
[size=200 GB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [enabled]
 \_ 1:0:0:1 sdc 8:32 [active][ready]
\_ round-robin 0 [active]
 \_ #:#:#:#      8:112 [failed]

300Gb (3600601608c9012008ae5de2cc985d911)
[size=300 GB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [enabled]
 \_ 1:0:0:0 sdb 8:16 [active][ready]
\_ round-robin 0 [enabled]
 \_ #:#:#:#      8:96 [failed]

3600601608c901200bc7680294053d911
[size=100 MB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [enabled]
 \_ #:#:#:#      8:144 [failed]
\_ round-robin 0 [enabled]
 \_ 1:0:0:3 sde 8:64 [active][ready]


I can write to the storage without problem

<b><big>2) the failed path turn up</big>

</b>multipath -l
5Gb (3600601608c9012006269b8f63b87d911)
[size=5 GB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [active]
 \_ 1:0:0:4 sdf 8:80  [active][ready]
\_ round-robin 0 [enabled]
 \_ 2:0:0:4 sdp 8:240 [active][ready]

3600601608c901200a8b8972f4053d911
[size=100 MB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [enabled]
 \_ 1:0:0:2 sdd 8:48  [active][ready]
\_ round-robin 0 [enabled]
 \_ 2:0:0:2 sdn 8:208 [active][ready]

200Gb (3600601608c901200ccfe543f4053d911)
[size=200 GB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [enabled]
 \_ 1:0:0:1 sdc 8:32  [active][ready]
\_ round-robin 0 [enabled]
 \_ 2:0:0:1 sdm 8:192 [active][ready]

300Gb (3600601608c9012008ae5de2cc985d911)
[size=300 GB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [enabled]
 \_ 1:0:0:0 sdb 8:16  [active][ready]
\_ round-robin 0 [enabled]
 \_ 2:0:0:0 sdl 8:176 [active][ready]

3600601608c901200bc7680294053d911
[size=100 MB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [enabled]
 \_ 2:0:0:3 sdo 8:224 [active][ready]
\_ round-robin 0 [enabled]
 \_ 1:0:0:3 sde 8:64  [active][ready]

I read and write without problem

every few seconds I have the following messages in /var/log/messages

Sep 14 19:36:58 nodob multipathd: 300Gb: switch to path group #1
Sep 14 19:36:58 nodob multipathd: 200Gb: switch to path group #2
Sep 14 19:36:58 nodob multipathd: 3600601608c901200a8b8972f4053d911: switch to path group #1
Sep 14 19:36:58 nodob multipathd: 3600601608c901200bc7680294053d911: switch to path group #1
Sep 14 19:36:58 nodob multipathd: 5Gb: switch to path group #1


<b><big>Cristophe is ok?</big></b>

<big><b>3) other path failure</b></big>

multipath -l
5Gb (3600601608c9012006269b8f63b87d911)
[size=5 GB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [enabled]
 \_ #:#:#:#      8:80  [failed]
\_ round-robin 0 [active]
 \_ 2:0:0:4 sdp 8:240 [active][ready]

3600601608c901200a8b8972f4053d911
[size=100 MB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [enabled]
 \_ #:#:#:#      8:48  [failed]
\_ round-robin 0 [enabled]
 \_ 2:0:0:2 sdn 8:208 [active][ready]

200Gb (3600601608c901200ccfe543f4053d911)
[size=200 GB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [enabled]
 \_ #:#:#:#      8:32  [failed]
\_ round-robin 0 [enabled]
 \_ 2:0:0:1 sdm 8:192 [active][ready]

300Gb (3600601608c9012008ae5de2cc985d911)
[size=300 GB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [enabled]
 \_ #:#:#:#      8:16  [failed]
\_ round-robin 0 [enabled]
 \_ 2:0:0:0 sdl 8:176 [active][ready]

3600601608c901200bc7680294053d911
[size=100 MB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [enabled]
 \_ 2:0:0:3 sdo 8:224 [active][ready]
\_ round-robin 0 [enabled]
 \_ #:#:#:#      8:64  [failed]


dmsetup table
vg00-portage: 0 4096000 linear 8:4 16384384
vg00-tmp: 0 4096000 linear 8:4 4096384
vg00-log: 0 8192000 linear 8:4 26624384
vg00-usr: 0 8192000 linear 8:4 8192384
vg00-var: 0 6144000 linear 8:4 20480384
vg00-root: 0 2048000 linear 8:4 2048384
5Gb: 0 10485760 multipath 0 1 emc 2 2 round-robin 0 1 1 8:80 1000 round-robin 0 1 1 8:240 1000
3600601608c901200a8b8972f4053d911: 0 204800 multipath 0 1 emc 2 1 round-robin 0 1 1 8:48 1000 round-robin 0 1 1 8:208 1000
vg00-admin: 0 2048000 linear 8:4 384
200Gb: 0 419430400 multipath 0 1 emc 2 2 round-robin 0 1 1 8:32 1000 round-robin 0 1 1 8:192 1000
300Gb: 0 629145600 multipath 0 1 emc 2 1 round-robin 0 1 1 8:16 1000 round-robin 0 1 1 8:176 1000
3600601608c901200bc7680294053d911: 0 204800 multipath 0 1 emc 2 1 round-robin 0 1 1 8:224 1000 round-robin 0 1 1 8:64 1000


<big><b>4) reboot with one path failed:</b></big>

multipath -l
5Gb (3600601608c9012006269b8f63b87d911)
[size=5 GB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [active]
 \_ 2:0:0:4 sdf 8:80 [active][ready]

3600601608c901200a8b8972f4053d911
[size=100 MB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [active]
 \_ 2:0:0:2 sdd 8:48 [active][ready]

200Gb (3600601608c901200ccfe543f4053d911)
[size=200 GB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [active]
 \_ 2:0:0:1 sdc 8:32 [active][ready]

300Gb (3600601608c9012008ae5de2cc985d911)
[size=300 GB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [active]
 \_ 2:0:0:0 sdb 8:16 [active][ready]

3600601608c901200bc7680294053d911
[size=100 MB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [active]
 \_ 2:0:0:3 sde 8:64 [active][ready]


df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/sda2             965M  534M  432M  56% /
udev                 1014M  124K 1014M   1% /dev
/dev/sda1              54M  5.2M   46M  11% /boot
/dev/mapper/vg00-admin
                     1000M   33M  968M   4% /admin
/dev/mapper/vg00-root
                     1000M   33M  968M   4% /root
/dev/mapper/vg00-usr  4.0G  868M  3.1G  22% /usr
/dev/mapper/vg00-var  3.0G   74M  2.9G   3% /var
/dev/mapper/vg00-tmp  2.0G   33M  2.0G   2% /tmp
/dev/mapper/vg00-log  4.0G   40M  3.9G   1% /var/log
/dev/mapper/vg00-portage
                      2.0G  234M  1.8G  12% /usr/portage
none                 1014M     0 1014M   0% /dev/shm
/dev/dm-6             5.0G  476M  4.6G  10% /mnt/web
/dev/dm-10            200G   33M  200G   1% /mnt/mysql
/dev/dm-3             300G   71M  300G   1% /mnt/mail
<big>
<small><b>NOTE</b>: the dm device name (dm-*) change every reboot the symbolic name (web,mysql,mail) remane the same</small>
</big>
dmsetup table
vg00-portage: 0 4096000 linear 8:4 16384384
vg00-tmp: 0 4096000 linear 8:4 4096384
vg00-log: 0 8192000 linear 8:4 26624384
vg00-usr: 0 8192000 linear 8:4 8192384
vg00-var: 0 6144000 linear 8:4 20480384
vg00-root: 0 2048000 linear 8:4 2048384
5Gb: 0 10485760 multipath 0 1 emc 1 1 round-robin 0 1 1 8:80 1000
3600601608c901200a8b8972f4053d911: 0 204800 multipath 0 1 emc 1 1 round-robin 0 1 1 8:48 1000
vg00-admin: 0 2048000 linear 8:4 384
200Gb: 0 419430400 multipath 0 1 emc 1 1 round-robin 0 1 1 8:32 1000
300Gb: 0 629145600 multipath 0 1 emc 1 1 round-robin 0 1 1 8:16 1000
3600601608c901200bc7680294053d911: 0 204800 multipath 0 1 emc 1 1 round-robin 0 1 1 8:64 1000

<big><b>5) the failed path return up</b></big>

multipath -l
5Gb (3600601608c9012006269b8f63b87d911)
[size=5 GB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [enabled]
 \_ 2:0:0:4 sdf 8:80  [active][ready]
\_ round-robin 0 [enabled]
 \_ 1:0:0:4 sdk 8:160 [active][ready]

3600601608c901200a8b8972f4053d911
[size=100 MB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [enabled]
 \_ 1:0:0:2 sdi 8:128 [active][ready]
\_ round-robin 0 [enabled]
 \_ 2:0:0:2 sdd 8:48  [active][ready]

200Gb (3600601608c901200ccfe543f4053d911)
[size=200 GB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [enabled]
 \_ 2:0:0:1 sdc 8:32  [active][ready]
\_ round-robin 0 [enabled]
 \_ 1:0:0:1 sdh 8:112 [active][ready]

300Gb (3600601608c9012008ae5de2cc985d911)
[size=300 GB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [enabled]
 \_ 2:0:0:0 sdb 8:16  [active][ready]
\_ round-robin 0 [enabled]
 \_ 1:0:0:0 sdg 8:96  [active][ready]

3600601608c901200bc7680294053d911
[size=100 MB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [enabled]
 \_ 2:0:0:3 sde 8:64  [active][ready]
\_ round-robin 0 [enabled]
 \_ 1:0:0:3 sdj 8:144 [active][ready]


6) If I set multibus instead of failover in multipath.conf I have read-only filesystem after a path failure

<big><b>Conclusion</b></big>

For me multipath-tools on EMC CX300 works fine, there are only issue if i try multibus instead of failover, but I don't need multibus

thanks for multipath-tools,

Nicola
</pre>
</body>
</html>

--------------070902030005040102060209--


--===============2033029760==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2033029760==--
