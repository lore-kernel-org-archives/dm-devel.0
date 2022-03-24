Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE472C4332F
	for <dm-devel@archiver.kernel.org>; Fri, 25 Mar 2022 07:27:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-262-6rUta_0fO66PLVgxZwdSBw-1; Fri, 25 Mar 2022 03:27:25 -0400
X-MC-Unique: 6rUta_0fO66PLVgxZwdSBw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0455129AB3E6;
	Fri, 25 Mar 2022 07:27:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E8CB7C15D78;
	Fri, 25 Mar 2022 07:27:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C73EA194034E;
	Fri, 25 Mar 2022 07:27:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CBAC2194034B
 for <dm-devel@listman.corp.redhat.com>; Thu, 24 Mar 2022 20:35:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BF4A6400E122; Thu, 24 Mar 2022 20:35:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BB20940E80E2
 for <dm-devel@redhat.com>; Thu, 24 Mar 2022 20:35:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A0E4B3802AE9
 for <dm-devel@redhat.com>; Thu, 24 Mar 2022 20:35:33 +0000 (UTC)
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com
 [209.85.160.173]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-613-FypgEtA-N8CD2DGC28TWHA-2; Thu, 24 Mar 2022 16:35:32 -0400
X-MC-Unique: FypgEtA-N8CD2DGC28TWHA-2
Received: by mail-qt1-f173.google.com with SMTP id t7so4924748qta.10
 for <dm-devel@redhat.com>; Thu, 24 Mar 2022 13:35:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references;
 bh=Yd52i0i0a5XNUmDGQ87h84LHgrvu7ZnpYDPKqDqFs1o=;
 b=hEfnr3B73QqxtN8e9yTxWNYRRO2oFyJkrw1c+7Ek3s87oLnOEtPJ9JfK6Rz2wx0Zfa
 /s01Vv7ZzR0kNjd0qkoPp6Fwgoxnv9PRS+Vq+gPON4pR9LOb+q9IV4zjHAStipcYd9R8
 QLddPCaa7KDuSWVKNyxd9UJSkOBx5GsjhZ2LGYtzfjlOKpdiuL3d+VdHokHrY9rZnglb
 3PPkg/vnBUZA1h/ia1+wONQtBq+JE5w6llwbIxTqJ0cv5/+rOhB53X1LqNlzUTz21vcu
 7dyhFXx3hj8vbU0dXploYrpNmbtxKCrKbb+HLLhbQVn20L4KeNcxnoNSXnV/DLtoOhdM
 SeBQ==
X-Gm-Message-State: AOAM532sp3BDWPgHqGoge1IVqBDcvLbcYAOyHb6r7+Lzr+K6wr9nOYqT
 r2GV7sC1kSpZX5GSpk556ULDcNE=
X-Google-Smtp-Source: ABdhPJxZ6t3UdQbj3qpY2z9A3nIrwL17ZMx/IWJPv3yGVUOB5gE/GLjHEMCnf/vE7K3JiRWmi0un2w==
X-Received: by 2002:ac8:7e8d:0:b0:2e0:6314:d5f3 with SMTP id
 w13-20020ac87e8d000000b002e06314d5f3mr6313001qtj.352.1648154131721; 
 Thu, 24 Mar 2022 13:35:31 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 k1-20020ac85fc1000000b002e1c6420790sm3492494qta.40.2022.03.24.13.35.31
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 24 Mar 2022 13:35:31 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: axboe@kernel.dk
Date: Thu, 24 Mar 2022 16:35:26 -0400
Message-Id: <20220324203526.62306-4-snitzer@kernel.org>
In-Reply-To: <20220324203526.62306-1-snitzer@kernel.org>
References: <20220324203526.62306-1-snitzer@kernel.org>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Mailman-Approved-At: Fri, 25 Mar 2022 07:27:19 +0000
Subject: [dm-devel] [PATCH v3 3/3] dm: conditionally enable
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, hch@lst.de,
 ming.lei@redhat.com
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
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
index c0be4f60b427..7ebc70e3eb2f 100644
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
index b762a48d3fdf..b3e32116c31f 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -898,7 +898,7 @@ static void dm_io_complete(struct dm_io *io)
 		 * may only reflect a subset of the pre-split original,
 		 * so clear REQ_POLLED in case of requeue
 		 */
-		bio->bi_opf &= ~REQ_POLLED;
+		bio_clear_polled(bio);
 		return;
 	}
 
@@ -2915,8 +2915,8 @@ int dm_noflush_suspending(struct dm_target *ti)
 EXPORT_SYMBOL_GPL(dm_noflush_suspending);
 
 struct dm_md_mempools *dm_alloc_md_mempools(struct mapped_device *md, enum dm_queue_mode type,
-					    unsigned integrity, unsigned per_io_data_size,
-					    unsigned min_pool_size)
+					    unsigned per_io_data_size, unsigned min_pool_size,
+					    bool integrity, bool poll)
 {
 	struct dm_md_mempools *pools = kzalloc_node(sizeof(*pools), GFP_KERNEL, md->numa_node_id);
 	unsigned int pool_size = 0;
@@ -2932,7 +2932,7 @@ struct dm_md_mempools *dm_alloc_md_mempools(struct mapped_device *md, enum dm_qu
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

