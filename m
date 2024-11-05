Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07C3117BA6
	for <dm-devel@lists.linux.dev>; Tue,  5 Nov 2024 00:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730766315; cv=none; b=kOBOe5ffNm+VGHmjQQ2h7M0fayZtNKDE0u92WA7vDyfv/U7uSuJghSel10xlAxb57xm6fkl0fJG2k8lD/RtLx7QZx3uAhsa36QTOIvVIlvOtMufYI6V8nmVsam9C7KXeMSjQmLkVGZRloJcocAaRHtx0pDP9WURhkl6cVqnzm6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730766315; c=relaxed/simple;
	bh=OuAni01Vc18azSlgGrtDR61CsJiOeBV45CGnCy65GWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IuL94auAvoKTSUYPDZUKLKeQi0ioIObbTBtiklFeuLWiVlqjJz95eJfbuKbM/xX/z+RXnjaYhb6MEVcr9SyqMo/GsJ0ZB53nLv1j+xIAVcZpncK4pMrYkDv+oKyBX6Ftl1djjbZR/0aeHJXYTXyokQyLIIkoMwEAhokBhymSJTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CigLpwhD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CigLpwhD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730766312;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8QCUJYqUMM3pGjZwzNeQGbmva01eGFxsq5g9tff87GY=;
	b=CigLpwhDEYz9wa7gObahoNH6nCEwnikwoHm/D8WNdBy/JDUCvThHaOLETIBs/LJMlds4V7
	BMfplrIYde8ys6vf/gUFAHbVLd7DpbL9g2OwMC3cU4BKErx5tV75rCkTpC37727DbPtXl6
	NHrlcipuVpbszwROKAII6PmofCZ6VKU=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-643-autOaeFON_mLHEK0YjqEEA-1; Mon,
 04 Nov 2024 19:25:11 -0500
X-MC-Unique: autOaeFON_mLHEK0YjqEEA-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0CDB619560B0
	for <dm-devel@lists.linux.dev>; Tue,  5 Nov 2024 00:25:11 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D4FA81955F43;
	Tue,  5 Nov 2024 00:25:10 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 4BEBC59E6A; Mon,  4 Nov 2024 19:25:10 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 1/2] dm vdo int-map: remove unused parameters
Date: Mon,  4 Nov 2024 19:25:09 -0500
Message-ID: <7b0f986d70243815ea3fe8242f1dde0991b8c039.1730766085.git.msakai@redhat.com>
In-Reply-To: <cover.1730766085.git.msakai@redhat.com>
References: <cover.1730766085.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Remove __always_unused parameters from static functions.
Also fix minor formatting issues.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202407141607.M3E2XQ0Z-lkp@intel.com/
Closes: https://lore.kernel.org/oe-kbuild-all/202409101018.B75pIBKR-lkp@intel.com/
Closes: https://lore.kernel.org/oe-kbuild-all/202410011107.U2xbVLRA-lkp@intel.com/
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/int-map.c | 28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

diff --git a/drivers/md/dm-vdo/int-map.c b/drivers/md/dm-vdo/int-map.c
index f6fe58e437b3..aeb690415dbd 100644
--- a/drivers/md/dm-vdo/int-map.c
+++ b/drivers/md/dm-vdo/int-map.c
@@ -70,7 +70,7 @@
  * it's crucial to keep the hop fields near the buckets that they use them so they'll tend to share
  * cache lines.
  */
-struct __packed bucket {
+struct bucket {
 	/**
 	 * @first_hop: The biased offset of the first entry in the hop list of the neighborhood
 	 *             that hashes to this bucket.
@@ -82,7 +82,7 @@ struct __packed bucket {
 	u64 key;
 	/** @value: The value stored in this bucket (NULL if empty). */
 	void *value;
-};
+} __packed;
 
 /**
  * struct int_map - The concrete definition of the opaque int_map type.
@@ -310,7 +310,6 @@ static struct bucket *select_bucket(const struct int_map *map, u64 key)
 /**
  * search_hop_list() - Search the hop list associated with given hash bucket for a given search
  *                     key.
- * @map: The map being searched.
  * @bucket: The map bucket to search for the key.
  * @key: The mapping key.
  * @previous_ptr: Output. if not NULL, a pointer in which to store the bucket in the list preceding
@@ -321,9 +320,7 @@ static struct bucket *select_bucket(const struct int_map *map, u64 key)
  *
  * Return: An entry that matches the key, or NULL if not found.
  */
-static struct bucket *search_hop_list(struct int_map *map __always_unused,
-				      struct bucket *bucket,
-				      u64 key,
+static struct bucket *search_hop_list(struct bucket *bucket, u64 key,
 				      struct bucket **previous_ptr)
 {
 	struct bucket *previous = NULL;
@@ -357,7 +354,7 @@ static struct bucket *search_hop_list(struct int_map *map __always_unused,
  */
 void *vdo_int_map_get(struct int_map *map, u64 key)
 {
-	struct bucket *match = search_hop_list(map, select_bucket(map, key), key, NULL);
+	struct bucket *match = search_hop_list(select_bucket(map, key), key, NULL);
 
 	return ((match != NULL) ? match->value : NULL);
 }
@@ -443,7 +440,6 @@ find_empty_bucket(struct int_map *map, struct bucket *bucket, unsigned int max_p
 
 /**
  * move_empty_bucket() - Move an empty bucket closer to the start of the bucket array.
- * @map: The map containing the bucket.
  * @hole: The empty bucket to fill with an entry that precedes it in one of its enclosing
  *        neighborhoods.
  *
@@ -454,8 +450,7 @@ find_empty_bucket(struct int_map *map, struct bucket *bucket, unsigned int max_p
  * Return: The bucket that was vacated by moving its entry to the provided hole, or NULL if no
  *         entry could be moved.
  */
-static struct bucket *move_empty_bucket(struct int_map *map __always_unused,
-					struct bucket *hole)
+static struct bucket *move_empty_bucket(struct bucket *hole)
 {
 	/*
 	 * Examine every neighborhood that the empty bucket is part of, starting with the one in
@@ -516,7 +511,6 @@ static struct bucket *move_empty_bucket(struct int_map *map __always_unused,
 /**
  * update_mapping() - Find and update any existing mapping for a given key, returning the value
  *                    associated with the key in the provided pointer.
- * @map: The int_map to attempt to modify.
  * @neighborhood: The first bucket in the neighborhood that would contain the search key
  * @key: The key with which to associate the new value.
  * @new_value: The value to be associated with the key.
@@ -525,10 +519,10 @@ static struct bucket *move_empty_bucket(struct int_map *map __always_unused,
  *
  * Return: true if the map contains a mapping for the key, false if it does not.
  */
-static bool update_mapping(struct int_map *map, struct bucket *neighborhood,
-			   u64 key, void *new_value, bool update, void **old_value_ptr)
+static bool update_mapping(struct bucket *neighborhood, u64 key, void *new_value,
+			   bool update, void **old_value_ptr)
 {
-	struct bucket *bucket = search_hop_list(map, neighborhood, key, NULL);
+	struct bucket *bucket = search_hop_list(neighborhood, key, NULL);
 
 	if (bucket == NULL) {
 		/* There is no bucket containing the key in the neighborhood. */
@@ -584,7 +578,7 @@ static struct bucket *find_or_make_vacancy(struct int_map *map,
 		 * The nearest empty bucket isn't within the neighborhood that must contain the new
 		 * entry, so try to swap it with bucket that is closer.
 		 */
-		hole = move_empty_bucket(map, hole);
+		hole = move_empty_bucket(hole);
 	}
 
 	return NULL;
@@ -625,7 +619,7 @@ int vdo_int_map_put(struct int_map *map, u64 key, void *new_value, bool update,
 	 * Check whether the neighborhood already contains an entry for the key, in which case we
 	 * optionally update it, returning the old value.
 	 */
-	if (update_mapping(map, neighborhood, key, new_value, update, old_value_ptr))
+	if (update_mapping(neighborhood, key, new_value, update, old_value_ptr))
 		return VDO_SUCCESS;
 
 	/*
@@ -679,7 +673,7 @@ void *vdo_int_map_remove(struct int_map *map, u64 key)
 	/* Select the bucket to search and search it for an existing entry. */
 	struct bucket *bucket = select_bucket(map, key);
 	struct bucket *previous;
-	struct bucket *victim = search_hop_list(map, bucket, key, &previous);
+	struct bucket *victim = search_hop_list(bucket, key, &previous);
 
 	if (victim == NULL) {
 		/* There is no matching entry to remove. */
-- 
2.45.2

