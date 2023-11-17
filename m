Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F6FE43169
	for <dm-devel@lists.linux.dev>; Fri, 17 Nov 2023 17:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Cra4hoJu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700241846;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Wt+SecLF7nx5ePC+29irv0jID34DtsxhiTuRCMTcj40=;
	b=Cra4hoJuf3ruFmgCySyKxhfOL3Vh/rTJj038cqXZRXkz5YieWEfUN/Qpm9NIRmcXsat0WF
	PnML+Ey5tf3Yl+9iZg8FX4q5d1cxFB7hUO6EnxNlS3GJ9hOIw21fYvx8aK5pKpxsyBs8jH
	OlWkdrcXucCxojiUn3DF67BTJG2hF40=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-108-4R5rkW6nMsGOBrdAx8AR7g-1; Fri, 17 Nov 2023 12:24:04 -0500
X-MC-Unique: 4R5rkW6nMsGOBrdAx8AR7g-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5CC178007B3;
	Fri, 17 Nov 2023 17:24:04 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 56F49492BFD;
	Fri, 17 Nov 2023 17:24:04 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 5043530C1A8C; Fri, 17 Nov 2023 17:24:04 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 4F6793FB76;
	Fri, 17 Nov 2023 18:24:04 +0100 (CET)
Date: Fri, 17 Nov 2023 18:24:04 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Mike Snitzer <msnitzer@redhat.com>
cc: Christian Loehle <christian.loehle@arm.com>, 
    Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>, 
    Heinz Mauelshagen <heinzm@redhat.com>, dm-devel@lists.linux.dev
Subject: [PATCH 3/3] dm-delay: avoid duplicate logic
In-Reply-To: <1b597cf-499b-a84c-fa5a-87a630987dff@redhat.com>
Message-ID: <d2eb1d8f-deaf-ca8f-5d92-47c38e53db18@redhat.com>
References: <1b597cf-499b-a84c-fa5a-87a630987dff@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

This is small refactoring of dm-delay - we avoid duplicate logic in
flush_delayed_bios and flush_delayed_bios_fast and join these two
functions into one.

We also add cond_resched() to flush_delayed_bios because the list may have
unbounded number of entries.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-delay.c |   65 ++++++++++++++++----------------------------------
 1 file changed, 21 insertions(+), 44 deletions(-)

Index: linux-2.6/drivers/md/dm-delay.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-delay.c	2023-11-17 16:11:47.000000000 +0100
+++ linux-2.6/drivers/md/dm-delay.c	2023-11-17 16:17:41.000000000 +0100
@@ -85,24 +85,40 @@ static void flush_bios(struct bio *bio)
 	}
 }
 
-static void flush_delayed_bios_fast(struct delay_c *dc, bool flush_all)
+static void flush_delayed_bios(struct delay_c *dc, bool flush_all)
 {
 	struct dm_delay_info *delayed, *next;
 	struct bio_list flush_bio_list;
+	unsigned long next_expires = 0;
+	bool start_timer = false;
 	bio_list_init(&flush_bio_list);
 
 	mutex_lock(&delayed_bios_lock);
 	list_for_each_entry_safe(delayed, next, &dc->delayed_bios, list) {
+		cond_resched();
 		if (flush_all || time_after_eq(jiffies, delayed->expires)) {
 			struct bio *bio = dm_bio_from_per_bio_data(delayed,
 						sizeof(struct dm_delay_info));
 			list_del(&delayed->list);
 			bio_list_add(&flush_bio_list, bio);
 			delayed->class->ops--;
+			continue;
+		}
+
+		if (!delay_is_fast(dc)) {
+			if (!start_timer) {
+				start_timer = true;
+				next_expires = delayed->expires;
+			} else {
+				next_expires = min(next_expires, delayed->expires);
+			}
 		}
 	}
 	mutex_unlock(&delayed_bios_lock);
 
+	if (start_timer)
+		queue_timeout(dc, next_expires);
+
 	flush_bios(bio_list_get(&flush_bio_list));
 }
 
@@ -111,7 +127,7 @@ static int flush_worker_fn(void *data)
 	struct delay_c *dc = data;
 
 	while (!kthread_should_stop()) {
-		flush_delayed_bios_fast(dc, false);
+		flush_delayed_bios(dc, false);
 		mutex_lock(&delayed_bios_lock);
 		if (unlikely(list_empty(&dc->delayed_bios))) {
 			set_current_state(TASK_INTERRUPTIBLE);
@@ -126,48 +142,12 @@ static int flush_worker_fn(void *data)
 	return 0;
 }
 
-static void flush_delayed_bios(struct delay_c *dc, bool flush_all)
-{
-	struct dm_delay_info *delayed, *next;
-	unsigned long next_expires = 0;
-	unsigned long start_timer = 0;
-	struct bio_list flush_bio_list;
-	bio_list_init(&flush_bio_list);
-
-	mutex_lock(&delayed_bios_lock);
-	list_for_each_entry_safe(delayed, next, &dc->delayed_bios, list) {
-		if (flush_all || time_after_eq(jiffies, delayed->expires)) {
-			struct bio *bio = dm_bio_from_per_bio_data(delayed,
-						sizeof(struct dm_delay_info));
-			list_del(&delayed->list);
-			bio_list_add(&flush_bio_list, bio);
-			delayed->class->ops--;
-			continue;
-		}
-
-		if (!start_timer) {
-			start_timer = 1;
-			next_expires = delayed->expires;
-		} else
-			next_expires = min(next_expires, delayed->expires);
-	}
-	mutex_unlock(&delayed_bios_lock);
-
-	if (start_timer)
-		queue_timeout(dc, next_expires);
-
-	flush_bios(bio_list_get(&flush_bio_list));
-}
-
 static void flush_expired_bios(struct work_struct *work)
 {
 	struct delay_c *dc;
 
 	dc = container_of(work, struct delay_c, flush_expired_bios);
-	if (delay_is_fast(dc))
-		flush_delayed_bios_fast(dc, false);
-	else
-		flush_delayed_bios(dc, false);
+	flush_delayed_bios(dc, false);
 }
 
 static void delay_dtr(struct dm_target *ti)
@@ -354,12 +334,9 @@ static void delay_presuspend(struct dm_t
 	dc->may_delay = false;
 	mutex_unlock(&delayed_bios_lock);
 
-	if (delay_is_fast(dc)) {
-		flush_delayed_bios_fast(dc, true);
-	} else {
+	if (!delay_is_fast(dc))
 		del_timer_sync(&dc->delay_timer);
-		flush_delayed_bios(dc, true);
-	}
+	flush_delayed_bios(dc, true);
 }
 
 static void delay_resume(struct dm_target *ti)

