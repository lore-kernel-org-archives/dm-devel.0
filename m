From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: device-mapper oops (and more!)
Date: Sat, 12 Feb 2005 12:23:02 +0100
Message-ID: <62b0912f050212032335d2248c@mail.gmail.com>
References: <62b0912f050121080176a120f@mail.gmail.com>
	<62b0912f05012603595aecc351@mail.gmail.com>
	<62b0912f0501290423e6001e5@mail.gmail.com>
	<20050130152511.GF3635@redhat.com>
	<62b0912f0501300744210291@mail.gmail.com>
	<62b0912f05013008035b4508be@mail.gmail.com>
	<20050131102906.GA3471@redhat.com>
	<62b0912f0502010012270dcd50@mail.gmail.com>
	<62b0912f0502010054f46e805@mail.gmail.com>
	<20050201091612.GM3471@redhat.com>
Reply-To: Molle Bestefich <molle.bestefich@gmail.com>,
	Promise Fasttrak / Highpoint 370 driver discussion <ataraid-list@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_1809_30371033.1108207382752"
In-Reply-To: <20050201091612.GM3471@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/ataraid-list>,
	<mailto:ataraid-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/ataraid-list>
List-Post: <mailto:ataraid-list@redhat.com>
List-Help: <mailto:ataraid-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/ataraid-list>,
	<mailto:ataraid-list-request@redhat.com?subject=subscribe>
Sender: ataraid-list-bounces@redhat.com
Errors-To: ataraid-list-bounces@redhat.com
To: hjm@redhat.com, mauelshagen@redhat.com
Cc: ataraid-list@redhat.com, dm-devel@redhat.com
List-Id: dm-devel.ids

------=_Part_1809_30371033.1108207382752
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi

A status update on my experience with dmraid and the device-mapper.

Topics, ranging from "least serious" (1) to most (4):

  1. 'dmraid' and device-mapper target availability
  2. Error message propagation from device-mapper through dmraid to end user
  3. Assembly of mirrors using dmraid
  4. Oops while using dmraid / device-mapper


--__--__--

Topic 1: 'dmraid' and device-mapper target availability

Dmraid does not check for available targets before trying to assemble arrays.

Example:
If I run 'dmraid -ay', dmraid tries to create device-mapper tables
using the 'mirror' target,
even though dmsetup does not list "mirror" support in 'dmsetup targets'.
(The mirror target is not compiled in and there is no dm-mirror.ko available.)


--__--__--

Topic 2: Error message propagation from device-mapper through dmraid to end user

When the device-mapper fails to do something for dmraid, the error
does not get propagated to the end user.
Sometimes there is a follow-on error from dmraid, sometimes there is
no indication at all that something is wrong.
The device-mapper errors, however, is in the syslog, so it should be
possible to show them to the end user?

Examples of device mapper error messages in attached syslog_{1,2}.txt.
Example of follow-on error message from dmraid:

ERROR: dos: reading /dev/mapper/hpt45x_bbdfhdjicg[2]


--__--__--

Topic 3: Assembly of mirrors using dmraid

'dmraid' does not assembly the mirror on a HPT controller correctly.
An error message is provided in the syslog from device-mapper, saying:

device-mapper: device /dev/mapper/hpt45x_bbdfhdjicg too small for target

It seems that dmraid / the device-mapper (dunno which is responsible)
builds a 40 GB mirror, when in fact it should have been 80 GB.  Dmraid
then proceeds to try and add tables (or what's it called?) for the
first partition, which happens to be 60 GB in size, and device-mapper
reports that it has failed to do this, with good reason I might add.

The resulting /dev/mapper/hpt45x_bbdfhdjicg1 device is 0 bytes in
size, so 'mount' etc. of course fails.

How I found out (forgive me, but I think that it's rather clever :-)):

I have two test setups, one where Linux runs directly on the hardware
and one where it runs in a VMware which emulates physical access to
the disks in the system.  Using the direct approach, dmraid and
device-mapper does disk layout.  Using the emulated approach, access
goes through a BusLogic SCSI driver and the Windows drivers for the
HPT controller, so Linux sees the correct disk layout as physical
disks.

'fdisk -l' output from both test environments is attached; check out
the 40 GB vs. 80 GB difference:

device-mapper / dmraid:  Disk /dev/mapper/hpt45x_bbdfhdjicg: 40.0 GB,
40013178368 bytes
Windows HPT374 driver:   Disk /dev/sda: 80.0 GB, 80023749120 bytes


--__--__--

Topic 4: Oops while using dmraid / device-mapper

I got this oops in kmirrord after activating and deactivating randomly
a couple (3-4) times:

livecd root # dmraid -ay
Oops: 0000 [#1]
EIP:    0060:[<c02a1032>]    Not tainted VLI
EFLAGS: 00010246   (2.6.9)
EIP is at find_next_zero_bit+0x82/0xa4
eax: ffffffff   ebx: f8d35000   ecx: 07fffd10   edx: 00000000
esi: 00000000   edi: f8d35000   ebp: ffffa1f2   esp: f7ccbeb0
ds: 007b   es: 007b   ss: 0068
Process kmirrord/0 (pid: 6721, threadinfo=f7cca000 task=dfc01000)
Stack: 00000000 f8d0f000 0012a1f2 f7dc3480 f7ccbef0 f8ca9a21 f8d0f000 0012a1f2
       00130000 c19dfdb0 c19dfd8c c19dfd80 c19dfd8c f8caa507 f74644e0 f7ccbef0
       0012ffff 00000000 c19dfdb0 c19dfd8c c19dfd80 f74644e0 f8caa5c6 c19dfd8c
Call Trace:
 [<f8ca9a21>] core_get_resync_work+0x31/0x80 [dm_mirror]
 [...]

Above is only a snippet; rest of the oops message is attached separately.


--__--__--

I cross-posted this to two mailing lists, since topics 4 and perhaps 2
is probably relevant for device-mapper folks.  Hope it's ok?

------=_Part_1809_30371033.1108207382752
Content-Type: text/plain; name="syslog_1.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename="syslog_1.txt"


Jan 18 19:28:36 livecd device-mapper: : unknown target type
Jan 18 19:28:36 livecd
Jan 18 19:28:36 livecd device-mapper: error adding target to table

------=_Part_1809_30371033.1108207382752
Content-Type: text/plain; name="syslog_2.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename="syslog_2.txt"


Feb 12 11:28:08 livecd device-mapper: 4.1.0-ioctl (2003-12-10) initialised:=
 dm@uk.sistina.com
Feb 12 11:29:25 livecd device-mapper: device /dev/mapper/hpt45x_bbdfhdjicg =
too small for target
Feb 12 11:29:25 livecd device-mapper: : dm-linear: Device lookup failed
Feb 12 11:29:25 livecd
Feb 12 11:29:25 livecd device-mapper: error adding target to table

------=_Part_1809_30371033.1108207382752
Content-Type: text/plain; name="fdisk_l__linux_dm.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename="fdisk_l__linux_dm.txt"


Disk /dev/mapper/hpt45x_bbdfhdjicg: 40.0 GB, 40013178368 bytes
255 heads, 63 sectors/track, 4864 cylinders
Units =3D cylinders of 16065 * 512 =3D 8225280 bytes

                        Device Boot      Start         End      Blocks   Id=
  System
/dev/mapper/hpt45x_bbdfhdjicg1               1        7833    62918541    c=
  W95 FAT32 (LBA)

------=_Part_1809_30371033.1108207382752
Content-Type: text/plain; name="fdisk_l__windows_driver.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename="fdisk_l__windows_driver.txt"


Disk /dev/sda: 80.0 GB, 80023749120 bytes
255 heads, 63 sectors/track, 9729 cylinders
Units =3D cylinders of 16065 * 512 =3D 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1               1        7833    62918541    c  W95 FAT32 (LBA)

------=_Part_1809_30371033.1108207382752
Content-Type: text/plain; name="oops.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename="oops.txt"

livecd root # dmraid -ay
Oops: 0000 [#1]
Modules linked in: dm_mirror dm_mod vfat fat uhci_hcd snd_intel8x0 snd_ac97=
_codec snd_pcm snd_timer snd_page_alloc gameport snd_mpu401_uart snd_rawmid=
i snd_seq_device snd intel_agp agpgart tg3 parport_pc parport sbp2 ohci1394=
 ieee1394 ohci_hcd usb_storage
usbhid ehci_hcd usbcore
CPU:    0
EIP:    0060:[<c02a1032>]    Not tainted VLI
EFLAGS: 00010246   (2.6.9)
EIP is at find_next_zero_bit+0x82/0xa4
eax: ffffffff   ebx: f8d35000   ecx: 07fffd10   edx: 00000000
esi: 00000000   edi: f8d35000   ebp: ffffa1f2   esp: f7ccbeb0
ds: 007b   es: 007b   ss: 0068
Process kmirrord/0 (pid: 6721, threadinfo=3Df7cca000 task=3Ddfc01000)
Stack: 00000000 f8d0f000 0012a1f2 f7dc3480 f7ccbef0 f8ca9a21 f8d0f000 0012a=
1f2
       00130000 c19dfdb0 c19dfd8c c19dfd80 c19dfd8c f8caa507 f74644e0 f7ccb=
ef0
       0012ffff 00000000 c19dfdb0 c19dfd8c c19dfd80 f74644e0 f8caa5c6 c19df=
d8c
Call Trace:
 [<f8ca9a21>] core_get_resync_work+0x31/0x80 [dm_mirror]
 [<f8caa507>] __rh_recovery_prepare+0x17/0xb0 [dm_mirror]
 [<f8caa5c6>] rh_recovery_prepare+0x26/0x50 [dm_mirror]
 [<f8caa914>] do_recovery+0x14/0x80 [dm_mirror]
 [<f8caae20>] do_work+0x0/0x70 [dm_mirror]
 [<f8caadfe>] do_mirror+0x4e/0x70 [dm_mirror]
 [<f8caae56>] do_work+0x36/0x70 [dm_mirror]
 [<c012c43b>] worker_thread+0x17b/0x220
 [<c011c200>] default_wake_function+0x0/0x20
 [<c03cddbc>] schedule+0x27c/0x480
 [<c011c200>] default_wake_function+0x0/0x20
 [<c012c2c0>] worker_thread+0x0/0x220
 [<c012fd53>] kthread+0xa3/0xb0
 [<c012fcb0>] kthread+0x0/0xb0
 [<c0104265>] kernel_thread_helper+0x5/0x10
Code: 76 00 8d bc 27 00 00 00 00 89 04 24 83 c7 04 89 f8 29 f0 c1 e0 03 31 =
f6 29 c5 74 25 8d 4d 1f c1 e9 05 89 fb b8 ff ff ff ff 31 d2 <f3> af 74 09 3=
3 47 fc 83 ef 04 0f bc d0 29 df c1 e7 03 01 fa 89
 <4>device-mapper: device /dev/mapper/hpt45x_bbdfhdjicg too small for targe=
t
device-mapper: : dm-linear: Device lookup failed

device-mapper: error adding target to table


------=_Part_1809_30371033.1108207382752
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Ataraid-list mailing list
Ataraid-list@redhat.com
https://www.redhat.com/mailman/listinfo/ataraid-list
------=_Part_1809_30371033.1108207382752--
