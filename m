From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: - info about dm
Date: Mon, 12 Nov 2007 16:15:56 -0500
Message-ID: <4738C28C.1090300@cfl.rr.com>
References: <00c401c82145$5a337180$27819296@wegaprise>
	<20071109163746.GB15775@percy.comedia.it>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20071109163746.GB15775@percy.comedia.it>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, ataraid-list@redhat.com
List-Id: dm-devel.ids

Luca Berra wrote:
>> Anyway, I found a little problematic configuring it manually: I tried =
to
>> install SL5 on a node which was misconfigured: instead of seeing one
>> device, it was managing the 2 HD (/dev/sda and /dev/sdb) as 2 separate

This is as expected.  The hardware is just a sata controller with two=20
disks attached, so that is what the kernel sees.  dmraid is used to=20
recognize the bios information on the disk and configure the device=20
mapper driver to create a raid virtual device.

>> devices an if I tried to configure them (at install time, via CD or
>> network boot) with  DM, I got many errors about the RAID table (=93ERR=
OR:
>> asr: Invalid RAID config table checksum on /dev/sda=94 or even =93asr:
>> Invalid magic number in RAID table; saw 0x0 expected=85=94). I tried t=
o
>> reconfigure the RAID card first via BIOS and then trying again to
>> configure it via Linux (=93dmsetup create =85=94) but even if it seeme=
d

dmsetup create creates a new dm device.  Generally this command is for=20
debugging and testing, so you should not use it.  It has nothing to do=20
with dmraid other than they are both clients of the device mapper kernel=20
driver.

>> working (exit code 0), then querying the device asr_ (i.e. =93dmraid =96=
r=94)
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
