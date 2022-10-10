Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD0F2C433FE
	for <dm-devel@archiver.kernel.org>; Mon, 10 Oct 2022 12:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1665405380;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=/NXZ1pc3LxIPPJvYyw1xCZkDABNaoXQp0BePED/lKM0=;
	b=YwFufx6JGh+VOKbgJGxTUWck64bxOzpx7eQENJ4H0O8XUkrp5/Fnz11rTjEw4ZztYw4F3H
	XWrfPr79eiPbGAJQB99LNx8h6uK03KEwi2CNjkG4VXJ7E5d+PiyMGZF6S3HJhrql+LQ9Da
	opcb5gB8DMn5b2QSlLbczcqqPRqWKiU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-526-bZAEq-1wOrqkwqrhRIW3VQ-1; Mon, 10 Oct 2022 08:36:17 -0400
X-MC-Unique: bZAEq-1wOrqkwqrhRIW3VQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 27D873C10EC5;
	Mon, 10 Oct 2022 12:36:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 16CBC145BF00;
	Mon, 10 Oct 2022 12:36:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CD64B19465A0;
	Mon, 10 Oct 2022 12:36:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9A0D11946597
 for <dm-devel@listman.corp.redhat.com>; Mon, 10 Oct 2022 12:36:14 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7F077C2129; Mon, 10 Oct 2022 12:36:14 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6CC55A9F42;
 Mon, 10 Oct 2022 12:36:14 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 29ACaElD026703; Mon, 10 Oct 2022 08:36:14 -0400
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 29ACaEit026699; Mon, 10 Oct 2022 08:36:14 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Mon, 10 Oct 2022 08:36:14 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Joe Thornber <thornber@redhat.com>, Mike Snitzer <msnitzer@redhat.com>,
 Heinz Mauelshagen <heinzm@redhat.com>
In-Reply-To: <alpine.LRH.2.02.2210100811400.25650@file01.intranet.prod.int.rdu2.redhat.com>
Message-ID: <alpine.LRH.2.02.2210100835450.25650@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2210100811400.25650@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: [dm-devel] [PATCH 2/4] dm-bufio: change mutex to rw_semaphore
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Change mutex to rw_semaphore, so that there could be multiple processes
inside dm_bufio_lock_read/dm_bufio_unlock_read concurrently.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-bufio.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

Index: linux-2.6/drivers/md/dm-bufio.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-bufio.c	2022-10-10 11:13:57.000000000 +0200
+++ linux-2.6/drivers/md/dm-bufio.c	2022-10-10 11:13:57.000000000 +0200
@@ -81,7 +81,7 @@
  *	context.
  */
 struct dm_bufio_client {
-	struct mutex lock;
+	struct rw_semaphore lock;
 	spinlock_t spinlock;
 	bool no_sleep;
 
@@ -174,7 +174,7 @@ static void dm_bufio_lock(struct dm_bufi
 	if (static_branch_unlikely(&no_sleep_enabled) && c->no_sleep)
 		spin_lock_bh(&c->spinlock);
 	else
-		mutex_lock_nested(&c->lock, dm_bufio_in_request());
+		down_write_nested(&c->lock, dm_bufio_in_request());
 }
 
 static int dm_bufio_trylock(struct dm_bufio_client *c)
@@ -182,7 +182,7 @@ static int dm_bufio_trylock(struct dm_bu
 	if (static_branch_unlikely(&no_sleep_enabled) && c->no_sleep)
 		return spin_trylock_bh(&c->spinlock);
 	else
-		return mutex_trylock(&c->lock);
+		return down_write_trylock(&c->lock);
 }
 
 static void dm_bufio_unlock(struct dm_bufio_client *c)
@@ -190,18 +190,18 @@ static void dm_bufio_unlock(struct dm_bu
 	if (static_branch_unlikely(&no_sleep_enabled) && c->no_sleep)
 		spin_unlock_bh(&c->spinlock);
 	else
-		mutex_unlock(&c->lock);
+		up_write(&c->lock);
 }
 
 void dm_bufio_lock_read(struct dm_bufio_client *c)
 {
-	mutex_lock(&c->lock);
+	down_read(&c->lock);
 }
 EXPORT_SYMBOL_GPL(dm_bufio_lock_read);
 
 void dm_bufio_unlock_read(struct dm_bufio_client *c)
 {
-	mutex_unlock(&c->lock);
+	up_read(&c->lock);
 }
 EXPORT_SYMBOL_GPL(dm_bufio_unlock_read);
 
@@ -1808,7 +1808,7 @@ struct dm_bufio_client *dm_bufio_client_
 		c->n_buffers[i] = 0;
 	}
 
-	mutex_init(&c->lock);
+	init_rwsem(&c->lock);
 	spin_lock_init(&c->spinlock);
 	INIT_LIST_HEAD(&c->reserved_buffers);
 	c->need_reserved_buffers = reserved_buffers;
@@ -1887,7 +1887,6 @@ bad:
 	kmem_cache_destroy(c->slab_buffer);
 	dm_io_client_destroy(c->dm_io);
 bad_dm_io:
-	mutex_destroy(&c->lock);
 	kfree(c);
 bad_client:
 	return ERR_PTR(r);
@@ -1935,7 +1934,6 @@ void dm_bufio_client_destroy(struct dm_b
 	kmem_cache_destroy(c->slab_cache);
 	kmem_cache_destroy(c->slab_buffer);
 	dm_io_client_destroy(c->dm_io);
-	mutex_destroy(&c->lock);
 	if (c->no_sleep)
 		static_branch_dec(&no_sleep_enabled);
 	kfree(c);

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

