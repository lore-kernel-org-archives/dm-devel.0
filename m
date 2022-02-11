Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B84ECC433EF
	for <dm-devel@archiver.kernel.org>; Fri, 11 Feb 2022 21:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1644615979;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=NwmGtnkxc1fTVrGxMsC1PIhq/taLDs94A3uiCIY+Pu0=;
	b=BZ9DBNA0/QIcXmtHkPSq3hfcnmmOjXdVYou96X1nfoTQDolc4Nci2ssQi2vFQCe9dhWCww
	p5cXait52Gchk6evzwJ8Vk78dGrt3RUCg95na+2vn3gt1aTIZuIotJN6IaQoYgfKF2hxab
	IM7KZLLowCVuDFA8JKA7HLcU2H9pW0w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-625-j_2ICfECOMe67uZKVSvfPA-1; Fri, 11 Feb 2022 16:46:14 -0500
X-MC-Unique: j_2ICfECOMe67uZKVSvfPA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A7D1B881278;
	Fri, 11 Feb 2022 21:46:09 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8C00C4CECC;
	Fri, 11 Feb 2022 21:46:09 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3A8CE1809CBA;
	Fri, 11 Feb 2022 21:46:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21BLfiTc024831 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 11 Feb 2022 16:41:44 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id DDB4C7ADE; Fri, 11 Feb 2022 21:41:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D9C677ADD
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 21:41:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 87BB4811E9B
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 21:41:27 +0000 (UTC)
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
	[209.85.161.72]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-186-EePQdaWpMjiU8fJDPSOCRQ-1; Fri, 11 Feb 2022 16:41:21 -0500
X-MC-Unique: EePQdaWpMjiU8fJDPSOCRQ-1
Received: by mail-oo1-f72.google.com with SMTP id
	c124-20020a4a4f82000000b002fb4087a29fso6304249oob.20
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 13:41:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
	:references;
	bh=0iX5cBRgHe/bSS7YT5ZJ9ztGvi8JUB0cZ1xYv+ukKb0=;
	b=D9mkIKkSRz5kEOC8Ipvkcp0gp5hUxXlQTvdvXkxSW6vY4gTzUYk61/F40lhSD3JUXw
	tQRBOJRN0yIBX6GowBuAhxO4xn9izDpjNeKRPh9JTjNCzJPj3eKH1MkvY+RdfIXsDjyk
	PjJpfda30snED82gWeccSWZPtugywZu7bfQ8R2MmzgZBpY2u0zTuqHJKQyWtAA9p9JAQ
	oPVhAwRWm5UiOGxWG/RNZnNaLgOLQUg/AEIE/h3xKnrA5rP9PzgNr/o1xflEVugxyr9Y
	FsLv8dRS3cqK8I58QLrS2zM0oH1W5XtXhFz1IpQIejSeybRxPDk7WhTAj9flHJKiMQdL
	mw9Q==
X-Gm-Message-State: AOAM531v22Vij4QycPPwd/+OAsonF4EoeXavhM4W5QZ2U3NpazN7YUJO
	14d47zoPlzP3gB8w4yuU+cAndCr4lNvHLsKGYa5RMK6SmIyNZ+j5UQbEqapCEsFrNY73v0aIcE1
	tlYHvbNiT3KIoV4m14RsyvWIHaGvQdxYXW1GVVzQ/CEotINVP0wqJa/hqH6HWF7X1lA==
X-Received: by 2002:a05:6870:3815:: with SMTP id
	y21mr801775oal.330.1644615680106; 
	Fri, 11 Feb 2022 13:41:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwhaY79cQa6rRIF6xGYCLQRnDZ3YcQEltVBHgKRWycktiay6UBHrlSniHAxFVmlgiQyEikfMQ==
X-Received: by 2002:a05:6870:3815:: with SMTP id
	y21mr801770oal.330.1644615679858; 
	Fri, 11 Feb 2022 13:41:19 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	u32sm6180621oiw.28.2022.02.11.13.41.19
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 11 Feb 2022 13:41:19 -0800 (PST)
From: Mike Snitzer <snitzer@redhat.com>
To: dm-devel@redhat.com
Date: Fri, 11 Feb 2022 16:40:52 -0500
Message-Id: <20220211214057.40612-10-snitzer@redhat.com>
In-Reply-To: <20220211214057.40612-1-snitzer@redhat.com>
References: <20220211214057.40612-1-snitzer@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org
Subject: [dm-devel] [PATCH v2 09/14] dm: move kicking of suspend queue to
	dm_io_dec_pending
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

Move kicking of the suspend queue to dm_io_dec_pending (the only
caller) since end_io_acct will soon only be called if IO accounting
was started.

Also, some comment tweaks and removal of local variables.
No functional change.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c | 26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 2f2002348b26..72686329f91e 100644
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

