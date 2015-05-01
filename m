From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Regression: Disk corruption with dm-crypt and kernels >= 4.0
Date: Fri, 1 May 2015 17:17:03 -0400
Message-ID: <20150501211703.GA15030@redhat.com>
References: <1430455027.7012.32.camel@memnix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1430455027.7012.32.camel@memnix.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Abelardo Ricart III <aricart@memnix.com>
Cc: dm-devel@redhat.com, mpatocka@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Fri, May 01 2015 at 12:37am -0400,
Abelardo Ricart III <aricart@memnix.com> wrote:

> I made sure to run a completely vanilla kernel when testing why I was=
 suddenly
> seeing some nasty libata errors with all kernels >=3D v4.0. Here's a =
snippet:
>=20
> -------------------->8--------------------
> [  165.592136] ata5.00: exception Emask 0x60 SAct 0x7000 SErr 0x800 a=
ction 0x6
> frozen
> [  165.592140] ata5.00: irq_stat 0x20000000, host bus error
> [  165.592143] ata5: SError: { HostInt }
> [  165.592145] ata5.00: failed command: READ FPDMA QUEUED
> [  165.592149] ata5.00: cmd 60/08:60:a0:0d:89/00:00:07:00:00/40 tag 1=
2 ncq 4096
> in
>                         res 40/00:74:40:58:5d/00:00:00:00:00/40 Emask=
 0x60
> (host bus error)
> [  165.592151] ata5.00: status: { DRDY }
> -------------------->8--------------------
>=20
> After a few dozen of these errors, I'd suddenly find my system in rea=
d-only
> mode with corrupted files throughout my encrypted filesystems (seemed=
 like
> either a read or a write would corrupt a file, though I could be mist=
aken). I
> decided to do a git bisect with a random read-write-sync test to narr=
ow down
> the culprit, which turned out to be this commit (part of a series):
>=20
> # first bad commit: [cf2f1abfbd0dba701f7f16ef619e4d2485de3366] dm cry=
pt: don't
> allocate pages for a partial request
>=20
> Just to be sure, I created a patch to revert the entire nine patch se=
ries that
> commit belonged to... and the bad behavior disappeared. I've now been=
 running
> kernel 4.0 for a few days without issue, and went so far as to stress=
 test my
> poor SSD for a few hours to be 100% positive.
>=20
> Here's some more info on my setup.
>=20
> -------------------->8--------------------
> $ lsblk -f
> NAME         FSTYPE      LABEL MOUNTPOINT
> sda                 =20
> =E2=94=9C=E2=94=80sda1       vfat              /boot/EFI
> =E2=94=9C=E2=94=80sda2       ext4              /boot
> =E2=94=94=E2=94=80sda3       LVM2_member
>   =E2=94=9C=E2=94=80SSD-root crypto_LUKS
>   =E2=94=82 =E2=94=94=E2=94=80root   f2fs              /
>   =E2=94=94=E2=94=80SSD-home crypto_LUKS
>     =E2=94=94=E2=94=80home   f2fs              /home
>=20
> $ cat /proc/cmdline
> BOOT_IMAGE=3D/vmlinuz-linux-memnix cryptdevice=3D/dev/SSD/root:root:a=
llow-discards
> root=3D/dev/mapper/root acpi_osi=3DLinux security=3Dtomoyo
> TOMOYO_trigger=3D/usr/lib/systemd/systemd intel_iommu=3Don
> modprobe.blacklist=3Dnouveau rw quiet
>=20
> $ cat /etc/lvm/lvm.conf | grep "issue_discards"
> issue_discards =3D 1
> -------------------->8--------------------
>=20
> If there's anything else I can do to help diagnose the underlying pro=
blem, I'm
> more than willing.

The patchset in question was tested quite heavily so this is a
surprising report.  I'm noticing you are opting in to dm-crypt discard
support.  Have you tested without discards enabled?
