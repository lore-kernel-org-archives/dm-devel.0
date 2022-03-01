Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7511DC433FE
	for <dm-devel@archiver.kernel.org>; Tue,  1 Mar 2022 09:15:46 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-185-op5L-B7zOdah8y0GFZa6jw-1; Tue, 01 Mar 2022 04:15:41 -0500
X-MC-Unique: op5L-B7zOdah8y0GFZa6jw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2084A1854E26;
	Tue,  1 Mar 2022 09:15:37 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9E0BB7B6CC;
	Tue,  1 Mar 2022 09:15:36 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DAFF01809C98;
	Tue,  1 Mar 2022 09:15:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 2219FYvV000721 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 1 Mar 2022 04:15:34 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 0492346A386; Tue,  1 Mar 2022 09:15:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 005FA46A381
	for <dm-devel@redhat.com>; Tue,  1 Mar 2022 09:15:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D84CD3800500
	for <dm-devel@redhat.com>; Tue,  1 Mar 2022 09:15:33 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-493-HVEbCDnSPS-1uSqMCfKGDA-1; Tue, 01 Mar 2022 04:15:30 -0500
X-MC-Unique: HVEbCDnSPS-1uSqMCfKGDA-1
Received: from [2.53.44.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nOy1Y-00FdGB-2b; Tue, 01 Mar 2022 08:38:24 +0000
From: Christoph Hellwig <hch@lst.de>
To: snitzer@redhat.com
Date: Tue,  1 Mar 2022 10:38:15 +0200
Message-Id: <20220301083815.879515-2-hch@lst.de>
In-Reply-To: <20220301083815.879515-1-hch@lst.de>
References: <20220301083815.879515-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, damien.lemoal@opensource.wdc.com
Subject: [dm-devel] [PATCH 2/2] dm: stop using bdevname
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Just use the %pg format specifier instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm-cache-target.c | 10 ++++------
 drivers/md/dm-clone-target.c | 10 ++++------
 drivers/md/dm-mpath.c        |  6 ++----
 drivers/md/dm-table.c        | 30 ++++++++++++++----------------
 drivers/md/dm-thin.c         |  8 +++-----
 5 files changed, 27 insertions(+), 37 deletions(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 89fdfb49d564e..d46c06f2ffccf 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -2015,7 +2015,6 @@ static int parse_metadata_dev(struct cache_args *ca, struct dm_arg_set *as,
 {
 	int r;
 	sector_t metadata_dev_size;
-	char b[BDEVNAME_SIZE];
 
 	if (!at_least_one_arg(as, error))
 		return -EINVAL;
@@ -2029,8 +2028,8 @@ static int parse_metadata_dev(struct cache_args *ca, struct dm_arg_set *as,
 
 	metadata_dev_size = get_dev_size(ca->metadata_dev);
 	if (metadata_dev_size > DM_CACHE_METADATA_MAX_SECTORS_WARNING)
-		DMWARN("Metadata device %s is larger than %u sectors: excess space will not be used.",
-		       bdevname(ca->metadata_dev->bdev, b), THIN_METADATA_MAX_SECTORS);
+		DMWARN("Metadata device %pg is larger than %u sectors: excess space will not be used.",
+		       ca->metadata_dev->bdev, THIN_METADATA_MAX_SECTORS);
 
 	return 0;
 }
@@ -3345,7 +3344,6 @@ static void disable_passdown_if_not_supported(struct cache *cache)
 	struct block_device *origin_bdev = cache->origin_dev->bdev;
 	struct queue_limits *origin_limits = &bdev_get_queue(origin_bdev)->limits;
 	const char *reason = NULL;
-	char buf[BDEVNAME_SIZE];
 
 	if (!cache->features.discard_passdown)
 		return;
@@ -3357,8 +3355,8 @@ static void disable_passdown_if_not_supported(struct cache *cache)
 		reason = "max discard sectors smaller than a block";
 
 	if (reason) {
-		DMWARN("Origin device (%s) %s: Disabling discard passdown.",
-		       bdevname(origin_bdev, buf), reason);
+		DMWARN("Origin device (%pg) %s: Disabling discard passdown.",
+		       origin_bdev, reason);
 		cache->features.discard_passdown = false;
 	}
 }
diff --git a/drivers/md/dm-clone-target.c b/drivers/md/dm-clone-target.c
index 4599632d7a84c..128316a73d016 100644
--- a/drivers/md/dm-clone-target.c
+++ b/drivers/md/dm-clone-target.c
@@ -1682,7 +1682,6 @@ static int parse_metadata_dev(struct clone *clone, struct dm_arg_set *as, char *
 {
 	int r;
 	sector_t metadata_dev_size;
-	char b[BDEVNAME_SIZE];
 
 	r = dm_get_device(clone->ti, dm_shift_arg(as), FMODE_READ | FMODE_WRITE,
 			  &clone->metadata_dev);
@@ -1693,8 +1692,8 @@ static int parse_metadata_dev(struct clone *clone, struct dm_arg_set *as, char *
 
 	metadata_dev_size = get_dev_size(clone->metadata_dev);
 	if (metadata_dev_size > DM_CLONE_METADATA_MAX_SECTORS_WARNING)
-		DMWARN("Metadata device %s is larger than %u sectors: excess space will not be used.",
-		       bdevname(clone->metadata_dev->bdev, b), DM_CLONE_METADATA_MAX_SECTORS);
+		DMWARN("Metadata device %pg is larger than %u sectors: excess space will not be used.",
+		       clone->metadata_dev->bdev, DM_CLONE_METADATA_MAX_SECTORS);
 
 	return 0;
 }
@@ -2033,7 +2032,6 @@ static void disable_passdown_if_not_supported(struct clone *clone)
 	struct block_device *dest_dev = clone->dest_dev->bdev;
 	struct queue_limits *dest_limits = &bdev_get_queue(dest_dev)->limits;
 	const char *reason = NULL;
-	char buf[BDEVNAME_SIZE];
 
 	if (!test_bit(DM_CLONE_DISCARD_PASSDOWN, &clone->flags))
 		return;
@@ -2044,8 +2042,8 @@ static void disable_passdown_if_not_supported(struct clone *clone)
 		reason = "max discard sectors smaller than a region";
 
 	if (reason) {
-		DMWARN("Destination device (%s) %s: Disabling discard passdown.",
-		       bdevname(dest_dev, buf), reason);
+		DMWARN("Destination device (%pd) %s: Disabling discard passdown.",
+		       dest_dev, reason);
 		clear_bit(DM_CLONE_DISCARD_PASSDOWN, &clone->flags);
 	}
 }
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index f4719b65e5e33..411403b3ec435 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -899,10 +899,8 @@ static int setup_scsi_dh(struct block_device *bdev, struct multipath *m,
 	if (m->hw_handler_name) {
 		r = scsi_dh_attach(q, m->hw_handler_name);
 		if (r == -EBUSY) {
-			char b[BDEVNAME_SIZE];
-
-			printk(KERN_INFO "dm-mpath: retaining handler on device %s\n",
-			       bdevname(bdev, b));
+			printk(KERN_INFO "dm-mpath: retaining handler on device %pg\n",
+			       bdev);
 			goto retain;
 		}
 		if (r < 0) {
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index e43096cfe9e22..f4ed756ab391a 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -230,15 +230,14 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
 	sector_t dev_size = bdev_nr_sectors(bdev);
 	unsigned short logical_block_size_sectors =
 		limits->logical_block_size >> SECTOR_SHIFT;
-	char b[BDEVNAME_SIZE];
 
 	if (!dev_size)
 		return 0;
 
 	if ((start >= dev_size) || (start + len > dev_size)) {
-		DMWARN("%s: %s too small for target: "
+		DMWARN("%s: %pg too small for target: "
 		       "start=%llu, len=%llu, dev_size=%llu",
-		       dm_device_name(ti->table->md), bdevname(bdev, b),
+		       dm_device_name(ti->table->md), bdev,
 		       (unsigned long long)start,
 		       (unsigned long long)len,
 		       (unsigned long long)dev_size);
@@ -253,10 +252,10 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
 		unsigned int zone_sectors = bdev_zone_sectors(bdev);
 
 		if (start & (zone_sectors - 1)) {
-			DMWARN("%s: start=%llu not aligned to h/w zone size %u of %s",
+			DMWARN("%s: start=%llu not aligned to h/w zone size %u of %pg",
 			       dm_device_name(ti->table->md),
 			       (unsigned long long)start,
-			       zone_sectors, bdevname(bdev, b));
+			       zone_sectors, bdev);
 			return 1;
 		}
 
@@ -270,10 +269,10 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
 		 * the sector range.
 		 */
 		if (len & (zone_sectors - 1)) {
-			DMWARN("%s: len=%llu not aligned to h/w zone size %u of %s",
+			DMWARN("%s: len=%llu not aligned to h/w zone size %u of %pg",
 			       dm_device_name(ti->table->md),
 			       (unsigned long long)len,
-			       zone_sectors, bdevname(bdev, b));
+			       zone_sectors, bdev);
 			return 1;
 		}
 	}
@@ -283,19 +282,19 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
 
 	if (start & (logical_block_size_sectors - 1)) {
 		DMWARN("%s: start=%llu not aligned to h/w "
-		       "logical block size %u of %s",
+		       "logical block size %u of %pg",
 		       dm_device_name(ti->table->md),
 		       (unsigned long long)start,
-		       limits->logical_block_size, bdevname(bdev, b));
+		       limits->logical_block_size, bdev);
 		return 1;
 	}
 
 	if (len & (logical_block_size_sectors - 1)) {
 		DMWARN("%s: len=%llu not aligned to h/w "
-		       "logical block size %u of %s",
+		       "logical block size %u of %pg",
 		       dm_device_name(ti->table->md),
 		       (unsigned long long)len,
-		       limits->logical_block_size, bdevname(bdev, b));
+		       limits->logical_block_size, bdev);
 		return 1;
 	}
 
@@ -400,20 +399,19 @@ static int dm_set_device_limits(struct dm_target *ti, struct dm_dev *dev,
 	struct queue_limits *limits = data;
 	struct block_device *bdev = dev->bdev;
 	struct request_queue *q = bdev_get_queue(bdev);
-	char b[BDEVNAME_SIZE];
 
 	if (unlikely(!q)) {
-		DMWARN("%s: Cannot set limits for nonexistent device %s",
-		       dm_device_name(ti->table->md), bdevname(bdev, b));
+		DMWARN("%s: Cannot set limits for nonexistent device %pg",
+		       dm_device_name(ti->table->md), bdev);
 		return 0;
 	}
 
 	if (blk_stack_limits(limits, &q->limits,
 			get_start_sect(bdev) + start) < 0)
-		DMWARN("%s: adding target device %s caused an alignment inconsistency: "
+		DMWARN("%s: adding target device %pg caused an alignment inconsistency: "
 		       "physical_block_size=%u, logical_block_size=%u, "
 		       "alignment_offset=%u, start=%llu",
-		       dm_device_name(ti->table->md), bdevname(bdev, b),
+		       dm_device_name(ti->table->md), bdev,
 		       q->limits.physical_block_size,
 		       q->limits.logical_block_size,
 		       q->limits.alignment_offset,
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index f4234d615aa1b..d210d1fffc3b4 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2824,7 +2824,6 @@ static void disable_passdown_if_not_supported(struct pool_c *pt)
 	struct block_device *data_bdev = pt->data_dev->bdev;
 	struct queue_limits *data_limits = &bdev_get_queue(data_bdev)->limits;
 	const char *reason = NULL;
-	char buf[BDEVNAME_SIZE];
 
 	if (!pt->adjusted_pf.discard_passdown)
 		return;
@@ -2836,7 +2835,7 @@ static void disable_passdown_if_not_supported(struct pool_c *pt)
 		reason = "max discard sectors smaller than a block";
 
 	if (reason) {
-		DMWARN("Data device (%s) %s: Disabling discard passdown.", bdevname(data_bdev, buf), reason);
+		DMWARN("Data device (%pg) %s: Disabling discard passdown.", data_bdev, reason);
 		pt->adjusted_pf.discard_passdown = false;
 	}
 }
@@ -3201,11 +3200,10 @@ static sector_t get_dev_size(struct block_device *bdev)
 static void warn_if_metadata_device_too_big(struct block_device *bdev)
 {
 	sector_t metadata_dev_size = get_dev_size(bdev);
-	char buffer[BDEVNAME_SIZE];
 
 	if (metadata_dev_size > THIN_METADATA_MAX_SECTORS_WARNING)
-		DMWARN("Metadata device %s is larger than %u sectors: excess space will not be used.",
-		       bdevname(bdev, buffer), THIN_METADATA_MAX_SECTORS);
+		DMWARN("Metadata device %pg is larger than %u sectors: excess space will not be used.",
+		       bdev, THIN_METADATA_MAX_SECTORS);
 }
 
 static sector_t get_metadata_dev_size(struct block_device *bdev)
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

