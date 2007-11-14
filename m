From: "Vega Forneris" <vega.forneris@sic.rm.cnr.it>
Subject: R: R: - info about dm
Date: Wed, 14 Nov 2007 11:57:55 +0100
Message-ID: <000001c826ad$36067650$27819296@wegaprise>
References: <4739EB5A.9050102@cfl.rr.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4739EB5A.9050102@cfl.rr.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: 'device-mapper development' <dm-devel@redhat.com>, "'ATARAID (eg, Promise Fasttrak,  Highpoint 370) related discussions'" <ataraid-list@redhat.com>
List-Id: dm-devel.ids

Hi Phillip,

Thanks for the answer

>> Yes... at least if your bios actually starts the rebuild process
instead=20
>> of just marking the array as needing rebuilt and relying on the OS to
do=20
>> it.

...well I have to test it: during the installation procedures, when I
tried to configure this damn RAID and I got the disk inconsistency
(=93ERROR:
asr: Invalid RAID config table checksum on /dev/sda=94 or =93asr: Invalid
magic number in RAID table; saw 0x0 expected=85=94) I tested even the
rebuilding through the BIOS with no results, while I'm sure the
rebuilding works (tested with working HD)...bah, maybe the rebuilding
was not completed and I had to wait a little longer...

Can you specify which commands are used for creating the device
(manually) the first time? I used "dmsetup create" but someone replied
that dmsetup is a debug command rather than the correct procedure.=20
Let me repeat ("repetita juvant": latin proverb ;-P): DM simply
recognize a BIOS RAID configuration and translate it to the system,
mapping it to a virtual device...so all I need is to launch "dmraid -ay"
for activating...

One last question, about the development: are they working for having a
way to "manage" RAID through DM? I'm talking above all about stopping
the RAID, disabling disks, rebuilding the RAID...

Thanks again for all the support
Vega



-----Messaggio originale-----
Da: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] Per
conto di Phillip Susi
Inviato: marted=EC 13 novembre 2007 19.22
A: ATARAID (eg, Promise Fasttrak, Highpoint 370) related discussions
Cc: 'device-mapper development'
Oggetto: Re: R: [dm-devel] - info about dm

Vega Forneris wrote:
> 1) I need to change an HD which has problems...here the steps I guess
> from what I read in these days:
> - halt the machine (ok, ok it's obvious ;-P )
> - change the faulty HD
> - boot
> - when BIOS starts the RAID manager, enter and rebuild the RAID (1:
> mirror)
> - after the rebuilding, everything should be ok.
>=20
> ...is it correct?

Yes... at least if your bios actually starts the rebuild process instead

of just marking the array as needing rebuilt and relying on the OS to do

it.

> 2) I have a machine with 2 HD SATA, on the first we have the OS
> installed (and working!), the second is blank (just added), I want to
> create a RAID 1 (mirror) of the whole disk:
> - ...
> I don't want to guess ;-P

The same way you did it the first time: in the bios.  Doing so will=20
destroy the existing data on the drive though, so you will want to=20
backup first.

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
