From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 07/19] io-controller: Export disk time used and
	nr sectors dipatched through cgroups
Date: Mon,  8 Jun 2009 22:08:50 -0400
Message-ID: <1244513342-11758-8-git-send-email-vgoyal@redhat.com>
References: <1244513342-11758-1-git-send-email-vgoyal@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1244513342-11758-1-git-send-email-vgoyal@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google
Cc: peterz@infradead.org, akpm@linux-foundation.org, snitzer@redhat.com, agk@redhat.com, vgoyal@redhat.com
List-Id: dm-devel.ids

o This patch exports some statistics through cgroup interface. Two of the
  statistics currently exported are actual disk time assigned to the cgroup
  and actual number of sectors dispatched to disk on behalf of this cgroup.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/elevator-fq.c |   89 +++++++++++++++++++++++++++++++++++++++++++++++---
 block/elevator-fq.h |   10 ++++++
 2 files changed, 93 insertions(+), 6 deletions(-)

diff --git a/block/elevator-fq.c b/block/elevator-fq.c
index 1640949..7165902 100644
--- a/block/elevator-fq.c
+++ b/block/elevator-fq.c
@@ -13,6 +13,7 @@
 #include <linux/blkdev.h>
 #include "elevator-fq.h"
 #include <linux/blktrace_api.h>
+#include <linux/seq_file.h>
 
 /* Values taken from cfq */
 const int elv_slice_sync = HZ / 10;
@@ -916,12 +917,15 @@ struct io_entity *bfq_lookup_next_entity(struct io_sched_data *sd,
 	return entity;
 }
 
-void entity_served(struct io_entity *entity, bfq_service_t served)
+void entity_served(struct io_entity *entity, bfq_service_t served,
+					bfq_service_t nr_sectors)
 {
 	struct io_service_tree *st;
 	for_each_entity(entity) {
 		st = io_entity_service_tree(entity);
 		entity->service += served;
+		entity->total_service += served;
+		entity->total_sector_service += nr_sectors;
 		BUG_ON(st->wsum == 0);
 		st->vtime += bfq_delta(served, st->wsum);
 		bfq_forget_idle(st);
@@ -1082,6 +1086,66 @@ STORE_FUNCTION(weight, 1, WEIGHT_MAX);
 STORE_FUNCTION(ioprio_class, IOPRIO_CLASS_RT, IOPRIO_CLASS_IDLE);
 #undef STORE_FUNCTION
 
+static int io_cgroup_disk_time_read(struct cgroup *cgroup,
+				struct cftype *cftype, struct seq_file *m)
+{
+	struct io_cgroup *iocg;
+	struct io_group *iog;
+	struct hlist_node *n;
+
+	if (!cgroup_lock_live_group(cgroup))
+		return -ENODEV;
+
+	iocg = cgroup_to_io_cgroup(cgroup);
+
+	spin_lock_irq(&iocg->lock);
+	hlist_for_each_entry_rcu(iog, n, &iocg->group_data, group_node) {
+		/*
+		 * There might be groups which are not functional and
+		 * waiting to be reclaimed upon cgoup deletion.
+		 */
+		if (iog->key) {
+			seq_printf(m, "%u %u %lu\n", MAJOR(iog->dev),
+					MINOR(iog->dev),
+					iog->entity.total_service);
+		}
+	}
+	spin_unlock_irq(&iocg->lock);
+	cgroup_unlock();
+
+	return 0;
+}
+
+static int io_cgroup_disk_sectors_read(struct cgroup *cgroup,
+				struct cftype *cftype, struct seq_file *m)
+{
+	struct io_cgroup *iocg;
+	struct io_group *iog;
+	struct hlist_node *n;
+
+	if (!cgroup_lock_live_group(cgroup))
+		return -ENODEV;
+
+	iocg = cgroup_to_io_cgroup(cgroup);
+
+	spin_lock_irq(&iocg->lock);
+	hlist_for_each_entry_rcu(iog, n, &iocg->group_data, group_node) {
+		/*
+		 * There might be groups which are not functional and
+		 * waiting to be reclaimed upon cgoup deletion.
+		 */
+		if (iog->key) {
+			seq_printf(m, "%u %u %lu\n", MAJOR(iog->dev),
+					MINOR(iog->dev),
+					iog->entity.total_sector_service);
+		}
+	}
+	spin_unlock_irq(&iocg->lock);
+	cgroup_unlock();
+
+	return 0;
+}
+
 /**
  * bfq_group_chain_alloc - allocate a chain of groups.
  * @bfqd: queue descriptor.
@@ -1092,7 +1156,7 @@ STORE_FUNCTION(ioprio_class, IOPRIO_CLASS_RT, IOPRIO_CLASS_IDLE);
  * to the root has already an allocated group on @bfqd.
  */
 struct io_group *io_group_chain_alloc(struct request_queue *q, void *key,
-					struct cgroup *cgroup)
+					struct cgroup *cgroup, struct bio *bio)
 {
 	struct io_cgroup *iocg;
 	struct io_group *iog, *leaf = NULL, *prev = NULL;
@@ -1131,6 +1195,11 @@ struct io_group *io_group_chain_alloc(struct request_queue *q, void *key,
 
 		iog->iocg_id = css_id(&iocg->css);
 
+		if (bio) {
+			struct gendisk *disk = bio->bi_bdev->bd_disk;
+			iog->dev = MKDEV(disk->major, disk->first_minor);
+		}
+
 		if (leaf == NULL) {
 			leaf = iog;
 			prev = leaf;
@@ -1234,7 +1303,7 @@ void io_group_chain_link(struct request_queue *q, void *key,
  */
 struct io_group *io_find_alloc_group(struct request_queue *q,
 			struct cgroup *cgroup, struct elv_fq_data *efqd,
-			int create)
+			int create, struct bio *bio)
 {
 	struct io_cgroup *iocg = cgroup_to_io_cgroup(cgroup);
 	struct io_group *iog = NULL;
@@ -1253,7 +1322,7 @@ struct io_group *io_find_alloc_group(struct request_queue *q,
 	if (iog != NULL || !create)
 		goto end;
 
-	iog = io_group_chain_alloc(q, key, cgroup);
+	iog = io_group_chain_alloc(q, key, cgroup, bio);
 	if (iog != NULL)
 		io_group_chain_link(q, key, cgroup, iog, efqd);
 
@@ -1283,7 +1352,7 @@ struct io_group *io_get_io_group(struct request_queue *q, int create)
 
 	rcu_read_lock();
 	cgroup = task_cgroup(current, io_subsys_id);
-	iog = io_find_alloc_group(q, cgroup, efqd, create);
+	iog = io_find_alloc_group(q, cgroup, efqd, create, NULL);
 	if (!iog) {
 		if (create)
 			iog = efqd->root_group;
@@ -1358,6 +1427,14 @@ struct cftype bfqio_files[] = {
 		.read_u64 = io_cgroup_ioprio_class_read,
 		.write_u64 = io_cgroup_ioprio_class_write,
 	},
+	{
+		.name = "disk_time",
+		.read_seq_string = io_cgroup_disk_time_read,
+	},
+	{
+		.name = "disk_sectors",
+		.read_seq_string = io_cgroup_disk_sectors_read,
+	},
 };
 
 int iocg_populate(struct cgroup_subsys *subsys, struct cgroup *cgroup)
@@ -1811,7 +1888,7 @@ EXPORT_SYMBOL(elv_get_slice_idle);
 
 void elv_ioq_served(struct io_queue *ioq, bfq_service_t served)
 {
-	entity_served(&ioq->entity, served);
+	entity_served(&ioq->entity, served, ioq->nr_sectors);
 }
 
 /* Tells whether ioq is queued in root group or not */
diff --git a/block/elevator-fq.h b/block/elevator-fq.h
index a37be0f..447cea0 100644
--- a/block/elevator-fq.h
+++ b/block/elevator-fq.h
@@ -147,6 +147,13 @@ struct io_entity {
 	unsigned short ioprio_class, new_ioprio_class;
 
 	int ioprio_changed;
+
+	/*
+	 * Keep track of total service received by this entity. Keep the
+	 * stats both for time slices and number of sectors dispatched
+	 */
+	unsigned long total_service;
+	unsigned long total_sector_service;
 };
 
 /*
@@ -234,6 +241,9 @@ struct io_group {
 
 	int deleting;
 	unsigned short iocg_id;
+
+	/* The device MKDEV(major, minor), this group has been created for */
+	dev_t	dev;
 };
 
 /**
-- 
1.6.0.6
