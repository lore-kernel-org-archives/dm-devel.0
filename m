Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 460AFC433FE
	for <dm-devel@archiver.kernel.org>; Thu, 27 Jan 2022 22:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1643324243;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=+8696gKBUp+NyiW0I/YSrpAsgcKVD3kOOU83Mqn4GjE=;
	b=hfwfmoZPMdMAqDXuduSuFEZ5GXvwEvVqE8495Xl8p+UQxDc5HjuNqxAAIdnQseVptEeTy6
	6c9o96nyiz+bm9oNlYVmmF3PLAev+E0NZ/eeWGaYml/4tR/TgPMksVC6ZR80tmW6A4EBeg
	ObciwqPJbl51U0qXho+FcsDWMJfb+5w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-219-yZ_ncyxlPP-LTMEb0Y8F5g-1; Thu, 27 Jan 2022 17:57:19 -0500
X-MC-Unique: yZ_ncyxlPP-LTMEb0Y8F5g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6203F1898296;
	Thu, 27 Jan 2022 22:57:15 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 19C1056F8B;
	Thu, 27 Jan 2022 22:57:15 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 756474BB7C;
	Thu, 27 Jan 2022 22:57:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20RMuwb0019726 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 27 Jan 2022 17:56:58 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E60F81120AC8; Thu, 27 Jan 2022 22:56:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E1BC51120AC5
	for <dm-devel@redhat.com>; Thu, 27 Jan 2022 22:56:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BFA8F3804095
	for <dm-devel@redhat.com>; Thu, 27 Jan 2022 22:56:54 +0000 (UTC)
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
	[209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-515-N_Qd9vf5MRWS_K-aCFyayg-1; Thu, 27 Jan 2022 17:56:53 -0500
X-MC-Unique: N_Qd9vf5MRWS_K-aCFyayg-1
Received: by mail-qk1-f200.google.com with SMTP id
	h10-20020a05620a284a00b0047649c94bc7so3469388qkp.20
	for <dm-devel@redhat.com>; Thu, 27 Jan 2022 14:56:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
	:references;
	bh=tQTNouHLD2pqrJUsY0rGuooqQ0qZGduHNcta+zU07XE=;
	b=Iqc5Ds6XzE6PZvgxb6zZwR+dqrEhGTYmOs917v0Fy0G0vOD8szDEe86C1VJNHIAAnq
	hgfT+FgwLQ6QksnXfrGxIpaf0+kmIRRpXEuwlq/IKT13VZ6VCFzMXIYzmOhb+RcDZKVI
	cFBH20pSiEKH+Ssv+saUbJ3LdXZ9mJ27JZTEoBWyouGeV4+670SLZOKMczkXVnkOIgcI
	W6U+udSoOaEtopY/Wu7XE/vl7cYpiX0G7DuVuw9X0cxf1Oas7YKhAdXQqwauBSXUTqME
	98SYpCbpkCPrL38TayNY3MIQLROgSt16Vi0fnRYRTD14HqTMbh4n+qeXOimE8H2wMe8r
	dBiw==
X-Gm-Message-State: AOAM530uNTojXpEEl4dWcW/j5SPMfEk+8QywgLJTFTp3om4MeDAFiBMI
	YlgPxwZRUwkfITrASoYnkvCYp23Ee8cQTW7YgGWoK6FWy9il7dTsu2STjNTFGpCzVBBsmWjY8D4
	3eD/mfo569Qd+RQ==
X-Received: by 2002:a05:620a:103c:: with SMTP id
	a28mr4150248qkk.417.1643324212904; 
	Thu, 27 Jan 2022 14:56:52 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyL2H63eKsh0Qu7Yz6ytqgIu4GetPzYuDGznITAsL1ZAj2qOMKyljpt5v1X/OwIwEtcD0UfYw==
X-Received: by 2002:a05:620a:103c:: with SMTP id
	a28mr4150241qkk.417.1643324212703; 
	Thu, 27 Jan 2022 14:56:52 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	p134sm2016512qke.29.2022.01.27.14.56.51
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 27 Jan 2022 14:56:52 -0800 (PST)
From: Mike Snitzer <snitzer@redhat.com>
To: axboe@kernel.dk
Date: Thu, 27 Jan 2022 17:56:47 -0500
Message-Id: <20220127225648.28729-3-snitzer@redhat.com>
In-Reply-To: <20220127225648.28729-1-snitzer@redhat.com>
References: <20220127225648.28729-1-snitzer@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, hch@lst.de
Subject: [dm-devel] [PATCH v2 2/3] dm: revert partial fix for redundant
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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

