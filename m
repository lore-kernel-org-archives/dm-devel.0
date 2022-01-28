Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B14D1C4321E
	for <dm-devel@archiver.kernel.org>; Fri, 28 Jan 2022 15:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1643385541;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=a81y7NKXXz2JKuthJ4ZxVjLHAY37qmxpLPMyvpTgWlA=;
	b=NoBHX78/ZCTswJvfUBZJmU3/z/n47e4yf//2QYbXUM2iY4oSQRrpYByi9mG6RFmtBpr7rZ
	JvCiM0MmtnHctNhOwYOwMQ0rgxYQWngMg4aa69u/zBin78rvUZEouY2QTTMpjJAtI8zCwF
	/ljPlRtpaq+jQivddoD2qgMQJDM9PBs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-397-p7vVd_QQNDq3RnT3ZJuOdw-1; Fri, 28 Jan 2022 10:58:58 -0500
X-MC-Unique: p7vVd_QQNDq3RnT3ZJuOdw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C55074686D;
	Fri, 28 Jan 2022 15:58:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A395910A48A9;
	Fri, 28 Jan 2022 15:58:53 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 22A8C1809CB8;
	Fri, 28 Jan 2022 15:58:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20SFwneD026016 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 28 Jan 2022 10:58:49 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A61462144B24; Fri, 28 Jan 2022 15:58:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A24F92144B22
	for <dm-devel@redhat.com>; Fri, 28 Jan 2022 15:58:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8A270802A5A
	for <dm-devel@redhat.com>; Fri, 28 Jan 2022 15:58:49 +0000 (UTC)
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
	[209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-196-x4coO1DFOU-YSfNB18U1lQ-1; Fri, 28 Jan 2022 10:58:48 -0500
X-MC-Unique: x4coO1DFOU-YSfNB18U1lQ-1
Received: by mail-qk1-f200.google.com with SMTP id
	u17-20020a05620a431100b004765c0dc33cso5097888qko.14
	for <dm-devel@redhat.com>; Fri, 28 Jan 2022 07:58:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
	:references;
	bh=c3s11MYpaHLkMPB6MRaVylhz5gNk+Yl6C2qy7I40rZo=;
	b=LsZDFR/iGVsiO+B/Q37+Up0OkwN4ulL93VU2RLWp3m7VjD658j5dSPIpEGhqt4RHf2
	8QehHLI7upf3ly4eRuXt7mETl2mlXoCFk4aaixHxXhQl+xcLTQes/CKnSi36u4wkz6cr
	Wwo2B3/kAmcTqqB8ElT5SboVsrU5DR1akL/axpbAzFnOQnUBAr4ieeBtHRERDItgj0dO
	G2B+SrFgF425jUTzlHKg6Aio3Uph0T+jlrEET2vWDzJ4Ax2gDkoRYYhVB4nj5AYiInyX
	0Zf5JxKDQay9LOc/aSIDePxViFXz+1vWzAwvWnK7wWsoZUcNXOSvtCR1Vo5QQzCSfmEi
	qVfA==
X-Gm-Message-State: AOAM531wK//ouNXbh2Czes7o3iWnHP8+MHncLg/RAF0UqrrZtJ751YHU
	AgpwvMeGKRPCRtr8JvZpVnxfbmAGyFs32tDCUFf42lHKLq37d5zAOfYiggrRdx9sbIHupc2+gPu
	HyFn5TDLytnRskw==
X-Received: by 2002:ad4:5c4f:: with SMTP id a15mr7612219qva.37.1643385527770; 
	Fri, 28 Jan 2022 07:58:47 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyicgWAEB6ayWqMlLhzSn7kxy+IJwfePHjuqVVRWhOwQ3qf8gee6U9e8wmQ3bOt09J6PLJR5w==
X-Received: by 2002:ad4:5c4f:: with SMTP id a15mr7612210qva.37.1643385527577; 
	Fri, 28 Jan 2022 07:58:47 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	l11sm3665173qkp.86.2022.01.28.07.58.46
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 28 Jan 2022 07:58:47 -0800 (PST)
From: Mike Snitzer <snitzer@redhat.com>
To: axboe@kernel.dk
Date: Fri, 28 Jan 2022 10:58:41 -0500
Message-Id: <20220128155841.39644-4-snitzer@redhat.com>
In-Reply-To: <20220128155841.39644-1-snitzer@redhat.com>
References: <20220128155841.39644-1-snitzer@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, hch@lst.de
Subject: [dm-devel] [PATCH v4 3/3] dm: properly fix redundant bio-based IO
	accounting
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

Record the start_time for a bio but defer the starting block core's IO
accounting until after IO is submitted using bio_start_io_acct_time().

This approach avoids the need to mess around with any of the
individual IO stats in response to a bio_split() that follows bio
submission.

Reported-by: Bud Brown <bubrown@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: stable@vger.kernel.org
Depends-on: 1073e8492f88 ("block: add bio_start_io_acct_time() to control start_time")
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 9849114b3c08..dcbd6d201619 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -489,7 +489,7 @@ static void start_io_acct(struct dm_io *io)
 	struct mapped_device *md = io->md;
 	struct bio *bio = io->orig_bio;
 
-	io->start_time = bio_start_io_acct(bio);
+	bio_start_io_acct_time(bio, io->start_time);
 	if (unlikely(dm_stats_used(&md->stats)))
 		dm_stats_account_io(&md->stats, bio_data_dir(bio),
 				    bio->bi_iter.bi_sector, bio_sectors(bio),
@@ -535,7 +535,7 @@ static struct dm_io *alloc_io(struct mapped_device *md, struct bio *bio)
 	io->md = md;
 	spin_lock_init(&io->endio_lock);
 
-	start_io_acct(io);
+	io->start_time = jiffies;
 
 	return io;
 }
@@ -1482,6 +1482,7 @@ static void __split_and_process_bio(struct mapped_device *md,
 			submit_bio_noacct(bio);
 		}
 	}
+	start_io_acct(ci.io);
 
 	/* drop the extra reference count */
 	dm_io_dec_pending(ci.io, errno_to_blk_status(error));
-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

