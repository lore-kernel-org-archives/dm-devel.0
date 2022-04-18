Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62E01C433FE
	for <dm-devel@archiver.kernel.org>; Mon, 18 Apr 2022 02:28:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-660-LRIsKv3kPAO-Hgnx9diQgg-1; Sun, 17 Apr 2022 22:28:03 -0400
X-MC-Unique: LRIsKv3kPAO-Hgnx9diQgg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9DC7C3C00124;
	Mon, 18 Apr 2022 02:28:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8509D145D483;
	Mon, 18 Apr 2022 02:28:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 23BCD1940353;
	Mon, 18 Apr 2022 02:28:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3637A19451F1
 for <dm-devel@listman.corp.redhat.com>; Mon, 18 Apr 2022 02:27:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 29786200B434; Mon, 18 Apr 2022 02:27:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 24E382029F8F
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 02:27:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F123138035A7
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 02:27:47 +0000 (UTC)
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com
 [209.85.222.171]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-110-BxhepsTWPlGZBleAGUEg1A-1; Sun, 17 Apr 2022 22:27:46 -0400
X-MC-Unique: BxhepsTWPlGZBleAGUEg1A-1
Received: by mail-qk1-f171.google.com with SMTP id s70so3596131qke.8
 for <dm-devel@redhat.com>; Sun, 17 Apr 2022 19:27:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references;
 bh=sUhfxEBPxt2oHPy19I+MXOfRAaSDteI777/I80bXC84=;
 b=5RXTnnaTwTRKSA10Iur5jBA7aYv4AkCr7ajVcYWNSXe5ldmaziWEVcNH/s6OHgh2rm
 AY+jfFpHqEOCiCUbn1YYTtUvm1MsOH0kCXluYs2DIQVmUsN8g9Xz0AfIRAkIgPNsrUBB
 bSEiNAH0higqUDqputqe+cFkcpg1myFb9z3ebDU0J4NaE1pIur5yAM1fl+YoRNEzgocx
 4vNihSvsdh7I3xIh8hzAsIOkmKMMAJmWOlNptOjykIHG5XVcZOWYp3FgQfHsOrX92baw
 iNUJCMLMvno5W5CUw8Ak8VX5R0QmDr70Vt2x86+Lo17k24H7YMKSI/A23+6cxwLSJ5Zr
 jd7Q==
X-Gm-Message-State: AOAM531xmzbYh9k5KLUQXu7esNC91MlNRA17cXxJLw/8yBufJK6K8Mlm
 kFb8man7mTYkuE2dc1ZhwwVUYIOZDBef0VQGAGXDuvsvqUermreliHkDZ3ryNWMJNhzGy1MtcK9
 u8MjQiTkdrMvAVU8is+B1cKJ32uOMNpFINpT7uUE4gEHvXE6OGzspa0u9s73c1GgxCqg=
X-Google-Smtp-Source: ABdhPJxwGcWlcNx5BE4STr8vOFowQljXAWiUlawLJFL1xDG1Rtya3XdEOkcY8uEU+TumspC9j4GfOA==
X-Received: by 2002:a05:620a:13a3:b0:69e:13f4:6f96 with SMTP id
 m3-20020a05620a13a300b0069e13f46f96mr5364223qki.100.1650248865725; 
 Sun, 17 Apr 2022 19:27:45 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 d13-20020a05622a15cd00b002f2005e6016sm866230qty.92.2022.04.17.19.27.45
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 17 Apr 2022 19:27:45 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Sun, 17 Apr 2022 22:27:21 -0400
Message-Id: <20220418022733.56168-10-snitzer@kernel.org>
In-Reply-To: <20220418022733.56168-1-snitzer@kernel.org>
References: <20220418022733.56168-1-snitzer@kernel.org>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: [dm-devel] [dm-5.19 PATCH 09/21] dm: introduce dm_{get,
 put}_live_table_bio called from dm_submit_bio
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

If a bio is marked REQ_NOWAIT optimize dm_submit_bio()'s dm_table RCU
usage to dm_{get,put}_live_table_fast.

DM core offers protection against blocking (via suspend) if REQ_NOWAIT.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm.c | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 4793225722dd..073b41ce7a30 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -661,14 +661,16 @@ static void queue_io(struct mapped_device *md, struct bio *bio)
  * function to access the md->map field, and make sure they call
  * dm_put_live_table() when finished.
  */
-struct dm_table *dm_get_live_table(struct mapped_device *md, int *srcu_idx) __acquires(md->io_barrier)
+struct dm_table *dm_get_live_table(struct mapped_device *md,
+				   int *srcu_idx) __acquires(md->io_barrier)
 {
 	*srcu_idx = srcu_read_lock(&md->io_barrier);
 
 	return srcu_dereference(md->map, &md->io_barrier);
 }
 
-void dm_put_live_table(struct mapped_device *md, int srcu_idx) __releases(md->io_barrier)
+void dm_put_live_table(struct mapped_device *md,
+		       int srcu_idx) __releases(md->io_barrier)
 {
 	srcu_read_unlock(&md->io_barrier, srcu_idx);
 }
@@ -694,6 +696,24 @@ static void dm_put_live_table_fast(struct mapped_device *md) __releases(RCU)
 	rcu_read_unlock();
 }
 
+static inline struct dm_table *dm_get_live_table_bio(struct mapped_device *md,
+						     int *srcu_idx, struct bio *bio)
+{
+	if (bio->bi_opf & REQ_NOWAIT)
+		return dm_get_live_table_fast(md);
+	else
+		return dm_get_live_table(md, srcu_idx);
+}
+
+static inline void dm_put_live_table_bio(struct mapped_device *md, int srcu_idx,
+					 struct bio *bio)
+{
+	if (bio->bi_opf & REQ_NOWAIT)
+		dm_put_live_table_fast(md);
+	else
+		dm_put_live_table(md, srcu_idx);
+}
+
 static char *_dm_claim_ptr = "I belong to device-mapper";
 
 /*
@@ -1613,7 +1633,7 @@ static void dm_submit_bio(struct bio *bio)
 	int srcu_idx;
 	struct dm_table *map;
 
-	map = dm_get_live_table(md, &srcu_idx);
+	map = dm_get_live_table_bio(md, &srcu_idx, bio);
 
 	/* If suspended, or map not yet available, queue this IO for later */
 	if (unlikely(test_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags)) ||
@@ -1636,7 +1656,7 @@ static void dm_submit_bio(struct bio *bio)
 
 	dm_split_and_process_bio(md, map, bio);
 out:
-	dm_put_live_table(md, srcu_idx);
+	dm_put_live_table_bio(md, srcu_idx, bio);
 }
 
 static bool dm_poll_dm_io(struct dm_io *io, struct io_comp_batch *iob,
-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

