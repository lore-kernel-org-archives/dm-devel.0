Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E10CE1F585D
	for <dm-devel@lists.linux.dev>; Sun,  9 Mar 2025 22:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741559357; cv=none; b=dIglyaG6LzjqwL75aBpv95VIWfN9KMSUYQvIQp2fmiJpFItliAYtkAVWUfoO6lUl/pP3XWLVb6rMRrGO8TfLcbuBCkacuGX2fAobLyGDruda7uDJHV4rT/JWct71U3xpjKmuzBXI2BrZ8SvCKmn7BrT931HQRHnF8Dr0Hq4xtcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741559357; c=relaxed/simple;
	bh=xjqrQy3/c2CAxNKpBKKoixokmpaWgzY9JitddRa4JL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t/NStn1SGw+L4KFL+A4eRTwAlUqmT80VvhRvOTMRpVI4Vfx7c3twFMNeXvN1buSLeWlFXrrnHWzawDKywsc8r4hQ2gQ8G1G9fIKGG/MtDuzR0Y0TCthxASwlwxohrfUTuh7ju9sALsmwisayOf9S/UUfBhnF1wwNWBDTPEm04zA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Re3qCzHY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Re3qCzHY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741559354;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mBTya5jDAn2ECaAH85zdtyIYqLGYimiGN42zC1yyuhw=;
	b=Re3qCzHYDKWfUdZcUZJ824Cp6MpjVHjq1igRZtsmgmz0I/U/sralJxsBbvkw6hehgsCjt/
	5tzx1bAwPByqgUO97fhvoDXbCHgWACSSwlFXA6CPXOGEcqGBt5B5V8Dm3FxWde+iRrR3Sn
	CxsdyWB+ZvmyTCauOeiFnRCaw9VnkJw=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-382-inuSz8IPP6ShbcW1Lv_jiA-1; Sun,
 09 Mar 2025 18:29:09 -0400
X-MC-Unique: inuSz8IPP6ShbcW1Lv_jiA-1
X-Mimecast-MFC-AGG-ID: inuSz8IPP6ShbcW1Lv_jiA_1741559347
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 756F719560AB;
	Sun,  9 Mar 2025 22:29:07 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9B2EB19560AD;
	Sun,  9 Mar 2025 22:29:06 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 529MT5eW449831
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sun, 9 Mar 2025 18:29:05 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 529MT5EM449830;
	Sun, 9 Mar 2025 18:29:05 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Cc: dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
        Damien Le Moal <dlemoal@kernel.org>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/7] dm: handle failures in dm_table_set_restrictions
Date: Sun,  9 Mar 2025 18:28:59 -0400
Message-ID: <20250309222904.449803-4-bmarzins@redhat.com>
In-Reply-To: <20250309222904.449803-1-bmarzins@redhat.com>
References: <20250309222904.449803-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

If dm_table_set_restrictions() fails while swapping tables,
device-mapper will continue using the previous table. It must be sure to
leave the mapped_device in it's previous state on failure.  Otherwise
device-mapper could end up using the old table with settings from the
unused table.

Do not update the mapped device in dm_set_zones_restrictions(). Wait
till after dm_table_set_restrictions() is sure to succeed to update the
md zoned settings. Do the same with the dax settings, and if
dm_revalidate_zones() fails, restore the original queue limits.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 drivers/md/dm-table.c | 24 ++++++++++++++++--------
 drivers/md/dm-zone.c  | 26 ++++++++++++++++++--------
 drivers/md/dm.h       |  1 +
 3 files changed, 35 insertions(+), 16 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 0ef5203387b2..4003e84af11d 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1836,6 +1836,7 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 			      struct queue_limits *limits)
 {
 	int r;
+	struct queue_limits old_limits;
 
 	if (!dm_table_supports_nowait(t))
 		limits->features &= ~BLK_FEAT_NOWAIT;
@@ -1862,16 +1863,11 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
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
@@ -1883,6 +1879,7 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 	if (dm_table_supports_atomic_writes(t))
 		limits->features |= BLK_FEAT_ATOMIC_WRITES;
 
+	old_limits = q->limits;
 	r = queue_limits_set(q, limits);
 	if (r)
 		return r;
@@ -1894,10 +1891,21 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
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

