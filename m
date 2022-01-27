Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 384D9C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 27 Jan 2022 22:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1643324241;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=jsuG6/QQL+FXYPNtlV87OyZmn6FlrIfjinHn8/iLJu0=;
	b=dkginsvlP3+UXQmaVd1UdTqG3TDr74zutdU5nxIqdjgy+t/cdY/WpKP5sRtR9d+2Dw24u8
	bxkDg1PxXTE7EYEMGNQXA7umwb6uwqk68JLJ6/2h5z7TCazyajVRN8sqR4TvWInGV4vl9W
	HpsIOpoeKCndovhBNfcO6IBDJVSdAjc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-12-6QqnXI8qNNGGfc3ihzRvLQ-1; Thu, 27 Jan 2022 17:57:19 -0500
X-MC-Unique: 6QqnXI8qNNGGfc3ihzRvLQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 24763100C664;
	Thu, 27 Jan 2022 22:57:15 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A65F94DC2C;
	Thu, 27 Jan 2022 22:57:14 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 735731809CBF;
	Thu, 27 Jan 2022 22:57:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20RMuu8q019721 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 27 Jan 2022 17:56:57 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B125F4021B2; Thu, 27 Jan 2022 22:56:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id ADD3D48FB04
	for <dm-devel@redhat.com>; Thu, 27 Jan 2022 22:56:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 93F7C1C07CEA
	for <dm-devel@redhat.com>; Thu, 27 Jan 2022 22:56:56 +0000 (UTC)
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
	[209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-501-EM2uq64TMj6PDzCHk87edQ-1; Thu, 27 Jan 2022 17:56:55 -0500
X-MC-Unique: EM2uq64TMj6PDzCHk87edQ-1
Received: by mail-qt1-f197.google.com with SMTP id
	h22-20020ac85696000000b002d258f68e98so3257179qta.22
	for <dm-devel@redhat.com>; Thu, 27 Jan 2022 14:56:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
	:references;
	bh=vJ6TnJPKd3jnAAKSRYmEdyBJB9c5u4F9myAf76vl6jE=;
	b=drFDDSCl22UxsMRT1Jp5OiAH5V1RPugmjTuY7Gj00SSkqU8WK9Mv8aGTkVSJ1jLtlh
	Uk8K+t8BTrFH3BnzEBIw7GuZfQeTenXVxJij8zU+W6d6Jo3baEx1YwbM8irQA+79ESWg
	cgMEqLB8JLUq3bqVR/R4vfAeNEf7NPrPbJ1HqbSJdjxvkSF6vqzNY/WnyyUJr3wa3WXJ
	Xi3jf2z4C1h5jSc5cPNipghJl1N2jcojLl+i7ElTpqs0BUoEMOdyFb8KsrTzj+y5hk1s
	P/rQ58MA9I8jenSE5QtvHMiWrVi3FvaIYkM7gCzHHYms94C/z8k3EHdB+fNRm2QzTS9p
	SshQ==
X-Gm-Message-State: AOAM532RNEg55+QrFLx9+VKuGkr0GYgDKJjy38h/+dZCivit//YG8mxv
	0X0uLEco/6/QWQDI8eYtFfXiryuOAXxrxOCcV2Agkrrk70MSrs97OcdN0j/npEU2XyloBMGRfQx
	Gp6zfVu3Uneypyg==
X-Received: by 2002:a05:620a:450c:: with SMTP id
	t12mr4251283qkp.343.1643324214622; 
	Thu, 27 Jan 2022 14:56:54 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx0nJBNt2XNTVFChnIRxj7wnHOd+t1Jl5N/kzJqu73nkFplu02EOEvuNXsrUdyeMf2Ql9ud7g==
X-Received: by 2002:a05:620a:450c:: with SMTP id
	t12mr4251277qkp.343.1643324214446; 
	Thu, 27 Jan 2022 14:56:54 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	n17sm1149219qkp.89.2022.01.27.14.56.53
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 27 Jan 2022 14:56:54 -0800 (PST)
From: Mike Snitzer <snitzer@redhat.com>
To: axboe@kernel.dk
Date: Thu, 27 Jan 2022 17:56:48 -0500
Message-Id: <20220127225648.28729-4-snitzer@redhat.com>
In-Reply-To: <20220127225648.28729-1-snitzer@redhat.com>
References: <20220127225648.28729-1-snitzer@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, hch@lst.de
Subject: [dm-devel] [PATCH v2 3/3] dm: properly fix redundant bio-based IO
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
+	__bio_start_io_acct(bio, io->start_time);
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

