Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52E9FC77B7A
	for <dm-devel@archiver.kernel.org>; Wed, 31 May 2023 13:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685538453;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=VnAEXFxHuVaELg2Fu4K6FGuaFzoXTmFaHnoq/nLi7ss=;
	b=V8+gcoMURyufkQn8u9uvvHyvhYu5o3lIfSXXZJg3VnJ6u5WTCS9MVXTonKJI/8oESro3zc
	NG4U9h7bP6tqEl179egDnUpi8CHVGp/oywWpRXuotFCN5uuDxs/hiyZZZMU9FHPLda+jcS
	tAYeU/FPP8H1t2QwdIiF2UN7nUgF2/I=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-230-z8ArnMqFM-25uIVX4Unt_w-1; Wed, 31 May 2023 09:07:31 -0400
X-MC-Unique: z8ArnMqFM-25uIVX4Unt_w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1E41D811E96;
	Wed, 31 May 2023 13:07:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9CFCD20296C6;
	Wed, 31 May 2023 13:07:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AC59D1946A47;
	Wed, 31 May 2023 13:06:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4C4CD19465A0
 for <dm-devel@listman.corp.redhat.com>; Wed, 31 May 2023 12:57:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 32BE740CFD46; Wed, 31 May 2023 12:57:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2B00B40CFD45
 for <dm-devel@redhat.com>; Wed, 31 May 2023 12:57:18 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0EC72101A531
 for <dm-devel@redhat.com>; Wed, 31 May 2023 12:57:18 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-581-FIXpiuesMDmlpQkL2um6Qw-1; Wed, 31 May 2023 08:57:15 -0400
X-MC-Unique: FIXpiuesMDmlpQkL2um6Qw-1
Received: from [2001:4bb8:182:6d06:2e49:a56:513a:92ee] (helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
 id 1q4LNz-00HRoS-0G; Wed, 31 May 2023 12:57:08 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Wed, 31 May 2023 14:55:27 +0200
Message-Id: <20230531125535.676098-17-hch@lst.de>
In-Reply-To: <20230531125535.676098-1-hch@lst.de>
References: <20230531125535.676098-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: [dm-devel] [PATCH 16/24] block: move more code to early-lookup.c
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: Loic Poulain <loic.poulain@linaro.org>,
 Vignesh Raghavendra <vigneshr@ti.com>, "Rafael J. Wysocki" <rafael@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-pm@vger.kernel.org,
 Joern Engel <joern@lazybastard.org>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, Richard Weinberger <richard@nod.at>,
 dm-devel@redhat.com, Mike Snitzer <snitzer@kernel.org>,
 Pavel Machek <pavel@ucw.cz>, Miquel Raynal <miquel.raynal@bootlin.com>,
 linux-mtd@lists.infradead.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: lst.de
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

blk_lookup_devt is only used by code in early-lookup.c, so move it
there.

printk_all_partitions and it's helper bdevt_str are only used by the
early init code in init/do_mounts.c, so they should go there as well.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/early-lookup.c   | 92 ++++++++++++++++++++++++++++++++++++++++++
 block/genhd.c          | 92 ------------------------------------------
 include/linux/blkdev.h |  1 -
 3 files changed, 92 insertions(+), 93 deletions(-)

diff --git a/block/early-lookup.c b/block/early-lookup.c
index 9fc30d039508af..6016e781b6a0e2 100644
--- a/block/early-lookup.c
+++ b/block/early-lookup.c
@@ -120,6 +120,35 @@ static int devt_from_partlabel(const char *label, dev_t *devt)
 	return 0;
 }
 
+static dev_t blk_lookup_devt(const char *name, int partno)
+{
+	dev_t devt = MKDEV(0, 0);
+	struct class_dev_iter iter;
+	struct device *dev;
+
+	class_dev_iter_init(&iter, &block_class, NULL, &disk_type);
+	while ((dev = class_dev_iter_next(&iter))) {
+		struct gendisk *disk = dev_to_disk(dev);
+
+		if (strcmp(dev_name(dev), name))
+			continue;
+
+		if (partno < disk->minors) {
+			/* We need to return the right devno, even
+			 * if the partition doesn't exist yet.
+			 */
+			devt = MKDEV(MAJOR(dev->devt),
+				     MINOR(dev->devt) + partno);
+		} else {
+			devt = part_devt(disk, partno);
+			if (devt)
+				break;
+		}
+	}
+	class_dev_iter_exit(&iter);
+	return devt;
+}
+
 static int devt_from_devname(const char *name, dev_t *devt)
 {
 	int part;
@@ -222,3 +251,66 @@ int early_lookup_bdev(const char *name, dev_t *devt)
 	return devt_from_devnum(name, devt);
 }
 EXPORT_SYMBOL_GPL(early_lookup_bdev);
+
+static char __init *bdevt_str(dev_t devt, char *buf)
+{
+	if (MAJOR(devt) <= 0xff && MINOR(devt) <= 0xff) {
+		char tbuf[BDEVT_SIZE];
+		snprintf(tbuf, BDEVT_SIZE, "%02x%02x", MAJOR(devt), MINOR(devt));
+		snprintf(buf, BDEVT_SIZE, "%-9s", tbuf);
+	} else
+		snprintf(buf, BDEVT_SIZE, "%03x:%05x", MAJOR(devt), MINOR(devt));
+
+	return buf;
+}
+
+/*
+ * print a full list of all partitions - intended for places where the root
+ * filesystem can't be mounted and thus to give the victim some idea of what
+ * went wrong
+ */
+void __init printk_all_partitions(void)
+{
+	struct class_dev_iter iter;
+	struct device *dev;
+
+	class_dev_iter_init(&iter, &block_class, NULL, &disk_type);
+	while ((dev = class_dev_iter_next(&iter))) {
+		struct gendisk *disk = dev_to_disk(dev);
+		struct block_device *part;
+		char devt_buf[BDEVT_SIZE];
+		unsigned long idx;
+
+		/*
+		 * Don't show empty devices or things that have been
+		 * suppressed
+		 */
+		if (get_capacity(disk) == 0 || (disk->flags & GENHD_FL_HIDDEN))
+			continue;
+
+		/*
+		 * Note, unlike /proc/partitions, I am showing the numbers in
+		 * hex - the same format as the root= option takes.
+		 */
+		rcu_read_lock();
+		xa_for_each(&disk->part_tbl, idx, part) {
+			if (!bdev_nr_sectors(part))
+				continue;
+			printk("%s%s %10llu %pg %s",
+			       bdev_is_partition(part) ? "  " : "",
+			       bdevt_str(part->bd_dev, devt_buf),
+			       bdev_nr_sectors(part) >> 1, part,
+			       part->bd_meta_info ?
+					part->bd_meta_info->uuid : "");
+			if (bdev_is_partition(part))
+				printk("\n");
+			else if (dev->parent && dev->parent->driver)
+				printk(" driver: %s\n",
+					dev->parent->driver->name);
+			else
+				printk(" (driver?)\n");
+		}
+		rcu_read_unlock();
+	}
+	class_dev_iter_exit(&iter);
+}
diff --git a/block/genhd.c b/block/genhd.c
index 1cb489b927d50a..aa28f296fe391b 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -318,18 +318,6 @@ void blk_free_ext_minor(unsigned int minor)
 	ida_free(&ext_devt_ida, minor);
 }
 
-static char *bdevt_str(dev_t devt, char *buf)
-{
-	if (MAJOR(devt) <= 0xff && MINOR(devt) <= 0xff) {
-		char tbuf[BDEVT_SIZE];
-		snprintf(tbuf, BDEVT_SIZE, "%02x%02x", MAJOR(devt), MINOR(devt));
-		snprintf(buf, BDEVT_SIZE, "%-9s", tbuf);
-	} else
-		snprintf(buf, BDEVT_SIZE, "%03x:%05x", MAJOR(devt), MINOR(devt));
-
-	return buf;
-}
-
 void disk_uevent(struct gendisk *disk, enum kobject_action action)
 {
 	struct block_device *part;
@@ -755,57 +743,6 @@ void blk_request_module(dev_t devt)
 }
 #endif /* CONFIG_BLOCK_LEGACY_AUTOLOAD */
 
-/*
- * print a full list of all partitions - intended for places where the root
- * filesystem can't be mounted and thus to give the victim some idea of what
- * went wrong
- */
-void __init printk_all_partitions(void)
-{
-	struct class_dev_iter iter;
-	struct device *dev;
-
-	class_dev_iter_init(&iter, &block_class, NULL, &disk_type);
-	while ((dev = class_dev_iter_next(&iter))) {
-		struct gendisk *disk = dev_to_disk(dev);
-		struct block_device *part;
-		char devt_buf[BDEVT_SIZE];
-		unsigned long idx;
-
-		/*
-		 * Don't show empty devices or things that have been
-		 * suppressed
-		 */
-		if (get_capacity(disk) == 0 || (disk->flags & GENHD_FL_HIDDEN))
-			continue;
-
-		/*
-		 * Note, unlike /proc/partitions, I am showing the numbers in
-		 * hex - the same format as the root= option takes.
-		 */
-		rcu_read_lock();
-		xa_for_each(&disk->part_tbl, idx, part) {
-			if (!bdev_nr_sectors(part))
-				continue;
-			printk("%s%s %10llu %pg %s",
-			       bdev_is_partition(part) ? "  " : "",
-			       bdevt_str(part->bd_dev, devt_buf),
-			       bdev_nr_sectors(part) >> 1, part,
-			       part->bd_meta_info ?
-					part->bd_meta_info->uuid : "");
-			if (bdev_is_partition(part))
-				printk("\n");
-			else if (dev->parent && dev->parent->driver)
-				printk(" driver: %s\n",
-					dev->parent->driver->name);
-			else
-				printk(" (driver?)\n");
-		}
-		rcu_read_unlock();
-	}
-	class_dev_iter_exit(&iter);
-}
-
 #ifdef CONFIG_PROC_FS
 /* iterator */
 static void *disk_seqf_start(struct seq_file *seqf, loff_t *pos)
@@ -1339,35 +1276,6 @@ dev_t part_devt(struct gendisk *disk, u8 partno)
 	return devt;
 }
 
-dev_t blk_lookup_devt(const char *name, int partno)
-{
-	dev_t devt = MKDEV(0, 0);
-	struct class_dev_iter iter;
-	struct device *dev;
-
-	class_dev_iter_init(&iter, &block_class, NULL, &disk_type);
-	while ((dev = class_dev_iter_next(&iter))) {
-		struct gendisk *disk = dev_to_disk(dev);
-
-		if (strcmp(dev_name(dev), name))
-			continue;
-
-		if (partno < disk->minors) {
-			/* We need to return the right devno, even
-			 * if the partition doesn't exist yet.
-			 */
-			devt = MKDEV(MAJOR(dev->devt),
-				     MINOR(dev->devt) + partno);
-		} else {
-			devt = part_devt(disk, partno);
-			if (devt)
-				break;
-		}
-	}
-	class_dev_iter_exit(&iter);
-	return devt;
-}
-
 struct gendisk *__alloc_disk_node(struct request_queue *q, int node_id,
 		struct lock_class_key *lkclass)
 {
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 0bda6cb98d7eb8..0ce09ecfa3a7af 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -838,7 +838,6 @@ static inline void bd_unlink_disk_holder(struct block_device *bdev,
 
 dev_t part_devt(struct gendisk *disk, u8 partno);
 void inc_diskseq(struct gendisk *disk);
-dev_t blk_lookup_devt(const char *name, int partno);
 void blk_request_module(dev_t devt);
 
 extern int blk_register_queue(struct gendisk *disk);
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

