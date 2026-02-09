Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B43B339843
	for <dm-devel@lists.linux.dev>; Mon,  9 Feb 2026 07:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770623719; cv=none; b=NwJycY2Om3Lm/H17CmqnW5hWmu0hZGCW7+fMpnOy1ZoXL30usTiVM1oVkfw40AsNj/p83JzTNOt0RcupHC4dDvv8lt82DW7ZX1jp82Cuk/C7vaKvTBQ+7SY3k38WIKhlukDVdkQkfN7hLG1Hy39L/7sj/usJoP6LRUnX5S693FY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770623719; c=relaxed/simple;
	bh=mmhYb+nvhFu+jmVhSTijtwCKHsCBoMx4yRSEVJWhcHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=OpxkBy/SNs9X9qGics34BeqCRujWf8YParRWQPgyjknwWN4Jnhq1h1947AO92KCBF4pMc6x5LMrZ5KV0YSfIb+W29yfgpKOznvUWVc8R/tpinZijujbGmobLKSxtKEMkbK9EBAOtK2zaN1le4IenlWlBZLsunjq4/HtBJWuHANQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BGgfNTMS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BGgfNTMS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770623718;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BsjI4GOhDp2OaPmxgLTx6IGV+1Okg8HKDyDDx2grgog=;
	b=BGgfNTMSA+k9h6BFTRtMot04uCUIe1xl1ACnjSoUUHew2JA6TxlOEidkEE4y1zUJ27ryAn
	ywSj9+0WuwQ5I82LYrg4GbKXasUeVboiDnhPfP43wwS41YxLnZt7Cstbr4o4RERQjlxAMS
	Q48y1HO7TjaMLSYYvQEJENls4d6eEME=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-106-bb7ZdM1VO1mF_sPo8FNtZQ-1; Mon,
 09 Feb 2026 02:55:16 -0500
X-MC-Unique: bb7ZdM1VO1mF_sPo8FNtZQ-1
X-Mimecast-MFC-AGG-ID: bb7ZdM1VO1mF_sPo8FNtZQ_1770623715
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D35581800365;
	Mon,  9 Feb 2026 07:55:15 +0000 (UTC)
Received: from thinkpad.redhat.com (unknown [10.64.240.53])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A9FE230001A8;
	Mon,  9 Feb 2026 07:55:12 +0000 (UTC)
From: Ming-Hung Tsai <mtsai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	Heinz Mauelshagen <heinzm@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Ming-Hung Tsai <mtsai@redhat.com>
Subject: [PATCH 3/7] dm cache: fix write hang in passthrough mode
Date: Mon,  9 Feb 2026 15:54:07 +0800
Message-ID: <20260209075411.860418-4-mtsai@redhat.com>
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
X-Mimecast-MFC-PROC-ID: gVKWXl2owo7BDF1y-PUAk-8JQEkDJGBF-QuYM544CjU_1770623715
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

The invalidate_remove() function has incomplete logic for handling write
hit bios after cache invalidation. It sets up the remapping for the
overwrite_bio but then drops it immediately without submission, causing
write operations to hang.

Fix by adding a new invalidate_committed() continuation that submits
the remapped writes to the cache origin after metadata commit completes,
while using the overwrite_endio hook to ensure proper completion
sequencing. This maintains existing coherency. Also improve error
handling in invalidate_complete() to preserve the original error status
instead of using bio_io_error() unconditionally.

Fixes: b29d4986d0da ("dm cache: significant rework to leverage dm-bio-prison-v2")
Signed-off-by: Ming-Hung Tsai <mtsai@redhat.com>
---
 drivers/md/dm-cache-target.c | 30 +++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index ac9901033073..8b62fe69722d 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -1467,8 +1467,14 @@ static void invalidate_complete(struct dm_cache_migration *mg, bool success)
 			free_prison_cell(cache, mg->cell);
 	}
 
-	if (!success && mg->overwrite_bio)
-		bio_io_error(mg->overwrite_bio);
+	if (mg->overwrite_bio) {
+		// Set generic error if the bio hasn't been issued yet,
+		// e.g., invalidation or metadata commit failed before bio
+		// submission. Otherwise preserve the bio's own error status.
+		if (!success && !mg->overwrite_bio->bi_status)
+			mg->overwrite_bio->bi_status = BLK_STS_IOERR;
+		bio_endio(mg->overwrite_bio);
+	}
 
 	free_migration(mg);
 	defer_bios(cache, &bios);
@@ -1508,6 +1514,22 @@ static int invalidate_cblock(struct cache *cache, dm_cblock_t cblock)
 	return r;
 }
 
+static void invalidate_committed(struct work_struct *ws)
+{
+	struct dm_cache_migration *mg = ws_to_mg(ws);
+	struct cache *cache = mg->cache;
+	struct bio *bio = mg->overwrite_bio;
+	struct per_bio_data *pb = get_per_bio_data(bio);
+
+	if (mg->k.input)
+		invalidate_complete(mg, false);
+
+	init_continuation(&mg->k, invalidate_completed);
+	remap_to_origin_clear_discard(cache, bio, mg->invalidate_oblock);
+	dm_hook_bio(&pb->hook_info, bio, overwrite_endio, mg);
+	dm_submit_bio_remap(bio, NULL);
+}
+
 static void invalidate_remove(struct work_struct *ws)
 {
 	int r;
@@ -1520,10 +1542,8 @@ static void invalidate_remove(struct work_struct *ws)
 		return;
 	}
 
-	init_continuation(&mg->k, invalidate_completed);
+	init_continuation(&mg->k, invalidate_committed);
 	continue_after_commit(&cache->committer, &mg->k);
-	remap_to_origin_clear_discard(cache, mg->overwrite_bio, mg->invalidate_oblock);
-	mg->overwrite_bio = NULL;
 	schedule_commit(&cache->committer);
 }
 
-- 
2.49.0

