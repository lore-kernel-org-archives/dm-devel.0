Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47336C6FD20
	for <dm-devel@archiver.kernel.org>; Fri, 24 Mar 2023 17:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679680688;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=LvzAMU/K1xUgAE8aF/ZwaChC12KsnRw4Xns3a301pG4=;
	b=KQXzWcbPEZgoB8au2AsJVKzlOWDfGN3sRH/O6aV3IaMZAQxwAANEYu+go5BtadJ3mxCKlm
	wM7yWWxAsBUrBxpoPyKFfidK5LDVBb6ly1kNJNvKRca+/Hvv5ANefa4X5Hj4MvkWS0+Fs2
	fMsR2cPPgJvqASU7oLCWaZWvSUjsh9c=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-548-Fb7hb2QaNMSdoM7XUNhjJg-1; Fri, 24 Mar 2023 13:58:05 -0400
X-MC-Unique: Fb7hb2QaNMSdoM7XUNhjJg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 91DC3886463;
	Fri, 24 Mar 2023 17:58:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7FBA02027040;
	Fri, 24 Mar 2023 17:58:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 15CF11946A61;
	Fri, 24 Mar 2023 17:57:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 120541946A5E
 for <dm-devel@listman.corp.redhat.com>; Fri, 24 Mar 2023 17:57:25 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E711D140EBF4; Fri, 24 Mar 2023 17:57:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DF1AC140E950
 for <dm-devel@redhat.com>; Fri, 24 Mar 2023 17:57:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 97E8B855304
 for <dm-devel@redhat.com>; Fri, 24 Mar 2023 17:57:14 +0000 (UTC)
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com
 [209.85.160.181]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-29-hRrz3UW8ORSO6x5hJ5QNfA-2; Fri, 24 Mar 2023 13:57:13 -0400
X-MC-Unique: hRrz3UW8ORSO6x5hJ5QNfA-2
Received: by mail-qt1-f181.google.com with SMTP id t9so2197381qtx.8
 for <dm-devel@redhat.com>; Fri, 24 Mar 2023 10:57:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1679680632;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=6PKqdJFHlMUFZNUEvpL9gBzLYs3G0zKQPB+NnAYo5GY=;
 b=lNqz1yQVULQTbXgAzxLQG2s5WJSO649MmceEMqn9/hbQ6GZhleuTusUs8Lay9jxkZW
 26aMbhGC2nPiQFj/gwyYCaLg7QGPYFl2CeDhsaKv0oiizcFqWzRzYDAVJmDeu7pLa2nJ
 t5BHZUTCLvL0ADLVm4hIK1FxDH9hO90HZeveYc+t39cF7XT8CZf5ChvAbWW67ENuuBke
 +A4vf5rt+pqMmqmRGtbSb24aqDs+IR11d6M98q7wFQPVTzjvUU0KTtHEj2f4lUGxF4ka
 V+QAgpcMgclnSjyOFCXTnW3guKWMYb7DT/v57ISb6qu4YMf3De5YTQIph56eQ/mnCcX8
 WMRg==
X-Gm-Message-State: AO0yUKXZo0ct51yHCv63TE5HApgiageEuEh65jWFnMhXzsqnwhPVnkLs
 WC8OtXhXULndygvJHwvkv4RRB0yD0SCXyqGzUsR/alJssoknj6QytM73K0IGxcnVm99UuefJBWv
 Eq9COX/QkQdYkeBOWwB3eYFeqr+wHVYrmEbWYXIvt0SZCt1HSeGjrlxfB2Z4n47wWGmNWKui4q0
 U=
X-Google-Smtp-Source: AK7set9Pa75MSe7qmMCQ3y5qWv/TuU6NoOI8MAEdwIhKnMW5+8A7tzWu6CW0B4S958q2mr3a15g4Ww==
X-Received: by 2002:a05:622a:4:b0:3e3:8e11:ca56 with SMTP id
 x4-20020a05622a000400b003e38e11ca56mr7064409qtw.37.1679680632164; 
 Fri, 24 Mar 2023 10:57:12 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 o10-20020a05620a228a00b00745b3e62006sm14396384qkh.23.2023.03.24.10.57.11
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 24 Mar 2023 10:57:11 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Fri, 24 Mar 2023 13:56:55 -0400
Message-Id: <20230324175656.85082-9-snitzer@kernel.org>
In-Reply-To: <20230324175656.85082-1-snitzer@kernel.org>
References: <20230324175656.85082-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: [dm-devel] [dm-6.4 PATCH v2 8/9] dm: split discards further if
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
Cc: ebiggers@kernel.org, keescook@chromium.org, heinzm@redhat.com,
 Mike Snitzer <snitzer@kernel.org>, nhuck@google.com,
 linux-block@vger.kernel.org, ejt@redhat.com, mpatocka@redhat.com,
 luomeng12@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
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

