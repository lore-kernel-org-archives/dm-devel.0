From: NeilBrown <neilb@suse.com>
Subject: [RFC PATCH] dm: don't assign zero to ->bi_status of an active bio.
Date: Thu, 15 Feb 2018 20:01:31 +1100
Message-ID: <87h8qipqxg.fsf@notabene.neil.brown.name>
References: <70cda2a3-f246-d45b-f600-1f9d15ba22ff@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <70cda2a3-f246-d45b-f600-1f9d15ba22ff@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Milan Broz <gmazyland@gmail.com>, Mike Snitzer <snitzer@redhat.com>, device-mapper development <dm-devel@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


Between the moment when generic_make_request() is first
called on a bio, and when bio_endio() finally gets past
bio_remaining_done(), a bio might have chained children, and might
get ->bi_status set asynchronously.

So during this time it is not safe to set it to zero.
It *is* safe to set it to any other error status as for most
purposes, one error is as good as another.

This patch is untested and RFC only.  It identifies a number of
possible problem areas in dm and often suggests fixes.

Please don't apply without careful review.

Reviewed-by: Nobody yet.
Signed-off-by: NeilBrown <neilb@suse.com>
=2D--
 drivers/md/dm-bio-prison-v1.c | 3 ++-
 drivers/md/dm-bufio.c         | 6 ++++--
 drivers/md/dm-crypt.c         | 3 ++-
 drivers/md/dm-mpath.c         | 3 +++
 drivers/md/dm-thin.c          | 3 ++-
 drivers/md/dm-verity-target.c | 3 ++-
 drivers/md/dm-zoned-target.c  | 3 ++-
 7 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm-bio-prison-v1.c b/drivers/md/dm-bio-prison-v1.c
index 874841f0fc83..68cb4fe98e9f 100644
=2D-- a/drivers/md/dm-bio-prison-v1.c
+++ b/drivers/md/dm-bio-prison-v1.c
@@ -238,7 +238,8 @@ void dm_cell_error(struct dm_bio_prison *prison,
 	dm_cell_release(prison, cell, &bios);
=20
 	while ((bio =3D bio_list_pop(&bios))) {
=2D		bio->bi_status =3D error;
+		if (error)
+			bio->bi_status =3D error;
 		bio_endio(bio);
 	}
 }
diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 414c9af54ded..80131e098650 100644
=2D-- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -565,7 +565,8 @@ static void dmio_complete(unsigned long error, void *co=
ntext)
 {
 	struct dm_buffer *b =3D context;
=20
=2D	b->bio.bi_status =3D error ? BLK_STS_IOERR : 0;
+	if (error)
+		b->bio.bi_status =3D BLK_STS_IOERR;
 	b->bio.bi_end_io(&b->bio);
 }
=20
@@ -614,7 +615,8 @@ static void inline_endio(struct bio *bio)
 	 */
 	bio_reset(bio);
=20
=2D	bio->bi_status =3D status;
+	if (status)
+		bio->bi_status =3D status;
 	end_fn(bio);
 }
=20
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 8168f737590e..3e7db4a1093e 100644
=2D-- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1488,7 +1488,8 @@ static void crypt_dec_pending(struct dm_crypt_io *io)
 	else
 		kfree(io->integrity_metadata);
=20
=2D	base_bio->bi_status =3D error;
+	if (error)
+		base_bio->bi_status =3D error;
 	bio_endio(base_bio);
 }
=20
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 7d3e572072f5..6f793d7d29f0 100644
=2D-- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -651,6 +651,9 @@ static int __multipath_map_bio(struct multipath *m, str=
uct bio *bio,
=20
 	mpio->pgpath =3D pgpath;
=20
+	/* FIXME If the bio was chained, this could
+	 * over-write an error... is that possible?
+	 */
 	bio->bi_status =3D 0;
 	bio_set_dev(bio, pgpath->path.dev->bdev);
 	bio->bi_opf |=3D REQ_FAILFAST_TRANSPORT;
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 629c555890c1..16d4c386cc56 100644
=2D-- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -563,7 +563,8 @@ static void error_bio_list(struct bio_list *bios, blk_s=
tatus_t error)
 	struct bio *bio;
=20
 	while ((bio =3D bio_list_pop(bios))) {
=2D		bio->bi_status =3D error;
+		if (error)
+			bio->bi_status =3D error;
 		bio_endio(bio);
 	}
 }
diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index aedb8222836b..86a1d501d915 100644
=2D-- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -503,7 +503,8 @@ static void verity_finish_io(struct dm_verity_io *io, b=
lk_status_t status)
 	struct bio *bio =3D dm_bio_from_per_bio_data(io, v->ti->per_io_data_size);
=20
 	bio->bi_end_io =3D io->orig_bi_end_io;
=2D	bio->bi_status =3D status;
+	if (status)
+		bio->bi_status =3D status;
=20
 	verity_fec_finish_io(io);
=20
diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
index caff02caf083..cfdacaf79492 100644
=2D-- a/drivers/md/dm-zoned-target.c
+++ b/drivers/md/dm-zoned-target.c
@@ -637,7 +637,8 @@ static int dmz_end_io(struct dm_target *ti, struct bio =
*bio, blk_status_t *error
 		return DM_ENDIO_INCOMPLETE;
=20
 	/* Done */
=2D	bio->bi_status =3D bioctx->status;
+	if (bioctx->status)
+		bio->bi_status =3D bioctx->status;
=20
 	if (bioctx->zone) {
 		struct dm_zone *zone =3D bioctx->zone;
=2D-=20
2.14.0.rc0.dirty


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlqFTGsACgkQOeye3VZi
gbkiRw//UVal09h8m4rzAOjdB0EQW+t5Cl2p3cAvWcPqNtOPpvVKwMVZSCdCy79i
H0JSUBxugr60XDCE135zNX+3/2ZRSEhX9bwLfCgDzTeKI1W4cy37KU663x0VhphJ
LWGEaAeADJHamyPAC+1UrrdoLxe0/YyScevQ8OxqV9wtqDEqHYY19/z9XDsecZgb
4UeJfxgXur0Ao3qzE4hEO9NuN681Z1bB7y25zdLTnP1epEU3frPSP94xMcZc+7A+
L1lTh3rR1ukw8tfk2KvVErqrh3mAyBXWQYPEPkOz/9z/IyV4WZyxwmV6kn/2UTV3
R+C9UrZu1mPFl6FSJQiod4iKZq8gAfbfWBI/6qoqKuk1k3PzC6Mxts1Nb96LuTIW
CmpwlOaGKYQY+cvUUPHDn+f5ZHsHHXozy3NJrLHKonbR9w7Kt83aDAI7q5pNyMuA
5rdqT6H350Qq4JRA5u55iXGBSb6dJr/l0fjja00Z5ArN/y220vmGL/UIEgRAShcK
ex9F6MV+lcWtIIh5ZEK94t8cyBxYit9Vqqyyewlk8jVpwyZc+W39kMN1+ZZzQ9P6
z5Ewep8rAP4njC67RqOwmTCZS5SXIQxpWQl/ttbOjGJQuqEerJ2uSbMXdqyO9PSK
YpX372f+h9h9EdWeVCizsOkxSuQvAp3LmVP72kiwACowocyVHEc=
=UsHS
-----END PGP SIGNATURE-----
--=-=-=--
