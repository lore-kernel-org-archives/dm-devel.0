Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 854423B5843
	for <dm-devel@lists.linux.dev>; Tue, 25 Aug 2026 19:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787685753; cv=none; b=KGa7eGxcbJc4WotlZRL2d8sKGGdZBAFJny/FIU0mVdvCOAjBjg2+29nrnhd7VDBw+HdHuFceZTdhBWhS7zuMtCOPsa4J0YiaCUYgz2kWo7tYJUIKT2NqOV/g6kgTeT6534oxS+ky+yG2B3yPFy0IkGk6OxugqhY5VD3KOswg68c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787685753; c=relaxed/simple;
	bh=1D5LYqmrS7a6fvUZgugj7QNVAU/Bw7vJZHTrl9z4950=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=Hc7IbXym7vFMldlHKKDAp2WxFRarYfyFF/q47/BbTJGjjhOTqKKbUBSE9K4e5zgSvivlgscPjCYmIHThYNAo4lZt6JrkWj2zFmZJkZojHhQt+QbZE5mTxy3cnZqw5KsECiGwoKQqsI1ggs5ViYMA0JTKS6GmfAkS0sRfL/fw7QI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DOoID1C4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DOoID1C4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787685751;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=kY+0sU6Y19fzywChB/fb9CWOwX56REd8ZYDviINs2z0=;
	b=DOoID1C445EcaXo1yF6Kz06XpfgnFEPTxhq9PyOuOq5bb5+Ka46GqRWCcFxXhDv0CvAapT
	aPpWTXqkPb/Jc+G2YALPQ3f22KnGD9FJYePqY9/p9UB7UBI9pisnyBqXDogxOoRjztot2F
	1B+m3H8vw/DPi0qZOF5mnvfNW5X0M3Y=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-627-ZwBhHXvkO7uQqW3MltOQCA-1; Tue,
 25 Aug 2026 15:22:30 -0400
X-MC-Unique: ZwBhHXvkO7uQqW3MltOQCA-1
X-Mimecast-MFC-AGG-ID: ZwBhHXvkO7uQqW3MltOQCA_1787685749
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 00FF7184B3AE;
	Tue, 25 Aug 2026 19:22:29 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5FD5818005B4;
	Tue, 25 Aug 2026 19:22:28 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 67PJMQAB4191107
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 25 Aug 2026 15:22:26 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 67PJMQiS4191044;
	Tue, 25 Aug 2026 15:22:26 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@kernel.org>
Cc: Ming-Hung Tsai <mtsai@redhat.com>, dm-devel@lists.linux.dev
Subject: [PATCH] dm cache: fix issue with background work locking
Date: Tue, 25 Aug 2026 15:22:26 -0400
Message-ID: <20260825192226.4191036-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 0ati4idl2JqlM5fdSR9nRrPvqV7BMPNSRxt9VUEZhX0_1787685749
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

dm cache used a rw_semaphore for background_work_lock. Write locks on
rw_semaphores have strict owner semantics, but there was no guarantee
that the process that locked background_work_lock was the same process
that unlocked it. This can be easily seen using a kernel compiled with
CONFIG_DEBUG_RWSEMS. Given a dm cache device <cache>, run: 'dmsetup
suspend <cache> && dmsetup resume <cache>'. This will tigger a kernel
warning:

DEBUG_RWSEMS_WARN_ON((rwsem_owner(sem) != current) && !rwsem_test_oflags(sem, RWSEM_NONSPINNABLE))

triggered by cache_resume(). To fix this, switch from a rw_semaphore to
a spinlock and a wait queue. dm cache already hasd a wait queue and
associated counter, migration_wait and nr_allocated_migrations, that was
getting woken up when background work was getting completed, but wasn't
actually used by anything. This is replaced by the background_work queue
and counter.

Fixes: b29d4986d0da ("dm cache: significant rework to leverage dm-bio-prison-v2")
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 drivers/md/dm-cache-target.c | 55 ++++++++++++++++++------------------
 1 file changed, 28 insertions(+), 27 deletions(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 33dbc71b730f..d8d9c63d2a67 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -340,8 +340,6 @@ struct cache {
 	struct list_head invalidation_requests;
 
 	sector_t migration_threshold;
-	wait_queue_head_t migration_wait;
-	atomic_t nr_allocated_migrations;
 
 	/*
 	 * The number of in flight migrations that are performing
@@ -397,7 +395,11 @@ struct cache {
 	bool loaded_mappings:1;
 	bool loaded_discards:1;
 
-	struct rw_semaphore background_work_lock;
+	/* background work management */
+	bool background_work_allowed;
+	unsigned background_work_nr;
+	spinlock_t background_work_lock;
+	wait_queue_head_t background_work_wait;
 
 	struct batcher committer;
 	struct work_struct commit_ws;
@@ -488,19 +490,13 @@ static struct dm_cache_migration *alloc_migration(struct cache *cache)
 	memset(mg, 0, sizeof(*mg));
 
 	mg->cache = cache;
-	atomic_inc(&cache->nr_allocated_migrations);
 
 	return mg;
 }
 
 static void free_migration(struct dm_cache_migration *mg)
 {
-	struct cache *cache = mg->cache;
-
-	if (atomic_dec_and_test(&cache->nr_allocated_migrations))
-		wake_up(&cache->migration_wait);
-
-	mempool_free(mg, &cache->migration_pool);
+	mempool_free(mg, &mg->cache->migration_pool);
 }
 
 /*----------------------------------------------------------------*/
@@ -1030,34 +1026,39 @@ static void calc_discard_block_range(struct cache *cache, struct bio *bio,
 
 static void prevent_background_work(struct cache *cache)
 {
-	lockdep_off();
-	down_write(&cache->background_work_lock);
-	lockdep_on();
+	spin_lock_irq(&cache->background_work_lock);
+	cache->background_work_allowed = false;
+	wait_event_lock_irq(cache->background_work_wait,
+			    cache->background_work_nr == 0,
+			    cache->background_work_lock);
+	spin_unlock_irq(&cache->background_work_lock);
 }
 
 static void allow_background_work(struct cache *cache)
 {
-	lockdep_off();
-	up_write(&cache->background_work_lock);
-	lockdep_on();
+	spin_lock_irq(&cache->background_work_lock);
+	cache->background_work_allowed = true;
+	spin_unlock_irq(&cache->background_work_lock);
 }
 
 static bool background_work_begin(struct cache *cache)
 {
 	bool r;
 
-	lockdep_off();
-	r = down_read_trylock(&cache->background_work_lock);
-	lockdep_on();
-
+	spin_lock_irq(&cache->background_work_lock);
+	r = cache->background_work_allowed;
+	if (r)
+		cache->background_work_nr++;
+	spin_unlock_irq(&cache->background_work_lock);
 	return r;
 }
 
 static void background_work_end(struct cache *cache)
 {
-	lockdep_off();
-	up_read(&cache->background_work_lock);
-	lockdep_on();
+	spin_lock_irq(&cache->background_work_lock);
+	if (--cache->background_work_nr == 0)
+		wake_up(&cache->background_work_wait);
+	spin_unlock_irq(&cache->background_work_lock);
 }
 
 /*----------------------------------------------------------------*/
@@ -2507,9 +2508,7 @@ static int cache_create(struct cache_args *ca, struct cache **result)
 
 	spin_lock_init(&cache->lock);
 	bio_list_init(&cache->deferred_bios);
-	atomic_set(&cache->nr_allocated_migrations, 0);
 	atomic_set(&cache->nr_io_migrations, 0);
-	init_waitqueue_head(&cache->migration_wait);
 
 	r = -ENOMEM;
 	atomic_set(&cache->nr_dirty, 0);
@@ -2592,8 +2591,10 @@ static int cache_create(struct cache_args *ca, struct cache **result)
 		     issue_op, cache, cache->wq);
 	dm_iot_init(&cache->tracker);
 
-	init_rwsem(&cache->background_work_lock);
-	prevent_background_work(cache);
+	init_waitqueue_head(&cache->background_work_wait);
+	spin_lock_init(&cache->background_work_lock);
+	cache->background_work_allowed = false;
+	cache->background_work_nr = 0;
 
 	*result = cache;
 	return 0;
-- 
2.53.0

