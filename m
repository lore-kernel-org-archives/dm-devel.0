Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC2C8C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 18 Apr 2022 02:27:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-322-PYeMQdBFMIGQ6zFJMfrljw-1; Sun, 17 Apr 2022 22:27:43 -0400
X-MC-Unique: PYeMQdBFMIGQ6zFJMfrljw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DD20138035A0;
	Mon, 18 Apr 2022 02:27:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CA7DE145D47D;
	Mon, 18 Apr 2022 02:27:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8629219451F1;
	Mon, 18 Apr 2022 02:27:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CE81C19466DF
 for <dm-devel@listman.corp.redhat.com>; Mon, 18 Apr 2022 02:27:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A83EC40F4961; Mon, 18 Apr 2022 02:27:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A477540F495E
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 02:27:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8C9A81857F02
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 02:27:39 +0000 (UTC)
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com
 [209.85.222.175]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-608-X1VgMUDtOQSHd-KpCDk2Xg-2; Sun, 17 Apr 2022 22:27:38 -0400
X-MC-Unique: X1VgMUDtOQSHd-KpCDk2Xg-2
Received: by mail-qk1-f175.google.com with SMTP id a186so7639920qkc.10
 for <dm-devel@redhat.com>; Sun, 17 Apr 2022 19:27:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references;
 bh=qZYYMcdkAxQYrABrUSFIfRtvMwACiFCOZgoiJ8izbTQ=;
 b=r8YQuIJZUPjuW5sW4Ar6GXl6jIfap10Fg+yhy6YQ/e4uba7PVU4Jtgx6AWgnXgsWgL
 9WYAGw+nhND7YSYuaRRZty6wKghjSGGyoZ6fz//aE+ltBagf4zw9GBsE2Rvs9K/whdVn
 nF3AREb8RuTCFrBYQCth094K82atY/QDUqsP0Yz8jMr7ylKtuUfrH9hIZZBG0WU48LX1
 CiscBCy3Bs7+RUPAuMTRbq8/UNthib2+Y1eX8V8qBxOmRf6FIdvzlw6sFj8wWphalKrt
 XKwDXhS4MTSKyT1jgNbhB9ynO+V73ESzfgFll0SNztqCt1wgECTIgd482VzgH59D6ZQA
 zdzg==
X-Gm-Message-State: AOAM533dxXYhVsudsFf27QNET4+A9HqyYApyh0qtyyW6hdF9KmrmtBob
 ZaIX10pcB/lghnvW8gEsqWRA6qKgCQAqhbazJgFob5XmVf7llNVoTmgH4dDvAae3imklO5BXJJO
 zwGa6NUUXg+uQJ6qtLb3Hf6jvVR6S22EtmPyDkY1S2b9KmeZfiqwnjWYtkjY/zZeZBoQ=
X-Google-Smtp-Source: ABdhPJyCMmvHxxYgQDH5fBs5LbFsGB0HEnorFWy5d9BGo/yZvlH1JIZrWI3QX21AZLQBG2uYcxCerA==
X-Received: by 2002:ae9:edc7:0:b0:69e:1318:3251 with SMTP id
 c190-20020ae9edc7000000b0069e13183251mr5532042qkg.57.1650248857402; 
 Sun, 17 Apr 2022 19:27:37 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 f11-20020a05622a1a0b00b002f1f3b66bd4sm3596772qtb.94.2022.04.17.19.27.36
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 17 Apr 2022 19:27:37 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Sun, 17 Apr 2022 22:27:14 -0400
Message-Id: <20220418022733.56168-3-snitzer@kernel.org>
In-Reply-To: <20220418022733.56168-1-snitzer@kernel.org>
References: <20220418022733.56168-1-snitzer@kernel.org>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: [dm-devel] [dm-5.19 PATCH 02/21] dm: conditionally enable
 BIOSET_PERCPU_CACHE for dm_io bioset
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
Cc: axboe@kernel.dk, hch@lst.de, ming.lei@redhat.com
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

A bioset's per-cpu alloc cache may have broader utility in the future
but for now constrain it to being tightly coupled to QUEUE_FLAG_POLL.

Also change dm_io_complete() to use bio_clear_polled() so that it
properly clears all associated bio state on requeue.

This commit improves DM's hipri bio polling (REQ_POLLED) perf by
7 - 20% depending on the system.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-table.c | 11 ++++++++---
 drivers/md/dm.c       |  8 ++++----
 drivers/md/dm.h       |  4 ++--
 3 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 03541cfc2317..ffd97cb6d1c1 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1002,6 +1002,8 @@ bool dm_table_request_based(struct dm_table *t)
 	return __table_type_request_based(dm_table_get_type(t));
 }
 
+static int dm_table_supports_poll(struct dm_table *t);
+
 static int dm_table_alloc_md_mempools(struct dm_table *t, struct mapped_device *md)
 {
 	enum dm_queue_mode type = dm_table_get_type(t);
@@ -1009,21 +1011,24 @@ static int dm_table_alloc_md_mempools(struct dm_table *t, struct mapped_device *
 	unsigned min_pool_size = 0;
 	struct dm_target *ti;
 	unsigned i;
+	bool poll_supported = false;
 
 	if (unlikely(type == DM_TYPE_NONE)) {
 		DMWARN("no table type is set, can't allocate mempools");
 		return -EINVAL;
 	}
 
-	if (__table_type_bio_based(type))
+	if (__table_type_bio_based(type)) {
 		for (i = 0; i < t->num_targets; i++) {
 			ti = t->targets + i;
 			per_io_data_size = max(per_io_data_size, ti->per_io_data_size);
 			min_pool_size = max(min_pool_size, ti->num_flush_bios);
 		}
+		poll_supported = !!dm_table_supports_poll(t);
+	}
 
-	t->mempools = dm_alloc_md_mempools(md, type, t->integrity_supported,
-					   per_io_data_size, min_pool_size);
+	t->mempools = dm_alloc_md_mempools(md, type, per_io_data_size, min_pool_size,
+					   t->integrity_supported, poll_supported);
 	if (!t->mempools)
 		return -ENOMEM;
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 82957bd460e8..61a52f585966 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -899,7 +899,7 @@ static void dm_io_complete(struct dm_io *io)
 			 * may only reflect a subset of the pre-split original)
 			 * so clear REQ_POLLED in case of requeue.
 			 */
-			bio->bi_opf &= ~REQ_POLLED;
+			bio_clear_polled(bio);
 			if (io_error == BLK_STS_AGAIN) {
 				/* io_uring doesn't handle BLK_STS_AGAIN (yet) */
 				queue_io(md, bio);
@@ -2902,8 +2902,8 @@ int dm_noflush_suspending(struct dm_target *ti)
 EXPORT_SYMBOL_GPL(dm_noflush_suspending);
 
 struct dm_md_mempools *dm_alloc_md_mempools(struct mapped_device *md, enum dm_queue_mode type,
-					    unsigned integrity, unsigned per_io_data_size,
-					    unsigned min_pool_size)
+					    unsigned per_io_data_size, unsigned min_pool_size,
+					    bool integrity, bool poll)
 {
 	struct dm_md_mempools *pools = kzalloc_node(sizeof(*pools), GFP_KERNEL, md->numa_node_id);
 	unsigned int pool_size = 0;
@@ -2919,7 +2919,7 @@ struct dm_md_mempools *dm_alloc_md_mempools(struct mapped_device *md, enum dm_qu
 		pool_size = max(dm_get_reserved_bio_based_ios(), min_pool_size);
 		front_pad = roundup(per_io_data_size, __alignof__(struct dm_target_io)) + DM_TARGET_IO_BIO_OFFSET;
 		io_front_pad = roundup(per_io_data_size,  __alignof__(struct dm_io)) + DM_IO_BIO_OFFSET;
-		ret = bioset_init(&pools->io_bs, pool_size, io_front_pad, 0);
+		ret = bioset_init(&pools->io_bs, pool_size, io_front_pad, poll ? BIOSET_PERCPU_CACHE : 0);
 		if (ret)
 			goto out;
 		if (integrity && bioset_integrity_create(&pools->io_bs, pool_size))
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index 9013dc1a7b00..3f89664fea01 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -221,8 +221,8 @@ void dm_kcopyd_exit(void);
  * Mempool operations
  */
 struct dm_md_mempools *dm_alloc_md_mempools(struct mapped_device *md, enum dm_queue_mode type,
-					    unsigned integrity, unsigned per_bio_data_size,
-					    unsigned min_pool_size);
+					    unsigned per_io_data_size, unsigned min_pool_size,
+					    bool integrity, bool poll);
 void dm_free_md_mempools(struct dm_md_mempools *pools);
 
 /*
-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

