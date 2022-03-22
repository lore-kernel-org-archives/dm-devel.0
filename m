Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4007FC433EF
	for <dm-devel@archiver.kernel.org>; Tue, 22 Mar 2022 19:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1647978664;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=eKxTxouW7oaKglgA9p7dE8bup+9cVWg336AKSgTqKms=;
	b=fWLIeqJfBD6iPmprpixn2DnurZLcrWlQCupZXhXIG1KwSzNbO+CCUwJG7ZK4/rLg6tlQW7
	ZjX7NxpkKrpOBPp+ERkYU9UCeI4e63oXXORSm0qP8bk4MPquqlUSw8xa91G2UKNUsmY6Tm
	momFOPSFbKzE9vuZln65Y5ZaDQxCcBw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-244-sdLrwUBlPV6O-0byMDLkrA-1; Tue, 22 Mar 2022 15:49:40 -0400
X-MC-Unique: sdLrwUBlPV6O-0byMDLkrA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3DBC180418D;
	Tue, 22 Mar 2022 19:49:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2ADB0401E86;
	Tue, 22 Mar 2022 19:49:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 683B51940362;
	Tue, 22 Mar 2022 19:49:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 684901949762
 for <dm-devel@listman.corp.redhat.com>; Tue, 22 Mar 2022 19:49:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5995CC26E9B; Tue, 22 Mar 2022 19:49:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 54E6DC26E9A
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 19:49:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 391D2811E78
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 19:49:35 +0000 (UTC)
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-486-aMUSgtq1NKKdZKf84hI7Sw-1; Tue, 22 Mar 2022 15:49:33 -0400
X-MC-Unique: aMUSgtq1NKKdZKf84hI7Sw-1
Received: by mail-qk1-f200.google.com with SMTP id
 bj2-20020a05620a190200b005084968bb24so12459778qkb.23
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 12:49:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
 :in-reply-to:references;
 bh=CUK36jS7t3ES+pLUUL+mUYA6t3/aGv0zfagQFWZKaXc=;
 b=HVnwB4a1gKdX0ZgoNNiH2PHJAq5tDYZMXpLmmvum3aAF3mk+tfFSdfuc02s3u9pvOC
 M2c8m+TN6FX8m/Q+GD6bdTyInQur53SPz7y0nHTZMIb/NL+YzoObVnnEWGXF1X/Ei0yv
 fxd2VddrNsz6nrIHHQITdCfGpF3qIg9D6ncjzICPAh0LI2zIjiOIadCx8D12haleIRTj
 NR97CguE2EJWmahiG1g8Z5cUf3M0A40HNPgLl0Uk62Ud7+VfnoJJz8fI1i464IEYjy9L
 hZsb+Q9Dryj0EkHcMFcT/78Br0tmFWfe/sWEdh1PviyeBVYtqpxJfdGe1vN0w73eRbFx
 +cXg==
X-Gm-Message-State: AOAM530ZIjhHWRG6thQZEmTLQwOhN1GGmOfCB6Zrr7YVHHtT0PHK7c8X
 cYKC0q9JR133xlEzsR++BhHwOtXTOQad2eksWhPnGIGOg66i3F/ndRznPnNxXYALlMGNs7LW8Zg
 cI5gz22cUCluEMA==
X-Received: by 2002:a37:7cd:0:b0:67b:e91:6b01 with SMTP id
 196-20020a3707cd000000b0067b0e916b01mr16641568qkh.652.1647978573393; 
 Tue, 22 Mar 2022 12:49:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzhGeJC8fKIOscwpW7RkXLopawiBL7yLMjD6LNS9u1yPv2DAClh1WWgit2m17Y/Funlddnw8A==
X-Received: by 2002:a37:7cd:0:b0:67b:e91:6b01 with SMTP id
 196-20020a3707cd000000b0067b0e916b01mr16641560qkh.652.1647978573149; 
 Tue, 22 Mar 2022 12:49:33 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 m23-20020a05620a221700b00649555cd27bsm9635821qkh.79.2022.03.22.12.49.32
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 22 Mar 2022 12:49:32 -0700 (PDT)
From: Mike Snitzer <snitzer@redhat.com>
X-Google-Original-From: Mike Snitzer <snitzer@kernel.org>
To: axboe@kernel.dk
Date: Tue, 22 Mar 2022 15:49:27 -0400
Message-Id: <20220322194927.42778-4-snitzer@kernel.org>
In-Reply-To: <20220322194927.42778-1-snitzer@kernel.org>
References: <20220322194927.42778-1-snitzer@kernel.org>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: [dm-devel] [PATCH 3/3] dm: conditionally enable BIOSET_PERCPU_CACHE
 for bio-based dm_io bioset
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

There is no point establishing the bioset percpu cache if request_queue
won't have QUEUE_FLAG_POLL.

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
index 06f3720a190b..071e7615f153 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2997,8 +2997,8 @@ int dm_noflush_suspending(struct dm_target *ti)
 EXPORT_SYMBOL_GPL(dm_noflush_suspending);
 
 struct dm_md_mempools *dm_alloc_md_mempools(struct mapped_device *md, enum dm_queue_mode type,
-					    unsigned integrity, unsigned per_io_data_size,
-					    unsigned min_pool_size)
+					    unsigned per_io_data_size, unsigned min_pool_size,
+					    bool integrity, bool poll)
 {
 	struct dm_md_mempools *pools = kzalloc_node(sizeof(*pools), GFP_KERNEL, md->numa_node_id);
 	unsigned int pool_size = 0;
@@ -3014,7 +3014,7 @@ struct dm_md_mempools *dm_alloc_md_mempools(struct mapped_device *md, enum dm_qu
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

