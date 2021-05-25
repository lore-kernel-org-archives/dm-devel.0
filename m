Return-Path: <SRS0=hs6z=KU=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9772C4707F
	for <dm-devel@archiver.kernel.org>; Tue, 25 May 2021 21:25:44 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7F6D7611BE
	for <dm-devel@archiver.kernel.org>; Tue, 25 May 2021 21:25:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7F6D7611BE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-479-BYI8UwVOMtSXWxDqkbRfLQ-1; Tue, 25 May 2021 17:25:41 -0400
X-MC-Unique: BYI8UwVOMtSXWxDqkbRfLQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B02866415B;
	Tue, 25 May 2021 21:25:36 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8C322100F49F;
	Tue, 25 May 2021 21:25:36 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5CCDA55351;
	Tue, 25 May 2021 21:25:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14PLPMQC003392 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 25 May 2021 17:25:22 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 76007103D232; Tue, 25 May 2021 21:25:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 719181025836
	for <dm-devel@redhat.com>; Tue, 25 May 2021 21:25:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 10E9E101D239
	for <dm-devel@redhat.com>; Tue, 25 May 2021 21:25:22 +0000 (UTC)
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-215-Qhf9hhb_NPCFdW7ee2MyoA-4; Tue, 25 May 2021 17:25:13 -0400
X-MC-Unique: Qhf9hhb_NPCFdW7ee2MyoA-4
IronPort-SDR: uGx70dkniVPrseyQusCmV73h+ELrE783jEOh77uygdLy2MlsEEzpuKmpdFq5VWHWmModLdjBQW
	sLwIvy4sDN7mwEOPgubpeL6MXDoTxzrLLzZUlz9KZDReu5AmZcDaK+qBEmX2mWKjHLWvxfccNq
	Xz2lR5UVeXbo1YMkHXXUr/LDkhs9xyPG+b6OttPH9WbGvsmfBvsTy+G87cJQTHdJRHRciNChSd
	sVxK+gqcefusmvhpOl80F9Dc3BeotMg8z18BE0RXNJJgIqRfOVn07wfDKCmOEJ1YVGOBQhxMWI
	7Qk=
X-IronPort-AV: E=Sophos;i="5.82,329,1613404800"; d="scan'208";a="168717532"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com)
	([199.255.45.15])
	by ob1.hgst.iphmx.com with ESMTP; 26 May 2021 05:25:12 +0800
IronPort-SDR: 38g1w6W47T5TSVHPvj4vBuJLfD30HZVxuZGv9kfOWTWn9JGGM3va0vYO95VQ1EA6FJJam1RdI1
	Db0z7uObUyROsTvvLFnFsUYcOTTpqCOpVpcStbW8j5xRofLRj3vgEToHzaqURQhauPZ1TV4u8j
	WYGVX18GFniQwJ+tjrrkEN+5pxgi3AYVcrsm77ViClCP9HSl47ojL8eWDAOPxMSxTuqzUZrKDY
	Z4t5g6wyI9vH4xLVqtekH65BhsxIe+PW9uIDAo5JoBKrgs9ckIz/hAHlUHbv5zRE3KkhTfSh/+
	C0pt/EZIFVmvMj8EVYnUux2f
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
	by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	25 May 2021 14:03:22 -0700
IronPort-SDR: 8cS/GDNZrClTdleFDrLru3OBcppNA7XH7h94rIzbghBh8hgaS9NSlzHJgUaL3pm3ATTWbe1+zn
	pmvnWYsQkP7IZZRFh/C/o5nyuWZjXYqOUcsITS+vUCzX9aJeMlMeexFIn98C0dSE/K/Rn6dKMX
	sVtGzAJopMZ7A1qBwEGoVP3MWE+W3Nf8h+iL90djMtsIK2yBBeqqoz/v9Ens5YRUCSnfvsHLlI
	S149d8GcGZeACDv+pfWQF/XPnnxbiNJ/HOQIN3wLvEz9dLPyvvOTYrgOC/N4Sa5/qaHuO/N4nS
	lZQ=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
	by uls-op-cesaip01.wdc.com with ESMTP; 25 May 2021 14:25:12 -0700
From: Damien Le Moal <damien.lemoal@wdc.com>
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
	linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Date: Wed, 26 May 2021 06:24:57 +0900
Message-Id: <20210525212501.226888-8-damien.lemoal@wdc.com>
In-Reply-To: <20210525212501.226888-1-damien.lemoal@wdc.com>
References: <20210525212501.226888-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Subject: [dm-devel] [PATCH v5 07/11] dm: Introduce dm_report_zones()
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

To simplify the implementation of the report_zones operation of a zoned
target, introduce the function dm_report_zones() to set a target
mapping start sector in struct dm_report_zones_args and call
blkdev_report_zones(). This new function is exported and the report
zones callback function dm_report_zones_cb() is not.

dm-linear, dm-flakey and dm-crypt are modified to use dm_report_zones().

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/md/dm-crypt.c         |  7 +++----
 drivers/md/dm-flakey.c        |  7 +++----
 drivers/md/dm-linear.c        |  7 +++----
 drivers/md/dm-zone.c          | 23 ++++++++++++++++++++---
 include/linux/device-mapper.h |  3 ++-
 5 files changed, 31 insertions(+), 16 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index b0ab080f2567..f410ceee51d7 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -3138,11 +3138,10 @@ static int crypt_report_zones(struct dm_target *ti,
 		struct dm_report_zones_args *args, unsigned int nr_zones)
 {
 	struct crypt_config *cc = ti->private;
-	sector_t sector = cc->start + dm_target_offset(ti, args->next_sector);
 
-	args->start = cc->start;
-	return blkdev_report_zones(cc->dev->bdev, sector, nr_zones,
-				   dm_report_zones_cb, args);
+	return dm_report_zones(cc->dev->bdev, cc->start,
+			cc->start + dm_target_offset(ti, args->next_sector),
+			args, nr_zones);
 }
 #else
 #define crypt_report_zones NULL
diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index b7fee9936f05..5877220c01ed 100644
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -463,11 +463,10 @@ static int flakey_report_zones(struct dm_target *ti,
 		struct dm_report_zones_args *args, unsigned int nr_zones)
 {
 	struct flakey_c *fc = ti->private;
-	sector_t sector = flakey_map_sector(ti, args->next_sector);
 
-	args->start = fc->start;
-	return blkdev_report_zones(fc->dev->bdev, sector, nr_zones,
-				   dm_report_zones_cb, args);
+	return dm_report_zones(fc->dev->bdev, fc->start,
+			       flakey_map_sector(ti, args->next_sector),
+			       args, nr_zones);
 }
 #else
 #define flakey_report_zones NULL
diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index 92db0f5e7f28..c91f1e2e2f65 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -140,11 +140,10 @@ static int linear_report_zones(struct dm_target *ti,
 		struct dm_report_zones_args *args, unsigned int nr_zones)
 {
 	struct linear_c *lc = ti->private;
-	sector_t sector = linear_map_sector(ti, args->next_sector);
 
-	args->start = lc->start;
-	return blkdev_report_zones(lc->dev->bdev, sector, nr_zones,
-				   dm_report_zones_cb, args);
+	return dm_report_zones(lc->dev->bdev, lc->start,
+			       linear_map_sector(ti, args->next_sector),
+			       args, nr_zones);
 }
 #else
 #define linear_report_zones NULL
diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
index 3243c42b7951..b42474043249 100644
--- a/drivers/md/dm-zone.c
+++ b/drivers/md/dm-zone.c
@@ -56,7 +56,8 @@ int dm_blk_report_zones(struct gendisk *disk, sector_t sector,
 	return ret;
 }
 
-int dm_report_zones_cb(struct blk_zone *zone, unsigned int idx, void *data)
+static int dm_report_zones_cb(struct blk_zone *zone, unsigned int idx,
+			      void *data)
 {
 	struct dm_report_zones_args *args = data;
 	sector_t sector_diff = args->tgt->begin - args->start;
@@ -84,7 +85,24 @@ int dm_report_zones_cb(struct blk_zone *zone, unsigned int idx, void *data)
 	args->next_sector = zone->start + zone->len;
 	return args->orig_cb(zone, args->zone_idx++, args->orig_data);
 }
-EXPORT_SYMBOL_GPL(dm_report_zones_cb);
+
+/*
+ * Helper for drivers of zoned targets to implement struct target_type
+ * report_zones operation.
+ */
+int dm_report_zones(struct block_device *bdev, sector_t start, sector_t sector,
+		    struct dm_report_zones_args *args, unsigned int nr_zones)
+{
+	/*
+	 * Set the target mapping start sector first so that
+	 * dm_report_zones_cb() can correctly remap zone information.
+	 */
+	args->start = start;
+
+	return blkdev_report_zones(bdev, sector, nr_zones,
+				   dm_report_zones_cb, args);
+}
+EXPORT_SYMBOL_GPL(dm_report_zones);
 
 void dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q)
 {
@@ -99,4 +117,3 @@ void dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q)
 	WARN_ON_ONCE(queue_is_mq(q));
 	q->nr_zones = blkdev_nr_zones(t->md->disk);
 }
-
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index ff700fb6ce1d..caea0a079d2d 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -478,7 +478,8 @@ struct dm_report_zones_args {
 	/* must be filled by ->report_zones before calling dm_report_zones_cb */
 	sector_t start;
 };
-int dm_report_zones_cb(struct blk_zone *zone, unsigned int idx, void *data);
+int dm_report_zones(struct block_device *bdev, sector_t start, sector_t sector,
+		    struct dm_report_zones_args *args, unsigned int nr_zones);
 #endif /* CONFIG_BLK_DEV_ZONED */
 
 /*
-- 
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

