Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95E87C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 18 Apr 2022 02:28:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-654-BQHkR1yWOc2ADspE-P36Ag-1; Sun, 17 Apr 2022 22:27:56 -0400
X-MC-Unique: BQHkR1yWOc2ADspE-P36Ag-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D22B938035A9;
	Mon, 18 Apr 2022 02:27:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C23AD1121315;
	Mon, 18 Apr 2022 02:27:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7935519466DF;
	Mon, 18 Apr 2022 02:27:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 36E6919466DF
 for <dm-devel@listman.corp.redhat.com>; Mon, 18 Apr 2022 02:27:53 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2190E416363; Mon, 18 Apr 2022 02:27:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1E1DE41617F
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 02:27:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0496C3C00104
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 02:27:53 +0000 (UTC)
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com
 [209.85.222.170]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-199-mGTANf8CPZuv5etW22IjZA-2; Sun, 17 Apr 2022 22:27:51 -0400
X-MC-Unique: mGTANf8CPZuv5etW22IjZA-2
Received: by mail-qk1-f170.google.com with SMTP id b68so5589612qkc.4
 for <dm-devel@redhat.com>; Sun, 17 Apr 2022 19:27:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references;
 bh=MPtMBridXKBpzZXbwYmtGjKb3t3TUfTcOiaglG3U56U=;
 b=D0TEaiTSO6gZOH0Ls0TeQNtVzxFUaD+G1UxNAHi84BqBxdNQjm9gjDajRqlPXTly9m
 ufnDt3CeATgEdkrpgkqxbfZmhHW4GXqW5HJeLVaMq6L4hN8x89l+LvbCZg5d6rrG0Wx5
 XkoSkticFhj5rLr8ao1GgmjGt3f5NrRAqQXabdhHvfZ8hlx1nxAFxnukQ8yTaXOahAZt
 H8tXf3jRD+vsfYNQrEiYiW3hIc4vVLpX4c4Md3gagO5tf04+IVjNAvCSGpy8grGo2f4Y
 aqlc1jg3UnxIIJDYukYuCeO3vFDG3CyaW4O1OxWFBoQWv96y0yOj2fDujHn0L/lHbv2N
 sOjg==
X-Gm-Message-State: AOAM530RN8yeijCx4d2RsxMYu3RqAU8LdlktII3mRRbLIbrPilRwIBbc
 R+b/VsyyDAQve41s2nApNSeRklyHo2LqB23NMh7ZSTLmeniOoHJWpqaLKbHs3krYhR2+8NeVOVt
 LHFPxsOL6UQkbXYIa2SRhwgzwfanwEtEZdK1O9jCy1r1gxlLCF4VvF7mHg/8cYRU7twM=
X-Google-Smtp-Source: ABdhPJxS69CJZ5yQam01AFrSfuxuOxZq4pb8RPRxJ7YU8TVCHpTcqAaNHIsy2p4EaOVBgtY69yR3tA==
X-Received: by 2002:a05:620a:4403:b0:67d:b78d:9ece with SMTP id
 v3-20020a05620a440300b0067db78d9ecemr5295955qkp.515.1650248870710; 
 Sun, 17 Apr 2022 19:27:50 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 y66-20020a37af45000000b0067dc0fc539fsm6054298qke.86.2022.04.17.19.27.50
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 17 Apr 2022 19:27:50 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Sun, 17 Apr 2022 22:27:25 -0400
Message-Id: <20220418022733.56168-14-snitzer@kernel.org>
In-Reply-To: <20220418022733.56168-1-snitzer@kernel.org>
References: <20220418022733.56168-1-snitzer@kernel.org>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: [dm-devel] [dm-5.19 PATCH 13/21] dm: don't pass bio to
 __dm_start_io_acct and dm_end_io_acct
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
Cc: axboe@kernel.dk, hch@lst.de, ming.lei@redhat.com
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============1790744504145117934=="

--===============1790744504145117934==
Content-Type: application/octet-stream; x-default=true

From: Ming Lei <ming.lei@redhat.com>

dm->orig_bio is always passed to __dm_start_io_acct and dm_end_io_acct,
so it isn't necessary to take one bio parameter for the two helpers.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index c8933d7e6a78..9012cd1eff1f 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -531,16 +531,13 @@ static void dm_io_acct(bool end, struct mapped_device *md, struct bio *bio,
 		bio->bi_iter.bi_size = bi_size;
 }
 
-static void __dm_start_io_acct(struct dm_io *io, struct bio *bio)
+static void __dm_start_io_acct(struct dm_io *io)
 {
-	dm_io_acct(false, io->md, bio, io->start_time, &io->stats_aux);
+	dm_io_acct(false, io->md, io->orig_bio, io->start_time, &io->stats_aux);
 }
 
 static void dm_start_io_acct(struct dm_io *io, struct bio *clone)
 {
-	/* Must account IO to DM device in terms of orig_bio */
-	struct bio *bio = io->orig_bio;
-
 	/*
 	 * Ensure IO accounting is only ever started once.
 	 */
@@ -558,12 +555,12 @@ static void dm_start_io_acct(struct dm_io *io, struct bio *clone)
 		spin_unlock_irqrestore(&io->lock, flags);
 	}
 
-	__dm_start_io_acct(io, bio);
+	__dm_start_io_acct(io);
 }
 
-static void dm_end_io_acct(struct dm_io *io, struct bio *bio)
+static void dm_end_io_acct(struct dm_io *io)
 {
-	dm_io_acct(true, io->md, bio, io->start_time, &io->stats_aux);
+	dm_io_acct(true, io->md, io->orig_bio, io->start_time, &io->stats_aux);
 }
 
 static struct dm_io *alloc_io(struct mapped_device *md, struct bio *bio)
@@ -899,14 +896,14 @@ static void dm_io_complete(struct dm_io *io)
 
 	io_error = io->status;
 	if (dm_io_flagged(io, DM_IO_ACCOUNTED))
-		dm_end_io_acct(io, bio);
+		dm_end_io_acct(io);
 	else if (!io_error) {
 		/*
 		 * Must handle target that DM_MAPIO_SUBMITTED only to
 		 * then bio_endio() rather than dm_submit_bio_remap()
 		 */
-		__dm_start_io_acct(io, bio);
-		dm_end_io_acct(io, bio);
+		__dm_start_io_acct(io);
+		dm_end_io_acct(io);
 	}
 	free_io(io);
 	smp_wmb();
-- 
2.15.0


--===============1790744504145117934==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============1790744504145117934==--

