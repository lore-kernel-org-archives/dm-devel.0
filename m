From: james harvey <jamespharvey20@gmail.com>
Subject: During systemd/udev,
	device-mapper trying to work with non-LVM volumes
Date: Fri, 22 Jul 2016 19:14:30 -0400
Message-ID: <CA+X5Wn5tbL02XpG-JMvZ4-Sdg+sv=yymD1s6Afboag59LqD94Q@mail.gmail.com>
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

If I understand what's going on here, I think device-mapper is trying
to work with two volumes that don't involve LVM, causing the errors.
Is this a device-mapper bug?  A udev bug?  Something I have configured
wrong?

During boot, I see the following messages:

===============================
starting version 230
:: running early hook [lvm2]
:: running hook [udev]
:: Triggering uevents...
    [    3.964973] device-mapper: table: 253:21: thin: Unable to
activate thin device while pool is suspended
    [    4.023198] device-mapper: table: 253:22: thin: Unable to
activate thin device while pool is suspended
. . .
===============================

In dmesg, I see:

===============================
[    3.313426] Btrfs loaded
[    3.313987] BTRFS: device label terrasnapper_boot devid 1 transid 13 /dev/md2
[    3.314219] BTRFS: device label terramain_boot devid 1 transid 27 /dev/md1
[    3.391995] device-mapper: thin: Data device (dm-5) discard
unsupported: Disabling discard passdown.
[    3.392803] device-mapper: thin: Data device (dm-3) discard
unsupported: Disabling discard passdown.
[    3.520545] BTRFS: device label terrasnapper devid 3 transid 28 /dev/dm-13
[    3.520931] BTRFS: device label terramain devid 2 transid 35 /dev/dm-11
[    3.574622] BTRFS: device label persistent devid 3 transid 11 /dev/dm-14
[    3.590508] BTRFS: device label terrasnapper devid 2 transid 28 /dev/dm-12
[    3.604053] BTRFS: device label terramain devid 3 transid 35 /dev/dm-10
[    3.711390] BTRFS: device label persistent devid 2 transid 11 /dev/dm-15
[    3.788923] md: bind<dm-16>
[    3.790860] md/raid1:md0: active with 3 out of 3 mirrors
[    3.790909] md0: detected capacity change from 0 to 17163091968
[    3.961862] device-mapper: thin: Data device (dm-18) discard
unsupported: Disabling discard passdown.
[    3.964973] device-mapper: table: 253:21: thin: Unable to activate
thin device while pool is suspended
[    3.965075] device-mapper: ioctl: error adding target to table
[    4.023198] device-mapper: table: 253:22: thin: Unable to activate
thin device while pool is suspended
[    4.023295] device-mapper: ioctl: error adding target to table
[    4.111046] BTRFS: device label terrasnapper devid 1 transid 28 /dev/dm-21
[    4.188863] BTRFS: device label persistent devid 1 transid 11 /dev/dm-23
[    4.196150] BTRFS: device label terramain devid 1 transid 35 /dev/dm-22
===============================

There are 3 hard drives, all platter SATA.

dm-21 and dm-22 are NOT using LVM.  (If that is what is being referred
to by "table: 253:21" and "table: 253:22".) They are each a btrfs
filesystem, on a md RAID 1, of 3 hard drive partitions.  They're each
separate boot partitions, for separate installs.

All other volumes in the system are btrfs RAID's on LVM volumes, not
using md arrays.  (Except swap is an md array of raw LVM volumes.)

dmsetup table shows (253:21 and 253:22 are NOT on here)

===============================
disk3-disk3thin: 0 1048576000 linear 253:6 0
disk3-terramain3: 0 209715200 thin 253:6 1
disk3-disk3thin-tpool: 0 1048576000 thin-pool 253:4 253:5 512 0 0
disk3-disk3thin_tdata: 0 1048576000 linear 8:35 33818624
disk2-terraswap2: 0 33554432 linear 8:19 2048
disk1-disk1thin-tpool: 0 1048576000 thin-pool 253:17 253:18 512 0 0
disk1-disk1thin_tdata: 0 1048576000 linear 8:3 33818624
disk3-disk3thin_tmeta: 0 262144 linear 8:35 1082394624
disk1-disk1thin_tmeta: 0 262144 linear 8:3 1082394624
disk2-disk2thin: 0 1048576000 linear 253:7 0
disk3-terrasnapper3: 0 209715200 thin 253:6 2
disk2-persistent2: 0 209715200 thin 253:7 3
disk3-terraswap3: 0 33554432 linear 8:35 2048
disk1-disk1thin: 0 1048576000 linear 253:19 0
disk2-terrasnapper2: 0 209715200 thin 253:7 2
disk1-terramain1: 0 209715200 thin 253:19 1
disk2-disk2thin-tpool: 0 1048576000 thin-pool 253:2 253:3 512 0 0
disk2-disk2thin_tdata: 0 1048576000 linear 8:19 33818624
disk1-persistent1: 0 209715200 thin 253:19 3
disk2-disk2thin_tmeta: 0 262144 linear 8:19 1082394624
disk1-terrasnapper1: 0 209715200 thin 253:19 2
disk2-terramain2: 0 209715200 thin 253:7 1
disk3-persistent3: 0 209715200 thin 253:6 3
disk1-terraswap1: 0 33554432 linear 8:3 2048
===============================
