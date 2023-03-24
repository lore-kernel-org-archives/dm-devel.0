Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.145.221.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32D5AC6FD20
	for <dm-devel@archiver.kernel.org>; Fri, 24 Mar 2023 17:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679680646;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=0VhOSqxAlhsKB42PrqNkzsKoOtPsJMWAOMjuqRsT4tQ=;
	b=CJ+omefJgYTzF1T1Vwr+fy4Bk8b6AJq6VuHoeux/mSfafl7WkCa018NnGkz7BJaLYj0GKr
	dCp4VUgBgFOshwj0t7rsMYLd6tI8CAqxGcZiiRs0grCjJHI+agzkXXwLoMVU7ALudh7x8Q
	VC3vDQXWkYbJGqBZjecsZX2LwpZJGxQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-2-suYLL6GsN9egKEhczx1LYQ-1; Fri, 24 Mar 2023 13:57:25 -0400
X-MC-Unique: suYLL6GsN9egKEhczx1LYQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A9D23855310;
	Fri, 24 Mar 2023 17:57:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5167940C6E67;
	Fri, 24 Mar 2023 17:57:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 034E81946A5E;
	Fri, 24 Mar 2023 17:57:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6449E1946A5A
 for <dm-devel@listman.corp.redhat.com>; Fri, 24 Mar 2023 17:57:06 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2A9C3C15BB8; Fri, 24 Mar 2023 17:57:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 22D81C15BA0
 for <dm-devel@redhat.com>; Fri, 24 Mar 2023 17:57:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 05B1128135B8
 for <dm-devel@redhat.com>; Fri, 24 Mar 2023 17:57:06 +0000 (UTC)
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com
 [209.85.160.177]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-411-6cqNXwYKOkqe-rqG-uQL6A-1; Fri, 24 Mar 2023 13:57:04 -0400
X-MC-Unique: 6cqNXwYKOkqe-rqG-uQL6A-1
Received: by mail-qt1-f177.google.com with SMTP id ga7so2219013qtb.2
 for <dm-devel@redhat.com>; Fri, 24 Mar 2023 10:57:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1679680623;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=kPEdicCB9nRHVOXH2vFQPCJlJzheS4Tji6ZAfc8sIpM=;
 b=le48WIKoL9URvrWsjF7OOK5/6mEtqeVcLkv40WTfnmCg/DouwG0cg8gPUslqMHppoz
 n4wtqLtmIAF81ipdV3/m+qO4GnZ9E9hzYvwMO6wjz1MMPyTNMbnhoqNJqPk8HbzKlziI
 wbuJJ9EzVgkOYvSmQkNRsHxdHSBu6S0h6pRckoxwglQ0GUtj5FfhG8PEbLfYDf5UUCWc
 EqdjTYG6RmzSB0xEblKrG0eFcmKoYsF8zFBb1wdq12Sb+UvdE9LAfvuC7ZW+nvgsBP1z
 w7u+2Ex5g4/3TWvwo07DRE4nkUMeUoyyG2d+Llk1Q6JMQI2cE4MtAx7IcMHoNOvWXCor
 urrg==
X-Gm-Message-State: AO0yUKWelh3bLb0kvxeetC9lFZ+bR28nRozs4vTuCPUn7j7+Z9Y0m3JS
 eqpqg99b5s5N4GVlHJz5LusVz+kFn4bELxtx01c43+oOv+lbNK7ckLGoafqrc1bP7F0zD8DLfNx
 i5A4nyW9E4FBFC/5ZMQy9p0f8sD/A/tWw4Q/RKQscbzs09MINvipKi0yekbLlYY4mAXWZbBotCN
 U=
X-Google-Smtp-Source: AK7set874hQQKW0EEPbAQ7o+UY6Py6ockTr+/OJGNDaye/vhx4Jz7AyzqhfNoaP3JCO5x35hKOaRCA==
X-Received: by 2002:a05:622a:b:b0:3bf:d161:79a1 with SMTP id
 x11-20020a05622a000b00b003bfd16179a1mr6603831qtw.29.1679680623345; 
 Fri, 24 Mar 2023 10:57:03 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 11-20020a37060b000000b0071d0f1d01easm8319902qkg.57.2023.03.24.10.57.02
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 24 Mar 2023 10:57:02 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Fri, 24 Mar 2023 13:56:49 -0400
Message-Id: <20230324175656.85082-3-snitzer@kernel.org>
In-Reply-To: <20230324175656.85082-1-snitzer@kernel.org>
References: <20230324175656.85082-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: [dm-devel] [dm-6.4 PATCH v2 2/9] dm bufio: move dm_buffer struct
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
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

