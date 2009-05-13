From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] IO Controller: Add per-device weight and ioprio_class
	handling
Date: Wed, 13 May 2009 11:59:00 -0400
Message-ID: <20090513155900.GA15623@redhat.com>
References: <1241553525-28095-1-git-send-email-vgoyal@redhat.com> <4A0A29B5.7030109@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759695AbZEMQEe@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4A0A29B5.7030109@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, jens.axboe@oracle.com, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, righi.andrea@gmail.com, agk@redhat.com, dm-devel@redhat.com, snitzer@redhat.com, m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org
List-Id: dm-devel.ids

On Wed, May 13, 2009 at 10:00:21AM +0800, Gui Jianfeng wrote:
> Hi Vivek,
> 
> This patch enables per-cgroup per-device weight and ioprio_class handling.
> A new cgroup interface "policy" is introduced. You can make use of this 
> file to configure weight and ioprio_class for each device in a given cgroup.
> The original "weight" and "ioprio_class" files are still available. If you
> don't do special configuration for a particular device, "weight" and 
> "ioprio_class" are used as default values in this device.
> 
> You can use the following format to play with the new interface.
> #echo DEV:weight:ioprio_class > /patch/to/cgroup/policy
> weight=0 means removing the policy for DEV.
> 
> Examples:
> Configure weight=300 ioprio_class=2 on /dev/hdb in this cgroup
> # echo /dev/hdb:300:2 > io.policy
> # cat io.policy
> dev weight class
> /dev/hdb 300 2
> 
> Configure weight=500 ioprio_class=1 on /dev/hda in this cgroup
> # echo /dev/hda:500:1 > io.policy
> # cat io.policy
> dev weight class
> /dev/hda 500 1
> /dev/hdb 300 2
> 
> Remove the policy for /dev/hda in this cgroup
> # echo /dev/hda:0:1 > io.policy
> # cat io.policy
> dev weight class
> /dev/hdb 300 2
> 
> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> ---
>  block/elevator-fq.c |  239 +++++++++++++++++++++++++++++++++++++++++++++++++-
>  block/elevator-fq.h |   11 +++
>  2 files changed, 245 insertions(+), 5 deletions(-)
> 
> diff --git a/block/elevator-fq.c b/block/elevator-fq.c
> index 69435ab..7c95d55 100644
> --- a/block/elevator-fq.c
> +++ b/block/elevator-fq.c
> @@ -12,6 +12,9 @@
>  #include "elevator-fq.h"
>  #include <linux/blktrace_api.h>
>  #include <linux/biotrack.h>
> +#include <linux/seq_file.h>
> +#include <linux/genhd.h>
> +
>  
>  /* Values taken from cfq */
>  const int elv_slice_sync = HZ / 10;
> @@ -1045,12 +1048,30 @@ struct io_group *io_lookup_io_group_current(struct request_queue *q)
>  }
>  EXPORT_SYMBOL(io_lookup_io_group_current);
>  
> -void io_group_init_entity(struct io_cgroup *iocg, struct io_group *iog)
> +static struct policy_node *policy_search_node(const struct io_cgroup *iocg,
> +					      void *key);
> +
> +void io_group_init_entity(struct io_cgroup *iocg, struct io_group *iog,
> +			  void *key)
>  {
>  	struct io_entity *entity = &iog->entity;
> +	struct policy_node *pn;
> +
> +	spin_lock_irq(&iocg->lock);
> +	pn = policy_search_node(iocg, key);
> +	if (pn) {
> +		entity->weight = pn->weight;
> +		entity->new_weight = pn->weight;
> +		entity->ioprio_class = pn->ioprio_class;
> +		entity->new_ioprio_class = pn->ioprio_class;
> +	} else {
> +		entity->weight = iocg->weight;
> +		entity->new_weight = iocg->weight;
> +		entity->ioprio_class = iocg->ioprio_class;
> +		entity->new_ioprio_class = iocg->ioprio_class;
> +	}
> +	spin_unlock_irq(&iocg->lock);

Hi Gui,

It might make sense to also store the device name or device major and
minor number in io_group while creating the io group. This will help us
to display io.disk_time and io.disk_sector statistics per device instead
of aggregate.

I am attaching a patch I was playing around with to display per device
statistics instead of aggregate one. So if user has specified the per
device rule.

Thanks
Vivek


o Currently the statistics exported through cgroup are aggregate of statistics
  on all devices for that cgroup. Instead of aggregate, make these per device.

o Also export another statistics io.disk_dequeue. This keeps a count of how
  many times a particular group got out of race for the disk. This is a
  debugging aid to keep a track how often we could create continuously
  backlogged queues.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/elevator-fq.c |  127 +++++++++++++++++++++++++++++++++-------------------
 block/elevator-fq.h |    3 +
 2 files changed, 85 insertions(+), 45 deletions(-)

Index: linux14/block/elevator-fq.h
===================================================================
--- linux14.orig/block/elevator-fq.h	2009-05-13 11:40:32.000000000 -0400
+++ linux14/block/elevator-fq.h	2009-05-13 11:40:57.000000000 -0400
@@ -250,6 +250,9 @@ struct io_group {
 
 #ifdef CONFIG_DEBUG_GROUP_IOSCHED
 	unsigned short iocg_id;
+	dev_t	dev;
+	/* How many times this group has been removed from active tree */
+	unsigned long dequeue;
 #endif
 };
 
Index: linux14/block/elevator-fq.c
===================================================================
--- linux14.orig/block/elevator-fq.c	2009-05-13 11:40:53.000000000 -0400
+++ linux14/block/elevator-fq.c	2009-05-13 11:40:57.000000000 -0400
@@ -12,6 +12,7 @@
 #include "elevator-fq.h"
 #include <linux/blktrace_api.h>
 #include <linux/biotrack.h>
+#include <linux/seq_file.h>
 
 /* Values taken from cfq */
 const int elv_slice_sync = HZ / 10;
@@ -758,6 +759,18 @@ int __bfq_deactivate_entity(struct io_en
 	BUG_ON(sd->active_entity == entity);
 	BUG_ON(sd->next_active == entity);
 
+#ifdef CONFIG_DEBUG_GROUP_IOSCHED
+	{
+		struct io_group *iog = io_entity_to_iog(entity);
+		/*
+		 * Keep track of how many times a group has been removed
+		 * from active tree because it did not have any active
+		 * backlogged ioq under it
+		 */
+		if (iog)
+			iog->dequeue++;
+	}
+#endif
 	return ret;
 }
 
@@ -1126,90 +1139,103 @@ STORE_FUNCTION(weight, 0, WEIGHT_MAX);
 STORE_FUNCTION(ioprio_class, IOPRIO_CLASS_RT, IOPRIO_CLASS_IDLE);
 #undef STORE_FUNCTION
 
-/*
- * traverse through all the io_groups associated with this cgroup and calculate
- * the aggr disk time received by all the groups on respective disks.
- */
-static u64 calculate_aggr_disk_time(struct io_cgroup *iocg)
+static int io_cgroup_disk_time_read(struct cgroup *cgroup,
+				struct cftype *cftype, struct seq_file *m)
 {
+	struct io_cgroup *iocg;
 	struct io_group *iog;
 	struct hlist_node *n;
-	u64 disk_time = 0;
+
+	if (!cgroup_lock_live_group(cgroup))
+		return -ENODEV;
+
+	iocg = cgroup_to_io_cgroup(cgroup);
 
 	rcu_read_lock();
+	spin_lock_irq(&iocg->lock);
 	hlist_for_each_entry_rcu(iog, n, &iocg->group_data, group_node) {
 		/*
 		 * There might be groups which are not functional and
 		 * waiting to be reclaimed upon cgoup deletion.
 		 */
-		if (rcu_dereference(iog->key))
-			disk_time += iog->entity.total_service;
+		if (rcu_dereference(iog->key)) {
+			seq_printf(m, "%u %u %lu\n", MAJOR(iog->dev),
+					MINOR(iog->dev),
+					iog->entity.total_service);
+		}
 	}
+	spin_unlock_irq(&iocg->lock);
 	rcu_read_unlock();
 
-	return disk_time;
+	cgroup_unlock();
+
+	return 0;
 }
 
-static u64 io_cgroup_disk_time_read(struct cgroup *cgroup,
-					struct cftype *cftype)
+static int io_cgroup_disk_sectors_read(struct cgroup *cgroup,
+				struct cftype *cftype, struct seq_file *m)
 {
 	struct io_cgroup *iocg;
-	u64 ret;
+	struct io_group *iog;
+	struct hlist_node *n;
 
 	if (!cgroup_lock_live_group(cgroup))
 		return -ENODEV;
 
 	iocg = cgroup_to_io_cgroup(cgroup);
-	spin_lock_irq(&iocg->lock);
-	ret = jiffies_to_msecs(calculate_aggr_disk_time(iocg));
-	spin_unlock_irq(&iocg->lock);
-
-	cgroup_unlock();
-
-	return ret;
-}
-
-/*
- * traverse through all the io_groups associated with this cgroup and calculate
- * the aggr number of sectors transferred by all the groups on respective disks.
- */
-static u64 calculate_aggr_disk_sectors(struct io_cgroup *iocg)
-{
-	struct io_group *iog;
-	struct hlist_node *n;
-	u64 disk_sectors = 0;
 
 	rcu_read_lock();
+	spin_lock_irq(&iocg->lock);
 	hlist_for_each_entry_rcu(iog, n, &iocg->group_data, group_node) {
 		/*
 		 * There might be groups which are not functional and
 		 * waiting to be reclaimed upon cgoup deletion.
 		 */
-		if (rcu_dereference(iog->key))
-			disk_sectors += iog->entity.total_sector_service;
+		if (rcu_dereference(iog->key)) {
+			seq_printf(m, "%u %u %lu\n", MAJOR(iog->dev),
+					MINOR(iog->dev),
+					iog->entity.total_sector_service);
+		}
 	}
+	spin_unlock_irq(&iocg->lock);
 	rcu_read_unlock();
 
-	return disk_sectors;
+	cgroup_unlock();
+
+	return 0;
 }
 
-static u64 io_cgroup_disk_sectors_read(struct cgroup *cgroup,
-					struct cftype *cftype)
+static int io_cgroup_disk_dequeue_read(struct cgroup *cgroup,
+			struct cftype *cftype, struct seq_file *m)
 {
-	struct io_cgroup *iocg;
-	u64 ret;
+	struct io_cgroup *iocg = NULL;
+	struct io_group *iog = NULL;
+	struct hlist_node *n;
 
 	if (!cgroup_lock_live_group(cgroup))
 		return -ENODEV;
 
 	iocg = cgroup_to_io_cgroup(cgroup);
+
+	rcu_read_lock();
 	spin_lock_irq(&iocg->lock);
-	ret = calculate_aggr_disk_sectors(iocg);
+	/* Loop through all the io groups and print statistics */
+	hlist_for_each_entry_rcu(iog, n, &iocg->group_data, group_node) {
+		/*
+		 * There might be groups which are not functional and
+		 * waiting to be reclaimed upon cgoup deletion.
+		 */
+		if (rcu_dereference(iog->key)) {
+			seq_printf(m, "%u %u %lu\n", MAJOR(iog->dev),
+					MINOR(iog->dev), iog->dequeue);
+		}
+	}
 	spin_unlock_irq(&iocg->lock);
+	rcu_read_unlock();
 
 	cgroup_unlock();
 
-	return ret;
+	return 0;
 }
 
 /**
@@ -1222,7 +1248,7 @@ static u64 io_cgroup_disk_sectors_read(s
  * to the root has already an allocated group on @bfqd.
  */
 struct io_group *io_group_chain_alloc(struct request_queue *q, void *key,
-					struct cgroup *cgroup)
+					struct cgroup *cgroup, struct bio *bio)
 {
 	struct io_cgroup *iocg;
 	struct io_group *iog, *leaf = NULL, *prev = NULL;
@@ -1250,8 +1276,13 @@ struct io_group *io_group_chain_alloc(st
 
 		io_group_init_entity(iocg, iog);
 		iog->my_entity = &iog->entity;
+
 #ifdef CONFIG_DEBUG_GROUP_IOSCHED
 		iog->iocg_id = css_id(&iocg->css);
+		if (bio) {
+			struct gendisk *disk = bio->bi_bdev->bd_disk;
+			iog->dev = MKDEV(disk->major, disk->first_minor);
+		}
 #endif
 
 		blk_init_request_list(&iog->rl);
@@ -1364,7 +1395,7 @@ void io_group_chain_link(struct request_
  */
 struct io_group *io_find_alloc_group(struct request_queue *q,
 			struct cgroup *cgroup, struct elv_fq_data *efqd,
-			int create)
+			int create, struct bio *bio)
 {
 	struct io_cgroup *iocg = cgroup_to_io_cgroup(cgroup);
 	struct io_group *iog = NULL;
@@ -1375,7 +1406,7 @@ struct io_group *io_find_alloc_group(str
 	if (iog != NULL || !create)
 		return iog;
 
-	iog = io_group_chain_alloc(q, key, cgroup);
+	iog = io_group_chain_alloc(q, key, cgroup, bio);
 	if (iog != NULL)
 		io_group_chain_link(q, key, cgroup, iog, efqd);
 
@@ -1481,7 +1512,7 @@ struct io_group *io_get_io_group(struct 
 		goto out;
 	}
 
-	iog = io_find_alloc_group(q, cgroup, efqd, create);
+	iog = io_find_alloc_group(q, cgroup, efqd, create, bio);
 	if (!iog) {
 		if (create)
 			iog = efqd->root_group;
@@ -1554,12 +1585,18 @@ struct cftype bfqio_files[] = {
 	},
 	{
 		.name = "disk_time",
-		.read_u64 = io_cgroup_disk_time_read,
+		.read_seq_string = io_cgroup_disk_time_read,
 	},
 	{
 		.name = "disk_sectors",
-		.read_u64 = io_cgroup_disk_sectors_read,
+		.read_seq_string = io_cgroup_disk_sectors_read,
 	},
+#ifdef CONFIG_DEBUG_GROUP_IOSCHED
+	{
+		.name = "disk_dequeue",
+		.read_seq_string = io_cgroup_disk_dequeue_read,
+	},
+#endif
 };
 
 int iocg_populate(struct cgroup_subsys *subsys, struct cgroup *cgroup)
