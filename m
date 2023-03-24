Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06C7EC7619A
	for <dm-devel@archiver.kernel.org>; Fri, 24 Mar 2023 17:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679680669;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ek+Wk4BtuNgfqQ79q3GfPhdWsfAGBaaZPHPUGT3bn6Y=;
	b=haPE7j81PQN2OagNh3o0CqVZ+USXqTw3uWXLs2CIPXHqwSIJHUDREfUT9/RNwmyIpop9rQ
	fxDPqi04gK8fhy1OZRO3rWAlE7joT5zgYLmrsVVwKqWg4VBrMEu9UuymRHAhwBOzAInInd
	JW6tKXJUqZ6DLkPt9JPOVGKixbESsak=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-45-PFF2AiHAO1GDaGzXmtqZ1g-1; Fri, 24 Mar 2023 13:57:47 -0400
X-MC-Unique: PFF2AiHAO1GDaGzXmtqZ1g-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 607F0101A552;
	Fri, 24 Mar 2023 17:57:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4D374492B15;
	Fri, 24 Mar 2023 17:57:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D374319472ED;
	Fri, 24 Mar 2023 17:57:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E3F0519472CC
 for <dm-devel@listman.corp.redhat.com>; Fri, 24 Mar 2023 17:57:18 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C7C3940C6E6A; Fri, 24 Mar 2023 17:57:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C089140C6E68
 for <dm-devel@redhat.com>; Fri, 24 Mar 2023 17:57:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A480C3C1015A
 for <dm-devel@redhat.com>; Fri, 24 Mar 2023 17:57:08 +0000 (UTC)
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com
 [209.85.219.44]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-253-a1XP2DJEPgm9WQU_nxrcPg-3; Fri, 24 Mar 2023 13:57:07 -0400
X-MC-Unique: a1XP2DJEPgm9WQU_nxrcPg-3
Received: by mail-qv1-f44.google.com with SMTP id g9so2116856qvt.8
 for <dm-devel@redhat.com>; Fri, 24 Mar 2023 10:57:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1679680626;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=QR+NKzxABFRAZ1kdMJ3IPIOMmvU3M9l0qrVDn7DCiqI=;
 b=wkEPwPtsxzhiKWzKXRUI1r+aMV6DlZE3CStezdTOuCdWuDJNjWUm42tz/AH/QsNWqZ
 W8dhg3dlyKul1P3y7pjhRANcxBzvEN0mJNWXcyN6w2l2ZUji6M9cMOmxIBsXrM0Yhzgx
 YO8LjqU2KOt259ohIlmdLoZgHyWtERj11dKVifncJdzyhJcCS8YsLC34dbZjCnGOWnKv
 QZtWXmTiCWNVI0+FxPQKo8k/v2V1e2kuvqDV9LK90Y+5iWPe2bnlrCz3pIba6MTDMBsU
 Qy3P2m1CLfh4PHawBi1ula4cgW8h8mBNw0E8hL9jKXK9QdM04qSZ+fZTJtmXvWzRgZaT
 Fazw==
X-Gm-Message-State: AO0yUKXQCjGb67m80Psz9FVaRffBnJsptNAyMWMZ/ObJkz6QxmYS238b
 TyeBT/orPPHAEWsspxmDjJdsYxEvlypF332XcmmZ7Co2THHiPy8e8NwmKAp8VYatemfYsu8kbQO
 bhaAlDuch4idka3yXpzoHeHjo8SnHFQdh8xx/eq0EgnFBOUyt5jPmQdTVgozqhOPfiFT5FHyZpr
 Q=
X-Google-Smtp-Source: AK7set9yhCEH2wAHH1Xt7DHGpawlCcVwVYIClvxbWIOkYTRq5XFKVwkEeJY+FKtLd6Dp+vZSYuNOrw==
X-Received: by 2002:a05:6214:501e:b0:584:8c13:3041 with SMTP id
 jo30-20020a056214501e00b005848c133041mr17397443qvb.24.1679680626298; 
 Fri, 24 Mar 2023 10:57:06 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 u1-20020a05621411a100b005dd8b9345besm852144qvv.86.2023.03.24.10.57.05
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 24 Mar 2023 10:57:05 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Fri, 24 Mar 2023 13:56:51 -0400
Message-Id: <20230324175656.85082-5-snitzer@kernel.org>
In-Reply-To: <20230324175656.85082-1-snitzer@kernel.org>
References: <20230324175656.85082-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: [dm-devel] [dm-6.4 PATCH v2 4/9] dm bufio: move dm_bufio_client
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
Cc: ebiggers@kernel.org, keescook@chromium.org, heinzm@redhat.com,
 Mike Snitzer <snitzer@kernel.org>, nhuck@google.com,
 linux-block@vger.kernel.org, ejt@redhat.com, mpatocka@redhat.com,
 luomeng12@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
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
index a58f8ac3ba75..929685011e02 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -952,13 +952,16 @@ static void cache_remove_range(struct dm_buffer_cache *bc,
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
@@ -970,23 +973,22 @@ struct dm_bufio_client {
 
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

