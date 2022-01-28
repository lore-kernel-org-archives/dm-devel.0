Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC23BC433F5
	for <dm-devel@archiver.kernel.org>; Fri, 28 Jan 2022 15:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1643385547;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=+8696gKBUp+NyiW0I/YSrpAsgcKVD3kOOU83Mqn4GjE=;
	b=WHR3qz2T2Alm3SrvotfTHC64XSaBjuHuHxaqTjnQX7zaOj2IfTX3WOjZwiKNR/9u+J6Scw
	s1003evMOGuV/ucNY8DQ9O0lFgdZX0UAXyPI4ydBh2RefBZ+qMOyKBUDIylbWhVDyGpwKj
	5d6CsrXkTSZvhfXCj18Aqecy/yL66kI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-630-cDacO2vIOQaeGjkTmHnt1Q-1; Fri, 28 Jan 2022 10:59:01 -0500
X-MC-Unique: cDacO2vIOQaeGjkTmHnt1Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E099F189829C;
	Fri, 28 Jan 2022 15:58:55 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BF51B10A48A6;
	Fri, 28 Jan 2022 15:58:55 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 921851809CB9;
	Fri, 28 Jan 2022 15:58:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20SFwmR6026000 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 28 Jan 2022 10:58:48 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 00C5448FB03; Fri, 28 Jan 2022 15:58:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F143D4021B4
	for <dm-devel@redhat.com>; Fri, 28 Jan 2022 15:58:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D831838011EB
	for <dm-devel@redhat.com>; Fri, 28 Jan 2022 15:58:47 +0000 (UTC)
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
	[209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-245-UlbK686jNgWYFJYawaqpGw-1; Fri, 28 Jan 2022 10:58:46 -0500
X-MC-Unique: UlbK686jNgWYFJYawaqpGw-1
Received: by mail-qt1-f197.google.com with SMTP id
	h22-20020ac85696000000b002d258f68e98so4775164qta.22
	for <dm-devel@redhat.com>; Fri, 28 Jan 2022 07:58:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
	:references;
	bh=tQTNouHLD2pqrJUsY0rGuooqQ0qZGduHNcta+zU07XE=;
	b=L+7mfkg8fG8DwqIoA4RqNG/oweVyIyKG9Dl3u+kT/Rl9DxnO5ZXIhDkwF69009pkqq
	OaTqGkKXOf98yS61rPiB9R2R68DP8PruY+RKvN/K1FDzjRO4XkAC6xv7d3kcMWjNJP3O
	igfVkrWbg7eQ031WZ+6RVRm4Yp0l6DXcBV3MFI09GXQE0V5lLAMcD+D62ngkzc9vCJpw
	XDT03XLS1bmAYx+OxDCVDspBCy1FQx+PXkf8XDixTTDoIcUGm5JF40/nCkhp/kRtKkaL
	ieopxRBZ4/0p09N2as94ZPhHjToQUZQQiwklf8Rwiq5f8H8H+TEpX8SbubvVTLxJPp2I
	OU6g==
X-Gm-Message-State: AOAM531XQFpUayVfMLBONMKjw8LnZGw5GH2sLMAZI/IXhilZ9jt82VM2
	GE216aYqA2nsqDoNOcIoDv3oOKse1tCmPhffCa7cGmgyy+bqOe0kCJHtdNrG4uLRn5jldmmH79Q
	Qz+m67owAKC5QAw==
X-Received: by 2002:a05:622a:1c3:: with SMTP id
	t3mr6038270qtw.351.1643385525968; 
	Fri, 28 Jan 2022 07:58:45 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwNHfNKSXr+1lep/iO1OnUsy2vGC9QMAcEvKoGaf9wMxmW0wA7F9StMPgHCj0D2VwKmmzABRA==
X-Received: by 2002:a05:622a:1c3:: with SMTP id
	t3mr6038262qtw.351.1643385525788; 
	Fri, 28 Jan 2022 07:58:45 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	w20sm3650313qkp.102.2022.01.28.07.58.45
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 28 Jan 2022 07:58:45 -0800 (PST)
From: Mike Snitzer <snitzer@redhat.com>
To: axboe@kernel.dk
Date: Fri, 28 Jan 2022 10:58:40 -0500
Message-Id: <20220128155841.39644-3-snitzer@redhat.com>
In-Reply-To: <20220128155841.39644-1-snitzer@redhat.com>
References: <20220128155841.39644-1-snitzer@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, hch@lst.de
Subject: [dm-devel] [PATCH v4 2/3] dm: revert partial fix for redundant
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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

