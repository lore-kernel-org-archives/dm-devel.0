Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C00B21EE7D3
	for <dm-devel@lists.linux.dev>; Thu, 10 Apr 2025 19:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744314595; cv=none; b=IjPUoT1brAn4vgA2CuktIcnLjWxNNn9Y9635wuLaj1g0UffSl8nNtXfYmQMIqUoYNTEhFpyZowMZr+vldmxDcv6LM/FEIW8yNdYFelW7bVhVfJp7rJElGCTMjEnvnt10kW5DD6wBUIRY8qSBWVBWm1T7EGVo+B6ZamKREIxUHhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744314595; c=relaxed/simple;
	bh=NZvuM1seOygZthyK5vr8I8Ie0gBlYcIDvEY91/muEZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=UxDsAIzdVY8rvIS/0Wehp1j6eL23P95L1jI8iEW5Gp4OFdIGy5OlES6+QcwZb1CQGhbLJ+6FfIHyCLtxT8/x4NHUwegfbxq++Nsv+05pbBBiSMIQXe92TKWw21iaOYKUgsc2ufgN9hPrQxJx2Ur8mHfTFqNiS9c9q6LkkC3YyXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GLVI7wRU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GLVI7wRU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744314592;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E9gfmtvgrc9SdQU1wgu0f5LCSYawbWF8GXbX0yV9Dfs=;
	b=GLVI7wRUGQkxPSngXhqbdRZGXrsvnioGjVm71zJCevKnUW+ykr5S7PlaX7vn98IWf/Ywn2
	FfAbdPDIt+EAI0EWoS3R5ftbAOqryw3IstQeUR2agv5zU5uRzYwDvWq/2o6YU9KvN5Plai
	WSup1BaqnP9jbJjsQjpV2bSqGCSW5ME=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-622-Mt1H50JKPfaiyGJp10mQ4g-1; Thu,
 10 Apr 2025 15:49:49 -0400
X-MC-Unique: Mt1H50JKPfaiyGJp10mQ4g-1
X-Mimecast-MFC-AGG-ID: Mt1H50JKPfaiyGJp10mQ4g_1744314587
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 393B3180AF56;
	Thu, 10 Apr 2025 19:49:47 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 05FB019560AD;
	Thu, 10 Apr 2025 19:49:45 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 53AJni0F009357
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 10 Apr 2025 15:49:44 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 53AJniVR009356;
	Thu, 10 Apr 2025 15:49:44 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@lists.linux.dev, Damien Le Moal <dlemoal@kernel.org>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH v4 4/6] dm: fix dm_blk_report_zones
Date: Thu, 10 Apr 2025 15:49:41 -0400
Message-ID: <20250410194943.9326-5-bmarzins@redhat.com>
In-Reply-To: <20250410194943.9326-1-bmarzins@redhat.com>
References: <20250410194943.9326-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: GGGtmY0k7fq238fdashokBzyb1jRaQ_-FBzhMKPy85M_1744314587
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

Solve this by tracking the process that sets md->zone_revalidate_map in
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

