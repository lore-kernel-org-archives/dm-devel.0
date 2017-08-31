From: NeilBrown <neilb@suse.com>
Subject: [PATCH/rfc] dm: revise 'rescue' strategy for md->bs
	allocations
Date: Thu, 31 Aug 2017 16:18:17 +1000
Message-ID: <878ti0fefq.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1703621525620444883=="
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

--===============1703621525620444883==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


The md->bs bioset currently needs the BIOSET_NEED_RESCUER flag
which I hope to deprecate.  It is currently needed because
__split_and_process_bio() can potentially allocate from the
bioset multiple times within the one make_request_fn context.
Subsequent allocations can deadlock waiting for the bio returned
by the first allocation to complete - but it is stuck on the
current->bio_list list.

The bioset is also used in setup_clone() in dm-rq.c, but there a
non-blocking (GFP_ATOMIC) allocation is used, so there is no risk of
deadlock.

dm also provide rescuing for ->map() calls.  If a map call ever blocks,
any bios already submitted with generic_make_request() will be passed to
the bioset rescuer thread.

This patch unifies these two separate needs for rescuing bios into a
single mechanism, and use the md->wq work queue to do the rescuing.

A blk_plug_cb is added to 'struct clone_info' so that it is available
throughout the __split_and_process_bio() process.
Prior to allocating from the bioset, or calling ->map(),
dm_offload_check() is called to ensure that the blk_plug_cb is active.
If either of these operation schedules, the callback is called,
and any queued bios get passed to the wq.

Note that only current->bio_list[0] is offloaded.  current->bio_list[1]
contains bios that were scheduled *before* the current one started, so
they must have been submitted from higher up the stack, and we cannot be
waiting for them here.  Also, we now rescue *all* bios on the list as
there is nothing to be gained by being more selective.

This allows us to remove BIOSET_NEED_RESCUER when allocating this
bioset.
It also keeps all the mechanics of rescuing inside dm, so dm can
be in full control.

Signed-off-by: NeilBrown <neilb@suse.com>
=2D--

Hi,
 I have only tested this lightly as I don't have any test infrastructure
 for dm and don't know how to reproduce the expected deadlocks.
 I'm keen to know your thoughts on this approach if you find a few spare
 moment to have a look.

Thanks,
NeilBrown

=20
 drivers/md/dm-core.h |  1 +
 drivers/md/dm.c      | 99 ++++++++++++++++++++++++++----------------------=
----
 2 files changed, 51 insertions(+), 49 deletions(-)

diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
index 24eddbdf2ab4..cb060dd6d3ca 100644
=2D-- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -71,6 +71,7 @@ struct mapped_device {
 	struct work_struct work;
 	spinlock_t deferred_lock;
 	struct bio_list deferred;
+	struct bio_list rescued;
=20
 	/*
 	 * Event handling.
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 2edbcc2d7d3f..774dd71cb49a 100644
=2D-- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1134,65 +1134,63 @@ void dm_remap_zone_report(struct dm_target *ti, str=
uct bio *bio, sector_t start)
 }
 EXPORT_SYMBOL_GPL(dm_remap_zone_report);
=20
+struct clone_info {
+	struct mapped_device *md;
+	struct dm_table *map;
+	struct bio *bio;
+	struct dm_io *io;
+	sector_t sector;
+	unsigned sector_count;
+	struct blk_plug plug;
+	struct blk_plug_cb cb;
+};
+
 /*
  * Flush current->bio_list when the target map method blocks.
  * This fixes deadlocks in snapshot and possibly in other targets.
  */
=2Dstruct dm_offload {
=2D	struct blk_plug plug;
=2D	struct blk_plug_cb cb;
=2D};
=20
 static void flush_current_bio_list(struct blk_plug_cb *cb, bool from_sched=
ule)
 {
=2D	struct dm_offload *o =3D container_of(cb, struct dm_offload, cb);
+	struct clone_info *ci =3D container_of(cb, struct clone_info, cb);
 	struct bio_list list;
=2D	struct bio *bio;
=2D	int i;
=20
=2D	INIT_LIST_HEAD(&o->cb.list);
+	INIT_LIST_HEAD(&cb->list);
=20
=2D	if (unlikely(!current->bio_list))
+	if (unlikely(!current->bio_list || bio_list_empty(&current->bio_list[0])))
 		return;
=20
=2D	for (i =3D 0; i < 2; i++) {
=2D		list =3D current->bio_list[i];
=2D		bio_list_init(&current->bio_list[i]);
=2D
=2D		while ((bio =3D bio_list_pop(&list))) {
=2D			struct bio_set *bs =3D bio->bi_pool;
=2D			if (unlikely(!bs) || bs =3D=3D fs_bio_set ||
=2D			    !bs->rescue_workqueue) {
=2D				bio_list_add(&current->bio_list[i], bio);
=2D				continue;
=2D			}
+	list =3D current->bio_list[0];
+	bio_list_init(&current->bio_list[0]);
+	spin_lock(&ci->md->deferred_lock);
+	bio_list_merge(&ci->md->rescued, &list);
+	spin_unlock(&ci->md->deferred_lock);
+	queue_work(ci->md->wq, &ci->md->work);
+}
=20
=2D			spin_lock(&bs->rescue_lock);
=2D			bio_list_add(&bs->rescue_list, bio);
=2D			queue_work(bs->rescue_workqueue, &bs->rescue_work);
=2D			spin_unlock(&bs->rescue_lock);
=2D		}
=2D	}
+static void dm_offload_start(struct clone_info *ci)
+{
+	blk_start_plug(&ci->plug);
+	INIT_LIST_HEAD(&ci->cb.list);
+	ci->cb.callback =3D flush_current_bio_list;
 }
=20
=2Dstatic void dm_offload_start(struct dm_offload *o)
+static void dm_offload_end(struct clone_info *ci)
 {
=2D	blk_start_plug(&o->plug);
=2D	o->cb.callback =3D flush_current_bio_list;
=2D	list_add(&o->cb.list, &current->plug->cb_list);
+	list_del(&ci->cb.list);
+	blk_finish_plug(&ci->plug);
 }
=20
=2Dstatic void dm_offload_end(struct dm_offload *o)
+static void dm_offload_check(struct clone_info *ci)
 {
=2D	list_del(&o->cb.list);
=2D	blk_finish_plug(&o->plug);
+	if (list_empty(&ci->cb.list))
+		list_add(&ci->cb.list, &current->plug->cb_list);
 }
=20
=2Dstatic void __map_bio(struct dm_target_io *tio)
+static void __map_bio(struct clone_info *ci, struct dm_target_io *tio)
 {
 	int r;
 	sector_t sector;
=2D	struct dm_offload o;
 	struct bio *clone =3D &tio->clone;
 	struct dm_target *ti =3D tio->ti;
=20
@@ -1206,9 +1204,8 @@ static void __map_bio(struct dm_target_io *tio)
 	atomic_inc(&tio->io->io_count);
 	sector =3D clone->bi_iter.bi_sector;
=20
=2D	dm_offload_start(&o);
+	dm_offload_check(ci);
 	r =3D ti->type->map(ti, clone);
=2D	dm_offload_end(&o);
=20
 	switch (r) {
 	case DM_MAPIO_SUBMITTED:
@@ -1233,15 +1230,6 @@ static void __map_bio(struct dm_target_io *tio)
 	}
 }
=20
=2Dstruct clone_info {
=2D	struct mapped_device *md;
=2D	struct dm_table *map;
=2D	struct bio *bio;
=2D	struct dm_io *io;
=2D	sector_t sector;
=2D	unsigned sector_count;
=2D};
=2D
 static void bio_setup_sector(struct bio *bio, sector_t sector, unsigned le=
n)
 {
 	bio->bi_iter.bi_sector =3D sector;
@@ -1291,6 +1279,7 @@ static struct dm_target_io *alloc_tio(struct clone_in=
fo *ci,
 	struct dm_target_io *tio;
 	struct bio *clone;
=20
+	dm_offload_check(ci);
 	clone =3D bio_alloc_bioset(GFP_NOIO, 0, ci->md->bs);
 	tio =3D container_of(clone, struct dm_target_io, clone);
=20
@@ -1314,7 +1303,7 @@ static void __clone_and_map_simple_bio(struct clone_i=
nfo *ci,
 	if (len)
 		bio_setup_sector(clone, ci->sector, *len);
=20
=2D	__map_bio(tio);
+	__map_bio(ci, tio);
 }
=20
 static void __send_duplicate_bios(struct clone_info *ci, struct dm_target =
*ti,
@@ -1361,7 +1350,7 @@ static int __clone_and_map_data_bio(struct clone_info=
 *ci, struct dm_target *ti,
 			free_tio(tio);
 			break;
 		}
=2D		__map_bio(tio);
+		__map_bio(ci, tio);
 	}
=20
 	return r;
@@ -1493,6 +1482,7 @@ static void __split_and_process_bio(struct mapped_dev=
ice *md,
 		bio_io_error(bio);
 		return;
 	}
+	dm_offload_start(&ci);
=20
 	ci.map =3D map;
 	ci.md =3D md;
@@ -1521,6 +1511,7 @@ static void __split_and_process_bio(struct mapped_dev=
ice *md,
 		while (ci.sector_count && !error)
 			error =3D __split_and_process_non_flush(&ci);
 	}
+	dm_offload_end(&ci);
=20
 	/* drop the extra reference count */
 	dec_pending(ci.io, error);
@@ -2248,6 +2239,16 @@ static void dm_wq_work(struct work_struct *work)
 	int srcu_idx;
 	struct dm_table *map;
=20
+	if (!bio_list_empty(&md->rescued)) {
+		struct bio_list list;
+		spin_lock_irq(&md->deferred_lock);
+		list =3D md->deferred;
+		bio_list_init(&md->deferred);
+		spin_unlock_irq(&md->deferred_lock);
+		while ((c =3D bio_list_pop(&md->deferred)) !=3D NULL)
+			generic_make_request(c);
+	}
+
 	map =3D dm_get_live_table(md, &srcu_idx);
=20
 	while (!test_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags)) {
@@ -2796,7 +2797,7 @@ struct dm_md_mempools *dm_alloc_md_mempools(struct ma=
pped_device *md, enum dm_qu
 		BUG();
 	}
=20
=2D	pools->bs =3D bioset_create(pool_size, front_pad, BIOSET_NEED_RESCUER);
+	pools->bs =3D bioset_create(pool_size, front_pad, 0);
 	if (!pools->bs)
 		goto out;
=20
=2D-=20
2.14.0.rc0.dirty


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlmnqisACgkQOeye3VZi
gblaxhAAiXoz/SQQkQieqv5DyfpCSBWKsc/oDaGk5/GI3Vs6AAhHn2MzUvKm7U/3
G8HXmUYr/Vmh/xGwiKFgSX/dfJkja6Skjn6GqQjltC9fwG3bmYf7lIeys4Q9rJ5F
ECDvmtuEk7poyIZ2vwSHH//4Ob8q82Zmz4+lW5idSIDTvfMceeyMM6fxEcPirMrV
3evta6UvbkhBQ9KUyDwp7F+FpcIHZC5jBz0NbZbFSvRMyriBeeD5Z/DWUPDfKelp
AiW/PqMctbH4MBk/cIFpzLEbPhlCwSVSgfa8xN5ql1Bf07+74Xz42kGnbZloqpWZ
o+FI+HtRP5Wj5wVm5lOP92eyEKysMOHIxDrPs3ETb1qFDP5xcVBQI4n7/oorkNYe
fJd4Xnd43M+KzUgG/e0UP+BThwvZw4FYtXx1fuYW38XfOXt77gKAvhatL/UbcVm2
i+8SVxfJirYlWiNVXXFYjeK1jJFu5egqp+5DcNgm3iHv/SvUrsVNSekKWzqv7UxB
LiMtSlrAyIw/tlVNc77XKQ1YEDgZOGDqx146QCeh6QjMKRN+5j6QQqOVsDgsHMS4
HCYBxJW/MpqHryO+JkIFrJfmTUDehTa1heIz3odQmvoaJ/wrsJ7qH5bMA+1C7CHJ
g0o8VihZ7F5wGbgRomvoIPS0toQDpFSCvsNwfOXdmIcwHJLtimI=
=Zcy4
-----END PGP SIGNATURE-----
--=-=-=--


--===============1703621525620444883==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1703621525620444883==--
