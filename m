Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8CA5C636CC
	for <dm-devel@archiver.kernel.org>; Mon, 13 Feb 2023 20:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676319336;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=e4y+xFxGof3twV+M0QAqjKy+8cRzGiNjO8TwKk1Pqfg=;
	b=PaIMvxE5xRAqhLLG3P3+WqJi7Or7OFVuc9XPu+/gUa2bvzUPLy7nLeP82qlIOHxS1z9eSg
	HwTNJSCFIksSOal3e1rp5egT1SxG0WLYmJvtielt4ajc6c2tPIr1UgJBaup+4lPVqeqmRw
	/RE8BtM+RRAQCk07/yenj+xTrzvVvM4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-447-7gENYe-CO3Kl9tiZwfYbJQ-1; Mon, 13 Feb 2023 15:15:32 -0500
X-MC-Unique: 7gENYe-CO3Kl9tiZwfYbJQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1339B1C07565;
	Mon, 13 Feb 2023 20:15:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F41D12026D4B;
	Mon, 13 Feb 2023 20:15:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D180E194658C;
	Mon, 13 Feb 2023 20:15:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9EAC61946588
 for <dm-devel@listman.corp.redhat.com>; Mon, 13 Feb 2023 20:15:18 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 850DB1121319; Mon, 13 Feb 2023 20:15:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7CFAE1121318
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:15:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D3360296A60C
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:15:14 +0000 (UTC)
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com
 [209.85.160.178]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-102-W8QScY-lPi-GqTRf8pcp4w-1; Mon, 13 Feb 2023 15:15:13 -0500
X-MC-Unique: W8QScY-lPi-GqTRf8pcp4w-1
Received: by mail-qt1-f178.google.com with SMTP id h24so15157810qta.12
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 12:15:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=st3ShYWOXzNOYzeEWZEVU8Y4Fu0YoenKt6jaHHZIRqY=;
 b=FSGpjL3XRx3Bd+BsN/3MQ3ukyjn3TfagWLW+aBH9tS/9nhiLZT1C0SgFGzLjCQQjA3
 WfgsFenuNXJStds6AAKsutftOPAC7Nw7PGGWBfZo+ZGA93l5zhne88vGdM5AO1Oclk69
 5qrfqg3qpoPXDV/3Nzkp8q/YxvOisZvjqUQ0BAXynMxE9yIhKlt7Qcp92zUsy3QZ2gvu
 84P83CxUduYs0G5VJNNPCCIbXaOMpKESNjKbrxFR1YyzuUIaU9sK2Wy2Zt3OpJ9Hzzte
 Xmnr9svIayaNPR7ZgJFu0Zntr9QOKcW4Cuh4L7uCv8F/f8ucrNWlVyUOKgVuEBH+mEi5
 +PHw==
X-Gm-Message-State: AO0yUKUAQiLbvMyIs4GzYEkQVDd2l/hywi187kaF1Ifs29gXDx12IaMB
 1RlVdXp/rxx6QYuFgKdArEJxJagPnMiu49OoUze7ER3N2ODtibH/k5KH8ockeHgNXP7kWh8v3O/
 QBY4rkxsXxYRnKl2j5L07Y8amDqLwD+NGYw+JSsRI/EMTLt0gPrNPT73Ih+YJ3v8KDxz9wQ==
X-Google-Smtp-Source: AK7set/P3Y79ByQSpeY1+LB8fX/25omSRkgXBlXzb4bEyJF19sz34dEgvvQ7HuOSDZrROWuPesT5Hg==
X-Received: by 2002:a05:622a:512:b0:3ba:38:2f5f with SMTP id
 l18-20020a05622a051200b003ba00382f5fmr43880993qtx.32.1676319310739; 
 Mon, 13 Feb 2023 12:15:10 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 f4-20020ac840c4000000b003b9bb59543fsm9779828qtm.61.2023.02.13.12.15.10
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 13 Feb 2023 12:15:10 -0800 (PST)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Mon, 13 Feb 2023 15:13:48 -0500
Message-Id: <20230213201401.45973-27-snitzer@kernel.org>
In-Reply-To: <20230213201401.45973-1-snitzer@kernel.org>
References: <20230213201401.45973-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: [dm-devel] [PATCH 26/39] dm: add missing blank line after
 declarations/fix those
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
Cc: ebiggers@kernel.org, Heinz Mauelshagen <heinzm@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Heinz Mauelshagen <heinzm@redhat.com>

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-raid.c                  | 2 +-
 drivers/md/dm.c                       | 5 +++++
 drivers/md/persistent-data/dm-array.c | 4 ++--
 drivers/md/persistent-data/dm-btree.c | 4 ++--
 drivers/md/persistent-data/dm-btree.h | 2 +-
 5 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 08fcc9908d0c..390f23150ff4 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -33,7 +33,7 @@
 static bool devices_handle_discard_safely;
 
 /*
- * The following flags are used by dm-raid.c to set up the array state.
+ * The following flags are used by dm-raid to set up the array state.
  * They must be cleared before md_run is called.
  */
 #define FirstUse 10		/* rdev flag */
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index a54700b6c9eb..7e6e81fe5298 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -105,6 +105,7 @@ EXPORT_SYMBOL_GPL(dm_per_bio_data);
 struct bio *dm_bio_from_per_bio_data(void *data, size_t data_size)
 {
 	struct dm_io *io = (struct dm_io *)((char *)data + data_size);
+
 	if (io->magic == DM_IO_MAGIC)
 		return (struct bio *)((char *)io + DM_IO_BIO_OFFSET);
 	BUG_ON(io->magic != DM_TIO_MAGIC);
@@ -128,6 +129,7 @@ static int swap_bios = DEFAULT_SWAP_BIOS;
 static int get_swap_bios(void)
 {
 	int latch = READ_ONCE(swap_bios);
+
 	if (unlikely(latch <= 0))
 		latch = DEFAULT_SWAP_BIOS;
 	return latch;
@@ -1115,6 +1117,7 @@ static void clone_endio(struct bio *bio)
 
 	if (endio) {
 		int r = endio(ti, bio, &error);
+
 		switch (r) {
 		case DM_ENDIO_REQUEUE:
 			if (static_branch_unlikely(&zoned_enabled)) {
@@ -1403,6 +1406,7 @@ static void __map_bio(struct bio *clone)
 	if (static_branch_unlikely(&swap_bios_enabled) &&
 	    unlikely(swap_bios_limit(ti, clone))) {
 		int latch = get_swap_bios();
+
 		if (unlikely(latch != md->swap_bios))
 			__set_swap_bios_limit(md, latch);
 		down(&md->swap_bios_semaphore);
@@ -2790,6 +2794,7 @@ static int __dm_resume(struct mapped_device *md, struct dm_table *map)
 {
 	if (map) {
 		int r = dm_table_resume_targets(map);
+
 		if (r)
 			return r;
 	}
diff --git a/drivers/md/persistent-data/dm-array.c b/drivers/md/persistent-data/dm-array.c
index 7821bf106fa7..a8c4d21aa8ce 100644
--- a/drivers/md/persistent-data/dm-array.c
+++ b/drivers/md/persistent-data/dm-array.c
@@ -695,7 +695,7 @@ static int array_resize(struct dm_array_info *info, dm_block_t root,
 int dm_array_resize(struct dm_array_info *info, dm_block_t root,
 		    uint32_t old_size, uint32_t new_size,
 		    const void *value, dm_block_t *new_root)
-		    __dm_written_to_disk(value)
+	__dm_written_to_disk(value)
 {
 	int r = array_resize(info, root, old_size, new_size, value, new_root);
 
@@ -846,7 +846,7 @@ static int array_set_value(struct dm_array_info *info, dm_block_t root,
 
 int dm_array_set_value(struct dm_array_info *info, dm_block_t root,
 		 uint32_t index, const void *value, dm_block_t *new_root)
-		 __dm_written_to_disk(value)
+	__dm_written_to_disk(value)
 {
 	int r;
 
diff --git a/drivers/md/persistent-data/dm-btree.c b/drivers/md/persistent-data/dm-btree.c
index 67b868ac2128..92560eb9301e 100644
--- a/drivers/md/persistent-data/dm-btree.c
+++ b/drivers/md/persistent-data/dm-btree.c
@@ -1320,7 +1320,7 @@ static int insert(struct dm_btree_info *info, dm_block_t root,
 
 int dm_btree_insert(struct dm_btree_info *info, dm_block_t root,
 		    uint64_t *keys, void *value, dm_block_t *new_root)
-		    __dm_written_to_disk(value)
+	__dm_written_to_disk(value)
 {
 	return insert(info, root, keys, value, new_root, NULL);
 }
@@ -1329,7 +1329,7 @@ EXPORT_SYMBOL_GPL(dm_btree_insert);
 int dm_btree_insert_notify(struct dm_btree_info *info, dm_block_t root,
 			   uint64_t *keys, void *value, dm_block_t *new_root,
 			   int *inserted)
-			   __dm_written_to_disk(value)
+	__dm_written_to_disk(value)
 {
 	return insert(info, root, keys, value, new_root, inserted);
 }
diff --git a/drivers/md/persistent-data/dm-btree.h b/drivers/md/persistent-data/dm-btree.h
index 0381ed689e51..9302cca04c31 100644
--- a/drivers/md/persistent-data/dm-btree.h
+++ b/drivers/md/persistent-data/dm-btree.h
@@ -122,7 +122,7 @@ int dm_btree_lookup_next(struct dm_btree_info *info, dm_block_t root,
  */
 int dm_btree_insert(struct dm_btree_info *info, dm_block_t root,
 		    uint64_t *keys, void *value, dm_block_t *new_root)
-		    __dm_written_to_disk(value);
+	__dm_written_to_disk(value);
 
 /*
  * A variant of insert that indicates whether it actually inserted or just
-- 
2.37.0 (Apple Git-136)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

