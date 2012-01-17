From: Jim Meyering <jim@meyering.net>
Subject: Re: parted issue/question
Date: Tue, 17 Jan 2012 23:28:04 +0100
Message-ID: <87lip6t157.fsf@rho.meyering.net>
References: <4F13ADB3.5070806@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4F13ADB3.5070806@redhat.com> (Joey Boggs's message of "Sun, 15
	Jan 2012 23:55:15 -0500")
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Joey Boggs <jboggs@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi guys,

Joey Boggs wrote this to me:
> Been working on an issue with device-mapper/parted for RHEV-H's
> upstream project just not sure where the fault possibly lies.
>
> I'm specifically working on adding efi support to the installation
> drive, which involves creating a specific partition on the disk and
> marking with the boot flag. /dev/mapper device names are used where
> available for all available devices including local sata/ide/scsi
>
> Typical Installer parted steps in order for ovirt-node/RHEV-H
> parted -s /dev/mapper/XXXXX "mklabel gpt"
> parted -s /dev/mapper/XXXXX "mkpart efi 0M 256M"
> parted -s /dev/mapper/XXXXX "mkpart primary 256M 512M"
> parted -s /dev/mapper/XXXXX "mkpart primary 512M 768M"
> mkfs.vfat /dev/mapper/XXXXp1 -n EFI
> mke2fs /dev/mapper/XXXXp2 -L Root
> mke2fs /dev/mapper/XXXXp3 -L RootBackup
> The created efi partition is fine up to this point and can be
> mounted/unmounted freely
> When adding a fourth and final partition we run into an issue.
> parted -s /dev/mapper/XXXXX "mkpart efi 768M -1" is ran for the last
> partition used for lvm
> # this step erases/corrupts the vfat file system(unable to mount)
> somehow easily reproduced by adding a 4th partition no matter the size
> with parted
>
> Any ideas what could possibly be happening to corrupt that file system
> or write to a part of the disk incorrectly within parted?
>
> Using RHEL6.2 based parted/device-mapper this completes fine but there
> is a major version difference with parted
>
> Fedora 16 Versions
> parted 3.0.4
> device-mapper 1.02-65-5
>
> RHEL6.2 Versions
> parted 2.1.17
> device-mapper 1.02-66-6

Hi Joey,

Thanks for the report.
I first tried to reproduce that on F16 using a regular scsi device:
---------------------------------
modprobe scsi_debug dev_size_mb=1000
dev=/dev/sdd
parted -s $dev mklabel gpt \
mkpart efi 0M 256M \
mkpart root 256M 512M \
mkpart roo2 512M 768M

mkfs.vfat ${dev}1 -n EFI
mke2fs ${dev}2 -L Root
mke2fs ${dev}3 -L RootBackup
parted -s $dev -- mkpart data 768M -1
mount ${dev}1 /mnt/xx
modprobe -r scsi_debug
---------------------------------

That worked fine.  I.e., no error, no reproducer.
Starting to think that this is somehow DM-specific.

Try again, but now using DM:
(testing via "mount" is not reliable --
instead, let's just compare first the sector, pre/post)
---------------------------------

cd /tmp; truncate -s 1g f && loop=$(losetup --show -f f)
echo 0 $((2**21)) linear $loop 0 | dmsetup create barz
dev=/dev/mapper/barz
parted -s $dev mklabel gpt \
mkpart efi 0M 256M \
mkpart root 256M 512M \
mkpart roo2 512M 768M

mkfs.vfat ${dev}p1 -n EFI
mke2fs ${dev}p2 -L Root
mke2fs ${dev}p3 -L RootBackup

dd if=${dev}p1 of=p1-copy.pre bs=1M count=5
parted -s $dev -- mkpart data 768M -1
dd if=${dev}p1 of=p1-copy.post bs=1M count=5

$ cmp -l p1-copy.pre p1-copy.post
     40 166 215
     41  20  44
     42 163 144
     43 104  23

Another iteration, I got this:

$ cmp -l p1-copy.pre p1-copy.post
      1 353   0
      2  74   0
      3 220   0
      4 155   0
      5 153   0
      6 144   0
      7 157   0
      8 163   0
      9 146   0
     10 163   0
     13   2   0
     14  10   0
     15  10   0
     17   2   0
     19   2   0
     22 370   0
     23 370   0
     25  77   0
     27 377   0
     33 377   0
     34 240   0
     35   7   0
     39  51   0
     40 157   0
...
    182 141   0
    183 151   0
    184 156   0
    185  40   0
    186  56   0
    187  56   0
    188  56   0
    189  40   0
    190  15   0
    191  12   0
    511 125   0
    512 252   0

This is surely a bug, but where?
Creating the 4th partition should not affect contents of first.

  $ parted -s $dev u s p
  Model: Linux device-mapper (linear) (dm)
  Disk /dev/mapper/barz: 2097152s
  Sector size (logical/physical): 512B/512B
  Partition Table: gpt

  Number  Start     End       Size     File system  Name  Flags
   1      34s       500000s   499967s  fat16        efi
   2      500001s   1000000s  500000s  ext2         p1
   3      1000001s  1500000s  500000s  ext2         p2
   4      1500001s  2095199s  595199s               data

I straced the parted invocation that added the 4th partition,
and the only two write syscalls were the ones I expected:
to rewrite the 32 sectors at beginning and end of the disk.

======================================================
retry with DM and trivially small partitions

cd /tmp; truncate -s 10m g && loop=$(losetup --show -f g)
echo 0 100 linear $loop 0 | dmsetup create zub
dev=/dev/mapper/zub
parted -s $dev \
  mklabel gpt \
  mkpart efi 34s 34s \
  mkpart root 35s 35s \
  mkpart roo2 36s 36s \
  u s p

# write random bits to p1
dd of=${dev}p1 if=/dev/urandom count=1
dd if=${dev}p1 of=p1-copy.pre count=1
parted -s $dev mkpart p4 37s 37s
dd if=${dev}p1 of=p1-copy.post count=1
cmp -l p1-copy.pre p1-copy.post
--------------------------------

# Same problem: something modifies the 35th sector, and in this case,
# clears it: that cmp shows random bits on the LHS and all 0 bytes on
# the RHS.

    $ parted -s $dev u s p
    Model: Linux device-mapper (linear) (dm)
    Disk /dev/mapper/zub: 100s
    Sector size (logical/physical): 512B/512B
    Partition Table: gpt

    Number  Start  End  Size  File system  Name  Flags
     1      34s    34s  1s                 efi
     2      35s    35s  1s                 root
     3      36s    36s  1s                 roo2
     4      37s    37s  1s                 p4

I'll investigate more tomorrow.
