Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795067149;
	b=DQ4WsdOvu0gPq/g7xlxwj+SGEG87JAKdkbRS/esrHTZQhJ8NV1jlQqMZiP2wQmBjRyVB
	 Sicw+fiNsej0tKHaJM4uS1nPQbc2M/H7xMXmAUyT1aODptpyFYiJ3HDNmqs5MCI9RdlLe
	 kIz4kZQxN2nm4K7PozC3q1J4pGU+MfEv+oNInCa4YcRGsPq8Hryc6rtecpxw/99LGU6Vc
	 jDcpy+KURlBcEH3+JXC7ydI3TxO8ARR7uFpNrbJaqEWbwOnTVa72d9AkjWv5Ju7+8poh/
	 Egp5B1xz2Zkdb+NHSFxsrUgo4aYXbcoDTSfVMc2xxusBkRguE2vQh/j+puAWXMNPjGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795067149;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer;
	bh=u7b8dqCM7GZ/vOl3/UCLJZVLgWwemwNrrc/Owmz3wdo=;
	b=NWZA1Y3Ibf4E3ZvdOYn4+7Prure7wtUmsjBgvPbjLfwBGXw7fH37MLDj376O+1/SGgWi
	 T+h63g11e1+8XrWdffKwQ1iQtyfiutgl0rXbTj0ZtDK2QW3F0BoMI33aE0MAYwvQfmK8Q
	 hdpE7n4TWU4DNX/VegCW9BBN1/v9OETwpYjBcoVxftcM5R3sAUcgSR7378Qa22D5ZG6s/
	 aPIYF6Py8ifgy+9ndys1zQmqhaisbUH4il6O/LVyeNzJM/n+JioMJEQuU35f9VfXUOE9E
	 8wMWN1ER7DJu8OXy/H6tj+zPjMTdY/Z1KMM3JByRnvfFGJLnGylxpgPRE2acKJRpvew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="WcNaqrT/";
	arc=none smtp.remote-ip=91.218.175.177
Received: from mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C42BB606A336
	for <dm-devel@lists.linux.dev>; Thu, 19 Nov 2026 05:45:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C42BB606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=WcNaqrT/
X-Envelope-To: dm-devel@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=sYq/ACkmGYZN7x+02+N05uhDgHOkpTdesVa83wIaO+4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795067146; v=1; x=1795671946;
 b=WcNaqrT/Hv7zyP9uwgTiYlnCr6qNL2JdcrL552tg2TpkSgF/aqlUGH2D6deXEceAkrOrq6pn
 tFRyEpTXeBSdoD5z0bmrd7A06mSa3PVlL3iPinLziz4fN9o/luK+Hrm4Y/zB/idITolPXFW0txA
 zWfD6/w+Eve355TAEBXcnarY=
X-Envelope-To: dm-devel@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id a6d9900c927f0b46;
	Thu, 19 Nov 2026 05:45:46 +0000
X-Mizu-Trace-ID: a6d9900c927f0b46
X-Migadu-Flow: FLOW_OUT
From: Qiliang Yuan <qiliang.yuan@linux.dev>
Date: Thu, 19 Nov 2026 00:45:33 -0500
Subject: [PATCH v2 2/3] dm thin: keep a thin on active_thins until its last
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
Message-Id: <20261119-bug-dm-thin-rcu-gp-v2-2-055d627763c3@linux.dev>
References: <20261119-bug-dm-thin-rcu-gp-v2-0-055d627763c3@linux.dev>
In-Reply-To: <20261119-bug-dm-thin-rcu-gp-v2-0-055d627763c3@linux.dev>
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
from freed memory.

Leave a thin on the list until its last reference is dropped and unlink
it then, under the pool lock, so that removing its neighbours keeps its
list.next valid. Have thin_dtr() mark the thin dead, so that no new
walker takes a reference, and make the walkers skip dead thins and the
ones whose last reference is already gone. thin_dtr() waits for the
grace period after the thin is unlinked, before freeing it.

With a test-only 3 s msleep() added to the worker after each thin it
processes, thins 1 and 2 of a pool with three thins are suspended and
then removed while the worker holds thin 1. Trials in which KASAN reports
a slab-use-after-free in get_next_thin():

                       before (trials)   after (trials)   change
  KASAN report                  3 of 3           0 of 5     -100%

Fixes: b10ebd34cccae ("dm thin: fix rcu_read_lock being held in code that can sleep")
Cc: stable@vger.kernel.org
Reported-by: Benjamin Marzinski <bmarzins@redhat.com>
Closes: https://lore.kernel.org/r/avz7qDWd2g-uubmL@redhat.com
Suggested-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Qiliang Yuan <qiliang.yuan@linux.dev>
---
 drivers/md/dm-thin.c | 51 +++++++++++++++++++++++++++++++++------------------
 1 file changed, 33 insertions(+), 18 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index bdd250d1eb2e1..f79f5982ae36c 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -356,10 +356,12 @@ struct thin_c {
 
 	/*
 	 * Ensures the thin is not destroyed until the worker has finished
-	 * iterating the active_thins list.
+	 * iterating the active_thins list.  Set dead once thin_dtr() starts,
+	 * so that no new walker picks the thin up.
 	 */
 	refcount_t refcount;
 	struct completion can_destroy;
+	bool dead;
 };
 
 /*----------------------------------------------------------------*/
@@ -2318,25 +2320,28 @@ static void process_thin_deferred_cells(struct thin_c *tc)
 	} while (!list_empty(&cells));
 }
 
-static void thin_get(struct thin_c *tc);
+static bool thin_tryget(struct thin_c *tc);
 static void thin_put(struct thin_c *tc);
 
 /*
  * We can't hold rcu_read_lock() around code that can block.  So we
  * find a thin with the rcu lock held; bump a refcount; then drop
- * the lock.
+ * the lock.  Skip the thins that thin_dtr() is destroying.
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
@@ -2345,7 +2350,8 @@ static struct thin_c *get_next_thin(struct pool *pool, struct thin_c *tc)
 
 	rcu_read_lock();
 	list_for_each_entry_continue_rcu(tc, &pool->active_thins, list) {
-		thin_get(tc);
+		if (!thin_tryget(tc))
+			continue;
 		thin_put(old_tc);
 		rcu_read_unlock();
 		return tc;
@@ -4131,28 +4137,37 @@ static struct target_type pool_target = {
  * Thin target methods
  *--------------------------------------------------------------
  */
-static void thin_get(struct thin_c *tc)
+static bool thin_tryget(struct thin_c *tc)
 {
-	refcount_inc(&tc->refcount);
+	return !READ_ONCE(tc->dead) && refcount_inc_not_zero(&tc->refcount);
 }
 
 static void thin_put(struct thin_c *tc)
 {
-	if (refcount_dec_and_test(&tc->refcount))
-		complete(&tc->can_destroy);
+	unsigned long flags;
+
+	if (!refcount_dec_and_test(&tc->refcount))
+		return;
+
+	/*
+	 * Unlink tc only once nobody holds it: a worker holding it continues
+	 * its walk from tc->list.next.
+	 */
+	spin_lock_irqsave(&tc->pool->lock, flags);
+	list_del_rcu(&tc->list);
+	spin_unlock_irqrestore(&tc->pool->lock, flags);
+	complete(&tc->can_destroy);
 }
 
 static void thin_dtr(struct dm_target *ti)
 {
 	struct thin_c *tc = ti->private;
 
-	spin_lock_irq(&tc->pool->lock);
-	list_del_rcu(&tc->list);
-	spin_unlock_irq(&tc->pool->lock);
-	synchronize_rcu();
-
+	WRITE_ONCE(tc->dead, true);
 	thin_put(tc);
 	wait_for_completion(&tc->can_destroy);
+	/* Let RCU readers of active_thins finish with tc */
+	synchronize_rcu();
 
 	mutex_lock(&dm_thin_pool_table.mutex);
 

-- 
2.43.0

