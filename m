From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: kcopyd_client_create allocation failure on creating
	snapshots
Date: Mon, 23 May 2005 10:48:09 -0400
Message-ID: <1116859689.6218.18.camel@localhost.localdomain>
References: <ba31087e05052301254b142bbe@mail.gmail.com>
Reply-To: mingz@ele.uri.edu,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0760405194=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <ba31087e05052301254b142bbe@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Igor Yanover <igor.yanover@gmail.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


--===============0760405194==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-5M2PFizvZcsxDKsuX2QU"


--=-5M2PFizvZcsxDKsuX2QU
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

yes, i fired this while no further discussion found. i also want to know
any solution regarding this.=20

ming

On Mon, 2005-05-23 at 10:25 +0200, Igor Yanover wrote:
>     Hi!
>     I've got the following error, while trying to create many
> snapshots ( > 32 ) :
> "device-mapper: : Could not create kcopyd client". After some digging,
> I found out that the reason is resize_pool() in dm-io.c trying to do
> mempool_resize that is probably too large. I've seen that the issue
> has been raised in this list before at:
> https://www.redhat.com/archives/dm-devel/2005-April/msg00080.html,
> with the same conclusions, but there was no discussion and as far I
> can seen, the code has not changed since. I understand that the
> correct fix would be to use per-kclient pools.
> Is anyone planning to work/already working on this?
>=20
>      Thanks,
>           Igor
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

--=-5M2PFizvZcsxDKsuX2QU
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQBCke0pSYbkL5BnVYoRAn1vAJ4356VFhcSTxMKxczo8emLVV/VUgwCfd8LU
w67X6dgeH9uz+4x7Ka2VUFk=
=lnSU
-----END PGP SIGNATURE-----

--=-5M2PFizvZcsxDKsuX2QU--


--===============0760405194==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0760405194==--
