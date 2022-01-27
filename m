Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F24CC433F5
	for <dm-devel@archiver.kernel.org>; Thu, 27 Jan 2022 19:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1643310499;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ByJYAnn9bLtU+87UdtyF+LHKoaiPPE2qhQ475K92bH8=;
	b=Uc9edgIlV3sbPUZx5a1YyaoQpbEQoqGocdyVmCZBIoOH76L0L5qCws716v57qHcyFdWHhA
	NVTJxx/QWOZ76oCNq6Y151nzheWgsG+8FhaoOk4mXiwawhJ85jvwiwouNvAVKoP+pm59Wp
	q5gel8UuNmmWkJI+h/oZwf52Ux+bS68=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-398-0M6n3W7YPHuCd0F6G0pKjQ-1; Thu, 27 Jan 2022 14:08:15 -0500
X-MC-Unique: 0M6n3W7YPHuCd0F6G0pKjQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E6EA883DD25;
	Thu, 27 Jan 2022 19:08:10 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C749E45D61;
	Thu, 27 Jan 2022 19:08:10 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9BEB54CA93;
	Thu, 27 Jan 2022 19:08:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20RJ7pcO004307 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 27 Jan 2022 14:07:51 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 5CECE4021B4; Thu, 27 Jan 2022 19:07:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 590B94021B2
	for <dm-devel@redhat.com>; Thu, 27 Jan 2022 19:07:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 401233C021A3
	for <dm-devel@redhat.com>; Thu, 27 Jan 2022 19:07:51 +0000 (UTC)
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
	[209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-324-tDETjSowNp6NHGiJYXY7Vg-1; Thu, 27 Jan 2022 14:07:49 -0500
X-MC-Unique: tDETjSowNp6NHGiJYXY7Vg-1
Received: by mail-qt1-f200.google.com with SMTP id
	l15-20020ac84ccf000000b002cf9424cfa5so2938714qtv.7
	for <dm-devel@redhat.com>; Thu, 27 Jan 2022 11:07:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
	:references;
	bh=2JN+LOniMXFro+iNkmrv3NdOziHLaBtesI3NZwO1yaE=;
	b=oys7/8XJ2lNYajyi5gnN1DRZRXE4ebUDfIiHU/wh/KKfIh1olC7/jG8xuP1PwMn9NQ
	+v5UNoBoAlHnSW6J++T0kTbEi4ojPefSkgkds/TCT7smTwfu1muFISzBAq4gT8O3uaGe
	TfbMQUUakjOGSIdNVZyCm9oVR9rL+DNjSdx0XLHSvLXDSji2a8hlYuj/oQHnbemcRlyB
	hKTNutsXWDXDJm7lGGyI0FLdLAiWGp1uQIL67BhHCVok3StBGMxb47XxmP9dX6SMOKrG
	VT07PshWpkllZXyynahPMwsnY8cKrSo1rsCIfx5mOlb9tYU0JL3mHC1ishk2LpSP6hCh
	rM7g==
X-Gm-Message-State: AOAM533oyRdwb0aO01Gq4GMyxd0S41Oots6vxZzjXMvEorgxxU1au8XN
	mc327xHifo3L4YFm3QfAeaU4uDs5PrzGgYMujSUZCdQ4NFUvNkzlj438xg392xUW4DIi0STAEvi
	O03EvlT4yguzX8w==
X-Received: by 2002:a05:620a:138c:: with SMTP id
	k12mr3748669qki.727.1643310469476; 
	Thu, 27 Jan 2022 11:07:49 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy8y8ISQKT74HIcxOb8RAwKBCEXzsuDElroT3TNZEEsMsmQR/6TnFw9eNzPzOVsNXWHOn5Kdw==
X-Received: by 2002:a05:620a:138c:: with SMTP id
	k12mr3748651qki.727.1643310469289; 
	Thu, 27 Jan 2022 11:07:49 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	k15sm2076787qko.82.2022.01.27.11.07.48
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 27 Jan 2022 11:07:48 -0800 (PST)
From: Mike Snitzer <snitzer@redhat.com>
To: axboe@kernel.dk
Date: Thu, 27 Jan 2022 14:07:42 -0500
Message-Id: <20220127190742.12776-4-snitzer@redhat.com>
In-Reply-To: <20220127190742.12776-1-snitzer@redhat.com>
References: <20220127190742.12776-1-snitzer@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com
Subject: [dm-devel] [PATCH 3/3] dm: properly fix redundant bio-based IO
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Record the start_time for a bio but defer the starting block core's IO
accounting until after IO is submitted using __bio_start_io_acct().

This approach avoids the need to mess around with any of the
individual IO stats in response to a bio_split() that follows bio
submission.

Reported-by: Bud Brown <bubrown@redhat.com>
Cc: stable@vger.kernel.org
Depends-on: e8d7405fccc6 ("block: add __bio_start_io_acct() to control start_time")
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

