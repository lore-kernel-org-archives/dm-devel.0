Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C50CE10940;
	Thu,  3 Oct 2024 01:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727918184; cv=none; b=qbz5xXHdYcouXQRv7ljHbEXNXrYZJ1y6hKuQGQPIkUcVCqOMo64Dl6xLWJoOozbq0/deQQZHMJFeQfACr1BQ/J3Hco3aewiE47JyfD9b0v6I0e7RoImrq5sQ1nVqqhNJZ8Q48wb95goFQFe+Hf2JcliaOAVvNZDKSrIjBdUlTZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727918184; c=relaxed/simple;
	bh=TN42O+dPCc9rpN7i5uzpW1iB7+KL+xeALQWTXTx2TB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X+Tbr1yXl3Y2nbbrAy49ZJrtC86H7hJryA6uqRhEKkulBD7AmO6IQJu400OWTlIm0Mqdwg6pzwA1xhNWWslASZdQydMUHoE9ar/nXiRTaTlGncODYfAAsiaZ/8hBS1p0CCJcJFuRxs23qM7g4vrBQSsitXzOUlwgjuPyy/ju47g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=fd4gtFQt; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="fd4gtFQt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=h8lTTXfuK6RUBS+BUnUa8xbmT/8DZa1iUX/wpjTb1G0=; b=fd4gtFQt2HSZtktr
	MY3ZQKUr7AQK5YpTfMuLGleyUxPPi2c7U9VAfIQ4DkapknjFEolid1ylqintkqlLC8t21gBpME9hX
	Uz6mp0ddKnSnKYXlc9qJ/bT1tfwdTI8sor2jyZp0QHMxQsfOcyJnbNrRIl7iFEXilNw6ayPahg186
	CXze/Ib04s6PYaXgE2vzZeZNQ9qWEwTdazKV4hY/teXOzh3mpuj8ZPEMt2TvP8zi0elqdDjP00u6+
	zDCo3j7qW0McbSV9N9rpYuxrgyvqxjZ+zmVjL0chKn6BbBe6T+gcE5iXv3GTcq1rswFuw4SfmVN1j
	sePiF8l8xC4t1W9kcg==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1swARu-008Zju-22;
	Thu, 03 Oct 2024 01:16:10 +0000
From: linux@treblig.org
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	msakai@redhat.com
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH 4/9] dm cache: Remove unused functions in bio-prison-v1
Date: Thu,  3 Oct 2024 02:15:49 +0100
Message-ID: <20241003011554.266654-5-linux@treblig.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241003011554.266654-1-linux@treblig.org>
References: <20241003011554.266654-1-linux@treblig.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

dm_cache_size() and dm_cache_dump() are unused since commit
b29d4986d0da ("dm cache: significant rework to leverage dm-bio-prison-v2")

Remove them.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 drivers/md/dm-bio-prison-v1.c | 35 -----------------------------------
 drivers/md/dm-bio-prison-v1.h | 24 ------------------------
 2 files changed, 59 deletions(-)

diff --git a/drivers/md/dm-bio-prison-v1.c b/drivers/md/dm-bio-prison-v1.c
index bca0f39e15b8..b4d1c4329df3 100644
--- a/drivers/md/dm-bio-prison-v1.c
+++ b/drivers/md/dm-bio-prison-v1.c
@@ -198,15 +198,6 @@ int dm_bio_detain(struct dm_bio_prison *prison,
 }
 EXPORT_SYMBOL_GPL(dm_bio_detain);
 
-int dm_get_cell(struct dm_bio_prison *prison,
-		struct dm_cell_key *key,
-		struct dm_bio_prison_cell *cell_prealloc,
-		struct dm_bio_prison_cell **cell_result)
-{
-	return bio_detain(prison, key, NULL, cell_prealloc, cell_result);
-}
-EXPORT_SYMBOL_GPL(dm_get_cell);
-
 /*
  * @inmates must have been initialised prior to this call
  */
@@ -288,32 +279,6 @@ void dm_cell_visit_release(struct dm_bio_prison *prison,
 }
 EXPORT_SYMBOL_GPL(dm_cell_visit_release);
 
-static int __promote_or_release(struct rb_root *root,
-				struct dm_bio_prison_cell *cell)
-{
-	if (bio_list_empty(&cell->bios)) {
-		rb_erase(&cell->node, root);
-		return 1;
-	}
-
-	cell->holder = bio_list_pop(&cell->bios);
-	return 0;
-}
-
-int dm_cell_promote_or_release(struct dm_bio_prison *prison,
-			       struct dm_bio_prison_cell *cell)
-{
-	int r;
-	unsigned l = lock_nr(&cell->key, prison->num_locks);
-
-	spin_lock_irq(&prison->regions[l].lock);
-	r = __promote_or_release(&prison->regions[l].cell, cell);
-	spin_unlock_irq(&prison->regions[l].lock);
-
-	return r;
-}
-EXPORT_SYMBOL_GPL(dm_cell_promote_or_release);
-
 /*----------------------------------------------------------------*/
 
 #define DEFERRED_SET_SIZE 64
diff --git a/drivers/md/dm-bio-prison-v1.h b/drivers/md/dm-bio-prison-v1.h
index 2a097ed0d85e..d39706c48447 100644
--- a/drivers/md/dm-bio-prison-v1.h
+++ b/drivers/md/dm-bio-prison-v1.h
@@ -72,17 +72,6 @@ struct dm_bio_prison_cell *dm_bio_prison_alloc_cell(struct dm_bio_prison *prison
 void dm_bio_prison_free_cell(struct dm_bio_prison *prison,
 			     struct dm_bio_prison_cell *cell);
 
-/*
- * Creates, or retrieves a cell that overlaps the given key.
- *
- * Returns 1 if pre-existing cell returned, zero if new cell created using
- * @cell_prealloc.
- */
-int dm_get_cell(struct dm_bio_prison *prison,
-		struct dm_cell_key *key,
-		struct dm_bio_prison_cell *cell_prealloc,
-		struct dm_bio_prison_cell **cell_result);
-
 /*
  * Returns false if key is beyond BIO_PRISON_MAX_RANGE or spans a boundary.
  */
@@ -117,19 +106,6 @@ void dm_cell_visit_release(struct dm_bio_prison *prison,
 			   void (*visit_fn)(void *, struct dm_bio_prison_cell *),
 			   void *context, struct dm_bio_prison_cell *cell);
 
-/*
- * Rather than always releasing the prisoners in a cell, the client may
- * want to promote one of them to be the new holder.  There is a race here
- * though between releasing an empty cell, and other threads adding new
- * inmates.  So this function makes the decision with its lock held.
- *
- * This function can have two outcomes:
- * i) An inmate is promoted to be the holder of the cell (return value of 0).
- * ii) The cell has no inmate for promotion and is released (return value of 1).
- */
-int dm_cell_promote_or_release(struct dm_bio_prison *prison,
-			       struct dm_bio_prison_cell *cell);
-
 /*----------------------------------------------------------------*/
 
 /*
-- 
2.46.2

