From: Ritesh Raj Sarraf <rrs@researchut.com>
Subject: Re: Re: 2.6.24 Kernel Soft Lock Up with heavy I/O
	=?iso-8859-1?q?in=09dm-crypt?=
Date: Thu, 6 Mar 2008 20:11:38 +0530
Message-ID: <200803062011.45323.rrs@researchut.com>
References: <200802281924.03996.rrs@researchut.com>
	<47C9AEF3.7040507@redhat.com> <47C9AF8F.2050502@redhat.com>
Reply-To: Ritesh Raj Sarraf <rrs@researchut.com>,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0415812003=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <47C9AF8F.2050502@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <mbroz@redhat.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, dm-crypt@saout.de, linux-kernel@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, akpm@linux-foundation.org, Alasdair G Kergon <agk@redhat.com>, Christophe Saout <christophe@saout.de>
List-Id: dm-devel.ids

--===============0415812003==
Content-Type: multipart/signed; boundary="nextPart3270476.Hljc4nDSfQ";
	protocol="application/pgp-signature"; micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart3270476.Hljc4nDSfQ
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

I have a problem now.
I'm not able to reproduce the bug on an IBM xSeries box.

CPU: Dual Core 3.8 Ghz
RAM: 1 GB

The big difference in the configuration is that the laptop read data from a=
=20
USB HDD and copied it to another USB HDD (dm-crypted)
The IBM box reads it from an NFS share and copies it to the local hdd=20
(dm-crypted)

Ritesh


On Sunday 02 March 2008, Milan Broz wrote:
> (the same patch for 2.6.24)
>
> Milan
> --
> Add cond_resched() to prevent stuck in big bio processing.
>
> Signed-off-by: Milan Broz <mbroz@redhat.com>
> ---
>  drivers/md/dm-crypt.c |    1 +
>  1 file changed, 1 insertion(+)
>
> Index: linux-2.6.24.3/drivers/md/dm-crypt.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.24.3.orig/drivers/md/dm-crypt.c	2008-02-26 01:20:20.0000000=
00
> +0100 +++ linux-2.6.24.3/drivers/md/dm-crypt.c	2008-03-01
> 16:46:24.000000000 +0100 @@ -374,6 +374,7 @@ static int
> crypt_convert(struct crypt_co
>  			break;
>
>  		ctx->sector++;
> +		cond_resched();
>  	}
>
>  	return r;



=2D-=20
Ritesh Raj Sarraf
RESEARCHUT - http://www.researchut.com
"Necessity is the mother of invention."

--nextPart3270476.Hljc4nDSfQ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBH0AKp4Rhi6gTxMLwRAgSRAJ9Qlkb+RLLiKsv5GaJkD1dqexTV+QCeO3dV
grXG/Ddd7DkMnzHEI8D/cP4=
=7S8l
-----END PGP SIGNATURE-----

--nextPart3270476.Hljc4nDSfQ--


--===============0415812003==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0415812003==--
