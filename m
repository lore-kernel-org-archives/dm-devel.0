Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A62E3064B
	for <dm-devel@lists.linux.dev>; Fri, 17 Nov 2023 17:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WjCNoQTu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700241677;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/svBxIG5pwZVgNOLV2M1jD8LhDYxTwLlFhJEi66yFmE=;
	b=WjCNoQTudlSwuAGviWKbq+rdeUsYXObKClkwsruj4Pdnam2mec+dn4N1x6w6VNQ+JenCRM
	y8plz46WvQ0lq+QgQDdzZR4hfRLv07dFP2rkRQ191EJ7OP5OaqXtCFbVGIj5ME+CtyWzz+
	e/4KoboMNGCOWCpw5lsh+eA5GBlLW0w=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-659-NfJvQNPYPvChRG5L-Z7lNQ-1; Fri,
 17 Nov 2023 12:21:14 -0500
X-MC-Unique: NfJvQNPYPvChRG5L-Z7lNQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4DDBD1C07550;
	Fri, 17 Nov 2023 17:21:14 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4838B492BFD;
	Fri, 17 Nov 2023 17:21:14 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 4028B30C1A8C; Fri, 17 Nov 2023 17:21:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 3F6CE3FB76;
	Fri, 17 Nov 2023 18:21:14 +0100 (CET)
Date: Fri, 17 Nov 2023 18:21:14 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Mike Snitzer <msnitzer@redhat.com>
cc: Christian Loehle <christian.loehle@arm.com>, 
    Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>, 
    Heinz Mauelshagen <heinzm@redhat.com>, dm-devel@lists.linux.dev
Subject: [PATCH 1/3] dm-delay: fix a race between delay_presuspend and
 delay_bio
In-Reply-To: <1b597cf-499b-a84c-fa5a-87a630987dff@redhat.com>
Message-ID: <59bf73d6-bee6-b734-b030-6872fea5b8d@redhat.com>
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

In delay_presuspend, we set the atomic variable may_delay and then stop
the timer and flush pending bios. The intention here is to prevent the
delay target from re-arming the timer again.

However, this test is racy. Suppose that one thread goes to delay_bio,
sees that dc->may_delay is one and proceeds; now, another theread executes
delay_presuspend, it sets, dc->may_delay to zero, deletes the timer and
flushes pending bios. Now, the first thread continues and adds the bio to
delayed->list despite the fact that dc->may_delay is false.

In order to fix this bug, we change may_delay's type from atomic_t to bool
and we read and write it only while holding the delayed_bios_lock mutex.
Note that we don't have to grab the mutex in delay_resume because there
are no bios in flight at this point.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/md/dm-delay.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

Index: linux-2.6/drivers/md/dm-delay.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-delay.c	2023-11-17 14:31:29.000000000 +0100
+++ linux-2.6/drivers/md/dm-delay.c	2023-11-17 14:55:10.000000000 +0100
@@ -33,7 +33,7 @@ struct delay_c {
 	struct work_struct flush_expired_bios;
 	struct list_head delayed_bios;
 	struct task_struct *worker;
-	atomic_t may_delay;
+	bool may_delay;
 
 	struct delay_class read;
 	struct delay_class write;
@@ -236,7 +236,7 @@ static int delay_ctr(struct dm_target *t
 
 	ti->private = dc;
 	INIT_LIST_HEAD(&dc->delayed_bios);
-	atomic_set(&dc->may_delay, 1);
+	dc->may_delay = true;
 	dc->argc = argc;
 
 	ret = delay_class_ctr(ti, &dc->read, argv);
@@ -312,7 +312,7 @@ static int delay_bio(struct delay_c *dc,
 	struct dm_delay_info *delayed;
 	unsigned long expires = 0;
 
-	if (!c->delay || !atomic_read(&dc->may_delay))
+	if (!c->delay)
 		return DM_MAPIO_REMAPPED;
 
 	delayed = dm_per_bio_data(bio, sizeof(struct dm_delay_info));
@@ -321,6 +321,10 @@ static int delay_bio(struct delay_c *dc,
 	delayed->expires = expires = jiffies + msecs_to_jiffies(c->delay);
 
 	mutex_lock(&delayed_bios_lock);
+	if (unlikely(!dc->may_delay)) {
+		mutex_unlock(&delayed_bios_lock);
+		return DM_MAPIO_REMAPPED;
+	}
 	c->ops++;
 	list_add_tail(&delayed->list, &dc->delayed_bios);
 	mutex_unlock(&delayed_bios_lock);
@@ -337,7 +341,9 @@ static void delay_presuspend(struct dm_t
 {
 	struct delay_c *dc = ti->private;
 
-	atomic_set(&dc->may_delay, 0);
+	mutex_lock(&delayed_bios_lock);
+	dc->may_delay = false;
+	mutex_unlock(&delayed_bios_lock);
 
 	if (delay_is_fast(dc))
 		flush_delayed_bios_fast(dc, true);
@@ -351,7 +357,7 @@ static void delay_resume(struct dm_targe
 {
 	struct delay_c *dc = ti->private;
 
-	atomic_set(&dc->may_delay, 1);
+	dc->may_delay = true;
 }
 
 static int delay_map(struct dm_target *ti, struct bio *bio)

