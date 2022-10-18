Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA3A0C4332F
	for <dm-devel@archiver.kernel.org>; Tue, 18 Oct 2022 14:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666102015;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=rUI+QtYhe6FsLUrZbRcLT2vNByOxzpfovbTfn/VQMkk=;
	b=UU/yM+fXhZ5qcmtqk8ziCBbwwmQHLxWHE7+Zvg0piFIt0ZOok2BPh7ilXTY/Q3I+gj2Spw
	i/mL5m2Xxlxwr++2sGMTMU+WE32H82hapzORowl+qg9OYFWRaQvvJG6J4/xE69uLVMEsmG
	w0OECGVZ1RvB0pP4eA7yLVDy0bL6aW8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-470-pImvtUkXOj6W6ihKM9KKKQ-1; Tue, 18 Oct 2022 10:06:52 -0400
X-MC-Unique: pImvtUkXOj6W6ihKM9KKKQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AF16F88F452;
	Tue, 18 Oct 2022 14:06:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2C98049BB62;
	Tue, 18 Oct 2022 14:06:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EC25E1946594;
	Tue, 18 Oct 2022 14:06:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 242CC194658F
 for <dm-devel@listman.corp.redhat.com>; Tue, 18 Oct 2022 14:06:46 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 058192022C33; Tue, 18 Oct 2022 14:06:46 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E5B892022C2B;
 Tue, 18 Oct 2022 14:06:45 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 29IE6joW017660; Tue, 18 Oct 2022 10:06:45 -0400
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 29IE6jgf017656; Tue, 18 Oct 2022 10:06:45 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Tue, 18 Oct 2022 10:06:45 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Mike Snitzer <msnitzer@redhat.com>, Joe Thornber <thornber@redhat.com>
Message-ID: <alpine.LRH.2.02.2210181005410.17374@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] [PATCH] dm-bufio: use the acquire memory barrier when
 testing for B_READ
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
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The function test_bit doesn't provide any memory barrier. It may be
possible that the read requests that follow test_bit(B_READING, &b->state)
are reordered before the test, reading invalid data that existed before
B_READING was cleared.

Fix this bug by changing test_bit to test_bit_acquire.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/md/dm-bufio.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: linux-2.6/drivers/md/dm-bufio.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-bufio.c
+++ linux-2.6/drivers/md/dm-bufio.c
@@ -795,7 +795,7 @@ static void __make_buffer_clean(struct d
 {
 	BUG_ON(b->hold_count);
 
-	if (!b->state)	/* fast case */
+	if (!smp_load_acquire(&b->state))	/* fast case */
 		return;
 
 	wait_on_bit_io(&b->state, B_READING, TASK_UNINTERRUPTIBLE);
@@ -816,7 +816,7 @@ static struct dm_buffer *__get_unclaimed
 		BUG_ON(test_bit(B_DIRTY, &b->state));
 
 		if (static_branch_unlikely(&no_sleep_enabled) && c->no_sleep &&
-		    unlikely(test_bit(B_READING, &b->state)))
+		    unlikely(test_bit_acquire(B_READING, &b->state)))
 			continue;
 
 		if (!b->hold_count) {
@@ -1058,7 +1058,7 @@ found_buffer:
 	 * If the user called both dm_bufio_prefetch and dm_bufio_get on
 	 * the same buffer, it would deadlock if we waited.
 	 */
-	if (nf == NF_GET && unlikely(test_bit(B_READING, &b->state)))
+	if (nf == NF_GET && unlikely(test_bit_acquire(B_READING, &b->state)))
 		return NULL;
 
 	b->hold_count++;
@@ -1218,7 +1218,7 @@ void dm_bufio_release(struct dm_buffer *
 		 * invalid buffer.
 		 */
 		if ((b->read_error || b->write_error) &&
-		    !test_bit(B_READING, &b->state) &&
+		    !test_bit_acquire(B_READING, &b->state) &&
 		    !test_bit(B_WRITING, &b->state) &&
 		    !test_bit(B_DIRTY, &b->state)) {
 			__unlink_buffer(b);
@@ -1479,7 +1479,7 @@ EXPORT_SYMBOL_GPL(dm_bufio_release_move)
 
 static void forget_buffer_locked(struct dm_buffer *b)
 {
-	if (likely(!b->hold_count) && likely(!b->state)) {
+	if (likely(!b->hold_count) && likely(!smp_load_acquire(&b->state))) {
 		__unlink_buffer(b);
 		__free_buffer_wake(b);
 	}
@@ -1639,7 +1639,7 @@ static bool __try_evict_buffer(struct dm
 {
 	if (!(gfp & __GFP_FS) ||
 	    (static_branch_unlikely(&no_sleep_enabled) && b->c->no_sleep)) {
-		if (test_bit(B_READING, &b->state) ||
+		if (test_bit_acquire(B_READING, &b->state) ||
 		    test_bit(B_WRITING, &b->state) ||
 		    test_bit(B_DIRTY, &b->state))
 			return false;
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

