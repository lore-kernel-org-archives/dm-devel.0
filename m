From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 09/24] io-controller: Export disk time used and
	nr sectors dipatched through cgroups
Date: Sun, 16 Aug 2009 15:30:31 -0400
Message-ID: <1250451046-9966-10-git-send-email-vgoyal@redhat.com>
References: <1250451046-9966-1-git-send-email-vgoyal@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1250451046-9966-1-git-send-email-vgoyal@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, dm-devel@redhat.com, jens.axboe@oracle.com, ryov@valinux.co.jp, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com
Cc: paolo.valente@unimore.it, jmarchan@redhat.com, dhaval@linux.vnet.ibm.com, peterz@infradead.org, guijianfeng@cn.fujitsu.com, fernando@oss.ntt.co.jp, lizf@cn.fujitsu.com, jmoyer@redhat.com, mikew@google.com, fchecconi@gmail.com, dpshah@google.com, vgoyal@redhat.com, nauman@google.com, s-uchida@ap.jp.nec.com, akpm@linux-foundation.org, agk@redhat.com, m-ikeda@ds.jp.nec.com
List-Id: dm-devel.ids

o This patch exports some statistics through cgroup interface. Two of the
  statistics currently exported are actual disk time assigned to the cgroup
  and actual number of sectors dispatched to disk on behalf of this cgroup.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/elevator-fq.c |   76 +++++++++++++++++++++++++++++++++++++++++++++++++++
 block/elevator-fq.h |   10 +++++++
 2 files changed, 86 insertions(+), 0 deletions(-)

diff --git a/block/elevator-fq.c b/block/elevator-fq.c
index 8d91ff7..de13d30 100644
--- a/block/elevator-fq.c
+++ b/block/elevator-fq.c
@@ -13,6 +13,7 @@
 
 #include <linux/blkdev.h>
 #include <linux/blktrace_api.h>
+#include <linux/seq_file.h>
 #include "elevator-fq.h"
 
 const int elv_slice_sync = HZ / 10;
@@ -257,6 +258,8 @@ entity_served(struct io_entity *entity, unsigned long served,
 	for_each_entity(entity) {
 		entity->vdisktime += elv_delta_fair(served, entity);
 		update_min_vdisktime(entity->st);
+		entity->total_time += served;
+		entity->total_sectors += nr_sectors;
 	}
 }
 
@@ -850,6 +853,66 @@ STORE_FUNCTION(weight, IO_WEIGHT_MIN, IO_WEIGHT_MAX);
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
@@ -861,6 +924,14 @@ struct cftype io_files[] = {
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
@@ -952,6 +1023,8 @@ io_group_chain_alloc(struct request_queue *q, void *key, struct cgroup *cgroup)
 	struct io_cgroup *iocg;
 	struct io_group *iog, *leaf = NULL, *prev = NULL;
 	gfp_t flags = GFP_ATOMIC |  __GFP_ZERO;
+	unsigned int major, minor;
+	struct backing_dev_info *bdi = &q->backing_dev_info;
 
 	for (; cgroup != NULL; cgroup = cgroup->parent) {
 		iocg = cgroup_to_io_cgroup(cgroup);
@@ -972,6 +1045,9 @@ io_group_chain_alloc(struct request_queue *q, void *key, struct cgroup *cgroup)
 
 		iog->iocg_id = css_id(&iocg->css);
 
+		sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
+		iog->dev = MKDEV(major, minor);
+
 		io_group_init_entity(iocg, iog);
 
 		atomic_set(&iog->ref, 0);
diff --git a/block/elevator-fq.h b/block/elevator-fq.h
index 671f366..e1d5bdd 100644
--- a/block/elevator-fq.h
+++ b/block/elevator-fq.h
@@ -52,6 +52,13 @@ struct io_entity {
 
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
@@ -103,6 +110,9 @@ struct io_group {
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
