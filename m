Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8355EC433FE
	for <dm-devel@archiver.kernel.org>; Tue, 12 Apr 2022 08:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1649753837;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=HWUjNqR6a0KAVssoySThku2mZK95OEt5SIaY1cRN/28=;
	b=Q88MlarQgumSBGhLWAM6MUra0eCzkbf3QCR+Q+IW0yB3UoWQ6nRr5fxIfJCJeQtgetd8Nd
	svsWicnO0naSUIjbGZOjTY50/zwwx6PIwoVarQtB15R8k3JrGFStlQr+K0bcEPEkAnxNPY
	NNVe6KeOaa9uLhoAILYckgUNrJ/rw+k=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-115-R91ZGTpBOZW5orOtMbb-DQ-1; Tue, 12 Apr 2022 04:57:14 -0400
X-MC-Unique: R91ZGTpBOZW5orOtMbb-DQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A7B49800B28;
	Tue, 12 Apr 2022 08:57:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9534441639E;
	Tue, 12 Apr 2022 08:57:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 61AC81940365;
	Tue, 12 Apr 2022 08:57:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A033C1947BBF
 for <dm-devel@listman.corp.redhat.com>; Tue, 12 Apr 2022 08:57:10 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7F96BC44B1E; Tue, 12 Apr 2022 08:57:10 +0000 (UTC)
Received: from localhost (ovpn-8-19.pek2.redhat.com [10.72.8.19])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 83520C44B1D;
 Tue, 12 Apr 2022 08:57:09 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@redhat.com>
Date: Tue, 12 Apr 2022 16:56:12 +0800
Message-Id: <20220412085616.1409626-5-ming.lei@redhat.com>
In-Reply-To: <20220412085616.1409626-1-ming.lei@redhat.com>
References: <20220412085616.1409626-1-ming.lei@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: [dm-devel] [PATCH 4/8] dm: switch to bdev based io accounting
 interface
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
 Damien Le Moal <damien.lemoal@opensource.wdc.com>,
 Ming Lei <ming.lei@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

DM won't account sectors in flush IO, also we can retrieve sectors
from 'dm_io' for avoiding to allocate & update new original bio, which
will be done in the following patch.

So switch to bdev based io accounting interface.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/md/dm.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index ed85cd1165a4..31eacc0e93ed 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -504,29 +504,24 @@ static void dm_io_acct(struct dm_io *io, bool end)
 	unsigned long start_time = io->start_time;
 	struct mapped_device *md = io->md;
 	struct bio *bio = io->orig_bio;
-	bool is_flush_with_data;
-	unsigned int bi_size;
+	unsigned int sectors;
 
 	/* If REQ_PREFLUSH set save any payload but do not account it */
-	is_flush_with_data = bio_is_flush_with_data(bio);
-	if (is_flush_with_data) {
-		bi_size = bio->bi_iter.bi_size;
-		bio->bi_iter.bi_size = 0;
-	}
+	if (bio_is_flush_with_data(bio))
+		sectors = 0;
+	else
+		sectors = bio_sectors(bio);
 
 	if (!end)
-		bio_start_io_acct_time(bio, start_time);
+		bdev_start_io_acct(bio->bi_bdev, sectors, bio_op(bio),
+				start_time);
 	else
-		bio_end_io_acct(bio, start_time);
+		bdev_end_io_acct(bio->bi_bdev, bio_op(bio), start_time);
 
 	if (unlikely(dm_stats_used(&md->stats)))
 		dm_stats_account_io(&md->stats, bio_data_dir(bio),
 				    bio->bi_iter.bi_sector, bio_sectors(bio),
 				    end, start_time, stats_aux);
-
-	/* Restore bio's payload so it does get accounted upon requeue */
-	if (is_flush_with_data)
-		bio->bi_iter.bi_size = bi_size;
 }
 
 static void __dm_start_io_acct(struct dm_io *io)
-- 
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

