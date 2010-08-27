From: "Stamper, Brian P. (ARC-D)[Logyx LLC]" <brian.p.stamper@nasa.gov>
Subject: oblem with lvm and multipath on fedora 13
Date: Fri, 27 Aug 2010 13:03:49 -0500
Message-ID: <C89D4C15.1070A%brian.p.stamper@nasa.gov>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

Last night I upgraded a box from Fedora 11 to Fedora 13, which upgraded
multipath from 4.8-10 to 4.9-14.  After the upgrade, multipath is failing to
create maps for some of my volumes.  The volumes are coming from a 3par
system, which is directly attached to Qlogic HBAs.

The volumes I'm having problems with contain vgs and lvms.  They're also
snapshot volumes.  I have a base volume (non-snapshot) that contains a vg
that is working fine.  I would not expect that these volumes being snapshots
would be significant, but it's the only common thread I've found so far.

It seems almost like a timing issue, where lvm is grabbing the disks before
multipath has a chance to create the maps.  What I can't figure is why it
only affects these volumes.  Looking through /var/log/messages from startup,
I am seeing some "unknown partition type" messages that do seem to
correspond to the volumes that dracut is reporting as duplicate PVs, so I'll
investigate that.

Help would be much appreciated.

-Brian

Here's the error I'm seeing (snip from multipath -v4):

Aug 27 10:52:06 | sdm: ownership set to op-tst-fsdata03-rw-04Jun2010
Aug 27 10:52:06 | sdm: not found in pathvec
Aug 27 10:52:06 | sdm: mask = 0xc
Aug 27 10:52:06 | sdm: get_state
Aug 27 10:52:06 | sdm: path checker = tur (controller setting)
Aug 27 10:52:06 | sdm: checker timeout = 300000 ms (internal default)
Aug 27 10:52:06 | sdm: state = running
Aug 27 10:52:06 | sdm: state = 3
Aug 27 10:52:06 | sdm: prio = const (controller setting)
Aug 27 10:52:06 | sdm: const prio = 1
Aug 27 10:52:06 | sdaa: ownership set to op-tst-fsdata03-rw-04Jun2010
Aug 27 10:52:06 | sdaa: not found in pathvec
Aug 27 10:52:06 | sdaa: mask = 0xc
Aug 27 10:52:06 | sdaa: get_state
Aug 27 10:52:06 | sdaa: path checker = tur (controller setting)
Aug 27 10:52:06 | sdaa: checker timeout = 300000 ms (internal default)
Aug 27 10:52:06 | sdaa: state = running
Aug 27 10:52:06 | sdaa: state = 3
Aug 27 10:52:06 | sdaa: prio = const (controller setting)
Aug 27 10:52:06 | sdaa: const prio = 1
Aug 27 10:52:06 | op-tst-fsdata03-rw-04Jun2010: verified path sdm dev_t
8:192
Aug 27 10:52:06 | op-tst-fsdata03-rw-04Jun2010: verified path sdaa dev_t
65:160
Aug 27 10:52:06 | op-tst-fsdata03-rw-04Jun2010: pgfailback = 15 (controller
setting)
Aug 27 10:52:06 | op-tst-fsdata03-rw-04Jun2010: pgpolicy = multibus
(controller setting)
Aug 27 10:52:06 | op-tst-fsdata03-rw-04Jun2010: selector = round-robin 0
(controller setting)
Aug 27 10:52:06 | op-tst-fsdata03-rw-04Jun2010: features = 0 (controller
setting)
Aug 27 10:52:06 | op-tst-fsdata03-rw-04Jun2010: hwhandler = 0 (controller
setting)
Aug 27 10:52:06 | op-tst-fsdata03-rw-04Jun2010: rr_weight = 2 (controller
setting)
Aug 27 10:52:06 | op-tst-fsdata03-rw-04Jun2010: minio = 1000 (controller
setting)
Aug 27 10:52:06 | op-tst-fsdata03-rw-04Jun2010: no_path_retry = -2
(controller setting)
Aug 27 10:52:06 | pg_timeout = NONE (internal default)
Aug 27 10:52:06 | op-tst-fsdata03-rw-04Jun2010: set ACT_CREATE (map does not
exist)
Aug 27 10:52:06 | libdevmapper: ioctl/libdm-iface.c(1772): device-mapper:
reload ioctl failed: Device or resource busy
Aug 27 10:52:06 | libdevmapper: libdm-common.c(1056): semid 294912: semop
failed for cookie 0xd4d3598: incorrect semaphore state
Aug 27 10:52:06 | libdevmapper: libdm-common.c(1230): Could not signal
waiting process using notification semaphore identified by cookie value
223163800 (0xd4d3598)
Aug 27 10:52:06 | libdevmapper: ioctl/libdm-iface.c(1772): device-mapper:
reload ioctl failed: Device or resource busy
Aug 27 10:52:06 | op-tst-fsdata03-rw-04Jun2010: domap (0) failure for
create/reload map
Aug 27 10:52:06 | op-tst-fsdata03-rw-04Jun2010: remove multipath map
Aug 27 10:52:06 | sdm: orphaned
Aug 27 10:52:06 | sdaa: orphaned

---------------------
 
[root@testfs ~]# dmsetup table
testfsdata01: 0 4194304000 multipath 1 queue_if_no_path 0 1 1 round-robin 0
2 1 8:32 1000 65:0 1000
opfsdata01--vg-opfsdata01--lv: 0 4292853760 linear 8:161 384
opfsdata01--vg-opfsdata01--lv: 4292853760 4292853760 linear 8:177 384
opfsdata01--vg-opfsdata01--lv: 8585707520 4292853760 linear 8:193 384
opfsdata01--vg-opfsdata01--lv: 12878561280 4292853760 linear 8:209 384
testNFS-testNFS: 0 4194295808 linear 8:48 384
testNFS-testNFS: 4194295808 4180893696 linear 8:64 384
filestoreVG-filestore: 0 4187594752 linear 8:32 384
vg_testfs-LogVol02: 0 32768000 linear 8:2 551649664
vg_testfs-LogVol01: 0 32768000 linear 8:2 518881664
testsnapfslog01p1: 0 419424957 linear 253:11 63
testsnapfslog02: 0 419430400 multipath 1 queue_if_no_path 0 1 1 round-robin
0 2 1 8:224 1000 65:192 1000
testsnapfslog02p1: 0 419424957 linear 253:12 63
testfslog01: 0 419430400 multipath 1 queue_if_no_path 0 1 1 round-robin 0 2
1 8:16 1000 8:240 1000
testsnapfslog01: 0 419430400 multipath 1 queue_if_no_path 0 1 1 round-robin
0 2 1 8:144 1000 65:112 1000
vg_testfs-lv_root: 0 518881280 linear 8:2 384
testfslog01p1: 0 419424957 linear 253:7 63
testnfs02: 0 4194304000 multipath 1 queue_if_no_path 0 1 1 round-robin 0 2 1
8:64 1000 65:32 1000
testnfs01: 0 4194304000 multipath 1 queue_if_no_path 0 1 1 round-robin 0 2 1
8:48 1000 65:16 1000
spqfsdata01--vg-spqfsdata01--lv: 0 4292853760 linear 8:81 384
spqfsdata01--vg-spqfsdata01--lv: 4292853760 4292853760 linear 8:97 384
spqfsdata01--vg-spqfsdata01--lv: 8585707520 4292853760 linear 8:113 384
spqfsdata01--vg-spqfsdata01--lv: 12878561280 4292853760 linear 8:129 384

---------------------

[root@testfs ~]# cat /etc/multipath.conf
defaults {
        user_friendly_names yes
}
devnode_blacklist {
        wwid 36001e4f02bc746000f60789e05a38474
        devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
        devnode "^hd[a-z]"
        devnode "^cciss!c[0-9]d[0-9]*"
}
multipaths {
        multipath {
                wwid                    350002ac000e505d8
                alias                   testfsdata01
        }
        multipath {
                wwid                    350002ac000e605d8
                alias                   testfslog01
        }
        multipath {
                wwid                    350002ac000e905d8
                alias                   testnfs01
        }
        multipath {
                wwid                    350002ac000ea05d8
                alias                   testnfs02
        }
        multipath {
                wwid                    350002ac0010905d8
                alias                   testsnapfslog01
        }
        multipath {
                wwid                    350002ac001ca05d8
                alias                   testsnapfslog02
        }
        multipath {
                wwid                    350002ac0022005d8
                alias                   spq-test-fsdata01-rw-27May2010
        }
        multipath {
                wwid                    350002ac0022105d8
                alias                   spq-test-fsdata02-rw-27May2010
        }
        multipath {
                wwid                    350002ac0022205d8
                alias                   spq-test-fsdata03-rw-27May2010
        }
        multipath {
                wwid                    350002ac0022305d8
                alias                   spq-test-fsdata04-rw-27May2010
        }
##
        multipath {
                wwid                    350002ac0021b05d8
                alias                   op-tst-fsdata01-rw-04Jun2010
        }
        multipath {
                wwid                    350002ac0021c05d8
                alias                   op-tst-fsdata02-rw-04Jun2010
        }
        multipath {
                wwid                    350002ac0021d05d8
                alias                   op-tst-fsdata03-rw-04Jun2010
        }
        multipath {
                wwid                    350002ac0021e05d8
                alias                   op-tst-fsdata04-rw-04Jun2010
        }
}
devices {
        device {
                vendor                  "3PARdata"
                product                 "VV"
                path_grouping_policy    multibus
                getuid_callout          "/lib/udev/scsi_id -g -u -d /dev/%n"
                path_checker            tur
                path_selector           "round-robin 0"
                hardware_handler        "0"
                failback                15
                rr_weight               priorities
                no_path_retry           queue
        }
}

---------------------

[root@testfs ~]# vgdisplay
  Found duplicate PV 3MgaHrPuGsYc41hT5ZbZlFUH8hjdAwoa: using /dev/sdf1 not
/dev/sdt1
  Found duplicate PV Nh6BDQVuD8w3hE2QwieNUEuQl6iooRBm: using /dev/sdg1 not
/dev/sdu1
  Found duplicate PV LG96GxjwLwc7U5gqAo7VZY5s1mEm51l6: using /dev/sdh1 not
/dev/sdv1
  Found duplicate PV twn6Tb5qNVY3WZxvWI4zZeN3jiKLj0oX: using /dev/sdi1 not
/dev/sdw1
  Found duplicate PV MMRd81t77dzriGiRUHVB13kfMNlMZczT: using /dev/sdk1 not
/dev/sdy1
  Found duplicate PV GS2aK5UfeTWYzNAJtJ6CRdZ6GC5gP1Eb: using /dev/sdl1 not
/dev/sdz1
  Found duplicate PV 5cOmDeoW4SIAPnz2ADC1MjRx0jd2xkeA: using /dev/sdm1 not
/dev/sdaa1
  Found duplicate PV IqnCrwAB334KIQ2WnmgDDEz3B6f2VTiR: using /dev/sdn1 not
/dev/sdab1
  --- Volume group ---
  VG Name               opfsdata01-vg
  System ID        
  Format                lvm2
  Metadata Areas        4
  Metadata Sequence No  2
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                1
  Open LV               1
  Max PV                0
  Cur PV                4
  Act PV                4
  VG Size               8.00 TiB
  PE Size               4.00 MiB
  Total PE              2096120
  Alloc PE / Size       2096120 / 8.00 TiB
  Free  PE / Size       0 / 0
  VG UUID               FeSlsp-mVzr-Xo6B-RIc5-72cv-xJLY-XRzndA
   
  --- Volume group ---
  VG Name               spqfsdata01-vg
  System ID        
  Format                lvm2
  Metadata Areas        4
  Metadata Sequence No  9
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                1
  Open LV               1
  Max PV                0
  Cur PV                4
  Act PV                4
  VG Size               8.00 TiB
  PE Size               4.00 MiB
  Total PE              2096120
  Alloc PE / Size       2096120 / 8.00 TiB
  Free  PE / Size       0 / 0
  VG UUID               cpKgCE-wdlC-ee4V-n5gd-ysGj-bJKq-c0Uk5g
   
  --- Volume group ---
  VG Name               testNFS
  System ID        
  Format                lvm2
  Metadata Areas        2
  Metadata Sequence No  2
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                1
  Open LV               1
  Max PV                0
  Cur PV                2
  Act PV                2
  VG Size               3.91 TiB
  PE Size               4.00 MiB
  Total PE              1023998
  Alloc PE / Size       1022362 / 3.90 TiB
  Free  PE / Size       1636 / 6.39 GiB
  VG UUID               WvSi5z-IpGB-h3tE-NzSy-Bou6-6mcK-ew3RaK
   
  --- Volume group ---
  VG Name               filestoreVG
  System ID        
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  3
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                1
  Open LV               1
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               1.95 TiB
  PE Size               4.00 MiB
  Total PE              511999
  Alloc PE / Size       511181 / 1.95 TiB
  Free  PE / Size       818 / 3.20 GiB
  VG UUID               dLvVeo-yuIk-xBFN-PAOV-PhVr-LXUk-mTR0CZ
   
  --- Volume group ---
  VG Name               vg_testfs
  System ID        
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  4
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                3
  Open LV               3
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               278.67 GiB
  PE Size               4.00 MiB
  Total PE              71340
  Alloc PE / Size       71340 / 278.67 GiB
  Free  PE / Size       0 / 0
  VG UUID               I8OmYL-lcr6-M01j-cker-Toga-6cG5-GHT02c
