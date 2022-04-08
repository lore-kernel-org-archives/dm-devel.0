Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50ED9C433FE
	for <dm-devel@archiver.kernel.org>; Fri,  8 Apr 2022 17:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1649438022;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=CY4sCosrTcKznRDiQTlSxLcWC7zsQ3luytvJ01XzXaY=;
	b=MygnNaQZTw1fCIZIqKONkEKqCI1iAOTterpSChmcBWoXjkBTwRsIAg+0m0ZoYMxqxB/hXD
	FcRhtdjqoQ5MwHxpLbz3XkRU3AzdzazI8chitGCevyWk9sr6tkfcaBX2epWMxSgTQYRnBY
	weIzIlydR6MgIe4wYcNmxlohRqO95IQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-596-O--pgBqLM6quy9xAgBCZyQ-1; Fri, 08 Apr 2022 13:13:41 -0400
X-MC-Unique: O--pgBqLM6quy9xAgBCZyQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0AD183C1485C;
	Fri,  8 Apr 2022 17:13:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EEF16111F3DD;
	Fri,  8 Apr 2022 17:13:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C2BC71940344;
	Fri,  8 Apr 2022 17:13:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7202E1940341
 for <dm-devel@listman.corp.redhat.com>; Fri,  8 Apr 2022 17:13:37 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 53E3340D296B; Fri,  8 Apr 2022 17:13:37 +0000 (UTC)
Received: from localhost (ovpn-8-29.pek2.redhat.com [10.72.8.29])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 8475F40D2962;
 Fri,  8 Apr 2022 17:13:36 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Mike Snitzer <snitzer@redhat.com>
Date: Sat,  9 Apr 2022 01:12:52 +0800
Message-Id: <20220408171254.935171-2-ming.lei@redhat.com>
In-Reply-To: <20220408171254.935171-1-ming.lei@redhat.com>
References: <20220408171254.935171-1-ming.lei@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: [dm-devel] [PATCH 1/3] dm: don't grab target io reference in
 dm_zone_map_bio
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
Cc: dm-devel@redhat.com, Damien Le Moal <damien.lemoal@wdc.com>,
 Ming Lei <ming.lei@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

dm_zone_map_bio() is only called from __map_bio in which the io's
reference is grabbed already, and the reference won't be released
until the bio is submitted, so no necessary to do it dm_zone_map_bio
any more.

Cc: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/md/dm-core.h |  7 -------
 drivers/md/dm-zone.c | 10 ----------
 drivers/md/dm.c      |  7 ++++++-
 3 files changed, 6 insertions(+), 18 deletions(-)

diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
index 4277853c7535..13136bd47cb3 100644
--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -277,13 +277,6 @@ static inline void dm_io_set_flag(struct dm_io *io, unsigned int bit)
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
index c1ca9be4b79e..85d3c158719f 100644
--- a/drivers/md/dm-zone.c
+++ b/drivers/md/dm-zone.c
@@ -545,13 +545,6 @@ int dm_zone_map_bio(struct dm_target_io *tio)
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
@@ -580,9 +573,6 @@ int dm_zone_map_bio(struct dm_target_io *tio)
 		break;
 	}
 
-	/* Drop the extra reference on the IO */
-	dm_io_dec_pending(io, sts);
-
 	if (sts != BLK_STS_OK)
 		return DM_MAPIO_KILL;
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 3c5fad7c4ee6..b8424a4b4725 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -929,11 +929,16 @@ static inline bool dm_tio_is_normal(struct dm_target_io *tio)
 		!dm_tio_flagged(tio, DM_TIO_IS_DUPLICATE_BIO));
 }
 
+static void dm_io_inc_pending(struct dm_io *io)
+{
+	atomic_inc(&io->io_count);
+}
+
 /*
  * Decrements the number of outstanding ios that a bio has been
  * cloned into, completing the original io if necc.
  */
-void dm_io_dec_pending(struct dm_io *io, blk_status_t error)
+static void dm_io_dec_pending(struct dm_io *io, blk_status_t error)
 {
 	/* Push-back supersedes any I/O errors */
 	if (unlikely(error)) {
-- 
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

