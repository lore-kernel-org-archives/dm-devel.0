From: Abelardo Ricart III <aricart@memnix.com>
Subject: Regression: Disk corruption with dm-crypt and kernels >= 4.0
Date: Fri, 01 May 2015 00:37:07 -0400
Message-ID: <1430455027.7012.32.camel@memnix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: dm-devel@redhat.com
Cc: mpatocka@redhat.com, snitzer@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

I made sure to run a completely vanilla kernel when testing why I was s=
uddenly
seeing some nasty libata errors with all kernels >=3D v4.0. Here's a sn=
ippet:

-------------------->8--------------------
[  165.592136] ata5.00: exception Emask 0x60 SAct 0x7000 SErr 0x800 act=
ion 0x6
frozen
[  165.592140] ata5.00: irq_stat 0x20000000, host bus error
[  165.592143] ata5: SError: { HostInt }
[  165.592145] ata5.00: failed command: READ FPDMA QUEUED
[  165.592149] ata5.00: cmd 60/08:60:a0:0d:89/00:00:07:00:00/40 tag 12 =
ncq 4096
in
                        res 40/00:74:40:58:5d/00:00:00:00:00/40 Emask 0=
x60
(host bus error)
[  165.592151] ata5.00: status: { DRDY }
-------------------->8--------------------

After a few dozen of these errors, I'd suddenly find my system in read-=
only
mode with corrupted files throughout my encrypted filesystems (seemed l=
ike
either a read or a write would corrupt a file, though I could be mistak=
en). I
decided to do a git bisect with a random read-write-sync test to narrow=
 down
the culprit, which turned out to be this commit (part of a series):

# first bad commit: [cf2f1abfbd0dba701f7f16ef619e4d2485de3366] dm crypt=
: don't
allocate pages for a partial request

Just to be sure, I created a patch to revert the entire nine patch seri=
es that
commit belonged to... and the bad behavior disappeared. I've now been r=
unning
kernel 4.0 for a few days without issue, and went so far as to stress t=
est my
poor SSD for a few hours to be 100% positive.

Here's some more info on my setup.

-------------------->8--------------------
$ lsblk -f
NAME         FSTYPE      LABEL MOUNTPOINT
sda                 =20
=E2=94=9C=E2=94=80sda1       vfat              /boot/EFI
=E2=94=9C=E2=94=80sda2       ext4              /boot
=E2=94=94=E2=94=80sda3       LVM2_member
  =E2=94=9C=E2=94=80SSD-root crypto_LUKS
  =E2=94=82 =E2=94=94=E2=94=80root   f2fs              /
  =E2=94=94=E2=94=80SSD-home crypto_LUKS
    =E2=94=94=E2=94=80home   f2fs              /home

$ cat /proc/cmdline
BOOT_IMAGE=3D/vmlinuz-linux-memnix cryptdevice=3D/dev/SSD/root:root:all=
ow-discards
root=3D/dev/mapper/root acpi_osi=3DLinux security=3Dtomoyo
TOMOYO_trigger=3D/usr/lib/systemd/systemd intel_iommu=3Don
modprobe.blacklist=3Dnouveau rw quiet

$ cat /etc/lvm/lvm.conf | grep "issue_discards"
issue_discards =3D 1
-------------------->8--------------------

If there's anything else I can do to help diagnose the underlying probl=
em, I'm
more than willing.

Thanks,

Abelardo Ricart.
