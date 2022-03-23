Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81B01C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 23 Mar 2022 19:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1648064741;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=JfkWgAKW9mw++aaj4XaL5ywvlKII7sL3jqNobELI58g=;
	b=AR36Hm0CZ1rXsW1lVbCt+cvo7cAn8lJ+vowMXTbUfrap0jH73yk3KkYK1fEkGDIOM3UCNj
	v+ZjwR4PltUBVLBxV7/D9yl86FpIfBCwQSFu1VymwR+6TUywFb9nUc4a6Eb/72F4OufmsV
	V4P50u1Syf8fKf5G11Ox3APDRr1dH3A=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-617-Ox1dn2C7P-aUyCh1NphRog-1; Wed, 23 Mar 2022 15:45:38 -0400
X-MC-Unique: Ox1dn2C7P-aUyCh1NphRog-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CDB0618A6585;
	Wed, 23 Mar 2022 19:45:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BC03540CFD01;
	Wed, 23 Mar 2022 19:45:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 932CD194034E;
	Wed, 23 Mar 2022 19:45:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 400A4194035E
 for <dm-devel@listman.corp.redhat.com>; Wed, 23 Mar 2022 19:45:34 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2CC9248FB14; Wed, 23 Mar 2022 19:45:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 28C5846A38A
 for <dm-devel@redhat.com>; Wed, 23 Mar 2022 19:45:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0EE82811E90
 for <dm-devel@redhat.com>; Wed, 23 Mar 2022 19:45:34 +0000 (UTC)
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-543-4OxaELMuPputS4SKSzB1Wg-1; Wed, 23 Mar 2022 15:45:32 -0400
X-MC-Unique: 4OxaELMuPputS4SKSzB1Wg-1
Received: by mail-qv1-f69.google.com with SMTP id
 o1-20020a0c9001000000b00440e415a3a2so2011844qvo.13
 for <dm-devel@redhat.com>; Wed, 23 Mar 2022 12:45:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
 :in-reply-to:references;
 bh=AF9xOLertVL1zPER2DBlMssTlLLbZ7i6J9GUZUZZbT8=;
 b=QW9FTZO7tUKbhhSIJ83OlL0q5irfivVfWL7dTBXtaynNSbxQoaXew4Km8etDw+bstR
 UGibKzC1F07LDrbizZ1/y6T1zvIWQo74whJTwm+g1ITFss+DYrGvAQ93lRSp5OT8fD1o
 BttVQUy5DRTQaBfQ+bI3opUvAlmdOVzxrXowikG7dLwGlCcyWePU3JRZaq1Z38i/0E76
 3LUkEX845ohH/wEdWJtH2OWbp4yrcYdnjY9iEUEIc8isXC6eyu2HviIyLoF7LPomghge
 ttKyfTQdd9JWfVYy3R5FyfVYfuOUDMak33I+VY42HfycByu+8iKjaWT/dYF8qO6/LX5z
 DHaQ==
X-Gm-Message-State: AOAM532dcIRubSX8kKbRqImLL8kX+V725XjItQvbsIsm7dknaRZhqPXH
 pToiJquZA15xviIVCZpJKdxzaPxHbkq4C/ekt2eSmM39i0fpfbIigDOIWrzjMy0Z25osfLA6dnV
 9aPbwUB/IW9uivA==
X-Received: by 2002:ad4:5c6f:0:b0:440:cd9b:db9a with SMTP id
 i15-20020ad45c6f000000b00440cd9bdb9amr1340808qvh.86.1648064732106; 
 Wed, 23 Mar 2022 12:45:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyGZdV6BdMXLbVGDokSS/YFyydCYRxSjfvid2Egnjd81a3tVo6BqGGKuI+kT/R4KaO8Ehs/6Q==
X-Received: by 2002:ad4:5c6f:0:b0:440:cd9b:db9a with SMTP id
 i15-20020ad45c6f000000b00440cd9bdb9amr1340794qvh.86.1648064731874; 
 Wed, 23 Mar 2022 12:45:31 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 y24-20020a37e318000000b0067d43d76184sm445886qki.97.2022.03.23.12.45.31
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 23 Mar 2022 12:45:31 -0700 (PDT)
From: Mike Snitzer <snitzer@redhat.com>
X-Google-Original-From: Mike Snitzer <snitzer@kernel.org>
To: axboe@kernel.dk
Date: Wed, 23 Mar 2022 15:45:24 -0400
Message-Id: <20220323194524.5900-5-snitzer@kernel.org>
In-Reply-To: <20220323194524.5900-1-snitzer@kernel.org>
References: <20220323194524.5900-1-snitzer@kernel.org>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: [dm-devel] [PATCH v2 4/4] dm: conditionally enable
 BIOSET_PERCPU_CACHE for bio-based dm_io bioset
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

A bioset's percpu cache may have broader utility in the future but for
now constrain it to being tightly coupled to QUEUE_FLAG_POLL.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-table.c | 11 ++++++++---
 drivers/md/dm.c       |  6 +++---
 drivers/md/dm.h       |  4 ++--
 3 files changed, 13 insertions(+), 8 deletions(-)

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
index b3cb2c1aea2a..ebd7919e555f 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2999,8 +2999,8 @@ int dm_noflush_suspending(struct dm_target *ti)
 EXPORT_SYMBOL_GPL(dm_noflush_suspending);
 
 struct dm_md_mempools *dm_alloc_md_mempools(struct mapped_device *md, enum dm_queue_mode type,
-					    unsigned integrity, unsigned per_io_data_size,
-					    unsigned min_pool_size)
+					    unsigned per_io_data_size, unsigned min_pool_size,
+					    bool integrity, bool poll)
 {
 	struct dm_md_mempools *pools = kzalloc_node(sizeof(*pools), GFP_KERNEL, md->numa_node_id);
 	unsigned int pool_size = 0;
@@ -3016,7 +3016,7 @@ struct dm_md_mempools *dm_alloc_md_mempools(struct mapped_device *md, enum dm_qu
 		pool_size = max(dm_get_reserved_bio_based_ios(), min_pool_size);
 		front_pad = roundup(per_io_data_size, __alignof__(struct dm_target_io)) + DM_TARGET_IO_BIO_OFFSET;
 		io_front_pad = roundup(per_io_data_size,  __alignof__(struct dm_io)) + DM_IO_BIO_OFFSET;
-		ret = bioset_init(&pools->io_bs, pool_size, io_front_pad, BIOSET_PERCPU_CACHE);
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

