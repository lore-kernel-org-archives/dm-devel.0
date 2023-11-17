Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526EC37156
	for <dm-devel@lists.linux.dev>; Fri, 17 Nov 2023 17:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YR6rlV24"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700241771;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=akSitNKLbWt9+Ota8avJH6qbNCjA5IDrL/Ubpvqmkf0=;
	b=YR6rlV24MPJRh0qeCqsZrIaGngCRx77NNK/9gKRQt7LrhsebvRu7DKVi64KEJzAoNiofej
	8XC8ANf7LspOTaeVzw4Nz0nkeRr1R+UWFi6MN9241i0asdo56sametB7lfwCd16DbDEl0Q
	BBQmpwBga/AImWcQs5Yg55kBjiSkn74=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-659-xKXKar40PXmRiMAdffv2vQ-1; Fri, 17 Nov 2023 12:22:48 -0500
X-MC-Unique: xKXKar40PXmRiMAdffv2vQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A242A8007B3;
	Fri, 17 Nov 2023 17:22:47 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9C85B5028;
	Fri, 17 Nov 2023 17:22:47 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 964A630C1A8C; Fri, 17 Nov 2023 17:22:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 954CB3FB76;
	Fri, 17 Nov 2023 18:22:47 +0100 (CET)
Date: Fri, 17 Nov 2023 18:22:47 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Mike Snitzer <msnitzer@redhat.com>
cc: Christian Loehle <christian.loehle@arm.com>, 
    Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>, 
    Heinz Mauelshagen <heinzm@redhat.com>, dm-devel@lists.linux.dev
Subject: [PATCH 2/3] dm-delay: fix bugs in kthread mode
In-Reply-To: <1b597cf-499b-a84c-fa5a-87a630987dff@redhat.com>
Message-ID: <c7b866fc-c18-8ae7-7149-5a48740ff3c@redhat.com>
References: <1b597cf-499b-a84c-fa5a-87a630987dff@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

The patch 70bbeb29fab0 broke dm-delay seriously. It introduced the
following bugs:

* the function flush_worker_fn has no exit path - on unload, this function
  will just loop and consume 100% CPU without any progress

* the wake-up mechanism in flush_worker_fn is racy - a wake up will be
  missed if the process adds entries to the delayed_bios list just before
  set_current_state(TASK_INTERRUPTIBLE)

* flush_delayed_bios_fast submits a bio while holding a global mutex; this
  may deadlock if we have multiple stacked dm-delay devices and the
  underlying device attempts to acquire the mutex too

* if the target constructor fails, it will call delay_dtr. delay_dtr would
  attempt to free dc->timer_lock without it being initialized by the
  constructor; if kthread allocation fails, delay_dtr would crash trying
  to dereference dc->worker because it would ontain error code

This commit fixes these bugs.

Fixes: 70bbeb29fab0 ("dm delay: for short delays, use kthread instead of timers and wq")
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-delay.c |   61 ++++++++++++++++++++++++++++----------------------
 1 file changed, 35 insertions(+), 26 deletions(-)

Index: linux-2.6/drivers/md/dm-delay.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-delay.c	2023-11-17 14:57:26.000000000 +0100
+++ linux-2.6/drivers/md/dm-delay.c	2023-11-17 14:58:44.000000000 +0100
@@ -73,9 +73,23 @@ static inline bool delay_is_fast(struct
 	return !!dc->worker;
 }
 
+static void flush_bios(struct bio *bio)
+{
+	struct bio *n;
+
+	while (bio) {
+		n = bio->bi_next;
+		bio->bi_next = NULL;
+		dm_submit_bio_remap(bio, NULL);
+		bio = n;
+	}
+}
+
 static void flush_delayed_bios_fast(struct delay_c *dc, bool flush_all)
 {
 	struct dm_delay_info *delayed, *next;
+	struct bio_list flush_bio_list;
+	bio_list_init(&flush_bio_list);
 
 	mutex_lock(&delayed_bios_lock);
 	list_for_each_entry_safe(delayed, next, &dc->delayed_bios, list) {
@@ -83,47 +97,42 @@ static void flush_delayed_bios_fast(stru
 			struct bio *bio = dm_bio_from_per_bio_data(delayed,
 						sizeof(struct dm_delay_info));
 			list_del(&delayed->list);
-			dm_submit_bio_remap(bio, NULL);
+			bio_list_add(&flush_bio_list, bio);
 			delayed->class->ops--;
 		}
 	}
 	mutex_unlock(&delayed_bios_lock);
+
+	flush_bios(bio_list_get(&flush_bio_list));
 }
 
 static int flush_worker_fn(void *data)
 {
 	struct delay_c *dc = data;
 
-	while (1) {
+	while (!kthread_should_stop()) {
 		flush_delayed_bios_fast(dc, false);
+		mutex_lock(&delayed_bios_lock);
 		if (unlikely(list_empty(&dc->delayed_bios))) {
 			set_current_state(TASK_INTERRUPTIBLE);
+			mutex_unlock(&delayed_bios_lock);
 			schedule();
-		} else
+		} else {
+			mutex_unlock(&delayed_bios_lock);
 			cond_resched();
+		}
 	}
 
 	return 0;
 }
 
-static void flush_bios(struct bio *bio)
-{
-	struct bio *n;
-
-	while (bio) {
-		n = bio->bi_next;
-		bio->bi_next = NULL;
-		dm_submit_bio_remap(bio, NULL);
-		bio = n;
-	}
-}
-
-static struct bio *flush_delayed_bios(struct delay_c *dc, bool flush_all)
+static void flush_delayed_bios(struct delay_c *dc, bool flush_all)
 {
 	struct dm_delay_info *delayed, *next;
 	unsigned long next_expires = 0;
 	unsigned long start_timer = 0;
-	struct bio_list flush_bios = { };
+	struct bio_list flush_bio_list;
+	bio_list_init(&flush_bio_list);
 
 	mutex_lock(&delayed_bios_lock);
 	list_for_each_entry_safe(delayed, next, &dc->delayed_bios, list) {
@@ -131,7 +140,7 @@ static struct bio *flush_delayed_bios(st
 			struct bio *bio = dm_bio_from_per_bio_data(delayed,
 						sizeof(struct dm_delay_info));
 			list_del(&delayed->list);
-			bio_list_add(&flush_bios, bio);
+			bio_list_add(&flush_bio_list, bio);
 			delayed->class->ops--;
 			continue;
 		}
@@ -147,7 +156,7 @@ static struct bio *flush_delayed_bios(st
 	if (start_timer)
 		queue_timeout(dc, next_expires);
 
-	return bio_list_get(&flush_bios);
+	flush_bios(bio_list_get(&flush_bio_list));
 }
 
 static void flush_expired_bios(struct work_struct *work)
@@ -158,7 +167,7 @@ static void flush_expired_bios(struct wo
 	if (delay_is_fast(dc))
 		flush_delayed_bios_fast(dc, false);
 	else
-		flush_bios(flush_delayed_bios(dc, false));
+		flush_delayed_bios(dc, false);
 }
 
 static void delay_dtr(struct dm_target *ti)
@@ -177,8 +186,7 @@ static void delay_dtr(struct dm_target *
 	if (dc->worker)
 		kthread_stop(dc->worker);
 
-	if (!delay_is_fast(dc))
-		mutex_destroy(&dc->timer_lock);
+	mutex_destroy(&dc->timer_lock);
 
 	kfree(dc);
 }
@@ -236,6 +244,7 @@ static int delay_ctr(struct dm_target *t
 
 	ti->private = dc;
 	INIT_LIST_HEAD(&dc->delayed_bios);
+	mutex_init(&dc->timer_lock);
 	dc->may_delay = true;
 	dc->argc = argc;
 
@@ -282,12 +291,12 @@ out:
 					    "dm-delay-flush-worker");
 		if (IS_ERR(dc->worker)) {
 			ret = PTR_ERR(dc->worker);
+			dc->worker = NULL;
 			goto bad;
 		}
 	} else {
 		timer_setup(&dc->delay_timer, handle_delayed_timer, 0);
 		INIT_WORK(&dc->flush_expired_bios, flush_expired_bios);
-		mutex_init(&dc->timer_lock);
 		dc->kdelayd_wq = alloc_workqueue("kdelayd", WQ_MEM_RECLAIM, 0);
 		if (!dc->kdelayd_wq) {
 			ret = -EINVAL;
@@ -345,11 +354,11 @@ static void delay_presuspend(struct dm_t
 	dc->may_delay = false;
 	mutex_unlock(&delayed_bios_lock);
 
-	if (delay_is_fast(dc))
+	if (delay_is_fast(dc)) {
 		flush_delayed_bios_fast(dc, true);
-	else {
+	} else {
 		del_timer_sync(&dc->delay_timer);
-		flush_bios(flush_delayed_bios(dc, true));
+		flush_delayed_bios(dc, true);
 	}
 }
 

