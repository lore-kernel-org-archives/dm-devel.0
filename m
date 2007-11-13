From: "Vega Forneris" <vega.forneris@sic.rm.cnr.it>
Subject: R: - info about dm
Date: Tue, 13 Nov 2007 16:52:12 +0100
Message-ID: <003d01c8260d$27a8e6b0$27819296@wegaprise>
References: <4738C28C.1090300@cfl.rr.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4738C28C.1090300@cfl.rr.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: 'device-mapper development' <dm-devel@redhat.com>, ataraid-list@redhat.com
List-Id: dm-devel.ids

Dear Philip, Sean and all,

First of all I apologize for what I wrote: I recognize that's not
clear...

However at the moment I cannot reproduce the error because I solved the
issue through a workaround and I (stupid) didn't save any log of that.

Instead of trying to explain better what I wrote (in a mess!!!), can you
explain how to work with dmraid? Is there any official HowTo?
Man pages don't give us a step by step procedure and that's what I need
now

Some info about the machines:
HW: IBM x306 - 2 HD 160GB SATA - Adaptec HostRAID ASR (onboard)

# dmraid -tay
cl->raidtype=3D1 rd_type=3D64
cl->raidtype=3D1 rd_type=3D64
cl->raidtype=3D1 rd_type=3D64
cl->raidtype=3D1 rd_type=3D64
asr_: 0 312580096 mirror core 2 131072 nosync 2 /dev/sda 0 /dev/sdb 0
asr_1: 0 71681967 linear /dev/mapper/asr_ 63
asr_2: 0 4096575 linear /dev/mapper/asr_ 71682030
asr_3: 0 236798100 linear /dev/mapper/asr_ 75778605

# dmraid -r
cl->raidtype=3D1 rd_type=3D64
cl->raidtype=3D1 rd_type=3D64
/dev/sda: asr, "asr_", mirror, ok, 312580096 sectors, data@ 0
/dev/sdb: asr, "asr_", mirror, ok, 312580096 sectors, data@ 0

# dmsetup status
asr_p1: 0 71681967 linear=20
asr_: 0 312580096 mirror 2 8:0 8:16 2385/2385 1 AA 1 core
asr_p3: 0 236798100 linear=20
asr_p2: 0 4096575 linear=20

# dmsetup ls
asr_p1  (253, 1)
asr_    (253, 0)
asr_p3  (253, 3)
asr_p2  (253, 2)

Let's handle a couple of doubts I have:

1) I need to change an HD which has problems...here the steps I guess
from what I read in these days:
- halt the machine (ok, ok it's obvious ;-P )
- change the faulty HD
- boot
- when BIOS starts the RAID manager, enter and rebuild the RAID (1:
mirror)
- after the rebuilding, everything should be ok.

...is it correct?

2) I have a machine with 2 HD SATA, on the first we have the OS
installed (and working!), the second is blank (just added), I want to
create a RAID 1 (mirror) of the whole disk:
- ...
I don't want to guess ;-P

I know how to manage grub for booting from the new device, but I'm not
sure how to create such device...

Any tip is welcome!

Cheers and thanks
Vega

-----Messaggio originale-----
Da: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] Per
conto di Phillip Susi
Inviato: luned=EC 12 novembre 2007 22.16
A: dm-devel@redhat.com; ataraid-list@redhat.com
Oggetto: Re: [dm-devel] - info about dm

Luca Berra wrote:
>> Anyway, I found a little problematic configuring it manually: I tried
to
>> install SL5 on a node which was misconfigured: instead of seeing one
>> device, it was managing the 2 HD (/dev/sda and /dev/sdb) as 2
separate

This is as expected.  The hardware is just a sata controller with two=20
disks attached, so that is what the kernel sees.  dmraid is used to=20
recognize the bios information on the disk and configure the device=20
mapper driver to create a raid virtual device.

>> devices an if I tried to configure them (at install time, via CD or
>> network boot) with  DM, I got many errors about the RAID table
(=93ERROR:
>> asr: Invalid RAID config table checksum on /dev/sda=94 or even =93asr:
>> Invalid magic number in RAID table; saw 0x0 expected=85=94). I tried t=
o
>> reconfigure the RAID card first via BIOS and then trying again to
>> configure it via Linux (=93dmsetup create =85=94) but even if it seeme=
d

dmsetup create creates a new dm device.  Generally this command is for=20
debugging and testing, so you should not use it.  It has nothing to do=20
with dmraid other than they are both clients of the device mapper kernel

driver.

>> working (exit code 0), then querying the device asr_ (i.e. =93dmraid
=96r=94)
>> resulted in errors as reported above=85or better, dmraid commands (-r,
>> -ay, -tay,=85) reported errors, while dmsetup commands  (status, ls,=85=
)

What where the exact commands and errors the generated?

I am also confused because the first thing you said was that the system=20
DID correctly recognize the raid array as /dev/mapper/asr_xxxx.

>> 2) Managing disks
>> I configured disks in RAID 1 (mirror) but I wonder how to manage this
>> RAID; in particular, how can I do for:
>> - stopping a device (disk) and put it offline/and viceversa? -=20
>> reconfiguring/rebuilding it (due to broken/faulting HD)?
>> At the moment I should change a couple of disks (SMARTD warnings
>> reported), but I=92m scared about the =93RAID table error=94=85

Currently the only way is to do so in the bios.  Some systems the bios=20
will begin rebuilding when you tell it to, and you need to wait for it=20
to finish.  On others, it only marks the disk as needing rebuilt and=20
relies on the windows driver to do the rebuilding.  Currently dmraid=20
does not perform rebuilding.


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
