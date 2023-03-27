Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60271C77B60
	for <dm-devel@archiver.kernel.org>; Mon, 27 Mar 2023 20:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679948026;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=EnaoKPkU00S/nGjKbG7I0LQ15J/reY0+x1A1eiH0Sg0=;
	b=DednicIwBsx3u7yfp8CrbgLj2cmNm53E7Mjn0zXE2t08upLVd8gUV3jGGB4O1E2q7RJuh+
	Ly0V6VBL9puOTKGsDSLqVurOYXDeq5eAvflhKXKkozl3KOeFel0uM7C8iOGGRGz2Yb8Xot
	dRqCoIfvjAETVQkEUlOdVQOBR/txYrU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-158-41s3GkvRPFm4VuFB2AbRPg-1; Mon, 27 Mar 2023 16:13:45 -0400
X-MC-Unique: 41s3GkvRPFm4VuFB2AbRPg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D8EEF8030DC;
	Mon, 27 Mar 2023 20:13:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C92DF2166B2C;
	Mon, 27 Mar 2023 20:13:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5758E19472D5;
	Mon, 27 Mar 2023 20:13:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1242319472C0
 for <dm-devel@listman.corp.redhat.com>; Mon, 27 Mar 2023 20:13:29 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id F29B6C15BC0; Mon, 27 Mar 2023 20:13:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E9EE6C15BB8
 for <dm-devel@redhat.com>; Mon, 27 Mar 2023 20:13:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CD7178030D4
 for <dm-devel@redhat.com>; Mon, 27 Mar 2023 20:13:23 +0000 (UTC)
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com
 [209.85.160.169]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-635-nVRgXkYDN2O0u4rT7lsyyg-4; Mon, 27 Mar 2023 16:13:22 -0400
X-MC-Unique: nVRgXkYDN2O0u4rT7lsyyg-4
Received: by mail-qt1-f169.google.com with SMTP id r5so9815620qtp.4
 for <dm-devel@redhat.com>; Mon, 27 Mar 2023 13:13:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1679948002;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=H9SedxOrdczzTjA4k7blz5Fc7tZ0dfZriRfxA3Ti63I=;
 b=GHkkZl1TJGviCj9GpGjmws8eIrwgGzZaRUUGlVC37zihemsnXvU7stcmqzToYM0fn7
 ND18ro8NTjXNyGw41Y31fdY6Xhle56EF6V97o5rJlNAwGmL3+mo8Q5OA7nujbrr9OKyC
 pR9WjTu9XPpKiuwfy9kc3a3UxMTtIrvP6t0om5MCYRIhwDDTF9kMBnLZWVNWxdLMjPlT
 SY1JGsxK6rJwBrooCfZtr0otWHggwHv+NZ/nPNTZyVwGb+iVmHJGl+FnBVuO6HcQ5NPi
 Oe1IIUpDygD/ulL49l+PjZIyYkTmVVuj6KTBeNAtNRMQezBrPwfGN/RynyXQ5icUYXGU
 G50g==
X-Gm-Message-State: AO0yUKUDU64K5IjvCKMVrpwJggBFw09t0YclNRRzrZlktapLD0SzcUAO
 iIMJUcRppCmpGqIl+fJBnXvrObyN2+XYVZzvBmAmGzkAfXVlkFyaXaECyLeNafWkobLJsLOt2fh
 wiOPC3WAdJ0UpI5NikrFwiS0D0eLYGAWvM/0hfBLnVvV0G/xVkF7E4b5XP5Unnm05QwtmlNYhQk
 s=
X-Google-Smtp-Source: AK7set98Y7dLUBXYMxUAgPYJRwSwe5G/4pJt7wTHoABVMGSpSmarcdzS7b1UEdwaYPt5vQLyrZsh/w==
X-Received: by 2002:a05:622a:170b:b0:3e3:7e24:a35a with SMTP id
 h11-20020a05622a170b00b003e37e24a35amr21832421qtk.9.1679948001588; 
 Mon, 27 Mar 2023 13:13:21 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 201-20020a3708d2000000b007456efa7f73sm12278213qki.85.2023.03.27.13.13.20
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 27 Mar 2023 13:13:21 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Mon, 27 Mar 2023 16:11:32 -0400
Message-Id: <20230327201143.51026-10-snitzer@kernel.org>
In-Reply-To: <20230327201143.51026-1-snitzer@kernel.org>
References: <20230327201143.51026-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: [dm-devel] [dm-6.4 PATCH v3 09/20] dm bufio: move dm_bufio_client
 members to avoid spanning cachelines
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
Cc: axboe@kernel.dk, ebiggers@kernel.org, keescook@chromium.org,
 heinzm@redhat.com, Mike Snitzer <snitzer@kernel.org>, nhuck@google.com,
 linux-block@vger.kernel.org, ejt@redhat.com, mpatocka@redhat.com,
 luomeng12@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Movement also consolidates holes in dm_bufio_client struct. But the
overall size of the struct isn't changed.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-bufio.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 9ac50024006d..e5459741335d 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -936,13 +936,16 @@ static void cache_remove_range(struct dm_buffer_cache *bc,
  *	context.
  */
 struct dm_bufio_client {
-	struct mutex lock;
-	spinlock_t spinlock;
-	bool no_sleep;
-
 	struct block_device *bdev;
 	unsigned int block_size;
 	s8 sectors_per_block_bits;
+
+	bool no_sleep;
+	struct mutex lock;
+	spinlock_t spinlock;
+
+	int async_write_error;
+
 	void (*alloc_callback)(struct dm_buffer *buf);
 	void (*write_callback)(struct dm_buffer *buf);
 	struct kmem_cache *slab_buffer;
@@ -954,23 +957,22 @@ struct dm_bufio_client {
 
 	unsigned int minimum_buffers;
 
-	struct dm_buffer_cache cache;
-	wait_queue_head_t free_buffer_wait;
-
 	sector_t start;
 
-	int async_write_error;
-
-	struct list_head client_list;
-
 	struct shrinker shrinker;
 	struct work_struct shrink_work;
 	atomic_long_t need_shrink;
 
+	wait_queue_head_t free_buffer_wait;
+
+	struct list_head client_list;
+
 	/*
 	 * Used by global_cleanup to sort the clients list.
 	 */
 	unsigned long oldest_buffer;
+
+	struct dm_buffer_cache cache;
 };
 
 static DEFINE_STATIC_KEY_FALSE(no_sleep_enabled);
-- 
2.40.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

