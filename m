Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89FAB339843
	for <dm-devel@lists.linux.dev>; Mon,  9 Feb 2026 07:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770623737; cv=none; b=u9/T+Tu2ak2GmpB54uuUAegVYfV4skxOmIxBySR9+w91CiWGMRPU3xOrOxV1wymTw5JPwguSFAxP3vaBORC9bcKJ1I6dbFm0tHo5Bb5WQBGx0M/3IKE0HquN/lGSUMGQcPd3CGkV18O7kgxXhmPAp+0GtrgvA3DVRY5lvtYnLrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770623737; c=relaxed/simple;
	bh=whn0wKrOKFrazhq7TXrhULFPoMjX/c+s/wGzNlGVg/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=Ov39j90u1y6R16NP86PyjyELRr56Nld0DnwLqzvHDI7W8IciA654W1ALJ10s8H658D5aq8I/0KC3FwGlehlRYGtPcaGOjTENDIp7jLrZHwTR0N5i2JnCodWBoDaPcMxaqjFuL/r6Rjg0yGMfk0fgv6hinaa/jBTHdgJbXx9ge4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=B1qkz/84; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B1qkz/84"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770623736;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+Pe3QqO1GHwaXh873WQwq0dfx09s1CxMgrAFOJb3ajI=;
	b=B1qkz/84VEiOFm4d3/GpeFwhXNbnU+E4q0qLOtQkZ3kMIACGU1RdfDJJcnZqJnaNghpKTY
	/W3rxghEYIbvdRPhWImuPwFNPZTzIrv1doXWkzdr1shJ4aI7NqnLsEhDnatu1LoKsUgnmT
	qgWDi5zCf0p/BI8JVdsyH35BsZgF3Eo=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-684-FbZURrHHP3CEKWj1jMwaeg-1; Mon,
 09 Feb 2026 02:55:35 -0500
X-MC-Unique: FbZURrHHP3CEKWj1jMwaeg-1
X-Mimecast-MFC-AGG-ID: FbZURrHHP3CEKWj1jMwaeg_1770623734
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 869F01956050;
	Mon,  9 Feb 2026 07:55:34 +0000 (UTC)
Received: from thinkpad.redhat.com (unknown [10.64.240.53])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1F2D330001A8;
	Mon,  9 Feb 2026 07:55:30 +0000 (UTC)
From: Ming-Hung Tsai <mtsai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	Heinz Mauelshagen <heinzm@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Ming-Hung Tsai <mtsai@redhat.com>
Subject: [PATCH 6/7] dm cache: fix dirty mapping checking in passthrough mode switching
Date: Mon,  9 Feb 2026 15:54:10 +0800
Message-ID: <20260209075411.860418-7-mtsai@redhat.com>
In-Reply-To: <20260209075411.860418-1-mtsai@redhat.com>
References: <20260209075411.860418-1-mtsai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: fNcWz3ExFCTfZuu7RThbAaofYjYeNi-H-WwwhPf0CDM_1770623734
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

As mentioned in commit 9b1cc9f251af ("dm cache: share cache-metadata
object across inactive and active DM tables"), dm-cache assumed table
reload occurs after suspension, while LVM's table preload breaks this
assumption. The dirty mapping check for passthrough mode was designed
around this assumption and is performed during table creation, causing
the check to fail with preload while metadata updates are ongoing. This
risks loading dirty mappings into passthrough mode, resulting in data
loss.

Reproduce steps:

1. Create a writeback cache with zero migration_threshold to produce
   dirty mappings

dmsetup create cmeta --table "0 8192 linear /dev/sdc 0"
dmsetup create cdata --table "0 131072 linear /dev/sdc 8192"
dmsetup create corig --table "0 262144 linear /dev/sdc 262144"
dd if=/dev/zero of=/dev/mapper/cmeta bs=4k count=1 oflag=direct
dmsetup create cache --table "0 262144 cache /dev/mapper/cmeta \
/dev/mapper/cdata /dev/mapper/corig 128 2 metadata2 writeback smq \
2 migration_threshold 0"

2. Preload a table in passthrough mode

dmsetup reload cache --table "0 262144 cache /dev/mapper/cmeta \
/dev/mapper/cdata /dev/mapper/corig 128 2 metadata2 passthrough smq 0"

3. Write to the first cache block to make it dirty

fio --filename=/dev/mapper/cache --name=populate --rw=write --bs=4k \
--direct=1 --size=64k

4. Resume the inactive table. Now it's possible to load the dirty block
   into passthrough mode.

dmsetup resume cache

Fix by moving the checks to the preresume phase to support table
preloading. Also remove the unused function dm_cache_metadata_all_clean.

Fixes: 2ee57d587357 ("dm cache: add passthrough mode")
Signed-off-by: Ming-Hung Tsai <mtsai@redhat.com>
---
 drivers/md/dm-cache-metadata.c | 11 -----------
 drivers/md/dm-cache-metadata.h |  5 -----
 drivers/md/dm-cache-target.c   | 25 ++++++++-----------------
 3 files changed, 8 insertions(+), 33 deletions(-)

diff --git a/drivers/md/dm-cache-metadata.c b/drivers/md/dm-cache-metadata.c
index a9a1ab284076..cf491c8508a4 100644
--- a/drivers/md/dm-cache-metadata.c
+++ b/drivers/md/dm-cache-metadata.c
@@ -1714,17 +1714,6 @@ int dm_cache_write_hints(struct dm_cache_metadata *cmd, struct dm_cache_policy *
 	return r;
 }
 
-int dm_cache_metadata_all_clean(struct dm_cache_metadata *cmd, bool *result)
-{
-	int r;
-
-	READ_LOCK(cmd);
-	r = blocks_are_unmapped_or_clean(cmd, 0, cmd->cache_blocks, result);
-	READ_UNLOCK(cmd);
-
-	return r;
-}
-
 void dm_cache_metadata_set_read_only(struct dm_cache_metadata *cmd)
 {
 	WRITE_LOCK_VOID(cmd);
diff --git a/drivers/md/dm-cache-metadata.h b/drivers/md/dm-cache-metadata.h
index 5f77890207fe..2f107e7c67d0 100644
--- a/drivers/md/dm-cache-metadata.h
+++ b/drivers/md/dm-cache-metadata.h
@@ -135,11 +135,6 @@ int dm_cache_get_metadata_dev_size(struct dm_cache_metadata *cmd,
  */
 int dm_cache_write_hints(struct dm_cache_metadata *cmd, struct dm_cache_policy *p);
 
-/*
- * Query method.  Are all the blocks in the cache clean?
- */
-int dm_cache_metadata_all_clean(struct dm_cache_metadata *cmd, bool *result);
-
 int dm_cache_metadata_needs_check(struct dm_cache_metadata *cmd, bool *result);
 int dm_cache_metadata_set_needs_check(struct dm_cache_metadata *cmd);
 void dm_cache_metadata_set_read_only(struct dm_cache_metadata *cmd);
diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index eb9d738704d0..17f37db57b5e 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -2506,23 +2506,8 @@ static int cache_create(struct cache_args *ca, struct cache **result)
 		goto bad;
 	}
 
-	if (passthrough_mode(cache)) {
-		bool all_clean;
-
-		r = dm_cache_metadata_all_clean(cache->cmd, &all_clean);
-		if (r) {
-			*error = "dm_cache_metadata_all_clean() failed";
-			goto bad;
-		}
-
-		if (!all_clean) {
-			*error = "Cannot enter passthrough mode unless all blocks are clean";
-			r = -EINVAL;
-			goto bad;
-		}
-
+	if (passthrough_mode(cache))
 		policy_allow_migrations(cache->policy, false);
-	}
 
 	spin_lock_init(&cache->lock);
 	bio_list_init(&cache->deferred_bios);
@@ -2848,6 +2833,12 @@ static int load_mapping(void *context, dm_oblock_t oblock, dm_cblock_t cblock,
 	struct cache *cache = context;
 
 	if (dirty) {
+		if (passthrough_mode(cache)) {
+			DMERR("%s: cannot enter passthrough mode unless all blocks are clean",
+			      cache_device_name(cache));
+			return -EBUSY;
+		}
+
 		set_bit(from_cblock(cblock), cache->dirty_bitset);
 		atomic_inc(&cache->nr_dirty);
 	} else
@@ -3081,7 +3072,7 @@ static int cache_preresume(struct dm_target *ti)
 					   load_filtered_mapping, cache);
 		if (r) {
 			DMERR("%s: could not load cache mappings", cache_device_name(cache));
-			if (r != -EFBIG)
+			if (r != -EFBIG && r != -EBUSY)
 				metadata_operation_failed(cache, "dm_cache_load_mappings", r);
 			return r;
 		}
-- 
2.49.0

