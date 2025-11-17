Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E318C2FC02F
	for <dm-devel@lists.linux.dev>; Mon, 17 Nov 2025 20:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763412249; cv=none; b=hNMKww0ZOpqfC2Yl47JAj7Ad6h5xDOzuyfbpVC5e9RlMcWi54SfvagBoFJzaXACyVejFIiX7TOEJT01jAdtAvuABEqjKeNidEPsNapN48LUlITPXutsYfcSc4rRzhXYfWLzn1jhA/mrhCxozWzYvCDqzLxxUHkQV0bOZSdXSjU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763412249; c=relaxed/simple;
	bh=asvi6QEJF8vqsiL1uX6ier4sOgJdLOP9mllDwQh2IXQ=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=cosR//xFHO78caWkKvQfWiS5aVd969qjb35Xt/rkrEV8wq9riiiE1g0hT0jem14pJ/Mzbd4LMfjTPtWbCzmcw+Jh+04TulJ/uO4sG898bSExgsy1i44k227B2liDZPjnrAorMcRxg5Fp0B1iOi7dM62rNycF1YjR8vR/m1FYhLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dvmt5Jmy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dvmt5Jmy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763412244;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=lTyRsVox4bqHJvkYmI3+aUXvnUa6MAqgcnGJU1jstXQ=;
	b=dvmt5JmyuXbZ3nShqzMZIOmHIt2m23p0NfbvS8VPqNOJJEc6hn3iwyawMlll7XR/hU0icT
	jqALwB/XnCe9TaQruWon/5WHk1LTrTzCD6xOFpHP8GC1s+FTkjRe1F/ywWl9GRlwkbdVlH
	kmn/4b/ddOsGoa0L7gfXd3DemoB6HpI=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-247-_8_-p3xzOuyOWtTrwiW_qQ-1; Mon,
 17 Nov 2025 15:44:01 -0500
X-MC-Unique: _8_-p3xzOuyOWtTrwiW_qQ-1
X-Mimecast-MFC-AGG-ID: _8_-p3xzOuyOWtTrwiW_qQ_1763412240
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4D1F9180130B;
	Mon, 17 Nov 2025 20:44:00 +0000 (UTC)
Received: from [10.44.32.60] (unknown [10.44.32.60])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 48F041800346;
	Mon, 17 Nov 2025 20:43:58 +0000 (UTC)
Date: Mon, 17 Nov 2025 21:43:54 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Sami Tolvanen <samitolvanen@google.com>, Alasdair Kergon <agk@redhat.com>, 
    Mike Snitzer <snitzer@kernel.org>
cc: dm-devel@lists.linux.dev, Ondrej Kozina <okozina@redhat.com>, 
    Milan Broz <gmazyland@gmail.com>
Subject: [PATCH] dm-verity: remove useless mempool
Message-ID: <b8066f81-09eb-d3f5-59ab-1929c2bd7568@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -BjecFe721iu-04h3EZjidRtyOYiXnxnu_tqa513rKg_1763412240
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

v->fec->extra_pool has zero reserved entries, so we can remove it and use
the kernel cache directly.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-verity-fec.c |   12 +++---------
 drivers/md/dm-verity-fec.h |    1 -
 2 files changed, 3 insertions(+), 10 deletions(-)

Index: linux-2.6/drivers/md/dm-verity-fec.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-verity-fec.c	2025-11-15 16:08:10.000000000 +0100
+++ linux-2.6/drivers/md/dm-verity-fec.c	2025-11-15 17:24:59.000000000 +0100
@@ -328,7 +328,7 @@ static int fec_alloc_bufs(struct dm_veri
 		if (fio->bufs[n])
 			continue;
 
-		fio->bufs[n] = mempool_alloc(&v->fec->extra_pool, GFP_NOWAIT);
+		fio->bufs[n] = kmem_cache_alloc(v->fec->cache, GFP_NOWAIT);
 		/* we can manage with even one buffer if necessary */
 		if (unlikely(!fio->bufs[n]))
 			break;
@@ -477,7 +477,8 @@ void verity_fec_finish_io(struct dm_veri
 		mempool_free(fio->bufs[n], &f->prealloc_pool);
 
 	fec_for_each_extra_buffer(fio, n)
-		mempool_free(fio->bufs[n], &f->extra_pool);
+		if (fio->bufs[n])
+			kmem_cache_free(f->cache, fio->bufs[n]);
 
 	mempool_free(fio->output, &f->output_pool);
 }
@@ -529,7 +530,6 @@ void verity_fec_dtr(struct dm_verity *v)
 
 	mempool_exit(&f->rs_pool);
 	mempool_exit(&f->prealloc_pool);
-	mempool_exit(&f->extra_pool);
 	mempool_exit(&f->output_pool);
 	kmem_cache_destroy(f->cache);
 
@@ -782,12 +782,6 @@ int verity_fec_ctr(struct dm_verity *v)
 		return ret;
 	}
 
-	ret = mempool_init_slab_pool(&f->extra_pool, 0, f->cache);
-	if (ret) {
-		ti->error = "Cannot allocate FEC buffer extra pool";
-		return ret;
-	}
-
 	/* Preallocate an output buffer for each thread */
 	ret = mempool_init_kmalloc_pool(&f->output_pool, num_online_cpus(),
 					1 << v->data_dev_block_bits);
Index: linux-2.6/drivers/md/dm-verity-fec.h
===================================================================
--- linux-2.6.orig/drivers/md/dm-verity-fec.h	2025-11-15 16:08:10.000000000 +0100
+++ linux-2.6/drivers/md/dm-verity-fec.h	2025-11-15 16:08:10.000000000 +0100
@@ -42,7 +42,6 @@ struct dm_verity_fec {
 	unsigned char rsn;	/* N of RS(M, N) */
 	mempool_t rs_pool;	/* mempool for fio->rs */
 	mempool_t prealloc_pool;	/* mempool for preallocated buffers */
-	mempool_t extra_pool;	/* mempool for extra buffers */
 	mempool_t output_pool;	/* mempool for output */
 	struct kmem_cache *cache;	/* cache for buffers */
 };

