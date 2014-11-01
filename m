From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH] dm crypt: fix access beyond the end of allocated space
Date: Sat, 01 Nov 2014 01:30:02 +0000
Message-ID: <1414805402.16849.103.camel@decadent.org.uk>
References: <alpine.LRH.2.02.1409111339220.5256@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-o54hsQc2Q5VK/c/sLqAU"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1409111339220.5256@file01.intranet.prod.int.rdu2.redhat.com>
Sender: stable-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Willy Tarreau <w@1wt.eu>, Paul Gortmaker <paul.gortmaker@windriver.com>, Luis Henriques <luis.henriques@canonical.com>, dm-devel@redhat.com, Mike Snitzer <msnitzer@redhat.com>
List-Id: dm-devel.ids


--=-o54hsQc2Q5VK/c/sLqAU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2014-09-11 at 13:43 -0400, Mikulas Patocka wrote:
> Hi
>=20
> This is backport of upstream commit=20
> d49ec52ff6ddcda178fc2476a109cf1bd1fa19ed. It is suitable for all stable=
=20
> kernels.
[...]

Queued up for 3.2, thanks.

Ben.

--=20
Ben Hutchings
The world is coming to an end.	Please log off.

--=-o54hsQc2Q5VK/c/sLqAU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVFQ3mue/yOyVhhEJAQrHpg//R/HYIyV76e575j0rA68g/whDyQEvnZMS
F5fqARvKzdQWvME1bSEuTVKFvMf7gAoaoO7MmCOpzVyFWRfIqD9hHDEkh/EfjLr3
8BRQL0KKTxuKJCMHu0g2sP1Nn83/v2w8jDfpi/NoQPou+4ej0TgjMh46wz7X50GD
UNd/rhbvkw1ZU1O8acTzrwvtuYxXUQfGa6aA4R54cys+fz86ueiAr8Ux+yaslsp5
VOnPcL0ond0/ZwtHwy163M9AWgzVKq5UsNeRM7etzor646cRzVHgzTRGuU2fzjsV
Hc7xqDltjnkRgRk7nRSONB9qjDvcoVORa9P991vUac5q4Ey4N5WJSoJEEGrX7IHt
2KPUqwiHoSrjBEMG5VLpeUDf1Wzd/5epBK2RGz1aW8QeIYF03AZPrzFujxpqKEuU
x6Wgi/iOlgFEjNaVi3zQhb2Sroqmr8RAlwBVlYne2SxTpZIdSmWzobIoIDLj4Lem
N75ipTuyuKEBUdTeG4dgSdGGCj7J2pIlTqZMTq1n0+9LdhO63H0wvF81xrEXyjRO
RT5l6igVnoky8lBOqWPPlVkcvQoZPBNAG/fkoESj3kZpKEVFgMTns6ZByfG0DzLK
HL5W4isCyEt3ZrsCEDj0NYrrwiIVQtvCUyyVL6PSsuA1J9nVtOo41s1R922y3LpZ
r6KJ2eTbXXA=
=tP06
-----END PGP SIGNATURE-----

--=-o54hsQc2Q5VK/c/sLqAU--
