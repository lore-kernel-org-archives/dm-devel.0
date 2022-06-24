Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 835BAC433EF
	for <dm-devel@archiver.kernel.org>; Fri, 24 Jun 2022 14:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656080146;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=qxUN02pQ43RTvcogTzStJfwrHj9cg6bEdhZvZuo3hS8=;
	b=Gj++6+zPI2Cro14utCJ7bzFrSGYjCfR5D5no8yK9nIOLsdThTHZcpSVRT+tQyo6eXvQn8Q
	vAm60fQeDMXjLPhr7CNJKd27P5FP1YNY/6pcuN1/hQsdHpR/5+FjAWoWVPiCTG1s2F6a19
	DdcVKe3Ls5dYa0IgQsT6i+PocrLDono=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-93-rX2-91USM56PoiWPGkYlyA-1; Fri, 24 Jun 2022 10:15:20 -0400
X-MC-Unique: rX2-91USM56PoiWPGkYlyA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 68C598032FB;
	Fri, 24 Jun 2022 14:14:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5722A400F8FD;
	Fri, 24 Jun 2022 14:14:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3F603194B94C;
	Fri, 24 Jun 2022 14:14:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B7C65194B946
 for <dm-devel@listman.corp.redhat.com>; Fri, 24 Jun 2022 14:14:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A93BB1730C; Fri, 24 Jun 2022 14:14:39 +0000 (UTC)
Received: from localhost (ovpn-8-21.pek2.redhat.com [10.72.8.21])
 by smtp.corp.redhat.com (Postfix) with ESMTP id B250F10725;
 Fri, 24 Jun 2022 14:14:38 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@redhat.com>
Date: Fri, 24 Jun 2022 22:12:53 +0800
Message-Id: <20220624141255.2461148-3-ming.lei@redhat.com>
In-Reply-To: <20220624141255.2461148-1-ming.lei@redhat.com>
References: <20220624141255.2461148-1-ming.lei@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: [dm-devel] [PATCH 5.20 2/4] dm: add new helper for handling dm_io
 requeue
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
 Ming Lei <ming.lei@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Add helper of dm_handle_requeue() for handling dm_io requeue.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/md/dm.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 2b75f1ef7386..a9e5e429c150 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -884,13 +884,11 @@ static int __noflush_suspending(struct mapped_device *md)
 	return test_bit(DMF_NOFLUSH_SUSPENDING, &md->flags);
 }
 
-static void dm_io_complete(struct dm_io *io)
+static void dm_handle_requeue(struct dm_io *io)
 {
-	blk_status_t io_error;
-	struct mapped_device *md = io->md;
-	struct bio *bio = io->split_bio ? io->split_bio : io->orig_bio;
-
 	if (io->status == BLK_STS_DM_REQUEUE) {
+		struct bio *bio = io->split_bio ? io->split_bio : io->orig_bio;
+		struct mapped_device *md = io->md;
 		unsigned long flags;
 		/*
 		 * Target requested pushing back the I/O.
@@ -909,6 +907,15 @@ static void dm_io_complete(struct dm_io *io)
 		}
 		spin_unlock_irqrestore(&md->deferred_lock, flags);
 	}
+}
+
+static void dm_io_complete(struct dm_io *io)
+{
+	struct bio *bio = io->split_bio ? io->split_bio : io->orig_bio;
+	struct mapped_device *md = io->md;
+	blk_status_t io_error;
+
+	dm_handle_requeue(io);
 
 	io_error = io->status;
 	if (dm_io_flagged(io, DM_IO_ACCOUNTED))
-- 
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

