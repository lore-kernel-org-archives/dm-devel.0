From: Dave Holland <dh3@sanger.ac.uk>
Subject: not all paths working at boot
Date: Thu, 3 Aug 2006 14:54:47 +0100
Message-ID: <20060803135447.GE15820@sanger.ac.uk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

I have a problem with multipath-tools 0.4.7 (I also tried the latest
"git" version) running on Debian (mix of stable/unstable), kernel
2.6.17-1-amd64-k8, libdevmapper 1.02.07-1, udev 0.093-1. The machine is
a HP DL385 with QLA2312 FC card.

Basically, at boot time, multipath does not recognise all the paths. The
underlying LUNs are visible, the mid-layer allocates /dev/sd* device
names, but not all the paths are not used:

newftp1b:~# lsscsi -d | grep ':1]'
[0:0:0:1]    disk    COMPAQ   HSV110 (C)COMPAQ 3028  /dev/sda[8:0]
[0:0:1:1]    disk    COMPAQ   HSV110 (C)COMPAQ 3028  /dev/sdi[8:128]
[1:0:0:1]    disk    COMPAQ   HSV110 (C)COMPAQ 3028  /dev/sdq[65:0]
[1:0:1:1]    disk    COMPAQ   HSV110 (C)COMPAQ 3028  /dev/sdy[65:128]

newftp1b:~# multipath -ll 3600508b4001031d40000c00005a30000
3600508b4001031d40000c00005a30000
[size=1000 GB][features=1 queue_if_no_path][hwhandler=0]
\_ round-robin 0 [prio=2][enabled]
 \_ 0:0:1:1 sdi  8:128  [active][ghost]
 \_ 1:0:1:1 sdy  65:128 [active][ghost]
\_ round-robin 0 [prio=1][enabled]
 \_ 1:0:0:1 sdq  65:0   [active][ready]

Note there's no path to 0:0:0:1 (sda 8:0); but I can dd data off that
device, fdisk it, etc, all OK.

If I remove /dev/sda and re-add it, then multipath (a) notices its
depature (as a "spurious" event?), and (b) correctly notices its
appearance and adds the path:

newftp1b:~# echo "scsi remove-single-device 0 0 0 1" > /proc/scsi/scsi 

Aug  3 14:23:20 localhost multipathd: sda: remove path (uevent)
Aug  3 14:23:20 localhost multipathd: sda: spurious uevent, path not in pathvec

newftp1b:~# echo "scsi add-single-device 0 0 0 1" > /proc/scsi/scsi 

Aug  3 14:23:47 localhost kernel: sd 0:0:0:1: Attached scsi disk sda
Aug  3 14:23:47 localhost multipathd: sda: add path (uevent)
Aug  3 14:23:48 localhost multipathd: 3600508b4001031d40000c00005a30000: load table [0 2097152000 multipath 1 queue_if_no_path 0 2 1 round-robin 0 2 1 8:128 100 0 65:

newftp1b:~# multipath -ll 3600508b4001031d40000c00005a30000
3600508b4001031d40000c00005a30000
[size=1000 GB][features=1 queue_if_no_path][hwhandler=0]
\_ round-robin 0 [prio=2][enabled]
 \_ 0:0:1:1 sdi  8:128  [active][ghost]
 \_ 1:0:1:1 sdy  65:128 [active][ghost]
\_ round-robin 0 [prio=2][enabled]
 \_ 1:0:0:1 sdq  65:0   [active][ready]
 \_ 0:0:0:1 sda  8:0    [active][ready]

I thought this might be a race condition in the boot process but putting
sleeps around the multipath invocations in /etc/init.d/* hasn't helped.
It only ever seems to happen with this one LUN; other LUNs always come
up just fine. What else can I try?

Full "multipath -ll" output: http://www.sanger.ac.uk/~dh3/multipath-ll.txt
/etc/multipath.conf: http://www.sanger.ac.uk/~dh3/multipath.conf.txt

thanks,
Dave
-- 
** Dave Holland ** Systems Support -- Special Projects Team **
** 01223 496923 ** Sanger Institute, Hinxton, Cambridge, UK **
