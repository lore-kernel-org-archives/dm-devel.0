From: Stefan Bader <Stefan.Bader@de.ibm.com>
Subject: Re: Size affects performance?
Date: Wed, 1 Aug 2007 11:24:27 +0200
Message-ID: <OF4938AA3C.6B364A5A-ONC125732A.003345EF-C125732A.00338569@de.ibm.com>
References: <0F900654-4DF1-40F7-8227-C277E11C4F33@mikl.as>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <0F900654-4DF1-40F7-8227-C277E11C4F33@mikl.as>
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

If you use dd for performance tests I would suggest to use oflags=3Dsync.=
=20
Otherwise there might be caching effects.

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

dm-devel-bounces@redhat.com wrote on 01.08.2007 05:03:52:

> Hi,
>=20
> I've noticed that the size of a device seems to affect its performance.
> Is this expected behaviour?
>=20
> For example, on a device that is exactly 1GB, I can transfer at 16.4=20
> MB/s:
>=20
> flanders1:~# dmsetup create test
> 0 2097152 linear /dev/sda6 0
>=20
> flanders1:~# dd if=3D/dev/zero of=3D/dev/mapper/test bs=3D1K count=3D10=
48576
> 1048576+0 records in
> 1048576+0 records out
> 1073741824 bytes (1.1 GB) copied, 65.4846 seconds, 16.4 MB/s
>=20
>=20
> Yet, if I resize the device to be one sector larger, the same=20
> transfer happens at 59.0 MB/s:
>=20
> flanders1:~# dmsetup create test
> 0 2097153 linear /dev/sda6 0
>=20
> flanders1:~# dd if=3D/dev/zero of=3D/dev/mapper/test bs=3D1K count=3D10=
48576
> 1048576+0 records in
> 1048576+0 records out
> 1073741824 bytes (1.1 GB) copied, 18.1887 seconds, 59.0 MB/s
>=20
>=20
> For reference, the underlying device seems capable of ~ 60 MB/s:
>=20
> flanders1:~# dd if=3D/dev/zero of=3D/dev/sda6 bs=3D1K count=3D1048576
> 1048576+0 records in
> 1048576+0 records out
> 1073741824 bytes (1.1 GB) copied, 18.1325 seconds, 59.2 MB/s
>=20
>=20
> I've noticed that the problem either doesn't occur or isn't as=20
> pronounced if different block sizes are used (ie. bs=3D4K).
> I'm running a fairly recent kernel: git tag v2.6.23-rc1-g6a30235
>=20
>=20
> Thanks for any help,
>=20
>=20
> Andrew Miklas
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
