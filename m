Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F19D38DD2
	for <dm-devel@lists.linux.dev>; Wed, 31 Jan 2024 20:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706734654; cv=none; b=cGyfU3vCMN9lQmzrB8S+JTYox/Z707M4mNaO3b3JSCtRPI30XhB//0Z8+kn5wRjF1cgmr+clYm28fM+6SPIEhmcJmaFOMr9I9eo2MhU8B2rqL10KG3sTUNw6mDkQbQ0s5CieTeLdI17rhPoq9tBYrMX0b4iFqc+u4ALqkMXYCRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706734654; c=relaxed/simple;
	bh=bHSLlOv7tz2D+FTDdd+KoqCmmDd3SghVB2j9p+O8lqk=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=QiNI6kBdy2vH2CZoFrOgikkFm0U3ToipH7lzPRhoKiUz964ICg8BIXyvaE7N6sSitT9rGZNWdcVuhcBjaibjxni5VBdPPnzB7e4Tz/yv7Od6hjX70H1Qv/yavp8n5a82d2XcZBtFyL6N485JcIzXnBXE0DpokgK5b3JY+V4XwJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WWvXcRtd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WWvXcRtd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706734650;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=+FNDUwepPKNN49tQfd2gqfob3Qg4/8wYY7E6pc+D6jg=;
	b=WWvXcRtdZxmzwdKmVfoNLualD4CKn13ERcQp6ZeEJ5hZ7+hg+8UR5NvYUazcqaMuxNxl7z
	l8kXLWgn9Wj5BWTIvlWcGG5a7bibQtwRSi05MkG2ntAU51CXt4fBEe/hG9L5DNB1wnoLLl
	MXyN62m8FBFPVOjlym9HnhbzgPBAepI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-527-tQWo7KhyNyGIF5cY-pth2g-1; Wed, 31 Jan 2024 15:57:28 -0500
X-MC-Unique: tQWo7KhyNyGIF5cY-pth2g-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 443AA87A9E1;
	Wed, 31 Jan 2024 20:57:28 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 242AE492BE2;
	Wed, 31 Jan 2024 20:57:28 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 0CB3D30C14EB; Wed, 31 Jan 2024 20:57:28 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 080393F7DC;
	Wed, 31 Jan 2024 21:57:28 +0100 (CET)
Date: Wed, 31 Jan 2024 21:57:27 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Mike Snitzer <msnitzer@redhat.com>, Jonathan Brassow <jbrassow@redhat.com>, 
    Benjamin Marzinski <bmarzins@redhat.com>
cc: dm-devel@lists.linux.dev, Tejun Heo <tj@kernel.org>, 
    Ignat Korchagin <ignat@cloudflare.com>, 
    Damien Le Moal <damien.lemoal@wdc.com>, Bob Liu <bob.liu@oracle.com>
Subject: [PATCH] dm-crypt, dm-verity: disable tasklets
Message-ID: <fb74448e-1ae2-193b-8b11-dfb91974963@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Tasklets have an inherent problem with memory corruption. The function
tasklet_action_common calls tasklet_trylock, then it calls the tasklet
callback and then it calls tasklet_unlock. If the tasklet callback frees
the structure that contains the tasklet or if it calls some code that may
free it, tasklet_unlock will write into free memory.

The commits 8e14f610159d and d9a02e016aaf try to fix it for dm-crypt, but
it is not a sufficient fix and the data corruption can still happen [1].
There is no fix for dm-verity and dm-verity will write into free memory
with every tasklet-processed bio.

There will be atomic workqueues implemented in the kernel 6.9 [2]. They
will have better interface and they will not suffer from the memory
corruption problem.

But we need something that stops the memory corruption now and that can be
backported to the stable kernels. So, I'm proposing this commit that
disables tasklets in both dm-crypt and dm-verity. This commit doesn't
remove the tasklet support, because the tasklet code will be reused when
atomic workqueues will be implemented.

[1] https://lore.kernel.org/all/d390d7ee-f142-44d3-822a-87949e14608b@suse.de/T/
[2] https://lore.kernel.org/lkml/20240130091300.2968534-1-tj@kernel.org/

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Fixes: 39d42fa96ba1b ("dm crypt: add flags to optionally bypass kcryptd workqueues")
Fixes: 5721d4e5a9cdb ("dm verity: Add optional "try_verify_in_tasklet" feature")

---
 drivers/md/dm-crypt.c         |   38 ++------------------------------------
 drivers/md/dm-verity-target.c |   26 ++------------------------
 2 files changed, 4 insertions(+), 60 deletions(-)

Index: linux-2.6/drivers/md/dm-crypt.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-crypt.c	2024-01-31 18:58:46.000000000 +0100
+++ linux-2.6/drivers/md/dm-crypt.c	2024-01-31 19:00:05.000000000 +0100
@@ -73,10 +73,8 @@ struct dm_crypt_io {
 	struct bio *base_bio;
 	u8 *integrity_metadata;
 	bool integrity_metadata_from_pool:1;
-	bool in_tasklet:1;
 
 	struct work_struct work;
-	struct tasklet_struct tasklet;
 
 	struct convert_context ctx;
 
@@ -1762,7 +1760,6 @@ static void crypt_io_init(struct dm_cryp
 	io->ctx.r.req = NULL;
 	io->integrity_metadata = NULL;
 	io->integrity_metadata_from_pool = false;
-	io->in_tasklet = false;
 	atomic_set(&io->io_pending, 0);
 }
 
@@ -1771,13 +1768,6 @@ static void crypt_inc_pending(struct dm_
 	atomic_inc(&io->io_pending);
 }
 
-static void kcryptd_io_bio_endio(struct work_struct *work)
-{
-	struct dm_crypt_io *io = container_of(work, struct dm_crypt_io, work);
-
-	bio_endio(io->base_bio);
-}
-
 /*
  * One of the bios was finished. Check for completion of
  * the whole request and correctly clean up the buffer.
@@ -1801,20 +1791,6 @@ static void crypt_dec_pending(struct dm_
 
 	base_bio->bi_status = error;
 
-	/*
-	 * If we are running this function from our tasklet,
-	 * we can't call bio_endio() here, because it will call
-	 * clone_endio() from dm.c, which in turn will
-	 * free the current struct dm_crypt_io structure with
-	 * our tasklet. In this case we need to delay bio_endio()
-	 * execution to after the tasklet is done and dequeued.
-	 */
-	if (io->in_tasklet) {
-		INIT_WORK(&io->work, kcryptd_io_bio_endio);
-		queue_work(cc->io_queue, &io->work);
-		return;
-	}
-
 	bio_endio(base_bio);
 }
 
@@ -2246,11 +2222,6 @@ static void kcryptd_crypt(struct work_st
 		kcryptd_crypt_write_convert(io);
 }
 
-static void kcryptd_crypt_tasklet(unsigned long work)
-{
-	kcryptd_crypt((struct work_struct *)work);
-}
-
 static void kcryptd_queue_crypt(struct dm_crypt_io *io)
 {
 	struct crypt_config *cc = io->cc;
@@ -2262,15 +2233,10 @@ static void kcryptd_queue_crypt(struct d
 		 * irqs_disabled(): the kernel may run some IO completion from the idle thread, but
 		 * it is being executed with irqs disabled.
 		 */
-		if (in_hardirq() || irqs_disabled()) {
-			io->in_tasklet = true;
-			tasklet_init(&io->tasklet, kcryptd_crypt_tasklet, (unsigned long)&io->work);
-			tasklet_schedule(&io->tasklet);
+		if (!(in_hardirq() || irqs_disabled())) {
+			kcryptd_crypt(&io->work);
 			return;
 		}
-
-		kcryptd_crypt(&io->work);
-		return;
 	}
 
 	INIT_WORK(&io->work, kcryptd_crypt);
Index: linux-2.6/drivers/md/dm-verity-target.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-verity-target.c	2024-01-31 18:58:46.000000000 +0100
+++ linux-2.6/drivers/md/dm-verity-target.c	2024-01-31 19:03:14.000000000 +0100
@@ -645,23 +645,6 @@ static void verity_work(struct work_stru
 	verity_finish_io(io, errno_to_blk_status(verity_verify_io(io)));
 }
 
-static void verity_tasklet(unsigned long data)
-{
-	struct dm_verity_io *io = (struct dm_verity_io *)data;
-	int err;
-
-	io->in_tasklet = true;
-	err = verity_verify_io(io);
-	if (err == -EAGAIN || err == -ENOMEM) {
-		/* fallback to retrying with work-queue */
-		INIT_WORK(&io->work, verity_work);
-		queue_work(io->v->verify_wq, &io->work);
-		return;
-	}
-
-	verity_finish_io(io, errno_to_blk_status(err));
-}
-
 static void verity_end_io(struct bio *bio)
 {
 	struct dm_verity_io *io = bio->bi_private;
@@ -674,13 +657,8 @@ static void verity_end_io(struct bio *bi
 		return;
 	}
 
-	if (static_branch_unlikely(&use_tasklet_enabled) && io->v->use_tasklet) {
-		tasklet_init(&io->tasklet, verity_tasklet, (unsigned long)io);
-		tasklet_schedule(&io->tasklet);
-	} else {
-		INIT_WORK(&io->work, verity_work);
-		queue_work(io->v->verify_wq, &io->work);
-	}
+	INIT_WORK(&io->work, verity_work);
+	queue_work(io->v->verify_wq, &io->work);
 }
 
 /*

