From: Saito Jun <cartman@mbs.sphere.ne.jp>
Subject: Device Mapper and unknown device.
Date: Sun, 14 Feb 2010 00:19:24 +0900
Message-ID: <4B76C2FC.3080109@mbs.sphere.ne.jp>
Reply-To: cartman@mbs.sphere.ne.jp,
        device-mapper development <dm-devel@redhat.com>
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

Hello everybody professional.
I am embarrassed.
What is this /dev/dm-1?
The cylinder is different though it is the same capacity.
And I newly made LUN.

-------------------------
[root@ns01 ~]# fdisk -l
This doesn't look like a partition table
Probably you selected the wrong device.
dev/sdb: 10.7 GB, 10737418240 bytes
255 heads, 63 sectors/track, 1305 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

Device Boot Start End Blocks Id System
/dev/sdb1 * 1 1305 10482381 7 HPFS/NTFS

Disk /dev/sdc: 10.7 GB, 10737418240 bytes
255 heads, 63 sectors/track, 1305 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

Device Boot Start End Blocks Id System
/dev/sdc1 * 1 1305 10482381 7 HPFS/NTFS

Disk /dev/dm-0: 10.7 GB, 10737418240 bytes
255 heads, 63 sectors/track, 1305 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

Device Boot Start End Blocks Id System
/dev/dm-0p1 * 1 1305 10482381 7 HPFS/NTFS

Disk /dev/dm-1: 10.7 GB, 10733958144 bytes
255 heads, 63 sectors/track, 1304 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

This doesn't look like a partition table
Probably you selected the wrong device.

Device Boot Start End Blocks Id System
/dev/dm-1p1 ? 10499 10499 0 65 Novell Netware 386
Partition 1 does not end on cylinder boundary.
/dev/dm-1p2 ? 13578 119522 850995205 72 unknown
Partition 2 does not end on cylinder boundary.
/dev/dm-1p3 ? 45382 79243 271987362 74 unknown
Partition 3 does not end on cylinder boundary.
/dev/dm-1p4 167628 167631 25817+ 0 empty
Partition 4 does not end on cylinder boundary.
---------------------------------


It explains the procedure.
--------------------
My Environment
/dev/sda [LocalDisk]
/dev/sdb [SAN External Disk]
/dev/sdc [SAN External Disk]

Configure Multipath
Edit /etc/multipath.conf
/etc/init.d/multipathd

Create Partition
fdisk /dev/sdb

Create Multipath block device
kpartx -a /dev/mapper/mpath0

Create File System
mke2fs -j /dev/mapper/mpath0p1

Mount
mount -t ext3 /dev/mapper/mpath0p1

Question
ls /dev/dm-1
---------------------

Regards,
