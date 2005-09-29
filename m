From: Bastian Blank <bastian@waldi.eu.org>
Subject: Re: [PATCH] multipath-tools/kpartx - fix endianes,
	undefined behaviour, cleanup
Date: Thu, 29 Sep 2005 17:09:49 +0200
Message-ID: <20050929150949.GC18325@wavehammer.waldi.eu.org>
References: <20050929124115.GA8988@wavehammer.waldi.eu.org>
	<20050929132938.GA14593@free.fr>
	<20050929140529.GA18325@wavehammer.waldi.eu.org>
	<20050929141336.GA14667@free.fr>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0777367228=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050929141336.GA14667@free.fr>
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


--===============0777367228==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TYecfFk8j8mZq+dy"
Content-Disposition: inline


--TYecfFk8j8mZq+dy
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 29, 2005 at 04:13:36PM +0200, Christophe Varoqui wrote:
> *** browse is ok, but ***
> 16:11:45 ERREUR 403: Forbidden.

Ups, I thought I fixed that. Seems to be a problem with git and my umask

Bastian

--=20
If there are self-made purgatories, then we all have to live in them.
		-- Spock, "This Side of Paradise", stardate 3417.7

--TYecfFk8j8mZq+dy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iEYEARECAAYFAkM8A70ACgkQnw66O/MvCNF+0wCgjH1Dbg/L12ad/S3zYyiG6CrA
Y50AoK1xsvGXgTHKoRA7l9ORBHdvdFJH
=UG0Q
-----END PGP SIGNATURE-----

--TYecfFk8j8mZq+dy--


--===============0777367228==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0777367228==--
