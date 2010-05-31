From: CoolCold <coolthecold@gmail.com>
Subject: Snapshots on block devices
Date: Mon, 31 May 2010 13:00:23 +0400
Message-ID: <AANLkTinAjaq_oDL2bgnn_5k4MXSM0eArcSxT7-OuMPEg@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hello!
Documentation states: "Device-mapper allows you, without massive data
copying: *) To create snapshots of any block device i.e. mountable,
saved states of the block device which are also writable without
interfering with the original content;" - from
http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.32.y.git;a=blob_plain;f=Documentation/device-mapper/snapshot.txt;h=a5009c8300f3364a98e8982c9697f1dee789346f;hb=HEAD
So, assuming I am reading right that it is possible to create snapshot
of say SATA disk partition or even md device. I'm trying to achieve
this but without much luck:


root@ubuntu:~# blockdev --getsz /dev/sda1
9767457
root@ubuntu:~# echo '0 9767457 snapshot /dev/sda1 /dev/ram7 N
1'|dmsetup -vvvvvvv create tstsnap
dm version   OF   [16384]
dm create tstsnap  OF   [16384]
tstsnap: Stacking NODE_ADD (252,0) 0:6 0660
dm reload tstsnap  OF   [16384]
device-mapper: reload ioctl failed: Device or resource busy
dm remove tstsnap  OF   [16384]
tstsnap: Stacking NODE_DEL (replaces other stacked ops)
Command failed
root@ubuntu:~# dmesg |tail
[ 2729.015213] device-mapper: table: 252:0: snapshot: Cannot get origin device
[ 2729.132113] device-mapper: ioctl: error adding target to table

root@ubuntu:~# uname -a
Linux ubuntu 2.6.32-22-generic #33-Ubuntu SMP Wed Apr 28 13:28:05 UTC
2010 x86_64 GNU/Linux

root@ubuntu:~# dmsetup targets
mirror           v1.12.0
snapshot-origin  v1.7.0
snapshot         v1.7.0
multipath        v1.1.0
striped          v1.3.0
linear           v1.1.0
error            v1.0.1

I guess i miss something but do have no idea what i'm missing

-- 
Best regards,
[COOLCOLD-RIPN]
