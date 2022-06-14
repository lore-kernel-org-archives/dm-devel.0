Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA0B2C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 14 Jun 2022 16:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1655223045;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=t6MT0rNgNI2ZgPwhKh7O4tWkJ9ZCXQjYiD/QtPC21No=;
	b=OHz+FmR4kn3s94EQRn3B95O0O25Hj84h8WY6ixt0TQl7K3qLfhtWMG485PM5hAEBt2oGsn
	KhSs1LJ2VxYvCqPQxBL2Ofx1GEFwBFsp62EqQHOVqWtpOr/750Sfa1kQpeBso55ISOzdGn
	6aDZ2xTpWwx6rUeivfWlUi5eu8KEli8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-623-4z5-phzcMGiiPGJnnjz1KQ-1; Tue, 14 Jun 2022 12:10:37 -0400
X-MC-Unique: 4z5-phzcMGiiPGJnnjz1KQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5AEF980159B;
	Tue, 14 Jun 2022 16:10:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2AF6DC53360;
	Tue, 14 Jun 2022 16:10:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BACD2194706D;
	Tue, 14 Jun 2022 16:10:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 533C01947B97
 for <dm-devel@listman.corp.redhat.com>; Tue, 14 Jun 2022 16:10:30 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D5D9718EA5; Tue, 14 Jun 2022 16:10:30 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C166410725;
 Tue, 14 Jun 2022 16:10:30 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 25EGATOp003241;
 Tue, 14 Jun 2022 11:10:29 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 25EGATjN003239;
 Tue, 14 Jun 2022 11:10:29 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mike Snitzer <snitzer@kernel.org>
Date: Tue, 14 Jun 2022 11:10:28 -0500
Message-Id: <1655223028-3199-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: [dm-devel] [PATCH] dm: fix possible race in dm_start_io_acct
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
Cc: dm-devel@redhat.com
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

After commit 82f6cdcc3676c ("dm: switch dm_io booleans over to proper
flags") dm_start_io_acct stopped atomically checking and setting
was_accounted, which turned into the DM_IO_ACCOUNTED flag. This opened
the possibility for a race where IO accounting is started twice for
duplicate bios. To remove the race, check the flag while holding the
io->lock.

Fixes: 82f6cdcc3676c ("dm: switch dm_io booleans over to proper flags")
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 drivers/md/dm.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index d8f16183bf27..c7d2dbf03ccb 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -544,17 +544,20 @@ static void dm_start_io_acct(struct dm_io *io, struct bio *clone)
 {
 	/*
 	 * Ensure IO accounting is only ever started once.
+	 * Expect no possibility for race unless DM_TIO_IS_DUPLICATE_BIO.
 	 */
-	if (dm_io_flagged(io, DM_IO_ACCOUNTED))
-		return;
-
-	/* Expect no possibility for race unless DM_TIO_IS_DUPLICATE_BIO. */
 	if (!clone || likely(dm_tio_is_normal(clone_to_tio(clone)))) {
+		if (WARN_ON_ONCE(dm_io_flagged(io, DM_IO_ACCOUNTED)))
+			return;
 		dm_io_set_flag(io, DM_IO_ACCOUNTED);
 	} else {
 		unsigned long flags;
 		/* Can afford locking given DM_TIO_IS_DUPLICATE_BIO */
 		spin_lock_irqsave(&io->lock, flags);
+		if (dm_io_flagged(io, DM_IO_ACCOUNTED)) {
+			spin_unlock_irqrestore(&io->lock, flags);
+			return;
+		}
 		dm_io_set_flag(io, DM_IO_ACCOUNTED);
 		spin_unlock_irqrestore(&io->lock, flags);
 	}
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

