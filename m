Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF6D4C76195
	for <dm-devel@archiver.kernel.org>; Wed, 22 Mar 2023 18:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679509203;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ZTJQ4VAqqvrU5NBQeSod8F3IzzsnS4+YVA+KMRJk+oA=;
	b=ZAWlMuqva5P93gBuG72GrbYtwfYJEfD1pWJ/hse8vDxfXcr3WpUrA97adJFBjQ1r9zqRLR
	EktZZil2K+k3plk0RTnawn5vKNX7asB1AM04jxW4v5Vh6lgg55HFLuYjHwC5OgOd0wlNUz
	ull8nkZ8gtTIjdOqTzTqcueGnePHRhw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-447-clOkByc9MX6xsh2qhIYtvw-1; Wed, 22 Mar 2023 14:19:45 -0400
X-MC-Unique: clOkByc9MX6xsh2qhIYtvw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2043D2999B3B;
	Wed, 22 Mar 2023 18:19:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0FA451121314;
	Wed, 22 Mar 2023 18:19:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 27E881946A75;
	Wed, 22 Mar 2023 18:19:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3A5741946A45
 for <dm-devel@listman.corp.redhat.com>; Wed, 22 Mar 2023 18:19:31 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1771B40C6E68; Wed, 22 Mar 2023 18:19:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1002640C6E67
 for <dm-devel@redhat.com>; Wed, 22 Mar 2023 18:19:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E9D79101A531
 for <dm-devel@redhat.com>; Wed, 22 Mar 2023 18:19:25 +0000 (UTC)
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com
 [209.85.219.48]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-178-pzFgcTRxNoSCFEfdMXg1Ww-1; Wed, 22 Mar 2023 14:19:24 -0400
X-MC-Unique: pzFgcTRxNoSCFEfdMXg1Ww-1
Received: by mail-qv1-f48.google.com with SMTP id qh28so12738771qvb.7
 for <dm-devel@redhat.com>; Wed, 22 Mar 2023 11:19:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1679509163;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=fhQNXEgbZRlvEDVe4dOSLEHmcdFKzX1JvHBuPQFromA=;
 b=zus0ytLI2+rMSGizPA21RBqpBdv7SYJBf7NkfCEkscJcclT01e9NQ3VvZ8n4pvhWSp
 oViCK21wn992UjA+A6gc4IrMZM/Nd4nA7uhwAibGSSzuUNr5Ul9bQnnlrX9ckA53lGup
 st371UsGmr4lwbLzdnCpaLiJD0VJMBqHHcuDqWorLni1a8XiC3FHKq2gyzOCW/gGeTg9
 Bg7X8urqpdwno+4K8G+RjfnwX7aYVjON5eLJhad4817usfqPOgTsYLQbiX8K0jOm0VIa
 hu7p9ibAR4PlV0vfG2o5innb6aewRDHkI4lsiBS/F4jRRLa8QPsS+Jlcqxx/NMEO60sB
 kvPw==
X-Gm-Message-State: AO0yUKUc4UK1wvoytkBEmntXhV4pxC7wu6wbHErpRCpL8dqY7me9EfgW
 Rxz36jHyG9ITkWlKJx+bp12QisAq5J69LuiIgcrbvSxUTMK1E7TQSMKedwI8GPPrxG8caWYFp8O
 vk7SkUTxm5sbnd1suBdYxKa4X5FlnQLjQ9DitWn6wYqJNQC8EG6T6konfuQ0CUaJ2NjIQHClmGQ
 g=
X-Google-Smtp-Source: AK7set/ltULtpwmQlv9orHhAzdUiRVUTXNEZa/Yzq+Vw04Oy+7liu0HoiPqY/MkvZ7XYrMSBCtAbEw==
X-Received: by 2002:a05:6214:1c0c:b0:56f:1b7e:d87f with SMTP id
 u12-20020a0562141c0c00b0056f1b7ed87fmr8423752qvc.34.1679509163266; 
 Wed, 22 Mar 2023 11:19:23 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 l6-20020ac848c6000000b003bfb0ea8094sm4012052qtr.83.2023.03.22.11.19.22
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 22 Mar 2023 11:19:22 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Wed, 22 Mar 2023 14:18:38 -0400
Message-Id: <20230322181845.29848-2-snitzer@kernel.org>
In-Reply-To: <20230322181845.29848-1-snitzer@kernel.org>
References: <20230322181845.29848-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: [dm-devel] [dm-6.4 PATCH 1/8] dm: split discards further if target
 sets max_discard_granularity
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

The block core (bio_split_discard) will already split discards based
on the 'discard_granularity' and 'max_discard_sectors' queue_limits.
But the DM thin target also needs to ensure that it doesn't receive a
discard that spans a 'max_discard_sectors' boundary.

Introduce a dm_target 'max_discard_granularity' flag that if set will
cause DM core to split discard bios relative to 'max_discard_sectors'.
This treats 'discard_granularity' as a "min_discard_granularity" and
'max_discard_sectors' as a "max_discard_granularity".

Requested-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm.c               | 54 +++++++++++++++++++----------------
 include/linux/device-mapper.h |  6 ++++
 include/uapi/linux/dm-ioctl.h |  4 +--
 3 files changed, 37 insertions(+), 27 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index b6ace995b9ca..eeb58f89369e 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1162,7 +1162,8 @@ static inline sector_t max_io_len_target_boundary(struct dm_target *ti,
 	return ti->len - target_offset;
 }
 
-static sector_t max_io_len(struct dm_target *ti, sector_t sector)
+static sector_t __max_io_len(struct dm_target *ti, sector_t sector,
+			     unsigned int max_granularity)
 {
 	sector_t target_offset = dm_target_offset(ti, sector);
 	sector_t len = max_io_len_target_boundary(ti, target_offset);
@@ -1173,11 +1174,16 @@ static sector_t max_io_len(struct dm_target *ti, sector_t sector)
 	 *   explains why stacked chunk_sectors based splitting via
 	 *   bio_split_to_limits() isn't possible here.
 	 */
-	if (!ti->max_io_len)
+	if (!max_granularity)
 		return len;
 	return min_t(sector_t, len,
 		min(queue_max_sectors(ti->table->md->queue),
-		    blk_chunk_sectors_left(target_offset, ti->max_io_len)));
+		    blk_chunk_sectors_left(target_offset, max_granularity)));
+}
+
+static inline sector_t max_io_len(struct dm_target *ti, sector_t sector)
+{
+	return __max_io_len(ti, sector, ti->max_io_len);
 }
 
 int dm_set_target_max_io_len(struct dm_target *ti, sector_t len)
@@ -1561,26 +1567,6 @@ static void __send_empty_flush(struct clone_info *ci)
 	bio_uninit(ci->bio);
 }
 
-static void __send_changing_extent_only(struct clone_info *ci, struct dm_target *ti,
-					unsigned int num_bios)
-{
-	unsigned int len, bios;
-
-	len = min_t(sector_t, ci->sector_count,
-		    max_io_len_target_boundary(ti, dm_target_offset(ti, ci->sector)));
-
-	atomic_add(num_bios, &ci->io->io_count);
-	bios = __send_duplicate_bios(ci, ti, num_bios, &len);
-	/*
-	 * alloc_io() takes one extra reference for submission, so the
-	 * reference won't reach 0 without the following (+1) subtraction
-	 */
-	atomic_sub(num_bios - bios + 1, &ci->io->io_count);
-
-	ci->sector += len;
-	ci->sector_count -= len;
-}
-
 static bool is_abnormal_io(struct bio *bio)
 {
 	enum req_op op = bio_op(bio);
@@ -1602,11 +1588,16 @@ static bool is_abnormal_io(struct bio *bio)
 static blk_status_t __process_abnormal_io(struct clone_info *ci,
 					  struct dm_target *ti)
 {
-	unsigned int num_bios = 0;
+	unsigned int bios, num_bios = 0;
+	unsigned int len, max_granularity = 0;
 
 	switch (bio_op(ci->bio)) {
 	case REQ_OP_DISCARD:
 		num_bios = ti->num_discard_bios;
+		if (ti->max_discard_granularity) {
+			struct queue_limits *limits = dm_get_queue_limits(ti->table->md);
+			max_granularity = limits->max_discard_sectors;
+		}
 		break;
 	case REQ_OP_SECURE_ERASE:
 		num_bios = ti->num_secure_erase_bios;
@@ -1627,7 +1618,20 @@ static blk_status_t __process_abnormal_io(struct clone_info *ci,
 	if (unlikely(!num_bios))
 		return BLK_STS_NOTSUPP;
 
-	__send_changing_extent_only(ci, ti, num_bios);
+	len = min_t(sector_t, ci->sector_count,
+		    __max_io_len(ti, ci->sector, max_granularity));
+
+	atomic_add(num_bios, &ci->io->io_count);
+	bios = __send_duplicate_bios(ci, ti, num_bios, &len);
+	/*
+	 * alloc_io() takes one extra reference for submission, so the
+	 * reference won't reach 0 without the following (+1) subtraction
+	 */
+	atomic_sub(num_bios - bios + 1, &ci->io->io_count);
+
+	ci->sector += len;
+	ci->sector_count -= len;
+
 	return BLK_STS_OK;
 }
 
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 7975483816e4..8aa6b3ea91fa 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -358,6 +358,12 @@ struct dm_target {
 	 */
 	bool discards_supported:1;
 
+	/*
+	 * Set if this target requires that discards be split on both
+	 * 'discard_granularity' and 'max_discard_sectors' boundaries.
+	 */
+	bool max_discard_granularity:1;
+
 	/*
 	 * Set if we need to limit the number of in-flight bios when swapping.
 	 */
diff --git a/include/uapi/linux/dm-ioctl.h b/include/uapi/linux/dm-ioctl.h
index 7edf335778ba..1990b5700f69 100644
--- a/include/uapi/linux/dm-ioctl.h
+++ b/include/uapi/linux/dm-ioctl.h
@@ -286,9 +286,9 @@ enum {
 #define DM_DEV_SET_GEOMETRY	_IOWR(DM_IOCTL, DM_DEV_SET_GEOMETRY_CMD, struct dm_ioctl)
 
 #define DM_VERSION_MAJOR	4
-#define DM_VERSION_MINOR	47
+#define DM_VERSION_MINOR	48
 #define DM_VERSION_PATCHLEVEL	0
-#define DM_VERSION_EXTRA	"-ioctl (2022-07-28)"
+#define DM_VERSION_EXTRA	"-ioctl (2023-03-01)"
 
 /* Status bits */
 #define DM_READONLY_FLAG	(1 << 0) /* In/Out */
-- 
2.40.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

