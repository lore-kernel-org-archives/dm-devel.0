Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61A3450255
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 04:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709267938; cv=none; b=SAQVq6ddqhMUg8HHaBXacxEwENNngFIXhaAwQbom8B8xCKOsqhRKZHCT08qek+SE596St8envCa/r/TocnWmWyv9KEek3NUlNJtQt2vFimP/BOEkVqIciVzhm9znWwTPmJMvciLYF+yT6iLce1/ZHT/D6Mc0tOQ3+jI4iwwkpNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709267938; c=relaxed/simple;
	bh=U3/cl9ex941e6L2+IyoKR5dR0xUNIuTBJI3TYMWiCfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CDFPDEMsImF9xr3iULscoHKMDAw7FqbTd92ztPTWQoSy3oKzrB2RobqBAY3NkhwZM0DoyH18DBkchHijkUcmvdMIqwajHXIJjJOuDeXEoFxoGSet+V2HbURwNDx7vb8JGWzCOHO1IvgPNPXiJgLPLrFwrZZ0LbA8XRVKVM8H+KU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h6jYWDyj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h6jYWDyj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709267935;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TtawbkqbMzMMJzbXYi1bvF0bxK4bDQnFMdwaBLQLV3Q=;
	b=h6jYWDyj4Js60wZ2wbzrVbAI79a7JWt0a9KA21d4zGbUpZxYNBhApf56VoD9RARQMPEJF2
	NuKlQZ5IhbHqk4BlaFOuljJ58k9wIB1xvl2vNAayecXqFFALX9XS5irAKgDilH7nbm2REg
	NtxtnQI2k44/jPIfygYGz5frArOfN+s=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-68-mUM0VrMXOnmoGA4YsIO4RA-1; Thu, 29 Feb 2024 23:38:54 -0500
X-MC-Unique: mUM0VrMXOnmoGA4YsIO4RA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C5B65832BD0;
	Fri,  1 Mar 2024 04:38:53 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C04032166B5D;
	Fri,  1 Mar 2024 04:38:53 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id BDA02A1622; Thu, 29 Feb 2024 23:38:53 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 04/10] dm vdo int-map: return VDO_SUCCESS on success
Date: Thu, 29 Feb 2024 23:38:47 -0500
Message-ID: <9b65d46a3f8d833db1ce7a77e69598c238bee95d.1709267597.git.msakai@redhat.com>
In-Reply-To: <cover.1709267597.git.msakai@redhat.com>
References: <cover.1709267597.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Mike Snitzer <snitzer@kernel.org>

Update all callers to check for VDO_SUCCESS (most already did).
Also fix whitespace for update_mapping() parameters.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/block-map.c    |  4 ++--
 drivers/md/dm-vdo/int-map.c      | 20 ++++++++------------
 drivers/md/dm-vdo/io-submitter.c |  4 ++--
 3 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/drivers/md/dm-vdo/block-map.c b/drivers/md/dm-vdo/block-map.c
index c4719fb30f86..320e76527e2b 100644
--- a/drivers/md/dm-vdo/block-map.c
+++ b/drivers/md/dm-vdo/block-map.c
@@ -231,7 +231,7 @@ static int __must_check allocate_cache_components(struct vdo_page_cache *cache)
 		return result;
 
 	result = vdo_int_map_create(cache->page_count, &cache->page_map);
-	if (result != UDS_SUCCESS)
+	if (result != VDO_SUCCESS)
 		return result;
 
 	return initialize_info(cache);
@@ -390,7 +390,7 @@ static int __must_check set_info_pbn(struct page_info *info, physical_block_numb
 
 	if (pbn != NO_PAGE) {
 		result = vdo_int_map_put(cache->page_map, pbn, info, true, NULL);
-		if (result != UDS_SUCCESS)
+		if (result != VDO_SUCCESS)
 			return result;
 	}
 	return VDO_SUCCESS;
diff --git a/drivers/md/dm-vdo/int-map.c b/drivers/md/dm-vdo/int-map.c
index 9849d12f2a36..a909a11204c1 100644
--- a/drivers/md/dm-vdo/int-map.c
+++ b/drivers/md/dm-vdo/int-map.c
@@ -397,7 +397,7 @@ static int resize_buckets(struct int_map *map)
 			continue;
 
 		result = vdo_int_map_put(map, entry->key, entry->value, true, NULL);
-		if (result != UDS_SUCCESS) {
+		if (result != VDO_SUCCESS) {
 			/* Destroy the new partial map and restore the map from the stack. */
 			vdo_free(vdo_forget(map->buckets));
 			*map = old_map;
@@ -525,12 +525,8 @@ static struct bucket *move_empty_bucket(struct int_map *map __always_unused,
  *
  * Return: true if the map contains a mapping for the key, false if it does not.
  */
-static bool update_mapping(struct int_map *map,
-			   struct bucket *neighborhood,
-			   u64 key,
-			   void *new_value,
-			   bool update,
-			   void **old_value_ptr)
+static bool update_mapping(struct int_map *map, struct bucket *neighborhood,
+			   u64 key, void *new_value, bool update, void **old_value_ptr)
 {
 	struct bucket *bucket = search_hop_list(map, neighborhood, key, NULL);
 
@@ -609,15 +605,15 @@ static struct bucket *find_or_make_vacancy(struct int_map *map,
  * update is true. In either case the old value is returned. If the map does not already contain a
  * value for the specified key, the new value is added regardless of the value of update.
  *
- * Return: UDS_SUCCESS or an error code.
+ * Return: VDO_SUCCESS or an error code.
  */
 int vdo_int_map_put(struct int_map *map, u64 key, void *new_value, bool update,
 		    void **old_value_ptr)
 {
 	struct bucket *neighborhood, *bucket;
 
-	if (new_value == NULL)
-		return UDS_INVALID_ARGUMENT;
+	if (unlikely(new_value == NULL))
+		return -EINVAL;
 
 	/*
 	 * Select the bucket at the start of the neighborhood that must contain any entry for the
@@ -630,7 +626,7 @@ int vdo_int_map_put(struct int_map *map, u64 key, void *new_value, bool update,
 	 * optionally update it, returning the old value.
 	 */
 	if (update_mapping(map, neighborhood, key, new_value, update, old_value_ptr))
-		return UDS_SUCCESS;
+		return VDO_SUCCESS;
 
 	/*
 	 * Find an empty bucket in the desired neighborhood for the new entry or re-arrange entries
@@ -666,7 +662,7 @@ int vdo_int_map_put(struct int_map *map, u64 key, void *new_value, bool update,
 	/* There was no existing entry, so there was no old value to be returned. */
 	if (old_value_ptr != NULL)
 		*old_value_ptr = NULL;
-	return UDS_SUCCESS;
+	return VDO_SUCCESS;
 }
 
 /**
diff --git a/drivers/md/dm-vdo/io-submitter.c b/drivers/md/dm-vdo/io-submitter.c
index b0f1ba810cd0..e82b4a8c6fc4 100644
--- a/drivers/md/dm-vdo/io-submitter.c
+++ b/drivers/md/dm-vdo/io-submitter.c
@@ -300,7 +300,7 @@ static bool try_bio_map_merge(struct vio *vio)
 	mutex_unlock(&bio_queue_data->lock);
 
 	/* We don't care about failure of int_map_put in this case. */
-	ASSERT_LOG_ONLY(result == UDS_SUCCESS, "bio map insertion succeeds");
+	ASSERT_LOG_ONLY(result == VDO_SUCCESS, "bio map insertion succeeds");
 	return merged;
 }
 
@@ -403,7 +403,7 @@ int vdo_make_io_submitter(unsigned int thread_count, unsigned int rotation_inter
 		 */
 		result = vdo_int_map_create(max_requests_active * 2,
 					    &bio_queue_data->map);
-		if (result != 0) {
+		if (result != VDO_SUCCESS) {
 			/*
 			 * Clean up the partially initialized bio-queue entirely and indicate that
 			 * initialization failed.
-- 
2.42.0

