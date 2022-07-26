Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 115C8C04A68
	for <dm-devel@archiver.kernel.org>; Tue, 26 Jul 2022 16:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658851820;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Z8rB3R1LyyZDJrv6AmwL9wos/O5/4TQt17T+KKuE9cY=;
	b=DKdlkPKieIj6dYgx1C/Fxa4E/tV77RQqHgueK7TPdISXfe+0B3keHqFgD6dLjshvmNQZEm
	xgzwFhodE14BmJAdN1HKkqyfSX3Y07KFpMEs8faE7yubP8Z84+BRMb3pEXZ4E/zDJs+isW
	gMWLb0vEgxVACjhxZDGR4WLiBtXWvX8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-552-5zFvx2uQOBK8TP0leWRgOw-1; Tue, 26 Jul 2022 12:10:16 -0400
X-MC-Unique: 5zFvx2uQOBK8TP0leWRgOw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C7E1C85A586;
	Tue, 26 Jul 2022 16:10:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B6E801415118;
	Tue, 26 Jul 2022 16:10:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 815F41945DB1;
	Tue, 26 Jul 2022 16:10:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7B4B11945DAA
 for <dm-devel@listman.corp.redhat.com>; Tue, 26 Jul 2022 16:10:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6EF4A400DFD7; Tue, 26 Jul 2022 16:10:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6A9D3404C324
 for <dm-devel@redhat.com>; Tue, 26 Jul 2022 16:10:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 528AE3C1172D
 for <dm-devel@redhat.com>; Tue, 26 Jul 2022 16:10:12 +0000 (UTC)
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com
 [209.85.219.53]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-668-ICNLDpmtMFiu1BUhLEQmOg-1; Tue, 26 Jul 2022 12:10:09 -0400
X-MC-Unique: ICNLDpmtMFiu1BUhLEQmOg-1
Received: by mail-qv1-f53.google.com with SMTP id f9so10982696qvr.2
 for <dm-devel@redhat.com>; Tue, 26 Jul 2022 09:10:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=CQTWjw72MLSIa+xj5Nzz1Vjuf3qitpUqN8ehDnlPolE=;
 b=Ge8N/RNc2DudMwU9Ulji8QYrJW2PpVtxUxX0/7VQ8d2WmgsEIbwfeCSmGTN/oIRQJd
 SCiAQcFwrh7CBaTGeQI2aRwwmMA96gsbYZNeILdYSD3CfwdgJ7YxEgxKwH4OnJREIZv1
 HiyDT4vHlMKP6CpdRnrIpk1Vo2GMFm8wv7XKSz+Qx5cUcu1XQzfQCkET4zRkJGbpJE87
 9jGAK/rot1P9yM5pc7qHsy4syCL2yGrdrE686sNMU6VSG2iwXHhVMpLzI9XW2rAXWRCd
 HTbf0slqueQPsbWyTvu5m7ZjtnWXWGULIrdYSmqt3spkStsSY2+MRRO9iBu5PK8G8lak
 TenQ==
X-Gm-Message-State: AJIora8FWP+GjpD3C97VYguEHE50UeB/xrFUsGaXu5zv+t5/K872aCFz
 +sGT3lQez/KKFGfzvUBqAhX1u1G2kaFRC+4=
X-Google-Smtp-Source: AGRyM1semOd97YtQI469j+6D/3a3hfOfZ+3aXnKCYLO1PxsR5cn/zdzeBFcvOEMrpAy6GRZmuteo1Q==
X-Received: by 2002:a05:6214:528e:b0:474:3c0f:65b2 with SMTP id
 kj14-20020a056214528e00b004743c0f65b2mr12560173qvb.97.1658851808325; 
 Tue, 26 Jul 2022 09:10:08 -0700 (PDT)
Received: from localhost (pool-68-160-173-162.bstnma.fios.verizon.net.
 [68.160.173.162]) by smtp.gmail.com with ESMTPSA id
 h4-20020a05620a400400b006b5652edb93sm12303899qko.48.2022.07.26.09.10.07
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 26 Jul 2022 09:10:07 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: Nathan Huckleberry <nhuck@google.com>, Eric Biggers <ebiggers@kernel.org>
Date: Tue, 26 Jul 2022 12:09:58 -0400
Message-Id: <20220726160959.89247-6-snitzer@kernel.org>
In-Reply-To: <20220726160959.89247-1-snitzer@kernel.org>
References: <20220726160959.89247-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: [dm-devel] [PATCH v2 5/6] dm bufio: conditionally enable branching
 for DM_BUFIO_CLIENT_NO_SLEEP
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Use jump_label to limit the need for branching unless the optional
DM_BUFIO_CLIENT_NO_SLEEP is used.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-bufio.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 486179d1831c..0a38a7aef49c 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -18,6 +18,7 @@
 #include <linux/module.h>
 #include <linux/rbtree.h>
 #include <linux/stacktrace.h>
+#include <linux/jump_label.h>
 
 #define DM_MSG_PREFIX "bufio"
 
@@ -164,13 +165,15 @@ struct dm_buffer {
 #endif
 };
 
+static DEFINE_STATIC_KEY_FALSE(no_sleep_enabled);
+
 /*----------------------------------------------------------------*/
 
 #define dm_bufio_in_request()	(!!current->bio_list)
 
 static void dm_bufio_lock(struct dm_bufio_client *c)
 {
-	if (c->no_sleep)
+	if (static_branch_unlikely(&no_sleep_enabled) && c->no_sleep)
 		spin_lock_irqsave_nested(&c->spinlock, c->spinlock_flags, dm_bufio_in_request());
 	else
 		mutex_lock_nested(&c->lock, dm_bufio_in_request());
@@ -178,7 +181,7 @@ static void dm_bufio_lock(struct dm_bufio_client *c)
 
 static int dm_bufio_trylock(struct dm_bufio_client *c)
 {
-	if (c->no_sleep)
+	if (static_branch_unlikely(&no_sleep_enabled) && c->no_sleep)
 		return spin_trylock_irqsave(&c->spinlock, c->spinlock_flags);
 	else
 		return mutex_trylock(&c->lock);
@@ -186,7 +189,7 @@ static int dm_bufio_trylock(struct dm_bufio_client *c)
 
 static void dm_bufio_unlock(struct dm_bufio_client *c)
 {
-	if (c->no_sleep)
+	if (static_branch_unlikely(&no_sleep_enabled) && c->no_sleep)
 		spin_unlock_irqrestore(&c->spinlock, c->spinlock_flags);
 	else
 		mutex_unlock(&c->lock);
@@ -1760,8 +1763,10 @@ struct dm_bufio_client *dm_bufio_client_create(struct block_device *bdev, unsign
 	c->alloc_callback = alloc_callback;
 	c->write_callback = write_callback;
 
-	if (flags & DM_BUFIO_CLIENT_NO_SLEEP)
+	if (flags & DM_BUFIO_CLIENT_NO_SLEEP) {
 		c->no_sleep = true;
+		static_branch_inc(&no_sleep_enabled);
+	}
 
 	for (i = 0; i < LIST_SIZE; i++) {
 		INIT_LIST_HEAD(&c->lru[i]);
@@ -1895,6 +1900,8 @@ void dm_bufio_client_destroy(struct dm_bufio_client *c)
 	kmem_cache_destroy(c->slab_buffer);
 	dm_io_client_destroy(c->dm_io);
 	mutex_destroy(&c->lock);
+	if (c->no_sleep)
+		static_branch_dec(&no_sleep_enabled);
 	kfree(c);
 }
 EXPORT_SYMBOL_GPL(dm_bufio_client_destroy);
-- 
2.32.1 (Apple Git-133)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

