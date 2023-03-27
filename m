Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD1F1C6FD1D
	for <dm-devel@archiver.kernel.org>; Mon, 27 Mar 2023 20:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679948042;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=LvzAMU/K1xUgAE8aF/ZwaChC12KsnRw4Xns3a301pG4=;
	b=E/QIVWu9iNmDxKozqak8ZPSZLhiK5elCUaMvbwdjOCbT9CVSmxsHtxI8OZSidtNIp1253x
	E057V+06/BldmLxmfKoS1G1HEqACmoEupC/AdVBZA56btKWvZ1dAzwevh/GRDYA4GiWt+W
	wyyIfJSg9guUhnc5lv8jDwYKp4Y8790=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-663-b_gClHWrPHy1LVPgl6UT5A-1; Mon, 27 Mar 2023 16:14:00 -0400
X-MC-Unique: b_gClHWrPHy1LVPgl6UT5A-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5A3E23C0F18F;
	Mon, 27 Mar 2023 20:13:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 49BB9492B01;
	Mon, 27 Mar 2023 20:13:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9F87119472D6;
	Mon, 27 Mar 2023 20:13:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2EECC1946A41
 for <dm-devel@listman.corp.redhat.com>; Mon, 27 Mar 2023 20:13:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2233F492C3E; Mon, 27 Mar 2023 20:13:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1AD77492B03
 for <dm-devel@redhat.com>; Mon, 27 Mar 2023 20:13:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F18C4101A552
 for <dm-devel@redhat.com>; Mon, 27 Mar 2023 20:13:32 +0000 (UTC)
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com
 [209.85.160.169]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-221-Y0rZRn7nPemSq_upB9a6JA-3; Mon, 27 Mar 2023 16:13:30 -0400
X-MC-Unique: Y0rZRn7nPemSq_upB9a6JA-3
Received: by mail-qt1-f169.google.com with SMTP id n14so9790281qta.10
 for <dm-devel@redhat.com>; Mon, 27 Mar 2023 13:13:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1679948009;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=6PKqdJFHlMUFZNUEvpL9gBzLYs3G0zKQPB+NnAYo5GY=;
 b=ctg8xcjeZmSBVzhuhbigKRl+L0T51YoN8t3effCSI/NgVqtes0OtMQ0QAS2Q4w0c17
 8WZ/YcB70j0aPv6ION3TovMOD/REyfn+A6s4qBBdHYSy0y7xTZbybVNxIE7lQn9XjI+z
 rXpUhuMwj6HOdDJH+PJVN5X9ONCp2RGypPGrvATfGXh9LmXevM2FJH1KDP1eI211qp3N
 Epu/fg50r8n0/o1/wIpVWvnrBxTJTt5FoiAdoH+JYfRX09LIrm8UOyYGI1xjPwCbg2RD
 yoZjcNNGoH2t3LGREpC2kWbRsp7/gCu4vstMx4bN9NBi2zGeVICpqXVW7H1arG6api5D
 S2hA==
X-Gm-Message-State: AO0yUKU8RPXDSn9L183O1sZG1O8sFOkcum6WMrpLg2LhP2G7kOFVMOxO
 Sn2IhUrPZKh3R8aa1qxidXr8GQbo3y5kNZTsKaru7F52PBxkDkdvDxClSp6+eu1H3ijLwsUUKvD
 Wv56+36QsAExz9evtZVl081UeCUzulT1mofA/MbBul2ro3sDLvEx5Z642eicW20OxvLFywcTGWu
 0=
X-Google-Smtp-Source: AK7set8CW+cpPq4Pp9FJfsBjh5ZA7tWZLyqOfAoMlX+sA6HGXom7lYbcNpi3u7woOx27vLDKG9NLYA==
X-Received: by 2002:a05:622a:1a98:b0:3d8:9b45:d362 with SMTP id
 s24-20020a05622a1a9800b003d89b45d362mr21296148qtc.28.1679948008860; 
 Mon, 27 Mar 2023 13:13:28 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 m64-20020a375843000000b0073b8512d2dbsm16899758qkb.72.2023.03.27.13.13.28
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 27 Mar 2023 13:13:28 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Mon, 27 Mar 2023 16:11:36 -0400
Message-Id: <20230327201143.51026-14-snitzer@kernel.org>
In-Reply-To: <20230327201143.51026-1-snitzer@kernel.org>
References: <20230327201143.51026-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: [dm-devel] [dm-6.4 PATCH v3 13/20] dm: split discards further if
 target sets max_discard_granularity
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
 drivers/md/dm.c               | 25 +++++++++++++++++++------
 include/linux/device-mapper.h |  6 ++++++
 include/uapi/linux/dm-ioctl.h |  4 ++--
 3 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index b6ace995b9ca..6eb0748a3bb2 100644
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
@@ -1562,12 +1568,13 @@ static void __send_empty_flush(struct clone_info *ci)
 }
 
 static void __send_changing_extent_only(struct clone_info *ci, struct dm_target *ti,
-					unsigned int num_bios)
+					unsigned int num_bios,
+					unsigned int max_granularity)
 {
 	unsigned int len, bios;
 
 	len = min_t(sector_t, ci->sector_count,
-		    max_io_len_target_boundary(ti, dm_target_offset(ti, ci->sector)));
+		    __max_io_len(ti, ci->sector, max_granularity));
 
 	atomic_add(num_bios, &ci->io->io_count);
 	bios = __send_duplicate_bios(ci, ti, num_bios, &len);
@@ -1603,10 +1610,16 @@ static blk_status_t __process_abnormal_io(struct clone_info *ci,
 					  struct dm_target *ti)
 {
 	unsigned int num_bios = 0;
+	unsigned int max_granularity = 0;
 
 	switch (bio_op(ci->bio)) {
 	case REQ_OP_DISCARD:
 		num_bios = ti->num_discard_bios;
+		if (ti->max_discard_granularity) {
+			struct queue_limits *limits =
+				dm_get_queue_limits(ti->table->md);
+			max_granularity = limits->max_discard_sectors;
+		}
 		break;
 	case REQ_OP_SECURE_ERASE:
 		num_bios = ti->num_secure_erase_bios;
@@ -1627,7 +1640,7 @@ static blk_status_t __process_abnormal_io(struct clone_info *ci,
 	if (unlikely(!num_bios))
 		return BLK_STS_NOTSUPP;
 
-	__send_changing_extent_only(ci, ti, num_bios);
+	__send_changing_extent_only(ci, ti, num_bios, max_granularity);
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

