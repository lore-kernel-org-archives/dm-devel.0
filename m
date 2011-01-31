From: Andreas Heinlein <aheinlein@gmx.com>
Subject: Possible severe bug in the device mapper?
Date: Mon, 31 Jan 2011 10:30:04 +0100
Message-ID: <4D46811C.9050506@gmx.com>
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

Hello,

we observed the following behaviour:

1. Create a plain file on a removable drive, e.g. USB pendrive or
hotpluggable SATA drive (dd if=/dev/zero of=/media/somedrive/testfile
bs=1 count=1 seek=100000000). Don't make it bigger than ~50% of free memory.
2. Create a loopback device with this file (losetup -f
/media/somedrive/testfile)
3. Make this /dev/loopX a device mapper target. Tested with truecrypt,
dm_crypt (cryptsetup luksFormat ... and luksOpen ...) and lvm (pvcreate
/dev/loopX, vgcreate testvg /dev/loopX, lvcreate -N testlv testvg).
4. Create a filesystem on top of that mapping (mkfs.ext3 /dev/mapper/...)
5. Mount that filesystem
6. Copy some data to it
7. Remove the drive without unmounting anything

Expected behavior: Writing to the still mounted mapping should at least
give an error
Actual behavior: Reading from and writing to the mapping is still
possible, as long as the written data fits into the page cache. Even
unmounting works cleanly. When you remount the whole thing, data is
obviously lost.

This does not happen with whole block devices as targets, which is AFAIK
the case in most uses of the device mapper. We experienced this with
truecrypt volumes, where the user accidentally removed a drive
containing an encrypted TrueCrypt container. He plugged it back in, and
since everything worked, he continued to work. Only after unmounting and
re-opening the container the next day, he noticed that several hours of
work had been lost because nothing had actually been written. We are
using Ubuntu 10.04 LTS with linux 2.6.32.

Since this is reproducible with other device mapper targets, I am sure
this is not a truecrypt problem. It might be related to udev, which
AFAIK should notify higher levels when a device is removed.

IMHO, this is a rather severe problem, since loss of connection to a
device may also occur by bad cables, connections etc.

Do you have any explanation for that?

Thanks,
Andreas
