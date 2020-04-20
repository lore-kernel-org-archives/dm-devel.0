From: Paul Wise <pabs3@bonedaddy.net>
Subject: Re: [dm-devel] [PATCH 0/3] dm raid/raid1: enable discard support
 when any devices support discard
Date: Mon, 20 Apr 2020 18:13:01 +0800
Message-ID: <a0034feda1f6f598c8376a418949b48109307e67.camel@bonedaddy.net>
References: <20200419073026.197967-1-pabs3@bonedaddy.net>
         <20200419131908.GA22398@redhat.com>
         <9cb6a39a43178be29af2f47a92c2e84754b62b69.camel@bonedaddy.net>
         <6bbf9d94-2fbb-f96f-ea85-a480ba109c55@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-7gYIJ8Sm/tiyMSzyv4MA"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6bbf9d94-2fbb-f96f-ea85-a480ba109c55@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ondrej Kozina <okozina@redhat.com>, dm-devel@redhat.com
Cc: Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids


--=-7gYIJ8Sm/tiyMSzyv4MA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2020-04-20 at 09:35 +0200, Ondrej Kozina wrote:

> Did you have discard allowed on both dm-crypt devices? dm-crypt
> (kernel) does not allow discards by default.

I did not, I guess that explains why I got no errors.

--=20
bye,
pabs

https://bonedaddy.net/pabs3/

--=-7gYIJ8Sm/tiyMSzyv4MA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEYQsotVz8/kXqG1Y7MRa6Xp/6aaMFAl6ddakACgkQMRa6Xp/6
aaMDqg/8Cj1meyJPg+ICUeg+WsYjGw/jaRrqC/UZzGwBCq/fguJ8BOwu+HtorOmM
Kqr370rlTrjwdn4THs3So6PDSr3es270GKN0Cg1sO7z97lXUYQJA1RklOHRDw/5M
EIw3uHHRNtutjWgyLScDBoy4kS+jzlNElwkj2M/amxTS2nlL99W5CI9sCdWwMjvm
+ftXtELcNC8znWUBQlPJ/JnTu4/6kfKPytrzBWGvPxODgFosI8fA1K7kMoXNSvq7
OSMCVZkq4AlhlHq+MIkXlPPE8pQoTbMTLflqD+wrusgEFGJMRYEGnndbg1vBrk5Y
ieZ/z96mxOQ4VrFEeIC9IeY560Z/lb1MJJBYJRF7HF9ez02YAqevzmM85jzo6CMv
7Bp8m+VcT/RcceAChWR14LOE+q3vJfhX1nu5wHatR3vTRYz5tFha+xqAypQMg504
sVo+YzxIp/z45EDbinz7niePh8v4V04K1ne75G2R1iX++RcIurieGBS7+4OueAEl
7anc/Evu+FPD/LDMlhGxVtiH1PqPk4ZJpD/Z6uVfKOQiOPhvF0RfPGJRE/8mW+uY
VdECV0zqsWlTYaOmSH0FiCgq3zxW5Zw8rxYs+ioHUR/431c7zo3JLBJPEF8+3H4t
x3hiW6iJ21Nw0ibptbIVJCg7jzqfMfe0cWHHqrynzZtfMIOzTAY=
=GclY
-----END PGP SIGNATURE-----

--=-7gYIJ8Sm/tiyMSzyv4MA--
