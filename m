Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BF7EC6FD1F
	for <dm-devel@archiver.kernel.org>; Wed, 22 Mar 2023 18:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679509187;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=0VhOSqxAlhsKB42PrqNkzsKoOtPsJMWAOMjuqRsT4tQ=;
	b=WSI30YSUcfNfqnw5IQOXxQ0K85LXo5xxGLy0+XqDYuB4SxGAjBkdVpleRmpq70xPNsWc7h
	VMnWQ2S2suGb5MsyYCx+FaG9o7Bqwg1WQl8kiawIqLtsqDN/HIFPDtpebq5MXkt243Crn9
	H/tNvNnjeOD35PRVWrga1D99/rDHTt8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-384-1ZyEW_PNOGWbhnz-3fI_WA-1; Wed, 22 Mar 2023 14:19:45 -0400
X-MC-Unique: 1ZyEW_PNOGWbhnz-3fI_WA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F2A6A2999B4A;
	Wed, 22 Mar 2023 18:19:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E23B41121314;
	Wed, 22 Mar 2023 18:19:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2C8CC1946587;
	Wed, 22 Mar 2023 18:19:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 194FA1946A72
 for <dm-devel@listman.corp.redhat.com>; Wed, 22 Mar 2023 18:19:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EDD86175AD; Wed, 22 Mar 2023 18:19:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E5F1343FBD
 for <dm-devel@redhat.com>; Wed, 22 Mar 2023 18:19:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C65371C02D4F
 for <dm-devel@redhat.com>; Wed, 22 Mar 2023 18:19:29 +0000 (UTC)
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com
 [209.85.160.181]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-91-_OvU2lQvOdyeTnEReROZJw-2; Wed, 22 Mar 2023 14:19:28 -0400
X-MC-Unique: _OvU2lQvOdyeTnEReROZJw-2
Received: by mail-qt1-f181.google.com with SMTP id a5so2172155qto.6
 for <dm-devel@redhat.com>; Wed, 22 Mar 2023 11:19:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1679509167;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=kPEdicCB9nRHVOXH2vFQPCJlJzheS4Tji6ZAfc8sIpM=;
 b=tbf9P3zCDkV0UFzWtYMitVQyA6dR+sA39r3ZCI6NLttn6eHvf6m5oqcN09ZtW6htyz
 nO8whW7l3Uhzo03to/mkW1T6cbk2WwCnBFJ4yiKCtLQdKHcBN8hMunrdjCP31np0WzhP
 1XPdVOPnFAseB/mCbb/CFDeNAbPJxZhN+8QcKoKKiY1pMgNf2LwyMD+KmzSrk0eahoCc
 K+tR6G/aCfwI3U4VvBWeuz9ltFvFLtZAaVQ5WklRkQhagSs4GpZXkb4F265PDsbaHiHj
 KFsFod30ahCd5aYdtiq25pqlPzXbvBs4WTOW3u516EKpMktx/55by+vWJywa+m+wSFzc
 V6bg==
X-Gm-Message-State: AO0yUKWdWFcv325p8igsjoJh4XNfJ7xMtFIa4ATCM7vhsIiVZaw3PTD3
 sxD4myH/Q3aEbbmVyXLpHvTD2UDAw1b4JqW5DyxlT1bBJ3+JKWslsBfvLe0546wf4AkAiA8Mz+D
 afqMa7X0j1MDY6paj9kCK5zIw3QrrGMKsgJ2VzesoFIl4Eb3jSBuqmKmuxR9vxMiJbyfVRh7Dx4
 o=
X-Google-Smtp-Source: AK7set9nVYEIWu9UwYc59VXvEfdpJ7Km2pqaYiFt5lyyBspvL/uG5KE5LQo7mmTQUMwTJcB6QhTHSg==
X-Received: by 2002:a05:622a:14d4:b0:3ba:151a:d300 with SMTP id
 u20-20020a05622a14d400b003ba151ad300mr8145570qtx.60.1679509167499; 
 Wed, 22 Mar 2023 11:19:27 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 k10-20020ac8604a000000b003d3a34d2eb2sm10656143qtm.41.2023.03.22.11.19.26
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 22 Mar 2023 11:19:27 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Wed, 22 Mar 2023 14:18:41 -0400
Message-Id: <20230322181845.29848-5-snitzer@kernel.org>
In-Reply-To: <20230322181845.29848-1-snitzer@kernel.org>
References: <20230322181845.29848-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: [dm-devel] [dm-6.4 PATCH 4/8] dm bufio: move dm_buffer struct
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Movement prepares for finer grained dm_buffer changes, in the next
commit, to be more easily seen.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-bufio.c | 97 ++++++++++++++++++++++---------------------
 1 file changed, 50 insertions(+), 47 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 79434b38f368..1de1bdcda1ce 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -66,6 +66,56 @@
 #define LIST_DIRTY	1
 #define LIST_SIZE	2
 
+/*
+ * Buffer state bits.
+ */
+#define B_READING	0
+#define B_WRITING	1
+#define B_DIRTY		2
+
+/*
+ * Describes how the block was allocated:
+ * kmem_cache_alloc(), __get_free_pages() or vmalloc().
+ * See the comment at alloc_buffer_data.
+ */
+enum data_mode {
+	DATA_MODE_SLAB = 0,
+	DATA_MODE_GET_FREE_PAGES = 1,
+	DATA_MODE_VMALLOC = 2,
+	DATA_MODE_LIMIT = 3
+};
+
+struct dm_buffer {
+	struct rb_node node;
+	struct list_head lru_list;
+	struct list_head global_list;
+
+	sector_t block;
+	void *data;
+	unsigned char data_mode;		/* DATA_MODE_* */
+
+	unsigned int accessed;
+	unsigned int hold_count;
+	unsigned long last_accessed;
+
+	unsigned char list_mode;		/* LIST_* */
+	blk_status_t read_error;
+	blk_status_t write_error;
+	unsigned long state;
+	unsigned int dirty_start;
+	unsigned int dirty_end;
+	unsigned int write_start;
+	unsigned int write_end;
+	struct dm_bufio_client *c;
+	struct list_head write_list;
+	void (*end_io)(struct dm_buffer *b, blk_status_t bs);
+#ifdef CONFIG_DM_DEBUG_BLOCK_STACK_TRACING
+#define MAX_STACK 10
+	unsigned int stack_len;
+	unsigned long stack_entries[MAX_STACK];
+#endif
+};
+
 /*
  * Linking of buffers:
  *	All buffers are linked to buffer_tree with their node field.
@@ -117,53 +167,6 @@ struct dm_bufio_client {
 	atomic_long_t need_shrink;
 };
 
-/*
- * Buffer state bits.
- */
-#define B_READING	0
-#define B_WRITING	1
-#define B_DIRTY		2
-
-/*
- * Describes how the block was allocated:
- * kmem_cache_alloc(), __get_free_pages() or vmalloc().
- * See the comment at alloc_buffer_data.
- */
-enum data_mode {
-	DATA_MODE_SLAB = 0,
-	DATA_MODE_GET_FREE_PAGES = 1,
-	DATA_MODE_VMALLOC = 2,
-	DATA_MODE_LIMIT = 3
-};
-
-struct dm_buffer {
-	struct rb_node node;
-	struct list_head lru_list;
-	struct list_head global_list;
-	sector_t block;
-	void *data;
-	unsigned char data_mode;		/* DATA_MODE_* */
-	unsigned char list_mode;		/* LIST_* */
-	blk_status_t read_error;
-	blk_status_t write_error;
-	unsigned int accessed;
-	unsigned int hold_count;
-	unsigned long state;
-	unsigned long last_accessed;
-	unsigned int dirty_start;
-	unsigned int dirty_end;
-	unsigned int write_start;
-	unsigned int write_end;
-	struct dm_bufio_client *c;
-	struct list_head write_list;
-	void (*end_io)(struct dm_buffer *buf, blk_status_t stat);
-#ifdef CONFIG_DM_DEBUG_BLOCK_STACK_TRACING
-#define MAX_STACK 10
-	unsigned int stack_len;
-	unsigned long stack_entries[MAX_STACK];
-#endif
-};
-
 static DEFINE_STATIC_KEY_FALSE(no_sleep_enabled);
 
 /*----------------------------------------------------------------*/
-- 
2.40.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

