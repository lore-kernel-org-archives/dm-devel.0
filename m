Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AEEF28F935
	for <dm-devel@lists.linux.dev>; Thu, 10 Apr 2025 19:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744314594; cv=none; b=uV1fEXAyqMphdC4y0j8OSiyS8Os9k53ozAC7ZZW9YJDtdmA0za8kDBJYKuo0FP1E5Bu+NpvcclsxPCuta2jKrF2JHPutpJ2YkILal1rGH/3FqZakOaU8oCzYY4nOHYipQc68HlPIj/ktDg6fpPOOBX5o4ze/KHJRrOY5FwqKGc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744314594; c=relaxed/simple;
	bh=Q5T7viEjSeMzudfvogEz8xijsgrtnDjUQG7KJ3YYMPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=ZMDchWD2wzPHUu4WEfznNEh/nfiiLZr7tSVHCLF+MT8jaUadgLDzAqOubX3fn61ndkF5PSPI21umkhyO7FCWMTM2D2fYC9RjMuxN7Vv73k5QhJ5ZTIxhCfY7IfazBMglMWNs2hiY8JhxG3z8uu4shQiz1FM/fkoaLjX1N38p3C0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aNpIgfHl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aNpIgfHl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744314590;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bjs8IU6CtG41/KfX2tdqOpuD8X6EJdideKhZSZHmvqk=;
	b=aNpIgfHla/5NfQ25F6OJ96bVA9SFJlifEfvYyO1pal/8dksIeUhlH+UHqC5PPW54jTluIw
	D7hmmG1ajTzEBMj+hQqrqT3lIwrSJtkoM1xVyQWSrexIo/IhVmKYSNPKncuZOJuk3I70Y7
	kDlVlj+1UaSe0C9xPAMQQypij1wwXSE=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-91-qu6K0lq6MPCAFfNADmF3Qg-1; Thu,
 10 Apr 2025 15:49:47 -0400
X-MC-Unique: qu6K0lq6MPCAFfNADmF3Qg-1
X-Mimecast-MFC-AGG-ID: qu6K0lq6MPCAFfNADmF3Qg_1744314586
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5DEA819560B8;
	Thu, 10 Apr 2025 19:49:46 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CEA411956094;
	Thu, 10 Apr 2025 19:49:45 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 53AJni4m009353
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 10 Apr 2025 15:49:44 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 53AJniNE009352;
	Thu, 10 Apr 2025 15:49:44 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@lists.linux.dev, Damien Le Moal <dlemoal@kernel.org>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH v4 3/6] dm: handle failures in dm_table_set_restrictions
Date: Thu, 10 Apr 2025 15:49:40 -0400
Message-ID: <20250410194943.9326-4-bmarzins@redhat.com>
In-Reply-To: <20250410194943.9326-1-bmarzins@redhat.com>
References: <20250410194943.9326-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ghOI2fQjRN38jLuMnPqN9XPb5srETtNIIoTH79gzTLg_1744314586
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

If dm_table_set_restrictions() fails while swapping tables,
device-mapper will continue using the previous table. It must be sure to
leave the mapped_device in it's previous state on failure.  Otherwise
device-mapper could end up using the old table with settings from the
unused table.

Do not update the mapped device in dm_set_zones_restrictions(). Wait
till after dm_table_set_restrictions() is sure to succeed to update the
md zoned settings. Do the same with the dax settings, and if
dm_revalidate_zones() fails, restore the original queue limits.

Fixes: 7f91ccd8a608d ("dm: Call dm_revalidate_zones() after setting the queue limits")
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 drivers/md/dm-table.c | 26 +++++++++++++++++---------
 drivers/md/dm-zone.c  | 26 ++++++++++++++++++--------
 drivers/md/dm.h       |  1 +
 3 files changed, 36 insertions(+), 17 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 04b3e9758e53..b8191ce691f1 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1840,6 +1840,7 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 			      struct queue_limits *limits)
 {
 	int r;
+	struct queue_limits old_limits;
 
 	if (!dm_table_supports_nowait(t))
 		limits->features &= ~BLK_FEAT_NOWAIT;
@@ -1866,16 +1867,11 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 	if (dm_table_supports_flush(t))
 		limits->features |= BLK_FEAT_WRITE_CACHE | BLK_FEAT_FUA;
 
-	if (dm_table_supports_dax(t, device_not_dax_capable)) {
+	if (dm_table_supports_dax(t, device_not_dax_capable))
 		limits->features |= BLK_FEAT_DAX;
-		if (dm_table_supports_dax(t, device_not_dax_synchronous_capable))
-			set_dax_synchronous(t->md->dax_dev);
-	} else
+	else
 		limits->features &= ~BLK_FEAT_DAX;
 
-	if (dm_table_any_dev_attr(t, device_dax_write_cache_enabled, NULL))
-		dax_write_cache(t->md->dax_dev, true);
-
 	/* For a zoned table, setup the zone related queue attributes. */
 	if (IS_ENABLED(CONFIG_BLK_DEV_ZONED) &&
 	    (limits->features & BLK_FEAT_ZONED)) {
@@ -1887,7 +1883,8 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 	if (dm_table_supports_atomic_writes(t))
 		limits->features |= BLK_FEAT_ATOMIC_WRITES;
 
-	r = queue_limits_set(q, limits);
+	old_limits = queue_limits_start_update(q);
+	r = queue_limits_commit_update(q, limits);
 	if (r)
 		return r;
 
@@ -1898,10 +1895,21 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 	if (IS_ENABLED(CONFIG_BLK_DEV_ZONED) &&
 	    (limits->features & BLK_FEAT_ZONED)) {
 		r = dm_revalidate_zones(t, q);
-		if (r)
+		if (r) {
+			queue_limits_set(q, &old_limits);
 			return r;
+		}
 	}
 
+	if (IS_ENABLED(CONFIG_BLK_DEV_ZONED))
+		dm_finalize_zone_settings(t, limits);
+
+	if (dm_table_supports_dax(t, device_not_dax_synchronous_capable))
+		set_dax_synchronous(t->md->dax_dev);
+
+	if (dm_table_any_dev_attr(t, device_dax_write_cache_enabled, NULL))
+		dax_write_cache(t->md->dax_dev, true);
+
 	dm_update_crypto_profile(q, t);
 	return 0;
 }
diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
index 20edd3fabbab..681058feb63b 100644
--- a/drivers/md/dm-zone.c
+++ b/drivers/md/dm-zone.c
@@ -340,12 +340,8 @@ int dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q,
 	 * mapped device queue as needing zone append emulation.
 	 */
 	WARN_ON_ONCE(queue_is_mq(q));
-	if (dm_table_supports_zone_append(t)) {
-		clear_bit(DMF_EMULATE_ZONE_APPEND, &md->flags);
-	} else {
-		set_bit(DMF_EMULATE_ZONE_APPEND, &md->flags);
+	if (!dm_table_supports_zone_append(t))
 		lim->max_hw_zone_append_sectors = 0;
-	}
 
 	/*
 	 * Determine the max open and max active zone limits for the mapped
@@ -383,9 +379,6 @@ int dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q,
 		lim->zone_write_granularity = 0;
 		lim->chunk_sectors = 0;
 		lim->features &= ~BLK_FEAT_ZONED;
-		clear_bit(DMF_EMULATE_ZONE_APPEND, &md->flags);
-		md->nr_zones = 0;
-		disk->nr_zones = 0;
 		return 0;
 	}
 
@@ -408,6 +401,23 @@ int dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q,
 	return 0;
 }
 
+void dm_finalize_zone_settings(struct dm_table *t, struct queue_limits *lim)
+{
+	struct mapped_device *md = t->md;
+
+	if (lim->features & BLK_FEAT_ZONED) {
+		if (dm_table_supports_zone_append(t))
+			clear_bit(DMF_EMULATE_ZONE_APPEND, &md->flags);
+		else
+			set_bit(DMF_EMULATE_ZONE_APPEND, &md->flags);
+	} else {
+		clear_bit(DMF_EMULATE_ZONE_APPEND, &md->flags);
+		md->nr_zones = 0;
+		md->disk->nr_zones = 0;
+	}
+}
+
+
 /*
  * IO completion callback called from clone_endio().
  */
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index a0a8ff119815..e5d3a9f46a91 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -102,6 +102,7 @@ int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t);
 int dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q,
 		struct queue_limits *lim);
 int dm_revalidate_zones(struct dm_table *t, struct request_queue *q);
+void dm_finalize_zone_settings(struct dm_table *t, struct queue_limits *lim);
 void dm_zone_endio(struct dm_io *io, struct bio *clone);
 #ifdef CONFIG_BLK_DEV_ZONED
 int dm_blk_report_zones(struct gendisk *disk, sector_t sector,
-- 
2.48.1

