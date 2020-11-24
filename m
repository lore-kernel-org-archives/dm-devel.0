Return-Path: <SRS0=MhoS=E6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14CA9C825A5
	for <dm-devel@archiver.kernel.org>; Tue, 24 Nov 2020 13:29:48 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7E6E0204EC
	for <dm-devel@archiver.kernel.org>; Tue, 24 Nov 2020 13:29:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7E6E0204EC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-314-k0Ou5_QOOqa6HA7zSSHmsQ-1; Tue, 24 Nov 2020 08:29:44 -0500
X-MC-Unique: k0Ou5_QOOqa6HA7zSSHmsQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E5993105207C;
	Tue, 24 Nov 2020 13:29:39 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B7C23101E581;
	Tue, 24 Nov 2020 13:29:39 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8622850031;
	Tue, 24 Nov 2020 13:29:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AODTJNZ018222 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 24 Nov 2020 08:29:19 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B2A722166B2B; Tue, 24 Nov 2020 13:29:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AD8A12166B27
	for <dm-devel@redhat.com>; Tue, 24 Nov 2020 13:29:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0835C800883
	for <dm-devel@redhat.com>; Tue, 24 Nov 2020 13:29:12 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-393-wYrsbB9fNrGxqZ0a-SaWrg-1; Tue, 24 Nov 2020 08:29:07 -0500
X-MC-Unique: wYrsbB9fNrGxqZ0a-SaWrg-1
Received: from [2001:4bb8:180:5443:c70:4a89:bc61:3] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
	id 1khYNC-0006eW-7z; Tue, 24 Nov 2020 13:28:47 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Tue, 24 Nov 2020 14:27:37 +0100
Message-Id: <20201124132751.3747337-32-hch@lst.de>
In-Reply-To: <20201124132751.3747337-1-hch@lst.de>
References: <20201124132751.3747337-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	casper.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: linux-bcache@vger.kernel.org, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jan Kara <jack@suse.com>, Josef Bacik <josef@toxicpanda.com>,
	Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
	Richard Weinberger <richard@nod.at>, dm-devel@redhat.com,
	linux-mtd@lists.infradead.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Tejun Heo <tj@kernel.org>, xen-devel@lists.xenproject.org,
	linux-mm@kvack.org
Subject: [dm-devel] [PATCH 31/45] block: move disk stat accounting to struct
	block_device
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Move the dkstats and stamp field to struct block_device in preparation
of killing struct hd_struct.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-cgroup.c        |  2 +-
 block/blk-core.c          |  4 ++--
 block/blk.h               |  1 -
 block/genhd.c             | 14 ++++----------
 block/partitions/core.c   |  9 +--------
 fs/block_dev.c            | 10 ++++++++++
 include/linux/blk_types.h |  2 ++
 include/linux/genhd.h     |  2 --
 include/linux/part_stat.h | 38 +++++++++++++++++++-------------------
 9 files changed, 39 insertions(+), 43 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 23437b96ea41e6..a598f86e014137 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -830,7 +830,7 @@ static void blkcg_fill_root_iostats(void)
 		for_each_possible_cpu(cpu) {
 			struct disk_stats *cpu_dkstats;
 
-			cpu_dkstats = per_cpu_ptr(part->dkstats, cpu);
+			cpu_dkstats = per_cpu_ptr(part->bdev->bd_stats, cpu);
 			tmp.ios[BLKG_IOSTAT_READ] +=
 				cpu_dkstats->ios[STAT_READ];
 			tmp.ios[BLKG_IOSTAT_WRITE] +=
diff --git a/block/blk-core.c b/block/blk-core.c
index 988f45094a387b..d2c9cb24e087f3 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1264,9 +1264,9 @@ static void update_io_ticks(struct hd_struct *part, unsigned long now, bool end)
 {
 	unsigned long stamp;
 again:
-	stamp = READ_ONCE(part->stamp);
+	stamp = READ_ONCE(part->bdev->bd_stamp);
 	if (unlikely(stamp != now)) {
-		if (likely(cmpxchg(&part->stamp, stamp, now) == stamp))
+		if (likely(cmpxchg(&part->bdev->bd_stamp, stamp, now) == stamp))
 			__part_stat_add(part, io_ticks, end ? now - stamp : 1);
 	}
 	if (part->partno) {
diff --git a/block/blk.h b/block/blk.h
index 09cee7024fb43e..3f801f6e86f8a1 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -381,7 +381,6 @@ static inline void hd_struct_put(struct hd_struct *part)
 
 static inline void hd_free_part(struct hd_struct *part)
 {
-	free_percpu(part->dkstats);
 	kfree(part->info);
 	bdput(part->bdev);
 	percpu_ref_exit(&part->ref);
diff --git a/block/genhd.c b/block/genhd.c
index 8ace0628ac20b7..0c0458367da7e4 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -102,7 +102,7 @@ static void part_stat_read_all(struct hd_struct *part, struct disk_stats *stat)
 
 	memset(stat, 0, sizeof(struct disk_stats));
 	for_each_possible_cpu(cpu) {
-		struct disk_stats *ptr = per_cpu_ptr(part->dkstats, cpu);
+		struct disk_stats *ptr = per_cpu_ptr(part->bdev->bd_stats, cpu);
 		int group;
 
 		for (group = 0; group < NR_STAT_GROUPS; group++) {
@@ -875,7 +875,7 @@ void del_gendisk(struct gendisk *disk)
 	kobject_put(disk->slave_dir);
 
 	part_stat_set_all(&disk->part0, 0);
-	disk->part0.stamp = 0;
+	disk->part0.bdev->bd_stamp = 0;
 	if (!sysfs_deprecated)
 		sysfs_remove_link(block_depr, dev_name(disk_to_dev(disk)));
 	pm_runtime_set_memalloc_noio(disk_to_dev(disk), false);
@@ -1612,19 +1612,15 @@ struct gendisk *__alloc_disk_node(int minors, int node_id)
 	if (!disk->part0.bdev)
 		goto out_free_disk;
 
-	disk->part0.dkstats = alloc_percpu(struct disk_stats);
-	if (!disk->part0.dkstats)
-		goto out_bdput;
-
 	disk->node_id = node_id;
 	if (disk_expand_part_tbl(disk, 0))
-		goto out_free_bdstats;
+		goto out_bdput;
 
 	ptbl = rcu_dereference_protected(disk->part_tbl, 1);
 	rcu_assign_pointer(ptbl->part[0], &disk->part0);
 
 	if (hd_ref_init(&disk->part0))
-		goto out_free_bdstats;
+		goto out_bdput;
 
 	disk->minors = minors;
 	rand_initialize_disk(disk);
@@ -1633,8 +1629,6 @@ struct gendisk *__alloc_disk_node(int minors, int node_id)
 	device_initialize(disk_to_dev(disk));
 	return disk;
 
-out_free_bdstats:
-	free_percpu(disk->part0.dkstats);
 out_bdput:
 	bdput(disk->part0.bdev);
 out_free_disk:
diff --git a/block/partitions/core.c b/block/partitions/core.c
index 92ffa55bdfddfd..c3a4870bfb123d 100644
--- a/block/partitions/core.c
+++ b/block/partitions/core.c
@@ -409,14 +409,9 @@ static struct hd_struct *add_partition(struct gendisk *disk, int partno,
 	if (!p)
 		return ERR_PTR(-EBUSY);
 
-	err = -ENOMEM;
-	p->dkstats = alloc_percpu(struct disk_stats);
-	if (!p->dkstats)
-		goto out_free;
-
 	bdev = bdev_alloc(disk, partno);
 	if (!bdev)
-		goto out_free_stats;
+		goto out_free;
 	p->bdev = bdev;
 
 	pdev = part_to_dev(p);
@@ -490,8 +485,6 @@ static struct hd_struct *add_partition(struct gendisk *disk, int partno,
 	kfree(p->info);
 out_bdput:
 	bdput(bdev);
-out_free_stats:
-	free_percpu(p->dkstats);
 out_free:
 	kfree(p);
 	return ERR_PTR(err);
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 02536d9fa29945..0427e6fa59556f 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -32,6 +32,7 @@
 #include <linux/cleancache.h>
 #include <linux/task_io_accounting_ops.h>
 #include <linux/falloc.h>
+#include <linux/part_stat.h>
 #include <linux/uaccess.h>
 #include <linux/suspend.h>
 #include "internal.h"
@@ -781,6 +782,10 @@ static struct inode *bdev_alloc_inode(struct super_block *sb)
 
 static void bdev_free_inode(struct inode *inode)
 {
+	struct block_device *bdev = I_BDEV(inode);
+
+	free_percpu(bdev->bd_stats);
+
 	kmem_cache_free(bdev_cachep, BDEV_I(inode));
 }
 
@@ -874,6 +879,11 @@ struct block_device *bdev_alloc(struct gendisk *disk, u8 partno)
 #ifdef CONFIG_SYSFS
 	INIT_LIST_HEAD(&bdev->bd_holder_disks);
 #endif
+	bdev->bd_stats = alloc_percpu(struct disk_stats);
+	if (!bdev->bd_stats) {
+		iput(inode);
+		return NULL;
+	}
 	return bdev;
 }
 
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 2e0a9bd9688d28..520011b95276fb 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -20,6 +20,8 @@ typedef void (bio_end_io_t) (struct bio *);
 struct bio_crypt_ctx;
 
 struct block_device {
+	struct disk_stats __percpu *bd_stats;
+	unsigned long		bd_stamp;
 	dev_t			bd_dev;
 	int			bd_openers;
 	struct inode *		bd_inode;	/* will die */
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 0dbd254bca51aa..dcc40c8217d095 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -52,8 +52,6 @@ struct partition_meta_info {
 
 struct hd_struct {
 	sector_t start_sect;
-	unsigned long stamp;
-	struct disk_stats __percpu *dkstats;
 	struct percpu_ref ref;
 
 	struct block_device *bdev;
diff --git a/include/linux/part_stat.h b/include/linux/part_stat.h
index 24125778ef3ec7..87ad60106e1db0 100644
--- a/include/linux/part_stat.h
+++ b/include/linux/part_stat.h
@@ -25,17 +25,17 @@ struct disk_stats {
 #define part_stat_unlock()	preempt_enable()
 
 #define part_stat_get_cpu(part, field, cpu)				\
-	(per_cpu_ptr((part)->dkstats, (cpu))->field)
+	(per_cpu_ptr((part)->bdev->bd_stats, (cpu))->field)
 
 #define part_stat_get(part, field)					\
 	part_stat_get_cpu(part, field, smp_processor_id())
 
 #define part_stat_read(part, field)					\
 ({									\
-	typeof((part)->dkstats->field) res = 0;				\
+	typeof((part)->bdev->bd_stats->field) res = 0;			\
 	unsigned int _cpu;						\
 	for_each_possible_cpu(_cpu)					\
-		res += per_cpu_ptr((part)->dkstats, _cpu)->field;	\
+		res += per_cpu_ptr((part)->bdev->bd_stats, _cpu)->field; \
 	res;								\
 })
 
@@ -44,7 +44,7 @@ static inline void part_stat_set_all(struct hd_struct *part, int value)
 	int i;
 
 	for_each_possible_cpu(i)
-		memset(per_cpu_ptr(part->dkstats, i), value,
+		memset(per_cpu_ptr(part->bdev->bd_stats, i), value,
 				sizeof(struct disk_stats));
 }
 
@@ -54,7 +54,7 @@ static inline void part_stat_set_all(struct hd_struct *part, int value)
 	 part_stat_read(part, field[STAT_DISCARD]))
 
 #define __part_stat_add(part, field, addnd)				\
-	__this_cpu_add((part)->dkstats->field, addnd)
+	__this_cpu_add((part)->bdev->bd_stats->field, addnd)
 
 #define part_stat_add(part, field, addnd)	do {			\
 	__part_stat_add((part), field, addnd);				\
@@ -63,20 +63,20 @@ static inline void part_stat_set_all(struct hd_struct *part, int value)
 				field, addnd);				\
 } while (0)
 
-#define part_stat_dec(gendiskp, field)					\
-	part_stat_add(gendiskp, field, -1)
-#define part_stat_inc(gendiskp, field)					\
-	part_stat_add(gendiskp, field, 1)
-#define part_stat_sub(gendiskp, field, subnd)				\
-	part_stat_add(gendiskp, field, -subnd)
+#define part_stat_dec(part, field)					\
+	part_stat_add(part, field, -1)
+#define part_stat_inc(part, field)					\
+	part_stat_add(part, field, 1)
+#define part_stat_sub(part, field, subnd)				\
+	part_stat_add(part, field, -subnd)
 
-#define part_stat_local_dec(gendiskp, field)				\
-	local_dec(&(part_stat_get(gendiskp, field)))
-#define part_stat_local_inc(gendiskp, field)				\
-	local_inc(&(part_stat_get(gendiskp, field)))
-#define part_stat_local_read(gendiskp, field)				\
-	local_read(&(part_stat_get(gendiskp, field)))
-#define part_stat_local_read_cpu(gendiskp, field, cpu)			\
-	local_read(&(part_stat_get_cpu(gendiskp, field, cpu)))
+#define part_stat_local_dec(part, field)				\
+	local_dec(&(part_stat_get(part, field)))
+#define part_stat_local_inc(part, field)				\
+	local_inc(&(part_stat_get(part, field)))
+#define part_stat_local_read(part, field)				\
+	local_read(&(part_stat_get(part, field)))
+#define part_stat_local_read_cpu(part, field, cpu)			\
+	local_read(&(part_stat_get_cpu(part, field, cpu)))
 
 #endif /* _LINUX_PART_STAT_H */
-- 
2.29.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

