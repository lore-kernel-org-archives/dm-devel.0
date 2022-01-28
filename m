Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FFE3C433EF
	for <dm-devel@archiver.kernel.org>; Fri, 28 Jan 2022 04:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1643343495;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=OO32XghO3nJqsELM/FdXTmYgGcLnmP2VbP0kL4wfNmg=;
	b=X1R6+1GhUZ/NL9/LMG4aBEUVnX5fHL3+R9ead7hBo4jYhzCgpX+x/hpk4IBFhKIloKE/Z3
	8CRWafgEe+NBH0OOSFFu6WbbPZRz3pRlnHe6Opfp0SibdQJlOsUn8wViG/aSdTDvexMiHa
	kQbraypq6gL9QfYZe0zix6Z/uvT/DEE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-635-wTaiPB0TMIidZBkxtcDUsg-1; Thu, 27 Jan 2022 23:18:11 -0500
X-MC-Unique: wTaiPB0TMIidZBkxtcDUsg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B3F901898291;
	Fri, 28 Jan 2022 04:18:06 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 686AD4DC18;
	Fri, 28 Jan 2022 04:18:06 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3446E1809CB9;
	Fri, 28 Jan 2022 04:18:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20S4I4UZ009783 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 27 Jan 2022 23:18:04 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 984A676E9; Fri, 28 Jan 2022 04:18:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9410F76E8
	for <dm-devel@redhat.com>; Fri, 28 Jan 2022 04:18:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2D5F585A5B5
	for <dm-devel@redhat.com>; Fri, 28 Jan 2022 04:18:01 +0000 (UTC)
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
	[209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-389-f7gASU57N3WpPlM2P8Hw0w-1; Thu, 27 Jan 2022 23:17:59 -0500
X-MC-Unique: f7gASU57N3WpPlM2P8Hw0w-1
Received: by mail-qv1-f69.google.com with SMTP id
	ge15-20020a05621427cf00b00421df9f8f23so5045451qvb.17
	for <dm-devel@redhat.com>; Thu, 27 Jan 2022 20:17:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
	:references;
	bh=1Bf1EUJyPBU3hvoZbXvQhOBhlizP0JEsfYBCXPFM+6E=;
	b=WGtxfpg3prUnl/Li7Pw/oq+MMRfriI5rHqDf1LAiFM6W/i1LbaTLi8Ux/BFWHNNgPA
	YjLHDQmqw+yrpMjaBbD/fBmrnNDCblbMgwq97YjQesECcf5gnHDS+ydUwKob1nlMvb5E
	B6MtgNCOZPCw2r80vAMqDY5pVg0VbwYdiK9fEP7EPYyS3zd919aCYJRC7LGWWUNATlN9
	lGSrtrXbVvrYK63mXI9igS4+UY23PMxImu3GqIA6AdALwE955zWCfwSDWiJr6svRmrq5
	uxFDBGXceHT8TsEjfD0bUI/5AdA+BqBAx3jOKgngL34UaX2hYfzNuqJmgmvg4VS4m41r
	nTSQ==
X-Gm-Message-State: AOAM531/WnV+dzJLtKO7x+s9y8Bca3Oh5LdXKpU3lMk0LB9iaaabhb3L
	jcFRxuO7LKCSNe1WVHPj6D9DQEq603z/3mTGbRZ/Wht1WgjP8rzTmZMm1szp6Pa8UUt7NBK6+/x
	f0yO025ru0Nclfg==
X-Received: by 2002:a05:622a:1109:: with SMTP id
	e9mr4938780qty.668.1643343479101; 
	Thu, 27 Jan 2022 20:17:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxjblMjZCrb4E1TKOCdtECb10lLL2MgcX9OKfcprTLIoUEorrr6OxHrIKHsSSiLf39WEBf2SQ==
X-Received: by 2002:a05:622a:1109:: with SMTP id
	e9mr4938772qty.668.1643343478907; 
	Thu, 27 Jan 2022 20:17:58 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52])
	by smtp.gmail.com with ESMTPSA id u9sm2578258qkp.37.2022.01.27.20.17.57
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 27 Jan 2022 20:17:58 -0800 (PST)
From: Mike Snitzer <snitzer@redhat.com>
To: axboe@kernel.dk
Date: Thu, 27 Jan 2022 23:17:53 -0500
Message-Id: <20220128041753.32195-4-snitzer@redhat.com>
In-Reply-To: <20220128041753.32195-1-snitzer@redhat.com>
References: <20220128041753.32195-1-snitzer@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, hch@lst.de
Subject: [dm-devel] [PATCH v3 3/3] dm: properly fix redundant bio-based IO
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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
Cc: stable@vger.kernel.org
Depends-on: f9893e1da2e3 ("block: add bio_start_io_acct_time() to control start_time")
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 9849114b3c08..144436301a57 100644
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
+	io->start_time = READ_ONCE(jiffies);
 
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

