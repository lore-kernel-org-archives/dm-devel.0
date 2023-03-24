Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06D19C7619A
	for <dm-devel@archiver.kernel.org>; Fri, 24 Mar 2023 17:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679680656;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=K7rE7gfIkkick9hC5oefqFb+vy1k4voR4Qk7csAT96Q=;
	b=cU8iKYSZIIWpUTs39VVtmlPbHQ0DcvPAjV2+WwZUCwDIwDwiQcHBjp5Q7qBFFEdG+L0Lmd
	JaOTblMpqdvqBUP0BVbWV9/deQydQgfg2xnNXDASreBZu5EmcFxEaUhGDb4/IkRz8HoYPa
	uLOf8rLFD9Pl1p7+muQ4ilsTXI1oDMo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-359-z46jwPCePhKaIYsSFtwJOg-1; Fri, 24 Mar 2023 13:57:31 -0400
X-MC-Unique: z46jwPCePhKaIYsSFtwJOg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8DBC285530F;
	Fri, 24 Mar 2023 17:57:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7B88F492B0A;
	Fri, 24 Mar 2023 17:57:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B1F3E1946A6E;
	Fri, 24 Mar 2023 17:57:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E22BE1946A6E
 for <dm-devel@listman.corp.redhat.com>; Fri, 24 Mar 2023 17:57:09 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C1AB3440BC; Fri, 24 Mar 2023 17:57:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B9B6D18EC7
 for <dm-devel@redhat.com>; Fri, 24 Mar 2023 17:57:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9E4CB858F09
 for <dm-devel@redhat.com>; Fri, 24 Mar 2023 17:57:04 +0000 (UTC)
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com
 [209.85.219.54]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-655-MbyIpRu-OGWz7rEAl5zcww-1; Fri, 24 Mar 2023 13:57:02 -0400
X-MC-Unique: MbyIpRu-OGWz7rEAl5zcww-1
Received: by mail-qv1-f54.google.com with SMTP id o44so2165819qvo.4
 for <dm-devel@redhat.com>; Fri, 24 Mar 2023 10:57:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1679680622;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=pNKDXzqz05HkFrPteMNUMY0uT7UJYCgf272zyuZUZl4=;
 b=T9fAKSubpjzT32lw9amLe3Ev5Kb/LMW7UUnjKasPR03pv1tXLrZ7nZ+1q3nVIVnh6F
 VFx6UecbAef4fc/zFO1nVxobdrhka0VSbPIGQnBFM3Q69nCva+BHW0DovZbBIH9eO/qU
 uXrJhn++lxxhKA4oaTQHpZiWkzl6aR4JXvBRk5Y5cOoHjaqBqqYmq9oUwnyOg6Ic2Lrj
 ZtD9I683MejlcOeRD/wOJoYChBNM+9kdceDZ+EmFsYhgwXaInVVsJEhDQIAx0GmKR2/1
 dCffxlrtCTHUDKTEwLHCmnQUgKg45/yd/6FF/qMnno5V8iULie4J8x4+I/nyMqaLlDXJ
 817Q==
X-Gm-Message-State: AAQBX9djoEdTo8SxrSmppJMTtNFGt7sdkeabIXtFAVD8LycfQKnp2ien
 66zFLDDGIdvb6PBkE3C5ClHFVKZRAoPl1Z9+LrGY5zIntz1RTAGLk9cnPPCD6heqBC07ZS2xNwu
 WNWlxbPb1ENBcvPkA7S/+AkzqdbTDVDcuMNts0MLwrkAtGl5ybi6LIFlOUF7Cx+dsF+Pr61iSWT
 I=
X-Google-Smtp-Source: AKy350bGhp7W2newRVTBbmoZx2qXXA2gpmXP36PQU0b4o9rStz5h1Py2BEuc4rkgXhilOeRw/2nEUg==
X-Received: by 2002:a05:6214:1d2f:b0:5c2:3e10:53e4 with SMTP id
 f15-20020a0562141d2f00b005c23e1053e4mr6117499qvd.15.1679680621865; 
 Fri, 24 Mar 2023 10:57:01 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 w16-20020a0cef90000000b005dd8b9345cfsm843233qvr.103.2023.03.24.10.57.01
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 24 Mar 2023 10:57:01 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Fri, 24 Mar 2023 13:56:48 -0400
Message-Id: <20230324175656.85082-2-snitzer@kernel.org>
In-Reply-To: <20230324175656.85082-1-snitzer@kernel.org>
References: <20230324175656.85082-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: [dm-devel] [dm-6.4 PATCH v2 1/9] dm bufio: remove unused
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
Cc: ebiggers@kernel.org, keescook@chromium.org, heinzm@redhat.com,
 Mike Snitzer <snitzer@kernel.org>, nhuck@google.com,
 linux-block@vger.kernel.org, ejt@redhat.com, mpatocka@redhat.com,
 luomeng12@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
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

