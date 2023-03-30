Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DECEC6FD1D
	for <dm-devel@archiver.kernel.org>; Thu, 30 Mar 2023 11:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680174996;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=kUZgUwHNAvglpD2YuA/cmRHNLVWfbhy6ueYZX6x0ObM=;
	b=dawLnQjV68RevCQgdJ4IbEwMkFj2G4TQdVHIZfYdPNg7AyegB3mnI+7D0Fs+6rdXGUw1xn
	BWr6Cruidsaa+ONWQ9TlJq4YjXgBzTk2UVTLS97mqQPYgGfh88+x/9vWzPzO590NJFtkKH
	WTny+vu50xhBaJAbL2Xk2hKDoAJR+Gc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-413-RGMe2_4FMYqwwdIfTIo8Ng-1; Thu, 30 Mar 2023 07:16:35 -0400
X-MC-Unique: RGMe2_4FMYqwwdIfTIo8Ng-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5DB8C884345;
	Thu, 30 Mar 2023 11:16:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0428B492C3E;
	Thu, 30 Mar 2023 11:16:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AF0A9194658F;
	Thu, 30 Mar 2023 11:16:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8D600194658F
 for <dm-devel@listman.corp.redhat.com>; Thu, 30 Mar 2023 11:16:14 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 20988202701F; Thu, 30 Mar 2023 11:16:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1897D202701E
 for <dm-devel@redhat.com>; Thu, 30 Mar 2023 11:16:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EBBAE3C025C4
 for <dm-devel@redhat.com>; Thu, 30 Mar 2023 11:16:13 +0000 (UTC)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-119-6lBBZ_JfNGeUlCtwpsk7jw-1; Thu, 30 Mar 2023 07:16:12 -0400
X-MC-Unique: 6lBBZ_JfNGeUlCtwpsk7jw-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 232A0B8280D;
 Thu, 30 Mar 2023 11:16:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55C25C433EF;
 Thu, 30 Mar 2023 11:16:09 +0000 (UTC)
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	snitzer@kernel.org
Date: Thu, 30 Mar 2023 07:16:07 -0400
Message-Id: <20230330111607.2889530-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] Patch "dm crypt: avoid accessing uninitialized tasklet"
 has been added to the 5.10-stable tree
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
Cc: dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This is a note to let you know that I've just added the patch titled

    dm crypt: avoid accessing uninitialized tasklet

to the 5.10-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-crypt-avoid-accessing-uninitialized-tasklet.patch
and it can be found in the queue-5.10 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit a95530ebdb4ef34ea248ae061d1fd676a6d4cc8e
Author: Mike Snitzer <snitzer@kernel.org>
Date:   Wed Mar 8 14:39:54 2023 -0500

    dm crypt: avoid accessing uninitialized tasklet
    
    [ Upstream commit d9a02e016aaf5a57fb44e9a5e6da8ccd3b9e2e70 ]
    
    When neither "no_read_workqueue" nor "no_write_workqueue" are enabled,
    tasklet_trylock() in crypt_dec_pending() may still return false due to
    an uninitialized state, and dm-crypt will unnecessarily do io completion
    in io_queue workqueue instead of current context.
    
    Fix this by adding an 'in_tasklet' flag to dm_crypt_io struct and
    initialize it to false in crypt_io_init(). Set this flag to true in
    kcryptd_queue_crypt() before calling tasklet_schedule(). If set
    crypt_dec_pending() will punt io completion to a workqueue.
    
    This also nicely avoids the tasklet_trylock/unlock hack when tasklets
    aren't in use.
    
    Fixes: 8e14f610159d ("dm crypt: do not call bio_endio() from the dm-crypt tasklet")
    Cc: stable@vger.kernel.org
    Reported-by: Hou Tao <houtao1@huawei.com>
    Suggested-by: Ignat Korchagin <ignat@cloudflare.com>
    Reviewed-by: Ignat Korchagin <ignat@cloudflare.com>
    Signed-off-by: Mike Snitzer <snitzer@kernel.org>
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 17ddca293965c..5d772f322a245 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -67,7 +67,9 @@ struct dm_crypt_io {
 	struct crypt_config *cc;
 	struct bio *base_bio;
 	u8 *integrity_metadata;
-	bool integrity_metadata_from_pool;
+	bool integrity_metadata_from_pool:1;
+	bool in_tasklet:1;
+
 	struct work_struct work;
 	struct tasklet_struct tasklet;
 
@@ -1722,6 +1724,7 @@ static void crypt_io_init(struct dm_crypt_io *io, struct crypt_config *cc,
 	io->ctx.r.req = NULL;
 	io->integrity_metadata = NULL;
 	io->integrity_metadata_from_pool = false;
+	io->in_tasklet = false;
 	atomic_set(&io->io_pending, 0);
 }
 
@@ -1767,14 +1770,13 @@ static void crypt_dec_pending(struct dm_crypt_io *io)
 	 * our tasklet. In this case we need to delay bio_endio()
 	 * execution to after the tasklet is done and dequeued.
 	 */
-	if (tasklet_trylock(&io->tasklet)) {
-		tasklet_unlock(&io->tasklet);
-		bio_endio(base_bio);
+	if (io->in_tasklet) {
+		INIT_WORK(&io->work, kcryptd_io_bio_endio);
+		queue_work(cc->io_queue, &io->work);
 		return;
 	}
 
-	INIT_WORK(&io->work, kcryptd_io_bio_endio);
-	queue_work(cc->io_queue, &io->work);
+	bio_endio(base_bio);
 }
 
 /*
@@ -2228,6 +2230,7 @@ static void kcryptd_queue_crypt(struct dm_crypt_io *io)
 		 * it is being executed with irqs disabled.
 		 */
 		if (in_irq() || irqs_disabled()) {
+			io->in_tasklet = true;
 			tasklet_init(&io->tasklet, kcryptd_crypt_tasklet, (unsigned long)&io->work);
 			tasklet_schedule(&io->tasklet);
 			return;

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

