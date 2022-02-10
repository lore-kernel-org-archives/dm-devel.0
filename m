Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB0EAC433F5
	for <dm-devel@archiver.kernel.org>; Thu, 10 Feb 2022 22:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1644532969;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=hmZqFXmqlbomLCgs702cXstB+BQ7+uRIYlglQZ72EjM=;
	b=cyf4LLYeQo9tpFzMYFlHOwqjkar6M9O6yq3t50604yYu5TSVLN/I9L+PfTQfe/YLmzxN/T
	sCHguG8bPsEkRucfU54fxGs1/x+vjd5GF3TESJFVx5qfFXOE+CKw1AsyS9qgzGtcRzD8oi
	IOsH7OEkFt9wGO6AHNqrLzRCYRPQQoY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-475-9YTfVYUbPL2Kl307IdTmIQ-1; Thu, 10 Feb 2022 17:42:48 -0500
X-MC-Unique: 9YTfVYUbPL2Kl307IdTmIQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D511181424B;
	Thu, 10 Feb 2022 22:42:43 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B993546971;
	Thu, 10 Feb 2022 22:42:43 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 900821809CB9;
	Thu, 10 Feb 2022 22:42:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21AMcsP6014866 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 10 Feb 2022 17:38:54 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1138F40885B9; Thu, 10 Feb 2022 22:38:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0D9A440885B5
	for <dm-devel@redhat.com>; Thu, 10 Feb 2022 22:38:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EAEE21C04B55
	for <dm-devel@redhat.com>; Thu, 10 Feb 2022 22:38:53 +0000 (UTC)
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
	[209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-55-BlEWvNG_MZ-SodVXQITI3g-1; Thu, 10 Feb 2022 17:38:52 -0500
X-MC-Unique: BlEWvNG_MZ-SodVXQITI3g-1
Received: by mail-qt1-f200.google.com with SMTP id
	a9-20020aed2789000000b002d78436cc47so5539707qtd.12
	for <dm-devel@redhat.com>; Thu, 10 Feb 2022 14:38:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
	:references;
	bh=+Mnt9RTq0AtjFUsH7/0mhHCJN7nnx7AZj3Cr8laEsbg=;
	b=ONJpznVwvl8Ydkn4xqXpyrtCDWT6d4YLSer24fKCc3kIrlOWcgw1CPBfFw/z2hQHNp
	EnlHuo4SxK7Uuvd0P44AwWb2l8xQSNI7GKZCyGQz0wkxOtC6awMKm6i2JQ/+0uoyaIN6
	iYWGpXEutkkhremU+Gn6Me+4pxQ+8leQnUQnQWAIB9h2ko8vhDz0wJRac2ljjSvaVzu9
	6XjFgoi7y8xufDyC1JQCVYl2GlxspeaaM3mo3eS+I1uZQdNVqPjSNcKHxWOW/8Trrw3i
	gZ3vU50zV3wykd8CxNtMwGsnpziUbt/8mzGrVUTF8dDO26UUY5/Tzlg6pJB4d1QwQAzF
	XN4w==
X-Gm-Message-State: AOAM5308d8uYiDz+l+ge9JIVLA4T9jkwwwPU9HwcX0MueW0xZ58cUoSd
	P0hxDRqWDnyL2eB3TMVFKTUobVP0QifeOUl9mMpxXDsC6R5rfxS49CYguD6TAaimtff5YYJuJpF
	24LJ6fdqds8wHajA0zWVxeNBNMRWGCmSVVV3qAqUORrC7WRTIpSuke+3P/dNPVCST/A==
X-Received: by 2002:a05:6214:2306:: with SMTP id
	gc6mr6868148qvb.63.1644532732050; 
	Thu, 10 Feb 2022 14:38:52 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyamo0E431a2/YSMBqGadwIEB+1DQaLXFNobXLpuclNidyN4EcKw4raCDde0o/OY6oGwrdnag==
X-Received: by 2002:a05:6214:2306:: with SMTP id
	gc6mr6868140qvb.63.1644532731828; 
	Thu, 10 Feb 2022 14:38:51 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	r3sm10312080qkm.56.2022.02.10.14.38.51
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 10 Feb 2022 14:38:51 -0800 (PST)
From: Mike Snitzer <snitzer@redhat.com>
To: dm-devel@redhat.com
Date: Thu, 10 Feb 2022 17:38:31 -0500
Message-Id: <20220210223832.99412-14-snitzer@redhat.com>
In-Reply-To: <20220210223832.99412-1-snitzer@redhat.com>
References: <20220210223832.99412-1-snitzer@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org
Subject: [dm-devel] [PATCH 13/14] dm: improve correctness and efficiency of
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

Don't use jiffies as a glorified bool because jiffies can/will
rollover to 0.

Also use xchg(), instead of spin_lock_irq{save,restore} and
smp_load_acquire/smp_store_release, to avoid performance impact of
disabling and enabling interrupts.

Suggested-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-core.h |  2 +-
 drivers/md/dm.c      | 34 ++++++++++++----------------------
 2 files changed, 13 insertions(+), 23 deletions(-)

diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
index 3ecd6f294f53..d3c116866fd7 100644
--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -230,7 +230,7 @@ struct dm_io {
 	atomic_t io_count;
 	struct bio *orig_bio;
 	unsigned long start_time;
-	unsigned long io_acct_time;
+	int was_accounted;
 	spinlock_t lock;
 	struct dm_stats_aux stats_aux;
 	/* last member of dm_target_io is 'struct bio' */
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index ad512f40716e..329f0be64523 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -487,17 +487,6 @@ EXPORT_SYMBOL_GPL(dm_start_time_ns_from_clone);
 
 static void __start_io_acct(struct dm_io *io, struct bio *bio)
 {
-	unsigned long flags;
-
-	/* Ensure IO accounting is only ever started once */
-	spin_lock_irqsave(&io->lock, flags);
-	if (smp_load_acquire(&io->io_acct_time)) {
-		spin_unlock_irqrestore(&io->lock, flags);
-		return;
-	}
-	smp_store_release(&io->io_acct_time, jiffies);
-	spin_unlock_irqrestore(&io->lock, flags);
-
 	bio_start_io_acct_time(bio, io->start_time);
 	if (unlikely(dm_stats_used(&io->md->stats)))
 		dm_stats_account_io(&io->md->stats, bio_data_dir(bio),
@@ -507,8 +496,8 @@ static void __start_io_acct(struct dm_io *io, struct bio *bio)
 
 static void start_io_acct(struct dm_io *io, struct bio *bio)
 {
-	/* Only start_io_acct() once for this IO */
-	if (smp_load_acquire(&io->io_acct_time))
+	/* Ensure IO accounting is only ever started once */
+	if (xchg(&io->was_accounted, 1) == 1)
 		return;
 
 	__start_io_acct(io, bio);
@@ -518,8 +507,8 @@ static void clone_and_start_io_acct(struct dm_io *io, struct bio *bio)
 {
 	struct bio io_acct_clone;
 
-	/* Only clone_and_start_io_acct() once for this IO */
-	if (smp_load_acquire(&io->io_acct_time))
+	/* Ensure IO accounting is only ever started once */
+	if (xchg(&io->was_accounted, 1) == 1)
 		return;
 
 	bio_init_clone(io->orig_bio->bi_bdev,
@@ -530,9 +519,6 @@ static void clone_and_start_io_acct(struct dm_io *io, struct bio *bio)
 static void end_io_acct(struct mapped_device *md, struct bio *bio,
 			unsigned long start_time, struct dm_stats_aux *stats_aux)
 {
-	if (!start_time)
-		return;
-
 	bio_end_io_acct(bio, start_time);
 
 	if (unlikely(dm_stats_used(&md->stats)))
@@ -562,7 +548,7 @@ static struct dm_io *alloc_io(struct mapped_device *md, struct bio *bio)
 	spin_lock_init(&io->lock);
 
 	io->start_time = jiffies;
-	io->io_acct_time = 0;
+	io->was_accounted = 0;
 
 	return io;
 }
@@ -819,6 +805,7 @@ void dm_io_dec_pending(struct dm_io *io, blk_status_t error)
 	blk_status_t io_error;
 	struct bio *bio;
 	struct mapped_device *md = io->md;
+	bool was_accounted = false;
 	unsigned long start_time = 0;
 	struct dm_stats_aux stats_aux;
 
@@ -852,11 +839,14 @@ void dm_io_dec_pending(struct dm_io *io, blk_status_t error)
 		}
 
 		io_error = io->status;
-		if (io->io_acct_time)
+		if (io->was_accounted) {
+			was_accounted = true;
 			start_time = io->start_time;
-		stats_aux = io->stats_aux;
+			stats_aux = io->stats_aux;
+		}
 		free_io(io);
-		end_io_acct(md, bio, start_time, &stats_aux);
+		if (was_accounted)
+			end_io_acct(md, bio, start_time, &stats_aux);
 
 		/* nudge anyone waiting on suspend queue */
 		if (unlikely(wq_has_sleeper(&md->wait)))
-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

