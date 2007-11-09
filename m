From: Luca Berra <bluca@comedia.it>
Subject: Re: [dm-devel] - info about dm
Date: Fri, 9 Nov 2007 17:37:46 +0100
Message-ID: <20071109163746.GB15775@percy.comedia.it>
References: <00c401c82145$5a337180$27819296@wegaprise>
Reply-To: "ATARAID (eg, Promise Fasttrak,  Highpoint 370) related discussions" <ataraid-list@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <ataraid-list-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <00c401c82145$5a337180$27819296@wegaprise>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/ataraid-list>,
	<mailto:ataraid-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/ataraid-list>
List-Post: <mailto:ataraid-list@redhat.com>
List-Help: <mailto:ataraid-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/ataraid-list>,
	<mailto:ataraid-list-request@redhat.com?subject=subscribe>
Sender: ataraid-list-bounces@redhat.com
Errors-To: ataraid-list-bounces@redhat.com
To: dm-devel@redhat.com
Cc: ataraid-list@redhat.com
List-Id: dm-devel.ids

Vega,
you should probably address dmraid related question to the ataraid
mailing list.
i am cc-ing the mentioned list, and doing a full quote for that reason


On Wed, Nov 07, 2007 at 02:51:52PM +0100, Vega Forneris wrote:
>Dear all,
>
>I just installed Scientific Linux 5 and I used for the first time DM
>drivers for working with the embedded RAID (the servers are IBM xSeries,
>with an Adaptec HostRAID ASR - SATA). I really appreciate the fact that
>now Linux is able to recognize such devices, but I had some troubles
>configuring it and I=92d like to have some info for better understanding
>how things work.=20
>
>I=92ll be a little =93verbose=94 for clarifying what I did and which are=
 my
>doubts=85
>
>1) Installation & Configuration
>I installed SL5 on a system which was running SL3 with HW drivers
>released by IBM. Linux was able to identify correctly the device
>(installed through CD), mapped it as /dev/mapper/asr_ and proceeded with
>he installation.
>
>Anyway, I found a little problematic configuring it manually: I tried to
>install SL5 on a node which was misconfigured: instead of seeing one
>device, it was managing the 2 HD (/dev/sda and /dev/sdb) as 2 separate
>devices an if I tried to configure them (at install time, via CD or
>network boot) with  DM, I got many errors about the RAID table (=93ERROR=
:
>asr: Invalid RAID config table checksum on /dev/sda=94 or even =93asr:
>Invalid magic number in RAID table; saw 0x0 expected=85=94). I tried to
>reconfigure the RAID card first via BIOS and then trying again to
>configure it via Linux (=93dmsetup create =85=94) but even if it seemed
>working (exit code 0), then querying the device asr_ (i.e. =93dmraid =96=
r=94)
>resulted in errors as reported above=85or better, dmraid commands (-r,
>-ay, -tay,=85) reported errors, while dmsetup commands  (status, ls,=85)
>worked normally. The only way I found for well-configuring the device
>was to install SL3 with specific drivers, and then to install SL5 with
>DM=85both commands now work perfectly
>
>In brief:
>
>If I try to configure DM-RAID from scratch and I get such errors, how
>can I do? What=92s that =93RAID table=94? Where is it written? Not in th=
e MBR
>of an HD, =91cause I tried to copy the MBR of the cloned disk which had =
no
>problem (still recognized as =93good=94 for RAID and DM) and nothing
>changed=85
>
>2) Managing disks
>I configured disks in RAID 1 (mirror) but I wonder how to manage this
>RAID; in particular, how can I do for:
> - stopping a device (disk) and put it offline/and viceversa?=20
> - reconfiguring/rebuilding it (due to broken/faulting HD)?=20
>
>At the moment I should change a couple of disks (SMARTD warnings
>reported), but I=92m scared about the =93RAID table error=94=85
>
>Many Thanks in advance for all help you can give me=85
>
>Best Regards
>Vega Forneris
>
>+--------------------------------------+
>=A0Vega Forneris
>
>=A0CNR =96 Servizi Informatici di Campo
>=A0Gestione servizi GRID
>
>=A0Area di Ricerca Roma II - Tor Vergata
>=A0Via del Fosso del Cavaliere, 100
>=A000133 Roma
>
>=A0Tel:=A0 =A0+39 06 4993 4667
>=A0Fax:=A0=A0 +39 06 4993 4650
>=A0Email: Vega.Forneris@sic.rm.cnr.it
>+--------------------------------------+
>
>
>
>--
>dm-devel mailing list
>dm-devel@redhat.com
>https://www.redhat.com/mailman/listinfo/dm-devel

--=20
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
