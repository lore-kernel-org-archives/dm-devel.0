Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C13947A66
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 03:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709265190; cv=none; b=iRzQkhoLt9sPWoGokhm3W18f+LhtaW2Fc5QuWOF0Am1DYVZwglf8vGsGqLT/ZMekPnymiY4LJzA1pLTFaDGeiDtAjTzzEFUjZYdBpcSVQOWxiBJWlilPs/TShStv67i8gdtI3+a3YB0h6q3M+8tJIeDneO5WcI32Fx3ka3xc+1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709265190; c=relaxed/simple;
	bh=pGEyrAtMHFfP+cCqGHnKQb3ZfJoRtvi6HnyUhPcpL9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CJ45JJKeSt8dNpTOc359BlCkp3lAdAlPpPIQsYyxYfDoLP64h9N2yMY/TpcYmLpPI0yqmLwKLlXUwYsBh0F3O44RhWTLd3oPb23jWa1CTmJB/9tlNu3qhI90b5InMoRGqHkuoJBBsxFfg5OTSmFHckfPXBDq4HIZkBzPxFRCq7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Mis3dyA+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Mis3dyA+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709265187;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZzjZHJha2yTLcPas/bMVcnd8wYcJ2pYzdL06V00ifDQ=;
	b=Mis3dyA+4/IWgNFx5f3zPEMB+Vt0BzyTFm6czP8eNP9UORxov85jb8dGzF628LAa01Q6Ww
	U5nFS/V+j5xGLdl+lMYpVEySFk+gb5YfEz0h0bjDeKqrWBlh7326wn99UDDOavPp3j+AmA
	q/2zmm8Vm4T2fyqOyFMVlaTWMeTpTME=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-518-7AnrN_TkNeSrjnc9LYtcTQ-1; Thu, 29 Feb 2024 22:53:05 -0500
X-MC-Unique: 7AnrN_TkNeSrjnc9LYtcTQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5DB3510201FD;
	Fri,  1 Mar 2024 03:53:05 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5886F492BC7;
	Fri,  1 Mar 2024 03:53:05 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 56E519EB29; Thu, 29 Feb 2024 22:53:05 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 04/13] dm vdo indexer sparse-cache: cleanup threads_barrier code
Date: Thu, 29 Feb 2024 22:52:56 -0500
Message-ID: <814f277ae6e7f9eae76c67b31e8e5f191b977472.1709264538.git.msakai@redhat.com>
In-Reply-To: <cover.1709264538.git.msakai@redhat.com>
References: <cover.1709264538.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Mike Snitzer <snitzer@kernel.org>

Rename 'barrier' to 'threads_barrier', remove useless
uds_destroy_barrier(), return void from remaining methods and
clean up uds_make_sparse_cache() accordingly.

Also remove uds_ prefix from the 2 remaining threads_barrier
functions.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/sparse-cache.c | 60 ++++++++++----------------------
 1 file changed, 19 insertions(+), 41 deletions(-)

diff --git a/drivers/md/dm-vdo/sparse-cache.c b/drivers/md/dm-vdo/sparse-cache.c
index dcd5ef25b360..216c8d6256a9 100644
--- a/drivers/md/dm-vdo/sparse-cache.c
+++ b/drivers/md/dm-vdo/sparse-cache.c
@@ -141,7 +141,7 @@ struct search_list {
 	struct cached_chapter_index *entries[];
 };
 
-struct barrier {
+struct threads_barrier {
 	/* Lock for this barrier object */
 	struct semaphore lock;
 	/* Semaphore for threads waiting at this barrier */
@@ -161,25 +161,19 @@ struct sparse_cache {
 	struct search_list *search_lists[MAX_ZONES];
 	struct cached_chapter_index **scratch_entries;
 
-	struct barrier begin_update_barrier;
-	struct barrier end_update_barrier;
+	struct threads_barrier begin_update_barrier;
+	struct threads_barrier end_update_barrier;
 
 	struct cached_chapter_index chapters[];
 };
 
-static int uds_initialize_barrier(struct barrier *barrier, unsigned int thread_count)
+static void initialize_threads_barrier(struct threads_barrier *barrier,
+				       unsigned int thread_count)
 {
 	sema_init(&barrier->lock, 1);
 	barrier->arrived = 0;
 	barrier->thread_count = thread_count;
 	sema_init(&barrier->wait, 0);
-
-	return UDS_SUCCESS;
-}
-
-static int uds_destroy_barrier(struct barrier *barrier)
-{
-	return UDS_SUCCESS;
 }
 
 static inline void __down(struct semaphore *semaphore)
@@ -203,7 +197,7 @@ static inline void __down(struct semaphore *semaphore)
 	}
 }
 
-static int uds_enter_barrier(struct barrier *barrier)
+static void enter_threads_barrier(struct threads_barrier *barrier)
 {
 	__down(&barrier->lock);
 	if (++barrier->arrived == barrier->thread_count) {
@@ -219,8 +213,6 @@ static int uds_enter_barrier(struct barrier *barrier)
 		up(&barrier->lock);
 		__down(&barrier->wait);
 	}
-
-	return UDS_SUCCESS;
 }
 
 static int __must_check initialize_cached_chapter_index(struct cached_chapter_index *chapter,
@@ -287,44 +279,32 @@ int uds_make_sparse_cache(const struct index_geometry *geometry, unsigned int ca
 	 */
 	cache->skip_threshold = (SKIP_SEARCH_THRESHOLD / zone_count);
 
-	result = uds_initialize_barrier(&cache->begin_update_barrier, zone_count);
-	if (result != UDS_SUCCESS) {
-		uds_free_sparse_cache(cache);
-		return result;
-	}
-
-	result = uds_initialize_barrier(&cache->end_update_barrier, zone_count);
-	if (result != UDS_SUCCESS) {
-		uds_free_sparse_cache(cache);
-		return result;
-	}
+	initialize_threads_barrier(&cache->begin_update_barrier, zone_count);
+	initialize_threads_barrier(&cache->end_update_barrier, zone_count);
 
 	for (i = 0; i < capacity; i++) {
 		result = initialize_cached_chapter_index(&cache->chapters[i], geometry);
-		if (result != UDS_SUCCESS) {
-			uds_free_sparse_cache(cache);
-			return result;
-		}
+		if (result != UDS_SUCCESS)
+			goto out;
 	}
 
 	for (i = 0; i < zone_count; i++) {
 		result = make_search_list(cache, &cache->search_lists[i]);
-		if (result != UDS_SUCCESS) {
-			uds_free_sparse_cache(cache);
-			return result;
-		}
+		if (result != UDS_SUCCESS)
+			goto out;
 	}
 
 	/* purge_search_list() needs some temporary lists for sorting. */
 	result = uds_allocate(capacity * 2, struct cached_chapter_index *,
 			      "scratch entries", &cache->scratch_entries);
-	if (result != UDS_SUCCESS) {
-		uds_free_sparse_cache(cache);
-		return result;
-	}
+	if (result != UDS_SUCCESS)
+		goto out;
 
 	*cache_ptr = cache;
 	return UDS_SUCCESS;
+out:
+	uds_free_sparse_cache(cache);
+	return result;
 }
 
 static inline void set_skip_search(struct cached_chapter_index *chapter,
@@ -381,8 +361,6 @@ void uds_free_sparse_cache(struct sparse_cache *cache)
 		uds_free(cache->chapters[i].page_buffers);
 	}
 
-	uds_destroy_barrier(&cache->begin_update_barrier);
-	uds_destroy_barrier(&cache->end_update_barrier);
 	uds_free(cache);
 }
 
@@ -525,7 +503,7 @@ int uds_update_sparse_cache(struct index_zone *zone, u64 virtual_chapter)
 	 * Wait for every zone thread to reach its corresponding barrier request and invoke this
 	 * function before starting to modify the cache.
 	 */
-	uds_enter_barrier(&cache->begin_update_barrier);
+	enter_threads_barrier(&cache->begin_update_barrier);
 
 	/*
 	 * This is the start of the critical section: the zone zero thread is captain, effectively
@@ -553,7 +531,7 @@ int uds_update_sparse_cache(struct index_zone *zone, u64 virtual_chapter)
 	/*
 	 * This is the end of the critical section. All cache invariants must have been restored.
 	 */
-	uds_enter_barrier(&cache->end_update_barrier);
+	enter_threads_barrier(&cache->end_update_barrier);
 	return result;
 }
 
-- 
2.42.0

