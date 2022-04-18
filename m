Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8256EC433EF
	for <dm-devel@archiver.kernel.org>; Mon, 18 Apr 2022 02:27:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-596-R9bqt9wVOzGKgbD80GKWFw-1; Sun, 17 Apr 2022 22:27:50 -0400
X-MC-Unique: R9bqt9wVOzGKgbD80GKWFw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 86E3329ABA2E;
	Mon, 18 Apr 2022 02:27:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 73C501121315;
	Mon, 18 Apr 2022 02:27:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3379719451F1;
	Mon, 18 Apr 2022 02:27:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4496C19466DF
 for <dm-devel@listman.corp.redhat.com>; Mon, 18 Apr 2022 02:27:43 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 37F5040F496D; Mon, 18 Apr 2022 02:27:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 332F340F4941
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 02:27:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1B27D811E78
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 02:27:43 +0000 (UTC)
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com
 [209.85.222.169]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-101-w84csCdqODKOORa5sMt6Fg-2; Sun, 17 Apr 2022 22:27:41 -0400
X-MC-Unique: w84csCdqODKOORa5sMt6Fg-2
Received: by mail-qk1-f169.google.com with SMTP id c1so10333853qkf.13
 for <dm-devel@redhat.com>; Sun, 17 Apr 2022 19:27:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references;
 bh=NEDNcRPXSM0l6lC/0mgd34uV1HMyQSsxxM6AAdfWrHs=;
 b=f4DRwWoHNJZcVZUPns/v1TEYTk01rVMt4b+6OgPxAQvWJiNDlPGN0I07XzGzWn06dz
 5N9iQPDsISDx7G+u3p3fzmaPwcmnxg6S/7kv4lpRRl24B18afGx6sTE54GTgaSRS8P2E
 zqo6SDsBCCkjuDJ76JRnwqn1dpH9r86O9QcchhiMOItKlIoGu9I+uOj4AUjTT9rScxW9
 uZVfYpX5EfVFOThd9h8YUnM2pPPUN/xIJbZXVh2LjVsrdo69kvu7WdX9pNY+Ed0NAXKL
 gGuEjXbS+HbAviHiZ22TRD4+qg7qeeaBGcVEC7c741KARX+iYKww9hSlmH4f55RVu5aZ
 xUXA==
X-Gm-Message-State: AOAM533lb29kPpioH0iR9fwJ8PHlAziDUb/6bOjJzC4p/pwsKdte3LpJ
 aErVM7PdTGdhxMe9XY09RGeZNFXVwZ2fCK/vCs/6ANr4BTjWZTOnl90N6mWdKlChrsVhlGSw7cw
 BiRhFbTg42iiDpss1DlMhWycWarR6vkQlQ0Di06baV2p06+I4m6b3frY5PbgPGNdhuw8=
X-Google-Smtp-Source: ABdhPJwFsovSNtvBbK9uIY0LhyNR9wHduKHfqBlQ7bHkcQ7LmmQE/PfGgJABcYyAhVgUXXSpiXzgEQ==
X-Received: by 2002:a05:620a:4102:b0:69c:67ba:ee79 with SMTP id
 j2-20020a05620a410200b0069c67baee79mr5385164qko.627.1650248860852; 
 Sun, 17 Apr 2022 19:27:40 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 v23-20020ae9e317000000b0069ea555b54dsm485965qkf.128.2022.04.17.19.27.40
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 17 Apr 2022 19:27:40 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Sun, 17 Apr 2022 22:27:17 -0400
Message-Id: <20220418022733.56168-6-snitzer@kernel.org>
In-Reply-To: <20220418022733.56168-1-snitzer@kernel.org>
References: <20220418022733.56168-1-snitzer@kernel.org>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: [dm-devel] [dm-5.19 PATCH 05/21] dm: simplify dm_start_io_acct
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Pull common DM_IO_ACCOUNTED check out to beginning of dm_start_io_acct.
Also, use dm_tio_is_normal (and move it to dm-core.h).

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-core.h |  6 ++++++
 drivers/md/dm.c      | 18 +++++-------------
 2 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
index 4277853c7535..db069fa9cee5 100644
--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -237,6 +237,12 @@ static inline void dm_tio_set_flag(struct dm_target_io *tio, unsigned int bit)
 	tio->flags |= (1U << bit);
 }
 
+static inline bool dm_tio_is_normal(struct dm_target_io *tio)
+{
+	return (dm_tio_flagged(tio, DM_TIO_INSIDE_DM_IO) &&
+		!dm_tio_flagged(tio, DM_TIO_IS_DUPLICATE_BIO));
+}
+
 /*
  * One of these is allocated per original bio.
  * It contains the first clone used for that original.
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 48f93c55c992..0974498c68e7 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -538,17 +538,15 @@ static void dm_start_io_acct(struct dm_io *io, struct bio *clone)
 
 	/*
 	 * Ensure IO accounting is only ever started once.
-	 * Expect no possibility for race unless DM_TIO_IS_DUPLICATE_BIO.
 	 */
-	if (!clone ||
-	    likely(!dm_tio_flagged(clone_to_tio(clone), DM_TIO_IS_DUPLICATE_BIO))) {
-		if (WARN_ON_ONCE(dm_io_flagged(io, DM_IO_ACCOUNTED)))
-			return;
+	if (dm_io_flagged(io, DM_IO_ACCOUNTED))
+		return;
+
+	/* Expect no possibility for race unless DM_TIO_IS_DUPLICATE_BIO. */
+	if (!clone || likely(dm_tio_is_normal(clone_to_tio(clone)))) {
 		dm_io_set_flag(io, DM_IO_ACCOUNTED);
 	} else {
 		unsigned long flags;
-		if (dm_io_flagged(io, DM_IO_ACCOUNTED))
-			return;
 		/* Can afford locking given DM_TIO_IS_DUPLICATE_BIO */
 		spin_lock_irqsave(&io->lock, flags);
 		dm_io_set_flag(io, DM_IO_ACCOUNTED);
@@ -923,12 +921,6 @@ static void dm_io_complete(struct dm_io *io)
 	}
 }
 
-static inline bool dm_tio_is_normal(struct dm_target_io *tio)
-{
-	return (dm_tio_flagged(tio, DM_TIO_INSIDE_DM_IO) &&
-		!dm_tio_flagged(tio, DM_TIO_IS_DUPLICATE_BIO));
-}
-
 /*
  * Decrements the number of outstanding ios that a bio has been
  * cloned into, completing the original io if necc.
-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

