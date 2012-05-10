From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCHES]: dm lock optimization
Date: Thu, 10 May 2012 13:33:53 +0900
Message-ID: <4FAB4531.4010704@ce.jp.nec.com>
References: <Pine.LNX.4.64.1204182249060.12984@file.rdu.redhat.com>
	<4F8F9FDA.1000103@ce.jp.nec.com>
	<Pine.LNX.4.64.1204211215230.3269@file.rdu.redhat.com>
	<4F953574.3000702@ce.jp.nec.com>
	<Pine.LNX.4.64.1205012214560.24798@file.rdu.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.1205012214560.24798@file.rdu.redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

Hi Mikulas,

On 05/02/12 11:17, Mikulas Patocka wrote:
> I placed the new code using srcu here: 
> http://people.redhat.com/mpatocka/patches/kernel/dm-lock-optimization/
> 
> It removes io_lock, map_lock and holders and replaces them with srcu.

I've reviewed the patches and here are some comments.
The 1st one seems to be a bug.
Others are minor comments about readability.

  - There are functions destroying inactive table
    without SRCU synchronization.
      * table_load
      * table_clear
      * do_resume
      * __hash_remove
    It could cause use-after-free by the user of
    dm_get_inactive_table().
    synchronization is needed, outside of exclusive hash_lock.

  - I couldn't see the reason why locking is different
    for request-based in dm_wq_work().

  - We could use dm_get_live_table() in the caller of
    __split_and_process_bio() and pass the result to it.
    Then, naked use of srcu_read_lock/unlock and
    rcu_dereference can be eliminated.
    I think it helps readability.

  - md->map is directly referenced in dm_suspend/dm_resume.
    It's ok because md->suspend_lock is taken and nobody
    can replace md->map. I think it's worth putting a comment
    in 'struct mapped_device' about the rule.

Attached patch explains the above comments by code.

>> synchronize_rcu could be put in dm_table_destroy() instead of __bind().
>> I think it's safer place to wait.
> 
> I think the code is more readable if synchronizing rcu is just after 
> assigning the pointer that is protected by rcu.

OK. I don't object.

Thanks,
--- 
Jun'ichi Nomura, NEC Corporation

* Added a comment about locking for reading md->map
* dm_sync_table() to wait for other processes to exit from
  read-side critical section
* __split_and_process_bio() takes map
* __hash_remove() returns a table pointer to be destroyed later
* Added dm_sync_table() in functions in dm-ioctl.c to synchronize with
  inactive table users

Index: linux-3.3/drivers/md/dm.c
===================================================================
--- linux-3.3.orig/drivers/md/dm.c	2012-05-10 12:19:10.977242964 +0900
+++ linux-3.3/drivers/md/dm.c	2012-05-10 13:54:30.150853855 +0900
@@ -141,6 +141,8 @@ struct mapped_device {
 
 	/*
 	 * The current mapping.
+	 * Use dm_get_live_table{_fast} or take suspend_lock for
+	 * dereference.
 	 */
 	struct dm_table *map;
 
@@ -561,6 +563,12 @@ void dm_put_live_table(struct mapped_dev
 	srcu_read_unlock(&md->io_barrier, srcu_idx);
 }
 
+void dm_sync_table(struct mapped_device *md)
+{
+	synchronize_srcu(&md->io_barrier);
+	synchronize_rcu_expedited();
+}
+
 /*
  * A fast alternative to dm_get_live_table/dm_put_live_table.
  * The caller must not block between these two functions.
@@ -1316,17 +1324,18 @@ static int __clone_and_map(struct clone_
 /*
  * Split the bio into several clones and submit it to targets.
  */
-static void __split_and_process_bio(struct mapped_device *md, struct bio *bio)
+static void __split_and_process_bio(struct mapped_device *md,
+				    struct dm_table *map, struct bio *bio)
 {
 	struct clone_info ci;
 	int error = 0;
 
-	ci.map = srcu_dereference(md->map, &md->io_barrier);
-	if (unlikely(!ci.map)) {
+	if (unlikely(!map)) {
 		bio_io_error(bio);
 		return;
 	}
 
+	ci.map = map;
 	ci.md = md;
 	ci.io = alloc_io(md);
 	ci.io->error = 0;
@@ -1422,8 +1431,9 @@ static void _dm_request(struct request_q
 	struct mapped_device *md = q->queuedata;
 	int cpu;
 	int srcu_idx;
+	struct dm_table *map;
 
-	srcu_idx = srcu_read_lock(&md->io_barrier);
+	map = dm_get_live_table(md, &srcu_idx);
 
 	cpu = part_stat_lock();
 	part_stat_inc(cpu, &dm_disk(md)->part0, ios[rw]);
@@ -1432,7 +1442,7 @@ static void _dm_request(struct request_q
 
 	/* if we're suspended, we have to queue this io for later */
 	if (unlikely(test_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags))) {
-		srcu_read_unlock(&md->io_barrier, srcu_idx);
+		dm_put_live_table(md, srcu_idx);
 
 		if (bio_rw(bio) != READA)
 			queue_io(md, bio);
@@ -1441,8 +1451,8 @@ static void _dm_request(struct request_q
 		return;
 	}
 
-	__split_and_process_bio(md, bio);
-	srcu_read_unlock(&md->io_barrier, srcu_idx);
+	__split_and_process_bio(md, map, bio);
+	dm_put_live_table(md, srcu_idx);
 	return;
 }
 
@@ -2115,8 +2125,7 @@ static struct dm_table *__bind(struct ma
 		set_bit(DMF_MERGE_IS_OPTIONAL, &md->flags);
 	else
 		clear_bit(DMF_MERGE_IS_OPTIONAL, &md->flags);
-	synchronize_srcu(&md->io_barrier);
-	synchronize_rcu_expedited();
+	dm_sync_table(md);
 
 	return old_map;
 }
@@ -2133,8 +2142,7 @@ static struct dm_table *__unbind(struct 
 
 	dm_table_event_callback(map, NULL, NULL);
 	rcu_assign_pointer(md->map, NULL);
-	synchronize_srcu(&md->io_barrier);
-	synchronize_rcu_expedited();
+	dm_sync_table(md);
 
 	return map;
 }
@@ -2375,8 +2383,9 @@ static void dm_wq_work(struct work_struc
 						work);
 	struct bio *c;
 	int srcu_idx;
+	struct dm_table *map;
 
-	srcu_idx = srcu_read_lock(&md->io_barrier);
+	map = dm_get_live_table(md, &srcu_idx);
 
 	while (!test_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags)) {
 		spin_lock_irq(&md->deferred_lock);
@@ -2386,15 +2395,13 @@ static void dm_wq_work(struct work_struc
 		if (!c)
 			break;
 
-		if (dm_request_based(md)) {
-			srcu_read_unlock(&md->io_barrier, srcu_idx);
+		if (dm_request_based(md))
 			generic_make_request(c);
-			srcu_idx = srcu_read_lock(&md->io_barrier);
-		} else
-			__split_and_process_bio(md, c);
+		else
+			__split_and_process_bio(md, map, c);
 	}
 
-	srcu_read_unlock(&md->io_barrier, srcu_idx);
+	dm_put_live_table(md, srcu_idx);
 }
 
 static void dm_queue_flush(struct mapped_device *md)
Index: linux-3.3/drivers/md/dm-ioctl.c
===================================================================
--- linux-3.3.orig/drivers/md/dm-ioctl.c	2012-05-10 12:19:10.995242964 +0900
+++ linux-3.3/drivers/md/dm-ioctl.c	2012-05-10 12:54:30.312180811 +0900
@@ -250,7 +250,7 @@ static int dm_hash_insert(const char *na
 	return -EBUSY;
 }
 
-static void __hash_remove(struct hash_cell *hc)
+static struct dm_table *__hash_remove(struct hash_cell *hc)
 {
 	struct dm_table *table;
 	int srcu_idx;
@@ -267,10 +267,13 @@ static void __hash_remove(struct hash_ce
 		dm_table_event(table);
 	dm_put_live_table(hc->md, srcu_idx);
 
+	table = NULL;
 	if (hc->new_map)
-		dm_table_destroy(hc->new_map);
+		table = hc->new_map;
 	dm_put(hc->md);
 	free_cell(hc);
+
+	return table;
 }
 
 static void dm_hash_remove_all(int keep_open_devices)
@@ -278,6 +281,7 @@ static void dm_hash_remove_all(int keep_
 	int i, dev_skipped;
 	struct hash_cell *hc;
 	struct mapped_device *md;
+	struct dm_table *t;
 
 retry:
 	dev_skipped = 0;
@@ -295,10 +299,14 @@ retry:
 				continue;
 			}
 
-			__hash_remove(hc);
+			t = __hash_remove(hc);
 
 			up_write(&_hash_lock);
 
+			if (t) {
+				dm_sync_table(md);
+				dm_table_destroy(t);
+			}
 			dm_put(md);
 			if (likely(keep_open_devices))
 				dm_destroy(md);
@@ -808,6 +816,7 @@ static int dev_remove(struct dm_ioctl *p
 	struct hash_cell *hc;
 	struct mapped_device *md;
 	int r;
+	struct dm_table *t;
 
 	down_write(&_hash_lock);
 	hc = __find_device_hash_cell(param);
@@ -831,9 +840,14 @@ static int dev_remove(struct dm_ioctl *p
 		return r;
 	}
 
-	__hash_remove(hc);
+	t = __hash_remove(hc);
 	up_write(&_hash_lock);
 
+	if (t) {
+		dm_sync_table(md);
+		dm_table_destroy(t);
+	}
+
 	if (!dm_kobject_uevent(md, KOBJ_REMOVE, param->event_nr))
 		param->flags |= DM_UEVENT_GENERATED_FLAG;
 
@@ -997,6 +1011,7 @@ static int do_resume(struct dm_ioctl *pa
 
 		old_map = dm_swap_table(md, new_map);
 		if (IS_ERR(old_map)) {
+			dm_sync_table(md);
 			dm_table_destroy(new_map);
 			dm_put(md);
 			return PTR_ERR(old_map);
@@ -1014,6 +1029,10 @@ static int do_resume(struct dm_ioctl *pa
 			param->flags |= DM_UEVENT_GENERATED_FLAG;
 	}
 
+	/*
+	 * Since dm_swap_table synchronizes RCU, nobody should be in
+	 * read-side critical section already.
+	 */
 	if (old_map)
 		dm_table_destroy(old_map);
 
@@ -1225,7 +1244,7 @@ static int table_load(struct dm_ioctl *p
 {
 	int r;
 	struct hash_cell *hc;
-	struct dm_table *t;
+	struct dm_table *t, *old_map = NULL;
 	struct mapped_device *md;
 	struct target_type *immutable_target_type;
 
@@ -1281,14 +1300,14 @@ static int table_load(struct dm_ioctl *p
 	hc = dm_get_mdptr(md);
 	if (!hc || hc->md != md) {
 		DMWARN("device has been removed from the dev hash table.");
-		dm_table_destroy(t);
 		up_write(&_hash_lock);
+		dm_table_destroy(t);
 		r = -ENXIO;
 		goto out;
 	}
 
 	if (hc->new_map)
-		dm_table_destroy(hc->new_map);
+		old_map = hc->new_map;
 	hc->new_map = t;
 	up_write(&_hash_lock);
 
@@ -1296,6 +1315,11 @@ static int table_load(struct dm_ioctl *p
 	__dev_status(md, param);
 
 out:
+	if (old_map) {
+		dm_sync_table(md);
+		dm_table_destroy(old_map);
+	}
+
 	dm_put(md);
 
 	return r;
@@ -1305,6 +1329,7 @@ static int table_clear(struct dm_ioctl *
 {
 	struct hash_cell *hc;
 	struct mapped_device *md;
+	struct dm_table *old_map = NULL;
 
 	down_write(&_hash_lock);
 
@@ -1316,7 +1341,7 @@ static int table_clear(struct dm_ioctl *
 	}
 
 	if (hc->new_map) {
-		dm_table_destroy(hc->new_map);
+		old_map = hc->new_map;
 		hc->new_map = NULL;
 	}
 
@@ -1325,6 +1350,10 @@ static int table_clear(struct dm_ioctl *
 	__dev_status(hc->md, param);
 	md = hc->md;
 	up_write(&_hash_lock);
+	if (old_map) {
+		dm_sync_table(md);
+		dm_table_destroy(old_map);
+	}
 	dm_put(md);
 
 	return 0;
Index: linux-3.3/include/linux/device-mapper.h
===================================================================
--- linux-3.3.orig/include/linux/device-mapper.h	2012-05-10 10:03:06.000000000 +0900
+++ linux-3.3/include/linux/device-mapper.h	2012-05-10 12:45:48.510196182 +0900
@@ -364,6 +364,7 @@ int dm_table_complete(struct dm_table *t
  */
 struct dm_table *dm_get_live_table(struct mapped_device *md, int *srcu_idx);
 void dm_put_live_table(struct mapped_device *md, int srcu_idx);
+void dm_sync_table(struct mapped_device *md);
 
 /*
  * Queries
