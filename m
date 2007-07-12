From: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [2.6.23 PATCH 14/18] dm: netlink add to core
Date: Fri, 13 Jul 2007 01:13:24 +0200
Message-ID: <1184282004.24418.1.camel@johannes.berg>
References: <20070711210159.GF24114@agk.fab.redhat.com>
	 <20070711143423.36722a41.akpm@linux-foundation.org>
	 <20070712004038.GB29241@us.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-t9G3crkbNyLNjUqzEUPn"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20070712004038.GB29241@us.ibm.com>
Sender: netdev-owner@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
List-Id: dm-devel.ids


--=-t9G3crkbNyLNjUqzEUPn
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-07-11 at 17:40 -0700, Mike Anderson wrote:

> The pid is a hold over from older code. If this will cause issue for othe=
r
> users I can switch to using nlmsg_multicast (genlmsg_multicast depending
> on the comment if I need to switch to the genl interface) and remove this
> code all together.

Another possible genl multicast user :)

Has anybody had a chance to look at my patches for this?

johannes

--=-t9G3crkbNyLNjUqzEUPn
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGlrWT/ETPhpq3jKURAtPiAJ9606zXLNJMK7MjBx8vknr0Gk0oiQCfb6nh
QgdqwgpyBxaVVpRPSw8ATt8=
=bk+/
-----END PGP SIGNATURE-----

--=-t9G3crkbNyLNjUqzEUPn--

