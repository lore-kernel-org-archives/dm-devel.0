Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C17481A9B51
	for <dm-devel@lists.linux.dev>; Mon, 18 Nov 2024 15:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731942881; cv=none; b=luxB0bm9n4HKp2XVuzXV/SXNW2NoHmXJru3hGV3BBwt00CRH9WwOFk1oilYyNt7hzo2vW1qWAt84eFlXNmKJJnuyFuah0na33qILHIKPucJrPUMVYbV/aYP5PzQ3XNNUZxQFDfMF84Ax4EDElRKajv227JqfbsOHfzBuoMK6eyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731942881; c=relaxed/simple;
	bh=SWYrTYc/LzMRpl1d+8L/iStvpAma+CNdBr2SclHciYE=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=J/cE7kXl4++0ZcfNIO4V0GeWtswMmGQAz2TYBdj69EikEsY2s3sJrLz9ItijBpBU6cY7ygPTJh/n+iM2eitcQeOajiWCRLVhJaqw/wm5tDcRia/k3ewW48ffF5zPisz1cdKgOrB31wviCDfW9kVzj2GkWEBR2g6sxt62MDPFv+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a6qEcEX4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a6qEcEX4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731942878;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=bvRAdedCCPlD0+FG0XXaNvMVT4YJQ0+29UZKZvwctxE=;
	b=a6qEcEX4mep0UfPI6y/FP3uGXQ9eusgKGEngLPT1FgQq859U/bqeD82sEJPP4E8Cy5xWSW
	m67GZi/gmvZWXy9OhdMRgRSt+moR9lL4DCKxrHYO9APnon497FB3MOj6ryE0HDQscj+Dqt
	7n0Wj+KsEZBRRO8COwYMJRLHMfYu1R0=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-587-GO9GvCrhNneRLijzdh4c4A-1; Mon,
 18 Nov 2024 10:14:35 -0500
X-MC-Unique: GO9GvCrhNneRLijzdh4c4A-1
X-Mimecast-MFC-AGG-ID: GO9GvCrhNneRLijzdh4c4A
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9D6A418E6516;
	Mon, 18 Nov 2024 15:14:32 +0000 (UTC)
Received: from [10.45.225.96] (unknown [10.45.225.96])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 16D591955E9D;
	Mon, 18 Nov 2024 15:14:29 +0000 (UTC)
Date: Mon, 18 Nov 2024 16:14:27 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>
cc: dm-devel@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH] dm-bufio: use kmalloc to allocate power-of-two sized
 buffers
Message-ID: <7cd801fa-c216-d18b-99f7-57f545434444@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: dg7gi2-IdwL4N-N9UESGkzIrxNfAvORyS6zb4Vu6cfY_1731942874
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Vlastimil Babka said that kmalloc will return a power-of-two-aligned
buffer if it was called with a power-of-two size. So, we can use kmalloc
instead of our own slab cache in dm-bufio. Note that the code for the
slab cache was not removed because dm-bufio supports non-power-of-two
buffer sizes.

Link: https://lore.kernel.org/linux-mm/e7fca292-7c79-4f97-a90c-d68178d8ca59@suse.cz/ [1]

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-bufio.c |   25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

Index: linux-2.6/drivers/md/dm-bufio.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-bufio.c	2024-11-13 15:24:33.000000000 +0100
+++ linux-2.6/drivers/md/dm-bufio.c	2024-11-13 15:46:58.000000000 +0100
@@ -318,9 +318,10 @@ static struct lru_entry *lru_evict(struc
  */
 enum data_mode {
 	DATA_MODE_SLAB = 0,
-	DATA_MODE_GET_FREE_PAGES = 1,
-	DATA_MODE_VMALLOC = 2,
-	DATA_MODE_LIMIT = 3
+	DATA_MODE_KMALLOC = 1,
+	DATA_MODE_GET_FREE_PAGES = 2,
+	DATA_MODE_VMALLOC = 3,
+	DATA_MODE_LIMIT = 4
 };
 
 struct dm_buffer {
@@ -1062,6 +1063,7 @@ static unsigned long dm_bufio_retain_byt
 
 static unsigned long dm_bufio_peak_allocated;
 static unsigned long dm_bufio_allocated_kmem_cache;
+static unsigned long dm_bufio_allocated_kmalloc;
 static unsigned long dm_bufio_allocated_get_free_pages;
 static unsigned long dm_bufio_allocated_vmalloc;
 static unsigned long dm_bufio_current_allocated;
@@ -1104,6 +1106,7 @@ static void adjust_total_allocated(struc
 
 	static unsigned long * const class_ptr[DATA_MODE_LIMIT] = {
 		&dm_bufio_allocated_kmem_cache,
+		&dm_bufio_allocated_kmalloc,
 		&dm_bufio_allocated_get_free_pages,
 		&dm_bufio_allocated_vmalloc,
 	};
@@ -1181,6 +1184,11 @@ static void *alloc_buffer_data(struct dm
 		return kmem_cache_alloc(c->slab_cache, gfp_mask);
 	}
 
+	if (unlikely(c->block_size < PAGE_SIZE)) {
+		*data_mode = DATA_MODE_KMALLOC;
+		return kmalloc(c->block_size, gfp_mask | __GFP_RECLAIMABLE);
+	}
+
 	if (c->block_size <= KMALLOC_MAX_SIZE &&
 	    gfp_mask & __GFP_NORETRY) {
 		*data_mode = DATA_MODE_GET_FREE_PAGES;
@@ -1204,6 +1212,10 @@ static void free_buffer_data(struct dm_b
 		kmem_cache_free(c->slab_cache, data);
 		break;
 
+	case DATA_MODE_KMALLOC:
+		kfree(data);
+		break;
+
 	case DATA_MODE_GET_FREE_PAGES:
 		free_pages((unsigned long)data,
 			   c->sectors_per_block_bits - (PAGE_SHIFT - SECTOR_SHIFT));
@@ -2519,8 +2531,7 @@ struct dm_bufio_client *dm_bufio_client_
 		goto bad_dm_io;
 	}
 
-	if (block_size <= KMALLOC_MAX_SIZE &&
-	    (block_size < PAGE_SIZE || !is_power_of_2(block_size))) {
+	if (block_size <= KMALLOC_MAX_SIZE && !is_power_of_2(block_size)) {
 		unsigned int align = min(1U << __ffs(block_size), (unsigned int)PAGE_SIZE);
 
 		snprintf(slab_name, sizeof(slab_name), "dm_bufio_cache-%u-%u",
@@ -2902,6 +2913,7 @@ static int __init dm_bufio_init(void)
 	__u64 mem;
 
 	dm_bufio_allocated_kmem_cache = 0;
+	dm_bufio_allocated_kmalloc = 0;
 	dm_bufio_allocated_get_free_pages = 0;
 	dm_bufio_allocated_vmalloc = 0;
 	dm_bufio_current_allocated = 0;
@@ -2990,6 +3002,9 @@ MODULE_PARM_DESC(peak_allocated_bytes, "
 module_param_named(allocated_kmem_cache_bytes, dm_bufio_allocated_kmem_cache, ulong, 0444);
 MODULE_PARM_DESC(allocated_kmem_cache_bytes, "Memory allocated with kmem_cache_alloc");
 
+module_param_named(allocated_kmalloc_bytes, dm_bufio_allocated_kmalloc, ulong, 0444);
+MODULE_PARM_DESC(allocated_kmalloc_bytes, "Memory allocated with kmalloc_alloc");
+
 module_param_named(allocated_get_free_pages_bytes, dm_bufio_allocated_get_free_pages, ulong, 0444);
 MODULE_PARM_DESC(allocated_get_free_pages_bytes, "Memory allocated with get_free_pages");
 

