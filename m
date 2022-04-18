Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D559C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 18 Apr 2022 02:28:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-547-YjIMjPWEMT-6M3CjZWokNg-1; Sun, 17 Apr 2022 22:28:03 -0400
X-MC-Unique: YjIMjPWEMT-6M3CjZWokNg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E3B7F1014A6D;
	Mon, 18 Apr 2022 02:28:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D265657477D;
	Mon, 18 Apr 2022 02:28:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A61E719451F1;
	Mon, 18 Apr 2022 02:28:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0A51719466DF
 for <dm-devel@listman.corp.redhat.com>; Mon, 18 Apr 2022 02:27:58 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id F0BBD574776; Mon, 18 Apr 2022 02:27:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id ECF77574775
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 02:27:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D72291014A6F
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 02:27:57 +0000 (UTC)
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com
 [209.85.222.172]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-212-u9LG-nU0MnCx8fGXNzgP2Q-1; Sun, 17 Apr 2022 22:27:56 -0400
X-MC-Unique: u9LG-nU0MnCx8fGXNzgP2Q-1
Received: by mail-qk1-f172.google.com with SMTP id d198so7196680qkc.12
 for <dm-devel@redhat.com>; Sun, 17 Apr 2022 19:27:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references;
 bh=ycfqOeRaTb3bLWOxIoubDkkyJ63DjHYGauSTfNs4G0I=;
 b=ZrQGeMFJ9tqJylOJ7ZF4dYfaKPF5nffGUXm1qQp9DLN4lPq6Qif/1kjzLdLUrkzcQp
 y4gMkQzuOkVCDR6iMJbHxRzifslcvSKmWR1R7Qntpkkd4nCQE/HR1Ys3JxVBS5abZSQo
 DN7lDzqkZhrZYYdovFK5/g0V1QlV8IYWcELLItKFanXrc1HB056BY3ZqToteYLHm3l6l
 AEranevGCxgh32zOcld9K7Ec5wJ7YcvF8R+pJWjeqORw+GHRmYJ0VmhBoKKL8YSKTzYT
 1hywzaxl3evfJYcLvfEuCa/YYOE29SWB5XndQrjkihztnNPetyeZuB2YRwNBPzeeV6b9
 LDkg==
X-Gm-Message-State: AOAM533dnmYQMO9w8eBTUcQfiSzBZ+qOg8JWq0c1nrby6z8hOU6uMHJn
 LEJyly0aoQymPAW8g9aYtkjeLDp5an4QH1rZmkcIqB5Z+FX2yvZ0EFKSSdr02Ov4VssLtqNs3EU
 pAzBL6Wo7fZOdI/Nv9PK6sEYao4MmNjvHz8zb86lK/Vj0pfnPCpcLTjGS1omATkRqBj8=
X-Google-Smtp-Source: ABdhPJxSXwiXt32Hon3Bm3hE5+bmc5ABMxTlqMBhRdcpOnMapqXzTZlRDHRfbDOAkN3FhzouO8xu4w==
X-Received: by 2002:a05:620a:290f:b0:67b:3212:d529 with SMTP id
 m15-20020a05620a290f00b0067b3212d529mr5472895qkp.4.1650248875760; 
 Sun, 17 Apr 2022 19:27:55 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 e13-20020ac85dcd000000b002eb9458498esm6924520qtx.95.2022.04.17.19.27.55
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 17 Apr 2022 19:27:55 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Sun, 17 Apr 2022 22:27:29 -0400
Message-Id: <20220418022733.56168-18-snitzer@kernel.org>
In-Reply-To: <20220418022733.56168-1-snitzer@kernel.org>
References: <20220418022733.56168-1-snitzer@kernel.org>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: [dm-devel] [dm-5.19 PATCH 17/21] dm: don't grab target io reference
 in dm_zone_map_bio
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============3795221526207435507=="

--===============3795221526207435507==
Content-Type: application/octet-stream; x-default=true

From: Ming Lei <ming.lei@redhat.com>

dm_zone_map_bio() is only called from __map_bio in which the io's
reference is grabbed already, and the reference won't be released
until the bio is submitted, so not necessary to do it dm_zone_map_bio
any more.

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Tested-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-core.h |  7 -------
 drivers/md/dm-zone.c | 10 ----------
 drivers/md/dm.c      |  7 ++++++-
 3 files changed, 6 insertions(+), 18 deletions(-)

diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
index 37ddedf61249..d2d188c9b632 100644
--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -296,13 +296,6 @@ static inline void dm_io_set_flag(struct dm_io *io, unsigned int bit)
 	io->flags |= (1U << bit);
 }
 
-static inline void dm_io_inc_pending(struct dm_io *io)
-{
-	atomic_inc(&io->io_count);
-}
-
-void dm_io_dec_pending(struct dm_io *io, blk_status_t error);
-
 static inline struct completion *dm_get_completion_from_kobject(struct kobject *kobj)
 {
 	return &container_of(kobj, struct dm_kobject_holder, kobj)->completion;
diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
index 57daa86c19cf..3e7b1fe1580b 100644
--- a/drivers/md/dm-zone.c
+++ b/drivers/md/dm-zone.c
@@ -550,13 +550,6 @@ int dm_zone_map_bio(struct dm_target_io *tio)
 		return DM_MAPIO_KILL;
 	}
 
-	/*
-	 * The target map function may issue and complete the IO quickly.
-	 * Take an extra reference on the IO to make sure it does disappear
-	 * until we run dm_zone_map_bio_end().
-	 */
-	dm_io_inc_pending(io);
-
 	/* Let the target do its work */
 	r = ti->type->map(ti, clone);
 	switch (r) {
@@ -587,9 +580,6 @@ int dm_zone_map_bio(struct dm_target_io *tio)
 		break;
 	}
 
-	/* Drop the extra reference on the IO */
-	dm_io_dec_pending(io, sts);
-
 	if (sts != BLK_STS_OK)
 		return DM_MAPIO_KILL;
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 860d2aaffd2a..e4ccd0cce8f3 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -955,6 +955,11 @@ static void dm_io_complete(struct dm_io *io)
 	}
 }
 
+static void dm_io_inc_pending(struct dm_io *io)
+{
+	atomic_inc(&io->io_count);
+}
+
 /*
  * Decrements the number of outstanding ios that a bio has been
  * cloned into, completing the original io if necc.
@@ -978,7 +983,7 @@ static void dm_io_set_error(struct dm_io *io, blk_status_t error)
 	spin_unlock_irqrestore(&io->lock, flags);
 }
 
-void dm_io_dec_pending(struct dm_io *io, blk_status_t error)
+static void dm_io_dec_pending(struct dm_io *io, blk_status_t error)
 {
 	if (unlikely(error))
 		dm_io_set_error(io, error);
-- 
2.15.0


--===============3795221526207435507==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============3795221526207435507==--

