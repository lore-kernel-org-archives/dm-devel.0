Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCBCCC00140
	for <dm-devel@archiver.kernel.org>; Wed, 10 Aug 2022 20:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1660162603;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=/SE+jr6dFOXZ+GqzMt1QiDRrwFWd3b7PQAZhq6jmGjs=;
	b=Feip+shcMPlC9wx7et1PdlMOVO0X23N11W6oj7j8kzEVZBQuUvg02YhkvFJ0C/O4FDSqUE
	KYsr85lHzgTR0A+YaUC2iC3pQ9NMJ3fRL4Gp/wR1bIPJWRAYgVe09r4vEnRhhQUM9aKTPq
	Oqp+QC5gEZHmqRQvCAEmawJnNGoWaEk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-649-m2IF052cN5mD0vdL0zs2BA-1; Wed, 10 Aug 2022 16:16:40 -0400
X-MC-Unique: m2IF052cN5mD0vdL0zs2BA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 95BF7801585;
	Wed, 10 Aug 2022 20:16:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3A31618EAA;
	Wed, 10 Aug 2022 20:16:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 094D51946A50;
	Wed, 10 Aug 2022 20:16:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5EE931946A4F
 for <dm-devel@listman.corp.redhat.com>; Wed, 10 Aug 2022 20:16:34 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 475A518EAA; Wed, 10 Aug 2022 20:16:34 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3D9FD945D0;
 Wed, 10 Aug 2022 20:16:34 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 27AKGYNU021959; Wed, 10 Aug 2022 16:16:34 -0400
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 27AKGYDB021955; Wed, 10 Aug 2022 16:16:34 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Wed, 10 Aug 2022 16:16:34 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Mike Snitzer <msnitzer@redhat.com>
Message-ID: <alpine.LRH.2.02.2208101614300.21201@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: [dm-devel] [PATCH] dm bufio: fix some cases where the code sleeps
 with spinlock held
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
Cc: dm-devel@redhat.com, Nathan Huckleberry <nhuck@google.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The patch b32d45824aa7 ("dm bufio: Add DM_BUFIO_CLIENT_NO_SLEEP flag")
added a "NO_SLEEP" mode, it replaces a mutex with a spinlock, and it is
only usable when the device is in read-only mode (because the write path
may be sleeping while holding the dm_bufio_client lock).

However, there are still two points where the code could sleep even in
read-only mode. One is in __get_unclaimed_buffer -> __make_buffer_clean.
The other is in __try_evict_buffer -> __make_buffer_clean. These functions
will call __make_buffer_clean which sleeps if the buffer is being read.

This patch fixes these cases, so that if c->no_sleep is set, we won't call
__make_buffer_clean and we skip the buffer instead.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: b32d45824aa7 ("dm bufio: Add DM_BUFIO_CLIENT_NO_SLEEP flag")

Index: linux-2.6/drivers/md/dm-bufio.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-bufio.c
+++ linux-2.6/drivers/md/dm-bufio.c
@@ -817,6 +817,9 @@ static struct dm_buffer *__get_unclaimed
 		BUG_ON(test_bit(B_WRITING, &b->state));
 		BUG_ON(test_bit(B_DIRTY, &b->state));
 
+		if (static_branch_unlikely(&no_sleep_enabled) && c->no_sleep && unlikely(test_bit(B_READING, &b->state)))
+			continue;
+
 		if (!b->hold_count) {
 			__make_buffer_clean(b);
 			__unlink_buffer(b);
@@ -825,6 +828,9 @@ static struct dm_buffer *__get_unclaimed
 		cond_resched();
 	}
 
+	if (static_branch_unlikely(&no_sleep_enabled) && c->no_sleep)
+		return NULL;
+
 	list_for_each_entry_reverse(b, &c->lru[LIST_DIRTY], lru_list) {
 		BUG_ON(test_bit(B_READING, &b->state));
 
@@ -1632,7 +1638,7 @@ static void drop_buffers(struct dm_bufio
  */
 static bool __try_evict_buffer(struct dm_buffer *b, gfp_t gfp)
 {
-	if (!(gfp & __GFP_FS)) {
+	if (!(gfp & __GFP_FS) || (static_branch_unlikely(&no_sleep_enabled) && b->c->no_sleep)) {
 		if (test_bit(B_READING, &b->state) ||
 		    test_bit(B_WRITING, &b->state) ||
 		    test_bit(B_DIRTY, &b->state))
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

