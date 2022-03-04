Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 159F1C433EF
	for <dm-devel@archiver.kernel.org>; Fri,  4 Mar 2022 21:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1646429205;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=gmJQ2uL2w+AmkEsMNE1T10n24Zy3ND3ANnKSwlXfNjs=;
	b=fuH40CyOBuKr4Xam0+uIcFcu+uKfGqIgvmYYXhjL63hIKHo/3rYYerm3JBfaM3r/Y6AcKR
	v8ZDVbKojT+QGpVhTIA6wlXymESYnpthe3Bc0sAZ1zIg79YRnVXn5emy7HpGpUyC4GnmLF
	QzsG4/HPJONJgwSuclB8gNjgM0c2WW0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-266-jZFMiqKHOtSoNlWHrTs1AQ-1; Fri, 04 Mar 2022 16:26:42 -0500
X-MC-Unique: jZFMiqKHOtSoNlWHrTs1AQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 530CA180FD72;
	Fri,  4 Mar 2022 21:26:37 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 69DA356F6E;
	Fri,  4 Mar 2022 21:26:35 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id EA3884EA37;
	Fri,  4 Mar 2022 21:26:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 224LQVVp011331 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 4 Mar 2022 16:26:31 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B2D9B202660C; Fri,  4 Mar 2022 21:26:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AD77C200B696
	for <dm-devel@redhat.com>; Fri,  4 Mar 2022 21:26:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 683033803917
	for <dm-devel@redhat.com>; Fri,  4 Mar 2022 21:26:28 +0000 (UTC)
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
	[209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-536-VsoL8gBOPrmah98ccmslNw-1; Fri, 04 Mar 2022 16:26:27 -0500
X-MC-Unique: VsoL8gBOPrmah98ccmslNw-1
Received: by mail-qv1-f69.google.com with SMTP id
	w7-20020a0ce107000000b0043512c55ecaso7941470qvk.11
	for <dm-devel@redhat.com>; Fri, 04 Mar 2022 13:26:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
	:references;
	bh=u3JizttDnirlW0fMUt56CDfPU64YbUD435+Bb5JoywE=;
	b=NsE2vTSWZr+rCu45ttMFVkzwuqZx0kcXEzaPJcMgLa1avjAdm4f6fIEwcy0Wh5w/4M
	tKfWwASzfYUyy50VoUOT+I4siDiMAqW3945tEwDFWHUDHqcw7OU0ifbiEBerqwOaW/qv
	It1REWrnC9IM6sKO01MMipP0rZz0ZvdM+L7i7WBzHU7GMz4zMY6eEzQ/Ku7WSqa/SAoX
	WxihDPeUifSUFal9nHAClAWLvasPmms3C31vB6bG1zQvFG+dTF9tR8mKkKuWkYXnpXlq
	w8EZu9ExGVcBY6XsCdHo92RiQVcnMpR26Z5p1fknApt04LUkkURgxRhE2SjoPY94shB3
	sEVQ==
X-Gm-Message-State: AOAM533qA7g5GCdBlzVviLQlhg8neyxQ8VtasLHoG+G1kBvKK48Ng16W
	kSFgCFPSn6/Gj4OPfuJNzpZuwI0Bmn4gTjEtEA36ShKBW4bjpujdNo1pYR8bFpsVMdKse77/D/C
	IXG74xGHsQSV8pQ==
X-Received: by 2002:a05:622a:48f:b0:2dd:b41a:e206 with SMTP id
	p15-20020a05622a048f00b002ddb41ae206mr666411qtx.274.1646429186680;
	Fri, 04 Mar 2022 13:26:26 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwqW5GCMKvuqgxUxRYl6ae7o3MM/vyX88ha2no7fzevAHX+A2WiT26fh9A3P4zHYp3OiTR69A==
X-Received: by 2002:a05:622a:48f:b0:2dd:b41a:e206 with SMTP id
	p15-20020a05622a048f00b002ddb41ae206mr666398qtx.274.1646429186469;
	Fri, 04 Mar 2022 13:26:26 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	s19-20020ac85cd3000000b002de4e165ae0sm3977166qta.75.2022.03.04.13.26.25
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 04 Mar 2022 13:26:25 -0800 (PST)
From: Mike Snitzer <snitzer@redhat.com>
To: axboe@kernel.dk
Date: Fri,  4 Mar 2022 16:26:22 -0500
Message-Id: <20220304212623.34016-2-snitzer@redhat.com>
In-Reply-To: <20220304212623.34016-1-snitzer@redhat.com>
References: <20220304212623.34016-1-snitzer@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, hch@lst.de,
	ming.lei@redhat.com
Subject: [dm-devel] [PATCH v4 1/2] block: add ->poll_bio to
	block_device_operations
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

From: Ming Lei <ming.lei@redhat.com>

Prepare for supporting IO polling for bio based driver.

Add ->poll_bio callback so that bio driver can provide their own logic
for polling bio.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-core.c       | 12 +++++++++---
 block/genhd.c          |  2 ++
 include/linux/blkdev.h |  2 ++
 3 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 94bf37f8e61d..e739c6264331 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -985,10 +985,16 @@ int bio_poll(struct bio *bio, struct io_comp_batch *iob, unsigned int flags)
 
 	if (blk_queue_enter(q, BLK_MQ_REQ_NOWAIT))
 		return 0;
-	if (WARN_ON_ONCE(!queue_is_mq(q)))
-		ret = 0;	/* not yet implemented, should not happen */
-	else
+	if (queue_is_mq(q)) {
 		ret = blk_mq_poll(q, cookie, iob, flags);
+	} else {
+		struct gendisk *disk = q->disk;
+
+		if (disk && disk->fops->poll_bio)
+			ret = disk->fops->poll_bio(bio, iob, flags);
+		else
+			ret = !WARN_ON_ONCE(1);
+	}
 	blk_queue_exit(q);
 	return ret;
 }
diff --git a/block/genhd.c b/block/genhd.c
index e351fac41bf2..eb43fa63ba47 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -410,6 +410,8 @@ int __must_check device_add_disk(struct device *parent, struct gendisk *disk,
 	struct device *ddev = disk_to_dev(disk);
 	int ret;
 
+	WARN_ON_ONCE(queue_is_mq(disk->queue) && disk->fops->poll_bio);
+
 	/*
 	 * The disk queue should now be all set with enough information about
 	 * the device for the elevator code to pick an adequate default
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index f757f9c2871f..51f1b1ddbed2 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1455,6 +1455,8 @@ enum blk_unique_id {
 
 struct block_device_operations {
 	void (*submit_bio)(struct bio *bio);
+	int (*poll_bio)(struct bio *bio, struct io_comp_batch *iob,
+			unsigned int flags);
 	int (*open) (struct block_device *, fmode_t);
 	void (*release) (struct gendisk *, fmode_t);
 	int (*rw_page)(struct block_device *, sector_t, struct page *, unsigned int);
-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

