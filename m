Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45BDA1494CE
	for <dm-devel@lists.linux.dev>; Tue, 22 Oct 2024 07:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729581259; cv=none; b=gqJ6lgFVrPl04HoIC/yMv/Iwn3R6ptXLivvuN4ejTuD5BFKVUrc8MbgLDtlWwXOWrKhsZ2sJ+M6R11ANEa+NpnbVca/S+S8vjiHxnxjnUzQHx+liO7w4sJz08Y0YwV4T1Ytp2ivlb+pd2sj8Q4Lm9fjWclHzwAJMMGFJBGr2vV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729581259; c=relaxed/simple;
	bh=Q8ENeAkz48Y3VTR3Dq4JyHQdC/MhcnnpEPGIlvpUPdo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=azwEkC8b776rfSt6kmHd5WyAdJoxUwDDteBllgn/cY7JO/OSaYdPsH7SW2E29g1E7p7S/y3w2cmh8zZhi+GRDe7+OZtYtQmSXcF6vQt9qwJo/3+oabTmztVap6GhldF2lnpcTrf2HFir/LHvJdj0a/L2PWxqC2Q1lwM/0iXc8GI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MfUzMQzi; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MfUzMQzi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729581256;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=vyrm88n/l7VkCAM9KVpNUNAT+MCV4oTA4h4H35isFR4=;
	b=MfUzMQzizLrlhWpg0jum1N8MyjQEFON/TgiU7iBYoayCrhJ4CmUpbYvfYm4s/BM0ZhXkzx
	HEyYCRdA9j675u9HbbI+t+nyBo9+vUArvMcsZnXPqekCwEvM2WVxR5RcFlzw5YpszGRJLx
	VLQyIRNI9+tM40vkSXGwsafEyouIhEE=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-439-40kV8SuRNnuJM90TMW7E0A-1; Tue,
 22 Oct 2024 03:14:12 -0400
X-MC-Unique: 40kV8SuRNnuJM90TMW7E0A-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 191FD19560A2;
	Tue, 22 Oct 2024 07:14:12 +0000 (UTC)
Received: from thinkpad.redhat.com (unknown [10.67.24.92])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AA69C1955F39;
	Tue, 22 Oct 2024 07:14:08 +0000 (UTC)
From: Ming-Hung Tsai <mtsai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: mpatocka@redhat.com,
	thornber@redhat.com,
	heinzm@redhat.com,
	snitzer@kernel.org,
	Ming-Hung Tsai <mtsai@redhat.com>
Subject: [PATCH 5/5] dm cache: fix potential out-of-bounds access on the first resume
Date: Tue, 22 Oct 2024 15:13:54 +0800
Message-ID: <20241022071354.778749-1-mtsai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Out-of-bounds access occurs if the fast device is expanded unexpectedly
before the first-time resume of the cache table. This happens because
expanding the fast device requires reloading the cache table for
cache_create to allocate new in-core data structures that fit the new
size, and the check in cache_preresume is not performed during the
first resume, leading to the issue.

Reproduce steps:

1. prepare component devices:

dmsetup create cmeta --table "0 8192 linear /dev/sdc 0"
dmsetup create cdata --table "0 65536 linear /dev/sdc 8192"
dmsetup create corig --table "0 524288 linear /dev/sdc 262144"
dd if=/dev/zero of=/dev/mapper/cmeta bs=4k count=1 oflag=direct

2. load a cache table of 512 cache blocks, and deliberately expand the
   fast device before resuming the cache, making the in-core data
   structures inadequate.

dmsetup create cache --notable
dmsetup reload cache --table "0 524288 cache /dev/mapper/cmeta \
/dev/mapper/cdata /dev/mapper/corig 128 2 metadata2 writethrough smq 0"
dmsetup reload cdata --table "0 131072 linear /dev/sdc 8192"
dmsetup resume cdata
dmsetup resume cache

3. suspend the cache to write out the in-core dirty bitset and hint
   array, leading to out-of-bounds access to the dirty bitset at offset
   0x40:

dmsetup suspend cache

KASAN reports:

  BUG: KASAN: vmalloc-out-of-bounds in is_dirty_callback+0x2b/0x80
  Read of size 8 at addr ffffc90000085040 by task dmsetup/90

  (...snip...)
  The buggy address belongs to the virtual mapping at
   [ffffc90000085000, ffffc90000087000) created by:
   cache_ctr+0x176a/0x35f0

  (...snip...)
  Memory state around the buggy address:
   ffffc90000084f00: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
   ffffc90000084f80: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
  >ffffc90000085000: 00 00 00 00 00 00 00 00 f8 f8 f8 f8 f8 f8 f8 f8
                                             ^
   ffffc90000085080: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
   ffffc90000085100: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8

Fix by checking the size change on the first resume.

Signed-off-by: Ming-Hung Tsai <mtsai@redhat.com>
Fixes: f494a9c6b1b6 ("dm cache: cache shrinking support")
---
 drivers/md/dm-cache-target.c | 37 ++++++++++++++++--------------------
 1 file changed, 16 insertions(+), 21 deletions(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index fa8ef2c32af8..40709310e327 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -2901,24 +2901,24 @@ static dm_cblock_t get_cache_dev_size(struct cache *cache)
 static bool can_resize(struct cache *cache, dm_cblock_t new_size)
 {
 	if (from_cblock(new_size) > from_cblock(cache->cache_size)) {
-		if (cache->sized) {
-			DMERR("%s: unable to extend cache due to missing cache table reload",
-			      cache_device_name(cache));
-			return false;
-		}
+		DMERR("%s: unable to extend cache due to missing cache table reload",
+		      cache_device_name(cache));
+		return false;
 	}
 
 	/*
 	 * We can't drop a dirty block when shrinking the cache.
 	 */
-	new_size = to_cblock(find_next_bit(cache->dirty_bitset,
-					   from_cblock(cache->cache_size),
-					   from_cblock(new_size)));
-	if (new_size != cache->cache_size) {
-		DMERR("%s: unable to shrink cache; cache block %llu is dirty",
-		      cache_device_name(cache),
-		      (unsigned long long) from_cblock(new_size));
-		return false;
+	if (cache->loaded_mappings) {
+		new_size = to_cblock(find_next_bit(cache->dirty_bitset,
+						   from_cblock(cache->cache_size),
+						   from_cblock(new_size)));
+		if (new_size != cache->cache_size) {
+			DMERR("%s: unable to shrink cache; cache block %llu is dirty",
+			      cache_device_name(cache),
+			      (unsigned long long) from_cblock(new_size));
+			return false;
+		}
 	}
 
 	return true;
@@ -2949,20 +2949,15 @@ static int cache_preresume(struct dm_target *ti)
 	/*
 	 * Check to see if the cache has resized.
 	 */
-	if (!cache->sized) {
-		r = resize_cache_dev(cache, csize);
-		if (r)
-			return r;
-
-		cache->sized = true;
-
-	} else if (csize != cache->cache_size) {
+	if (!cache->sized || csize != cache->cache_size) {
 		if (!can_resize(cache, csize))
 			return -EINVAL;
 
 		r = resize_cache_dev(cache, csize);
 		if (r)
 			return r;
+
+		cache->sized = true;
 	}
 
 	if (!cache->loaded_mappings) {
-- 
2.47.0

