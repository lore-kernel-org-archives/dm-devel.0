From: NeilBrown <neilb@suse.com>
Subject: [PATCH] dm-region-hash: fix strange usage of mempool_alloc.
Date: Mon, 10 Apr 2017 12:11:06 +1000
Message-ID: <87efx1xb9h.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


mempool_alloc() should only be called with GFP_ATOMIC when
it is not safe to wait. Passing __GFP_NOFAIL to kmalloc()
says that it is safe to wait indefinitely.  So this code is
inconsistent.

Clearly it is OK to wait indefinitely in this code, and
mempool_alloc() is able to do that.  So just use
mempool_alloc, and allow it to sleep.  If no memory is
available it will wait for something to be returned to the
pool, and will retry a normal allocation regularly.

Signed-off-by: NeilBrown <neilb@suse.com>
=2D--
 drivers/md/dm-region-hash.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/md/dm-region-hash.c b/drivers/md/dm-region-hash.c
index 85c32b22a420..a6279f5d779e 100644
=2D-- a/drivers/md/dm-region-hash.c
+++ b/drivers/md/dm-region-hash.c
@@ -287,9 +287,7 @@ static struct dm_region *__rh_alloc(struct dm_region_ha=
sh *rh, region_t region)
 {
 	struct dm_region *reg, *nreg;
=20
=2D	nreg =3D mempool_alloc(rh->region_pool, GFP_ATOMIC);
=2D	if (unlikely(!nreg))
=2D		nreg =3D kmalloc(sizeof(*nreg), GFP_NOIO | __GFP_NOFAIL);
+	nreg =3D mempool_alloc(rh->region_pool, GFP_NOIO);
=20
 	nreg->state =3D rh->log->type->in_sync(rh->log, region, 1) ?
 		      DM_RH_CLEAN : DM_RH_NOSYNC;
=2D-=20
2.12.2


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljq6boACgkQOeye3VZi
gbmmYhAAgOwhRoE5yJsOEFVM9583wANZCHSumF81Rftk8Q8e+Bz191yGnZRJFkzr
nglaVm+7BC7KiGWyQyQDaGGpzd2WAydpdUZw3wbFdEqDgQLVQdaXrT5TY1CvBBBj
pKlmeg9OdjFq2EJ+ayv/iTq+i10Iz1xfuRFbJ5yydGrDlmdFUgvsETEAe7V62dWj
zc6r7sAQ26JzEXiMLJlUm3XB2Fr1kDpQV/Giumc8pr7Y3qpoBeijmxQmu7/6ezSh
0mEt3KGObK1c9Fn6Va59GoiWWbr+BLDDbKZeLJC4YRSuGm7kBUhYXCsPGfEXskP3
6H4SVGIkAJ59Jm6pWqjSwAlcZtLNKji1DAoYLsakNAi/9SnaFY6jhJ01s6Ii0cn5
9jZvzVX/CfltqPrSumK+ygs4IHwWkpOTBWiOpx3Cq9me+Yol/mXLOczqTMSAOCEd
E80X/yjuHDxQtVQRY5jBVmOrs9uBYf804aXnfhP8D1EBqRDkVcLrwSLcr7E7XU3n
vzdp++uUi63M/zQoLEx0Hep6O164x/EmLd5oM82fD7D4st/zov0gxaDfnzYWv0At
yuSOLskJz1AQabmXXSpiczlP9DhYCBPIu2P/Ca33UMWn13+ZgHtgT3BAUN/HibsA
Qn+q6yt6TDBqVkkLcGX9/9g76pEIThOQis6Cbq9gnzV3a71wQNg=
=DTqR
-----END PGP SIGNATURE-----
--=-=-=--
