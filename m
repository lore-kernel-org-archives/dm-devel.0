Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6023C00140
	for <dm-devel@archiver.kernel.org>; Tue, 26 Jul 2022 16:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658851810;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=0oTLVnQERJAYGuDZNsyw+0m5yUsAiwJBGNA0PuybFQA=;
	b=GkZDy6HBVaOaiy45ogdNxX/Gt8C9TlwPNXPrSDQDxvNb5o9x+KGp/cSGIqYTjj1IRW5VO3
	3RlK9k1KqNcpNM3l76VnAVIXIa/oeExykquKe4CpmdWjoBEfhbH5Fv8MIIh4qoxhRlF3Rv
	AfLxEQNSPrxLNimY6hSZ+MWMKa15AiU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-613--9u_pQfgNV-LxdKBfl7Ydg-1; Tue, 26 Jul 2022 12:10:09 -0400
X-MC-Unique: -9u_pQfgNV-LxdKBfl7Ydg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8FB83101A54E;
	Tue, 26 Jul 2022 16:10:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1797718EA8;
	Tue, 26 Jul 2022 16:10:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A4378194704E;
	Tue, 26 Jul 2022 16:10:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 282341945DAD
 for <dm-devel@listman.corp.redhat.com>; Tue, 26 Jul 2022 16:10:05 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E9C6540C1288; Tue, 26 Jul 2022 16:10:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E635D4010E4D
 for <dm-devel@redhat.com>; Tue, 26 Jul 2022 16:10:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CBD3A38164C0
 for <dm-devel@redhat.com>; Tue, 26 Jul 2022 16:10:04 +0000 (UTC)
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com
 [209.85.222.180]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-508-XTXsWZL4OqOiitKSygPqzg-1; Tue, 26 Jul 2022 12:10:03 -0400
X-MC-Unique: XTXsWZL4OqOiitKSygPqzg-1
Received: by mail-qk1-f180.google.com with SMTP id m16so11293398qka.12
 for <dm-devel@redhat.com>; Tue, 26 Jul 2022 09:10:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=WxXg6XaT1wKu/KuKSPKc0B35Io1t0NOqv84ULmPGdiI=;
 b=2RLOgzKynI2LD/ueCec788PUhKM144KhLdHGdsnPelPSE5Khkao3QkaYvpYO/cViQM
 lGPwb1qNOaneebMrxKfLQo544YxegFQik02ev6dUgfHPN1g/nzjSGtqCHGiUxdSxshQs
 qi33HCMhwSOG3/6FrknbTifDkQ6laax9ROFj0ubQjsz5YYN7fW1Cof0ERuF1u8cYSI08
 VS/O3gvDLPKERRbUwqp/y2EOjA+bKAghd1rDFM9xrWigOPEb4L3Py9r5K7qL1Kvoj2X0
 ok1jsdrntfBo/wfZkWU4/M1p1b32ZPjHBFeFwsrtBnIzlFzuCyl9YondyWUUTX72KyhQ
 Xvrw==
X-Gm-Message-State: AJIora/pgWZ58bjy30ltsR2+aeWZrspRIlOL0bDd/sMgr0lZ3o7GJiuN
 H91nssT+NMj79QmEtvh7b0TxYi3PZ1UVk/s=
X-Google-Smtp-Source: AGRyM1tffIguYojUk8ExY/o2OMIV3pXwH2U3G1r1vQp5jF3geBrHhAilX2hsdB0ADZq/LbcE7D015A==
X-Received: by 2002:a05:620a:3707:b0:6b5:e205:81c7 with SMTP id
 de7-20020a05620a370700b006b5e20581c7mr13882006qkb.754.1658851802416; 
 Tue, 26 Jul 2022 09:10:02 -0700 (PDT)
Received: from localhost (pool-68-160-173-162.bstnma.fios.verizon.net.
 [68.160.173.162]) by smtp.gmail.com with ESMTPSA id
 s34-20020a05622a1aa200b003177969a48fsm9839694qtc.21.2022.07.26.09.10.01
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 26 Jul 2022 09:10:01 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: Nathan Huckleberry <nhuck@google.com>, Eric Biggers <ebiggers@kernel.org>
Date: Tue, 26 Jul 2022 12:09:54 -0400
Message-Id: <20220726160959.89247-2-snitzer@kernel.org>
In-Reply-To: <20220726160959.89247-1-snitzer@kernel.org>
References: <20220726160959.89247-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: [dm-devel] [PATCH v2 1/6] dm bufio: Add flags argument to
 dm_bufio_client_create
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Nathan Huckleberry <nhuck@google.com>

Add a flags argument to dm_bufio_client_create and update all the
callers. This is in preparation to add the DM_BUFIO_NO_SLEEP flag.

Signed-off-by: Nathan Huckleberry <nhuck@google.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-bufio.c                         | 3 ++-
 drivers/md/dm-ebs-target.c                    | 3 ++-
 drivers/md/dm-integrity.c                     | 2 +-
 drivers/md/dm-snap-persistent.c               | 2 +-
 drivers/md/dm-verity-fec.c                    | 4 ++--
 drivers/md/dm-verity-target.c                 | 2 +-
 drivers/md/persistent-data/dm-block-manager.c | 3 ++-
 include/linux/dm-bufio.h                      | 3 ++-
 8 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 5ffa1dcf84cf..ad5603eb12e3 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -1717,7 +1717,8 @@ static unsigned long dm_bufio_shrink_count(struct shrinker *shrink, struct shrin
 struct dm_bufio_client *dm_bufio_client_create(struct block_device *bdev, unsigned block_size,
 					       unsigned reserved_buffers, unsigned aux_size,
 					       void (*alloc_callback)(struct dm_buffer *),
-					       void (*write_callback)(struct dm_buffer *))
+					       void (*write_callback)(struct dm_buffer *),
+					       unsigned int flags)
 {
 	int r;
 	struct dm_bufio_client *c;
diff --git a/drivers/md/dm-ebs-target.c b/drivers/md/dm-ebs-target.c
index 0221fa63f888..04a1f56d6588 100644
--- a/drivers/md/dm-ebs-target.c
+++ b/drivers/md/dm-ebs-target.c
@@ -312,7 +312,8 @@ static int ebs_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto bad;
 	}
 
-	ec->bufio = dm_bufio_client_create(ec->dev->bdev, to_bytes(ec->u_bs), 1, 0, NULL, NULL);
+	ec->bufio = dm_bufio_client_create(ec->dev->bdev, to_bytes(ec->u_bs), 1,
+					   0, NULL, NULL, 0);
 	if (IS_ERR(ec->bufio)) {
 		ti->error = "Cannot create dm bufio client";
 		r = PTR_ERR(ec->bufio);
diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 67dc35b32264..a537fb8e6459 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -4434,7 +4434,7 @@ static int dm_integrity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	}
 
 	ic->bufio = dm_bufio_client_create(ic->meta_dev ? ic->meta_dev->bdev : ic->dev->bdev,
-			1U << (SECTOR_SHIFT + ic->log2_buffer_sectors), 1, 0, NULL, NULL);
+			1U << (SECTOR_SHIFT + ic->log2_buffer_sectors), 1, 0, NULL, NULL, 0);
 	if (IS_ERR(ic->bufio)) {
 		r = PTR_ERR(ic->bufio);
 		ti->error = "Cannot initialize dm-bufio";
diff --git a/drivers/md/dm-snap-persistent.c b/drivers/md/dm-snap-persistent.c
index 3bb5cff5d6fc..aaa699749c3b 100644
--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -494,7 +494,7 @@ static int read_exceptions(struct pstore *ps,
 
 	client = dm_bufio_client_create(dm_snap_cow(ps->store->snap)->bdev,
 					ps->store->chunk_size << SECTOR_SHIFT,
-					1, 0, NULL, NULL);
+					1, 0, NULL, NULL, 0);
 
 	if (IS_ERR(client))
 		return PTR_ERR(client);
diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index cea2b3789736..23cffce56403 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -749,7 +749,7 @@ int verity_fec_ctr(struct dm_verity *v)
 
 	f->bufio = dm_bufio_client_create(f->dev->bdev,
 					  f->io_size,
-					  1, 0, NULL, NULL);
+					  1, 0, NULL, NULL, 0);
 	if (IS_ERR(f->bufio)) {
 		ti->error = "Cannot initialize FEC bufio client";
 		return PTR_ERR(f->bufio);
@@ -765,7 +765,7 @@ int verity_fec_ctr(struct dm_verity *v)
 
 	f->data_bufio = dm_bufio_client_create(v->data_dev->bdev,
 					       1 << v->data_dev_block_bits,
-					       1, 0, NULL, NULL);
+					       1, 0, NULL, NULL, 0);
 	if (IS_ERR(f->data_bufio)) {
 		ti->error = "Cannot initialize FEC data bufio client";
 		return PTR_ERR(f->data_bufio);
diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 75b66dd67633..95db3a7ee3c7 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -1265,7 +1265,7 @@ static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 
 	v->bufio = dm_bufio_client_create(v->hash_dev->bdev,
 		1 << v->hash_dev_block_bits, 1, sizeof(struct buffer_aux),
-		dm_bufio_alloc_callback, NULL);
+		dm_bufio_alloc_callback, NULL, 0);
 	if (IS_ERR(v->bufio)) {
 		ti->error = "Cannot initialize dm-bufio";
 		r = PTR_ERR(v->bufio);
diff --git a/drivers/md/persistent-data/dm-block-manager.c b/drivers/md/persistent-data/dm-block-manager.c
index 54c089a50b15..11935864f50f 100644
--- a/drivers/md/persistent-data/dm-block-manager.c
+++ b/drivers/md/persistent-data/dm-block-manager.c
@@ -391,7 +391,8 @@ struct dm_block_manager *dm_block_manager_create(struct block_device *bdev,
 	bm->bufio = dm_bufio_client_create(bdev, block_size, max_held_per_thread,
 					   sizeof(struct buffer_aux),
 					   dm_block_manager_alloc_callback,
-					   dm_block_manager_write_callback);
+					   dm_block_manager_write_callback,
+					   0);
 	if (IS_ERR(bm->bufio)) {
 		r = PTR_ERR(bm->bufio);
 		kfree(bm);
diff --git a/include/linux/dm-bufio.h b/include/linux/dm-bufio.h
index 90bd558a17f5..e21480715255 100644
--- a/include/linux/dm-bufio.h
+++ b/include/linux/dm-bufio.h
@@ -24,7 +24,8 @@ struct dm_bufio_client *
 dm_bufio_client_create(struct block_device *bdev, unsigned block_size,
 		       unsigned reserved_buffers, unsigned aux_size,
 		       void (*alloc_callback)(struct dm_buffer *),
-		       void (*write_callback)(struct dm_buffer *));
+		       void (*write_callback)(struct dm_buffer *),
+		       unsigned int flags);
 
 /*
  * Release a buffered IO cache.
-- 
2.32.1 (Apple Git-133)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

