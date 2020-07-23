From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH v2] dm-integrity: revert adc0daad366b to fix
	recalculation
Date: Thu, 23 Jul 2020 10:42:09 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.2007231036570.17947@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2007221444390.6426@file01.intranet.prod.int.rdu2.redhat.com>
	<20200722194536.GA28682@redhat.com>
	<alpine.LRH.2.02.2007221601140.16826@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.2007221601140.16826@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, Marian Csontos <mcsontos@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids



On Wed, 22 Jul 2020, Mikulas Patocka wrote:

> 
> 
> On Wed, 22 Jul 2020, Mike Snitzer wrote:
> 
> > On Wed, Jul 22 2020 at  2:46pm -0400,
> > Mikulas Patocka <mpatocka@redhat.com> wrote:
> > 
> > > Hi Mike
> > > 
> > > Please submit this to Linus and to RHEL-8.
> > > 
> > > Mikulas
> > > 
> > > 
> > > 
> > > From: Mikulas Patocka <mpatocka@redhat.com>
> > > 
> > > The patch adc0daad366b62ca1bce3e2958a40b0b71a8b8b3 broke recalculation on
> > > dm-integrity. The patch replaces a private variable "suspending" with a
> > > call to "dm_suspended".
> > > 
> > > The problem is that dm_suspended returns true not only during suspend, but
> > > also during resume. This race condition could occur:
> > > 1. dm_integrity_resume calls queue_work(ic->recalc_wq, &ic->recalc_work)
> > > 2. integrity_recalc (&ic->recalc_work) preempts the current thread
> > > 3. integrity_recalc calls if (unlikely(dm_suspended(ic->ti))) goto unlock_ret;
> > > 4. integrity_recalc exits and no recalculating is done.
> > > 
> > > In order to fix this race condition, we stop using dm_suspended and start
> > > using the variable "suspending" (that is only set during suspend, not
> > > during resume).
> > > 
> > > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > > Fixes: adc0daad366b ("dm: report suspended device during destroy")
> > > Cc: stable@vger.kernel.org	# v4.18+
> > 
> > OK, but why not add a dm_suspending() to DM core?  Could be other
> > future targets would like this same info right?  I don't see harm in
> > elevating it.
> > 
> > Mike
> 
> Yes - it may be possible to add this.
> 
> Mikulas

From: Mikulas Patocka <mpatocka@redhat.com>

The patch adc0daad366b62ca1bce3e2958a40b0b71a8b8b3 broke recalculation on
dm-integrity. The patch replaces a private variable "suspending" with a
call to "dm_suspended".

The problem is that dm_suspended returns true not only during suspend, but
also during resume. This race condition could occur:
1. dm_integrity_resume calls queue_work(ic->recalc_wq, &ic->recalc_work)
2. integrity_recalc (&ic->recalc_work) preempts the current thread
3. integrity_recalc calls if (unlikely(dm_suspended(ic->ti))) goto unlock_ret;
4. integrity_recalc exits and no recalculating is done.

In order to fix this race condition, we add a function dm_suspending that
is only true during the postsuspend phase and use it instead of
dm_suspended.

Signed-off-by: Mikulas Patocka <mpatocka redhat com>
Fixes: adc0daad366b ("dm: report suspended device during destroy")
Cc: stable vger kernel org      # v4.18+

Index: rhel8/drivers/md/dm.c
===================================================================
--- rhel8.orig/drivers/md/dm.c
+++ rhel8/drivers/md/dm.c
@@ -140,6 +140,7 @@ EXPORT_SYMBOL_GPL(dm_bio_get_target_bio_
 #define DMF_NOFLUSH_SUSPENDING 5
 #define DMF_DEFERRED_REMOVE 6
 #define DMF_SUSPENDED_INTERNALLY 7
+#define DMF_SUSPENDING 8
 
 #define DM_NUMA_NODE NUMA_NO_NODE
 static int dm_numa_node = DM_NUMA_NODE;
@@ -2379,6 +2380,7 @@ static void __dm_destroy(struct mapped_d
 	if (!dm_suspended_md(md)) {
 		dm_table_presuspend_targets(map);
 		set_bit(DMF_SUSPENDED, &md->flags);
+		set_bit(DMF_SUSPENDING, &md->flags);
 		dm_table_postsuspend_targets(map);
 	}
 	/* dm_put_live_table must be before msleep, otherwise deadlock is possible */
@@ -2701,7 +2703,9 @@ retry:
 	if (r)
 		goto out_unlock;
 
+	set_bit(DMF_SUSPENDING, &md->flags);
 	dm_table_postsuspend_targets(map);
+	clear_bit(DMF_SUSPENDING, &md->flags);
 
 out_unlock:
 	mutex_unlock(&md->suspend_lock);
@@ -2798,7 +2802,9 @@ static void __dm_internal_suspend(struct
 	(void) __dm_suspend(md, map, suspend_flags, TASK_UNINTERRUPTIBLE,
 			    DMF_SUSPENDED_INTERNALLY);
 
+	set_bit(DMF_SUSPENDING, &md->flags);
 	dm_table_postsuspend_targets(map);
+	clear_bit(DMF_SUSPENDING, &md->flags);
 }
 
 static void __dm_internal_resume(struct mapped_device *md)
@@ -2951,6 +2957,11 @@ int dm_suspended_md(struct mapped_device
 	return test_bit(DMF_SUSPENDED, &md->flags);
 }
 
+static int dm_suspending_md(struct mapped_device *md)
+{
+	return test_bit(DMF_SUSPENDING, &md->flags);
+}
+
 int dm_suspended_internally_md(struct mapped_device *md)
 {
 	return test_bit(DMF_SUSPENDED_INTERNALLY, &md->flags);
@@ -2967,6 +2978,12 @@ int dm_suspended(struct dm_target *ti)
 }
 EXPORT_SYMBOL_GPL(dm_suspended);
 
+int dm_suspending(struct dm_target *ti)
+{
+	return dm_suspending_md(dm_table_get_md(ti->table));
+}
+EXPORT_SYMBOL_GPL(dm_suspending);
+
 int dm_noflush_suspending(struct dm_target *ti)
 {
 	return __noflush_suspending(dm_table_get_md(ti->table));
Index: rhel8/drivers/md/dm-integrity.c
===================================================================
--- rhel8.orig/drivers/md/dm-integrity.c
+++ rhel8/drivers/md/dm-integrity.c
@@ -2428,7 +2428,7 @@ static void integrity_writer(struct work
 	unsigned prev_free_sectors;
 
 	/* the following test is not needed, but it tests the replay code */
-	if (unlikely(dm_suspended(ic->ti)) && !ic->meta_dev)
+	if (unlikely(dm_suspending(ic->ti)) && !ic->meta_dev)
 		return;
 
 	spin_lock_irq(&ic->endio_wait.lock);
@@ -2489,7 +2489,7 @@ static void integrity_recalc(struct work
 
 next_chunk:
 
-	if (unlikely(dm_suspended(ic->ti)))
+	if (unlikely(dm_suspending(ic->ti)))
 		goto unlock_ret;
 
 	range.logical_sector = le64_to_cpu(ic->sb->recalc_sector);
Index: rhel8/include/linux/device-mapper.h
===================================================================
--- rhel8.orig/include/linux/device-mapper.h
+++ rhel8/include/linux/device-mapper.h
@@ -426,6 +426,7 @@ const char *dm_device_name(struct mapped
 int dm_copy_name_and_uuid(struct mapped_device *md, char *name, char *uuid);
 struct gendisk *dm_disk(struct mapped_device *md);
 int dm_suspended(struct dm_target *ti);
+int dm_suspending(struct dm_target *ti);
 int dm_noflush_suspending(struct dm_target *ti);
 void dm_accept_partial_bio(struct bio *bio, unsigned n_sectors);
 union map_info *dm_get_rq_mapinfo(struct request *rq);
