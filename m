From: NeilBrown <neilb@suse.com>
Subject: [PATCH] dm-verity-fec: don't check for failure from mempool_alloc(GFP_NOIO)
Date: Mon, 10 Apr 2017 12:13:00 +1000
Message-ID: <87bms5xb6b.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: Sami Tolvanen <samitolvanen@google.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


mempool_alloc() cannot fail for GFP_NOIO allocation,
so there is no point testing for failure.

One place the code tested for failure was passing "0" as the GFP
flags.  This is most unusually and is probably meant to be GFP_NOIO,
so that is changed.

Allocation from ->extra_pool and ->prealloc_pool are repeated before
releasing the previous allocation.  This can deadlock if the code is
servicing a write under high memory pressure.  To avoid deadlocks,
change these to use GFP_NOWAIT and leave the error handling in place.

Signed-off-by: NeilBrown <neilb@suse.com>
=2D--
 drivers/md/dm-verity-fec.c | 21 +++++----------------
 1 file changed, 5 insertions(+), 16 deletions(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index 78f36012eaca..16e224fbd356 100644
=2D-- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -308,19 +308,14 @@ static int fec_alloc_bufs(struct dm_verity *v, struct=
 dm_verity_fec_io *fio)
 {
 	unsigned n;
=20
=2D	if (!fio->rs) {
=2D		fio->rs =3D mempool_alloc(v->fec->rs_pool, 0);
=2D		if (unlikely(!fio->rs)) {
=2D			DMERR("failed to allocate RS");
=2D			return -ENOMEM;
=2D		}
=2D	}
+	if (!fio->rs)
+		fio->rs =3D mempool_alloc(v->fec->rs_pool, GFP_NOIO);
=20
 	fec_for_each_prealloc_buffer(n) {
 		if (fio->bufs[n])
 			continue;
=20
=2D		fio->bufs[n] =3D mempool_alloc(v->fec->prealloc_pool, GFP_NOIO);
+		fio->bufs[n] =3D mempool_alloc(v->fec->prealloc_pool, GFP_NOWAIT);
 		if (unlikely(!fio->bufs[n])) {
 			DMERR("failed to allocate FEC buffer");
 			return -ENOMEM;
@@ -332,22 +327,16 @@ static int fec_alloc_bufs(struct dm_verity *v, struct=
 dm_verity_fec_io *fio)
 		if (fio->bufs[n])
 			continue;
=20
=2D		fio->bufs[n] =3D mempool_alloc(v->fec->extra_pool, GFP_NOIO);
+		fio->bufs[n] =3D mempool_alloc(v->fec->extra_pool, GFP_NOWAIT);
 		/* we can manage with even one buffer if necessary */
 		if (unlikely(!fio->bufs[n]))
 			break;
 	}
 	fio->nbufs =3D n;
=20
=2D	if (!fio->output) {
+	if (!fio->output)
 		fio->output =3D mempool_alloc(v->fec->output_pool, GFP_NOIO);
=20
=2D		if (!fio->output) {
=2D			DMERR("failed to allocate FEC page");
=2D			return -ENOMEM;
=2D		}
=2D	}
=2D
 	return 0;
 }
=20
=2D-=20
2.12.2


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIyBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljq6iwACgkQOeye3VZi
gbnW9w/4/K2S6VE7G0+ozAsiN5E7UIArJ7X2BYQg2QZ9Z8m9Aa2Ibf7wUTCgOLTZ
C1L+U9YqzqLq0Zc/Zp9JPaZ/xDQYeMQbFGUldmYCUxH+D4bpcS2MrD72sDIrOxZS
A3c2lcwi2MgC/Co3DTrLoBiu51qAJqjxwyO/4j0vmLe6oqfM6ItZEfQOBQpE15is
b1i1TvOO/QZBiSQMEVyP8WzA3e71WNRcaaJQIqDxqZ41geczwNvpHr52QPJmUjQF
qmIzbOvKIZnBWus1E3jUrDHiQKyv5peh4l8XvkDQDfRH1PEsSeEhGNTg1/GTUvEz
yTeh6Q5/m9SVEIw9qdT+fjp8wuYkMjr9vApzJkwXbk5LYA+8+9LINTKg62GugWok
TzqM/YI0+S/8JkPOHeQRjvsUP4yrI8yj74xFH+1R0A+RKpof9E5XNg/uVyYBKcRg
LNIJ8oh5/RLHAw+XTJVHVSKSz/n0jvOkBNge6RECQZ/hqrdl9jyYHjnthrVyFc5s
Aft5jfGj64OUXnVaVc4Lpyjnc8xuoaX6DdPE9RmRRL5/HdrruoHl+tnxj7p+Gaai
EYUxPuS43zeVYdJcpHXG7TyLMmLE/rfb9XLNeH+TnywCkbYv5F3UHbATbg/uzOG5
GO6qLb6WgiLpmcTvdymk9nUS6koBQ87/XVqlZqUIi0kiQSmCMw==
=nL88
-----END PGP SIGNATURE-----
--=-=-=--
