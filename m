From: Stefan Bader <Stefan.Bader@de.ibm.com>
Subject: Re: fdisk on a multipath device fails kernel partition
	re-read
Date: Mon, 1 Oct 2007 14:59:35 +0200
Message-ID: <OF10AFAEEE.C15672A1-ONC1257367.00466788-C1257367.004736AC@de.ibm.com>
References: <448b15030709281328i104c04f0te6dd1ef333b825a3@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <448b15030709281328i104c04f0te6dd1ef333b825a3@mail.gmail.com>
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

Using device-mapper volumes for partioning is wrong in the way DM works.
DM devices do not use partitions and do not support the ioctl used to
update the partition table (exception for linear mappings with single
devices).  Partitions on multipath volumes are created by kpartx as
linear targets after creating the base multipath target.
The only safe way that should always be used is to remove the multipath
volume (multipath -f <mpname>), then call fdisk on the sd device=20
(optionally
call blockdev --rereadpt <dev> on all other paths) and the recreate the
multipath volume by calling multipath.

Mit freundlichem Gru=DF / Regards,
Stefan Bader

SW Linux on zSeries Development
Stefan.Bader@de.ibm.com

IBM Deutschland Entwicklung GmbH
Vorsitzender des Aufsichtsrats: Martin Jetter
Gesch=E4ftsf=FChrung: Herbert Kircher
Sitz der Gesellschaft: B=F6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
-------------------------------------------------------------------------=
---------
  When all other means of communication fail, try words.

dm-devel-bounces@redhat.com wrote on 28.09.2007 22:28:06:

> When I perform an fdisk or sfdisk on a /dev/mapper/ multipath device I
> get a warning about it failing to re-read the partition information.
> With fdisk it warns that I'll need to reboot before using the device,
> with sfdisk it just complains about the ioctl that failed:
>=20
> Re-reading the partition table ...
> BLKRRPART: Invalid argument
>=20
> Is it possible I have something configured wrong? Or is this a problem
> with the way /dev/mapper nodes work? I get the same result when using
> /dev/dm-* nodes. With the raw device nodes such as /dev/sd* it works
> ok.
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
