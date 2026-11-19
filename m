Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795065389;
	b=zA1gjMifURQd2lLtiMtNtezYdyjQRRY49xtppGDFtf8BQZuJ73QNEHXq0XI2foB2fgt6
	 ih1nlylrAHrV/jzcL6u0Xb3U0KX7zOUn56HLs33F1gh3msGySR4ksVQw64KH7wsZs1ROX
	 f/Gj+6s/AwLOyErILV25z/n59ZBxC/KPPLYqyoOfRoIJ+sIKmPj4TqY8dxmzEVu7owlt6
	 komq3Zy6i5HFFxoMNCod5wLQf8k9i8FVuLM/ya+R24UmAtpSFa2Wp5rUWCNdZgM8u3IYi
	 cZNYQm4l6UBjCAHOqXdM9HbaKYwr8qWR8EtLFFCFpuvRwI7tsFuJ7BLlxrk2EPRd8pw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795065389;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:In-Reply-To:References:MIME-Version:
	 X-Scanned-By:X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:
	 Content-Transfer-Encoding:content-type;
	bh=/eFrMJdRmbyCVilWFFOcN9CVbywZeEfhI5uZ77W7ufg=;
	b=Pm/xguisJLbTuPN6ntwI1EKhP0yeoa/qvBim9JatzB0QuXjvbDgSbRWpYerYYZBcvzCO
	 HeO0X7NybWNSUkKoxeVjZeF0U16oO7ClBfNRzVPW4M4bicfWwRf+Rsg1SkTFHVdk/DDxj
	 Go0zcIaesv0tCWUq4qGc/2mG9MIPdYxmQTpbyz787pXP5Y26qOJHC2EqM+oqjhn6XGfd/
	 /fzHv3b9zvHOEolrF4PTP9N5JfsFC1+JElZRMtMJ3ctOyfn90Zy/MdRJDNkZu9EXh63Q2
	 HQSYMUp9tgQf0iT9JFkaO2XaFGRWEIsUDDCUkb7iIdCz4eUKmHcksUBDsiZh9Nh4ocw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=YZye1VRn;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10FED606A320
	for <dm-devel@lists.linux.dev>; Thu, 19 Nov 2026 05:16:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 10FED606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=YZye1VRn
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795065388;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/eFrMJdRmbyCVilWFFOcN9CVbywZeEfhI5uZ77W7ufg=;
	b=YZye1VRn1rdSyd0rWsIK1DbV4I16A1G3aUqyUYvTcPqjmuSdJPPpI3OJ3hSdONm5PZvNiT
	3y/UsTb81W3zoIxd/KhZw8YC8FUJ2S6pkl2igw1KDXRnIaZVfw0N6Hldz+3MgkBsW6j+3p
	iYJiq0HC9aNLg2db5p+VupHlxcO6YQY=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-673-3oJFR0IDMJOMiJ-eBNvvnA-1; Thu,
 19 Nov 2026 00:16:24 -0500
X-MC-Unique: 3oJFR0IDMJOMiJ-eBNvvnA-1
X-Mimecast-MFC-AGG-ID: 3oJFR0IDMJOMiJ-eBNvvnA_1795065383
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5910E1956058;
	Thu, 19 Nov 2026 05:16:23 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F302A195B3C0;
	Thu, 19 Nov 2026 05:16:22 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 6AJ5GLvg507198
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 00:16:21 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 6AJ5GKRq507197;
	Thu, 19 Nov 2026 00:16:20 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Qiliang Yuan <qiliang.yuan@linux.dev>, Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>,
        Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: [PATCH v2] dm thin: free thins with kfree_rcu() instead of waiting in thin_dtr()
Date: Thu, 19 Nov 2026 00:16:20 -0500
Message-ID: <20261119051620.507189-1-bmarzins@redhat.com>
In-Reply-To: <20261116-bug-dm-thin-rcu-gp-v1-2-14ed3567da3e@linux.dev>
References: <20261116-bug-dm-thin-rcu-gp-v1-2-14ed3567da3e@linux.dev>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: lBs76ip9FHvF1WutNY8NH4AYkjV-VcCinhptlXf9cRM_1795065383
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

From: Qiliang Yuan <qiliang.yuan@linux.dev>

get_first_thin() and get_next_thin() find a thin on pool->active_thins
under rcu_read_lock() and take a reference on it. thin_dtr() removes the
thin from the list and waits for a grace period before dropping its own
reference, so that no walker takes one after the last is gone. Removing
a thin device thus waits for a full grace period in thin_dtr(), before
it waits for the references that are still held.

Additionally, thin_dtr() can take a thin off the active_thins list,
while it's being held by a worker. The refcount keeps it from being
deleted. But once the thin is removed from the list, there's nothing
that guarantees that tc->list.next is still meaningful. If "dmsetup
remove" is called on the thin device that is next in the active_thins
list, that thin_dtr() call can free the thin pointed to by the original
tc->list.next pointer. So when the worker calls get_next_thin(), it
will access freed memory.

Instead of removing thins from the active_thins list at the start of
thin_dtr(), mark them as dying. This keeps active_thins walkers from
grabbing them, while thin_dtr() waits for the refcount to drop to zero.
It's racy, but no more than removing the thin from the list was.

Also, take the references with refcount_inc_not_zero() and skip the
thins who are dying or whose last reference is gone, so that thin_dtr()
only waits for the references already taken. Free the thin with
kfree_rcu(), as requeue_bios() and error_retry_list_with_code() may
still look at it under rcu_read_lock().

Removing 100 thin devices of an idle pool with dmsetup remove takes per
device (mean of five rounds, min-max of the rounds in parentheses). The
queue freeze in del_gendisk() waits for a grace period of its own, which
the one in thin_dtr() used to overlap, so only part of it is saved:

  before (ms)        after (ms)         change
  16.9 (15.8-17.3)   14.4 (13.8-15.3)     -15%

Fixes: 17181fb7a0c3 ("dm thin: fix a race in thin_dtr")
Signed-off-by: Qiliang Yuan <qiliang.yuan@linux.dev>
Co-developed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---

Qiliang, does this version work for you? Could you rerun the timing?

I'm squashed my changes together with your patch, because my changes 
depend on your patch to actually fix 17181fb7a0c3. I just moved the list
removal till after refcount drops to zero (which depends on your
refcount_inc_not_zero changes to be safe), and added a dying variable to 
keep active_thins walkers from grabbing the thin, while thin_dtr() is
waiting for the existing holders to drop it (just like what removeing it
from the list did).

If people want this split into a fix and a feature patch, that's fine.
However, the feature patch would just be swapping the synchronize_rcu() 
for kfree_rcu(), which seemed to me kind of pointless to move to a   
separate patch.

 drivers/md/dm-thin.c | 54 +++++++++++++++++++++++++++++---------------
 1 file changed, 36 insertions(+), 18 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index bdd250d1eb2e..e695fc356c4d 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -355,11 +355,17 @@ struct thin_c {
 	struct rb_root sort_bio_list; /* sorted list of deferred bios */
 
 	/*
-	 * Ensures the thin is not destroyed until the worker has finished
-	 * iterating the active_thins list.
+	 * Ensures the thin stays on the active_thins list until the workers
+	 * have moved past it while iterating the list.
 	 */
 	refcount_t refcount;
 	struct completion can_destroy;
+	struct rcu_head rcu;
+	/*
+	 * Keeps new active_thin walkers from grabbing the table while
+	 * thin_dtr() is waiting for the existing holders to finish.
+	 */
+	bool dying;
 };
 
 /*----------------------------------------------------------------*/
@@ -652,8 +658,11 @@ static void error_retry_list_with_code(struct pool *pool, blk_status_t error)
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
 
@@ -2318,25 +2327,29 @@ static void process_thin_deferred_cells(struct thin_c *tc)
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
@@ -2345,7 +2358,8 @@ static struct thin_c *get_next_thin(struct pool *pool, struct thin_c *tc)
 
 	rcu_read_lock();
 	list_for_each_entry_continue_rcu(tc, &pool->active_thins, list) {
-		thin_get(tc);
+		if (!thin_tryget(tc))
+			continue;
 		thin_put(old_tc);
 		rcu_read_unlock();
 		return tc;
@@ -2817,6 +2831,8 @@ static void requeue_bios(struct pool *pool)
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(tc, &pool->active_thins, list) {
+		if (READ_ONCE(tc->dying))
+			continue;
 		spin_lock_irq(&tc->lock);
 		bio_list_merge(&tc->deferred_bio_list, &tc->retry_on_resume_list);
 		bio_list_init(&tc->retry_on_resume_list);
@@ -4131,9 +4147,9 @@ static struct target_type pool_target = {
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
@@ -4146,14 +4162,15 @@ static void thin_dtr(struct dm_target *ti)
 {
 	struct thin_c *tc = ti->private;
 
-	spin_lock_irq(&tc->pool->lock);
-	list_del_rcu(&tc->list);
-	spin_unlock_irq(&tc->pool->lock);
-	synchronize_rcu();
+	WRITE_ONCE(tc->dying, true);
 
 	thin_put(tc);
 	wait_for_completion(&tc->can_destroy);
 
+	spin_lock_irq(&tc->pool->lock);
+	list_del_rcu(&tc->list);
+	spin_unlock_irq(&tc->pool->lock);
+
 	mutex_lock(&dm_thin_pool_table.mutex);
 
 	__pool_dec(tc->pool);
@@ -4161,7 +4178,8 @@ static void thin_dtr(struct dm_target *ti)
 	dm_put_device(ti, tc->pool_dev);
 	if (tc->origin_dev)
 		dm_put_device(ti, tc->origin_dev);
-	kfree(tc);
+	/* Let RCU readers of active_thins finish with tc before freeing it */
+	kfree_rcu(tc, rcu);
 
 	mutex_unlock(&dm_thin_pool_table.mutex);
 }
-- 
2.56.0

