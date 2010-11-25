From: Artur Piechocki <artur.piechocki@open-e.com>
Subject: Problem with creating LV - device too small for target
Date: Thu, 25 Nov 2010 19:51:13 +0100
Message-ID: <4CEEB021.3080004@open-e.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hello

We have experienced problem with creating very big LV. During creating 
we get:

device-mapper: reload ioctl failed: Invalid argument
Failed to activate new LV.

and in dmesg:

device-mapper: table: device 8:16 too small for target
device-mapper: table: 253:25: linear: dm-linear: Device lookup failed
device-mapper: ioctl: error adding target to table

Our structure looks:

  LV                                          VG      Attr   LSize 
Origin Snap%  Move Log Copy%  Convert
   config                                      vg+vg00 -wi-ao  32.00M
   lv0000                                     vg+vg00 -wi-ao   3.91T
   lv0001                                     vg+vg00 -wi-ao   3.91T
   lv0002                                     vg+vg00 -wi-ao   3.91T
   lv0003                                     vg+vg00 -wi-ao   3.91T
   lvr1                                         vg+vg00 -wi-ao 128.00M
   lvr2                                         vg+vg00 -wi-ao 128.00M
   lvr3                                         vg+vg00 -wi-ao 128.00M
   lvr4                                        vg+vg00 -wi-ao 128.00M
   system+1256483170812375821 vg+vg00 -wi-ao   1.00G


vgdisplay :   --- Volume group ---
   VG Name               vg+vg00
   System ID
   Format                lvm2
   Metadata Areas        1
   Metadata Sequence No  322
   VG Access             read/write
   VG Status             resizable
   MAX LV                0
   Cur LV                10
   Open LV               10
   Max PV                0
   Cur PV                1
   Act PV                1
   VG Size               19.09 TB
   PE Size               32.00 MB
   Total PE              625630
   Alloc PE / Size       512049 / 15.63 TB
   Free  PE / Size       113581 / 3.47 TB
   VG UUID               rwewoQ-ibp8-PTDi-2B3v-nlj8-i8jE-sSmR27

So it looks like we should have 113581 PE free but during creating LV:

lvcreate -l 112000 vg+vg00 -n lv0004

we get Invalid argument.

Verbose shows that lvcreate tries to reserve a few free segment but 
without success:

#label/label.c:270         Using cached label for /dev/sdb
#label/label.c:270         Using cached label for /dev/sdb
#format_text/format-text.c:525         Read vg+vg00 metadata (386) from 
/dev/sdb at 111104 size 3380
#metadata/pv_manip.c:296         /dev/sdb 0:      0      1: config(0:0)
#metadata/pv_manip.c:296         /dev/sdb 1:      1     32: 
system+1256483170812375821(0:0)
#metadata/pv_manip.c:296         /dev/sdb 2:     33    128: NULL(0:0)
#metadata/pv_manip.c:296         /dev/sdb 3:    161 128000: lv0000(0:0)
#metadata/pv_manip.c:296         /dev/sdb 4: 128161      4: NULL(0:0)
#metadata/pv_manip.c:296         /dev/sdb 5: 128165 128000: lv0001(0:0)
#metadata/pv_manip.c:296         /dev/sdb 6: 256165   3200: NULL(0:0)
#metadata/pv_manip.c:296         /dev/sdb 7: 259365      4: lvr4(0:0)
#metadata/pv_manip.c:296         /dev/sdb 8: 259369      4: lvr2(0:0)
#metadata/pv_manip.c:296         /dev/sdb 9: 259373 128000: lv0002(0:0)
#metadata/pv_manip.c:296         /dev/sdb 10: 387373      4: lvr3(0:0)
#metadata/pv_manip.c:296         /dev/sdb 11: 387377 128000: lv0003(0:0)
#metadata/pv_manip.c:296         /dev/sdb 12: 515377      4: lvr1(0:0)
#metadata/pv_manip.c:296         /dev/sdb 13: 515381 110249: NULL(0:0)
#metadata/lv_manip.c:2052     Creating logical volume lv0004
#metadata/pv_map.c:55         Allowing allocation on /dev/sdb start PE 
33 length 128
#metadata/pv_map.c:55         Allowing allocation on /dev/sdb start PE 
128161 length 4
#metadata/pv_map.c:55         Allowing allocation on /dev/sdb start PE 
256165 length 3200
#metadata/pv_map.c:55         Allowing allocation on /dev/sdb start PE 
515381 length 110249
#metadata/lv_manip.c:1375         Trying allocation using contiguous 
policy.  Need 112000 extents for 1 parallel areas and 0 log areas of 0 
extents. (Total 112000 extents.)
#metadata/lv_manip.c:1239         Trying allocation area 0 on /dev/sdb 
start PE 515381 length 110249 leaving 0.
#metadata/lv_manip.c:804         Allocating parallel area 0 on /dev/sdb 
start PE 515381 length 110249.
#metadata/lv_manip.c:1375         Trying allocation using cling policy. 
  Need 1751 extents for 1 parallel areas and 0 log areas of 0 extents. 
(Total 1751 extents.)
#metadata/lv_manip.c:1239         Trying allocation area 0 on /dev/sdb 
start PE 256165 length 1751 leaving 1449.
#metadata/lv_manip.c:804         Allocating parallel area 0 on /dev/sdb 
start PE 256165 length 1751.
#metadata/pv_manip.c:296         /dev/sdb 0:      0      1: config(0:0)
#metadata/pv_manip.c:296         /dev/sdb 1:      1     32: 
system+1256483170812375821(0:0)
#metadata/pv_manip.c:296         /dev/sdb 2:     33    128: NULL(0:0)
#metadata/pv_manip.c:296         /dev/sdb 3:    161 128000: lv0000(0:0)
#metadata/pv_manip.c:296         /dev/sdb 4: 128161      4: NULL(0:0)
#metadata/pv_manip.c:296         /dev/sdb 5: 128165 128000: lv0001(0:0)
#metadata/pv_manip.c:296         /dev/sdb 6: 256165   1751: lv0004(110249:0)
#metadata/pv_manip.c:296         /dev/sdb 7: 257916   1449: NULL(0:0)
#metadata/pv_manip.c:296         /dev/sdb 8: 259365      4: lvr4(0:0)
#metadata/pv_manip.c:296         /dev/sdb 9: 259369      4: lvr2(0:0)
#metadata/pv_manip.c:296         /dev/sdb 10: 259373 128000: lv0002(0:0)
#metadata/pv_manip.c:296         /dev/sdb 11: 387373      4: lvr3(0:0)
#metadata/pv_manip.c:296         /dev/sdb 12: 387377 128000: lv0003(0:0)
#metadata/pv_manip.c:296         /dev/sdb 13: 515377      4: lvr1(0:0)
#metadata/pv_manip.c:296         /dev/sdb 14: 515381 110249: lv0004(0:0)
#format_text/format-text.c:632         Writing vg+vg00 metadata to 
/dev/sdb at 114688 len 3790
#format_text/format-text.c:737         Pre-Committing vg+vg00 metadata 
(387) to /dev/sdb header at 4096
#format_text/format-text.c:737         Committing vg+vg00 metadata (387) 
to /dev/sdb header at 4096
#format_text/archiver.c:395     Creating volume group backup 
"/etc/lvm/backup/vg+vg00" (seqno 387).
#format_text/format-text.c:932         Writing vg+vg00 metadata to 
/etc/lvm/backup/.lvm_90145678_20338_1209151577
#format_text/format-text.c:976         Committing vg+vg00 metadata (387)
#format_text/format-text.c:977         Renaming 
/etc/lvm/backup/vg+vg00.tmp to /etc/lvm/backup/vg+vg00
#locking/file_locking.c:292       Locking LV 
rwewoQibp8PTDi2B3vnlj8i8jEsSmR27RzcM9OgP24qjK6nvxG2WLcAtjhhYRRyh (R)
#metadata/metadata.c:3156       Finding volume group for uuid 
rwewoQibp8PTDi2B3vnlj8i8jEsSmR27RzcM9OgP24qjK6nvxG2WLcAtjhhYRRyh
#label/label.c:160       /dev/sdb: lvm2 label detected
#cache/lvmcache.c:1135         lvmcache: /dev/sdb: now in VG 
#orphans_lvm2 (#orphans_lvm2) with 1 mdas
#format_text/format-text.c:1182         /dev/sdb: Found metadata at 
114688 size 3790 (in area at 4096 size 192512) for vg+vg00 
(rwewoQ-ibp8-PTDi-2B3v-nlj8-i8jE-sSmR27)
#cache/lvmcache.c:1135         lvmcache: /dev/sdb: now in VG vg+vg00 
with 1 mdas
#cache/lvmcache.c:923         lvmcache: /dev/sdb: setting vg+vg00 VGID 
to rwewoQibp8PTDi2B3vnlj8i8jEsSmR27
#cache/lvmcache.c:1172         lvmcache: /dev/sdb: VG vg+vg00: Set 
creation host to 90145678.
#label/label.c:270         Using cached label for /dev/sdb
#format_text/format-text.c:525         Read vg+vg00 metadata (387) from 
/dev/sdb at 114688 size 3790
#metadata/metadata.c:3162     Found volume group "vg+vg00"
#activate/activate.c:271     activation/volume_list configuration 
setting not defined, checking only host tags for vg+vg00/lv0004
#activate/dev_manager.c:274         Getting device info for 
vg+vg00-lv0004 
[LVM-rwewoQibp8PTDi2B3vnlj8i8jEsSmR27RzcM9OgP24qjK6nvxG2WLcAtjhhYRRyh]
#ioctl/libdm-iface.c:1960         dm info 
LVM-rwewoQibp8PTDi2B3vnlj8i8jEsSmR27RzcM9OgP24qjK6nvxG2WLcAtjhhYRRyh NF 
   [16384]
#ioctl/libdm-iface.c:1960         dm info 
rwewoQibp8PTDi2B3vnlj8i8jEsSmR27RzcM9OgP24qjK6nvxG2WLcAtjhhYRRyh NF [16384]
#device/dev-io.c:299       /dev/sdb: read_ahead is 256 sectors
#mm/memlock.c:296       Locking memory
#mm/memlock.c:178         mlock        724KiB      8048000 - 80fd000 
r-xp 00000000 00:0e 51601854 /tmp/LVM/sbin/lvm
#mm/memlock.c:178         mlock         28KiB      80fd000 - 8104000 
rw-p 000b4000 00:0e 51601854 /tmp/LVM/sbin/lvm
#mm/memlock.c:178         mlock         32KiB      8104000 - 810c000 
rw-p 08104000 00:00 0
#mm/memlock.c:178         mlock      10528KiB      8f41000 - 9989000 
rw-p 08f41000 00:00 0                                  [heap]
#mm/memlock.c:178         mlock          4KiB     f75c3000 - f75c4000 
rw-p f75c3000 00:00 0
#mm/memlock.c:178         mlock       1184KiB     f75c4000 - f76ec000 
r-xp 00000000 00:0d 40 /lib/tls/libc-2.3.6.so
#mm/memlock.c:178         mlock         20KiB     f76ec000 - f76f1000 
r--p 00128000 00:0d 40 /lib/tls/libc-2.3.6.so
#mm/memlock.c:178         mlock          8KiB     f76f1000 - f76f3000 
rw-p 0012d000 00:0d 40 /lib/tls/libc-2.3.6.so
#mm/memlock.c:178         mlock         12KiB     f76f3000 - f76f6000 
rw-p f76f3000 00:00 0
#mm/memlock.c:178         mlock        140KiB     f76f6000 - f7719000 
r-xp 00000000 00:0d 153 /lib/tls/libm-2.3.6.so
#mm/memlock.c:178         mlock          8KiB     f7719000 - f771b000 
rw-p 00022000 00:0d 153 /lib/tls/libm-2.3.6.so
#mm/memlock.c:178         mlock        128KiB     f771b000 - f773b000 
r-xp 00000000 00:0e 51601742 /tmp/LVM/lib/libdevmapper.so.1.02
#mm/memlock.c:178         mlock          8KiB     f773b000 - f773d000 
rw-p 00020000 00:0e 51601742 /tmp/LVM/lib/libdevmapper.so.1.02
#mm/memlock.c:178         mlock          4KiB     f773d000 - f773e000 
rw-p f773d000 00:00 0
#mm/memlock.c:160         mlock default filter '/libdl-' matches 
'f773e000-f7740000 r-xp 00000000 00:0d 42   /lib/tls/libdl-2.3.6.so': 
Skipping.
#mm/memlock.c:160         mlock default filter '/libdl-' matches 
'f7740000-f7742000 rw-p 00001000 00:0d 42   /lib/tls/libdl-2.3.6.so': 
Skipping.
#mm/memlock.c:178         mlock          8KiB     f774a000 - f774c000 
rw-p f774a000 00:00 0
#mm/memlock.c:178         mlock         84KiB     f774c000 - f7761000 
r-xp 00000000 00:0d 34 /lib/ld-2.3.6.so
#mm/memlock.c:178         mlock          8KiB     f7761000 - f7763000 
rw-p 00014000 00:0d 34 /lib/ld-2.3.6.so
#mm/memlock.c:178         mlock        280KiB     ffb97000 - ffbdd000 
rw-p 7ffffffb9000 00:00 0                              [stack]
#mm/memlock.c:150         mlock ignore filter '[vdso]' matches 
'ffffe000-fffff000 r-xp ffffe000 00:00 0   [vdso]': Skipping.
#mm/memlock.c:263         Locked 13524992 bytes
#mm/memlock.c:350         memlock_count inc to 1
#activate/dev_manager.c:929         Getting device info for 
vg+vg00-lv0004 
[LVM-rwewoQibp8PTDi2B3vnlj8i8jEsSmR27RzcM9OgP24qjK6nvxG2WLcAtjhhYRRyh]
#ioctl/libdm-iface.c:1960         dm info 
LVM-rwewoQibp8PTDi2B3vnlj8i8jEsSmR27RzcM9OgP24qjK6nvxG2WLcAtjhhYRRyh OF 
   [16384]
#ioctl/libdm-iface.c:1960         dm info 
rwewoQibp8PTDi2B3vnlj8i8jEsSmR27RzcM9OgP24qjK6nvxG2WLcAtjhhYRRyh OF [16384]
#activate/dev_manager.c:929         Getting device info for 
vg+vg00-lv0004-real 
[LVM-rwewoQibp8PTDi2B3vnlj8i8jEsSmR27RzcM9OgP24qjK6nvxG2WLcAtjhhYRRyh-real]
#ioctl/libdm-iface.c:1960         dm info 
LVM-rwewoQibp8PTDi2B3vnlj8i8jEsSmR27RzcM9OgP24qjK6nvxG2WLcAtjhhYRRyh-real OF 
   [16384]
#ioctl/libdm-iface.c:1960         dm info 
rwewoQibp8PTDi2B3vnlj8i8jEsSmR27RzcM9OgP24qjK6nvxG2WLcAtjhhYRRyh-real OF 
   [16384]
#activate/dev_manager.c:929         Getting device info for 
vg+vg00-lv0004-cow 
[LVM-rwewoQibp8PTDi2B3vnlj8i8jEsSmR27RzcM9OgP24qjK6nvxG2WLcAtjhhYRRyh-cow]
#ioctl/libdm-iface.c:1960         dm info 
LVM-rwewoQibp8PTDi2B3vnlj8i8jEsSmR27RzcM9OgP24qjK6nvxG2WLcAtjhhYRRyh-cow 
OF   [16384]
#ioctl/libdm-iface.c:1960         dm info 
rwewoQibp8PTDi2B3vnlj8i8jEsSmR27RzcM9OgP24qjK6nvxG2WLcAtjhhYRRyh-cow OF 
   [16384]
#activate/dev_manager.c:1380         Checking kernel supports striped 
segment type for lv0004
#activate/dev_manager.c:1380         Checking kernel supports striped 
segment type for lv0004
#metadata/metadata.c:2151         Calculated readahead of LV lv0004 is 256
#libdm-deptree.c:1367     Creating vg+vg00-lv0004
#ioctl/libdm-iface.c:1960         dm create vg+vg00-lv0004 
LVM-rwewoQibp8PTDi2B3vnlj8i8jEsSmR27RzcM9OgP24qjK6nvxG2WLcAtjhhYRRyh NF 
   [16384]
#libdm-common.c:783         vg+vg00-lv0004: Stacking NODE_ADD (253,25) 
0:0 0600
#libdm-deptree.c:1793     Loading vg+vg00-lv0004 table (253:25)
#libdm-deptree.c:1739         Adding target to (253:25): 0 7225278464 
linear 8:16 33776009600
#libdm-deptree.c:1739         Adding target to (253:25): 7225278464 
114753536 linear 8:16 16788029824
#ioctl/libdm-iface.c:1960         dm table   (253:25) OF   [16384]
#ioctl/libdm-iface.c:1960         dm reload   (253:25) NF   [16384]
#ioctl/libdm-iface.c:1977   device-mapper: reload ioctl failed: Invalid 
argument
#libdm-deptree.c:1879 <backtrace>
#activate/dev_manager.c:1724 <backtrace>
#activate/dev_manager.c:1760 <backtrace>
#activate/activate.c:616 <backtrace>
#activate/activate.c:1311 <backtrace>
#mm/memlock.c:313       Unlocking memory
#mm/memlock.c:178         munlock        724KiB      8048000 - 80fd000 
r-xp 00000000 00:0e 51601854 /tmp/LVM/sbin/lvm
#mm/memlock.c:178         munlock         28KiB      80fd000 - 8104000 
rw-p 000b4000 00:0e 51601854 /tmp/LVM/sbin/lvm
#mm/memlock.c:178         munlock         32KiB      8104000 - 810c000 
rw-p 08104000 00:00 0
#mm/memlock.c:178         munlock      10528KiB      8f41000 - 9989000 
rw-p 08f41000 00:00 0                                  [heap]
#mm/memlock.c:178         munlock          4KiB     f75c3000 - f75c4000 
rw-p f75c3000 00:00 0
#mm/memlock.c:178         munlock       1184KiB     f75c4000 - f76ec000 
r-xp 00000000 00:0d 40 /lib/tls/libc-2.3.6.so
#mm/memlock.c:178         munlock         20KiB     f76ec000 - f76f1000 
r--p 00128000 00:0d 40 /lib/tls/libc-2.3.6.so
#mm/memlock.c:178         munlock          8KiB     f76f1000 - f76f3000 
rw-p 0012d000 00:0d 40 /lib/tls/libc-2.3.6.so
#mm/memlock.c:178         munlock         12KiB     f76f3000 - f76f6000 
rw-p f76f3000 00:00 0
#mm/memlock.c:178         munlock        140KiB     f76f6000 - f7719000 
r-xp 00000000 00:0d 153 /lib/tls/libm-2.3.6.so
#mm/memlock.c:178         munlock          8KiB     f7719000 - f771b000 
rw-p 00022000 00:0d 153 /lib/tls/libm-2.3.6.so
#mm/memlock.c:178         munlock        128KiB     f771b000 - f773b000 
r-xp 00000000 00:0e 51601742 /tmp/LVM/lib/libdevmapper.so.1.02
#mm/memlock.c:178         munlock          8KiB     f773b000 - f773d000 
rw-p 00020000 00:0e 51601742 /tmp/LVM/lib/libdevmapper.so.1.02
#mm/memlock.c:178         munlock          4KiB     f773d000 - f773e000 
rw-p f773d000 00:00 0
#mm/memlock.c:160         mlock default filter '/libdl-' matches 
'f773e000-f7740000 r-xp 00000000 00:0d 42   /lib/tls/libdl-2.3.6.so': 
Skipping.
#mm/memlock.c:160         mlock default filter '/libdl-' matches 
'f7740000-f7742000 rw-p 00001000 00:0d 42   /lib/tls/libdl-2.3.6.so': 
Skipping.
#mm/memlock.c:178         munlock          8KiB     f774a000 - f774c000 
rw-p f774a000 00:00 0
#mm/memlock.c:178         munlock         84KiB     f774c000 - f7761000 
r-xp 00000000 00:0d 34 /lib/ld-2.3.6.so
#mm/memlock.c:178         munlock          8KiB     f7761000 - f7763000 
rw-p 00014000 00:0d 34 /lib/ld-2.3.6.so
#mm/memlock.c:178         munlock        280KiB     ffb97000 - ffbdd000 
rw-p 7ffffffb9000 00:00 0                              [stack]
#mm/memlock.c:150         mlock ignore filter '[vdso]' matches 
'ffffe000-fffff000 r-xp ffffe000 00:00 0   [vdso]': Skipping.
#mm/memlock.c:263         Unlocked 13524992 bytes
#mm/memlock.c:359         memlock_count dec to 0
#libdm-common.c:460         Created /dev/mapper/vg+vg00-lv0004
#activate/activate.c:1340 <backtrace>
#locking/locking.c:397 <backtrace>
#metadata/lv_manip.c:3243   Failed to activate new LV.

Kernel 2.6.27.39 and LVM:

   LVM version:     2.02.33 (2008-01-31)
   Library version: 1.02.24 (2007-12-20)
   Driver version:  4.14.0

We have tried to use the newest version of LVM

   LVM version:     2.02.76(2) (2010-11-08)
   Library version: 1.02.24 (2007-12-20)
   Driver version:  4.14.0


but effect was the same.

Maybe you know where the problem is? We are not able to change the 
kernel version.

Thanks in advance.
