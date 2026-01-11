Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 423662D028A;
	Sun, 11 Jan 2026 21:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768167547; cv=none; b=b/Re+xrbxau44VtD1BtZUxgpTwTLduRhsja7nvnaMq4hJf/rndJ0BM003gtjNs0l696hQ9Txqi9NEAih465LhyNGF1xomUkUVenY5UdWTIdovR2gmZ6m4kHKjeIx14TWVrE5H8mx9VJRzYsNzarfFRNeU1QJY3pXnH0tT3t99Gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768167547; c=relaxed/simple;
	bh=HnHWABtvCkKcsqbtikkBLOHjLvBbhWd2x5g9UCb6u80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oopoitc4xE8IUeag/42j+MsnFOgKdT/b31FFPGyk6yiCHQ7Ckz+j+2Fjn465Pxk2jwK0J2dfbnLAe4AssMztxNZGzSDNNA8zvWGgN7U7Fiqug4e7a+T5TvlzZ0oz7IHyBE01Z7aU5C/Bfu64X1v2PSV+Sv/nsfKrza6U0keDE1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kBXlRssN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kBXlRssN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D96FC19422;
	Sun, 11 Jan 2026 21:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768167546;
	bh=HnHWABtvCkKcsqbtikkBLOHjLvBbhWd2x5g9UCb6u80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kBXlRssNNAZ1GjHGLKSp9zD+//rp3xufor/E3G47Q3hTAnAZEIwgjLpdGlZ1u8YDd
	 ak7isCIKcB61R/uwTffImDHRNDbUOWrgyaeI++bRsITZCOgv4Xi6apZu2owYrUyRvl
	 hmmmp0JX+Q6leiVORuBpSYBSrNS5gy7xLCFzhctCSG8ewpx97J7riHHa98wOh0xrDs
	 UzsOMZT/YsUnmM3poQFC5/Z3yYSk1zdO3TqXU1I6x8bvJKhy6lGvycX/OTQHM7NLni
	 T7lF0gscrgJnGk+BOkILRbiEWjyr9HLPnS9GM4dzw5jNACHWLsKlP7lgznBfc9iT1U
	 VVuy2O3y5H18g==
From: Eric Biggers <ebiggers@kernel.org>
To: dm-devel@lists.linux.dev,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Sami Tolvanen <samitolvanen@google.com>,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 1/2] dm-bufio: merge cache_put() into cache_put_and_wake()
Date: Sun, 11 Jan 2026 13:38:20 -0800
Message-ID: <20260111213821.94895-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260111213821.94895-1-ebiggers@kernel.org>
References: <20260111213821.94895-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Merge cache_put() into its only caller, cache_put_and_wake().

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/md/dm-bufio.c | 32 ++++++++++----------------------
 1 file changed, 10 insertions(+), 22 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 5235f3e4924b..6e61982c9b92 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -367,12 +367,12 @@ struct dm_buffer {
  * It does *not* handle:
  *  - allocation/freeing of buffers.
  *  - IO
  *  - Eviction or cache sizing.
  *
- * cache_get() and cache_put() are threadsafe, you do not need to
- * protect these calls with a surrounding mutex.  All the other
+ * cache_get() and cache_put_and_wake() are threadsafe, you do not need
+ * to protect these calls with a surrounding mutex.  All the other
  * methods are not threadsafe; they do use locking primitives, but
  * only enough to ensure get/put are threadsafe.
  */
 
 struct buffer_tree {
@@ -617,28 +617,10 @@ static struct dm_buffer *cache_get(struct dm_buffer_cache *bc, sector_t block)
 	return b;
 }
 
 /*--------------*/
 
-/*
- * Returns true if the hold count hits zero.
- * threadsafe
- */
-static bool cache_put(struct dm_buffer_cache *bc, struct dm_buffer *b)
-{
-	bool r;
-
-	cache_read_lock(bc, b->block);
-	BUG_ON(!atomic_read(&b->hold_count));
-	r = atomic_dec_and_test(&b->hold_count);
-	cache_read_unlock(bc, b->block);
-
-	return r;
-}
-
-/*--------------*/
-
 typedef enum evict_result (*b_predicate)(struct dm_buffer *, void *);
 
 /*
  * Evicts a buffer based on a predicate.  The oldest buffer that
  * matches the predicate will be selected.  In addition to the
@@ -1743,16 +1725,22 @@ static void __check_watermark(struct dm_bufio_client *c,
  *--------------------------------------------------------------
  */
 
 static void cache_put_and_wake(struct dm_bufio_client *c, struct dm_buffer *b)
 {
+	bool wake;
+
+	cache_read_lock(&c->cache, b->block);
+	BUG_ON(!atomic_read(&b->hold_count));
+	wake = atomic_dec_and_test(&b->hold_count);
+	cache_read_unlock(&c->cache, b->block);
+
 	/*
 	 * Relying on waitqueue_active() is racey, but we sleep
 	 * with schedule_timeout anyway.
 	 */
-	if (cache_put(&c->cache, b) &&
-	    unlikely(waitqueue_active(&c->free_buffer_wait)))
+	if (wake && unlikely(waitqueue_active(&c->free_buffer_wait)))
 		wake_up(&c->free_buffer_wait);
 }
 
 /*
  * This assumes you have already checked the cache to see if the buffer
-- 
2.52.0

