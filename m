From: Tore Anderson <tore@linpro.no>
Subject: Resizing multipath maps: reload ioctl failed: Invalid
	argument
Date: Mon, 27 Aug 2007 15:02:55 +0200
Message-ID: <46D2CB7F.80900@linpro.no>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids


  Hi.  I'm trying to resize multipath maps, but there appears to be
 something wrong with the ioctl call...  I resized the "www" volume on
 the storage array from 25GB to 45GB, and attempted to reload it on the
 host, which is running 2.6.23-rc3 and multipath-tools 0.4.7.  It
 resulted in the following:

root@atalanta:~# multipath -ll
[...]
www (3600a0b80002984ae0000179b46a687fb)
[size=25 GB][features=1 queue_if_no_path][hwhandler=1 rdac]
\_ round-robin 0 [prio=6][active]
 \_ 3:0:1:0 sdf 8:80  [active][ready]
 \_ 4:0:1:0 sdi 8:128 [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 4:0:0:0 sdc 8:32  [active][ready]
 \_ 3:0:0:0 sdd 8:48  [active][ready]
root@atalanta:~# for d in sdf sdi sdc sdd; do cat /sys/block/$d/size; done
52428800
52428800
52428800
52428800
root@atalanta:~# for d in sdf sdi sdc sdd; do echo 1 > /sys/block/$d/device/rescan; done
root@atalanta:~# for d in sdf sdi sdc sdd; do cat /sys/block/$d/size; done
94371840
94371840
94371840
94371840
root@atalanta:~# multipath -v 2 -d
reload: www (3600a0b80002984ae0000179b46a687fb)
[size=45 GB][features=0][hwhandler=1 rdac]
\_ round-robin 0 [prio=0][undef]
 \_ 4:0:0:0 sdc 8:32  [active][ready]
 \_ 3:0:0:0 sdd 8:48  [active][ready]
\_ round-robin 0 [prio=6][undef]
 \_ 3:0:1:0 sdf 8:80  [active][ready]
 \_ 4:0:1:0 sdi 8:128 [active][ready]
[...]
root@atalanta:~# multipath -v 2
device-mapper: reload ioctl failed: Invalid argument
device-mapper: reload ioctl failed: Invalid argument
device-mapper: reload ioctl failed: Invalid argument
device-mapper: reload ioctl failed: Invalid argument
root@atalanta:~# dmsetup table www | sed 's/52428800/94371840/' | dmsetup reload www
device-mapper: reload ioctl failed: Invalid argument
Command failed

  Ultimately I found no other way to make this work but to umount the
 file system, then run "multipath -f www; multipath", which kind of
 defeated the point of fancy online resizing support in the file system
 and storage array since I need downtime to do it.  Is there any other
 way to make online resizing work?

  By the way, I think the error is happening in the kernel, due to the
 following messages appearing in dmesg after the rescan and multipath
 steps:

sd 3:0:1:0: [sdf] 94371840 512-byte hardware sectors (48318 MB)
sd 3:0:1:0: [sdf] Write Protect is off
sd 3:0:1:0: [sdf] Mode Sense: 77 00 10 08
sd 3:0:1:0: [sdf] Write cache: enabled, read cache: enabled, supports DPO and FUA
sd 4:0:1:0: [sdi] 94371840 512-byte hardware sectors (48318 MB)
sd 4:0:1:0: [sdi] Write Protect is off
sd 4:0:1:0: [sdi] Mode Sense: 77 00 10 08
sd 4:0:1:0: [sdi] Write cache: enabled, read cache: enabled, supports DPO and FUA
sd 4:0:0:0: [sdc] 94371840 512-byte hardware sectors (48318 MB)
sd 4:0:0:0: [sdc] Write Protect is off
sd 4:0:0:0: [sdc] Mode Sense: 77 00 10 08
sd 4:0:0:0: [sdc] Uses READ/WRITE(6), disabling FUA
sd 4:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 3:0:0:0: [sdd] 94371840 512-byte hardware sectors (48318 MB)
sd 3:0:0:0: [sdd] Write Protect is off
sd 3:0:0:0: [sdd] Mode Sense: 77 00 10 08
sd 3:0:0:0: [sdd] Uses READ/WRITE(6), disabling FUA
sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
device-mapper: multipath rdac: using RDAC command with timeout 6000
device-mapper: table: device 8:32 too small for target
device-mapper: table: 253:3: multipath: error getting device
device-mapper: ioctl: error adding target to table 
device-mapper: multipath rdac: using RDAC command with timeout 6000
device-mapper: table: device 8:32 too small for target
device-mapper: table: 253:3: multipath: error getting device
device-mapper: ioctl: error adding target to table 
device-mapper: multipath rdac: using RDAC command with timeout 6000
device-mapper: table: device 8:32 too small for target
device-mapper: table: 253:3: multipath: error getting device
device-mapper: ioctl: error adding target to table 
device-mapper: multipath rdac: using RDAC command with timeout 6000
device-mapper: table: device 8:32 too small for target
device-mapper: table: 253:3: multipath: error getting device
device-mapper: ioctl: error adding target to table 

Regards
-- 
Tore Anderson
