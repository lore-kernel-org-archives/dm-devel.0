Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47D80C6FD1D
	for <dm-devel@archiver.kernel.org>; Mon, 27 Mar 2023 20:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679948005;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=K7rE7gfIkkick9hC5oefqFb+vy1k4voR4Qk7csAT96Q=;
	b=N1C5pcy6YSD9c1wmCJ2bltZVS7xyJshG3WL5fd9EJwyT1ToBls+4Z495Jl+S+vlmHcuBTI
	PSxRUAZ+lkwgEwvFH/seejXU1EEH5b9Z0B1H6YQAaTo5awEffwT+S9FuDQBSdao6ODKkgY
	nOMkogJh7JovAbfPB0tgZQLztQ8yyTE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-321-_NSJO08OP6i9UqE1LWfVTA-1; Mon, 27 Mar 2023 16:13:23 -0400
X-MC-Unique: _NSJO08OP6i9UqE1LWfVTA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 05A60185A791;
	Mon, 27 Mar 2023 20:13:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E57C5C33187;
	Mon, 27 Mar 2023 20:13:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 36C541946A6F;
	Mon, 27 Mar 2023 20:13:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 133AC19465B9
 for <dm-devel@listman.corp.redhat.com>; Mon, 27 Mar 2023 20:13:11 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 06DBEC15BB8; Mon, 27 Mar 2023 20:13:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F3201C15BA0
 for <dm-devel@redhat.com>; Mon, 27 Mar 2023 20:13:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D79EC3C0E44A
 for <dm-devel@redhat.com>; Mon, 27 Mar 2023 20:13:10 +0000 (UTC)
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com
 [209.85.160.169]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-221-3YBuUjitNIKfosdK_x-V_A-1; Mon, 27 Mar 2023 16:13:09 -0400
X-MC-Unique: 3YBuUjitNIKfosdK_x-V_A-1
Received: by mail-qt1-f169.google.com with SMTP id n14so9789386qta.10
 for <dm-devel@redhat.com>; Mon, 27 Mar 2023 13:13:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1679947988;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=pNKDXzqz05HkFrPteMNUMY0uT7UJYCgf272zyuZUZl4=;
 b=rwHho5qRM3GFKMYMthdcGXK6p7SmVe3MLqZJcCHtdDVNC1TUbfYExnYyzZA73y81oJ
 pp6ppQO6HPfCK3esBKNyn8BLFt2w71nQR3P/6Fp1Hja1s+c+enrAL9VRZuEydl1BQjQd
 70EXSC3UeE6Qm62bFTboS2m6Gj6gBv2sAsJrLxOtt4MrSYExvM3cZ1cBgGeqYPYjzGfo
 yykAJYD2LQ3knycWU6Su+WU968xNCS4+YUOzH4nBzr/R31sozNc4Dv/aGG2lu/7nYgd3
 IJKWSZ0GV59JejlU8V11+TFUxKfquoJF2CVvoSNMQXOQUyPjM6iX71Il73pOM2Uunryi
 dxNA==
X-Gm-Message-State: AO0yUKWcLU2YKFnCeOz8ZOi/2corw+lU01ygSKR7zrRSEHtYxhWD2KWH
 aH4pQ2eWVseEIt7qqjdpHi/tvEhmPL2iFhXS+2f5REokk44oo10kGtlRbwnjREVT/eZhr2XwjE1
 z7m9pzJWYV4yJu2fC8jvAEzhdonrCtb7zUyMuHH7uJYSz0ab2GZS783b8t9IKdud7+R1TI95l1w
 Y=
X-Google-Smtp-Source: AK7set+7MMoq6Vd0Xdcf9qnBj1WT4JAtfpuUnRj7pcmV6oOeji14qNAy6w9DZt923oR8XoqLbUpKMQ==
X-Received: by 2002:ac8:5f0b:0:b0:3e1:c341:f618 with SMTP id
 x11-20020ac85f0b000000b003e1c341f618mr20781332qta.65.1679947988341; 
 Mon, 27 Mar 2023 13:13:08 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 128-20020a370486000000b00746772d78a6sm11397199qke.2.2023.03.27.13.13.07
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 27 Mar 2023 13:13:07 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Mon, 27 Mar 2023 16:11:24 -0400
Message-Id: <20230327201143.51026-2-snitzer@kernel.org>
In-Reply-To: <20230327201143.51026-1-snitzer@kernel.org>
References: <20230327201143.51026-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: [dm-devel] [dm-6.4 PATCH v3 01/20] dm bufio: remove unused
 dm_bufio_release_move interface
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
Cc: axboe@kernel.dk, ebiggers@kernel.org, keescook@chromium.org,
 heinzm@redhat.com, Mike Snitzer <snitzer@kernel.org>, nhuck@google.com,
 linux-block@vger.kernel.org, ejt@redhat.com, mpatocka@redhat.com,
 luomeng12@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Joe Thornber <ejt@redhat.com>

Was used by multi-snapshot DM target that never went upstream.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Acked-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-bufio.c    | 77 ----------------------------------------
 include/linux/dm-bufio.h |  6 ----
 2 files changed, 83 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index cf077f9b30c3..79434b38f368 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -1415,83 +1415,6 @@ int dm_bufio_issue_discard(struct dm_bufio_client *c, sector_t block, sector_t c
 }
 EXPORT_SYMBOL_GPL(dm_bufio_issue_discard);
 
-/*
- * We first delete any other buffer that may be at that new location.
- *
- * Then, we write the buffer to the original location if it was dirty.
- *
- * Then, if we are the only one who is holding the buffer, relink the buffer
- * in the buffer tree for the new location.
- *
- * If there was someone else holding the buffer, we write it to the new
- * location but not relink it, because that other user needs to have the buffer
- * at the same place.
- */
-void dm_bufio_release_move(struct dm_buffer *b, sector_t new_block)
-{
-	struct dm_bufio_client *c = b->c;
-	struct dm_buffer *new;
-
-	BUG_ON(dm_bufio_in_request());
-
-	dm_bufio_lock(c);
-
-retry:
-	new = __find(c, new_block);
-	if (new) {
-		if (new->hold_count) {
-			__wait_for_free_buffer(c);
-			goto retry;
-		}
-
-		/*
-		 * FIXME: Is there any point waiting for a write that's going
-		 * to be overwritten in a bit?
-		 */
-		__make_buffer_clean(new);
-		__unlink_buffer(new);
-		__free_buffer_wake(new);
-	}
-
-	BUG_ON(!b->hold_count);
-	BUG_ON(test_bit(B_READING, &b->state));
-
-	__write_dirty_buffer(b, NULL);
-	if (b->hold_count == 1) {
-		wait_on_bit_io(&b->state, B_WRITING,
-			       TASK_UNINTERRUPTIBLE);
-		set_bit(B_DIRTY, &b->state);
-		b->dirty_start = 0;
-		b->dirty_end = c->block_size;
-		__unlink_buffer(b);
-		__link_buffer(b, new_block, LIST_DIRTY);
-	} else {
-		sector_t old_block;
-
-		wait_on_bit_lock_io(&b->state, B_WRITING,
-				    TASK_UNINTERRUPTIBLE);
-		/*
-		 * Relink buffer to "new_block" so that write_callback
-		 * sees "new_block" as a block number.
-		 * After the write, link the buffer back to old_block.
-		 * All this must be done in bufio lock, so that block number
-		 * change isn't visible to other threads.
-		 */
-		old_block = b->block;
-		__unlink_buffer(b);
-		__link_buffer(b, new_block, b->list_mode);
-		submit_io(b, REQ_OP_WRITE, write_endio);
-		wait_on_bit_io(&b->state, B_WRITING,
-			       TASK_UNINTERRUPTIBLE);
-		__unlink_buffer(b);
-		__link_buffer(b, old_block, b->list_mode);
-	}
-
-	dm_bufio_unlock(c);
-	dm_bufio_release(b);
-}
-EXPORT_SYMBOL_GPL(dm_bufio_release_move);
-
 static void forget_buffer_locked(struct dm_buffer *b)
 {
 	if (likely(!b->hold_count) && likely(!smp_load_acquire(&b->state))) {
diff --git a/include/linux/dm-bufio.h b/include/linux/dm-bufio.h
index 2056743aaaaa..681656a1c03d 100644
--- a/include/linux/dm-bufio.h
+++ b/include/linux/dm-bufio.h
@@ -130,12 +130,6 @@ int dm_bufio_issue_flush(struct dm_bufio_client *c);
  */
 int dm_bufio_issue_discard(struct dm_bufio_client *c, sector_t block, sector_t count);
 
-/*
- * Like dm_bufio_release but also move the buffer to the new
- * block. dm_bufio_write_dirty_buffers is needed to commit the new block.
- */
-void dm_bufio_release_move(struct dm_buffer *b, sector_t new_block);
-
 /*
  * Free the given buffer.
  * This is just a hint, if the buffer is in use or dirty, this function
-- 
2.40.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

