From: Andrew Morton <akpm@linux-foundation.org>
Subject: Fw: BUG: Files corrupt after moving LVM volume to USB
	disk
Date: Thu, 22 Mar 2007 00:03:48 -0800
Message-ID: <20070322000348.92631512.akpm@linux-foundation.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
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


ho hum I'm getting rather bored of redirecting emails to the correct lists.

Does anyone there read linux-kernel?


Begin forwarded message:

Date: Tue, 20 Mar 2007 12:34:08 +0200
From: "Marti Raudsepp" <marti@juffo.org>
To: "Kernel hackers" <linux-kernel@vger.kernel.org>, fsdevel <linux-fsdevel@vger.kernel.org>
Subject: BUG: Files corrupt after moving LVM volume to USB disk


Hello LKML,

Second repost of "BUG: Killing and reviving files with USB disks", this time
also destined to linux-fsdevel.

This is a reproducible demonstration of the problem initially reported in my
first e-mail, titled "PROBLEM: 'bio too big device' after moving to a USB
disk" (http://lkml.org/lkml/2007/3/7/657)

Summary:
01. Create LVM volume; initialize dm-crypt; initialize reiserfs; mount
02. Populate the disk with files; sync; flush caches
03. Confirm that the files are still readable and non-corrupt (sha1sum)
04. Migrate logical volume to USB disk; sync; flush caches
05. Confirm that ALL PREVIOUSLY VERIFIED FILES ARE CORRUPT
06. Observe "bio too big device dm-0 (256 > 240)" messages in dmesg
07. Run reiserfsck to check for corruptions -- none.
08. Migrate logical volume back to SATA disk; sync; flush caches
09. Confirm that files are readable and non-corrupt again
10. Clean up


Environment/configuration:
* Linux non 2.6.19-gentoo-r6 #1 Wed Feb 28 20:55:24 EET 2007 x86_64 AMD
  Athlon(tm) 64 Processor 3000+ AuthenticAMD GNU/Linux
* USB disk 120GB Western Digital, model 00UE-00KVT0 (according to udev),
  serial DEF10CD7F64C
* Older SATA disk 200GB Seagate 7200.7, model ST3200822AS
* Motherboard Asus A8N5X, nForce4 chipset
* Offending file system: reiserfs v3.6, mounted with noatime,barrier=flush
* dm-crypt using aes-256 with cbc-essiv:sha256; using assembly-optimized AES
  on x86_64 (CONFIG_CRYPTO_AES_X86_64)
* Test partition is 68 extents times 16MiB = 1088 MiB large (that's the
  largest I could allocate while remaining in one segment -- otherwise lvmove
  wouldn't move the partition back to /dev/sda5 after "defragmenting" it.)
* LVM utilities version: 2.02.17 (2006-12-14)
* LVM library version: 1.02.12 (2006-10-13)
* LVM driver version: 4.10.0
* cryptsetup-luks 1.0.4 (user space interface to dm-crypt)

Involved block devices:
* /dev/sda: My old SATA disk.
* /dev/sda5: The LVM partition on the old disk.
* /dev/sdb: The new offending USB disk; whole disk is used as an LVM physical
            volume.
* /dev/primary: LVM volume group 'primary', consisting of /dev/sdb and
                /dev/sda5
* /dev/primary/punchbag: LVM volume 'punchbag' for demonstration purposes.
* /dev/mapper/crypt-punchbag: The dm-crypt "decrypted" loopback device.


----
00. PV information

[non]# pvdisplay /dev/sda5
  --- Physical volume ---
  PV Name               /dev/sda5
  VG Name               primary
  PV Size               145.83 GB / not usable 2.73 MB
  Allocatable           yes
  PE Size (KByte)       16384
  Total PE              9333
  Free PE               117
  Allocated PE          9216
  PV UUID               YdrDuL-jw5z-J0SA-EEKU-NOC4-6gGR-T90YCA

[non]# pvdisplay /dev/sdb
  --- Physical volume ---
  PV Name               /dev/sdb
  VG Name               primary
  PV Size               111.79 GB / not usable 9.46 MB
  Allocatable           yes
  PE Size (KByte)       16384
  Total PE              7154
  Free PE               7129
  Allocated PE          25
  PV UUID               nE8C5L-lfI1-VNgs-Q7ei-1Zz3-GeGT-UNhH4p

----
01. Create LVM volume; initialize dm-crypt; initialize reiserfs; mount

[non]# lvcreate -n punchbag --extents 68 primary /dev/sda5
  Logical volume "punchbag" created
[non]# lvs --segments -o +devices
  LV       VG      Attr   #Str Type   SSize   Devices
  [...]
  punchbag primary -wi-a-    1 linear   1.06G /dev/sda5(0)
  [...]
[non]# cryptsetup luksFormat /dev/primary/punchbag -c
aes-cbc-essiv:sha256 -h sha1
  [...]
Are you sure? (Type uppercase yes): YES
Enter LUKS passphrase:
Verify passphrase:
Command successful.
[non]# cryptsetup luksOpen /dev/primary/punchbag crypt-punchbag
Enter LUKS passphrase:
key slot 0 unlocked.
Command successful.
[non]# mkfs.reiserfs /dev/mapper/crypt-punchbag
  [...]
Guessing about desired format.. Kernel 2.6.19-gentoo-r6 is running.
Format 3.6 with standard journal
Count of blocks on the device: 343920
Number of blocks consumed by mkreiserfs formatting process: 8222
Blocksize: 4096
Hash function used to sort names: "r5"
Journal Size 8193 blocks (first block 18)
Journal Max transaction length 1024
inode generation number: 0
UUID: c1857208-5090-49dd-9163-9fb002d96a88
ATTENTION: YOU SHOULD REBOOT AFTER FDISK!
        ALL DATA WILL BE LOST ON '/dev/mapper/crypt-punchbag'!
Continue (y/n):y

Initializing journal - 0%....20%....40%....60%....80%....100%
Syncing..ok
  [...]

ReiserFS is successfully created on /dev/mapper/crypt-punchbag.
[non]# mkdir /mnt/punchbag
[non]# mount /dev/mapper/crypt-punchbag /mnt/punchbag -o noatime,barrier=flush

----
02. Populate the disk with files; sync; flush caches

[non]# cp -r ~marti/mp3 /mnt/punchbag
  [... yes, these are legal mp3s ;)]
cp: writing `/mnt/punchbag/mp3/...': No space left on device
^C
[non]# sync
[non]# echo 3 > /proc/sys/vm/drop_caches
[non]# cd /mnt/punchbag/mp3/mr\ Epic\ -\ Sideways

----
03. Confirm that the files are still readable and non-corrupt (sha1sum)

[non]# sha1sum -c *.sha1
mr Epic - Sideways - 01. Down Low.flac: OK
mr Epic - Sideways - 02. Blue Days.flac: OK
mr Epic - Sideways - 03. Sift.flac: OK
mr Epic - Sideways - 04. Slipping.flac: OK
mr Epic - Sideways - 05. Ruff and Tumble.flac: OK
mr Epic - Sideways - 06. In.flac: OK
mr Epic - Sideways - 07. Out.flac: OK

----
04. Migrate logical volume to USB disk; sync; flush caches

[non]# pvmove -n punchbag /dev/sda5 /dev/sdb
  [...]
  /dev/sda5: Moved: 100.0%
[non]# lvs --segments -o +devices
  LV       VG      Attr   #Str Type   SSize   Devices
  [...]
  punchbag primary -wi-ao    1 linear   1.06G /dev/sdb(25)
[non]# sync
[non]# echo 3 > /proc/sys/vm/drop_caches

----
05. Confirm that all previously verified files are corrupt

[non]# sha1sum -c *.sha1
sha1sum: mr Epic - Sideways - 01. Down Low.flac: Input/output error
mr Epic - Sideways - 01. Down Low.flac: FAILED open or read
sha1sum: mr Epic - Sideways - 02. Blue Days.flac: Input/output error
mr Epic - Sideways - 02. Blue Days.flac: FAILED open or read
sha1sum: mr Epic - Sideways - 03. Sift.flac: Input/output error
mr Epic - Sideways - 03. Sift.flac: FAILED open or read
sha1sum: mr Epic - Sideways - 04. Slipping.flac: Input/output error
mr Epic - Sideways - 04. Slipping.flac: FAILED open or read
sha1sum: mr Epic - Sideways - 05. Ruff and Tumble.flac: Input/output error
mr Epic - Sideways - 05. Ruff and Tumble.flac: FAILED open or read
sha1sum: mr Epic - Sideways - 06. In.flac: Input/output error
mr Epic - Sideways - 06. In.flac: FAILED open or read
sha1sum: mr Epic - Sideways - 07. Out.flac: Input/output error
mr Epic - Sideways - 07. Out.flac: FAILED open or read
sha1sum: WARNING: 7 of 7 listed files could not be read

----
06. Observe "bio too big device dm-0 (256 > 240)" messages in dmesg

[non]# dmesg |tail -n7
[101403.106825] bio too big device dm-0 (256 > 240)
[101403.115228] bio too big device dm-0 (256 > 240)
[101403.115912] bio too big device dm-0 (256 > 240)
[101403.130529] bio too big device dm-0 (256 > 240)
[101403.131220] bio too big device dm-0 (256 > 240)
[101403.141577] bio too big device dm-0 (256 > 240)
[101403.142255] bio too big device dm-0 (256 > 240)

----
07. Run reiserfsck to check for corruptions -- none.

[non]# cd
[non]# umount /mnt/punchbag
[non]# reiserfsck --check /dev/mapper/crypt-punchbag
  [...]
Will read-only check consistency of the filesystem on
/dev/mapper/crypt-punchbag
Will put log info to 'stdout'

Do you want to run this program?[N/Yes] (note need to type Yes if you do):Yes
###########
reiserfsck --check started at Sat Mar 10 19:00:08 2007
###########
Replaying journal..
Reiserfs journal '/dev/mapper/crypt-punchbag' in blocks [18..8211]: 0
transactions replayed
Checking Internal tree...
0%....20%....40%....60%....80%....100%
Checking Semantic tree...
There are on the filesystem:
        Leaves 282
        Internal nodes 3
        Directories 18
        Other files 196
        Data block pointers 268374 (0 of them are zero)
        Safe links 0
No corruptions found
###########
reiserfsck finished at Sat Mar 10 19:00:10 2007
###########

----
08. Migrate logical volume back to SATA disk; sync; flush caches

[non]# mount /dev/mapper/crypt-punchbag /mnt/punchbag -o noatime,barrier=flush
[non]# cd /mnt/punchbag/mp3/mr\ Epic\ -\ Sideways
[non]# pvmove -n punchbag /dev/sdb /dev/sda5
  [...]
  /dev/sdb: Moved: 100.0%
[non]# lvs --segments -o +devices
  LV       VG      Attr   #Str Type   SSize   Devices
  [...]
  punchbag primary -wi-a-    1 linear   1.06G /dev/sda5(0)
  [...]
[non]# sync
[non]# echo 3 > /proc/sys/vm/drop_caches

----
09. Confirm that files are readable and non-corrupt again

[non]# sha1sum -c *.sha1
mr Epic - Sideways - 01. Down Low.flac: OK
mr Epic - Sideways - 02. Blue Days.flac: OK
mr Epic - Sideways - 03. Sift.flac: OK
mr Epic - Sideways - 04. Slipping.flac: OK
mr Epic - Sideways - 05. Ruff and Tumble.flac: OK
mr Epic - Sideways - 06. In.flac: OK
mr Epic - Sideways - 07. Out.flac: OK

----
10. Clean up

[non]# cd
[non]# umount /mnt/punchbag
[non]# cryptsetup remove crypt-punchbag
[non]# lvremove primary/punchbag
Do you really want to remove active logical volume "punchbag"? [y/n]: y
  Logical volume "punchbag" successfully removed

I repeated this five times and each time was able to reproduce the problem.
More details on the symptoms of the problem in my previous problem report:
http://lkml.org/lkml/2007/3/7/657

I'm not subscribed to the list, so please keep me in Cc:.


Regards,
Marti Raudsepp
