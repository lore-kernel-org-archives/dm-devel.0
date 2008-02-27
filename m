From: Dharmesh Kamdar <kamdard71@yahoo.com>
Subject: UDEV with DM-MULTIPATH issue in RHEL 5.1....
Date: Wed, 27 Feb 2008 10:10:22 -0800 (PST)
Message-ID: <508552.23576.qm@web90611.mail.mud.yahoo.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
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

Hi,

This question is more in conjunction with DM-MULTIPATH
and UDEV.

We are trying to set-up a Oracle 10g RAC (2 node)
using RHEL 5.1 on an x86-64 hardware.=20

We are using DM-MULTIPATH for storage devices,
including OCR and VOTING disk(s) that Oracle requires.

Oracle OUI requires "OCR" and "VOTING" disk to be
specified as "raw" devices for the installation (it
does NOT accept the block device while
installation)...Also it requires us to change the
permissions on these devices such that the user
"oracle" can access the OCR and VOTING  disks.

We've created partitions on the OCR and VOTING disks
and have defined an alias in /etc/multipath.conf

After that, for persistency, we've defined following
UDEV rules for it to=20
1) create raw device binding in a persistent way (so
that it survives reboot).

2) it changes the permission that is acceptable to
Oracle.

The UDEV rules are as follows:
/etc/udev/rules.d/51-oracle-raw.rules
ACTION=3D=3D"add", KERNEL=3D"/dev/mpath/OCR1p1",
RUN+=3D"/bin/raw /dev/raw/rawX %N"
ACTION=3D=3D"add", KERNEL=3D"/dev/mpath/OCR2p1",
RUN+=3D"/bin/raw /dev/raw/rawX %N"
ACTION=3D=3D"add", KERNEL=3D"/dev/mpath/VOTE1p1",
RUN+=3D"/bin/raw /dev/raw/rawX %N"
ACTION=3D=3D"add", KERNEL=3D"/dev/mpath/VOTE2p1",
RUN+=3D"/bin/raw /dev/raw/rawX %N"
ACTION=3D=3D"add", KERNEL=3D"/dev/mpath/VOTE3p1",
RUN+=3D"/bin/raw /dev/raw/rawX %N"
~                                                    =20
2) /etc/udev/rules.d/99-raw.rules
#-------------------------#
#OCR disks --> raw1, raw2 #
#-------------------------#

KERNEL=3D=3D"raw[1-2]*", GROUP=3D"oinstall", MODE=3D"640"

#------------------------------------#
# Voting disks --> raw3, raw4, raw5. #
#------------------------------------#
KERNEL=3D=3D"raw[3-5]*", OWNER=3D"oracle", GROUP=3D"oinstall",
MODE=3D"660"
~                                                    =20
                 =20

But these rules do NOT get honored..It does NOT create
any raw binding, neither does it change the
permissions
on the devices as specified. Even reboot of a system
does NOT help.

We've tried and experimented numerous ways, like
specifiying /dev/mapper rather than /dev/mpath, also
we have changed the UDEV rule names with various
numbers...but all in vain so far.

The only thing that seems to work is if we write some
sort of script in /etc/rc.local, however, it then
defeats the purpose of UDEV.

We also updated  to the latest and greatest patches
for RHEL 5.1, but no use...

So, is there an issue with DM-MULTIPATH and UDEV in
RHEL 5.1 ? or are we missing anything specific ?


Here are the specifics:
OS: RHEL 5.1

uname -a : Linux arcx3550gxvg4 2.6.18-53.1.13.el5 #1
SMP Mon Feb 11 13:27:27 EST 2008 x86_64 x86_64 x86_64
GNU/Linux

Multipath : device-mapper-multipath-0.4.7-12.el5_1.2

Hardware: IBM xseries 3550 servers

Will appreciate any help or tips/tricks on the
subject.

Thanks & Regards,
Dharmesh.


      ___________________________________________________________________=
_________________
Never miss a thing.  Make Yahoo your home page.=20
http://www.yahoo.com/r/hs
