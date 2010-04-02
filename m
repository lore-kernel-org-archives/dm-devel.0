From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 2/7] Improve name used for "persistent store" in
	'struct dm_multisnap'
Date: Fri,  2 Apr 2010 01:17:53 -0400
Message-ID: <1270185478-8870-3-git-send-email-snitzer@redhat.com>
References: <1270185478-8870-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1270185478-8870-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Renamed 'struct dm_exception_store *p' to 'ps' in 'struct dm_multisnap'.
While not perfect, 'ps' does offer some addiitonal consistency relative
to the existing snapshot code base.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-multisnap-private.h |    6 +---
 drivers/md/dm-multisnap.c         |   72 ++++++++++++++++++------------------
 2 files changed, 37 insertions(+), 41 deletions(-)

diff --git a/drivers/md/dm-multisnap-private.h b/drivers/md/dm-multisnap-private.h
index 5d13ded..935ddc1 100644
--- a/drivers/md/dm-multisnap-private.h
+++ b/drivers/md/dm-multisnap-private.h
@@ -40,12 +40,8 @@ struct dm_multisnap_bio_queue {
 #define DM_MULTISNAP_N_QUEUES	2
 
 struct dm_multisnap {
-	/* FIXME rename 'p' to be more descriptive, maybe 'ps' or 'pstore' for persistent store? */
-	/* FIXME also reorder in struct; put 'store' before 'ps' (_init() order)? */
-	// struct dm_multisnap_exception_store *store;
-	// struct dm_multisnap_persistent_exception_store *ps;
-	struct dm_exception_store *p;
 	struct dm_multisnap_exception_store *store;
+	struct dm_exception_store *ps;
 
 	struct dm_dev *origin;
 	struct dm_dev *snapshot;
diff --git a/drivers/md/dm-multisnap.c b/drivers/md/dm-multisnap.c
index a1727a9..e0e2c3e 100644
--- a/drivers/md/dm-multisnap.c
+++ b/drivers/md/dm-multisnap.c
@@ -19,12 +19,12 @@ static void dm_multisnap_process_bios(struct dm_multisnap *s);
 static void dm_multisnap_lock(struct dm_multisnap *s)
 {
 	mutex_lock(&s->master_lock);
-	if (s->p && s->store->store_lock_acquired)
+	if (s->ps && s->store->store_lock_acquired)
 		/*
 		 * Flags is currently unused, it will be used to flush cache
 		 * in clustered environment
 		 */
-		s->store->store_lock_acquired(s->p, 0);
+		s->store->store_lock_acquired(s->ps, 0);
 }
 
 static void dm_multisnap_unlock(struct dm_multisnap *s)
@@ -125,7 +125,7 @@ static sector_t chunk_to_sector(struct dm_multisnap *s, chunk_t chunk)
 
 int dm_multisnap_snapshot_exists(struct dm_multisnap *s, snapid_t snapid)
 {
-	return snapid == s->store->get_next_snapid(s->p, snapid);
+	return snapid == s->store->get_next_snapid(s->ps, snapid);
 }
 EXPORT_SYMBOL(dm_multisnap_snapshot_exists);
 
@@ -146,7 +146,7 @@ static void print_snapid(struct dm_multisnap *s, char *string,
 			 unsigned maxlen, snapid_t snapid)
 {
 	if (s->store->print_snapid)
-		s->store->print_snapid(s->p, string, maxlen, snapid);
+		s->store->print_snapid(s->ps, string, maxlen, snapid);
 	else
 		snprintf(string, maxlen, "%llu", (unsigned long long)snapid);
 }
@@ -155,7 +155,7 @@ static int read_snapid(struct dm_multisnap *s, char *string,
 		       snapid_t *snapid, char **error)
 {
 	if (s->store->read_snapid)
-		return s->store->read_snapid(s->p, string, snapid, error);
+		return s->store->read_snapid(s->ps, string, snapid, error);
 	else {
 		int r;
 
@@ -398,7 +398,7 @@ static int check_pending_io(struct dm_multisnap *s, struct bio *bio,
 			if (snapid == DM_SNAPID_T_ORIGIN)
 				goto conflict;
 			for (i = 0; i < pe->n_descs; i++) {
-				if (s->store->check_conflict(s->p, &pe->desc[i], snapid))
+				if (s->store->check_conflict(s->ps, &pe->desc[i], snapid))
 					goto conflict;
 			}
 		}
@@ -431,7 +431,7 @@ EXPORT_SYMBOL(dm_multisnap_can_commit);
 void dm_multisnap_call_commit(struct dm_multisnap *s)
 {
 	s->kcopyd_jobs_last_commit_count = s->kcopyd_jobs_finished_count;
-	s->store->commit(s->p);
+	s->store->commit(s->ps);
 	s->commit_sequence++;
 }
 EXPORT_SYMBOL(dm_multisnap_call_commit);
@@ -497,7 +497,7 @@ static void remap_callback(int read_err, unsigned long write_err, void *pe_)
 		return;
 
 	if (s->store->prepare_for_commit)
-		s->store->prepare_for_commit(s->p);
+		s->store->prepare_for_commit(s->ps);
 
 	dm_multisnap_lock(s);
 
@@ -620,11 +620,11 @@ static void do_origin_write(struct dm_multisnap *s, struct bio *bio)
 	if (unlikely(dm_multisnap_has_error(s)))
 		goto err_endio;
 
-	s->store->reset_query(s->p);
+	s->store->reset_query(s->ps);
 
 	chunk = sector_to_chunk(s, bio->bi_sector);
 
-	r = s->store->query_next_remap(s->p, chunk);
+	r = s->store->query_next_remap(s->ps, chunk);
 	if (unlikely(r < 0))
 		goto err_endio;
 
@@ -655,14 +655,14 @@ dispatch_write:
 	i = 0;
 	goto skip_query_next_remap;
 	for (; i < DM_MULTISNAP_MAX_CHUNKS_TO_REMAP; i++) {
-		r = s->store->query_next_remap(s->p, chunk);
+		r = s->store->query_next_remap(s->ps, chunk);
 		if (unlikely(r < 0))
 			goto free_err_endio;
 		if (likely(!r))
 			break;
 
 skip_query_next_remap:
-		s->store->add_next_remap(s->p, &pe->desc[i], &new_chunk);
+		s->store->add_next_remap(s->ps, &pe->desc[i], &new_chunk);
 		if (unlikely(dm_multisnap_has_error(s)))
 			goto free_err_endio;
 
@@ -704,7 +704,7 @@ static void do_snapshot_io(struct dm_multisnap *s, struct bio *bio, snapid_t id)
 		goto err_endio;
 
 	chunk = sector_to_chunk(s, bio->bi_sector);
-	r = s->store->find_snapshot_chunk(s->p, id, chunk,
+	r = s->store->find_snapshot_chunk(s->ps, id, chunk,
 					  bio_rw(bio) == WRITE, &result);
 	if (unlikely(r < 0))
 		goto err_endio;
@@ -751,7 +751,7 @@ static void do_snapshot_io(struct dm_multisnap *s, struct bio *bio, snapid_t id)
 			if (unlikely(!pe))
 				goto failed_pe_allocation;
 
-			s->store->add_next_remap(s->p, &pe->desc[0], &result);
+			s->store->add_next_remap(s->ps, &pe->desc[0], &result);
 			if (unlikely(dm_multisnap_has_error(s)))
 				goto free_err_endio;
 
@@ -774,7 +774,7 @@ static void do_snapshot_io(struct dm_multisnap *s, struct bio *bio, snapid_t id)
 			if (unlikely(!pe))
 				goto failed_pe_allocation;
 
-			s->store->make_chunk_writeable(s->p, &pe->desc[0], &result);
+			s->store->make_chunk_writeable(s->ps, &pe->desc[0], &result);
 			if (unlikely(dm_multisnap_has_error(s)))
 				goto free_err_endio;
 
@@ -827,7 +827,7 @@ again:
 				   struct dm_multisnap_background_work, list);
 		list_del(&bw->list);
 		bw->queued = 0;
-		bw->work(s->p, bw);
+		bw->work(s->ps, bw);
 
 		cond_resched();
 	}
@@ -1128,7 +1128,7 @@ static int multisnap_origin_ctr(struct dm_target *ti, unsigned argc, char **argv
 
 	ti->private = s;
 
-	s->p = NULL;
+	s->ps = NULL;
 	s->error = 0;
 	s->flags = 0;
 	mutex_init(&s->master_lock);
@@ -1274,9 +1274,9 @@ static int multisnap_origin_ctr(struct dm_target *ti, unsigned argc, char **argv
 	}
 
 	dm_multisnap_lock(s);
-	r = s->store->init_exception_store(s, &s->p, store_args, argv, &ti->error);
+	r = s->store->init_exception_store(s, &s->ps, store_args, argv, &ti->error);
 	if (r) {
-		s->p = NULL;
+		s->ps = NULL;
 		goto exception_store_error;
 	}
 
@@ -1318,23 +1318,23 @@ static int multisnap_origin_ctr(struct dm_target *ti, unsigned argc, char **argv
 
 		/* Delete the snapshots that shouldn't be there */
 		sort(snapids, num_snapshots, sizeof(snapid_t), compare_snapids, NULL);
-		sn = s->store->get_next_snapid(s->p, 0);
+		sn = s->store->get_next_snapid(s->ps, 0);
 		for (n = 0; n <= num_snapshots; n++) {
 			while (sn < snapids[n]) {
 				if (!dm_multisnap_has_error(s)) {
-					r = s->store->delete_snapshot(s->p, sn);
+					r = s->store->delete_snapshot(s->ps, sn);
 					if (r && s->flags & DM_MULTISNAP_PRESERVE_ON_ERROR) {
 						ti->error = "Could not delete snapshot";
 						vfree(snapids);
 						goto error_syncing_snapshots;
 					}
 				}
-				sn = s->store->get_next_snapid(s->p, sn + 1);
+				sn = s->store->get_next_snapid(s->ps, sn + 1);
 				if (sn == DM_SNAPID_T_ORIGIN)
 					goto delete_done;
 			}
 			if (sn == snapids[n]) {
-				sn = s->store->get_next_snapid(s->p, sn + 1);
+				sn = s->store->get_next_snapid(s->ps, sn + 1);
 				if (sn == DM_SNAPID_T_ORIGIN)
 					goto delete_done;
 			}
@@ -1347,7 +1347,7 @@ delete_done:
 		for (n = 0; n <= num_snapshots; n++) {
 			if (!dm_multisnap_snapshot_exists(s, snapids[n])) {
 				if (!dm_multisnap_has_error(s)) {
-					r = s->store->create_snapshot(s->p, snapids[n]);
+					r = s->store->create_snapshot(s->ps, snapids[n]);
 					if (r && s->flags & DM_MULTISNAP_PRESERVE_ON_ERROR) {
 						ti->error = "Could not create snapshot";
 						vfree(snapids);
@@ -1367,8 +1367,8 @@ delete_done:
 	return 0;
 
 error_syncing_snapshots:
-	s->store->exit_exception_store(s->p);
-	s->p = NULL;
+	s->store->exit_exception_store(s->ps);
+	s->ps = NULL;
 exception_store_error:
 	dm_multisnap_unlock(s);
 	destroy_workqueue(s->wq);
@@ -1449,13 +1449,13 @@ poll_for_ios:
 
 	dm_multisnap_lock(s);
 	dm_multisnap_call_commit(s);
-	s->store->exit_exception_store(s->p);
-	s->p = NULL;
+	s->store->exit_exception_store(s->ps);
+	s->ps = NULL;
 	list_del(&s->list_all);
 	dm_multisnap_unlock(s);
 
 	destroy_workqueue(s->wq);
-	kfree(s->p);
+	kfree(s->ps);
 	dm_kcopyd_client_destroy(s->kcopyd);
 	mempool_destroy(s->tracked_chunk_pool);
 	mempool_destroy(s->pending_pool);
@@ -1575,7 +1575,7 @@ create_snapshot:
 		s->new_snapid_valid = 0;
 		dm_multisnap_status_unlock(s);
 
-		r = s->store->allocate_snapid(s->p, &s->new_snapid,
+		r = s->store->allocate_snapid(s->ps, &s->new_snapid,
 					      subsnap, subsnap_id);
 		if (r)
 			goto unlock_ret;
@@ -1641,7 +1641,7 @@ create_snapshot:
 			goto unlock_ret;
 		}
 
-		r = s->store->delete_snapshot(s->p, snapid);
+		r = s->store->delete_snapshot(s->ps, snapid);
 		if (r)
 			goto unlock_ret;
 
@@ -1668,12 +1668,12 @@ static void print_snapshot_ids(struct dm_multisnap *s, char *result, unsigned ma
 {
 	snapid_t nsnap = 0;
 	snapid_t sn = 0;
-	while ((sn = s->store->get_next_snapid(s->p, sn)) != DM_SNAPID_T_ORIGIN)
+	while ((sn = s->store->get_next_snapid(s->ps, sn)) != DM_SNAPID_T_ORIGIN)
 		sn++, nsnap++;
 	snprintf(result, maxlen, " %llu", (unsigned long long)nsnap);
 	dm_multisnap_adjust_string(&result, &maxlen);
 	sn = 0;
-	while ((sn = s->store->get_next_snapid(s->p, sn)) != DM_SNAPID_T_ORIGIN) {
+	while ((sn = s->store->get_next_snapid(s->ps, sn)) != DM_SNAPID_T_ORIGIN) {
 		snprintf(result, maxlen, " ");
 		dm_multisnap_adjust_string(&result, &maxlen);
 		print_snapid(s, result, maxlen, sn);
@@ -1705,7 +1705,7 @@ static int multisnap_origin_status(struct dm_target *ti, status_type_t type,
 				snprintf(result, maxlen, "-");
 			dm_multisnap_adjust_string(&result, &maxlen);
 			if (s->store->get_space)
-				s->store->get_space(s->p, &total, &alloc, &meta);
+				s->store->get_space(s->ps, &total, &alloc, &meta);
 			else
 				total = alloc = meta = 0;
 			total <<= s->chunk_shift - SECTOR_SHIFT;
@@ -1735,7 +1735,7 @@ static int multisnap_origin_status(struct dm_target *ti, status_type_t type,
 				s->store->name);
 			dm_multisnap_adjust_string(&result, &maxlen);
 			if (s->store->status_table)
-				s->store->status_table(s->p, result, maxlen);
+				s->store->status_table(s->ps, result, maxlen);
 			else
 				snprintf(result, maxlen, " 0");
 			dm_multisnap_adjust_string(&result, &maxlen);
@@ -1767,7 +1767,7 @@ static void multisnap_origin_postsuspend(struct dm_target *ti)
 		 * No way to return the error code, but it is recorded
 		 * in s->error anyway.
 		 */
-		s->store->create_snapshot(s->p, s->new_snapid);
+		s->store->create_snapshot(s->ps, s->new_snapid);
 		s->new_snapid_valid = 0;
 	}
 	dm_multisnap_unlock(s);
-- 
1.6.6.1
