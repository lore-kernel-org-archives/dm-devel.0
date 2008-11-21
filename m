From: Ritesh Raj Sarraf <rrs@researchut.com>
Subject: Re: [PATCH] Read the verbosity level from multipath.conf
	configuration file
Date: Fri, 21 Nov 2008 16:25:23 +0530
Message-ID: <200811211625.36757.rrs@researchut.com>
References: <1227184875-20831-1-git-send-email-rsarraf@netapp.com>
	<49266A26.7040801@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0801672920=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <49266A26.7040801@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============0801672920==
Content-Type: multipart/signed; boundary="nextPart1514379.Ytel810ICV";
	protocol="application/pgp-signature"; micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1514379.Ytel810ICV
Content-Type: text/plain;
  charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 21 Nov 2008 13:28:30 Kiyoshi Ueda wrote:
> > =1B(B?=1B(Bstatic int
> > +snprint_def_verbosity (char * buff, int len, void * data)
> > +{
> > +=1B(B?????=1B(Bif (conf->checkint =3D=3D DEFAULT_VERBOSITY)
>
> Isn't it conf->verbosity?

Thank you Kiyoshi. I'll be sending an updated patch.


Ritesh
=2D-=20
Ritesh Raj Sarraf
RESEARCHUT - http://www.researchut.com
"Necessity is the mother of invention."


--nextPart1514379.Ytel810ICV
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkmk6IACgkQ4Rhi6gTxMLxZogCdHLrj/0h3GZMjIH9RMBtSegyQ
vqwAoLQfCYVdBguZsVcQojejT7eV+Dlh
=nzGz
-----END PGP SIGNATURE-----

--nextPart1514379.Ytel810ICV--


--===============0801672920==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0801672920==--
