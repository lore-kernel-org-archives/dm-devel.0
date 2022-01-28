Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E677C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 28 Jan 2022 04:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1643343494;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=+8696gKBUp+NyiW0I/YSrpAsgcKVD3kOOU83Mqn4GjE=;
	b=BCTz2ehR90CMictpSIMa9yG4Bw4HNu6pmysUh3JZ4o6STQiOQti+6XevQ0DE5sWe+hM776
	NR7vGz8VzQK4ocIsMf+jit00wGLlN9IHA1IVMtDrYvRV7wkaiTS6ugDwJ42qO5vZBSF/d+
	Fe6qwPE9nAKbB1PnwzwXdmlS0V6Zhzk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-121-3o-0YHvAM9eOMF0uLF2U7g-1; Thu, 27 Jan 2022 23:18:11 -0500
X-MC-Unique: 3o-0YHvAM9eOMF0uLF2U7g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 78EB11083F65;
	Fri, 28 Jan 2022 04:18:07 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5E21B610A6;
	Fri, 28 Jan 2022 04:18:07 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 343CA1809CB9;
	Fri, 28 Jan 2022 04:18:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20S4I5lF009791 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 27 Jan 2022 23:18:05 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 61B7B200A4ED; Fri, 28 Jan 2022 04:18:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5D4CF2026612
	for <dm-devel@redhat.com>; Fri, 28 Jan 2022 04:17:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 21FC0811E76
	for <dm-devel@redhat.com>; Fri, 28 Jan 2022 04:17:59 +0000 (UTC)
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
	[209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-343-agJ57xVnOPSirNRb4U5XOw-1; Thu, 27 Jan 2022 23:17:57 -0500
X-MC-Unique: agJ57xVnOPSirNRb4U5XOw-1
Received: by mail-qv1-f72.google.com with SMTP id
	t3-20020a0562140c6300b00424a0fd3721so5081963qvj.12
	for <dm-devel@redhat.com>; Thu, 27 Jan 2022 20:17:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
	:references;
	bh=tQTNouHLD2pqrJUsY0rGuooqQ0qZGduHNcta+zU07XE=;
	b=UcGdHAKK06OE5YYJOE96z6jttYFewOJHys25Bq9W9gp9haJSJaRnPNJTTa1lyIUDjK
	RtYCkeeRoEQkanQ/ZEJHBIeiY6mro/I7WHEYxMDHdY6DhjrMuafFW3ekdQmgWhMm7B9L
	wDu0rxBq6CXSbLidSjlxeNpUX070w6UFfjv6qc2LTnveOmLGnBcpq2x7ZokbJtT7ORRo
	V8bmhC8hoWJvMseLSzbJAuO3rYHhVcdnQjkCISPbgpPCflyyr/clewIy2JRoSP/+RtCo
	de2iSiNWqnGjNirQVcAoHLY2GVz658LqtSECseF9EW5HEik9rSOApKFqY/pP3gLegyQh
	YbDg==
X-Gm-Message-State: AOAM530kY67JYDefDd4jaUYWpTu//aFbTi64PgPnkYceqX0rOb6FMDfh
	+fom0iNlkfEC2EZoULDzKzS9K3Q59KCBJ2o7bNkMrqcQKSx/bC+7lv3khSrA6fzwo8Bnz4pE9o9
	M9a2DLvTb7/gNEA==
X-Received: by 2002:ac8:7d0a:: with SMTP id g10mr4992289qtb.449.1643343477329; 
	Thu, 27 Jan 2022 20:17:57 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwzUbkSikg1u7V0kLUzFH1wyiqaoX9jOQQFHcVBPR42iTH4UoZhdUYJg81QtQgJlbjB1W2H6Q==
X-Received: by 2002:ac8:7d0a:: with SMTP id g10mr4992279qtb.449.1643343477149; 
	Thu, 27 Jan 2022 20:17:57 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	o19sm2353114qta.40.2022.01.27.20.17.56
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 27 Jan 2022 20:17:56 -0800 (PST)
From: Mike Snitzer <snitzer@redhat.com>
To: axboe@kernel.dk
Date: Thu, 27 Jan 2022 23:17:52 -0500
Message-Id: <20220128041753.32195-3-snitzer@redhat.com>
In-Reply-To: <20220128041753.32195-1-snitzer@redhat.com>
References: <20220128041753.32195-1-snitzer@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, hch@lst.de
Subject: [dm-devel] [PATCH v3 2/3] dm: revert partial fix for redundant
	bio-based IO accounting
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

Reverts a1e1cb72d9649 ("dm: fix redundant IO accounting for bios that
need splitting") because it was too narrow in scope (only addressed
redundant 'sectors[]' accounting and not ios, nsecs[], etc).

Cc: stable@vger.kernel.org
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index c0ae8087c602..9849114b3c08 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1442,9 +1442,6 @@ static void init_clone_info(struct clone_info *ci, struct mapped_device *md,
 	ci->sector = bio->bi_iter.bi_sector;
 }
 
-#define __dm_part_stat_sub(part, field, subnd)	\
-	(part_stat_get(part, field) -= (subnd))
-
 /*
  * Entry point to split a bio into clones and submit them to the targets.
  */
@@ -1480,18 +1477,6 @@ static void __split_and_process_bio(struct mapped_device *md,
 						  GFP_NOIO, &md->queue->bio_split);
 			ci.io->orig_bio = b;
 
-			/*
-			 * Adjust IO stats for each split, otherwise upon queue
-			 * reentry there will be redundant IO accounting.
-			 * NOTE: this is a stop-gap fix, a proper fix involves
-			 * significant refactoring of DM core's bio splitting
-			 * (by eliminating DM's splitting and just using bio_split)
-			 */
-			part_stat_lock();
-			__dm_part_stat_sub(dm_disk(md)->part0,
-					   sectors[op_stat_group(bio_op(bio))], ci.sector_count);
-			part_stat_unlock();
-
 			bio_chain(b, bio);
 			trace_block_split(b, bio->bi_iter.bi_sector);
 			submit_bio_noacct(bio);
-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

