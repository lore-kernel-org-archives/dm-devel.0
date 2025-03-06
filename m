Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69F94207A04
	for <dm-devel@lists.linux.dev>; Thu,  6 Mar 2025 08:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741250544; cv=none; b=hkvgtSQAaaGnon54PN0sUb6z10Nn8kW5R0SUCLwSskb/RunM1WOsTWLGKtI6GrYdNlggV/SXW+Haz0ddzkEyBPc8Qea4NkcDLws7SKnNI0Lvkx9GMA2DdmTrJz3me1M2p3ZNSPKJji8iHlyP4N9/yfdKx5KbkDVsxKLek0yzsO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741250544; c=relaxed/simple;
	bh=3EhPCX7NgpfwYLMNElVPKLIhjoEn2yRkRHRQWNGNEmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=c/crGEG0H5z3WEms8gwZr5MWt3u4IvS7h8CMiH0qVXbfixj1tDCSm63yK2b3+6BRBvwUoORh5Ym6mS8p5gbbrXFbrqg7CBZ7ja6Ysd2e8yY0BW0IS6iHgaCkN7ZeuNzm8SR3cBXbK+NUDW4t27Y9xUfflkZUm3EIPjqxWlITzCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cfkORQ7m; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cfkORQ7m"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741250541;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ktxlcmNvHgX0a+MzF6p+XF29yGsYupBsvEjuDp5OPTs=;
	b=cfkORQ7mpTfTnBp4aa1jgAQol2izLNr9418NRiRuyoQ8qZm4cdd1chpicY69WMrRXiAcip
	vFmZmInxUkMsEEcYoYxVLyN7J5gGH3zeyBrcDT3apoqhIKJEY5l0ADlj0U+f7Ed1r1OSN0
	U3ZPd0snN8xxmCOBgkJesbLy5mrXzpY=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-247-bBgc8UpDOwmPeX_-wBt9UQ-1; Thu,
 06 Mar 2025 03:42:19 -0500
X-MC-Unique: bBgc8UpDOwmPeX_-wBt9UQ-1
X-Mimecast-MFC-AGG-ID: bBgc8UpDOwmPeX_-wBt9UQ_1741250539
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E71AB1955D66;
	Thu,  6 Mar 2025 08:42:18 +0000 (UTC)
Received: from thinkpad.redhat.com (unknown [10.67.24.24])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BB182300019E;
	Thu,  6 Mar 2025 08:42:14 +0000 (UTC)
From: Ming-Hung Tsai <mtsai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	Joe Thornber <thornber@redhat.com>,
	Heinz Mauelshagen <heinzm@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Ming-Hung Tsai <mtsai@redhat.com>
Subject: [PATCH v3 2/2] dm cache: support shrinking the origin device
Date: Thu,  6 Mar 2025 16:41:51 +0800
Message-ID: <20250306084151.371591-3-mtsai@redhat.com>
In-Reply-To: <20250306084151.371591-1-mtsai@redhat.com>
References: <20250306084151.371591-1-mtsai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: On2FEEKjsh_qXhUHmuhu6ORel8hcrV0aBKH28wiTiSQ_1741250539
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

This patch introduces formal support for shrinking the cache origin by
reducing the cache target length via table reloads. Cache blocks mapped
beyond the new target length must be clean and are invalidated during
preresume. If any dirty blocks exist in the area being removed, the
preresume operation fails without setting the NEEDS_CHECK flag in
superblock, and the resume ioctl returns EFBIG. The cache device remains
suspended until a table reload with target length that fits existing
mappings is performed.

Without this patch, reducing the cache target length could result in
io errors (RHBZ: 2134334), out-of-bounds memory access to the discard
bitset, and security concerns regarding data leakage.

Verification steps:

1. create a cache metadata with some cached blocks mapped to the tail
   of the origin device. Here we use cache_restore v1.0 to build a
   metadata with one clean block mapped to the last origin block.

cat <<EOF >> cmeta.xml
<superblock uuid="" block_size="128" nr_cache_blocks="512" \
policy="smq" hint_width="4">
  <mappings>
    <mapping cache_block="0" origin_block="4095" dirty="false"/>
  </mappings>
</superblock>
EOF
dmsetup create cmeta --table "0 8192 linear /dev/sdc 0"
cache_restore -i cmeta.xml -o /dev/mapper/cmeta --metadata-version=2
dmsetup remove cmeta

2. bring up the cache whilst shrinking the cache origin by one block:

dmsetup create cmeta --table "0 8192 linear /dev/sdc 0"
dmsetup create cdata --table "0 65536 linear /dev/sdc 8192"
dmsetup create corig --table "0 524160 linear /dev/sdc 262144"
dmsetup create cache --table "0 524160 cache /dev/mapper/cmeta \
/dev/mapper/cdata /dev/mapper/corig 128 2 metadata2 writethrough smq 0"

3. check the number of cached data blocks via dmsetup status. It is
   expected to be zero.

dmsetup status cache | cut -d ' ' -f 7

In addition to the script above, this patch can be verified using the
"cache/resize" tests in dmtest-python:

./dmtest run --rx cache/resize/shrink_origin --result-set default

Signed-off-by: Ming-Hung Tsai <mtsai@redhat.com>
---
 drivers/md/dm-cache-target.c | 72 ++++++++++++++++++++++++++++++++++--
 1 file changed, 69 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 6cee5eac8b9e..a10d75a562db 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -406,6 +406,12 @@ struct cache {
 	mempool_t migration_pool;
 
 	struct bio_set bs;
+
+	/*
+	 * Cache_size entries. Set bits indicate blocks mapped beyond the
+	 * target length, which are marked for invalidation.
+	 */
+	unsigned long *invalid_bitset;
 };
 
 struct per_bio_data {
@@ -1922,6 +1928,9 @@ static void __destroy(struct cache *cache)
 	if (cache->discard_bitset)
 		free_bitset(cache->discard_bitset);
 
+	if (cache->invalid_bitset)
+		free_bitset(cache->invalid_bitset);
+
 	if (cache->copier)
 		dm_kcopyd_client_destroy(cache->copier);
 
@@ -2510,6 +2519,13 @@ static int cache_create(struct cache_args *ca, struct cache **result)
 	}
 	clear_bitset(cache->discard_bitset, from_dblock(cache->discard_nr_blocks));
 
+	cache->invalid_bitset = alloc_bitset(from_cblock(cache->cache_size));
+	if (!cache->invalid_bitset) {
+		*error = "could not allocate bitset for invalid blocks";
+		goto bad;
+	}
+	clear_bitset(cache->invalid_bitset, from_cblock(cache->cache_size));
+
 	cache->copier = dm_kcopyd_client_create(&dm_kcopyd_throttle);
 	if (IS_ERR(cache->copier)) {
 		*error = "could not create kcopyd client";
@@ -2808,6 +2824,24 @@ static int load_mapping(void *context, dm_oblock_t oblock, dm_cblock_t cblock,
 	return policy_load_mapping(cache->policy, oblock, cblock, dirty, hint, hint_valid);
 }
 
+static int load_filtered_mapping(void *context, dm_oblock_t oblock, dm_cblock_t cblock,
+				 bool dirty, uint32_t hint, bool hint_valid)
+{
+	struct cache *cache = context;
+
+	if (from_oblock(oblock) >= from_oblock(cache->origin_blocks)) {
+		if (dirty) {
+			DMERR("%s: unable to shrink origin; cache block %u is dirty",
+			      cache_device_name(cache), from_cblock(cblock));
+			return -EFBIG;
+		}
+		set_bit(from_cblock(cblock), cache->invalid_bitset);
+		return 0;
+	}
+
+	return load_mapping(context, oblock, cblock, dirty, hint, hint_valid);
+}
+
 /*
  * The discard block size in the on disk metadata is not
  * necessarily the same as we're currently using.  So we have to
@@ -2962,6 +2996,24 @@ static int resize_cache_dev(struct cache *cache, dm_cblock_t new_size)
 	return 0;
 }
 
+static int truncate_oblocks(struct cache *cache)
+{
+	uint32_t nr_blocks = from_cblock(cache->cache_size);
+	uint32_t i;
+	int r;
+
+	for_each_set_bit(i, cache->invalid_bitset, nr_blocks) {
+		r = dm_cache_remove_mapping(cache->cmd, to_cblock(i));
+		if (r) {
+			DMERR_LIMIT("%s: invalidation failed; couldn't update on disk metadata",
+				    cache_device_name(cache));
+			return r;
+		}
+	}
+
+	return 0;
+}
+
 static int cache_preresume(struct dm_target *ti)
 {
 	int r = 0;
@@ -2986,11 +3038,25 @@ static int cache_preresume(struct dm_target *ti)
 	}
 
 	if (!cache->loaded_mappings) {
+		/*
+		 * The fast device could have been resized since the last
+		 * failed preresume attempt.  To be safe we start by a blank
+		 * bitset for cache blocks.
+		 */
+		clear_bitset(cache->invalid_bitset, from_cblock(cache->cache_size));
+
 		r = dm_cache_load_mappings(cache->cmd, cache->policy,
-					   load_mapping, cache);
+					   load_filtered_mapping, cache);
 		if (r) {
 			DMERR("%s: could not load cache mappings", cache_device_name(cache));
-			metadata_operation_failed(cache, "dm_cache_load_mappings", r);
+			if (r != -EFBIG)
+				metadata_operation_failed(cache, "dm_cache_load_mappings", r);
+			return r;
+		}
+
+		r = truncate_oblocks(cache);
+		if (r) {
+			metadata_operation_failed(cache, "dm_cache_remove_mapping", r);
 			return r;
 		}
 
@@ -3450,7 +3516,7 @@ static void cache_io_hints(struct dm_target *ti, struct queue_limits *limits)
 
 static struct target_type cache_target = {
 	.name = "cache",
-	.version = {2, 2, 0},
+	.version = {2, 3, 0},
 	.module = THIS_MODULE,
 	.ctr = cache_ctr,
 	.dtr = cache_dtr,
-- 
2.47.0

