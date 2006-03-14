From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH] dm-striped device sizes must be multiple of
	chunk-size
Date: Tue, 14 Mar 2006 14:43:43 -0800
Message-ID: <1142376223.3333.25.camel@localhost.localdomain>
References: <200603141631.02655.kevcorry@us.ibm.com>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1680193345=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200603141631.02655.kevcorry@us.ibm.com>
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


--===============1680193345==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-JdGcydY5pZfhL3iYGOtK"


--=-JdGcydY5pZfhL3iYGOtK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Also, those error messages should read "Target length not divisible...",
not "divisable".

--D

On Tue, 2006-03-14 at 16:31 -0600, Kevin Corry wrote:
> The dm-striped target currently does not enforce that the size of a strip=
e=20
> device be a multiple of the chunk-size. Under certain conditions, this ca=
n=20
> lead to I/O requests going off the end of an underlying device. This=20
> test-case shows one example.
>=20
> echo "0 100 linear /dev/hdb1 0" | dmsetup create linear0
> echo "0 100 linear /dev/hdb1 100" | dmsetup create linear1
> echo "0 200 striped 2 32 /dev/mapper/linear0 0 /dev/mapper/linear1 0" | \
>    dmsetup create stripe0
> dd if=3D/dev/zero of=3D/dev/mapper/stripe0 bs=3D1k
>=20
> This will produce the output:
> dd: writing '/dev/mapper/stripe0': Input/output error
> 97+0 records in
> 96+0 records out
>=20
> And in the kernel log will be:
> attempt to access beyond end of device
> dm-0: rw=3D0, want=3D104, limit=3D100
>=20
> The patch below will check that the table size is a multiple of the strip=
e=20
> chunk-size when the table is created, which will prevent the above stripe=
d=20
> device from being created.
>=20
> This should not effect tools like LVM or EVMS, since in all the cases I c=
an=20
> think of, striped devices are always created with the sizes being a multi=
ple=20
> of the chunk-size.
>=20

--=-JdGcydY5pZfhL3iYGOtK
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.1 (GNU/Linux)

iD8DBQBEF0cfa6vRYYgWQuURAuipAJ9P0YxfWKpmOC8nlNDnRBS+R4qAVgCfR9pD
/vGPqLnPOFIJyJdQpPWJKAc=
=MNBu
-----END PGP SIGNATURE-----

--=-JdGcydY5pZfhL3iYGOtK--


--===============1680193345==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1680193345==--
