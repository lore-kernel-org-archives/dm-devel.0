Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B2E4C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 11 Feb 2022 21:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1644616029;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=H+6vEEvuRrKLR0f/3yzw7KlrxKL8mDNJ9Bcge3Kc+VI=;
	b=XR4pPIVnr2zDYS9MJmq1xZBFzumVJ8+2IZrpub4NZa4nBLSDwECuswlYKIjWoXluR7N0eM
	apnU6gpuZQQ/sLjgaJu7UnhdvQXfp92oVVsnPdanHJbdhivV+dif+CMuLS1z96dwPQIasG
	l1n3QDZ1lALaqb0f1C/1NkrUT5mHr4A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-553-VtarcdCQO1G7N6pvnZC8jg-1; Fri, 11 Feb 2022 16:47:06 -0500
X-MC-Unique: VtarcdCQO1G7N6pvnZC8jg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8D8E8190A7DE;
	Fri, 11 Feb 2022 21:47:01 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 75C29610A7;
	Fri, 11 Feb 2022 21:47:01 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4FA681806D1C;
	Fri, 11 Feb 2022 21:47:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21BLfMMU024730 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 11 Feb 2022 16:41:22 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 975EBC07F4D; Fri, 11 Feb 2022 21:41:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 93CDAC07F4B
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 21:41:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A43EA28EB2E3
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 21:41:15 +0000 (UTC)
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
	[209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-528-c4VFfEqGMWOqrSdzGhzimQ-1; Fri, 11 Feb 2022 16:41:08 -0500
X-MC-Unique: c4VFfEqGMWOqrSdzGhzimQ-1
Received: by mail-ot1-f72.google.com with SMTP id
	r16-20020a9d7510000000b0059ea94f86eeso6050748otk.8
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 13:41:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
	:references;
	bh=pSQq04wy06PXm26IhLE5PNJWpgzIDfqO8yF6qrhvU94=;
	b=PlT+BNnnwlAegxZo+Gqa2SE8GcpuWD7PcArb3ydvqxH/EyADPJFWTeNCUb8jXh/SMM
	MoR6yga1OYDRNivmqz783mM5kE5p5HTe2o2kwRs/ZEMudWTcx/bb2Ob2g7vnIioSXTPZ
	uX5qevQ8DSBrn9iWA7NtfqIBKQicWJMD586gKXpg4HMaimZ5c+hBYzAeyADq/g1zjFMY
	0t7pLD1+Ro/CAgYg0ZXpFZ4tl8UOJZV+vC1sLyId7nBTkp6EFcuFYT3Pe4zZSHhp5tb2
	Y9PWJX5wyW6JQau57HEnvi8NZhuBQcrL01sFKaJfhYijM5I6WSi0yjqBwYyvip9o8eR/
	07uQ==
X-Gm-Message-State: AOAM532DD7RyRhx2IKoCBzGlrcSi6c6uM5vkIL9kXEx70QUm1ztZD7GK
	uj7cjmvzat3z96na23YCAWf20DqoyT3NN/gnFTjpaSvuoenkisclfFDshjEhuPef1yoFXVKvixg
	TAUl2ywemBOhxaN4mobeX8EaLDLlVM9HbZ2nl0P4WuJthd8B1KP1hGzO2IUhPWWqcwQ==
X-Received: by 2002:a9d:6c8b:: with SMTP id c11mr1270691otr.92.1644615667699; 
	Fri, 11 Feb 2022 13:41:07 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzFoas0EWXUNof1qFC7AgnYYs6iZQl7YqF3JcxmfK7cJthcvMpyzcju8Qara2vobaiK5lDdjA==
X-Received: by 2002:a9d:6c8b:: with SMTP id c11mr1270675otr.92.1644615667250; 
	Fri, 11 Feb 2022 13:41:07 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	bl6sm10078090oib.38.2022.02.11.13.41.06
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 11 Feb 2022 13:41:06 -0800 (PST)
From: Mike Snitzer <snitzer@redhat.com>
To: dm-devel@redhat.com
Date: Fri, 11 Feb 2022 16:40:45 -0500
Message-Id: <20220211214057.40612-3-snitzer@redhat.com>
In-Reply-To: <20220211214057.40612-1-snitzer@redhat.com>
References: <20220211214057.40612-1-snitzer@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org
Subject: [dm-devel] [PATCH v2 02/14] dm: fold __clone_and_map_data_bio into
	__split_and_process_bio
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Fold __clone_and_map_data_bio into its only caller.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c | 30 ++++++++----------------------
 1 file changed, 8 insertions(+), 22 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 2cecb8832936..2f1942b61d48 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1188,25 +1188,6 @@ static void bio_setup_sector(struct bio *bio, sector_t sector, unsigned len)
 	bio->bi_iter.bi_size = to_bytes(len);
 }
 
-/*
- * Creates a bio that consists of range of complete bvecs.
- */
-static int __clone_and_map_data_bio(struct clone_info *ci, struct dm_target *ti,
-				    sector_t sector, unsigned *len)
-{
-	struct bio *bio = ci->bio, *clone;
-
-	clone = alloc_tio(ci, ti, 0, len, GFP_NOIO);
-	bio_advance(clone, to_bytes(sector - clone->bi_iter.bi_sector));
-	clone->bi_iter.bi_size = to_bytes(*len);
-
-	if (bio_integrity(bio))
-		bio_integrity_trim(clone);
-
-	__map_bio(clone);
-	return 0;
-}
-
 static void alloc_multiple_bios(struct bio_list *blist, struct clone_info *ci,
 				struct dm_target *ti, unsigned num_bios,
 				unsigned *len)
@@ -1361,6 +1342,7 @@ static bool __process_abnormal_io(struct clone_info *ci, struct dm_target *ti,
  */
 static int __split_and_process_bio(struct clone_info *ci)
 {
+	struct bio *clone;
 	struct dm_target *ti;
 	unsigned len;
 	int r;
@@ -1374,9 +1356,13 @@ static int __split_and_process_bio(struct clone_info *ci)
 
 	len = min_t(sector_t, max_io_len(ti, ci->sector), ci->sector_count);
 
-	r = __clone_and_map_data_bio(ci, ti, ci->sector, &len);
-	if (r < 0)
-		return r;
+	clone = alloc_tio(ci, ti, 0, &len, GFP_NOIO);
+	bio_advance(clone, to_bytes(ci->sector - clone->bi_iter.bi_sector));
+	clone->bi_iter.bi_size = to_bytes(len);
+	if (bio_integrity(clone))
+		bio_integrity_trim(clone);
+
+	__map_bio(clone);
 
 	ci->sector += len;
 	ci->sector_count -= len;
-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

