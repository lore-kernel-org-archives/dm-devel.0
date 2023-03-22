Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E469C6FD1F
	for <dm-devel@archiver.kernel.org>; Wed, 22 Mar 2023 18:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679509181;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Qsrcu1V/90agJEJxtZU4/A4/58KEqd0J49sFhQow6AQ=;
	b=axOgx0bzdF3Pt/kA1xldd6DOiNPCEoZhd6vQvLR8Y3ELdCTIp7fOFQii8mGzxhxRTQETp4
	e/DDSWDs5rEr1wuFL/841U3qJSGI6gGJdAAo0u2mJEtOFscRTX7Lmu+QsxbxjRp5s2l5IB
	4IWrw3oPwd7y2/Y36r0yxcnweimTJwE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-388-fjA2OAn-Op6kCSFLFZg4qA-1; Wed, 22 Mar 2023 14:19:38 -0400
X-MC-Unique: fjA2OAn-Op6kCSFLFZg4qA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5AC5F8533F9;
	Wed, 22 Mar 2023 18:19:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 47A2240CE2A7;
	Wed, 22 Mar 2023 18:19:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 026091946A5A;
	Wed, 22 Mar 2023 18:19:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 430091946587
 for <dm-devel@listman.corp.redhat.com>; Wed, 22 Mar 2023 18:19:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 35A7A1410F1C; Wed, 22 Mar 2023 18:19:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2DFC6140EBF4
 for <dm-devel@redhat.com>; Wed, 22 Mar 2023 18:19:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 115FB1C02D4F
 for <dm-devel@redhat.com>; Wed, 22 Mar 2023 18:19:33 +0000 (UTC)
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com
 [209.85.219.42]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-241-6EDaqah7OEC1wYZ-cAsgQA-2; Wed, 22 Mar 2023 14:19:31 -0400
X-MC-Unique: 6EDaqah7OEC1wYZ-cAsgQA-2
Received: by mail-qv1-f42.google.com with SMTP id q88so6465626qvq.13
 for <dm-devel@redhat.com>; Wed, 22 Mar 2023 11:19:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1679509171;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=kQP0HeYBfNlPYlh5gIEzv8UhlztQDXrINyULEoq5wvs=;
 b=cccBdMDe8s8Ew5VaAPWzU8KDNDAIAZizTCtxD1FdpEyv/5JY95usjJsdfuwnUR7iAZ
 wPKu8Z2bMPH4dBr28sGpB1xCDxIIbpHry7iInkXWQP9kxCdB9sd7Zky8ddw9cWKso5PK
 qrJ6Zz4Y7SZW7xx5zSPMA1gItHlbYGUcwmRGRhPkMawy/R15vzpRsCibH9p7Xkjqc0oj
 gJdQ/8hgkMJ83nb7l8ZJWfYNXbpi5GIqDItfhPZ/Zpv+HR+RPlVo72SdGNEbzy0R5F4C
 OdgWILXTvVwcaheF4dp8Pjc2yvytxJFnbxWwoz6OVo6RDXR2P4aPic+qlvvalWGLd5MC
 xKbg==
X-Gm-Message-State: AO0yUKVTsdbEX7wqNrUAXNNlA1Mv6zl63wYIkmx1weqsD8gCJRwFU6NQ
 pdnZTGNRI6Hi57BWayiRIrpXoCO6qtsLQ6AdUibQirvsWM5Xv+IUpry8fjaILl4zRG9MOhDj3MQ
 kL4Ov+jQPol7/ueYlOiD/ltJnF2Wx8qJ1YO8UmAu8ytoSnDVYiqwyeeWSOkWsw9MYtmp6/aFM3E
 M=
X-Google-Smtp-Source: AK7set8NEJcx+EAb5gkT/4ahtfywUPlkQ1iFUJfA0uxPV3bosrPnfSkmAHuD7Sh78bh6S2G8NzhPLw==
X-Received: by 2002:a05:6214:2461:b0:5d1:d9f3:dd8c with SMTP id
 im1-20020a056214246100b005d1d9f3dd8cmr8216016qvb.46.1679509170688; 
 Wed, 22 Mar 2023 11:19:30 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 o140-20020a374192000000b007343fceee5fsm5688174qka.8.2023.03.22.11.19.30
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 22 Mar 2023 11:19:30 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Wed, 22 Mar 2023 14:18:43 -0400
Message-Id: <20230322181845.29848-7-snitzer@kernel.org>
In-Reply-To: <20230322181845.29848-1-snitzer@kernel.org>
References: <20230322181845.29848-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: [dm-devel] [dm-6.4 PATCH 6/8] dm bufio: move dm_bufio_client
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
Cc: keescook@chromium.org, heinzm@redhat.com, Mike Snitzer <snitzer@kernel.org>,
 nhuck@google.com, ebiggers@kernel.org, ejt@redhat.com, mpatocka@redhat.com,
 luomeng12@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Movement also consolidates holes in dm_bufio_client struct. But the
overall size of the struct isn't changed.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-bufio.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 56ef160331ce..b418ee8e3853 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -952,13 +952,16 @@ static void cache_remove_range(struct buffer_cache *bc,
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
 
-	struct buffer_cache cache;
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
+	struct buffer_cache cache;
 };
 
 static DEFINE_STATIC_KEY_FALSE(no_sleep_enabled);
-- 
2.40.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

