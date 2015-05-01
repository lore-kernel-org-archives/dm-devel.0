From: Abelardo Ricart III <aricart@memnix.com>
Subject: Re: Regression: Disk corruption with dm-crypt and kernels >= 4.0
Date: Fri, 01 May 2015 19:42:15 -0400
Message-ID: <1430523735.5352.1.camel@memnix.com>
References: <1430455027.7012.32.camel@memnix.com>
	 <20150501211703.GA15030@redhat.com> <1430519090.5537.4.camel@memnix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1430519090.5537.4.camel@memnix.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, mpatocka@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Fri, 2015-05-01 at 18:24 -0400, Abelardo Ricart III wrote:
> On Fri, 2015-05-01 at 17:17 -0400, Mike Snitzer wrote:
> > On Fri, May 01 2015 at 12:37am -0400,
> > Abelardo Ricart III <aricart@memnix.com> wrote:
> >=20
> > > I made sure to run a completely vanilla kernel when testing why I=
 was=20
> > > suddenly
> > > seeing some nasty libata errors with all kernels >=3D v4.0. Here'=
s a=20
> > > snippet:
> > >=20
> > > -------------------->8--------------------
> > > [  165.592136] ata5.00: exception Emask 0x60 SAct 0x7000 SErr 0x8=
00=20
> > > action=20
> > > 0x6
> > > frozen
> > > [  165.592140] ata5.00: irq_stat 0x20000000, host bus error
> > > [  165.592143] ata5: SError: { HostInt }
> > > [  165.592145] ata5.00: failed command: READ FPDMA QUEUED
> > > [  165.592149] ata5.00: cmd 60/08:60:a0:0d:89/00:00:07:00:00/40 t=
ag 12=20
> > > ncq=20
> > > 4096
> > > in
> > >                         res 40/00:74:40:58:5d/00:00:00:00:00/40 E=
mask 0x60
> > > (host bus error)
> > > [  165.592151] ata5.00: status: { DRDY }
> > > -------------------->8--------------------
> > >=20
> > > After a few dozen of these errors, I'd suddenly find my system in=
 read
> > > -only
> > > mode with corrupted files throughout my encrypted filesystems (se=
emed like
> > > either a read or a write would corrupt a file, though I could be=20
> > > mistaken).=20
> > > I
> > > decided to do a git bisect with a random read-write-sync test to =
narrow=20
> > > down
> > > the culprit, which turned out to be this commit (part of a series=
):
> > >=20
> > > # first bad commit: [cf2f1abfbd0dba701f7f16ef619e4d2485de3366] dm=
 crypt:=20
> > > don't
> > > allocate pages for a partial request
> > >=20
> > > Just to be sure, I created a patch to revert the entire nine patc=
h series=20
> > > that
> > > commit belonged to... and the bad behavior disappeared. I've now =
been=20
> > > running
> > > kernel 4.0 for a few days without issue, and went so far as to st=
ress=20
> > > test=20
> > > my
> > > poor SSD for a few hours to be 100% positive.
> > >=20
> > > Here's some more info on my setup.
> > >=20
> > > -------------------->8--------------------
> > > $ lsblk -f
> > > NAME         FSTYPE      LABEL MOUNTPOINT
> > > sda                 =20
> > > =E2=94=9C=E2=94=80sda1       vfat              /boot/EFI
> > > =E2=94=9C=E2=94=80sda2       ext4              /boot
> > > =E2=94=94=E2=94=80sda3       LVM2_member
> > >   =E2=94=9C=E2=94=80SSD-root crypto_LUKS
> > >   =E2=94=82 =E2=94=94=E2=94=80root   f2fs              /
> > >   =E2=94=94=E2=94=80SSD-home crypto_LUKS
> > >     =E2=94=94=E2=94=80home   f2fs              /home
> > >=20
> > > $ cat /proc/cmdline
> > > BOOT_IMAGE=3D/vmlinuz-linux-memnix cryptdevice=3D/dev/SSD/root:ro=
ot:allow
> > > -discards
> > > root=3D/dev/mapper/root acpi_osi=3DLinux security=3Dtomoyo
> > > TOMOYO_trigger=3D/usr/lib/systemd/systemd intel_iommu=3Don
> > > modprobe.blacklist=3Dnouveau rw quiet
> > >=20
> > > $ cat /etc/lvm/lvm.conf | grep "issue_discards"
> > > issue_discards =3D 1
> > > -------------------->8--------------------
> > >=20
> > > If there's anything else I can do to help diagnose the underlying=
=20
> > > problem,=20
> > > I'm
> > > more than willing.
> >=20
> > The patchset in question was tested quite heavily so this is a
> > surprising report.  I'm noticing you are opting in to dm-crypt disc=
ard
> > support.  Have you tested without discards enabled?
>=20
> I've disabled discards universally and rebuilt a vanilla kernel. Afte=
r running
> my heavy read-write-sync scripts, everything seems to be working fine=
 now. I
> suppose this could be something that used to fail silently before, bu=
t now
> produces bad behavior? I seem to remember having something in my mess=
age log
> about "discards not supported on this device" when running with it en=
abled
> before.

=46orgive me, but I spoke too soon. The corruption and libata errors ar=
e still
there, as was evidenced when I went to reboot and got treated to an eye=
 full of
"read-only filesystem" and ata errors.

So no, disabling discards unfortunately did nothing to help.
