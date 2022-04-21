Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9D48C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 21 Apr 2022 18:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1650564447;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=jp6pcynJoVCV80ntMn/nEj4Xn6t57t1HNjCgtfHpEh0=;
	b=CukBLhL8di8HyQ2kaZBldo37BtADDQtph4SZTwPATYMwYiyegPumCn35B7onaQURu6FMfM
	oZDbzRFnKHl2i9jjF7rlMlei1eAJlLqePNDGWubVxLXg2vlAqSNWvnWFfpTWweWeJp1WgH
	cHvUKvaNx/BULq8nADt8ti223xUWbxA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-594-wcOJJaroNQOfVrUcc4CD3Q-1; Thu, 21 Apr 2022 14:07:24 -0400
X-MC-Unique: wcOJJaroNQOfVrUcc4CD3Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2536B281AF08;
	Thu, 21 Apr 2022 18:07:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0F52D111E3F2;
	Thu, 21 Apr 2022 18:07:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 810A11940347;
	Thu, 21 Apr 2022 18:07:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AE79D19451EF
 for <dm-devel@listman.corp.redhat.com>; Thu, 21 Apr 2022 18:07:20 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 694D055119B; Thu, 21 Apr 2022 18:07:20 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 590285517C2;
 Thu, 21 Apr 2022 18:07:20 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 23LI7KbH001550; Thu, 21 Apr 2022 14:07:20 -0400
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 23LI7Kot001546; Thu, 21 Apr 2022 14:07:20 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Thu, 21 Apr 2022 14:07:20 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Message-ID: <alpine.LRH.2.02.2204211406080.761@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: [dm-devel] [PATCH v5.4] dm: fix mempool NULL pointer race when
 completing IO
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com,
 stable@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi

This is backport of patches d208b89401e0 ("dm: fix mempool NULL pointer
race when completing IO") and 9f6dc6337610 ("dm: interlock pending dm_io
and dm_wait_for_bios_completion") for the kernel 5.4.

The bugs fixed by these patches can cause random crashing when reloading
dm table, so it is eligible for stable backport.

This patch is different from the upstream patches because the code
diverged significantly.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

Index: linux-stable/drivers/md/dm.c
===================================================================
--- linux-stable.orig/drivers/md/dm.c	2022-04-19 16:25:08.000000000 +0200
+++ linux-stable/drivers/md/dm.c	2022-04-19 16:26:18.000000000 +0200
@@ -676,20 +676,27 @@ static void start_io_acct(struct dm_io *
 				    false, 0, &io->stats_aux);
 }
 
+static void free_io(struct mapped_device *md, struct dm_io *io);
+
 static void end_io_acct(struct dm_io *io)
 {
 	struct mapped_device *md = io->md;
 	struct bio *bio = io->orig_bio;
-	unsigned long duration = jiffies - io->start_time;
-
-	generic_end_io_acct(md->queue, bio_op(bio), &dm_disk(md)->part0,
-			    io->start_time);
+	unsigned long start_time = io->start_time;
+	unsigned long duration = jiffies - start_time;
 
 	if (unlikely(dm_stats_used(&md->stats)))
 		dm_stats_account_io(&md->stats, bio_data_dir(bio),
 				    bio->bi_iter.bi_sector, bio_sectors(bio),
 				    true, duration, &io->stats_aux);
 
+	free_io(md, io);
+
+	smp_wmb();
+
+	generic_end_io_acct(md->queue, bio_op(bio), &dm_disk(md)->part0,
+			    start_time);
+
 	/* nudge anyone waiting on suspend queue */
 	if (unlikely(wq_has_sleeper(&md->wait)))
 		wake_up(&md->wait);
@@ -936,7 +943,6 @@ static void dec_pending(struct dm_io *io
 		io_error = io->status;
 		bio = io->orig_bio;
 		end_io_acct(io);
-		free_io(md, io);
 
 		if (io_error == BLK_STS_DM_REQUEUE)
 			return;
@@ -2491,6 +2497,8 @@ static int dm_wait_for_completion(struct
 	}
 	finish_wait(&md->wait, &wait);
 
+	smp_rmb();
+
 	return r;
 }
 
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

