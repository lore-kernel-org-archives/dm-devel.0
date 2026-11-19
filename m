Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.149
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795086347;
	b=0xkz9KxOCwpvipegorJwrdy8HSS/M0iilyyVGR4mNANQl+JNTzQ1rXLQ8ymMzTmAgDo0
	 JROv0v2MJOKevEFlIU/1dLksp10aVBXXf6ILrc/A/5jZdRdsfvRX632pgM622QJF4hvJT
	 MRPPzuE92noiTK3+xhLBzJfA0ppc1/iuMfpnhEmhTVjyn8i6E8+HZ0SfwGusSv8piVp74
	 JzP9TX8LBlKSk208grGwtDLEGFtP8mhWctEP+28WaqQrq9aMgzxdbhOb+zxJqdNnc/VkQ
	 qt3Rnmt4D65ddRu/gJVZqL446XiewGatOldl++/wNLZOgmgjmVGavPPifo/25iEg8zg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795086347;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer;
	bh=AaEzE711+tc9IdObgmSVbwoFFJ2pMZ5n07vhrZrx58U=;
	b=bmo+gPn03xWqshez2gaJ1lvnsllq8lth8Jagd+YC3RFwxWqVdt091FFtkHbd4MlOANzr
	 EB7bfmi5mfbxqsloEXIlFkTa3bSVHymPe44M58vYxxw6/AS+CH1tdfL2Uhux5BUuYS0sF
	 GsCrWzrV5YSt0hjdg6hdkgisXsGbyGFLydK8zWVJ+xXP1yJrQRyDeTGSQxvAPLqA9FSsI
	 tLr3Ixy0X/RW4taUUpVKqyD9XOc4MCwXdyywaL3lysraXaJ8yTPvJ+y4Oxt74tcjxlHrc
	 fLksv08JO1JLD3FhKmMDDrDNuw8AHYdUXkmv7JJlU9ftg+/955oiFaGKnwhsvD4dCTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=bbUHLbot;
	arc=none smtp.remote-ip=95.215.58.149
Received: from mta1.migadu.com (out-149.mta1.migadu.com [95.215.58.149])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 071C3606A320
	for <dm-devel@lists.linux.dev>; Thu, 19 Nov 2026 11:05:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 071C3606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=bbUHLbot
X-Envelope-To: dm-devel@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=GaPiiv9hfZUnw6nbm9QwfXgKetG3STR+VM+RraVfipY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795086345; v=1; x=1795691145;
 b=bbUHLbotF+29TWCWmQQeMvwKSifosaYX6afjxpZYrrvsxGt/a+w6quYlQoqZB76tJhmWoHfx
 lJa+dPc8Uz8KgKz3eHweO08UmchWV0lNY6jzfRlPLx47WEane603nBzya/UuidD+lfBTXW5m+k/
 97yZx9ULZ3OLvy/LTFSctYt0=
X-Envelope-To: dm-devel@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 49fea87ce89f3fbb;
	Thu, 19 Nov 2026 11:05:45 +0000
X-Mizu-Trace-ID: 49fea87ce89f3fbb
X-Migadu-Flow: FLOW_OUT
From: Qiliang Yuan <qiliang.yuan@linux.dev>
Date: Thu, 19 Nov 2026 06:05:07 -0500
Subject: [PATCH v3 2/3] dm thin: keep a thin on active_thins until its last
 reference is dropped
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261119-bug-dm-thin-rcu-gp-v3-2-c80ecc475e1e@linux.dev>
References: <20261119-bug-dm-thin-rcu-gp-v3-0-c80ecc475e1e@linux.dev>
In-Reply-To: <20261119-bug-dm-thin-rcu-gp-v3-0-c80ecc475e1e@linux.dev>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
 Mikulas Patocka <mpatocka@redhat.com>, 
 Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
 Qiliang Yuan <qiliang.yuan@linux.dev>, stable@vger.kernel.org
X-Mailer: b4 0.13.0

get_first_thin() and get_next_thin() let the pool worker process the
thins on pool->active_thins without holding rcu_read_lock() while it
does: they take a reference on a thin under the lock, and
get_next_thin() continues from that thin in a new read-side section.
thin_dtr() takes the thin off the list, waits for a grace period and
then for the references still held.

Once thin_dtr() has removed a thin that the worker holds, nothing
updates its list.next pointer any more. If the thin after it is removed
and freed before the worker calls get_next_thin(), the walk continues
from freed memory:

  BUG: KASAN: slab-use-after-free in get_next_thin+0x8b/0x240 [dm_thin_pool]
  Write of size 4 at addr ff11000116371cc8 by task kworker/u128:0/13
  Workqueue: dm-thin do_worker [dm_thin_pool]
  Call Trace:
   get_next_thin+0x8b/0x240 [dm_thin_pool]
   process_deferred_bios+0x34/0x650 [dm_thin_pool]
   do_worker+0x2b7/0x4f0 [dm_thin_pool]
   process_one_work+0x8ce/0x1850
   worker_thread+0x639/0x1190
  Allocated by task 2290:
   thin_ctr+0x130/0x1260 [dm_thin_pool]
   dm_table_add_target+0x65f/0xf60 [dm_mod]
   table_load+0x1c2/0x480 [dm_mod]
  Freed by task 2391:
   kfree+0x15d/0x550
   thin_dtr+0x21c/0x2c0 [dm_thin_pool]
   dm_table_destroy+0x13c/0x570 [dm_mod]
   __dm_destroy+0x2eb/0x5d0 [dm_mod]
   dev_remove+0x2f1/0x3c0 [dm_mod]

Mark the thin as dying in thin_dtr() instead of removing it, and take it
off the list only after the last reference is dropped, so that removing
its neighbours keeps its list.next valid. Take references with
refcount_inc_not_zero() and skip dying thins, so that thin_dtr() only
waits for the references already taken, and have requeue_bios() and
error_retry_list_with_code() skip dying thins as they skipped the thins
already off the list.

With a test-only 3 s msleep() added to the worker after each thin it
processes, thins 1 and 2 of a pool with three thins are suspended and
then removed while the worker holds thin 1. Trials in which KASAN reports
a slab-use-after-free in get_next_thin():

                 before (trials)   after (trials)   change
  KASAN report            3 of 3           0 of 5     -100%

Fixes: 17181fb7a0c3 ("dm thin: fix a race in thin_dtr")
Cc: stable@vger.kernel.org
Reported-by: Benjamin Marzinski <bmarzins@redhat.com>
Closes: https://lore.kernel.org/r/avz7qDWd2g-uubmL@redhat.com
Co-developed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Qiliang Yuan <qiliang.yuan@linux.dev>
---
 drivers/md/dm-thin.c | 49 +++++++++++++++++++++++++++++++++----------------
 1 file changed, 33 insertions(+), 16 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index bdd250d1eb2e1..62ef96bf08cb3 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -355,11 +355,16 @@ struct thin_c {
 	struct rb_root sort_bio_list; /* sorted list of deferred bios */
 
 	/*
-	 * Ensures the thin is not destroyed until the worker has finished
-	 * iterating the active_thins list.
+	 * Ensures the thin stays on the active_thins list until the workers
+	 * have moved past it while iterating the list.
 	 */
 	refcount_t refcount;
 	struct completion can_destroy;
+	/*
+	 * Keeps new active_thin walkers from grabbing the table while
+	 * thin_dtr() is waiting for the existing holders to finish.
+	 */
+	bool dying;
 };
 
 /*----------------------------------------------------------------*/
@@ -652,8 +657,11 @@ static void error_retry_list_with_code(struct pool *pool, blk_status_t error)
 	struct thin_c *tc;
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(tc, &pool->active_thins, list)
+	list_for_each_entry_rcu(tc, &pool->active_thins, list) {
+		if (READ_ONCE(tc->dying))
+			continue;
 		error_thin_bio_list(tc, &tc->retry_on_resume_list, error);
+	}
 	rcu_read_unlock();
 }
 
@@ -2318,25 +2326,29 @@ static void process_thin_deferred_cells(struct thin_c *tc)
 	} while (!list_empty(&cells));
 }
 
-static void thin_get(struct thin_c *tc);
+static bool thin_tryget(struct thin_c *tc);
 static void thin_put(struct thin_c *tc);
 
 /*
  * We can't hold rcu_read_lock() around code that can block.  So we
  * find a thin with the rcu lock held; bump a refcount; then drop
- * the lock.
+ * the lock. Skip the thins marked as dying or whose refcount thin_dtr()
+ * already dropped to zero.
  */
 static struct thin_c *get_first_thin(struct pool *pool)
 {
-	struct thin_c *tc = NULL;
+	struct thin_c *tc;
 
 	rcu_read_lock();
-	tc = list_first_or_null_rcu(&pool->active_thins, struct thin_c, list);
-	if (tc)
-		thin_get(tc);
+	list_for_each_entry_rcu(tc, &pool->active_thins, list) {
+		if (thin_tryget(tc)) {
+			rcu_read_unlock();
+			return tc;
+		}
+	}
 	rcu_read_unlock();
 
-	return tc;
+	return NULL;
 }
 
 static struct thin_c *get_next_thin(struct pool *pool, struct thin_c *tc)
@@ -2345,7 +2357,8 @@ static struct thin_c *get_next_thin(struct pool *pool, struct thin_c *tc)
 
 	rcu_read_lock();
 	list_for_each_entry_continue_rcu(tc, &pool->active_thins, list) {
-		thin_get(tc);
+		if (!thin_tryget(tc))
+			continue;
 		thin_put(old_tc);
 		rcu_read_unlock();
 		return tc;
@@ -2817,6 +2830,8 @@ static void requeue_bios(struct pool *pool)
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(tc, &pool->active_thins, list) {
+		if (READ_ONCE(tc->dying))
+			continue;
 		spin_lock_irq(&tc->lock);
 		bio_list_merge(&tc->deferred_bio_list, &tc->retry_on_resume_list);
 		bio_list_init(&tc->retry_on_resume_list);
@@ -4131,9 +4146,9 @@ static struct target_type pool_target = {
  * Thin target methods
  *--------------------------------------------------------------
  */
-static void thin_get(struct thin_c *tc)
+static bool thin_tryget(struct thin_c *tc)
 {
-	refcount_inc(&tc->refcount);
+	return !READ_ONCE(tc->dying) && refcount_inc_not_zero(&tc->refcount);
 }
 
 static void thin_put(struct thin_c *tc)
@@ -4146,14 +4161,16 @@ static void thin_dtr(struct dm_target *ti)
 {
 	struct thin_c *tc = ti->private;
 
+	WRITE_ONCE(tc->dying, true);
+
+	thin_put(tc);
+	wait_for_completion(&tc->can_destroy);
+
 	spin_lock_irq(&tc->pool->lock);
 	list_del_rcu(&tc->list);
 	spin_unlock_irq(&tc->pool->lock);
 	synchronize_rcu();
 
-	thin_put(tc);
-	wait_for_completion(&tc->can_destroy);
-
 	mutex_lock(&dm_thin_pool_table.mutex);
 
 	__pool_dec(tc->pool);

-- 
2.43.0

