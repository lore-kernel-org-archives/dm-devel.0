Return-Path: <SRS0=dJ+f=FC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70785C63777
	for <dm-devel@archiver.kernel.org>; Sat, 28 Nov 2020 16:29:44 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E54BC246CA
	for <dm-devel@archiver.kernel.org>; Sat, 28 Nov 2020 16:29:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E54BC246CA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-446-oPWUt2BPNay8mqZJcJYw9A-1; Sat, 28 Nov 2020 11:29:38 -0500
X-MC-Unique: oPWUt2BPNay8mqZJcJYw9A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C02121842141;
	Sat, 28 Nov 2020 16:29:34 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9A10519C71;
	Sat, 28 Nov 2020 16:29:34 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6EA315002C;
	Sat, 28 Nov 2020 16:29:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0ASGTWOr024445 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 28 Nov 2020 11:29:32 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id F1CAE200BA9E; Sat, 28 Nov 2020 16:29:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id ECCAB202717D
	for <dm-devel@redhat.com>; Sat, 28 Nov 2020 16:29:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 944358007D9
	for <dm-devel@redhat.com>; Sat, 28 Nov 2020 16:29:29 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-190-UYrQN9E_MomGMwXWvmtufw-1; Sat, 28 Nov 2020 11:29:27 -0500
X-MC-Unique: UYrQN9E_MomGMwXWvmtufw-1
Received: from 089144198196.atnat0007.highway.a1.net ([89.144.198.196]
	helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
	id 1kj36B-0001KR-8e; Sat, 28 Nov 2020 16:29:23 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Sat, 28 Nov 2020 17:15:04 +0100
Message-Id: <20201128161510.347752-40-hch@lst.de>
In-Reply-To: <20201128161510.347752-1-hch@lst.de>
References: <20201128161510.347752-1-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: linux-bcache@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Mike Snitzer <snitzer@redhat.com>, linux-mm@kvack.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jan Kara <jack@suse.com>, Josef Bacik <josef@toxicpanda.com>,
	Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
	linux-mtd@lists.infradead.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>, Tejun Heo <tj@kernel.org>
Subject: [dm-devel] [PATCH 39/45] block: remove the partno field from struct
	hd_struct
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Just use the bd_partno field in struct block_device everywhere.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 block/genhd.c           | 12 ++++++------
 block/partitions/core.c |  9 ++++-----
 include/linux/genhd.h   |  1 -
 init/do_mounts.c        |  2 +-
 4 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 563cfa8885a42c..f4e5a892fc8208 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -581,8 +581,8 @@ int blk_alloc_devt(struct hd_struct *part, dev_t *devt)
 	int idx;
 
 	/* in consecutive minor range? */
-	if (part->partno < disk->minors) {
-		*devt = MKDEV(disk->major, disk->first_minor + part->partno);
+	if (part->bdev->bd_partno < disk->minors) {
+		*devt = MKDEV(disk->major, disk->first_minor + part->bdev->bd_partno);
 		return 0;
 	}
 
@@ -856,7 +856,7 @@ void del_gendisk(struct gendisk *disk)
 	disk_part_iter_init(&piter, disk,
 			     DISK_PITER_INCL_EMPTY | DISK_PITER_REVERSE);
 	while ((part = disk_part_iter_next(&piter))) {
-		invalidate_partition(disk, part->partno);
+		invalidate_partition(disk, part->bdev->bd_partno);
 		delete_partition(part);
 	}
 	disk_part_iter_exit(&piter);
@@ -1000,7 +1000,7 @@ void __init printk_all_partitions(void)
 			printk("%s%s %10llu %s %s", is_part0 ? "" : "  ",
 			       bdevt_str(part_devt(part), devt_buf),
 			       bdev_nr_sectors(part->bdev) >> 1,
-			       disk_name(disk, part->partno, name_buf),
+			       disk_name(disk, part->bdev->bd_partno, name_buf),
 			       part->bdev->bd_meta_info ?
 					part->bdev->bd_meta_info->uuid : "");
 			if (is_part0) {
@@ -1094,7 +1094,7 @@ static int show_partition(struct seq_file *seqf, void *v)
 		seq_printf(seqf, "%4d  %7d %10llu %s\n",
 			   MAJOR(part_devt(part)), MINOR(part_devt(part)),
 			   bdev_nr_sectors(part->bdev) >> 1,
-			   disk_name(sgp, part->partno, buf));
+			   disk_name(sgp, part->bdev->bd_partno, buf));
 	disk_part_iter_exit(&piter);
 
 	return 0;
@@ -1517,7 +1517,7 @@ static int diskstats_show(struct seq_file *seqf, void *v)
 			   "%lu %u"
 			   "\n",
 			   MAJOR(part_devt(hd)), MINOR(part_devt(hd)),
-			   disk_name(gp, hd->partno, buf),
+			   disk_name(gp, hd->bdev->bd_partno, buf),
 			   stat.ios[STAT_READ],
 			   stat.merges[STAT_READ],
 			   stat.sectors[STAT_READ],
diff --git a/block/partitions/core.c b/block/partitions/core.c
index c2f6721633b8d5..6db9ca8b722d66 100644
--- a/block/partitions/core.c
+++ b/block/partitions/core.c
@@ -184,7 +184,7 @@ static ssize_t part_partition_show(struct device *dev,
 {
 	struct hd_struct *p = dev_to_part(dev);
 
-	return sprintf(buf, "%d\n", p->partno);
+	return sprintf(buf, "%d\n", p->bdev->bd_partno);
 }
 
 static ssize_t part_start_show(struct device *dev,
@@ -274,7 +274,7 @@ static int part_uevent(struct device *dev, struct kobj_uevent_env *env)
 {
 	struct hd_struct *part = dev_to_part(dev);
 
-	add_uevent_var(env, "PARTN=%u", part->partno);
+	add_uevent_var(env, "PARTN=%u", part->bdev->bd_partno);
 	if (part->bdev->bd_meta_info && part->bdev->bd_meta_info->volname[0])
 		add_uevent_var(env, "PARTNAME=%s",
 			       part->bdev->bd_meta_info->volname);
@@ -298,7 +298,7 @@ void delete_partition(struct hd_struct *part)
 	struct disk_part_tbl *ptbl =
 		rcu_dereference_protected(disk->part_tbl, 1);
 
-	rcu_assign_pointer(ptbl->part[part->partno], NULL);
+	rcu_assign_pointer(ptbl->part[part->bdev->bd_partno], NULL);
 	rcu_assign_pointer(ptbl->last_lookup, NULL);
 
 	kobject_put(part->bdev->bd_holder_dir);
@@ -372,7 +372,6 @@ static struct hd_struct *add_partition(struct gendisk *disk, int partno,
 
 	bdev->bd_start_sect = start;
 	bdev_set_nr_sectors(bdev, len);
-	p->partno = partno;
 	bdev->bd_read_only = get_disk_ro(disk);
 
 	if (info) {
@@ -445,7 +444,7 @@ static bool partition_overlaps(struct gendisk *disk, sector_t start,
 
 	disk_part_iter_init(&piter, disk, DISK_PITER_INCL_EMPTY);
 	while ((part = disk_part_iter_next(&piter))) {
-		if (part->partno == skip_partno ||
+		if (part->bdev->bd_partno == skip_partno ||
 		    start >= part->bdev->bd_start_sect +
 			bdev_nr_sectors(part->bdev) ||
 		    start + length <= part->bdev->bd_start_sect)
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index fe6fee77e2b9df..3c13d4708e3f9d 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -54,7 +54,6 @@ struct partition_meta_info {
 struct hd_struct {
 	struct block_device *bdev;
 	struct device __dev;
-	int partno;
 };
 
 /**
diff --git a/init/do_mounts.c b/init/do_mounts.c
index 368ccb71850126..86bef93e72ebd6 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -136,7 +136,7 @@ static dev_t devt_from_partuuid(const char *uuid_str)
 		struct hd_struct *part;
 
 		part = disk_get_part(dev_to_disk(dev),
-				     dev_to_part(dev)->partno + offset);
+				     dev_to_part(dev)->bdev->bd_partno + offset);
 		if (part) {
 			devt = part_devt(part);
 			put_device(part_to_dev(part));
-- 
2.29.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

