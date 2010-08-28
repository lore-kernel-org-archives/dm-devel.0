From: "Stamper, Brian P. (ARC-D)[Logyx LLC]" <brian.p.stamper@nasa.gov>
Subject: Re: oblem with lvm and multipath on fedora 13
Date: Sat, 28 Aug 2010 16:48:01 -0500
Message-ID: <12DC34690DFFAC4FACD7A7255FC5E14A131BCDE0DB@NDJSSCC07.ndc.nasa.gov>
References: <20100827182634.GB31618@us.ibm.com>
	<C89D80D7.10732%brian.p.stamper@nasa.gov>,
	<20100828174751.GA31397@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100828174751.GA31397@us.ibm.com>
Content-Language: en-US
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

________________________________________
From: dm-devel-bounces@redhat.com [dm-devel-bounces@redhat.com] On Behalf Of Malahal Naineni [malahal@us.ibm.com]
Sent: Saturday, August 28, 2010 10:47 AM
To: dm-devel@redhat.com
Subject: Re: [dm-devel] oblem with lvm and multipath on fedora 13

>The entries in /dev/mapper should work. If they don't work, other
>entries don't work either. Based on the above information, can I assume
>that you were able to mount such logical volumes without multipath (this
>is very unusual, if true)?

Yes.

>Inactivate affected VGs, run "multipath -F"
>to delete multipath maps, and then activate your VGs. You should now be
>where you were before and see if you can mount logical volumes that were
>failing before (I doubt if they work though).

Yes, this worked, if I remove the multipath devices and do a vgscan, I'm back to where I was before deactivating and can once again mount the volumes.

I've included a typescript of the session below this, perhaps you can find steps I'm missing.  But it sounds as though you're surprised by the behavior.

>RedHat mkinitrd scripts go to great lengths to not include multipath in
>initrd unless you are currently using your 'root' on multipath! Most
>likely it didn't include multipath. You can expand the initrd (it is a
>compressed cpio archive, 'zcat initrd.img | cpio -icd' should extract
>all the files) and see if multipath is included (look for multipath
>in the extracted files). I would suggest you work on your first problem
>(not able to mount stuff).
>
>Thanks, Malahal.

[root@testfs boot]# mkdir foo
[root@testfs boot]# cd foo
[root@testfs foo]# zcat ../initramfs-with-multipath.img | cpio -icd
26392 blocks
[root@testfs foo]# ls
bin                emergency  initqueue-finished  mount        proc     tmp
cmdline            etc        initqueue-settled   pre-pivot    sbin     usr
dev                init       lib                 pre-trigger  sys      var
dracut-005-3.fc13  initqueue  lib64               pre-udev     sysroot
[root@testfs foo]# find . -print | grep -i multi
./lib/modules/2.6.33.8-149.fc13.x86_64/kernel/drivers/md/dm-multipath.ko

-----------------------------------

Typescript of unmount, deactivate, multipath, activate, vgscan, try to mount, deactivate, multipath -F, vgscan, reactivate, mount:

Script started on Sat 28 Aug 2010 02:18:22 PM PDT
[root@testfs ~]# multipath -ll
testfsdata01 (350002ac000e505d8) dm-8 3PARdata,VV
size=2.0T features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=2 status=active
  |- 3:0:0:1  sdc  8:32   active ready running
  `- 4:0:0:1  sdq  65:0   active ready running
testsnapfslog02 (350002ac001ca05d8) dm-12 3PARdata,VV
size=200G features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=2 status=active
  |- 3:0:0:13 sdo  8:224  active ready running
  `- 4:0:0:13 sdac 65:192 active ready running
testfslog01 (350002ac000e605d8) dm-7 3PARdata,VV
size=200G features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=2 status=active
  |- 3:0:0:0  sdb  8:16   active ready running
  `- 4:0:0:0  sdp  8:240  active ready running
testsnapfslog01 (350002ac0010905d8) dm-11 3PARdata,VV
size=200G features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=2 status=active
  |- 3:0:0:8  sdj  8:144  active ready running
  `- 4:0:0:8  sdx  65:112 active ready running
testnfs02 (350002ac000ea05d8) dm-10 3PARdata,VV
size=2.0T features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=2 status=active
  |- 3:0:0:3  sde  8:64   active ready running
  `- 4:0:0:3  sds  65:32  active ready running
testnfs01 (350002ac000e905d8) dm-9 3PARdata,VV
size=2.0T features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=2 status=active
  |- 3:0:0:2  sdd  8:48   active ready running
  `- 4:0:0:2  sdr  65:16  active ready running
[root@testfs ~]# mount
/dev/mapper/vg_testfs-lv_root on / type ext4 (rw)
proc on /proc type proc (rw)
sysfs on /sys type sysfs (rw)
devpts on /dev/pts type devpts (rw,gid=5,mode=620)
tmpfs on /dev/shm type tmpfs (rw)
/dev/sda1 on /boot type ext3 (rw,nodev)
/dev/mapper/filestoreVG-filestore on /filestore type ext3 (rw,noatime,nodiratime)
/dev/mapper/testfslog01p1 on /filestore/fsdatadir/transactionLog type ext3 (rw,noatime,nodiratime)
/dev/mapper/testNFS-testNFS on /export type ext3 (rw)
/dev/mapper/opfsdata01--vg-opfsdata01--lv on /soc/san/filestore/snapshots/op-test-fsdata01-rw-04Jun2010 type ext3 (rw,noatime,nodiratime)
/dev/mapper/testsnapfslog02p1 on /soc/san/filestore/snapshots/op-test-fsdata01-rw-04Jun2010/fsdatadir/transactionLog type ext3 (rw,nodev,noatime,nodiratime)
/dev/mapper/spqfsdata01--vg-spqfsdata01--lv on /soc/san/filestore/snapshots/spq-test-fsdata01-rw-27May2010 type ext3 (rw,noatime,nodiratime)
/dev/mapper/testsnapfslog01p1 on /soc/san/filestore/snapshots/spq-test-fsdata01-rw-27May2010/fsdatadir/transactionLog type ext3 (rw,nodev,noatime,nodiratime)
none on /proc/sys/fs/binfmt_misc type binfmt_misc (rw)
sunrpc on /var/lib/nfs/rpc_pipefs type rpc_pipefs (rw)
nfsd on /proc/fs/nfsd type nfsd (rw)
[root@testfs ~]# blkid
/dev/sda1: UUID="675e8280-95d6-4c21-a233-c15fad937362" SEC_TYPE="ext2" TYPE="ext3"
/dev/filestoreVG/filestore: UUID="0b820e66-ea43-4a99-a4f4-d6dbba678245" SEC_TYPE="ext2" TYPE="ext3"
/dev/mapper/filestoreVG-filestore: UUID="0b820e66-ea43-4a99-a4f4-d6dbba678245" SEC_TYPE="ext2" TYPE="ext3"
/dev/mapper/testfslog01p1: UUID="e509829d-4333-4f03-8d25-3968bb6da965" SEC_TYPE="ext2" TYPE="ext3"
/dev/testNFS/testNFS: UUID="4458c5b3-edf9-41fa-8714-84f1f6a25b3f" SEC_TYPE="ext2" TYPE="ext3"
/dev/sdb1: UUID="e509829d-4333-4f03-8d25-3968bb6da965" TYPE="ext3"
/dev/mapper/vg_testfs-LogVol01: TYPE="swap" UUID="fa144978-2dae-4eee-88e7-72a70f70e104"
/dev/mapper/vg_testfs-lv_root: UUID="9db6bbe3-fa81-4889-802a-25daa9b36059" TYPE="ext4"
/dev/mapper/vg_testfs-LogVol02: TYPE="swap" UUID="cdb5fa92-8fa2-401d-ba48-c937342edf64"
/dev/mapper/testNFS-testNFS: UUID="4458c5b3-edf9-41fa-8714-84f1f6a25b3f" TYPE="ext3"
/dev/mapper/testsnapfslog01p1: UUID="986595d9-042c-4777-8d72-1607eebff422" TYPE="ext3" SEC_TYPE="ext2"
/dev/sdp1: UUID="e509829d-4333-4f03-8d25-3968bb6da965" TYPE="ext3" SEC_TYPE="ext2"
/dev/mapper/testsnapfslog02p1: UUID="1491e12d-78a5-4b1a-ad61-7b6b8232149e" TYPE="ext3" SEC_TYPE="ext2"
/dev/sdm1: UUID="5cOmDe-oW4S-IAPn-z2AD-C1Mj-Rx0j-d2xkeA" TYPE="LVM2_member"
/dev/sdn1: UUID="IqnCrw-AB33-4KIQ-2Wnm-gDDE-z3B6-f2VTiR" TYPE="LVM2_member"
/dev/sdo1: UUID="1491e12d-78a5-4b1a-ad61-7b6b8232149e" SEC_TYPE="ext2" TYPE="ext3"
/dev/sdq: UUID="2VqqWi-cWZo-Tu5T-cC40-z4CW-ZOti-aWhi5F" TYPE="LVM2_member"
/dev/sdr: UUID="JV8nOF-NxdU-WAZP-ZY9h-iXo8-HJWs-CjSjTj" TYPE="LVM2_member"
/dev/sdu1: UUID="Nh6BDQ-VuD8-w3hE-2Qwi-eNUE-uQl6-iooRBm" TYPE="LVM2_member"
/dev/sds: UUID="Crn275-rSvZ-6Bl1-LplP-c0iG-PvtZ-OVofd8" TYPE="LVM2_member"
/dev/sda2: UUID="SQ8Lg0-uiV2-xjUN-jWO0-xy9A-Ct6Y-PfRcGV" TYPE="LVM2_member"
/dev/sdc: UUID="2VqqWi-cWZo-Tu5T-cC40-z4CW-ZOti-aWhi5F" TYPE="LVM2_member"
/dev/sdd: UUID="JV8nOF-NxdU-WAZP-ZY9h-iXo8-HJWs-CjSjTj" TYPE="LVM2_member"
/dev/sdf1: UUID="3MgaHr-PuGs-Yc41-hT5Z-bZlF-UH8h-jdAwoa" TYPE="LVM2_member"
/dev/sde: UUID="Crn275-rSvZ-6Bl1-LplP-c0iG-PvtZ-OVofd8" TYPE="LVM2_member"
/dev/sdg1: UUID="Nh6BDQ-VuD8-w3hE-2Qwi-eNUE-uQl6-iooRBm" TYPE="LVM2_member"
/dev/sdi1: UUID="twn6Tb-5qNV-Y3WZ-xvWI-4zZe-N3ji-KLj0oX" TYPE="LVM2_member"
/dev/sdj1: UUID="986595d9-042c-4777-8d72-1607eebff422" TYPE="ext3" SEC_TYPE="ext2"
/dev/sdh1: UUID="LG96Gx-jwLw-c7U5-gqAo-7VZY-5s1m-Em51l6" TYPE="LVM2_member"
/dev/sdk1: UUID="MMRd81-t77d-zriG-iRUH-VB13-kfMN-lMZczT" TYPE="LVM2_member"
/dev/sdl1: UUID="GS2aK5-UfeT-WYzN-AJtJ-6CRd-Z6GC-5gP1Eb" TYPE="LVM2_member"
/dev/sdt1: UUID="3MgaHr-PuGs-Yc41-hT5Z-bZlF-UH8h-jdAwoa" TYPE="LVM2_member"
/dev/sdv1: UUID="LG96Gx-jwLw-c7U5-gqAo-7VZY-5s1m-Em51l6" TYPE="LVM2_member"
/dev/sdw1: UUID="twn6Tb-5qNV-Y3WZ-xvWI-4zZe-N3ji-KLj0oX" TYPE="LVM2_member"
/dev/sdx1: UUID="986595d9-042c-4777-8d72-1607eebff422" TYPE="ext3" SEC_TYPE="ext2"
/dev/sdy1: UUID="MMRd81-t77d-zriG-iRUH-VB13-kfMN-lMZczT" TYPE="LVM2_member"
/dev/sdz1: UUID="GS2aK5-UfeT-WYzN-AJtJ-6CRd-Z6GC-5gP1Eb" TYPE="LVM2_member"
/dev/sdaa1: UUID="5cOmDe-oW4S-IAPn-z2AD-C1Mj-Rx0j-d2xkeA" TYPE="LVM2_member"
/dev/sdab1: UUID="IqnCrw-AB33-4KIQ-2Wnm-gDDE-z3B6-f2VTiR" TYPE="LVM2_member"
/dev/sdac1: UUID="1491e12d-78a5-4b1a-ad61-7b6b8232149e" SEC_TYPE="ext2" TYPE="ext3"
/dev/mapper/testfsdata01: UUID="2VqqWi-cWZo-Tu5T-cC40-z4CW-ZOti-aWhi5F" TYPE="LVM2_member"
/dev/mapper/testnfs01: UUID="JV8nOF-NxdU-WAZP-ZY9h-iXo8-HJWs-CjSjTj" TYPE="LVM2_member"
/dev/mapper/testnfs02: UUID="Crn275-rSvZ-6Bl1-LplP-c0iG-PvtZ-OVofd8" TYPE="LVM2_member"
/dev/vg_testfs/LogVol01: UUID="fa144978-2dae-4eee-88e7-72a70f70e104" TYPE="swap"
/dev/block/253:4: UUID="9db6bbe3-fa81-4889-802a-25daa9b36059" TYPE="ext4"
/dev/block/8:2: UUID="SQ8Lg0-uiV2-xjUN-jWO0-xy9A-Ct6Y-PfRcGV" TYPE="LVM2_member"
/dev/mapper/opfsdata01--vg-opfsdata01--lv: UUID="4e86d36f-bbd8-4013-833f-13156cb74383" TYPE="ext3"
/dev/mapper/spqfsdata01--vg-spqfsdata01--lv: UUID="37430186-3e39-4410-a5b6-231eae1563c3" TYPE="ext3"
[root@testfs ~]# cat unmountem
umount /soc/san/filestore/snapshots/op-test-fsdata01-rw-04Jun2010/fsdatadir/transactionLog
umount /soc/san/filestore/snapshots/op-test-fsdata01-rw-04Jun2010
umount /soc/san/filestore/snapshots/spq-test-fsdata01-rw-27May2010/fsdatadir/transactionLog
umount /soc/san/filestore/snapshots/spq-test-fsdata01-rw-27May2010
[root@testfs ~]# ./unmountem
[root@testfs ~]# cat deact
vgchange -a n spqfsdata01-vg
vgchange -a n opfsdata01-vg
[root@testfs ~]# ./deact
  Found duplicate PV 3MgaHrPuGsYc41hT5ZbZlFUH8hjdAwoa: using /dev/sdf1 not /dev/sdt1
  Found duplicate PV Nh6BDQVuD8w3hE2QwieNUEuQl6iooRBm: using /dev/sdg1 not /dev/sdu1
  Found duplicate PV LG96GxjwLwc7U5gqAo7VZY5s1mEm51l6: using /dev/sdh1 not /dev/sdv1
  Found duplicate PV twn6Tb5qNVY3WZxvWI4zZeN3jiKLj0oX: using /dev/sdi1 not /dev/sdw1
  Found duplicate PV MMRd81t77dzriGiRUHVB13kfMNlMZczT: using /dev/sdk1 not /dev/sdy1
  Found duplicate PV GS2aK5UfeTWYzNAJtJ6CRdZ6GC5gP1Eb: using /dev/sdl1 not /dev/sdz1
  Found duplicate PV 5cOmDeoW4SIAPnz2ADC1MjRx0jd2xkeA: using /dev/sdm1 not /dev/sdaa1
  Found duplicate PV IqnCrwAB334KIQ2WnmgDDEz3B6f2VTiR: using /dev/sdn1 not /dev/sdab1
  0 logical volume(s) in volume group "spqfsdata01-vg" now active
  /dev/dm-1: open failed: No such device or address
  Found duplicate PV 3MgaHrPuGsYc41hT5ZbZlFUH8hjdAwoa: using /dev/sdf1 not /dev/sdt1
  Found duplicate PV Nh6BDQVuD8w3hE2QwieNUEuQl6iooRBm: using /dev/sdg1 not /dev/sdu1
  Found duplicate PV LG96GxjwLwc7U5gqAo7VZY5s1mEm51l6: using /dev/sdh1 not /dev/sdv1
  Found duplicate PV twn6Tb5qNVY3WZxvWI4zZeN3jiKLj0oX: using /dev/sdi1 not /dev/sdw1
  Found duplicate PV MMRd81t77dzriGiRUHVB13kfMNlMZczT: using /dev/sdk1 not /dev/sdy1
  Found duplicate PV GS2aK5UfeTWYzNAJtJ6CRdZ6GC5gP1Eb: using /dev/sdl1 not /dev/sdz1
  Found duplicate PV 5cOmDeoW4SIAPnz2ADC1MjRx0jd2xkeA: using /dev/sdm1 not /dev/sdaa1
  Found duplicate PV IqnCrwAB334KIQ2WnmgDDEz3B6f2VTiR: using /dev/sdn1 not /dev/sdab1
  0 logical volume(s) in volume group "opfsdata01-vg" now active
[root@testfs ~]# multipath -v2
create: spq-test-fsdata01-rw-27May2010 (350002ac0022005d8) undef 3PARdata,VV
size=2.0T features='0' hwhandler='0' wp=undef
`-+- policy='round-robin 0' prio=2 status=undef
  |- 3:0:0:4  sdf  8:80   undef ready running
  `- 4:0:0:4  sdt  65:48  undef ready running
create: spq-test-fsdata04-rw-27May2010 (350002ac0022305d8) undef 3PARdata,VV
size=2.0T features='0' hwhandler='0' wp=undef
`-+- policy='round-robin 0' prio=2 status=undef
  |- 3:0:0:7  sdi  8:128  undef ready running
  `- 4:0:0:7  sdw  65:96  undef ready running
create: spq-test-fsdata02-rw-27May2010 (350002ac0022105d8) undef 3PARdata,VV
size=2.0T features='0' hwhandler='0' wp=undef
`-+- policy='round-robin 0' prio=2 status=undef
  |- 3:0:0:5  sdg  8:96   undef ready running
  `- 4:0:0:5  sdu  65:64  undef ready running
create: spq-test-fsdata03-rw-27May2010 (350002ac0022205d8) undef 3PARdata,VV
size=2.0T features='0' hwhandler='0' wp=undef
`-+- policy='round-robin 0' prio=2 status=undef
  |- 3:0:0:6  sdh  8:112  undef ready running
  `- 4:0:0:6  sdv  65:80  undef ready running
create: op-tst-fsdata01-rw-04Jun2010 (350002ac0021b05d8) undef 3PARdata,VV
size=2.0T features='0' hwhandler='0' wp=undef
`-+- policy='round-robin 0' prio=2 status=undef
  |- 3:0:0:9  sdk  8:160  undef ready running
  `- 4:0:0:9  sdy  65:128 undef ready running
create: op-tst-fsdata04-rw-04Jun2010 (350002ac0021e05d8) undef 3PARdata,VV
size=2.0T features='0' hwhandler='0' wp=undef
`-+- policy='round-robin 0' prio=2 status=undef
  |- 3:0:0:12 sdn  8:208  undef ready running
  `- 4:0:0:12 sdab 65:176 undef ready running
create: op-tst-fsdata02-rw-04Jun2010 (350002ac0021c05d8) undef 3PARdata,VV
size=2.0T features='0' hwhandler='0' wp=undef
`-+- policy='round-robin 0' prio=2 status=undef
  |- 3:0:0:10 sdl  8:176  undef ready running
  `- 4:0:0:10 sdz  65:144 undef ready running
create: op-tst-fsdata03-rw-04Jun2010 (350002ac0021d05d8) undef 3PARdata,VV
size=2.0T features='0' hwhandler='0' wp=undef
`-+- policy='round-robin 0' prio=2 status=undef
  |- 3:0:0:11 sdm  8:192  undef ready running
  `- 4:0:0:11 sdaa 65:160 undef ready running
[root@testfs ~]# multipath -ll
op-tst-fsdata01-rw-04Jun2010 (350002ac0021b05d8) dm-18 3PARdata,VV
size=2.0T features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=2 status=active
  |- 3:0:0:9  sdk  8:160  active ready running
  `- 4:0:0:9  sdy  65:128 active ready running
spq-test-fsdata04-rw-27May2010 (350002ac0022305d8) dm-1 3PARdata,VV
size=2.0T features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=2 status=active
  |- 3:0:0:7  sdi  8:128  active ready running
  `- 4:0:0:7  sdw  65:96  active ready running
spq-test-fsdata01-rw-27May2010 (350002ac0022005d8) dm-0 3PARdata,VV
size=2.0T features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=2 status=active
  |- 3:0:0:4  sdf  8:80   active ready running
  `- 4:0:0:4  sdt  65:48  active ready running
testfsdata01 (350002ac000e505d8) dm-8 3PARdata,VV
size=2.0T features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=2 status=active
  |- 3:0:0:1  sdc  8:32   active ready running
  `- 4:0:0:1  sdq  65:0   active ready running
op-tst-fsdata03-rw-04Jun2010 (350002ac0021d05d8) dm-21 3PARdata,VV
size=2.0T features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=2 status=active
  |- 3:0:0:11 sdm  8:192  active ready running
  `- 4:0:0:11 sdaa 65:160 active ready running
spq-test-fsdata03-rw-27May2010 (350002ac0022205d8) dm-17 3PARdata,VV
size=2.0T features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=2 status=active
  |- 3:0:0:6  sdh  8:112  active ready running
  `- 4:0:0:6  sdv  65:80  active ready running
testsnapfslog02 (350002ac001ca05d8) dm-12 3PARdata,VV
size=200G features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=2 status=active
  |- 3:0:0:13 sdo  8:224  active ready running
  `- 4:0:0:13 sdac 65:192 active ready running
testfslog01 (350002ac000e605d8) dm-7 3PARdata,VV
size=200G features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=2 status=active
  |- 3:0:0:0  sdb  8:16   active ready running
  `- 4:0:0:0  sdp  8:240  active ready running
testsnapfslog01 (350002ac0010905d8) dm-11 3PARdata,VV
size=200G features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=2 status=active
  |- 3:0:0:8  sdj  8:144  active ready running
  `- 4:0:0:8  sdx  65:112 active ready running
op-tst-fsdata02-rw-04Jun2010 (350002ac0021c05d8) dm-20 3PARdata,VV
size=2.0T features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=2 status=active
  |- 3:0:0:10 sdl  8:176  active ready running
  `- 4:0:0:10 sdz  65:144 active ready running
testnfs02 (350002ac000ea05d8) dm-10 3PARdata,VV
size=2.0T features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=2 status=active
  |- 3:0:0:3  sde  8:64   active ready running
  `- 4:0:0:3  sds  65:32  active ready running
spq-test-fsdata02-rw-27May2010 (350002ac0022105d8) dm-16 3PARdata,VV
size=2.0T features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=2 status=active
  |- 3:0:0:5  sdg  8:96   active ready running
  `- 4:0:0:5  sdu  65:64  active ready running
testnfs01 (350002ac000e905d8) dm-9 3PARdata,VV
size=2.0T features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=2 status=active
  |- 3:0:0:2  sdd  8:48   active ready running
  `- 4:0:0:2  sdr  65:16  active ready running
op-tst-fsdata04-rw-04Jun2010 (350002ac0021e05d8) dm-19 3PARdata,VV
size=2.0T features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=2 status=active
  |- 3:0:0:12 sdn  8:208  active ready running
  `- 4:0:0:12 sdab 65:176 active ready running
[root@testfs ~]# ls /dev/op*
ls: cannot access /dev/op*: No such file or directory
[root@testfs ~]# vgscan --mknodes
  Reading all physical volumes.  This may take a while...
  Found duplicate PV 3MgaHrPuGsYc41hT5ZbZlFUH8hjdAwoa: using /dev/sdf1 not /dev/sdt1
  Found duplicate PV Nh6BDQVuD8w3hE2QwieNUEuQl6iooRBm: using /dev/sdg1 not /dev/sdu1
  Found duplicate PV LG96GxjwLwc7U5gqAo7VZY5s1mEm51l6: using /dev/sdh1 not /dev/sdv1
  Found duplicate PV twn6Tb5qNVY3WZxvWI4zZeN3jiKLj0oX: using /dev/sdi1 not /dev/sdw1
  Found duplicate PV MMRd81t77dzriGiRUHVB13kfMNlMZczT: using /dev/sdk1 not /dev/sdy1
  Found duplicate PV GS2aK5UfeTWYzNAJtJ6CRdZ6GC5gP1Eb: using /dev/sdl1 not /dev/sdz1
  Found duplicate PV 5cOmDeoW4SIAPnz2ADC1MjRx0jd2xkeA: using /dev/sdm1 not /dev/sdaa1
  Found duplicate PV IqnCrwAB334KIQ2WnmgDDEz3B6f2VTiR: using /dev/sdn1 not /dev/sdab1
  Found volume group "opfsdata01-vg" using metadata type lvm2
  Found volume group "spqfsdata01-vg" using metadata type lvm2
  Found volume group "testNFS" using metadata type lvm2
  Found volume group "filestoreVG" using metadata type lvm2
  Found volume group "vg_testfs" using metadata type lvm2
[root@testfs ~]# vgdisplay
  Found duplicate PV 3MgaHrPuGsYc41hT5ZbZlFUH8hjdAwoa: using /dev/sdf1 not /dev/sdt1
  Found duplicate PV Nh6BDQVuD8w3hE2QwieNUEuQl6iooRBm: using /dev/sdg1 not /dev/sdu1
  Found duplicate PV LG96GxjwLwc7U5gqAo7VZY5s1mEm51l6: using /dev/sdh1 not /dev/sdv1
  Found duplicate PV twn6Tb5qNVY3WZxvWI4zZeN3jiKLj0oX: using /dev/sdi1 not /dev/sdw1
  Found duplicate PV MMRd81t77dzriGiRUHVB13kfMNlMZczT: using /dev/sdk1 not /dev/sdy1
  Found duplicate PV GS2aK5UfeTWYzNAJtJ6CRdZ6GC5gP1Eb: using /dev/sdl1 not /dev/sdz1
  Found duplicate PV 5cOmDeoW4SIAPnz2ADC1MjRx0jd2xkeA: using /dev/sdm1 not /dev/sdaa1
  Found duplicate PV IqnCrwAB334KIQ2WnmgDDEz3B6f2VTiR: using /dev/sdn1 not /dev/sdab1
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
  Open LV               0
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
  Open LV               0
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

[root@testfs ~]# lvdisplay
  Found duplicate PV 3MgaHrPuGsYc41hT5ZbZlFUH8hjdAwoa: using /dev/sdf1 not /dev/sdt1
  Found duplicate PV Nh6BDQVuD8w3hE2QwieNUEuQl6iooRBm: using /dev/sdg1 not /dev/sdu1
  Found duplicate PV LG96GxjwLwc7U5gqAo7VZY5s1mEm51l6: using /dev/sdh1 not /dev/sdv1
  Found duplicate PV twn6Tb5qNVY3WZxvWI4zZeN3jiKLj0oX: using /dev/sdi1 not /dev/sdw1
  Found duplicate PV MMRd81t77dzriGiRUHVB13kfMNlMZczT: using /dev/sdk1 not /dev/sdy1
  Found duplicate PV GS2aK5UfeTWYzNAJtJ6CRdZ6GC5gP1Eb: using /dev/sdl1 not /dev/sdz1
  Found duplicate PV 5cOmDeoW4SIAPnz2ADC1MjRx0jd2xkeA: using /dev/sdm1 not /dev/sdaa1
  Found duplicate PV IqnCrwAB334KIQ2WnmgDDEz3B6f2VTiR: using /dev/sdn1 not /dev/sdab1
  --- Logical volume ---
  LV Name                /dev/opfsdata01-vg/opfsdata01-lv
  VG Name                opfsdata01-vg
  LV UUID                n9EGjn-Jfsi-pIJP-Wd02-mLd9-rGAF-0VIZhq
  LV Write Access        read/write
  LV Status              NOT available
  LV Size                8.00 TiB
  Current LE             2096120
  Segments               4
  Allocation             inherit
  Read ahead sectors     auto

  --- Logical volume ---
  LV Name                /dev/spqfsdata01-vg/spqfsdata01-lv
  VG Name                spqfsdata01-vg
  LV UUID                n9EGjn-Jfsi-pIJP-Wd02-mLd9-rGAF-0VIZhq
  LV Write Access        read/write
  LV Status              NOT available
  LV Size                8.00 TiB
  Current LE             2096120
  Segments               4
  Allocation             inherit
  Read ahead sectors     auto

  --- Logical volume ---
  LV Name                /dev/testNFS/testNFS
  VG Name                testNFS
  LV UUID                I8MMOA-Qfin-7WTe-HwcM-7Xey-WUPj-Kw8ra1
  LV Write Access        read/write
  LV Status              available
  # open                 1
  LV Size                3.90 TiB
  Current LE             1022362
  Segments               2
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:3

  --- Logical volume ---
  LV Name                /dev/filestoreVG/filestore
  VG Name                filestoreVG
  LV UUID                pdeKUQ-fdMQ-Pmhc-ONYW-Jrtz-knAk-JSnEH5
  LV Write Access        read/write
  LV Status              available
  # open                 1
  LV Size                1.95 TiB
  Current LE             511181
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:2

  --- Logical volume ---
  LV Name                /dev/vg_testfs/lv_root
  VG Name                vg_testfs
  LV UUID                DQoYPJ-koBr-xyxy-eXAx-8tS2-2inZ-4few5U
  LV Write Access        read/write
  LV Status              available
  # open                 1
  LV Size                247.42 GiB
  Current LE             63340
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:4

  --- Logical volume ---
  LV Name                /dev/vg_testfs/LogVol01
  VG Name                vg_testfs
  LV UUID                71ymYW-3ozU-8JI0-P030-qMd5-aJi1-0alm8B
  LV Write Access        read/write
  LV Status              available
  # open                 1
  LV Size                15.62 GiB
  Current LE             4000
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:5

  --- Logical volume ---
  LV Name                /dev/vg_testfs/LogVol02
  VG Name                vg_testfs
  LV UUID                johyzz-tzb4-TdQO-AfLy-8UfU-O3q8-eh7bUM
  LV Write Access        read/write
  LV Status              available
  # open                 1
  LV Size                15.62 GiB
  Current LE             4000
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:6

[root@testfs ~]# cat react
vgchange -a y spqfsdata01-vg
vgchange -a y opfsdata01-vg
[root@testfs ~]# ./react
  Found duplicate PV 3MgaHrPuGsYc41hT5ZbZlFUH8hjdAwoa: using /dev/sdf1 not /dev/sdt1
  Found duplicate PV Nh6BDQVuD8w3hE2QwieNUEuQl6iooRBm: using /dev/sdg1 not /dev/sdu1
  Found duplicate PV LG96GxjwLwc7U5gqAo7VZY5s1mEm51l6: using /dev/sdh1 not /dev/sdv1
  Found duplicate PV twn6Tb5qNVY3WZxvWI4zZeN3jiKLj0oX: using /dev/sdi1 not /dev/sdw1
  Found duplicate PV MMRd81t77dzriGiRUHVB13kfMNlMZczT: using /dev/sdk1 not /dev/sdy1
  Found duplicate PV GS2aK5UfeTWYzNAJtJ6CRdZ6GC5gP1Eb: using /dev/sdl1 not /dev/sdz1
  Found duplicate PV 5cOmDeoW4SIAPnz2ADC1MjRx0jd2xkeA: using /dev/sdm1 not /dev/sdaa1
  Found duplicate PV IqnCrwAB334KIQ2WnmgDDEz3B6f2VTiR: using /dev/sdn1 not /dev/sdab1
  device-mapper: reload ioctl failed: Invalid argument
  1 logical volume(s) in volume group "spqfsdata01-vg" now active
  Found duplicate PV 3MgaHrPuGsYc41hT5ZbZlFUH8hjdAwoa: using /dev/sdf1 not /dev/sdt1
  Found duplicate PV Nh6BDQVuD8w3hE2QwieNUEuQl6iooRBm: using /dev/sdg1 not /dev/sdu1
  Found duplicate PV LG96GxjwLwc7U5gqAo7VZY5s1mEm51l6: using /dev/sdh1 not /dev/sdv1
  Found duplicate PV twn6Tb5qNVY3WZxvWI4zZeN3jiKLj0oX: using /dev/sdi1 not /dev/sdw1
  Found duplicate PV MMRd81t77dzriGiRUHVB13kfMNlMZczT: using /dev/sdk1 not /dev/sdy1
  Found duplicate PV GS2aK5UfeTWYzNAJtJ6CRdZ6GC5gP1Eb: using /dev/sdl1 not /dev/sdz1
  Found duplicate PV 5cOmDeoW4SIAPnz2ADC1MjRx0jd2xkeA: using /dev/sdm1 not /dev/sdaa1
  Found duplicate PV IqnCrwAB334KIQ2WnmgDDEz3B6f2VTiR: using /dev/sdn1 not /dev/sdab1
  device-mapper: reload ioctl failed: Invalid argument
  1 logical volume(s) in volume group "opfsdata01-vg" now active
[root@testfs ~]# lvdisplay
  Found duplicate PV 3MgaHrPuGsYc41hT5ZbZlFUH8hjdAwoa: using /dev/sdf1 not /dev/sdt1
  Found duplicate PV Nh6BDQVuD8w3hE2QwieNUEuQl6iooRBm: using /dev/sdg1 not /dev/sdu1
  Found duplicate PV LG96GxjwLwc7U5gqAo7VZY5s1mEm51l6: using /dev/sdh1 not /dev/sdv1
  Found duplicate PV twn6Tb5qNVY3WZxvWI4zZeN3jiKLj0oX: using /dev/sdi1 not /dev/sdw1
  Found duplicate PV MMRd81t77dzriGiRUHVB13kfMNlMZczT: using /dev/sdk1 not /dev/sdy1
  Found duplicate PV GS2aK5UfeTWYzNAJtJ6CRdZ6GC5gP1Eb: using /dev/sdl1 not /dev/sdz1
  Found duplicate PV 5cOmDeoW4SIAPnz2ADC1MjRx0jd2xkeA: using /dev/sdm1 not /dev/sdaa1
  Found duplicate PV IqnCrwAB334KIQ2WnmgDDEz3B6f2VTiR: using /dev/sdn1 not /dev/sdab1
  --- Logical volume ---
  LV Name                /dev/opfsdata01-vg/opfsdata01-lv
  VG Name                opfsdata01-vg
  LV UUID                n9EGjn-Jfsi-pIJP-Wd02-mLd9-rGAF-0VIZhq
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                8.00 TiB
  Current LE             2096120
  Segments               4
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:23

  --- Logical volume ---
  LV Name                /dev/spqfsdata01-vg/spqfsdata01-lv
  VG Name                spqfsdata01-vg
  LV UUID                n9EGjn-Jfsi-pIJP-Wd02-mLd9-rGAF-0VIZhq
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                8.00 TiB
  Current LE             2096120
  Segments               4
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:22

  --- Logical volume ---
  LV Name                /dev/testNFS/testNFS
  VG Name                testNFS
  LV UUID                I8MMOA-Qfin-7WTe-HwcM-7Xey-WUPj-Kw8ra1
  LV Write Access        read/write
  LV Status              available
  # open                 1
  LV Size                3.90 TiB
  Current LE             1022362
  Segments               2
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:3

  --- Logical volume ---
  LV Name                /dev/filestoreVG/filestore
  VG Name                filestoreVG
  LV UUID                pdeKUQ-fdMQ-Pmhc-ONYW-Jrtz-knAk-JSnEH5
  LV Write Access        read/write
  LV Status              available
  # open                 1
  LV Size                1.95 TiB
  Current LE             511181
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:2

  --- Logical volume ---
  LV Name                /dev/vg_testfs/lv_root
  VG Name                vg_testfs
  LV UUID                DQoYPJ-koBr-xyxy-eXAx-8tS2-2inZ-4few5U
  LV Write Access        read/write
  LV Status              available
  # open                 1
  LV Size                247.42 GiB
  Current LE             63340
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:4

  --- Logical volume ---
  LV Name                /dev/vg_testfs/LogVol01
  VG Name                vg_testfs
  LV UUID                71ymYW-3ozU-8JI0-P030-qMd5-aJi1-0alm8B
  LV Write Access        read/write
  LV Status              available
  # open                 1
  LV Size                15.62 GiB
  Current LE             4000
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:5

  --- Logical volume ---
  LV Name                /dev/vg_testfs/LogVol02
  VG Name                vg_testfs
  LV UUID                johyzz-tzb4-TdQO-AfLy-8UfU-O3q8-eh7bUM
  LV Write Access        read/write
  LV Status              available
  # open                 1
  LV Size                15.62 GiB
  Current LE             4000
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:6

[root@testfs ~]# ls /dev/op*
ls: cannot access /dev/op*: No such file or directory
[root@testfs ~]# ls /dev/mapper/opfsdata01--vg-opfsdata01--lv
/dev/mapper/opfsdata01--vg-opfsdata01--lv
[root@testfs ~]# ls -als /dev/mapper/opfsdata01--vg-opfsdata01--lv
0 brw-rw---- 1 root disk 253, 23 Aug 28 14:20 /dev/mapper/opfsdata01--vg-opfsdata01--lv
[root@testfs ~]# mount /dev/mapper/opfsdata01--vg-opfsdata01--lv /mnt
mount: you must specify the filesystem type
[root@testfs ~]# blkid | grep opfs
[root@testfs ~]# blkid -p /dev/mapper/opfsdata01--vg-opfsdata01--lv
[root@testfs ~]# /etc/init.d/udev-post reload
Retrigger failed udev events  OK
[root@testfs ~]# ls -als /dev/op*
ls: cannot access /dev/op*: No such file or directory
[root@testfs ~]# vgscan --mknodes
  Reading all physical volumes.  This may take a while...
  Found duplicate PV 3MgaHrPuGsYc41hT5ZbZlFUH8hjdAwoa: using /dev/sdf1 not /dev/sdt1
  Found duplicate PV Nh6BDQVuD8w3hE2QwieNUEuQl6iooRBm: using /dev/sdg1 not /dev/sdu1
  Found duplicate PV LG96GxjwLwc7U5gqAo7VZY5s1mEm51l6: using /dev/sdh1 not /dev/sdv1
  Found duplicate PV twn6Tb5qNVY3WZxvWI4zZeN3jiKLj0oX: using /dev/sdi1 not /dev/sdw1
  Found duplicate PV MMRd81t77dzriGiRUHVB13kfMNlMZczT: using /dev/sdk1 not /dev/sdy1
  Found duplicate PV GS2aK5UfeTWYzNAJtJ6CRdZ6GC5gP1Eb: using /dev/sdl1 not /dev/sdz1
  Found duplicate PV 5cOmDeoW4SIAPnz2ADC1MjRx0jd2xkeA: using /dev/sdm1 not /dev/sdaa1
  Found duplicate PV IqnCrwAB334KIQ2WnmgDDEz3B6f2VTiR: using /dev/sdn1 not /dev/sdab1
  Found volume group "opfsdata01-vg" using metadata type lvm2
  Found volume group "spqfsdata01-vg" using metadata type lvm2
  Found volume group "testNFS" using metadata type lvm2
  Found volume group "filestoreVG" using metadata type lvm2
  Found volume group "vg_testfs" using metadata type lvm2
  The link /dev/opfsdata01-vg/opfsdata01-lv should had been created by udev but it was not found. Falling back to direct link creation.
  The link /dev/spqfsdata01-vg/spqfsdata01-lv should had been created by udev but it was not found. Falling back to direct link creation.
[root@testfs ~]# ls -als /dev/op*
total 0
0 drwxr-xr-x  2 root root   60 Aug 28 14:22 .
0 drwxr-xr-x 23 root root 5840 Aug 28 14:22 ..
0 lrwxrwxrwx  1 root root   41 Aug 28 14:22 opfsdata01-lv -> /dev/mapper/opfsdata01--vg-opfsdata01--lv
[root@testfs ~]# blkid /dev/opfsdata01-vg/opfsdata01-lv
[root@testfs ~]# blkid -p /dev/opfsdata01-vg/opfsdata01-lv
[root@testfs ~]# mount /dev/mapper/opfsdata01--vg-opfsdata01--lv /mnt
mount: you must specify the filesystem type
[root@testfs ~]# ./cat deact
vgchange -a n spqfsdata01-vg
vgchange -a n opfsdata01-vg
[root@testfs ~]# ./deact
  Found duplicate PV 3MgaHrPuGsYc41hT5ZbZlFUH8hjdAwoa: using /dev/sdf1 not /dev/sdt1
  Found duplicate PV Nh6BDQVuD8w3hE2QwieNUEuQl6iooRBm: using /dev/sdg1 not /dev/sdu1
  Found duplicate PV LG96GxjwLwc7U5gqAo7VZY5s1mEm51l6: using /dev/sdh1 not /dev/sdv1
  Found duplicate PV twn6Tb5qNVY3WZxvWI4zZeN3jiKLj0oX: using /dev/sdi1 not /dev/sdw1
  Found duplicate PV MMRd81t77dzriGiRUHVB13kfMNlMZczT: using /dev/sdk1 not /dev/sdy1
  Found duplicate PV GS2aK5UfeTWYzNAJtJ6CRdZ6GC5gP1Eb: using /dev/sdl1 not /dev/sdz1
  Found duplicate PV 5cOmDeoW4SIAPnz2ADC1MjRx0jd2xkeA: using /dev/sdm1 not /dev/sdaa1
  Found duplicate PV IqnCrwAB334KIQ2WnmgDDEz3B6f2VTiR: using /dev/sdn1 not /dev/sdab1
  Node /dev/mapper/spqfsdata01--vg-spqfsdata01--lv was not removed by udev. Falling back to direct node removal.
  The link /dev/spqfsdata01-vg/spqfsdata01-lv should have been removed by udev but it is still present. Falling back to direct link removal.
  0 logical volume(s) in volume group "spqfsdata01-vg" now active
  Found duplicate PV 3MgaHrPuGsYc41hT5ZbZlFUH8hjdAwoa: using /dev/sdf1 not /dev/sdt1
  Found duplicate PV Nh6BDQVuD8w3hE2QwieNUEuQl6iooRBm: using /dev/sdg1 not /dev/sdu1
  Found duplicate PV LG96GxjwLwc7U5gqAo7VZY5s1mEm51l6: using /dev/sdh1 not /dev/sdv1
  Found duplicate PV twn6Tb5qNVY3WZxvWI4zZeN3jiKLj0oX: using /dev/sdi1 not /dev/sdw1
  Found duplicate PV MMRd81t77dzriGiRUHVB13kfMNlMZczT: using /dev/sdk1 not /dev/sdy1
  Found duplicate PV GS2aK5UfeTWYzNAJtJ6CRdZ6GC5gP1Eb: using /dev/sdl1 not /dev/sdz1
  Found duplicate PV 5cOmDeoW4SIAPnz2ADC1MjRx0jd2xkeA: using /dev/sdm1 not /dev/sdaa1
  Found duplicate PV IqnCrwAB334KIQ2WnmgDDEz3B6f2VTiR: using /dev/sdn1 not /dev/sdab1
  Node /dev/mapper/opfsdata01--vg-opfsdata01--lv was not removed by udev. Falling back to direct node removal.
  The link /dev/opfsdata01-vg/opfsdata01-lv should have been removed by udev but it is still present. Falling back to direct link removal.
  0 logical volume(s) in volume group "opfsdata01-vg" now active
[root@testfs ~]# mulitipath -F
Aug 28 14:23:05 | testfslog01: map in use
[root@testfs ~]# multipath -ll
testfslog01 (350002ac000e605d8) dm-7 3PARdata,VV
size=200G features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=2 status=active
  |- 3:0:0:0  sdb  8:16   active ready running
  `- 4:0:0:0  sdp  8:240  active ready running
[root@testfs ~]# vgscan --mknodes
  Reading all physical volumes.  This may take a while...
  Found duplicate PV 2VqqWicWZoTu5TcC40z4CWZOtiaWhi5F: using /dev/sdc not /dev/sdq
  Found duplicate PV JV8nOFNxdUWAZPZY9hiXo8HJWsCjSjTj: using /dev/sdd not /dev/sdr
  Found duplicate PV Crn275rSvZ6Bl1LplPc0iGPvtZOVofd8: using /dev/sde not /dev/sds
  Found duplicate PV 3MgaHrPuGsYc41hT5ZbZlFUH8hjdAwoa: using /dev/sdf1 not /dev/sdt1
  Found duplicate PV Nh6BDQVuD8w3hE2QwieNUEuQl6iooRBm: using /dev/sdg1 not /dev/sdu1
  Found duplicate PV LG96GxjwLwc7U5gqAo7VZY5s1mEm51l6: using /dev/sdh1 not /dev/sdv1
  Found duplicate PV twn6Tb5qNVY3WZxvWI4zZeN3jiKLj0oX: using /dev/sdi1 not /dev/sdw1
  Found duplicate PV MMRd81t77dzriGiRUHVB13kfMNlMZczT: using /dev/sdk1 not /dev/sdy1
  Found duplicate PV GS2aK5UfeTWYzNAJtJ6CRdZ6GC5gP1Eb: using /dev/sdl1 not /dev/sdz1
  Found duplicate PV 5cOmDeoW4SIAPnz2ADC1MjRx0jd2xkeA: using /dev/sdm1 not /dev/sdaa1
  Found duplicate PV IqnCrwAB334KIQ2WnmgDDEz3B6f2VTiR: using /dev/sdn1 not /dev/sdab1
  Found volume group "opfsdata01-vg" using metadata type lvm2
  Found volume group "spqfsdata01-vg" using metadata type lvm2
  Found volume group "filestoreVG" using metadata type lvm2
  Found volume group "testNFS" using metadata type lvm2
  Found volume group "vg_testfs" using metadata type lvm2
[root@testfs ~]# vgdisplay
  Found duplicate PV 2VqqWicWZoTu5TcC40z4CWZOtiaWhi5F: using /dev/sdc not /dev/sdq
  Found duplicate PV JV8nOFNxdUWAZPZY9hiXo8HJWsCjSjTj: using /dev/sdd not /dev/sdr
  Found duplicate PV Crn275rSvZ6Bl1LplPc0iGPvtZOVofd8: using /dev/sde not /dev/sds
  Found duplicate PV 3MgaHrPuGsYc41hT5ZbZlFUH8hjdAwoa: using /dev/sdf1 not /dev/sdt1
  Found duplicate PV Nh6BDQVuD8w3hE2QwieNUEuQl6iooRBm: using /dev/sdg1 not /dev/sdu1
  Found duplicate PV LG96GxjwLwc7U5gqAo7VZY5s1mEm51l6: using /dev/sdh1 not /dev/sdv1
  Found duplicate PV twn6Tb5qNVY3WZxvWI4zZeN3jiKLj0oX: using /dev/sdi1 not /dev/sdw1
  Found duplicate PV MMRd81t77dzriGiRUHVB13kfMNlMZczT: using /dev/sdk1 not /dev/sdy1
  Found duplicate PV GS2aK5UfeTWYzNAJtJ6CRdZ6GC5gP1Eb: using /dev/sdl1 not /dev/sdz1
  Found duplicate PV 5cOmDeoW4SIAPnz2ADC1MjRx0jd2xkeA: using /dev/sdm1 not /dev/sdaa1
  Found duplicate PV IqnCrwAB334KIQ2WnmgDDEz3B6f2VTiR: using /dev/sdn1 not /dev/sdab1
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
  Open LV               0
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
  Open LV               0
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

[root@testfs ~]# lvscan
  Found duplicate PV 2VqqWicWZoTu5TcC40z4CWZOtiaWhi5F: using /dev/sdc not /dev/sdq
  Found duplicate PV JV8nOFNxdUWAZPZY9hiXo8HJWsCjSjTj: using /dev/sdd not /dev/sdr
  Found duplicate PV Crn275rSvZ6Bl1LplPc0iGPvtZOVofd8: using /dev/sde not /dev/sds
  Found duplicate PV 3MgaHrPuGsYc41hT5ZbZlFUH8hjdAwoa: using /dev/sdf1 not /dev/sdt1
  Found duplicate PV Nh6BDQVuD8w3hE2QwieNUEuQl6iooRBm: using /dev/sdg1 not /dev/sdu1
  Found duplicate PV LG96GxjwLwc7U5gqAo7VZY5s1mEm51l6: using /dev/sdh1 not /dev/sdv1
  Found duplicate PV twn6Tb5qNVY3WZxvWI4zZeN3jiKLj0oX: using /dev/sdi1 not /dev/sdw1
  Found duplicate PV MMRd81t77dzriGiRUHVB13kfMNlMZczT: using /dev/sdk1 not /dev/sdy1
  Found duplicate PV GS2aK5UfeTWYzNAJtJ6CRdZ6GC5gP1Eb: using /dev/sdl1 not /dev/sdz1
  Found duplicate PV 5cOmDeoW4SIAPnz2ADC1MjRx0jd2xkeA: using /dev/sdm1 not /dev/sdaa1
  Found duplicate PV IqnCrwAB334KIQ2WnmgDDEz3B6f2VTiR: using /dev/sdn1 not /dev/sdab1
  inactive          '/dev/opfsdata01-vg/opfsdata01-lv' [8.00 TiB] inherit
  inactive          '/dev/spqfsdata01-vg/spqfsdata01-lv' [8.00 TiB] inherit
  ACTIVE            '/dev/filestoreVG/filestore' [1.95 TiB] inherit
  ACTIVE            '/dev/testNFS/testNFS' [3.90 TiB] inherit
  ACTIVE            '/dev/vg_testfs/lv_root' [247.42 GiB] inherit
  ACTIVE            '/dev/vg_testfs/LogVol01' [15.62 GiB] inherit
  ACTIVE            '/dev/vg_testfs/LogVol02' [15.62 GiB] inherit
[root@testfs ~]# lvdisplay
  Found duplicate PV 2VqqWicWZoTu5TcC40z4CWZOtiaWhi5F: using /dev/sdc not /dev/sdq
  Found duplicate PV JV8nOFNxdUWAZPZY9hiXo8HJWsCjSjTj: using /dev/sdd not /dev/sdr
  Found duplicate PV Crn275rSvZ6Bl1LplPc0iGPvtZOVofd8: using /dev/sde not /dev/sds
  Found duplicate PV 3MgaHrPuGsYc41hT5ZbZlFUH8hjdAwoa: using /dev/sdf1 not /dev/sdt1
  Found duplicate PV Nh6BDQVuD8w3hE2QwieNUEuQl6iooRBm: using /dev/sdg1 not /dev/sdu1
  Found duplicate PV LG96GxjwLwc7U5gqAo7VZY5s1mEm51l6: using /dev/sdh1 not /dev/sdv1
  Found duplicate PV twn6Tb5qNVY3WZxvWI4zZeN3jiKLj0oX: using /dev/sdi1 not /dev/sdw1
  Found duplicate PV MMRd81t77dzriGiRUHVB13kfMNlMZczT: using /dev/sdk1 not /dev/sdy1
  Found duplicate PV GS2aK5UfeTWYzNAJtJ6CRdZ6GC5gP1Eb: using /dev/sdl1 not /dev/sdz1
  Found duplicate PV 5cOmDeoW4SIAPnz2ADC1MjRx0jd2xkeA: using /dev/sdm1 not /dev/sdaa1
  Found duplicate PV IqnCrwAB334KIQ2WnmgDDEz3B6f2VTiR: using /dev/sdn1 not /dev/sdab1
  --- Logical volume ---
  LV Name                /dev/opfsdata01-vg/opfsdata01-lv
  VG Name                opfsdata01-vg
  LV UUID                n9EGjn-Jfsi-pIJP-Wd02-mLd9-rGAF-0VIZhq
  LV Write Access        read/write
  LV Status              NOT available
  LV Size                8.00 TiB
  Current LE             2096120
  Segments               4
  Allocation             inherit
  Read ahead sectors     auto

  --- Logical volume ---
  LV Name                /dev/spqfsdata01-vg/spqfsdata01-lv
  VG Name                spqfsdata01-vg
  LV UUID                n9EGjn-Jfsi-pIJP-Wd02-mLd9-rGAF-0VIZhq
  LV Write Access        read/write
  LV Status              NOT available
  LV Size                8.00 TiB
  Current LE             2096120
  Segments               4
  Allocation             inherit
  Read ahead sectors     auto

  --- Logical volume ---
  LV Name                /dev/filestoreVG/filestore
  VG Name                filestoreVG
  LV UUID                pdeKUQ-fdMQ-Pmhc-ONYW-Jrtz-knAk-JSnEH5
  LV Write Access        read/write
  LV Status              available
  # open                 1
  LV Size                1.95 TiB
  Current LE             511181
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:2

  --- Logical volume ---
  LV Name                /dev/testNFS/testNFS
  VG Name                testNFS
  LV UUID                I8MMOA-Qfin-7WTe-HwcM-7Xey-WUPj-Kw8ra1
  LV Write Access        read/write
  LV Status              available
  # open                 1
  LV Size                3.90 TiB
  Current LE             1022362
  Segments               2
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:3

  --- Logical volume ---
  LV Name                /dev/vg_testfs/lv_root
  VG Name                vg_testfs
  LV UUID                DQoYPJ-koBr-xyxy-eXAx-8tS2-2inZ-4few5U
  LV Write Access        read/write
  LV Status              available
  # open                 1
  LV Size                247.42 GiB
  Current LE             63340
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:4

  --- Logical volume ---
  LV Name                /dev/vg_testfs/LogVol01
  VG Name                vg_testfs
  LV UUID                71ymYW-3ozU-8JI0-P030-qMd5-aJi1-0alm8B
  LV Write Access        read/write
  LV Status              available
  # open                 1
  LV Size                15.62 GiB
  Current LE             4000
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:5

  --- Logical volume ---
  LV Name                /dev/vg_testfs/LogVol02
  VG Name                vg_testfs
  LV UUID                johyzz-tzb4-TdQO-AfLy-8UfU-O3q8-eh7bUM
  LV Write Access        read/write
  LV Status              available
  # open                 1
  LV Size                15.62 GiB
  Current LE             4000
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:6

[root@testfs ~]# cat react
vgchange -a y spqfsdata01-vg
vgchange -a y opfsdata01-vg
[root@testfs ~]# ./react
  Found duplicate PV 2VqqWicWZoTu5TcC40z4CWZOtiaWhi5F: using /dev/sdc not /dev/sdq
  Found duplicate PV JV8nOFNxdUWAZPZY9hiXo8HJWsCjSjTj: using /dev/sdd not /dev/sdr
  Found duplicate PV Crn275rSvZ6Bl1LplPc0iGPvtZOVofd8: using /dev/sde not /dev/sds
  Found duplicate PV 3MgaHrPuGsYc41hT5ZbZlFUH8hjdAwoa: using /dev/sdf1 not /dev/sdt1
  Found duplicate PV Nh6BDQVuD8w3hE2QwieNUEuQl6iooRBm: using /dev/sdg1 not /dev/sdu1
  Found duplicate PV LG96GxjwLwc7U5gqAo7VZY5s1mEm51l6: using /dev/sdh1 not /dev/sdv1
  Found duplicate PV twn6Tb5qNVY3WZxvWI4zZeN3jiKLj0oX: using /dev/sdi1 not /dev/sdw1
  Found duplicate PV MMRd81t77dzriGiRUHVB13kfMNlMZczT: using /dev/sdk1 not /dev/sdy1
  Found duplicate PV GS2aK5UfeTWYzNAJtJ6CRdZ6GC5gP1Eb: using /dev/sdl1 not /dev/sdz1
  Found duplicate PV 5cOmDeoW4SIAPnz2ADC1MjRx0jd2xkeA: using /dev/sdm1 not /dev/sdaa1
  Found duplicate PV IqnCrwAB334KIQ2WnmgDDEz3B6f2VTiR: using /dev/sdn1 not /dev/sdab1
  1 logical volume(s) in volume group "spqfsdata01-vg" now active
  Found duplicate PV 2VqqWicWZoTu5TcC40z4CWZOtiaWhi5F: using /dev/sdc not /dev/sdq
  Found duplicate PV JV8nOFNxdUWAZPZY9hiXo8HJWsCjSjTj: using /dev/sdd not /dev/sdr
  Found duplicate PV Crn275rSvZ6Bl1LplPc0iGPvtZOVofd8: using /dev/sde not /dev/sds
  Found duplicate PV 3MgaHrPuGsYc41hT5ZbZlFUH8hjdAwoa: using /dev/sdf1 not /dev/sdt1
  Found duplicate PV Nh6BDQVuD8w3hE2QwieNUEuQl6iooRBm: using /dev/sdg1 not /dev/sdu1
  Found duplicate PV LG96GxjwLwc7U5gqAo7VZY5s1mEm51l6: using /dev/sdh1 not /dev/sdv1
  Found duplicate PV twn6Tb5qNVY3WZxvWI4zZeN3jiKLj0oX: using /dev/sdi1 not /dev/sdw1
  Found duplicate PV MMRd81t77dzriGiRUHVB13kfMNlMZczT: using /dev/sdk1 not /dev/sdy1
  Found duplicate PV GS2aK5UfeTWYzNAJtJ6CRdZ6GC5gP1Eb: using /dev/sdl1 not /dev/sdz1
  Found duplicate PV 5cOmDeoW4SIAPnz2ADC1MjRx0jd2xkeA: using /dev/sdm1 not /dev/sdaa1
  Found duplicate PV IqnCrwAB334KIQ2WnmgDDEz3B6f2VTiR: using /dev/sdn1 not /dev/sdab1
  1 logical volume(s) in volume group "opfsdata01-vg" now active
[root@testfs ~]# ls /dev/opfsdata01-vg/opfsdata01-lv
/dev/opfsdata01-vg/opfsdata01-lv
[root@testfs ~]# ls -als /dev/opfsdata01-vg/opfsdata01-lv
0 lrwxrwxrwx 1 root root 7 Aug 28 14:23 /dev/opfsdata01-vg/opfsdata01-lv -> ../dm-1
[root@testfs ~]# mount /soc/san/filestore/snapshots/op-test-fsdata01-rw-04Jun2010
[root@testfs ~]# cd /soc/san/filestore/snapshots/op-test-fsdata01-rw-04Jun2010/
[root@testfs op-test-fsdata01-rw-04Jun2010]# ls -als
total 36
 8 drwxr-xr-x.  4 root   root    4096 Jan 29  2010 .
 4 drwxr-xr-x  13 socops socops  4096 Aug 26 20:55 ..
 4 drwx------   7 socops socops  4096 May 10 15:50 fsdatadir
20 drwx------.  2 root   root   16384 Feb 26  2009 lost+found
[root@testfs op-test-fsdata01-rw-04Jun2010]# cd fsdatadir/
[root@testfs fsdatadir]# ls
[root@testfs fsdatadir]# ls
anc-bad         blob             lock  stack.dump.csv      transactionLog
anc-bad.tar.gz  commitorder.seq  mts   stack.dump.old.csv  ts
[root@testfs fsdatadir]#
[root@testfs fsdatadir]# exit
exit

Script done on Sat 28 Aug 2010 02:25:00 PM PDT
[root@testfs ~]#
