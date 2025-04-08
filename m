Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8BF5255E44
	for <dm-devel@lists.linux.dev>; Tue,  8 Apr 2025 23:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744156327; cv=none; b=eISOwW5n7evYJiXxof0nDvxsKgkoGVpHI6hyzFCtWspojRIIYTThYQcytTp25QnD7mbEZvZoiJR3UvJ+rs88Wz++KNiqOLi+TSdpc6VszuKTBTkHHMG3cBE+2IHxDab3C+YE0nf8vuLvQsxksRgiIZuw7kM1rhHDAu5/Bb5sXbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744156327; c=relaxed/simple;
	bh=7jhQPNTdO49SUNApFALyA5f8RJa4HPqncdwDcFHnhoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=AmUyD0zridMI5OHGDC9DuzvZrSn8yiG25P/Maz2bRU+PWWBZxV1yrar37/jQqHkIbKxiI7MDUgpgHX2GgkVZa4UBITlFl0uMCUAy2YGf0mYZqrEM/QG31oNtLwIMIe8TjZAKYpFDCzZT1BOk155dfUUH00fADPjAwD9YjI6JLEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Os3EG7x5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Os3EG7x5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744156324;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4lRfEi+FAUFR7oR+RUHlHzDP0C/LEWhi6L6Li0gp+vQ=;
	b=Os3EG7x5domDdlYfhgs6D/v9i9Hw+GEETX3K3Rd6I/3aEqF2nei/WcFOVp5jK39zLrHfxb
	JcvMF+yygHHs7jAf8PkJgR7RAj+SQ0o0UytFsL70etvkHG/DDDorp5p821ow3M1Z7xaTMg
	2cJAqQ+1Djz5ZlxDaR/Tx0lI+SJP8A4=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-473-woSLM-ubOIidQgf2QyquEw-1; Tue,
 08 Apr 2025 19:52:03 -0400
X-MC-Unique: woSLM-ubOIidQgf2QyquEw-1
X-Mimecast-MFC-AGG-ID: woSLM-ubOIidQgf2QyquEw_1744156322
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EBE9B1800258;
	Tue,  8 Apr 2025 23:52:01 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 23B5C1955BC0;
	Tue,  8 Apr 2025 23:52:01 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 538Nq0ZU4128869
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 8 Apr 2025 19:52:00 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 538Nq06n4128868;
	Tue, 8 Apr 2025 19:52:00 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@lists.linux.dev, Damien Le Moal <dlemoal@kernel.org>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH v3 4/6] dm: fix dm_blk_report_zones
Date: Tue,  8 Apr 2025 19:51:57 -0400
Message-ID: <20250408235159.4128838-5-bmarzins@redhat.com>
In-Reply-To: <20250408235159.4128838-1-bmarzins@redhat.com>
References: <20250408235159.4128838-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: dMRZRU2wukcuxRJEsu5YC5XdoDqg5mREI84OQbq5CoA_1744156322
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

If dm_get_live_table() returned NULL, dm_put_live_table() was never
called. Also, it is possible that md->zone_revalidate_map will change
while calling this function. Only read it once, so that we are always
using the same value. Otherwise we might miss a call to
dm_put_live_table().

Finally, while md->zone_revalidate_map is set and a process is calling
blk_revalidate_disk_zones() to set up the zone append emulation
resources, it is possible that another process, perhaps triggered by
blkdev_report_zones_ioctl(), will call dm_blk_report_zones(). If
blk_revalidate_disk_zones() fails, these resources can be freed while
the other process is still using them, causing a use-after-free error.

blk_revalidate_disk_zones() will only ever be called when initially
setting up the zone append emulation resources, such as when setting up
a zoned dm-crypt table for the first time. Further table swaps will not
set md->zone_revalidate_map or call blk_revalidate_disk_zones().
However it must be called using the new table (referenced by
md->zone_revalidate_map) and the new queue limits while the DM device is
suspended. dm_blk_report_zones() needs some way to distinguish between a
call from blk_revalidate_disk_zones(), which must be allowed to use
md->zone_revalidate_map to access this not yet activated table, and all
other calls to dm_blk_report_zones(), which should not be allowed while
the device is suspended and cannot use md->zone_revalidate_map, since
the zone resources might be freed by the process currently calling
blk_revalidate_disk_zones().

Solve this by tracking the process that set md->zone_revalidate_map
dm_revalidate_zones() and only allowing that process to make use of it
in dm_blk_report_zones().

Fixes: f211268ed1f9b ("dm: Use the block layer zone append emulation")
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 drivers/md/dm-core.h |  1 +
 drivers/md/dm-zone.c | 23 +++++++++++++++--------
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
index 3637761f3585..f3a3f2ef6322 100644
--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -141,6 +141,7 @@ struct mapped_device {
 #ifdef CONFIG_BLK_DEV_ZONED
 	unsigned int nr_zones;
 	void *zone_revalidate_map;
+	struct task_struct *revalidate_map_task;
 #endif
 
 #ifdef CONFIG_IMA
diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
index 681058feb63b..11e19281bb64 100644
--- a/drivers/md/dm-zone.c
+++ b/drivers/md/dm-zone.c
@@ -56,24 +56,29 @@ int dm_blk_report_zones(struct gendisk *disk, sector_t sector,
 {
 	struct mapped_device *md = disk->private_data;
 	struct dm_table *map;
-	int srcu_idx, ret;
+	struct dm_table *zone_revalidate_map = md->zone_revalidate_map;
+	int srcu_idx, ret = -EIO;
 
-	if (!md->zone_revalidate_map) {
-		/* Regular user context */
+	if (!zone_revalidate_map || md->revalidate_map_task != current) {
+		/*
+		 * Regular user context or
+		 * Zone revalidation during __bind() is in progress, but this
+		 * call is from a different process
+		 */
 		if (dm_suspended_md(md))
 			return -EAGAIN;
 
 		map = dm_get_live_table(md, &srcu_idx);
-		if (!map)
-			return -EIO;
 	} else {
 		/* Zone revalidation during __bind() */
-		map = md->zone_revalidate_map;
+		map = zone_revalidate_map;
 	}
 
-	ret = dm_blk_do_report_zones(md, map, sector, nr_zones, cb, data);
+	if (map)
+		ret = dm_blk_do_report_zones(md, map, sector, nr_zones, cb,
+					     data);
 
-	if (!md->zone_revalidate_map)
+	if (!zone_revalidate_map)
 		dm_put_live_table(md, srcu_idx);
 
 	return ret;
@@ -175,7 +180,9 @@ int dm_revalidate_zones(struct dm_table *t, struct request_queue *q)
 	 * our table for dm_blk_report_zones() to use directly.
 	 */
 	md->zone_revalidate_map = t;
+	md->revalidate_map_task = current;
 	ret = blk_revalidate_disk_zones(disk);
+	md->revalidate_map_task = NULL;
 	md->zone_revalidate_map = NULL;
 
 	if (ret) {
-- 
2.48.1

