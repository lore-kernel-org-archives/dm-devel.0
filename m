From: Christophe Saout <christophe@saout.de>
Subject: Re: possible dm-crypt leak over loop
Date: Thu, 10 Mar 2005 16:21:39 +0100
Message-ID: <1110468099.16258.7.camel@leto.cs.pocnet.net>
References: <1110147738.2266.26.camel@boxen>
	<1110461058.14581.3.camel@leto.cs.pocnet.net>
	<1110466511.2301.10.camel@boxen>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1814903446=="
In-Reply-To: <1110466511.2301.10.camel@boxen>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alexander Nyberg <alexn@dsv.su.se>
Cc: dm-crypt@saout.de, device-mapper development <dm-devel@redhat.com>, Steffen Michalke <StMichalke@web.de>
List-Id: dm-devel.ids


--===============1814903446==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-iFArOP1x0QSkzwOAova9"


--=-iFArOP1x0QSkzwOAova9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Am Donnerstag, den 10.03.2005, 15:55 +0100 schrieb Alexander Nyberg:

> > Can anybody else confirm this?
>=20
> The original report came from Steffen Michalke (CC'd), but I find it
> very weird that you can't trigger the lockup. It takes about a second
> here on a UP non-preempt box to lock up.

Perhaps my machine has too much memory. ;)

> Why I think it's a memory leak is due to the sysrq-Meminfo trace
> and the call-trace showing=20
> crypt_alloc_buffer =3D> mempool_alloc =3D> io_schedule

That's normal. For write-outs dm-crypt has to allocate some buffers
where it can put the encrypted data. mempool_alloc means that it ran out
of preallocated buffers and waits for some in-flight I/O to finish which
should free some buffers.

It looks like this is a dm-crypt <-> loop deadlock. The problem with
loop is that it goes back through the page cache. The loop thread is
also waiting for memory to actually be able to write out some more
pages.

So this seems to be a loop bug. Loop is waiting for pages to become free
to actually be able to write some pages. dm-crypt uses a mempool to
avoid this deadlock but if the underlying device deadlocks it can't do
anything about that.

loop does a: alloc_page(GFP_NOIO | __GFP_HIGHMEM);

There is no guarantee that this will succeed. It probably should also
have some sort of emergency pool.


--=-iFArOP1x0QSkzwOAova9
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Dies ist ein digital signierter Nachrichtenteil

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQBCMGYDZCYBcts5dM0RApKdAKCm+Y+3MlimGT0FjBJZeng1739dkACfYMH0
SZYkgwEzuBmNW4vpOvKnduA=
=ZWmY
-----END PGP SIGNATURE-----

--=-iFArOP1x0QSkzwOAova9--


--===============1814903446==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1814903446==--
