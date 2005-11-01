From: Bernd Zeimetz <bernd@bzed.de>
Subject: Re: multipath + evms problems
Date: Tue, 1 Nov 2005 01:29:07 +0100
Message-ID: <200511010129.07773.bernd@bzed.de>
References: <200510291248.51290.bernd@bzed.de>
	<200510312320.06690.bernd@bzed.de>
	<200510311801.44636.kevcorry@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200510311801.44636.kevcorry@us.ibm.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: dm-devel@redhat.com, EVMS <evms-devel@lists.sourceforge.net>
List-Id: dm-devel.ids

> > Oct 29 13:22:54 zeus-2 _2_ Engine: build_target_list: Error getting
> > number of devices and groups from the target type. Oct 29 13:22:54 zeus-2
> > _2_ Engine: build_target_list: Error building target list. Name =
> > 3600601f4a20c000096dc229956b0d711 Oct 29 13:22:54 zeus-2 _2_ LocalDskMgr:
> > check_multipath: Error getting DM mapping for disk
> > 3600601f4a20c000096dc229956b0d711. [...] x 8 - for every LUN
>
> Please send in the output from "dmsetup ls" and "dmsetup table", and the
> contents of /proc/partitions. Also, run "evms -d debug", and mail me
> (privately) a gzipped copy of /var/log/evms-engine.log.



zeus-2:~# dmsetup ls
lvm|RAIDFC|FG-GTA       (254, 60)
FB-FACHSCHAFT   (254, 25)
FG-TWE  (254, 77)
lvm|RAIDFC|FG-STADT     (254, 72)
FG-EE   (254, 49)
FB-BIB  (254, 19)
FG-STADT        (254, 73)
FB-COPYSHOP     (254, 21)
ZEUS-2  (254, 95)
lvm|RAIDFC|FG-CAD       (254, 44)
3600601f2a20c0000fa13caa656b0d711       (254, 1)
lvm|RAIDFC|FB-SICHTEN   (254, 40)
lvm|RAIDFC|FG-DRUCK     (254, 46)
FB-HAUSMEISTER  (254, 27)
WIN_CLIENT      (254, 91)
lvm|RAIDFC|FG-EUB       (254, 56)
lvm|RAIDFC|FG-EG        (254, 52)
ZEUS-1  (254, 93)
FG-PAR  (254, 69)
lvm|RAIDFC|FG-HBK       (254, 62)
lvm|RAIDFC|HOMES        (254, 82)
FG-ZMG  (254, 81)
FG-DRUCK        (254, 47)
sdo1    (254, 8)
3600601f4a20c000099dc229956b0d711       (254, 6)
lvm|RAIDFC|FG-STATIK    (254, 74)
lvm|RAIDFC|SERVICE      (254, 88)
lvm|RAIDFC|FG-EF        (254, 50)
lvm|RAIDFC|FB-FACHSCHAFT        (254, 24)
lvm|RAIDFC|APPLICATION  (254, 16)
sdj1    (254, 12)
IO      (254, 85)
lvm|RAIDFC|FG-EGT       (254, 54)
lvm|RAIDFC|FG-EE        (254, 48)
lvm|RAIDFC|FB-SCHULUNG  (254, 38)
FB-DEKANAT      (254, 23)
FG-PLASTEN      (254, 71)
lvm|RAIDFC|FG-TWE       (254, 76)
3600601f4a20c000098dc229956b0d711       (254, 4)
SERVICE (254, 89)
lvm|RAIDFC|FB-POOL      (254, 32)
sdm1    (254, 10)
APPLICATION     (254, 17)
FB-PR   (254, 35)
FG-EUR  (254, 59)
lvm|RAIDFC|FB-BIB       (254, 18)
sdh1    (254, 13)
3600601f2a20c0000fd13caa656b0d711       (254, 7)
FG-GTA  (254, 61)
FB-SCHULUNG     (254, 39)
lvm|RAIDFC|ZEUS-2       (254, 94)
lvm|RAIDFC|FB-KUHLE     (254, 30)
FG-KUKLAR       (254, 67)
lvm|RAIDFC|FB-HAUSMEISTER       (254, 26)
lvm|RAIDFC|WIN_CLIENT   (254, 90)
FB-KUHLE        (254, 31)
lvm|RAIDFC|ZEUS-1       (254, 92)
lvm|RAIDFC|NETZ (254, 86)
lvm|RAIDFC|FG-PAR       (254, 68)
FB-POOL (254, 33)
3600601f4a20c000097dc229956b0d711       (254, 3)
lvm|RAIDFC|FG-ZMG       (254, 80)
sdk1    (254, 11)
lvm|RAIDFC|FG-WOBAU     (254, 78)
FG-CAD  (254, 45)
NETZ    (254, 87)
FB-SICHTEN      (254, 41)
lvm|RAIDFC|FB-WERKSTATT (254, 42)
3600601f2a20c0000fc13caa656b0d711       (254, 5)
lvm|RAIDFC|FB-PRUEFUNG  (254, 36)
lvm|RAIDFC|FB-HOMEPAGE  (254, 28)
lvm|RAIDFC|IO   (254, 84)
FG-WOBAU        (254, 79)
lvm|RAIDFC|FG-INDU      (254, 64)
FG-EUB  (254, 57)
FG-HBK  (254, 63)
sda1    (254, 15)
FB-WERKSTATT    (254, 43)
lvm|RAIDFC|FB-PR        (254, 34)
lvm|RAIDFC|FB-DEKANAT   (254, 22)
sdn1    (254, 9)
3600601f4a20c000096dc229956b0d711       (254, 0)
lvm|RAIDFC|FG-PLASTEN   (254, 70)
FG-EGT  (254, 55)
FG-EG   (254, 53)
HOMES   (254, 83)
lvm|RAIDFC|FG-KUKLAR    (254, 66)
lvm|RAIDFC|FB-COPYSHOP  (254, 20)
FB-PRUEFUNG     (254, 37)
FB-HOMEPAGE     (254, 29)
3600601f2a20c0000fb13caa656b0d711       (254, 2)
FG-STATIK       (254, 75)
FG-INDU (254, 65)
lvm|RAIDFC|FG-EUR       (254, 58)
sdd1    (254, 14)
FG-EF   (254, 51)
zeus-2:~#



zeus-2:~# dmsetup table
lvm|RAIDFC|FG-GTA: 0 52428800 linear 254:11 122716672
FB-FACHSCHAFT: 0 20971518 linear 254:24 0
FG-TWE: 0 52428798 linear 254:76 0
lvm|RAIDFC|FG-STADT: 0 68976640 linear 254:11 489718272
lvm|RAIDFC|FG-STADT: 68976640 140738560 linear 254:14 33280
lvm|RAIDFC|FG-STADT: 209715200 52428800 linear 254:13 37847424
lvm|RAIDFC|FG-STADT: 262144000 10485760 linear 254:13 163447168
lvm|RAIDFC|FG-STADT: 272629760 41943040 linear 254:13 247333248
FG-EE: 0 73400318 linear 254:48 0
FB-BIB: 0 10485758 linear 254:18 0
FG-STADT: 0 314572798 linear 254:72 0
FB-COPYSHOP: 0 10485758 linear 254:20 0
ZEUS-2: 0 10485758 linear 254:94 0
lvm|RAIDFC|FG-CAD: 0 34603008 linear 254:12 218661248
lvm|RAIDFC|FG-CAD: 34603008 17825792 linear 254:11 33280
lvm|RAIDFC|FG-CAD: 52428800 52428800 linear 254:11 70287872
lvm|RAIDFC|FG-CAD: 104857600 20971520 linear 254:13 226361728
lvm|RAIDFC|FG-CAD: 125829120 41943040 linear 254:13 289276288
3600601f2a20c0000fa13caa656b0d711: 0 253304832 multipath 0 1 emc 2 1 round-robin 0 1 1 8:16 1000 round-robin 0 1 1 8:144 1000
lvm|RAIDFC|FB-SICHTEN: 0 104857600 linear 254:14 287572480
lvm|RAIDFC|FB-SICHTEN: 104857600 41484288 linear 254:13 331219328
lvm|RAIDFC|FB-SICHTEN: 146341888 458752 linear 254:13 393675136
lvm|RAIDFC|FG-DRUCK: 0 52428800 linear 254:11 280003072
FB-HAUSMEISTER: 0 10485758 linear 254:26 0
WIN_CLIENT: 0 196606 linear 254:90 0
lvm|RAIDFC|FG-EUB: 0 52428800 linear 254:11 437289472
lvm|RAIDFC|FG-EUB: 52428800 20971520 linear 254:13 90276224
lvm|RAIDFC|FG-EG: 0 52428800 linear 254:11 332431872
ZEUS-1: 0 10485758 linear 254:92 0
FG-PAR: 0 52428798 linear 254:68 0
lvm|RAIDFC|FG-HBK: 0 52428800 linear 254:12 61374848
lvm|RAIDFC|HOMES: 0 103350272 linear 254:14 455344640
lvm|RAIDFC|HOMES: 103350272 419004416 linear 254:10 33152
lvm|RAIDFC|HOMES: 522354688 419004416 linear 254:9 33152
lvm|RAIDFC|HOMES: 941359104 488833024 linear 254:8 33152
lvm|RAIDFC|HOMES: 1430192128 37814272 linear 254:13 33152
FG-ZMG: 0 52428798 linear 254:80 0
FG-DRUCK: 0 52428798 linear 254:46 0
sdo1: 0 488873952 linear 8:224 63
3600601f4a20c000099dc229956b0d711: 0 488886272 multipath 0 1 emc 2 1 round-robin 0 1 1 8:224 1000 round-robin 0 1 1 8:96 1000
lvm|RAIDFC|FG-STATIK: 0 52428800 linear 254:15 104890752
lvm|RAIDFC|SERVICE: 0 41943040 linear 254:14 203686400
lvm|RAIDFC|FG-EF: 0 52428800 linear 254:15 33152
lvm|RAIDFC|FG-EF: 52428800 31457280 linear 254:13 173932928
lvm|RAIDFC|FB-FACHSCHAFT: 0 10485760 linear 254:14 182714880
lvm|RAIDFC|FB-FACHSCHAFT: 10485760 10485760 linear 254:13 457802112
lvm|RAIDFC|APPLICATION: 0 10485760 linear 254:14 444858880
sdj1: 0 253296792 linear 8:144 63
IO: 0 196606 linear 254:84 0
lvm|RAIDFC|FG-EGT: 0 52428800 linear 254:15 52461952
lvm|RAIDFC|FG-EE: 0 52428800 linear 254:15 157319552
lvm|RAIDFC|FG-EE: 52428800 20971520 linear 254:13 121733504
lvm|RAIDFC|FB-SCHULUNG: 0 41943040 linear 254:14 245629440
FB-DEKANAT: 0 10485758 linear 254:22 0
FG-PLASTEN: 0 52428798 linear 254:70 0
lvm|RAIDFC|FG-TWE: 0 52428800 linear 254:11 17859072
3600601f4a20c000098dc229956b0d711: 0 419045376 multipath 0 1 emc 2 1 round-robin 0 1 1 8:192 1000 round-robin 0 1 1 8:64 1000
SERVICE: 0 41943038 linear 254:88 0
lvm|RAIDFC|FB-POOL: 0 20971520 linear 254:14 392430080
lvm|RAIDFC|FB-POOL: 20971520 10485760 linear 254:13 111247744
sdm1: 0 419039397 linear 8:192 63
APPLICATION: 0 10485758 linear 254:16 0
FB-PR: 0 10485758 linear 254:34 0
FG-EUR: 0 52428798 linear 254:58 0
lvm|RAIDFC|FB-BIB: 0 10485760 linear 254:14 140771840
sdh1: 0 488873952 linear 8:112 63
3600601f2a20c0000fd13caa656b0d711: 0 488886272 multipath 0 1 emc 2 1 round-robin 0 1 1 8:112 1000 round-robin 0 1 1 8:240 1000
FG-GTA: 0 52428798 linear 254:60 0
FB-SCHULUNG: 0 41943038 linear 254:38 0
lvm|RAIDFC|ZEUS-2: 0 10485760 linear 254:13 372703616
lvm|RAIDFC|FB-KUHLE: 0 10485760 linear 254:14 413401600
FG-KUKLAR: 0 52428798 linear 254:66 0
lvm|RAIDFC|FB-HAUSMEISTER: 0 10485760 linear 254:14 172229120
lvm|RAIDFC|WIN_CLIENT: 0 196608 linear 254:13 457408896
FB-KUHLE: 0 10485758 linear 254:30 0
lvm|RAIDFC|ZEUS-1: 0 10485760 linear 254:13 152961408
lvm|RAIDFC|NETZ: 0 10485760 linear 254:13 383189376
lvm|RAIDFC|FG-PAR: 0 52428800 linear 254:11 384860672
FB-POOL: 0 31457278 linear 254:32 0
3600601f4a20c000097dc229956b0d711: 0 558727168 multipath 0 1 emc 2 1 round-robin 0 1 1 8:48 1000 round-robin 0 1 1 8:176 1000
lvm|RAIDFC|FG-ZMG: 0 52428800 linear 254:12 113803648
sdk1: 0 558724572 linear 8:160 63
lvm|RAIDFC|FG-WOBAU: 0 52428800 linear 254:11 227574272
FG-CAD: 0 167772158 linear 254:44 0
NETZ: 0 10485758 linear 254:86 0
FB-SICHTEN: 0 146800638 linear 254:40 0
lvm|RAIDFC|FB-WERKSTATT: 0 10485760 linear 254:14 161743360
3600601f2a20c0000fc13caa656b0d711: 0 419045376 multipath 0 1 emc 2 1 round-robin 0 1 1 8:80 1000 round-robin 0 1 1 8:208 1000
lvm|RAIDFC|FB-PRUEFUNG: 0 10256384 linear 254:13 142705024
lvm|RAIDFC|FB-HOMEPAGE: 0 10485760 linear 254:14 423887360
lvm|RAIDFC|IO: 0 196608 linear 254:13 457605504
FG-WOBAU: 0 52428798 linear 254:78 0
lvm|RAIDFC|FG-INDU: 0 52428800 linear 254:11 175145472
lvm|RAIDFC|FG-INDU: 52428800 20971520 linear 254:13 205390208
FG-EUB: 0 73400318 linear 254:56 0
FG-HBK: 0 52428798 linear 254:62 0
sda1: 0 253296792 linear 8:0 63
FB-WERKSTATT: 0 10485758 linear 254:42 0
lvm|RAIDFC|FB-PR: 0 10485760 linear 254:14 434373120
lvm|RAIDFC|FB-DEKANAT: 0 10485760 linear 254:14 151257600
sdn1: 0 419039397 linear 8:208 63
3600601f4a20c000096dc229956b0d711: 0 253304832 multipath 0 1 emc 2 1 round-robin 0 1 1 8:128 1000 round-robin 0 1 1 8:0 1000
lvm|RAIDFC|FG-PLASTEN: 0 43515904 linear 254:15 209748352
lvm|RAIDFC|FG-PLASTEN: 43515904 8912896 linear 254:12 33152
FG-EGT: 0 52428798 linear 254:54 0
FG-EG: 0 52428798 linear 254:52 0
HOMES: 0 1468006398 linear 254:82 0
lvm|RAIDFC|FG-KUKLAR: 0 52428800 linear 254:12 166232448
lvm|RAIDFC|FB-COPYSHOP: 0 10485760 linear 254:14 193200640
FB-PRUEFUNG: 0 10256382 linear 254:36 0
FB-HOMEPAGE: 0 10485758 linear 254:28 0
3600601f2a20c0000fb13caa656b0d711: 0 558727168 multipath 0 1 emc 2 1 round-robin 0 1 1 8:160 1000 round-robin 0 1 1 8:32 1000
FG-STATIK: 0 52428798 linear 254:74 0
FG-INDU: 0 73400318 linear 254:64 0
lvm|RAIDFC|FG-EUR: 0 52428800 linear 254:12 8946048
sdd1: 0 558724572 linear 8:48 63
FG-EF: 0 83886078 linear 254:50 0
zeus-2:~#


zeus-2:~# evms -d debug

EVMS Command Line Interpreter Version 2.5.2

Engine: Error code 5 (Input/output error) when reading the primary copy of feature header on object sdp.
Engine: Error code 5 (Input/output error) when reading the secondary copy of feature header on object sdp.
Engine: Error code 5 (Input/output error) when reading the primary copy of feature header on object sdl.
Engine: Error code 5 (Input/output error) when reading the secondary copy of feature header on object sdl.
Engine: Error code 5 (Input/output error) when reading the primary copy of feature header on object sdi.
Engine: Error code 5 (Input/output error) when reading the secondary copy of feature header on object sdi.
Engine: Error code 5 (Input/output error) when reading the primary copy of feature header on object sdg.
Engine: Error code 5 (Input/output error) when reading the secondary copy of feature header on object sdg.
Engine: Error code 5 (Input/output error) when reading the primary copy of feature header on object sdf.
Engine: Error code 5 (Input/output error) when reading the secondary copy of feature header on object sdf.
Engine: Error code 5 (Input/output error) when reading the primary copy of feature header on object sde.
Engine: Error code 5 (Input/output error) when reading the secondary copy of feature header on object sde.
Engine: Error code 5 (Input/output error) when reading the primary copy of feature header on object sdc.
Engine: Error code 5 (Input/output error) when reading the secondary copy of feature header on object sdc.
Engine: Error code 5 (Input/output error) when reading the primary copy of feature header on object sdb.
Engine: Error code 5 (Input/output error) when reading the secondary copy of feature header on object sdb.



zeus-2:/etc# sed 's,^[ \t]*,,g;s,^#.*,,g' /etc/evms.conf | grep '[a-z{}*]'
engine {
mode            = readwrite
debug_level     = default
log_file        = /var/log/evms-engine.log
metadata_backup_dir     = /var/evms/metadata_backups
}
daemon {
debug_level     = default       # Same settings as available for
log_file        = /var/log/evms-daemon.log
}
clustering {
membership_timeout = 10
}
activate {
include = [ * ]
exclude = [ ]
}
legacy_devices {
scan = /dev
directories = [ ide scsi dasd ]
include = [ hd? sd? dasd? disc ]
exclude = [ ]
}
sysfs_devices {
include = [ * ]
exclude = [ ]
}
csm {
}
multipath {
}
lvm2 {
device_size_prompt = yes
}



After excluding sd* evms doesn't find any volumes at all.
I'll send you the logs in a few minutes.

Thanks a lot!

Bernd

--
Darmstadt University of Technology
Germany
