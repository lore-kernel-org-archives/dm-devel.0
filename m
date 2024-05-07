Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22BA87352D
	for <dm-devel@lists.linux.dev>; Tue,  7 May 2024 21:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715116592; cv=none; b=tq2D9MtKjQ0aPBcl7Hc5LHCoGJ+TcwzG3QXsH4FWBzLmp3zg0hwkb4z6wpu8AyMPLXEYS3GFBUQHAk94AqAysRntWNiU1ZwqeSyS+xRZU3BD9qwDQ1Jq+A5pJOCfl9hPeGvxyBqfvmJZLmjgvUzeTr1kNxYKslGJeZJ725VInaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715116592; c=relaxed/simple;
	bh=kpdSD4YBDB8gVEUZFdAgCUOBMmpPEsXqE71PnBjmKJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FPJKn1H8CZy6RWBup2W1e3dRWhpCN117Kg529VWzl6DeREduRH4RAMPjDwbz2ACRrSQ7FQ88N7Qi2NnBDl7SiZ4DfP5ILsFY/hz1aqf6XMDDVzsLQ1O2CdOo3L92bQpfViPkb2Z3vByoGJZfy9KMaYkWf2fN6X9MMUn3kK64APE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ISsjKACS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ISsjKACS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715116590;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=viJ0FnYpRARWgaxLJ8zaNSguwPjZ1WcsErTMD6kXzh8=;
	b=ISsjKACSvgo6Lfw+P5jLnCvJXb3T8IuyOrXTj2bqf0dIC84HV4dvokgPMgRab1VVtZQtJ+
	7Yn/FLE/cuWyc54AIGemul0Nt8V1dUPBl6R0geX1Zmyizwgo/JPTzJOvTYCxaqotbRa/yE
	GmfKzcDkVQ1h76LIdwnv6hm6X11RGEU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-596-yovydOzbN4-cE53GBsvFJg-1; Tue, 07 May 2024 17:16:27 -0400
X-MC-Unique: yovydOzbN4-cE53GBsvFJg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D296A101A54F;
	Tue,  7 May 2024 21:16:26 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 906FC201E72F;
	Tue,  7 May 2024 21:16:26 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 447LGQ2g026726
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 7 May 2024 17:16:26 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 447LGQ5L026725;
	Tue, 7 May 2024 17:16:26 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
        Heinz Mauelshagen <mauelshagen@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 2/3] dm-delay: change locking to avoid contention
Date: Tue,  7 May 2024 17:16:24 -0400
Message-ID: <20240507211626.26706-3-bmarzins@redhat.com>
In-Reply-To: <20240507211626.26706-1-bmarzins@redhat.com>
References: <20240507211626.26706-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

The delayed_bios list is protected by one mutex shared by all dm-delay
devices. This mutex must be held whenever a bio is added or expired bios
are removed from the list.  Since a large number of expired bios could
be on the list, flush_delayed_bios() can schedule while holding the
mutex. This means a flush_delayed_bios() call on any dm-delay device can
slow down delay_map() calls on any other dm-delay device.

To keep dm-delay devices from slowing each other down and keep
processing delay bios from slowing adding delayed bios, the global mutex
has been removed, and each dm-delay device now has two locks.
delayed_bios_lock is a spinlock that must be held whenever the
delayed_bios list is accessed. process_bios_lock is a mutex that must be
held whenever a process has temporarily pulled bios off the delayed_bios
list to check which ones should be processed. It must be held until all
the bios that won't be processed are returned to the list. This is what
flush_delayed_bios() now does. The mutex is necessary to guarantee that
delay_presuspend() sees the entire list of delayed bios when it calls
flush_delayed_bios().

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 drivers/md/dm-delay.c | 36 +++++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 13 deletions(-)

diff --git a/drivers/md/dm-delay.c b/drivers/md/dm-delay.c
index 584e3b10802d..b1829c106a37 100644
--- a/drivers/md/dm-delay.c
+++ b/drivers/md/dm-delay.c
@@ -29,6 +29,8 @@ struct delay_class {
 struct delay_c {
 	struct timer_list delay_timer;
 	struct mutex timer_lock;
+	struct mutex process_bios_lock; /* hold while removing bios to be processed from list */
+	spinlock_t delayed_bios_lock; /* hold on all accesses to delayed_bios list */
 	struct workqueue_struct *kdelayd_wq;
 	struct work_struct flush_expired_bios;
 	struct list_head delayed_bios;
@@ -49,8 +51,6 @@ struct dm_delay_info {
 	unsigned long expires;
 };
 
-static DEFINE_MUTEX(delayed_bios_lock);
-
 static void handle_delayed_timer(struct timer_list *t)
 {
 	struct delay_c *dc = from_timer(dc, t, delay_timer);
@@ -89,12 +89,16 @@ static void flush_delayed_bios(struct delay_c *dc, bool flush_all)
 {
 	struct dm_delay_info *delayed, *next;
 	struct bio_list flush_bio_list;
+	LIST_HEAD(local_list);
 	unsigned long next_expires = 0;
 	bool start_timer = false;
 	bio_list_init(&flush_bio_list);
 
-	mutex_lock(&delayed_bios_lock);
-	list_for_each_entry_safe(delayed, next, &dc->delayed_bios, list) {
+	mutex_lock(&dc->process_bios_lock);
+	spin_lock(&dc->delayed_bios_lock);
+	list_replace_init(&dc->delayed_bios, &local_list);
+	spin_unlock(&dc->delayed_bios_lock);
+	list_for_each_entry_safe(delayed, next, &local_list, list) {
 		cond_resched();
 		if (flush_all || time_after_eq(jiffies, delayed->expires)) {
 			struct bio *bio = dm_bio_from_per_bio_data(delayed,
@@ -114,7 +118,10 @@ static void flush_delayed_bios(struct delay_c *dc, bool flush_all)
 			}
 		}
 	}
-	mutex_unlock(&delayed_bios_lock);
+	spin_lock(&dc->delayed_bios_lock);
+	list_splice(&local_list, &dc->delayed_bios);
+	spin_unlock(&dc->delayed_bios_lock);
+	mutex_unlock(&dc->process_bios_lock);
 
 	if (start_timer)
 		queue_timeout(dc, next_expires);
@@ -128,13 +135,13 @@ static int flush_worker_fn(void *data)
 
 	while (!kthread_should_stop()) {
 		flush_delayed_bios(dc, false);
-		mutex_lock(&delayed_bios_lock);
+		spin_lock(&dc->delayed_bios_lock);
 		if (unlikely(list_empty(&dc->delayed_bios))) {
 			set_current_state(TASK_INTERRUPTIBLE);
-			mutex_unlock(&delayed_bios_lock);
+			spin_unlock(&dc->delayed_bios_lock);
 			schedule();
 		} else {
-			mutex_unlock(&delayed_bios_lock);
+			spin_unlock(&dc->delayed_bios_lock);
 			cond_resched();
 		}
 	}
@@ -168,6 +175,7 @@ static void delay_dtr(struct dm_target *ti)
 	if (dc->worker)
 		kthread_stop(dc->worker);
 
+	mutex_destroy(&dc->process_bios_lock);
 	mutex_destroy(&dc->timer_lock);
 
 	kfree(dc);
@@ -227,6 +235,8 @@ static int delay_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	ti->private = dc;
 	INIT_LIST_HEAD(&dc->delayed_bios);
 	mutex_init(&dc->timer_lock);
+	mutex_init(&dc->process_bios_lock);
+	spin_lock_init(&dc->delayed_bios_lock);
 	dc->may_delay = true;
 	dc->argc = argc;
 
@@ -310,14 +320,14 @@ static int delay_bio(struct delay_c *dc, struct delay_class *c, struct bio *bio)
 	delayed->context = dc;
 	delayed->expires = expires = jiffies + msecs_to_jiffies(c->delay);
 
-	mutex_lock(&delayed_bios_lock);
+	spin_lock(&dc->delayed_bios_lock);
 	if (unlikely(!dc->may_delay)) {
-		mutex_unlock(&delayed_bios_lock);
+		spin_unlock(&dc->delayed_bios_lock);
 		return DM_MAPIO_REMAPPED;
 	}
 	c->ops++;
 	list_add_tail(&delayed->list, &dc->delayed_bios);
-	mutex_unlock(&delayed_bios_lock);
+	spin_unlock(&dc->delayed_bios_lock);
 
 	if (delay_is_fast(dc))
 		wake_up_process(dc->worker);
@@ -331,9 +341,9 @@ static void delay_presuspend(struct dm_target *ti)
 {
 	struct delay_c *dc = ti->private;
 
-	mutex_lock(&delayed_bios_lock);
+	spin_lock(&dc->delayed_bios_lock);
 	dc->may_delay = false;
-	mutex_unlock(&delayed_bios_lock);
+	spin_unlock(&dc->delayed_bios_lock);
 
 	if (!delay_is_fast(dc))
 		timer_delete(&dc->delay_timer);
-- 
2.45.0

