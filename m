From: "Andreas Huck" <dm-devel@huck.it>
Subject: multipath with dual Compaq SA462 connected to MSA500
Date: Tue, 10 Oct 2006 12:21:13 +0200 (CEST)
Message-ID: <37429.195.37.166.71.1160475673.squirrel@io3.huck.it>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


Hi,

I'd like to enable some sort of multipath to a RAID device which
is connected by two Smart Array 462 to a MSA500. The host is a DL380 G4.
In contrast to MSA1000 the MSA500 is just directly attached, no HBA
involved.
The RAID appears as /dev/cciss/c1d0 and /dev/cciss/c2d0 and currently
I am forced to disable one path by lvm filter.

Without the lvm filter I get:

Found duplicate PV iXZqRZZg8X6pNn4RBrxRbFiK8O6txY0b: using
/dev/cciss/c2d0p1 not /dev/cciss/c1d0p1

So, I'd like to use both controllers but setup multipath on them. Anyone
around who succeeded with such a setup? It should work since HP offers
some Win*** driver for it, but I need to enable it with SLES9-SP3++ ;-)

The drives do not register as scis defices and to not appear in
/proc/scsi/scsi. Therefore, /sbin/scsi_id -g -u -s /block/%n
does not work of course.

# multipath -v2 -d
dm names   N
dm table vgdata-netview  N
dm table vglocal-tivoli  N
dm table vgdata-oradata  N
dm table vglocal-tmp  N
dm table vglocal-optoracle  N
dm table vgdata-etc_tivoli  N
dm table vglocal-var  N

So just the LVM devices appear, vgdata is on the MSA500.

Any hints apprecciated!

Thanks and best regards,
Andreas Huck
