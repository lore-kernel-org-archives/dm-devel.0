Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97568C433EF
	for <dm-devel@archiver.kernel.org>; Fri, 11 Feb 2022 21:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1644616041;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=sh2PbuBVGHXemOIY7yZzC1pOC/WmsbNLqxT5yR8xyQk=;
	b=hrGLygmURUS5qf+4NpcUdrhApI+OxmXDkq60PkVc/2VfKjZPCv3A3rs6ddfLhwSw7zTftn
	vOGisNck+bYQvqXf5vFjz/8wrCCHudpBDQwKMG5DX0EHdS9T84UpLfRnlklknrnIKaGGF0
	rZKlE2DRNzlcgCa+GYMaJF4Zq/eUZig=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-459-zp1PsIITPCe5tHZeogYcig-1; Fri, 11 Feb 2022 16:47:16 -0500
X-MC-Unique: zp1PsIITPCe5tHZeogYcig-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 929EC8145F9;
	Fri, 11 Feb 2022 21:47:10 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5D12AE72B;
	Fri, 11 Feb 2022 21:47:10 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 30A414A7C8;
	Fri, 11 Feb 2022 21:47:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21BLfpoI024857 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 11 Feb 2022 16:41:51 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 6D5742026D2D; Fri, 11 Feb 2022 21:41:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 68BDD2024CC7
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 21:41:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3E27B805C1D
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 21:41:33 +0000 (UTC)
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
	[209.85.210.69]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-224-tPUC2A70OyORqKeM_lxM3A-1; Fri, 11 Feb 2022 16:41:30 -0500
X-MC-Unique: tPUC2A70OyORqKeM_lxM3A-1
Received: by mail-ot1-f69.google.com with SMTP id
	k3-20020a9d4b83000000b005a1871e98cbso6045757otf.10
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 13:41:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
	:references;
	bh=NzdOPJXGvWlTS8MF/XpfxdYLMQV7NltmT4t/BtAgnos=;
	b=x2ZSahVd7It2RXUAPCYLs4PS1Fdc7E9FUbVLDydmdoxVvgWBX/pSbkz7xIhhiXqDWy
	s2WjYWk8I6Izv1N3UlNKa8BrLoNkX3U0VYWEeWKnKx2Yb/CEec8Ug8iyHZ5BM/szQdO5
	DNkIoCY0yZeCoYl/A2spNQKycVzbbttQQmknrqpsSGRZn7+hPjDW7p1k/tg5+JRSkXkw
	MudRMYGeXf8ftJidxqTHjIFZYFr8g/msNRALsyh08lsNKySOvSUEufA8FR7cOsA+dha4
	MY79BsQWXNGHOzjQN65xw0ZHGikSH9zjqcfT0nOK5k5uSU6/lNVgVvpRAu/8/G+SSnUV
	Kfag==
X-Gm-Message-State: AOAM5315NAQ5VWUW6XALNl3+HTnpG26TZzomSgnDmroD3oLQCl7DuEKX
	ViFyV1SL961BLa74+YlVDp7wGL/TXji+ILBsH+LaPHJ5W3OzK8/VCD3i61/oYwJiLXZ5aGtNW5n
	krekMh0IhFD11HJOA63YWpV8j2hmDWNNw+KAulUHcHyNw2KVHhrPr6pF5p46KbS7dJw==
X-Received: by 2002:a05:6808:13d6:: with SMTP id
	d22mr1174122oiw.184.1644615689147; 
	Fri, 11 Feb 2022 13:41:29 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzjvjfCjbkgODKupEk2FfXco+AHWfmEFNUHW5C40tZr+sBFx1L6qwEAK968vKCKNbAHr0iUvg==
X-Received: by 2002:a05:6808:13d6:: with SMTP id
	d22mr1174103oiw.184.1644615688566; 
	Fri, 11 Feb 2022 13:41:28 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	o144sm10188855ooo.25.2022.02.11.13.41.27
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 11 Feb 2022 13:41:28 -0800 (PST)
From: Mike Snitzer <snitzer@redhat.com>
To: dm-devel@redhat.com
Date: Fri, 11 Feb 2022 16:40:57 -0500
Message-Id: <20220211214057.40612-15-snitzer@redhat.com>
In-Reply-To: <20220211214057.40612-1-snitzer@redhat.com>
References: <20220211214057.40612-1-snitzer@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org
Subject: [dm-devel] [PATCH v2 14/14] dm: move duplicate code in callers of
	alloc_tio into alloc_tio
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 2461df65e2fe..20c7b1b4d1f7 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -546,13 +546,16 @@ static struct bio *alloc_tio(struct clone_info *ci, struct dm_target *ti,
 		unsigned target_bio_nr, unsigned *len, gfp_t gfp_mask)
 {
 	struct dm_target_io *tio;
+	struct bio *clone;
 
 	if (!ci->io->tio.io) {
 		/* the dm_target_io embedded in ci->io is available */
 		tio = &ci->io->tio;
+		/* alloc_io() already initialized embedded clone */
+		clone = &tio->clone;
 	} else {
-		struct bio *clone = bio_alloc_clone(ci->bio->bi_bdev, ci->bio,
-						    gfp_mask, &ci->io->md->bs);
+		clone = bio_alloc_clone(ci->bio->bi_bdev, ci->bio,
+					gfp_mask, &ci->io->md->bs);
 		if (!clone)
 			return NULL;
 
@@ -567,7 +570,13 @@ static struct bio *alloc_tio(struct clone_info *ci, struct dm_target *ti,
 	tio->len_ptr = len;
 	tio->old_sector = 0;
 
-	return &tio->clone;
+	if (len) {
+		clone->bi_iter.bi_size = to_bytes(*len);
+		if (bio_integrity(clone))
+			bio_integrity_trim(clone);
+	}
+
+	return clone;
 }
 
 static void free_tio(struct bio *clone)
@@ -1258,17 +1267,12 @@ static void __send_duplicate_bios(struct clone_info *ci, struct dm_target *ti,
 		break;
 	case 1:
 		clone = alloc_tio(ci, ti, 0, len, GFP_NOIO);
-		if (len)
-			clone->bi_iter.bi_size = to_bytes(*len);
 		__map_bio(clone);
 		break;
 	default:
 		alloc_multiple_bios(&blist, ci, ti, num_bios, len);
-		while ((clone = bio_list_pop(&blist))) {
-			if (len)
-				clone->bi_iter.bi_size = to_bytes(*len);
+		while ((clone = bio_list_pop(&blist)))
 			__map_bio(clone);
-		}
 		break;
 	}
 }
@@ -1382,12 +1386,7 @@ static int __split_and_process_bio(struct clone_info *ci)
 		return r;
 
 	len = min_t(sector_t, max_io_len(ti, ci->sector), ci->sector_count);
-
 	clone = alloc_tio(ci, ti, 0, &len, GFP_NOIO);
-	clone->bi_iter.bi_size = to_bytes(len);
-	if (bio_integrity(clone))
-		bio_integrity_trim(clone);
-
 	__map_bio(clone);
 
 	ci->sector += len;
-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

