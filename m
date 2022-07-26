Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2E7CC00144
	for <dm-devel@archiver.kernel.org>; Tue, 26 Jul 2022 16:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658851815;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=K5DUwoveCQMs5+9hanjldfB3UyUZBS1PVGgARBoXD+k=;
	b=DIgv+o1SF3LpHWzIceZ+5kD787BQE+y/AKEznMZApFL7Z2VcmytZ56jEW6PkpP1AD6ZV4Z
	owky1clShw35H04B7rvRs3hIHs9DTVmmecb9WeU3BEci+hbNgFyEcAStTXFkF3AVbJPgER
	EG1m4jEh1JbZgrJjzglKKZTSYuUgLfU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-607--HZfAIP-MV2yuzBVFaWT3g-1; Tue, 26 Jul 2022 12:10:12 -0400
X-MC-Unique: -HZfAIP-MV2yuzBVFaWT3g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C8AEC85A581;
	Tue, 26 Jul 2022 16:10:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B886018EA8;
	Tue, 26 Jul 2022 16:10:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8637C1945DAD;
	Tue, 26 Jul 2022 16:10:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id F288F1945DAA
 for <dm-devel@listman.corp.redhat.com>; Tue, 26 Jul 2022 16:10:07 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E3DDA2026D07; Tue, 26 Jul 2022 16:10:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E00312026D64
 for <dm-devel@redhat.com>; Tue, 26 Jul 2022 16:10:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AB1601857F06
 for <dm-devel@redhat.com>; Tue, 26 Jul 2022 16:10:07 +0000 (UTC)
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com
 [209.85.222.170]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-531-w3dYfIqaN3uGcOeYFU_Row-1; Tue, 26 Jul 2022 12:10:04 -0400
X-MC-Unique: w3dYfIqaN3uGcOeYFU_Row-1
Received: by mail-qk1-f170.google.com with SMTP id g1so11298726qki.7
 for <dm-devel@redhat.com>; Tue, 26 Jul 2022 09:10:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=H2qum5dZpDxE0Pe30VSsT0Affri5sshSkO6ZlSqCjGA=;
 b=Hun51vEZTgfsMihcN+D1fcbsyXg75mL5OClvLt0BacZECLGlapixML3pNpY2jChppD
 o/x3YTVfDX4lR0dq4CX+C/RS/SiUGaZa6I2arCTbR5ES8NLCNcwxUQN/oqf95EUNAmq2
 Uv4VesCSXDmvGvx6mpv/DAwZRsq0xDWJx541TtgEUcfO5/GIS1KF7ZU0hgIaYi9lNs5u
 6pFp7vMC/bc4PjlRSRaJiTpvf5JfZWm+WmzAPhjxbJi9Vdk7Z5M/Xm7tgFQFNeWmfSv+
 AWI+O1PbT0VHL2nABcodG30/9xFz3r1bhju0mGvMIVUTxXWsW69gaMJ2iJTTy8EhwHua
 htwg==
X-Gm-Message-State: AJIora9Q6D+T57PWYLVXUvB7H+Xg16d6Up/JQrBePwK6cUZ340H6h7S9
 /HQUSJItaZoeF1Y8200YVU2JBlc=
X-Google-Smtp-Source: AGRyM1svN5kL0mZeLpWYPx0NSpjhYLWS3Ib93ZDMAN17H9kQIBUoIIVmAfq2F29VaOWVKItYDT5otg==
X-Received: by 2002:a05:620a:4489:b0:6b6:1c1d:2fc1 with SMTP id
 x9-20020a05620a448900b006b61c1d2fc1mr13773672qkp.703.1658851803811; 
 Tue, 26 Jul 2022 09:10:03 -0700 (PDT)
Received: from localhost (pool-68-160-173-162.bstnma.fios.verizon.net.
 [68.160.173.162]) by smtp.gmail.com with ESMTPSA id
 s21-20020a05620a29d500b006b5cefa8877sm12008624qkp.105.2022.07.26.09.10.03
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 26 Jul 2022 09:10:03 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: Nathan Huckleberry <nhuck@google.com>, Eric Biggers <ebiggers@kernel.org>
Date: Tue, 26 Jul 2022 12:09:55 -0400
Message-Id: <20220726160959.89247-3-snitzer@kernel.org>
In-Reply-To: <20220726160959.89247-1-snitzer@kernel.org>
References: <20220726160959.89247-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: [dm-devel] [PATCH v2 2/6] dm bufio: Add DM_BUFIO_CLIENT_NO_SLEEP
 flag
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
Cc: dm-devel@redhat.com, Sami Tolvanen <samitolvanen@google.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Nathan Huckleberry <nhuck@google.com>

Add an optional flag that ensures dm_bufio_client does not sleep
(primary focus is to service dm_bufio_get without sleeping). This
allows the dm-bufio cache to be queried from interrupt context.

To ensure that dm-bufio does not sleep, dm-bufio must use a spinlock
instead of a mutex. Additionally, to avoid deadlocks, special care
must be taken so that dm-bufio does not sleep while holding the
spinlock.

But again: the scope of this no_sleep is initially confined to
dm_bufio_get, so __alloc_buffer_wait_no_callback is _not_ changed to
avoid sleeping because __bufio_new avoids allocation for NF_GET.

Signed-off-by: Nathan Huckleberry <nhuck@google.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-bufio.c    | 22 +++++++++++++++++++---
 include/linux/dm-bufio.h |  5 +++++
 2 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index ad5603eb12e3..486179d1831c 100644
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
+	bool no_sleep;
 
 	struct kmem_cache *slab_buffer;
 	struct kmem_cache *slab_cache;
@@ -167,17 +170,26 @@ struct dm_buffer {
 
 static void dm_bufio_lock(struct dm_bufio_client *c)
 {
-	mutex_lock_nested(&c->lock, dm_bufio_in_request());
+	if (c->no_sleep)
+		spin_lock_irqsave_nested(&c->spinlock, c->spinlock_flags, dm_bufio_in_request());
+	else
+		mutex_lock_nested(&c->lock, dm_bufio_in_request());
 }
 
 static int dm_bufio_trylock(struct dm_bufio_client *c)
 {
-	return mutex_trylock(&c->lock);
+	if (c->no_sleep)
+		return spin_trylock_irqsave(&c->spinlock, c->spinlock_flags);
+	else
+		return mutex_trylock(&c->lock);
 }
 
 static void dm_bufio_unlock(struct dm_bufio_client *c)
 {
-	mutex_unlock(&c->lock);
+	if (c->no_sleep)
+		spin_unlock_irqrestore(&c->spinlock, c->spinlock_flags);
+	else
+		mutex_unlock(&c->lock);
 }
 
 /*----------------------------------------------------------------*/
@@ -1748,12 +1760,16 @@ struct dm_bufio_client *dm_bufio_client_create(struct block_device *bdev, unsign
 	c->alloc_callback = alloc_callback;
 	c->write_callback = write_callback;
 
+	if (flags & DM_BUFIO_CLIENT_NO_SLEEP)
+		c->no_sleep = true;
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
index e21480715255..15d9e15ca830 100644
--- a/include/linux/dm-bufio.h
+++ b/include/linux/dm-bufio.h
@@ -17,6 +17,11 @@
 struct dm_bufio_client;
 struct dm_buffer;
 
+/*
+ * Flags for dm_bufio_client_create
+ */
+#define DM_BUFIO_CLIENT_NO_SLEEP 0x1
+
 /*
  * Create a buffered IO cache on a given device
  */
-- 
2.32.1 (Apple Git-133)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

