From: NeilBrown <neilb@suse.com>
Subject: [PATCH 1/5 v3] blk: improve order of bio handling in generic_make_request()
Date: Fri, 10 Mar 2017 15:33:41 +1100
Message-ID: <87a88thhsq.fsf@notabene.neil.brown.name>
References: <87h93blz6g.fsf@notabene.neil.brown.name> <71562c2c-97f4-9a0a-32ec-30e0702ca575@profitbricks.com> <87lgsjj9w8.fsf@notabene.neil.brown.name> <a674456d-fb93-437e-c50e-195e7a035ba4@kernel.dk> <87r328j00i.fsf@notabene.neil.brown.name> <87d1dphhuy.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <87d1dphhuy.fsf@notabene.neil.brown.name>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Jack Wang <jinpu.wang@profitbricks.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Lars Ellenberg <lars.ellenberg@linbit.com>, Kent Overstreet <kent.overstreet@gmail.com>, Pavel Machek <pavel@ucw.cz>, Mike Snitzer <snitzer@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, linux-raid@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, linux-block@vger.kernel.org
List-Id: dm-devel.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


To avoid recursion on the kernel stack when stacked block devices
are in use, generic_make_request() will, when called recursively,
queue new requests for later handling.  They will be handled when the
make_request_fn for the current bio completes.

If any bios are submitted by a make_request_fn, these will ultimately
be handled seqeuntially.  If the handling of one of those generates
further requests, they will be added to the end of the queue.

This strict first-in-first-out behaviour can lead to deadlocks in
various ways, normally because a request might need to wait for a
previous request to the same device to complete.  This can happen when
they share a mempool, and can happen due to interdependencies
particular to the device.  Both md and dm have examples where this happens.

These deadlocks can be erradicated by more selective ordering of bios.
Specifically by handling them in depth-first order.  That is: when the
handling of one bio generates one or more further bios, they are
handled immediately after the parent, before any siblings of the
parent.  That way, when generic_make_request() calls make_request_fn
for some particular device, we can be certain that all previously
submited requests for that device have been completely handled and are
not waiting for anything in the queue of requests maintained in
generic_make_request().

An easy way to achieve this would be to use a last-in-first-out stack
instead of a queue.  However this will change the order of consecutive
bios submitted by a make_request_fn, which could have unexpected consequenc=
es.
Instead we take a slightly more complex approach.
A fresh queue is created for each call to a make_request_fn.  After it comp=
letes,
any bios for a different device are placed on the front of the main queue, =
followed
by any bios for the same device, followed by all bios that were already on
the queue before the make_request_fn was called.
This provides the depth-first approach without reordering bios on the same =
level.

This, by itself, it not enough to remove all deadlocks.  It just makes
it possible for drivers to take the extra step required themselves.

To avoid deadlocks, drivers must never risk waiting for a request
after submitting one to generic_make_request.  This includes never
allocing from a mempool twice in the one call to a make_request_fn.

A common pattern in drivers is to call bio_split() in a loop, handling
the first part and then looping around to possibly split the next part.
Instead, a driver that finds it needs to split a bio should queue
(with generic_make_request) the second part, handle the first part,
and then return.  The new code in generic_make_request will ensure the
requests to underlying bios are processed first, then the second bio
that was split off.  If it splits again, the same process happens.  In
each case one bio will be completely handled before the next one is attempt=
ed.

With this is place, it should be possible to disable the
punt_bios_to_recover() recovery thread for many block devices, and
eventually it may be possible to remove it completely.

Note that as some drivers look inside the bio_list, sometimes to punt
some bios to rescuer threads, we need to make both the pendind list and the
new list visible.  So current->bio_list is now an array of 2 lists,
and relevant code examines both of them.

Ref: http://www.spinics.net/lists/raid/msg54680.html
Tested-by: Jinpu Wang <jinpu.wang@profitbricks.com>
Inspired-by: Lars Ellenberg <lars.ellenberg@linbit.com>
Signed-off-by: NeilBrown <neilb@suse.com>
=2D--
 block/bio.c         |   11 ++++++++---
 block/blk-core.c    |   40 ++++++++++++++++++++++++++++++++--------
 drivers/md/dm.c     |   29 ++++++++++++++++-------------
 drivers/md/raid10.c |    3 ++-
 4 files changed, 58 insertions(+), 25 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 5eec5e08417f..84ae39f06f81 100644
=2D-- a/block/bio.c
+++ b/block/bio.c
@@ -376,10 +376,13 @@ static void punt_bios_to_rescuer(struct bio_set *bs)
 	bio_list_init(&punt);
 	bio_list_init(&nopunt);
=20
=2D	while ((bio =3D bio_list_pop(current->bio_list)))
+	while ((bio =3D bio_list_pop(&current->bio_list[0])))
 		bio_list_add(bio->bi_pool =3D=3D bs ? &punt : &nopunt, bio);
+	current->bio_list[0] =3D nopunt;
=20
=2D	*current->bio_list =3D nopunt;
+	while ((bio =3D bio_list_pop(&current->bio_list[1])))
+		bio_list_add(bio->bi_pool =3D=3D bs ? &punt : &nopunt, bio);
+	current->bio_list[1] =3D nopunt;
=20
 	spin_lock(&bs->rescue_lock);
 	bio_list_merge(&bs->rescue_list, &punt);
@@ -466,7 +469,9 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iov=
ecs, struct bio_set *bs)
 		 * we retry with the original gfp_flags.
 		 */
=20
=2D		if (current->bio_list && !bio_list_empty(current->bio_list))
+		if (current->bio_list &&
+		    (!bio_list_empty(&current->bio_list[0]) ||
+		     !bio_list_empty(&current->bio_list[1])))
 			gfp_mask &=3D ~__GFP_DIRECT_RECLAIM;
=20
 		p =3D mempool_alloc(bs->bio_pool, gfp_mask);
diff --git a/block/blk-core.c b/block/blk-core.c
index 1086dac8724c..bd2cb4ba674e 100644
=2D-- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1975,7 +1975,14 @@ generic_make_request_checks(struct bio *bio)
  */
 blk_qc_t generic_make_request(struct bio *bio)
 {
=2D	struct bio_list bio_list_on_stack;
+	/*
+	 * bio_list_on_stack[0] contains bios submitted by the current
+	 * make_request_fn.
+	 * bio_list_on_stack[1] contains bios that were submitted before
+	 * the current make_request_fn, but that haven't been processed
+	 * yet.
+	 */
+	struct bio_list bio_list_on_stack[2];
 	blk_qc_t ret =3D BLK_QC_T_NONE;
=20
 	if (!generic_make_request_checks(bio))
@@ -1992,7 +1999,7 @@ blk_qc_t generic_make_request(struct bio *bio)
 	 * should be added at the tail
 	 */
 	if (current->bio_list) {
=2D		bio_list_add(current->bio_list, bio);
+		bio_list_add(&current->bio_list[0], bio);
 		goto out;
 	}
=20
@@ -2011,23 +2018,40 @@ blk_qc_t generic_make_request(struct bio *bio)
 	 * bio_list, and call into ->make_request() again.
 	 */
 	BUG_ON(bio->bi_next);
=2D	bio_list_init(&bio_list_on_stack);
=2D	current->bio_list =3D &bio_list_on_stack;
+	bio_list_init(&bio_list_on_stack[0]);
+	bio_list_init(&bio_list_on_stack[1]);
+	current->bio_list =3D bio_list_on_stack;
 	do {
 		struct request_queue *q =3D bdev_get_queue(bio->bi_bdev);
=20
 		if (likely(blk_queue_enter(q, false) =3D=3D 0)) {
+			struct bio_list lower, same;
+
+			/* Create a fresh bio_list for all subordinate requests */
+			bio_list_on_stack[1] =3D bio_list_on_stack[0];
+			bio_list_init(&bio_list_on_stack[0]);
 			ret =3D q->make_request_fn(q, bio);
=20
 			blk_queue_exit(q);
=20
=2D			bio =3D bio_list_pop(current->bio_list);
+			/* sort new bios into those for a lower level
+			 * and those for the same level
+			 */
+			bio_list_init(&lower);
+			bio_list_init(&same);
+			while ((bio =3D bio_list_pop(&bio_list_on_stack[0])) !=3D NULL)
+				if (q =3D=3D bdev_get_queue(bio->bi_bdev))
+					bio_list_add(&same, bio);
+				else
+					bio_list_add(&lower, bio);
+			/* now assemble so we handle the lowest level first */
+			bio_list_merge(&bio_list_on_stack[0], &lower);
+			bio_list_merge(&bio_list_on_stack[0], &same);
+			bio_list_merge(&bio_list_on_stack[0], &bio_list_on_stack[1]);
 		} else {
=2D			struct bio *bio_next =3D bio_list_pop(current->bio_list);
=2D
 			bio_io_error(bio);
=2D			bio =3D bio_next;
 		}
+		bio =3D bio_list_pop(&bio_list_on_stack[0]);
 	} while (bio);
 	current->bio_list =3D NULL; /* deactivate */
=20
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index f4ffd1eb8f44..dfb75979e455 100644
=2D-- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -989,26 +989,29 @@ static void flush_current_bio_list(struct blk_plug_cb=
 *cb, bool from_schedule)
 	struct dm_offload *o =3D container_of(cb, struct dm_offload, cb);
 	struct bio_list list;
 	struct bio *bio;
+	int i;
=20
 	INIT_LIST_HEAD(&o->cb.list);
=20
 	if (unlikely(!current->bio_list))
 		return;
=20
=2D	list =3D *current->bio_list;
=2D	bio_list_init(current->bio_list);
=2D
=2D	while ((bio =3D bio_list_pop(&list))) {
=2D		struct bio_set *bs =3D bio->bi_pool;
=2D		if (unlikely(!bs) || bs =3D=3D fs_bio_set) {
=2D			bio_list_add(current->bio_list, bio);
=2D			continue;
+	for (i =3D 0; i < 2; i++) {
+		list =3D current->bio_list[i];
+		bio_list_init(&current->bio_list[i]);
+
+		while ((bio =3D bio_list_pop(&list))) {
+			struct bio_set *bs =3D bio->bi_pool;
+			if (unlikely(!bs) || bs =3D=3D fs_bio_set) {
+				bio_list_add(&current->bio_list[i], bio);
+				continue;
+			}
+
+			spin_lock(&bs->rescue_lock);
+			bio_list_add(&bs->rescue_list, bio);
+			queue_work(bs->rescue_workqueue, &bs->rescue_work);
+			spin_unlock(&bs->rescue_lock);
 		}
=2D
=2D		spin_lock(&bs->rescue_lock);
=2D		bio_list_add(&bs->rescue_list, bio);
=2D		queue_work(bs->rescue_workqueue, &bs->rescue_work);
=2D		spin_unlock(&bs->rescue_lock);
 	}
 }
=20
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 063c43d83b72..0536658c9d40 100644
=2D-- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -974,7 +974,8 @@ static void wait_barrier(struct r10conf *conf)
 				    !conf->barrier ||
 				    (atomic_read(&conf->nr_pending) &&
 				     current->bio_list &&
=2D				     !bio_list_empty(current->bio_list)),
+				     (!bio_list_empty(&current->bio_list[0]) ||
+				      !bio_list_empty(&current->bio_list[1]))),
 				    conf->resync_lock);
 		conf->nr_waiting--;
 		if (!conf->nr_waiting)



--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljCLKUACgkQOeye3VZi
gbm5aRAAo58rXLq/OsHR3RgP0enR1qVYL/ULHIPPp2xlP4XIohFKB5Z/zBLxjIqL
sDZzKVYldVOwkeFgZ7GjEyOj53l2Rhhg6Tld3CVIXYj6Km3PLN8fN+2zVLF8kAFn
enYe4INsAEHlFUDEtPkvn6XfBR7+aZU4xsp9pZPnXCyzVmrJjV8LTLW61y2rtq2R
/VvPIsP0s+HB4/qLYRMHPFmX3M1tLbe2bHr771ThBkIwdcLunWcD/OYztIpU1IEf
TujOZnVZkCRVcEb6SFBZlGhmY0j8r+GDQeINGacufyL/Yj7u1jkKNF6NBxUWJg57
6jjXavpty86ZnhhkTPyIwYMII+m4kTbf4/vJQ/F4OvGPib8yn0u+wmPEBlGENFin
6+7eBYdp+g3o7c1vD+/13yKi2j+nynSOGcBXA84REB4qqG1I6QsRSimS89/LsEqw
ygrXAe/jTPP1j+w1oV9mRE+ECZ3CWBPLYB/EfpYJiEFxSL8HgzqWvvYyQxWbRuXy
EvhN1C9WVY3YyZz62ocMYWR9MqjhUEJygvBVK+N6CXo/39hYfILCsyaK13c/sPgW
JpzLHj/a3nlWdpRBnsOJWB526iA2ujfY3BWw7AJnjNU9T5e1BreU8YBiHeyNfJXE
NVUY1eaeT4A/qWoBp7yTrp8lb6lhNUz6OMT707yiSwTH83ro+7E=
=Lbln
-----END PGP SIGNATURE-----
--=-=-=--
