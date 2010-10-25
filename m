From: "Ulrich Windl" <Ulrich.Windl-LOEJiUoeGm199bV2EpccEXqWYbMAw+HU@public.gmane.org>
Subject: Antw: Re: Q: md-RAID1 creation with I/O error (attempt to
 access beyond end of device)
Date: Mon, 25 Oct 2010 08:25:52 +0200
Message-ID: <4CC53F10020000A1000109FD@gwsmtp1.uni-regensburg.de>
References: <4CC03D24020000A100010898@gwsmtp1.uni-regensburg.de>
 <AANLkTineg_wHmd_es91=aGpr-bRLBp=xNikiO7i8MWBV@mail.gmail.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <open-iscsi+bncCLzCps7fBhD2xZTmBBoECczLSw-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <AANLkTineg_wHmd_es91=aGpr-bRLBp=xNikiO7i8MWBV-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post?hl=en_US>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/?hl=en_US>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi?hl=en_US>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
 <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
 <mailto:open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Content-Disposition: inline
To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Cc: dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

>>> Rahsaan Page <rahsaan.page-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> schrieb am 22.10.2010 um 14:46 in
Nachricht <AANLkTineg_wHmd_es91=3DaGpr-bRLBp=3DxNikiO7i8MWBV-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org=
>:
> Hi Ulrich,
>=20
> I dont think thats going to work, arent you suppose to create the raid wi=
th
> xdisk, than create LVM on top of the raid?

Hi!

I never heard of "xdisk". Also I decided to use MD for RAID, and not LVM, b=
ecause the Linux implementation needs a third device to handle the mirror l=
og, while MD can host a bitmap on the members itself. In my setup I'd parti=
tion the MD-device, then create an LVM physical volume in one of the partit=
ions...

Regards,
Ulrich


>=20
> On Thu, Oct 21, 2010 at 7:16 AM, Ulrich Windl <
> Ulrich.Windl-LOEJiUoeGm199bV2EpccEXqWYbMAw+HU@public.gmane.org> wrote:
>=20
> > Hi,
> >
> > not an iSCSI question, but maybe here's the right audience: I had
> > sucessfully created a RAID1 using mdadm, multipath, iSCSI and some SAN
> > storage on SLES10 SP3+Updates on x86_64. When I tried to do the same th=
ing
> > on a comparable machine, the RAID could not be created, because somethi=
ng
> > tried to access the disk at a bad position. I reapeated the attempt wit=
h
> > another set of disks of the same size, and it also failed.
> >
> > Details:
> > # mdadm --verbose --create /dev/md5 --raid-devices=3D2 --level=3Draid1
> > --bitmap=3Dinternal --assume-clean /dev/mapper/EVA1_L232_host05
> > /dev/mapper/EVA2_L232_host05
> > mdadm: /dev/mapper/EVA1_L232_host05 appears to be part of a raid array:
> >    level=3Draid1 devices=3D2 ctime=3DThu Oct 21 12:26:18 2010
> > mdadm: /dev/mapper/EVA2_L232_host05 appears to be part of a raid array:
> >    level=3Draid1 devices=3D2 ctime=3DThu Oct 21 12:26:18 2010
> > mdadm: size set to 31457216K
> > Continue creating array? y
> > mdadm: RUN_ARRAY failed: Input/output error
> > mdadm: stopped /dev/md5
> > hostname:~ # tail -24 /var/log/messages
> >     Oct 21 12:28:05 hostname kernel: md: md5 stopped.
> > Oct 21 12:28:07 hostname kernel: md: md5 stopped.
> > Oct 21 12:29:46 hostname kernel: md: bind<dm-21>
> > Oct 21 12:29:46 hostname kernel: md: bind<dm-14>
> > Oct 21 12:29:46 hostname kernel: raid1: raid set md5 active with 2 out =
of 2
> > mirrors
> > Oct 21 12:29:46 hostname kernel: md5: bitmap file is out of date (0 < 1=
) --
> > forcing full recovery
> > Oct 21 12:29:46 hostname kernel: md5: bitmap file is out of date, doing
> > full recovery
> > Oct 21 12:29:46 hostname kernel: attempt to access beyond end of device
> > Oct 21 12:29:46 hostname kernel: dm-14: rw=3D8, want=3D62914568, limit=
=3D62914560
> > Oct 21 12:29:46 hostname kernel: attempt to access beyond end of device
> > Oct 21 12:29:46 hostname kernel: dm-21: rw=3D8, want=3D62914568, limit=
=3D62914560
> > Oct 21 12:29:46 hostname kernel: md5: bitmap initialized from disk: rea=
d
> > 15/16 pages, set 489472 bits, status: -5
> > Oct 21 12:29:46 hostname kernel: md5: failed to create bitmap (-5)
> > Oct 21 12:29:46 hostname kernel: md: pers->run() failed ...
> > Oct 21 12:29:46 hostname kernel: md: md5 stopped.
> > Oct 21 12:29:46 hostname kernel: md: unbind<dm-14>
> > Oct 21 12:29:46 hostname kernel: md: export_rdev(dm-14)
> > Oct 21 12:29:46 hostname kernel: md: unbind<dm-21>
> > Oct 21 12:29:46 hostname kernel: md: export_rdev(dm-21)
> >
> > hostname:~ # mdadm --query -X /dev/mapper/EVA2_L232_host05
> > mdadm: WARNING: bitmap file is not large enough for array size 62914432=
!
> >
> >        Filename : /dev/mapper/EVA2_L232_host05
> >           Magic : 6d746962
> >         Version : 4
> >            UUID : c522ab5a:24f292a0:0b3d7356:64ade12a
> >          Events : 0
> >  Events Cleared : 0
> >           State : Out of date
> >       Chunksize : 64 KB
> >          Daemon : 5s flush period
> >      Write Mode : Normal
> >       Sync Size : 31457216 (30.00 GiB 32.21 GB)
> >          Bitmap : 489472 bits (chunks), 489472 dirty (100.0%)
> > hostname:~ # mdadm --query -X /dev/mapper/EVA1_L232_host05
> > mdadm: WARNING: bitmap file is not large enough for array size 62914432=
!
> >
> >        Filename : /dev/mapper/EVA1_L232_host05
> >           Magic : 6d746962
> >         Version : 4
> >            UUID : c522ab5a:24f292a0:0b3d7356:64ade12a
> >          Events : 0
> >  Events Cleared : 0
> >           State : Out of date
> >       Chunksize : 64 KB
> >          Daemon : 5s flush period
> >      Write Mode : Normal
> >       Sync Size : 31457216 (30.00 GiB 32.21 GB)
> >          Bitmap : 489472 bits (chunks), 489472 dirty (100.0%)
> >
> > "blockdev --getsize" reports "62914560" for each LUN being used.
> >
> > Regards,
> > Ulrich
> >
> >
> > --
> > You received this message because you are subscribed to the Google Grou=
ps
> > "open-iscsi" group.
> > To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
> > To unsubscribe from this group, send email to
> >=20
> open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org<open-iscsi%2Bunsubscribe@googlegr=
oups.c=20
>om>
> > .
> > For more options, visit this group at
> > http://groups.google.com/group/open-iscsi?hl=3Den.
> >
> >
>=20



=20

--=20
You received this message because you are subscribed to the Google Groups "=
open-iscsi" group.
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To unsubscribe from this group, send email to open-iscsi+unsubscribe@google=
groups.com.
For more options, visit this group at http://groups.google.com/group/open-i=
scsi?hl=3Den.
