From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 10/28] io-controller: Export disk time used and nr sectors dipatched through cgroups
Date: Thu, 24 Sep 2009 15:25:14 -0400
Message-ID: <1253820332-10246-11-git-send-email-vgoyal@redhat.com>
References: <1253820332-10246-1-git-send-email-vgoyal@redhat.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754278AbZIXT1U@vger.kernel.org>
In-Reply-To: <1253820332-10246-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Cc: containers@lists.linux-foundation.org, dm-devel@redhat.com, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com, vgoyal@redhat.com, akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com, torvalds@linux-foundation.org, mingo@elte.hu, riel@redhat.com
List-Id: dm-devel.ids

o This patch exports some statistics through cgroup interface. Two of the
  statistics currently exported are actual disk time assigned to the cgroup
  and actual number of sectors dispatched to disk on behalf of this cgroup.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Acked-by: Rik van Riel <riel@redhat.com>
---
 block/elevator-fq.c |   76 +++++++++++++++++++++++++++++++++++++++++++++++++++
 block/elevator-fq.h |   10 +++++++
 2 files changed, 86 insertions(+), 0 deletions(-)

diff --git a/block/elevator-fq.c b/block/elevator-fq.c
index d59ac50..a57ca9d 100644
--- a/block/elevator-fq.c
+++ b/block/elevator-fq.c
@@ -13,6 +13,7 @@
 
 #include <linux/blkdev.h>
 #include <linux/blktrace_api.h>
+#include <linux/seq_file.h>
 #include "elevator-fq.h"
 
 const int elv_slice_sync = HZ / 10;
@@ -267,6 +268,8 @@ static void entity_served(struct io_entity *entity, unsigned long served,
 	for_each_entity(entity) {
 		entity->vdisktime += elv_delta_fair(charge, entity);
 		update_min_vdisktime(entity->st);
+		entity->total_time += served;
+		entity->total_sectors += nr_sectors;
 		/* Group charge can be different from queue charge */
 		charge = group_charge;
 	}
@@ -1035,6 +1038,66 @@ STORE_FUNCTION(weight, IO_WEIGHT_MIN, IO_WEIGHT_MAX);
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
+	rcu_read_lock();
+	hlist_for_each_entry_rcu(iog, n, &iocg->group_data, group_node) {
+		/*
+		 * There might be groups which are not functional and
+		 * waiting to be reclaimed upon cgoup deletion.
+		 */
+		if (iog->key) {
+			seq_printf(m, "%u:%u %lu\n", MAJOR(iog->dev),
+					MINOR(iog->dev),
+					iog->entity.total_time);
+		}
+	}
+	rcu_read_unlock();
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
+	rcu_read_lock();
+	hlist_for_each_entry_rcu(iog, n, &iocg->group_data, group_node) {
+		/*
+		 * There might be groups which are not functional and
+		 * waiting to be reclaimed upon cgoup deletion.
+		 */
+		if (iog->key) {
+			seq_printf(m, "%u:%u %lu\n", MAJOR(iog->dev),
+					MINOR(iog->dev),
+					iog->entity.total_sectors);
+		}
+	}
+	rcu_read_unlock();
+	cgroup_unlock();
+
+	return 0;
+}
+
 struct cftype io_files[] = {
 	{
 		.name = "weight",
@@ -1046,6 +1109,14 @@ struct cftype io_files[] = {
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
 
 static int iocg_populate(struct cgroup_subsys *subsys, struct cgroup *cgroup)
@@ -1137,6 +1208,8 @@ io_group_chain_alloc(struct request_queue *q, void *key, struct cgroup *cgroup)
 	struct io_cgroup *iocg;
 	struct io_group *iog, *leaf = NULL, *prev = NULL;
 	gfp_t flags = GFP_ATOMIC |  __GFP_ZERO;
+	unsigned int major, minor;
+	struct backing_dev_info *bdi = &q->backing_dev_info;
 
 	for (; cgroup != NULL; cgroup = cgroup->parent) {
 		iocg = cgroup_to_io_cgroup(cgroup);
@@ -1157,6 +1230,9 @@ io_group_chain_alloc(struct request_queue *q, void *key, struct cgroup *cgroup)
 
 		iog->iocg_id = css_id(&iocg->css);
 
+		sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
+		iog->dev = MKDEV(major, minor);
+
 		io_group_init_entity(iocg, iog);
 
 		atomic_set(&iog->ref, 0);
diff --git a/block/elevator-fq.h b/block/elevator-fq.h
index 769798b..256f71a 100644
--- a/block/elevator-fq.h
+++ b/block/elevator-fq.h
@@ -60,6 +60,13 @@ struct io_entity {
 
 	unsigned short ioprio, ioprio_class;
 	int ioprio_changed;
+
+	/*
+	 * Keep track of total service received by this entity. Keep the
+	 * stats both for time slices and number of sectors dispatched
+	 */
+	unsigned long total_time;
+	unsigned long total_sectors;
 };
 
 /*
@@ -111,6 +118,9 @@ struct io_group {
 	struct io_queue *async_idle_queue;
 	void *key;
 	struct rcu_head rcu_head;
+
+	/* The device MKDEV(major, minor), this group has been created for */
+	dev_t	dev;
 };
 
 struct io_cgroup {
-- 
1.6.0.6
