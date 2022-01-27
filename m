Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D1F4C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 27 Jan 2022 19:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1643310481;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=+8696gKBUp+NyiW0I/YSrpAsgcKVD3kOOU83Mqn4GjE=;
	b=WOSAXXYRx8P6jYRuCdgRTKXP9Mq1HRsphh9CNHjcbKbdW4Q9NOaE3bEMcNhFlwGw4MgFx1
	B1GSBAsoOFpEyQAKdl0pSZYEuq9U/HvtfDXTmGTAgjFAq9bNLjHntmpDwdLIDe1kCoUJbT
	ruOrJjYo/RhQ6YF4Rk2nbPhSWSVPABY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-591-zgB14uUZOhS3WLouqsbrUg-1; Thu, 27 Jan 2022 14:07:57 -0500
X-MC-Unique: zgB14uUZOhS3WLouqsbrUg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1C55283DD20;
	Thu, 27 Jan 2022 19:07:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EC2305D6D5;
	Thu, 27 Jan 2022 19:07:52 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 91DF71809CBF;
	Thu, 27 Jan 2022 19:07:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
	[10.11.54.7])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20RJ7oro004302 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 27 Jan 2022 14:07:50 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A20D5141DC57; Thu, 27 Jan 2022 19:07:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9EDA8141DC2C
	for <dm-devel@redhat.com>; Thu, 27 Jan 2022 19:07:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 862CC3C02193
	for <dm-devel@redhat.com>; Thu, 27 Jan 2022 19:07:50 +0000 (UTC)
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
	[209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-456-EMNPL6D6MNiU1ASNbo5iSw-1; Thu, 27 Jan 2022 14:07:48 -0500
X-MC-Unique: EMNPL6D6MNiU1ASNbo5iSw-1
Received: by mail-qv1-f69.google.com with SMTP id
	x2-20020ad44622000000b0042555fbc04fso4051899qvv.18
	for <dm-devel@redhat.com>; Thu, 27 Jan 2022 11:07:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
	:references;
	bh=tQTNouHLD2pqrJUsY0rGuooqQ0qZGduHNcta+zU07XE=;
	b=NWa4wCgSBalo4y7V8eBUepS/nYFfuGZ9tEZ9SbQayE2pGCHE3U2jmKUElpmodnJm7o
	+rH20w2ZlmsYTn1EoBQL27JTD8EN+xTfZ6FRvaiGivXfWAt/bWogNZOlYI19pUX6k44x
	of+vWQYfwG4ZUB0Yi/ASMMgPpqftYfMnZB0i+ZVmcS4b6dW6eXDpv2luTvscdG+GDhcA
	3/CHDMdytmaZEb/GzbNQLdiCOCi25/GmTKclPqRsLaHsfHtixYbHzBjdUYthFPK0QnDm
	gX/tXrXbPULmSEDwxig35H/oIqMQPDOIXHdJB90JErrHhnPRFlUItZ28MxEnMCrWG91m
	/r7w==
X-Gm-Message-State: AOAM530DMyCnK83iFDhGLRqU9bKjpsmKB0W/nIEzxhFu0KsNJufMJr7X
	kea1dvATvg3hNuiskqb00wJjJsYyGCeFUDApKFKx3Zhn4Tg3bQErsy4zHH4AfZyauK3mMJB6YZH
	iGVJn+9zhjoxsEQ==
X-Received: by 2002:a05:6214:5283:: with SMTP id
	kj3mr4186783qvb.44.1643310467911; 
	Thu, 27 Jan 2022 11:07:47 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxLXfr5ejiKHZx1ikK0AjZiulBItlwcYvACwkbT0h4rgqFSKIcHUzV6pNWRSgRjrkRpIubxgg==
X-Received: by 2002:a05:6214:5283:: with SMTP id
	kj3mr4186766qvb.44.1643310467651; 
	Thu, 27 Jan 2022 11:07:47 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52])
	by smtp.gmail.com with ESMTPSA id r3sm1816610qkm.56.2022.01.27.11.07.47
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 27 Jan 2022 11:07:47 -0800 (PST)
From: Mike Snitzer <snitzer@redhat.com>
To: axboe@kernel.dk
Date: Thu, 27 Jan 2022 14:07:41 -0500
Message-Id: <20220127190742.12776-3-snitzer@redhat.com>
In-Reply-To: <20220127190742.12776-1-snitzer@redhat.com>
References: <20220127190742.12776-1-snitzer@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com
Subject: [dm-devel] [PATCH 2/3] dm: revert partial fix for redundant
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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

