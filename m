Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25627C43334
	for <dm-devel@archiver.kernel.org>; Fri, 22 Jul 2022 18:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658514434;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=f3O9SumJk4b1Y9VrClPqmeWhkzdo592BnIqPRVp2Qkw=;
	b=Ta9mmxh5r/M1NsuT1NSRT+lPLLUSSarVO7TJLo9BQYH0sc9tamBAGfZSkhhWTmPz7dU64f
	I4lwbeVXpo/7X7fsQNScmDVM0007wdAPXkR1t/coL/4+qiuUKYQjf5Xxgg4IxGchKgDnIB
	Hi1aDaQz46Whv89QoP+JW3yIwBOtq84=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-206-rxia32I0On6wRlXVXb8kRw-1; Fri, 22 Jul 2022 14:27:09 -0400
X-MC-Unique: rxia32I0On6wRlXVXb8kRw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 87B673C11E71;
	Fri, 22 Jul 2022 18:27:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7575D492CA6;
	Fri, 22 Jul 2022 18:27:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A305E1947057;
	Fri, 22 Jul 2022 18:27:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 564F3194704F
 for <dm-devel@listman.corp.redhat.com>; Fri, 22 Jul 2022 09:38:54 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4BECE2166B26; Fri, 22 Jul 2022 09:38:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 47EA12166B2A
 for <dm-devel@redhat.com>; Fri, 22 Jul 2022 09:38:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 294BC3802AC2
 for <dm-devel@redhat.com>; Fri, 22 Jul 2022 09:38:54 +0000 (UTC)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-411-GctjHE4uPSa72mFoZgAZSg-1; Fri, 22 Jul 2022 05:38:52 -0400
X-MC-Unique: GctjHE4uPSa72mFoZgAZSg-1
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-31cdce3ed04so35620087b3.13
 for <dm-devel@redhat.com>; Fri, 22 Jul 2022 02:38:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=0HvoRxN2Vq0/Bi3xt58hq8m4jj9hpFn+i7fw2drMGQc=;
 b=eBI3yr7SX7x78Gm78eZyff6OUML+BWaKTsO5+N7TQ2F5+M5Lzr9Wabtul/8Te3T6jZ
 FQr3a1RpJN28Y2+C5Y0T8M4obV6KO3coxiZXgBttMxVGuFYIkFZ3Xbv5F9h4LLI3E3st
 aWzgELCMgk9RTNN1lDSenCN9HVVP6ea2n0hYtSDdWveeuT6qqmUIDf4a+HD0/EkSBD4s
 LnS+Ll+/CRX8fYanX3wRkqMqx8HK9yaoekbtf7w/D2+9bZoBTOvRkQMjzS+G8gNOwrTh
 ucR6gDG5qG5jp85AiZM9Pz7es/ZD6tjkpaYExPJReUhB7gqKTxpRtnQIts/VFlcOzSmg
 kgKw==
X-Gm-Message-State: AJIora8ww4osk5oj9zt1fMng+XY4ukW4bB1/sALI8JusXvz1rzG3khUT
 xZwrtzCsQm4PpFxfSTZ3RjwuFrZmuw==
X-Google-Smtp-Source: AGRyM1vrqyRWf0OgG6fTxyUyuG16olDyk74u0WLdD/aZC47eoaJHVQNRfVoKKDTJI4OkFZyLIEFXkpH0+Q==
X-Received: from nhuck.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:39cc])
 (user=nhuck job=sendgmr) by 2002:a25:fc21:0:b0:670:8160:a9f9 with
 SMTP id
 v33-20020a25fc21000000b006708160a9f9mr2134064ybd.513.1658482731701; Fri, 22
 Jul 2022 02:38:51 -0700 (PDT)
Date: Fri, 22 Jul 2022 09:38:22 +0000
In-Reply-To: <20220722093823.4158756-1-nhuck@google.com>
Message-Id: <20220722093823.4158756-3-nhuck@google.com>
Mime-Version: 1.0
References: <20220722093823.4158756-1-nhuck@google.com>
From: Nathan Huckleberry <nhuck@google.com>
To: linux-kernel@vger.kernel.org, dm-devel@redhat.com, 
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Mailman-Approved-At: Fri, 22 Jul 2022 18:27:03 +0000
Subject: [dm-devel] [PATCH 2/3] dm-bufio: Add DM_BUFIO_GET_CANT_SLEEP
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: Eric Biggers <ebiggers@kernel.org>, Sami Tolvanen <samitolvanen@google.com>,
 Nathan Huckleberry <nhuck@google.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Add an optional flag that ensures dm_bufio_get does not sleep.  This
allows the dm-bufio cache to be queried from interrupt context.

To ensure that dm-bufio does not sleep, dm-bufio must use a spinlock
instead of a mutex.  Additionally, to avoid deadlocks, special care must
be taken so that dm-bufio does not sleep while holding the spinlock.

DM_BUFIO_GET_CANT_SLEEP is useful in some contexts, such as dm-verity,
so that we can query the dm-bufio cache in a tasklet.  If the required
data is cached, processing can be handled immediately in the tasklet
instead of waiting for a work-queue job to be scheduled.  This can
reduce latency when there is high CPU load and memory pressure.

Signed-off-by: Nathan Huckleberry <nhuck@google.com>
---
 drivers/md/dm-bufio.c    | 26 ++++++++++++++++++++++----
 include/linux/dm-bufio.h |  5 +++++
 2 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index ad5603eb12e3..3edeca7cfca6 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -81,6 +81,8 @@
  */
 struct dm_bufio_client {
 	struct mutex lock;
+	spinlock_t spinlock;
+	unsigned long spinlock_flags;
 
 	struct list_head lru[LIST_SIZE];
 	unsigned long n_buffers[LIST_SIZE];
@@ -90,6 +92,7 @@ struct dm_bufio_client {
 	s8 sectors_per_block_bits;
 	void (*alloc_callback)(struct dm_buffer *);
 	void (*write_callback)(struct dm_buffer *);
+	bool may_sleep;
 
 	struct kmem_cache *slab_buffer;
 	struct kmem_cache *slab_cache;
@@ -167,17 +170,26 @@ struct dm_buffer {
 
 static void dm_bufio_lock(struct dm_bufio_client *c)
 {
-	mutex_lock_nested(&c->lock, dm_bufio_in_request());
+	if (c->may_sleep)
+		mutex_lock_nested(&c->lock, dm_bufio_in_request());
+	else
+		spin_lock_irqsave_nested(&c->spinlock, c->spinlock_flags, dm_bufio_in_request());
 }
 
 static int dm_bufio_trylock(struct dm_bufio_client *c)
 {
-	return mutex_trylock(&c->lock);
+	if (c->may_sleep)
+		return mutex_trylock(&c->lock);
+	else
+		return spin_trylock_irqsave(&c->spinlock, c->spinlock_flags);
 }
 
 static void dm_bufio_unlock(struct dm_bufio_client *c)
 {
-	mutex_unlock(&c->lock);
+	if (c->may_sleep)
+		mutex_unlock(&c->lock);
+	else
+		spin_unlock_irqrestore(&c->spinlock, c->spinlock_flags);
 }
 
 /*----------------------------------------------------------------*/
@@ -878,7 +890,7 @@ static struct dm_buffer *__alloc_buffer_wait_no_callback(struct dm_bufio_client
 	 * be allocated.
 	 */
 	while (1) {
-		if (dm_bufio_cache_size_latch != 1) {
+		if (dm_bufio_cache_size_latch != 1 && c->may_sleep) {
 			b = alloc_buffer(c, GFP_NOWAIT | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN);
 			if (b)
 				return b;
@@ -1041,6 +1053,7 @@ static struct dm_buffer *__bufio_new(struct dm_bufio_client *c, sector_t block,
 	if (nf == NF_GET && unlikely(test_bit(B_READING, &b->state)))
 		return NULL;
 
+
 	b->hold_count++;
 	__relink_lru(b, test_bit(B_DIRTY, &b->state) ||
 		     test_bit(B_WRITING, &b->state));
@@ -1748,12 +1761,17 @@ struct dm_bufio_client *dm_bufio_client_create(struct block_device *bdev, unsign
 	c->alloc_callback = alloc_callback;
 	c->write_callback = write_callback;
 
+	c->may_sleep = true;
+	if (flags & DM_BUFIO_GET_CANT_SLEEP)
+		c->may_sleep = false;
+
 	for (i = 0; i < LIST_SIZE; i++) {
 		INIT_LIST_HEAD(&c->lru[i]);
 		c->n_buffers[i] = 0;
 	}
 
 	mutex_init(&c->lock);
+	spin_lock_init(&c->spinlock);
 	INIT_LIST_HEAD(&c->reserved_buffers);
 	c->need_reserved_buffers = reserved_buffers;
 
diff --git a/include/linux/dm-bufio.h b/include/linux/dm-bufio.h
index e21480715255..2a78f0cb8e71 100644
--- a/include/linux/dm-bufio.h
+++ b/include/linux/dm-bufio.h
@@ -17,6 +17,11 @@
 struct dm_bufio_client;
 struct dm_buffer;
 
+/*
+ * Flags for dm_bufio_client_create
+ */
+#define DM_BUFIO_GET_CANT_SLEEP 0x1
+
 /*
  * Create a buffered IO cache on a given device
  */
-- 
2.37.1.359.gd136c6c3e2-goog

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

