Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 524A1C433EF
	for <dm-devel@archiver.kernel.org>; Tue,  1 Mar 2022 09:23:18 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-265-PIbLOONkNLmxpxy-vyz60Q-1; Tue, 01 Mar 2022 04:23:13 -0500
X-MC-Unique: PIbLOONkNLmxpxy-vyz60Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D360D1006AA7;
	Tue,  1 Mar 2022 09:23:08 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 787CB7B6DD;
	Tue,  1 Mar 2022 09:23:08 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id EB7694A701;
	Tue,  1 Mar 2022 09:23:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 2219M6es001132 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 1 Mar 2022 04:22:06 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9168D46A387; Tue,  1 Mar 2022 09:22:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8DD1346A381
	for <dm-devel@redhat.com>; Tue,  1 Mar 2022 09:22:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 760DC801585
	for <dm-devel@redhat.com>; Tue,  1 Mar 2022 09:22:06 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-573-ltuyCRePNNuRci5Hrr0nqQ-1; Tue, 01 Mar 2022 04:22:04 -0500
X-MC-Unique: ltuyCRePNNuRci5Hrr0nqQ-1
Received: from [2.53.44.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nOy1U-00FdDp-2b; Tue, 01 Mar 2022 08:38:20 +0000
From: Christoph Hellwig <hch@lst.de>
To: snitzer@redhat.com
Date: Tue,  1 Mar 2022 10:38:14 +0200
Message-Id: <20220301083815.879515-1-hch@lst.de>
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
Subject: [dm-devel] [PATCH 1/2] dm-zoned: remove the ->name field in struct
	dmz_dev
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

Just use the %pg format specifier to print the block device name
directly.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm-zoned-metadata.c | 4 ++--
 drivers/md/dm-zoned-target.c   | 1 -
 drivers/md/dm-zoned.h          | 9 ++++-----
 3 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
index e5f1eb27ce2e9..d1ea66114d142 100644
--- a/drivers/md/dm-zoned-metadata.c
+++ b/drivers/md/dm-zoned-metadata.c
@@ -1101,8 +1101,8 @@ static int dmz_check_sb(struct dmz_metadata *zmd, struct dmz_sb *dsb,
  */
 static int dmz_read_sb(struct dmz_metadata *zmd, struct dmz_sb *sb, int set)
 {
-	dmz_zmd_debug(zmd, "read superblock set %d dev %s block %llu",
-		      set, sb->dev->name, sb->block);
+	dmz_zmd_debug(zmd, "read superblock set %d dev %pg block %llu",
+		      set, sb->dev->bdev, sb->block);
 
 	return dmz_rdwr_block(sb->dev, REQ_OP_READ,
 			      sb->block, sb->mblk->page);
diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
index a3f6d3ef38174..cac295cc8840e 100644
--- a/drivers/md/dm-zoned-target.c
+++ b/drivers/md/dm-zoned-target.c
@@ -730,7 +730,6 @@ static int dmz_get_zoned_device(struct dm_target *ti, char *path,
 	}
 	dev->bdev = bdev;
 	dev->dev_idx = idx;
-	(void)bdevname(dev->bdev, dev->name);
 
 	dev->capacity = bdev_nr_sectors(bdev);
 	if (ti->begin) {
diff --git a/drivers/md/dm-zoned.h b/drivers/md/dm-zoned.h
index 22f11440b423b..a02744a0846cc 100644
--- a/drivers/md/dm-zoned.h
+++ b/drivers/md/dm-zoned.h
@@ -56,7 +56,6 @@ struct dmz_dev {
 	struct dmz_metadata	*metadata;
 	struct dmz_reclaim	*reclaim;
 
-	char			name[BDEVNAME_SIZE];
 	uuid_t			uuid;
 
 	sector_t		capacity;
@@ -176,16 +175,16 @@ enum {
  * Message functions.
  */
 #define dmz_dev_info(dev, format, args...)	\
-	DMINFO("(%s): " format, (dev)->name, ## args)
+	DMINFO("(%pg): " format, (dev)->bdev, ## args)
 
 #define dmz_dev_err(dev, format, args...)	\
-	DMERR("(%s): " format, (dev)->name, ## args)
+	DMERR("(%pg): " format, (dev)->bdev, ## args)
 
 #define dmz_dev_warn(dev, format, args...)	\
-	DMWARN("(%s): " format, (dev)->name, ## args)
+	DMWARN("(%pg): " format, (dev)->bdev, ## args)
 
 #define dmz_dev_debug(dev, format, args...)	\
-	DMDEBUG("(%s): " format, (dev)->name, ## args)
+	DMDEBUG("(%pg): " format, (dev)->bdev, ## args)
 
 /*
  * Functions defined in dm-zoned-metadata.c
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

