Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97D80C433FE
	for <dm-devel@archiver.kernel.org>; Thu, 10 Feb 2022 22:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1644532847;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=z39c3PnbQqBq0iaoSuZLL7aE+nQLdWiI/9JLG7NjeqA=;
	b=ROkWVuoPovWQiat9UOHrZ1/qtvdR9HSp30aBybSCd59PJO8xh+hWuZIIogoj2DbjE8W9fk
	8v1Q9xRysS83IQqDYyn9SZTKTpgppCBU8gHf7MGHhmceHSspN2TpBHjsuGiOypEemEJnXL
	6napJEaYb9Gj2woxErxjTdsTq5mkBsY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-596-LY-BAT8yNSG5u8_qupm8tA-1; Thu, 10 Feb 2022 17:40:44 -0500
X-MC-Unique: LY-BAT8yNSG5u8_qupm8tA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B9D0718C8C01;
	Thu, 10 Feb 2022 22:40:39 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9E9F24E2DD;
	Thu, 10 Feb 2022 22:40:39 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 79AAD1809CBA;
	Thu, 10 Feb 2022 22:40:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21AMcs1M014865 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 10 Feb 2022 17:38:54 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 00D7C2026609; Thu, 10 Feb 2022 22:38:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F030D2026D6B
	for <dm-devel@redhat.com>; Thu, 10 Feb 2022 22:38:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B9FF51066559
	for <dm-devel@redhat.com>; Thu, 10 Feb 2022 22:38:48 +0000 (UTC)
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
	[209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-52-6MZB7qj1P6Kbletr0WFjBA-1; Thu, 10 Feb 2022 17:38:47 -0500
X-MC-Unique: 6MZB7qj1P6Kbletr0WFjBA-1
Received: by mail-qv1-f70.google.com with SMTP id
	eo11-20020ad4594b000000b0042151b7180aso5025222qvb.8
	for <dm-devel@redhat.com>; Thu, 10 Feb 2022 14:38:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
	:references;
	bh=NJDDntpX1bDz2HHZg4ERdrCl6N9td/COm3CwT3DXHyU=;
	b=uITbS5S5jdpEk5liH2dgj+xveiAFUXeJWvJhHYlhwFhGjeQmhXuSTpI99VidTqSbWi
	x+oTjP6s4Z4Hx1XVA67XPzxyE9+aClKBPB2PyhuTg3Lj26hrWmi62fLVzR8rGQ4MLjwH
	Pui4AXMTwRzYKXnL6WqyEFmyc83JjpV6Pirq5/8+6j0sZdH5lZmz+JEpvad9/BmaIs8e
	lMfhdQqV2HCMot62uSAa/599BcKigki5FonnUFgxlsU38DF3zms0pfcIqSEA2XDmLi+p
	F6XELfQa8Nb3u8kliP6Nfxvs6aYqUEy88uRf820P+4ZtLgHXdggJ+hPqzgr5dpLnx7vH
	saVw==
X-Gm-Message-State: AOAM533pZAh8BdPtyQ14d5P96rfKFfn5amRZ0oGZLg+d5e7y0712T/M3
	aCdbck+f+0I6VZ56VflINO/YjNa1YmlBvr0aKYRyCte2jR6JIGFqbBP2g55Y7cJrqR+wq1Pbs/x
	KLfvt60+w/rWV1vTDrqZJtmUYQS8CFxyF4KGJbw5dxNhS1xY4Gc9OKXWBdt8wYAi/Ew==
X-Received: by 2002:a05:6214:2308:: with SMTP id
	gc8mr6697708qvb.108.1644532726960; 
	Thu, 10 Feb 2022 14:38:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx/swioXpnZqj/ggEJ7xdDFKsnoeOBasBsyZ13Up+u3iQ8ukuq5/OcxD8Z9zGj3LPPEVFxxxw==
X-Received: by 2002:a05:6214:2308:: with SMTP id
	gc8mr6697693qvb.108.1644532726554; 
	Thu, 10 Feb 2022 14:38:46 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52])
	by smtp.gmail.com with ESMTPSA id z4sm12115514qtw.4.2022.02.10.14.38.46
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 10 Feb 2022 14:38:46 -0800 (PST)
From: Mike Snitzer <snitzer@redhat.com>
To: dm-devel@redhat.com
Date: Thu, 10 Feb 2022 17:38:27 -0500
Message-Id: <20220210223832.99412-10-snitzer@redhat.com>
In-Reply-To: <20220210223832.99412-1-snitzer@redhat.com>
References: <20220210223832.99412-1-snitzer@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org
Subject: [dm-devel] [PATCH 09/14] dm: prep for following changes
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Rename dm_io struct's 'endio_lock' member to 'lock' to reuse spinlock
to protect new member used to flag if IO accounting has been started.

Also move kicking of the suspend queue out to dm_io_dec_pending (the
only caller) since end_io_acct will soon only be called if IO
accounting was started.

Some comment tweaks and removal of local variables. No functional
change.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-core.h |  2 +-
 drivers/md/dm.c      | 32 ++++++++++++++------------------
 2 files changed, 15 insertions(+), 19 deletions(-)

diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
index f40be01cca81..8dd196aec130 100644
--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -230,7 +230,7 @@ struct dm_io {
 	atomic_t io_count;
 	struct bio *orig_bio;
 	unsigned long start_time;
-	spinlock_t endio_lock;
+	spinlock_t lock;
 	struct dm_stats_aux stats_aux;
 	/* last member of dm_target_io is 'struct bio' */
 	struct dm_target_io tio;
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 3bd872b0e891..8c0e96b8e1a5 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -487,12 +487,12 @@ EXPORT_SYMBOL_GPL(dm_start_time_ns_from_clone);
 
 static void start_io_acct(struct dm_io *io)
 {
-	struct mapped_device *md = io->md;
 	struct bio *bio = io->orig_bio;
 
 	bio_start_io_acct_time(bio, io->start_time);
-	if (unlikely(dm_stats_used(&md->stats)))
-		dm_stats_account_io(&md->stats, bio_data_dir(bio),
+
+	if (unlikely(dm_stats_used(&io->md->stats)))
+		dm_stats_account_io(&io->md->stats, bio_data_dir(bio),
 				    bio->bi_iter.bi_sector, bio_sectors(bio),
 				    false, 0, &io->stats_aux);
 }
@@ -500,18 +500,12 @@ static void start_io_acct(struct dm_io *io)
 static void end_io_acct(struct mapped_device *md, struct bio *bio,
 			unsigned long start_time, struct dm_stats_aux *stats_aux)
 {
-	unsigned long duration = jiffies - start_time;
-
 	bio_end_io_acct(bio, start_time);
 
 	if (unlikely(dm_stats_used(&md->stats)))
 		dm_stats_account_io(&md->stats, bio_data_dir(bio),
 				    bio->bi_iter.bi_sector, bio_sectors(bio),
-				    true, duration, stats_aux);
-
-	/* nudge anyone waiting on suspend queue */
-	if (unlikely(wq_has_sleeper(&md->wait)))
-		wake_up(&md->wait);
+				    true, jiffies - start_time, stats_aux);
 }
 
 static struct dm_io *alloc_io(struct mapped_device *md, struct bio *bio)
@@ -532,7 +526,7 @@ static struct dm_io *alloc_io(struct mapped_device *md, struct bio *bio)
 	atomic_set(&io->io_count, 1);
 	io->orig_bio = bio;
 	io->md = md;
-	spin_lock_init(&io->endio_lock);
+	spin_lock_init(&io->lock);
 
 	io->start_time = jiffies;
 
@@ -796,10 +790,10 @@ void dm_io_dec_pending(struct dm_io *io, blk_status_t error)
 
 	/* Push-back supersedes any I/O errors */
 	if (unlikely(error)) {
-		spin_lock_irqsave(&io->endio_lock, flags);
+		spin_lock_irqsave(&io->lock, flags);
 		if (!(io->status == BLK_STS_DM_REQUEUE && __noflush_suspending(md)))
 			io->status = error;
-		spin_unlock_irqrestore(&io->endio_lock, flags);
+		spin_unlock_irqrestore(&io->lock, flags);
 	}
 
 	if (atomic_dec_and_test(&io->io_count)) {
@@ -829,6 +823,10 @@ void dm_io_dec_pending(struct dm_io *io, blk_status_t error)
 		free_io(io);
 		end_io_acct(md, bio, start_time, &stats_aux);
 
+		/* nudge anyone waiting on suspend queue */
+		if (unlikely(wq_has_sleeper(&md->wait)))
+			wake_up(&md->wait);
+
 		if (io_error == BLK_STS_DM_REQUEUE)
 			return;
 
@@ -1127,9 +1125,7 @@ static void __map_bio(struct bio *clone)
 	clone->bi_end_io = clone_endio;
 
 	/*
-	 * Map the clone.  If r == 0 we don't need to do
-	 * anything, the target has assumed ownership of
-	 * this io.
+	 * Map the clone.
 	 */
 	dm_io_inc_pending(io);
 	tio->old_sector = clone->bi_iter.bi_sector;
@@ -1154,6 +1150,7 @@ static void __map_bio(struct bio *clone)
 
 	switch (r) {
 	case DM_MAPIO_SUBMITTED:
+		/* target has assumed ownership of this io */
 		break;
 	case DM_MAPIO_REMAPPED:
 		/* the bio has been remapped so dispatch it */
@@ -1301,10 +1298,9 @@ static bool is_abnormal_io(struct bio *bio)
 static bool __process_abnormal_io(struct clone_info *ci, struct dm_target *ti,
 				  int *result)
 {
-	struct bio *bio = ci->bio;
 	unsigned num_bios = 0;
 
-	switch (bio_op(bio)) {
+	switch (bio_op(ci->bio)) {
 	case REQ_OP_DISCARD:
 		num_bios = ti->num_discard_bios;
 		break;
-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

