Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03076C433FE
	for <dm-devel@archiver.kernel.org>; Mon, 18 Apr 2022 02:27:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-516-Jqm0YFMCNLa3SlsrwAV1rg-1; Sun, 17 Apr 2022 22:27:53 -0400
X-MC-Unique: Jqm0YFMCNLa3SlsrwAV1rg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 049021C06915;
	Mon, 18 Apr 2022 02:27:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E787C145D820;
	Mon, 18 Apr 2022 02:27:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9B35319451F1;
	Mon, 18 Apr 2022 02:27:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 900C219466DF
 for <dm-devel@listman.corp.redhat.com>; Mon, 18 Apr 2022 02:27:50 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7F30A574772; Mon, 18 Apr 2022 02:27:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7B3D757476A
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 02:27:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 642AA811E76
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 02:27:50 +0000 (UTC)
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com
 [209.85.219.48]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-18-AmAvjXQeP8ClMS2QygF19Q-1; Sun, 17 Apr 2022 22:27:48 -0400
X-MC-Unique: AmAvjXQeP8ClMS2QygF19Q-1
Received: by mail-qv1-f48.google.com with SMTP id c1so10144917qvl.3
 for <dm-devel@redhat.com>; Sun, 17 Apr 2022 19:27:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references;
 bh=mOq2yPZnQf8TffJEk8a4huokoENYVwScfH7hTgDzmm8=;
 b=ZWvvIv6xhLBzAUCTZw+XgpXkz1g8N0Hh+9wXhD8FcXBvHHe2WPIumf0hTDhTa/gbG4
 gKKPD96JWaM3K4ggMHhz1UfQbmlmrDOAyl3aX7lC6Mna5+tdFLUCHaoZxrIhUswJfR7S
 OEXsB/H3Tl+KPq3vw7vWDCIgVfG81Uif+mRlacgIsu98ijEIIOc/Bh9a1bqJtcFEIRAv
 TsqmBFBQ5tHHTnqgwc74YRcRLd8Ir1xvA/O5F6fvEn3exRA4D1gMdnksTIsGk8vtHRm0
 SbhT/JNZ6XheK/7WVgv/vDViOF8nLRdyehy75XDSePfakIbd+gdPW9bScs9KiDKAkqFR
 DSVA==
X-Gm-Message-State: AOAM532PJtdMv9Lu4nnha3kgAeKm8NwYn7zkf/1Y2fHmwmg2PytpMF2t
 4LP7Z9iCRTPFPwGRBHAONvCrrGIgyBd8aI8twpXn7/7EYwP3QtmwyRiTZIyKb7OUQLRN5k/kMSe
 v5+sH4W9ZjeYPNSe+3/vheARvm7DjgXnvc+ulGUVaUigtjjSNQmxx6/b1OmdH+S7afHI=
X-Google-Smtp-Source: ABdhPJzEOHHia9AIFniU6bUh+Ety47iTiUVICPOU3K+DY1NOAlqyoZWS3bEc68Y9FHD/F6QZmDBvYA==
X-Received: by 2002:a0c:c587:0:b0:443:cec4:5b55 with SMTP id
 a7-20020a0cc587000000b00443cec45b55mr6623852qvj.25.1650248868054; 
 Sun, 17 Apr 2022 19:27:48 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 22-20020ac85756000000b002e1cabad999sm7124719qtx.89.2022.04.17.19.27.47
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 17 Apr 2022 19:27:47 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Sun, 17 Apr 2022 22:27:23 -0400
Message-Id: <20220418022733.56168-12-snitzer@kernel.org>
In-Reply-To: <20220418022733.56168-1-snitzer@kernel.org>
References: <20220418022733.56168-1-snitzer@kernel.org>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: [dm-devel] [dm-5.19 PATCH 11/21] dm: simplify basic targets
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Remove needless factoring and remap bi_sector regardless of
bio_sectors() being non-zero.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-delay.c  |  3 +--
 drivers/md/dm-flakey.c |  4 +---
 drivers/md/dm-linear.c | 11 ++---------
 3 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/md/dm-delay.c b/drivers/md/dm-delay.c
index 9a51bf51a859..869afef5654a 100644
--- a/drivers/md/dm-delay.c
+++ b/drivers/md/dm-delay.c
@@ -296,8 +296,7 @@ static int delay_map(struct dm_target *ti, struct bio *bio)
 	}
 	delayed->class = c;
 	bio_set_dev(bio, c->dev->bdev);
-	if (bio_sectors(bio))
-		bio->bi_iter.bi_sector = c->start + dm_target_offset(ti, bio->bi_iter.bi_sector);
+	bio->bi_iter.bi_sector = c->start + dm_target_offset(ti, bio->bi_iter.bi_sector);
 
 	return delay_bio(dc, c, bio);
 }
diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index 345229d7e59c..f2305eb758a2 100644
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -280,9 +280,7 @@ static void flakey_map_bio(struct dm_target *ti, struct bio *bio)
 	struct flakey_c *fc = ti->private;
 
 	bio_set_dev(bio, fc->dev->bdev);
-	if (bio_sectors(bio) || op_is_zone_mgmt(bio_op(bio)))
-		bio->bi_iter.bi_sector =
-			flakey_map_sector(ti, bio->bi_iter.bi_sector);
+	bio->bi_iter.bi_sector = flakey_map_sector(ti, bio->bi_iter.bi_sector);
 }
 
 static void corrupt_bio_data(struct bio *bio, struct flakey_c *fc)
diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index 76b486e4d2be..0a6abbbe3745 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -84,19 +84,12 @@ static sector_t linear_map_sector(struct dm_target *ti, sector_t bi_sector)
 	return lc->start + dm_target_offset(ti, bi_sector);
 }
 
-static void linear_map_bio(struct dm_target *ti, struct bio *bio)
+static int linear_map(struct dm_target *ti, struct bio *bio)
 {
 	struct linear_c *lc = ti->private;
 
 	bio_set_dev(bio, lc->dev->bdev);
-	if (bio_sectors(bio) || op_is_zone_mgmt(bio_op(bio)))
-		bio->bi_iter.bi_sector =
-			linear_map_sector(ti, bio->bi_iter.bi_sector);
-}
-
-static int linear_map(struct dm_target *ti, struct bio *bio)
-{
-	linear_map_bio(ti, bio);
+	bio->bi_iter.bi_sector = linear_map_sector(ti, bio->bi_iter.bi_sector);
 
 	return DM_MAPIO_REMAPPED;
 }
-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

