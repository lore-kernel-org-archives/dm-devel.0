Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20EBFC636D4
	for <dm-devel@archiver.kernel.org>; Mon, 13 Feb 2023 20:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676319286;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=cnyS9+3nQ/i03Lz7heVxmXDHcLmK1I55zo2MTZ6h4DI=;
	b=XzreUmK12hYchh55CymEl2n404DxvYG8WI1PYlIOuNdcxTAlZFnngbGYVXrZ3XzOjgkw4i
	/PF/oX4sHVef4/bteJ5aVFUMfZUVJ3n2uUVLX3o2aNzN4IyuuSY51jzWo7Un82bflNRmU5
	2NzQg41UCBUb++4T9R4mdhOdH1EdzHA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-299-nlMDCquEPtKxPdrgef24Yg-1; Mon, 13 Feb 2023 15:14:43 -0500
X-MC-Unique: nlMDCquEPtKxPdrgef24Yg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 753161C04336;
	Mon, 13 Feb 2023 20:14:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 601912026D4B;
	Mon, 13 Feb 2023 20:14:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 431861946588;
	Mon, 13 Feb 2023 20:14:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1AF321946586
 for <dm-devel@listman.corp.redhat.com>; Mon, 13 Feb 2023 20:14:38 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0D6D31C55A; Mon, 13 Feb 2023 20:14:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 05F4B18EC7
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:14:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D3C23800B23
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:14:37 +0000 (UTC)
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com
 [209.85.160.178]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-120-5s6r634JNUyYLtlZlXqlTw-2; Mon, 13 Feb 2023 15:14:36 -0500
X-MC-Unique: 5s6r634JNUyYLtlZlXqlTw-2
Received: by mail-qt1-f178.google.com with SMTP id z5so15165988qtn.8
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 12:14:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=VvusQRMCF2B/fWm+RFBja6TfBJn2zCehFq2PLq0m2Hg=;
 b=msmWunDMJin9onACP8rjerrRHsAE4PFr9MGqSgmcNVM1FoWsZdQrDE8h9hqhhQV3JX
 S+KVegl0ypdii3u5XbOVnqJ3He5lgLgjAJovK5Ixc/CK5HggJVo5UEWhfE2k6TfGHs/V
 w/g557k81tz4JDCEQUc5Ax72+KTkJTD4oAY1aQwGg420cM/r8TcKEd7NWAisHe37WL+s
 G8alqJ3ch0W49X10CEGZ3NdTr8Fwr4Tvoq3lGtusA5A1iYlMDymjdVrETKI9vAy80eTI
 A8Lcb734G9slt1u6Glimy5Z7W32RpO2IR5A6GgJJmiTRh0bUR397237JktYsAbpX653R
 t5mg==
X-Gm-Message-State: AO0yUKW0i4YsCcCdXuxHsclISwKLBLbTKeC/9vCkVqLG8bSNuQyO2P7D
 Z1zrWffy1D+tK5CqY/Y1SJABhnmolIejQnTHpZZb2FgoJO3uUjSUnNUb9l9hdVyuUxsEidZjNoh
 oomeKr9wUqYlfXUo7ufOAwVGMYvHA3wl2Xns6NRmMj4OUaxuEAJehn3spcdxB4Z9azyRqiw==
X-Google-Smtp-Source: AK7set+yTGAzEGTv5AvSR5KeEgNpSqo+2lW3p5StpyCy2tU7TsC1NQuxQtog3KdVhlVYo/Bbh5StHQ==
X-Received: by 2002:ac8:7f01:0:b0:3b8:5057:377b with SMTP id
 f1-20020ac87f01000000b003b85057377bmr46958882qtk.65.1676319275500; 
 Mon, 13 Feb 2023 12:14:35 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 d19-20020ae9ef13000000b0071ddbe8fe23sm10362693qkg.24.2023.02.13.12.14.34
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 13 Feb 2023 12:14:35 -0800 (PST)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Mon, 13 Feb 2023 15:13:27 -0500
Message-Id: <20230213201401.45973-6-snitzer@kernel.org>
In-Reply-To: <20230213201401.45973-1-snitzer@kernel.org>
References: <20230213201401.45973-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: [dm-devel] [PATCH 05/39] dm: avoid assignment in if conditions
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
Cc: ebiggers@kernel.org, Heinz Mauelshagen <heinzm@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Heinz Mauelshagen <heinzm@redhat.com>

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-crypt.c      |  9 ++++++---
 drivers/md/dm-stats.c      |  3 ++-
 drivers/md/dm-table.c      |  3 ++-
 drivers/md/dm-writecache.c | 11 +++++++----
 4 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 6a58000f58d7..98c788d1b305 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -3416,9 +3416,12 @@ static int crypt_map(struct dm_target *ti, struct bio *bio)
 	if (cc->on_disk_tag_size) {
 		unsigned int tag_len = cc->on_disk_tag_size * (bio_sectors(bio) >> cc->sector_shift);
 
-		if (unlikely(tag_len > KMALLOC_MAX_SIZE) ||
-		    unlikely(!(io->integrity_metadata = kmalloc(tag_len,
-				GFP_NOIO | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN)))) {
+		if (unlikely(tag_len > KMALLOC_MAX_SIZE))
+			io->integrity_metadata = NULL;
+		else
+			io->integrity_metadata = kmalloc(tag_len, GFP_NOIO | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN);
+
+		if (unlikely(!io->integrity_metadata)) {
 			if (bio_sectors(bio) > cc->tag_pool_max_sectors)
 				dm_accept_partial_bio(bio, cc->tag_pool_max_sectors);
 			io->integrity_metadata = mempool_alloc(&cc->tag_pool, GFP_NOIO);
diff --git a/drivers/md/dm-stats.c b/drivers/md/dm-stats.c
index 861e6f97438b..3287c0a9dd04 100644
--- a/drivers/md/dm-stats.c
+++ b/drivers/md/dm-stats.c
@@ -1046,7 +1046,8 @@ static int message_stats_create(struct mapped_device *md,
 			else if (!strncasecmp(a, "histogram:", 10)) {
 				if (n_histogram_entries)
 					goto ret_einval;
-				if ((r = parse_histogram(a + 10, &n_histogram_entries, &histogram_boundaries)))
+				r = parse_histogram(a + 10, &n_histogram_entries, &histogram_boundaries);
+				if (r)
 					goto ret;
 			} else
 				goto ret_einval;
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index af0a214825d6..d5a3f73de4bf 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -374,7 +374,8 @@ int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
 		if (!dd)
 			return -ENOMEM;
 
-		if ((r = dm_get_table_device(t->md, dev, mode, &dd->dm_dev))) {
+		r = dm_get_table_device(t->md, dev, mode, &dd->dm_dev);
+		if (r) {
 			kfree(dd);
 			return r;
 		}
diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 431c84595ddb..369b2a99e459 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -1832,10 +1832,13 @@ static void __writecache_writeback_pmem(struct dm_writecache *wc, struct writeba
 		wb->wc = wc;
 		bio->bi_end_io = writecache_writeback_endio;
 		bio->bi_iter.bi_sector = read_original_sector(wc, e);
-		if (max_pages <= WB_LIST_INLINE ||
-		    unlikely(!(wb->wc_list = kmalloc_array(max_pages, sizeof(struct wc_entry *),
-							   GFP_NOIO | __GFP_NORETRY |
-							   __GFP_NOMEMALLOC | __GFP_NOWARN)))) {
+
+		if (unlikely(max_pages > WB_LIST_INLINE))
+			wb->wc_list = kmalloc_array(max_pages, sizeof(struct wc_entry *),
+						    GFP_NOIO | __GFP_NORETRY |
+						    __GFP_NOMEMALLOC | __GFP_NOWARN);
+
+		if (likely(max_pages <= WB_LIST_INLINE) || unlikely(!wb->wc_list)) {
 			wb->wc_list = wb->wc_list_inline;
 			max_pages = WB_LIST_INLINE;
 		}
-- 
2.37.0 (Apple Git-136)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

