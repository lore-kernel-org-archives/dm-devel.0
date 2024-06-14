Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5930F137764
	for <dm-devel@lists.linux.dev>; Fri, 14 Jun 2024 18:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718389463; cv=none; b=tXpuH8wPv5LcOTfkDE6c6a94+7/ULBUOprhbWyHRn3BECwRrgw+svccZ+k/DA9GqC9XrnJCKoS/hula82zBLUv1Kg1Uh5NH/yZWXn1N9z9VN/RbhzNUmrDNtcdXiQXwxhOuXNuAHX1udtudFnp9wuytvcNxCNr0ZcnJ6OgErhdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718389463; c=relaxed/simple;
	bh=eb8rq39XBo5WV5JSo7sMfdOqz5PpMQdZY8ny+Z1lnoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LFQ2ISzK3iUdCUCRpU7pafaIgSpsnlCefETJPsQP5bcGIScCOJOFJSKV0MWex1AO/qx5+17/n3fsxy9RjAjq4DVmKuBQMuDRHiTHj6KLojD6+cxxaRf+/CtqanrPUb/GdlCDx8W+cgoBc8O+XVliXY/0Ua2BQSPb3P9RtsdUms0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eOi4knHu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eOi4knHu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718389461;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wv9Re76v8f3o9GsziQl2zMysv+AIlkj3wtFLZpGru0Y=;
	b=eOi4knHuNw4brIr1BEBeLGeKbUvUu1CdnIr4ItT/tfQDqUQ2kmh9LHJSjlivce+wjL1QVa
	1+SJlqXNdEPrw7PRszpWmCx8cXTWFtp/GEuk5Mo5NMNz1z0i+nWObBbZsHJahLmx+n82lv
	WXEHWHJ9vklSmmdh2Ld+60ellnB/XfI=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-467-nnjIlVkyPwqu5Ni363bqLQ-1; Fri,
 14 Jun 2024 14:24:16 -0400
X-MC-Unique: nnjIlVkyPwqu5Ni363bqLQ-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 54036195609F;
	Fri, 14 Jun 2024 18:24:15 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B040519560AA;
	Fri, 14 Jun 2024 18:24:14 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 45EIODnu952190
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 14 Jun 2024 14:24:13 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 45EIODvr952189;
	Fri, 14 Jun 2024 14:24:13 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@kernel.org>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 3/3] dm io: remove code duplication between sync_io and aysnc_io
Date: Fri, 14 Jun 2024 14:24:12 -0400
Message-ID: <20240614182412.952166-4-bmarzins@redhat.com>
In-Reply-To: <20240614182412.952166-1-bmarzins@redhat.com>
References: <20240614182412.952166-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

The only difference between the code to setup and dispatch the io in
sync_io() and async_io() is the sync argument to dispatch_io(), which
is used to update the opf argument.

Update the opf argument direcly in sync_io(), and remove the sync
argument from dispatch_io(). Then, make sync_io() call async_io()
instead of duplicting all of its code.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 drivers/md/dm-io.c | 59 ++++++++++++++++++----------------------------
 1 file changed, 23 insertions(+), 36 deletions(-)

diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index 329a85a12061..d7a8e2f40db3 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -384,16 +384,13 @@ static void do_region(const blk_opf_t opf, unsigned int region,
 
 static void dispatch_io(blk_opf_t opf, unsigned int num_regions,
 			struct dm_io_region *where, struct dpages *dp,
-			struct io *io, int sync, unsigned short ioprio)
+			struct io *io, unsigned short ioprio)
 {
 	int i;
 	struct dpages old_pages = *dp;
 
 	BUG_ON(num_regions > DM_IO_MAX_REGIONS);
 
-	if (sync)
-		opf |= REQ_SYNC;
-
 	/*
 	 * For multiple regions we need to be careful to rewind
 	 * the dp object for each call to do_region.
@@ -411,6 +408,26 @@ static void dispatch_io(blk_opf_t opf, unsigned int num_regions,
 	dec_count(io, 0, 0);
 }
 
+static void async_io(struct dm_io_client *client, unsigned int num_regions,
+		     struct dm_io_region *where, blk_opf_t opf,
+		     struct dpages *dp, io_notify_fn fn, void *context,
+		     unsigned short ioprio)
+{
+	struct io *io;
+
+	io = mempool_alloc(&client->pool, GFP_NOIO);
+	io->error_bits = 0;
+	atomic_set(&io->count, 1); /* see dispatch_io() */
+	io->client = client;
+	io->callback = fn;
+	io->context = context;
+
+	io->vma_invalidate_address = dp->vma_invalidate_address;
+	io->vma_invalidate_size = dp->vma_invalidate_size;
+
+	dispatch_io(opf, num_regions, where, dp, io, ioprio);
+}
+
 struct sync_io {
 	unsigned long error_bits;
 	struct completion wait;
@@ -428,22 +445,12 @@ static int sync_io(struct dm_io_client *client, unsigned int num_regions,
 		   struct dm_io_region *where, blk_opf_t opf, struct dpages *dp,
 		   unsigned long *error_bits, unsigned short ioprio)
 {
-	struct io *io;
 	struct sync_io sio;
 
 	init_completion(&sio.wait);
 
-	io = mempool_alloc(&client->pool, GFP_NOIO);
-	io->error_bits = 0;
-	atomic_set(&io->count, 1); /* see dispatch_io() */
-	io->client = client;
-	io->callback = sync_io_complete;
-	io->context = &sio;
-
-	io->vma_invalidate_address = dp->vma_invalidate_address;
-	io->vma_invalidate_size = dp->vma_invalidate_size;
-
-	dispatch_io(opf, num_regions, where, dp, io, 1, ioprio);
+	async_io(client, num_regions, where, opf | REQ_SYNC, dp,
+		 sync_io_complete, &sio, ioprio);
 
 	wait_for_completion_io(&sio.wait);
 
@@ -453,26 +460,6 @@ static int sync_io(struct dm_io_client *client, unsigned int num_regions,
 	return sio.error_bits ? -EIO : 0;
 }
 
-static void async_io(struct dm_io_client *client, unsigned int num_regions,
-		     struct dm_io_region *where, blk_opf_t opf,
-		     struct dpages *dp, io_notify_fn fn, void *context,
-		     unsigned short ioprio)
-{
-	struct io *io;
-
-	io = mempool_alloc(&client->pool, GFP_NOIO);
-	io->error_bits = 0;
-	atomic_set(&io->count, 1); /* see dispatch_io() */
-	io->client = client;
-	io->callback = fn;
-	io->context = context;
-
-	io->vma_invalidate_address = dp->vma_invalidate_address;
-	io->vma_invalidate_size = dp->vma_invalidate_size;
-
-	dispatch_io(opf, num_regions, where, dp, io, 0, ioprio);
-}
-
 static int dp_init(struct dm_io_request *io_req, struct dpages *dp,
 		   unsigned long size)
 {
-- 
2.45.0

