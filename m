Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFC82C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 18 Apr 2022 02:28:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-629-xa2J0Aa0NzKvUzX8Ynvq9w-1; Sun, 17 Apr 2022 22:27:58 -0400
X-MC-Unique: xa2J0Aa0NzKvUzX8Ynvq9w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2BB1E1857F16;
	Mon, 18 Apr 2022 02:27:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 152F4145BEE2;
	Mon, 18 Apr 2022 02:27:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AFDA519451F3;
	Mon, 18 Apr 2022 02:27:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BF8E419466DF
 for <dm-devel@listman.corp.redhat.com>; Mon, 18 Apr 2022 02:27:55 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8697A40F495E; Mon, 18 Apr 2022 02:27:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 82E6440F4941
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 02:27:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6A16686B8A0
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 02:27:55 +0000 (UTC)
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com
 [209.85.160.182]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-567-yBYhuuw3NhGD8RjwoHzp9w-2; Sun, 17 Apr 2022 22:27:53 -0400
X-MC-Unique: yBYhuuw3NhGD8RjwoHzp9w-2
Received: by mail-qt1-f182.google.com with SMTP id x24so882693qtq.11
 for <dm-devel@redhat.com>; Sun, 17 Apr 2022 19:27:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references;
 bh=y6Ys98S8N58jSkRucGZJIQN+neaUdA7Xt3Ujrpd+ZzU=;
 b=jEiPltwykJ8dPZspU+NzSq/vJxfQKMdDj0b+UGTnSWBC+atf19YxMPo3fVym7otzIL
 TpXEiJMtD6kPCLzbDd/1OiXD5G9n753J3KH4funuWazMYPIBEUbpiYr3uH5JgGGlC69W
 oMpGAV8DDaoP+C5/wokhKa49XGqeAKMTBfsCHFOdsfSXDonH70S/UuYteXKYE/RK0eQh
 4j5SUoR9dEseC0o2Um8lagUc+4TBMLc2fhfPlo/nz8MUxI5TYds5M9DPHfWveD2lfZxr
 62/wd8vI2fINdeQhDm9iF2FYTa738lj2ofxovteKbtRw4o+TK2nP04B2V3ft4yZEttTH
 X5pw==
X-Gm-Message-State: AOAM530F8vEwOKjHXtDhnhu0+kNXopeZKJstr/ls3YIeE0MSiYWrsUVb
 Qrh0U9uE2KoUwKEnmd8jAWcDQM79J6KTmp8tpH8M0YZVNVPcflgFC1WVyhWs74kKb8eozkoY2e+
 iy18xl86BEAOsXysYuKu4jxyZOqSg6Rf/NAs03DkNcsyEtBS4IT+OCwKnefGDuZEht0g=
X-Google-Smtp-Source: ABdhPJwsfOuhGeXlhb5ka+wFzcg7sXwv5GPP22Yc/AtX4PpFpmh34HX8Ik6vcUw5HqVHPITJVLCjVQ==
X-Received: by 2002:a05:622a:9:b0:2f1:e9d7:d734 with SMTP id
 x9-20020a05622a000900b002f1e9d7d734mr5924122qtw.476.1650248873254; 
 Sun, 17 Apr 2022 19:27:53 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 m9-20020a05622a118900b002f1fc51135dsm1690235qtk.57.2022.04.17.19.27.52
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 17 Apr 2022 19:27:52 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Sun, 17 Apr 2022 22:27:27 -0400
Message-Id: <20220418022733.56168-16-snitzer@kernel.org>
In-Reply-To: <20220418022733.56168-1-snitzer@kernel.org>
References: <20220418022733.56168-1-snitzer@kernel.org>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: [dm-devel] [dm-5.19 PATCH 15/21] dm: switch to bdev based IO
 accounting interfaces
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============7148776436431585105=="

--===============7148776436431585105==
Content-Type: application/octet-stream; x-default=true

From: Ming Lei <ming.lei@redhat.com>

DM splits flush with data into empty flush followed by bio with data
payload, switch dm_io_acct() to use bdev_{start,end}_io_acct() to do
this accoiunting more naturally (rather than temporarily changing the
bio's bi_size).

This will allow DM to more easily account bios that are split (in
following commit).

Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index f100ced29e0d..cb41384cd814 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -508,30 +508,28 @@ static void dm_io_acct(struct dm_io *io, bool end)
 	unsigned long start_time = io->start_time;
 	struct mapped_device *md = io->md;
 	struct bio *bio = io->orig_bio;
-	bool is_flush_with_data;
-	unsigned int bi_size;
+	unsigned int sectors;
 
-	/* If REQ_PREFLUSH set save any payload but do not account it */
-	is_flush_with_data = bio_is_flush_with_data(bio);
-	if (is_flush_with_data) {
-		bi_size = bio->bi_iter.bi_size;
-		bio->bi_iter.bi_size = 0;
-	}
+	/*
+	 * If REQ_PREFLUSH set, don't account payload, it will be
+	 * submitted (and accounted) after this flush completes.
+	 */
+	if (bio_is_flush_with_data(bio))
+		sectors = 0;
+	else
+		sectors = bio_sectors(bio);
 
 	if (!end)
-		bio_start_io_acct_time(bio, start_time);
+		bdev_start_io_acct(bio->bi_bdev, sectors, bio_op(bio),
+				   start_time);
 	else
-		bio_end_io_acct(bio, start_time);
+		bdev_end_io_acct(bio->bi_bdev, bio_op(bio), start_time);
 
 	if (static_branch_unlikely(&stats_enabled) &&
 	    unlikely(dm_stats_used(&md->stats)))
 		dm_stats_account_io(&md->stats, bio_data_dir(bio),
-				    bio->bi_iter.bi_sector, bio_sectors(bio),
+				    bio->bi_iter.bi_sector, sectors,
 				    end, start_time, stats_aux);
-
-	/* Restore bio's payload so it does get accounted upon requeue */
-	if (is_flush_with_data)
-		bio->bi_iter.bi_size = bi_size;
 }
 
 static void __dm_start_io_acct(struct dm_io *io)
-- 
2.15.0


--===============7148776436431585105==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============7148776436431585105==--

