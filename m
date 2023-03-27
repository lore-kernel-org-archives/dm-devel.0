Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B55D5C77B60
	for <dm-devel@archiver.kernel.org>; Mon, 27 Mar 2023 20:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679948056;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=k+ow5h4fvOB68teKqp0nfcPWI9d3iZfIBa4LJYSiXg0=;
	b=YZL8SDFnCvjOFoRyXmlkqNyPpm9JSS0EAF4Ci9EZJW8vW1OlBAMN9/gnMCx5fr4O9LuNhe
	Nvo94VNKPsA1LhO38TKXbHf/SvSQNQSignu4kYcGaa1pEqSV85xTTffo8UKMI5oyyvGUI/
	wWBw04SU+wF91bgLBkafpuU31Gb1WiI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-659-yGnin8-EPPO4kB-xDOTfaA-1; Mon, 27 Mar 2023 16:14:13 -0400
X-MC-Unique: yGnin8-EPPO4kB-xDOTfaA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5F377857FB3;
	Mon, 27 Mar 2023 20:14:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4EB64492B01;
	Mon, 27 Mar 2023 20:14:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 689871949739;
	Mon, 27 Mar 2023 20:13:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BC139194658F
 for <dm-devel@listman.corp.redhat.com>; Mon, 27 Mar 2023 20:13:41 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id AC6B72166B2C; Mon, 27 Mar 2023 20:13:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A555E2166B29
 for <dm-devel@redhat.com>; Mon, 27 Mar 2023 20:13:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 865C0802D32
 for <dm-devel@redhat.com>; Mon, 27 Mar 2023 20:13:41 +0000 (UTC)
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com
 [209.85.160.169]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-635-F6F-nH9kNbarqske-1UjjA-7; Mon, 27 Mar 2023 16:13:39 -0400
X-MC-Unique: F6F-nH9kNbarqske-1UjjA-7
Received: by mail-qt1-f169.google.com with SMTP id r5so9816382qtp.4
 for <dm-devel@redhat.com>; Mon, 27 Mar 2023 13:13:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1679948018;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=RS/kygwvcLIIpB3MPZf9iFXCT5/ZQtXgTxSpDCvveGI=;
 b=kuvDlucaP7Pnf/j3LrunawoalZlYY6v32/yU3GSVSFJ3Mu1xEPBfm8klmBAEYSRsF7
 TxKHtBo9Z8C3RK2PiPjnXQOM2fQwEMow3/B84ABJd+QdShJSvb3O1dyqJJwJyF/erwmv
 pStY4Q1kDHt9umBNDfjtluRONWHiiDCwEqQlyN7FQ4FDQAjWZXccDNi/VjDvHuVQFONA
 nfXCu2V/EHQaiBSOJsF+qRU7GYnw8W4TqsaZiCMNeO+hTep/vCluskP6p/TtGLXC8oDt
 RArpBEndoa39j8pG5MQ2INm0iYxDh6/+m6Qte462nhjyoUOlHerT6pI1mBQsNwZoLdYI
 fL5w==
X-Gm-Message-State: AO0yUKWSXzX6X3idUvJWcP9Q0lXBhgcQl78pdJ8+QP1HuE1bExpFQDxY
 C/5Av6JufdVOMWso0m6Jb6kBsFvQbD3FFw/9slAuX+6uVN6KpUk2sZpuoCwBpm4sBj5YRVQYHbw
 cJiMgneOAwLOyVddB2ZBc/R/8mLvESb8Dlu0Dye09s3RXlUrGLNcpsrknKu78Z718emCxeisu7j
 Q=
X-Google-Smtp-Source: AK7set9gY+NOfaP2EPxXeQTEmFaMokIIbBlTZWwiEUt/LmRMwCYwgGOWnXBndmFgQ57KlO5UkZnONg==
X-Received: by 2002:a05:622a:1d3:b0:3e3:87a2:e7f5 with SMTP id
 t19-20020a05622a01d300b003e387a2e7f5mr20519135qtw.11.1679948018387; 
 Mon, 27 Mar 2023 13:13:38 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 207-20020a3703d8000000b007468ec2e5dcsm10816449qkd.87.2023.03.27.13.13.37
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 27 Mar 2023 13:13:38 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Mon, 27 Mar 2023 16:11:42 -0400
Message-Id: <20230327201143.51026-20-snitzer@kernel.org>
In-Reply-To: <20230327201143.51026-1-snitzer@kernel.org>
References: <20230327201143.51026-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: [dm-devel] [dm-6.4 PATCH v3 19/20] dm bio prison v1: prepare to
 intelligently size dm_bio_prison's prison_regions
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
Cc: axboe@kernel.dk, ebiggers@kernel.org, keescook@chromium.org,
 heinzm@redhat.com, Mike Snitzer <snitzer@kernel.org>, nhuck@google.com,
 linux-block@vger.kernel.org, ejt@redhat.com, mpatocka@redhat.com,
 luomeng12@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Add num_locks member to dm_bio_prison struct and use it rather than
the NR_LOCKS magic value (64).

Next commit will size the dm_bio_prison's prison_regions according to
dm_num_sharded_locks().

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-bio-prison-v1.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm-bio-prison-v1.c b/drivers/md/dm-bio-prison-v1.c
index 78bb559b521c..a7930ad1878b 100644
--- a/drivers/md/dm-bio-prison-v1.c
+++ b/drivers/md/dm-bio-prison-v1.c
@@ -17,7 +17,6 @@
 /*----------------------------------------------------------------*/
 
 #define NR_LOCKS 64
-#define LOCK_MASK (NR_LOCKS - 1)
 #define MIN_CELLS 1024
 
 struct prison_region {
@@ -26,8 +25,9 @@ struct prison_region {
 } ____cacheline_aligned_in_smp;
 
 struct dm_bio_prison {
-	struct prison_region regions[NR_LOCKS];
 	mempool_t cell_pool;
+	unsigned int num_locks;
+	struct prison_region regions[NR_LOCKS];
 };
 
 static struct kmem_cache *_cell_cache;
@@ -46,8 +46,9 @@ struct dm_bio_prison *dm_bio_prison_create(void)
 
 	if (!prison)
 		return NULL;
+	prison->num_locks = NR_LOCKS;
 
-	for (i = 0; i < NR_LOCKS; i++) {
+	for (i = 0; i < prison->num_locks; i++) {
 		spin_lock_init(&prison->regions[i].lock);
 		prison->regions[i].cell = RB_ROOT;
 	}
@@ -115,9 +116,9 @@ static int cmp_keys(struct dm_cell_key *lhs,
 	return 0;
 }
 
-static unsigned lock_nr(struct dm_cell_key *key)
+static unsigned lock_nr(struct dm_cell_key *key, unsigned int num_locks)
 {
-	return (key->block_begin >> BIO_PRISON_MAX_RANGE_SHIFT) & LOCK_MASK;
+	return (key->block_begin >> BIO_PRISON_MAX_RANGE_SHIFT) & (num_locks - 1);
 }
 
 bool dm_cell_key_has_valid_range(struct dm_cell_key *key)
@@ -176,7 +177,7 @@ static int bio_detain(struct dm_bio_prison *prison,
 		      struct dm_bio_prison_cell **cell_result)
 {
 	int r;
-	unsigned l = lock_nr(key);
+	unsigned l = lock_nr(key, prison->num_locks);
 
 	spin_lock_irq(&prison->regions[l].lock);
 	r = __bio_detain(&prison->regions[l].cell, key, inmate, cell_prealloc, cell_result);
@@ -224,7 +225,7 @@ void dm_cell_release(struct dm_bio_prison *prison,
 		     struct dm_bio_prison_cell *cell,
 		     struct bio_list *bios)
 {
-	unsigned l = lock_nr(&cell->key);
+	unsigned l = lock_nr(&cell->key, prison->num_locks);
 
 	spin_lock_irq(&prison->regions[l].lock);
 	__cell_release(&prison->regions[l].cell, cell, bios);
@@ -247,7 +248,7 @@ void dm_cell_release_no_holder(struct dm_bio_prison *prison,
 			       struct dm_bio_prison_cell *cell,
 			       struct bio_list *inmates)
 {
-	unsigned l = lock_nr(&cell->key);
+	unsigned l = lock_nr(&cell->key, prison->num_locks);
 	unsigned long flags;
 
 	spin_lock_irqsave(&prison->regions[l].lock, flags);
@@ -277,7 +278,7 @@ void dm_cell_visit_release(struct dm_bio_prison *prison,
 			   void *context,
 			   struct dm_bio_prison_cell *cell)
 {
-	unsigned l = lock_nr(&cell->key);
+	unsigned l = lock_nr(&cell->key, prison->num_locks);
 	spin_lock_irq(&prison->regions[l].lock);
 	visit_fn(context, cell);
 	rb_erase(&cell->node, &prison->regions[l].cell);
@@ -301,7 +302,7 @@ int dm_cell_promote_or_release(struct dm_bio_prison *prison,
 			       struct dm_bio_prison_cell *cell)
 {
 	int r;
-	unsigned l = lock_nr(&cell->key);
+	unsigned l = lock_nr(&cell->key, prison->num_locks);
 
 	spin_lock_irq(&prison->regions[l].lock);
 	r = __promote_or_release(&prison->regions[l].cell, cell);
-- 
2.40.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

