Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E6401C01
	for <dm-devel@lists.linux.dev>; Mon, 11 Nov 2024 15:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731340112; cv=none; b=JGsp7RhWDWF2xXzESpn4lCoMg4Bu+7vToclFCC8lCAUQOJ1+wVsv6C3s7TqmAOP8JQWvuq3kpvhdz01R9tfiGQGXrjZQ+ecIXVs35a84Z0whF9NIgj4stn6QkI5mNkePfleGj/FV8ktTqmgQCbHOQW0RRqMqZFWf8HCvwcvbZ2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731340112; c=relaxed/simple;
	bh=Iiehn44JfRaEuiycDnonOQYVM7xiw+ZpsdbM+Ho1Slc=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=RkDcMqUzPUssvJC7T8xdV8ezKFa4nXIePllJ7TkWtutXFyf4+w7kyEh+oSzGz1DlA7YhPZRhoVVBa/245TTh2dA3XtbsLdpiK/f4MBzbnQ27PmsuMlA1ubaNwkvokumOt39g3Du0R0ArleuBPGEDsl1TqcaWqkHceMg9IRQIF50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Exy99eMR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Exy99eMR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731340110;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=azJg5Nc7iO7VWNHfc5O+wPEi/mJqb26B/eOtieXISw8=;
	b=Exy99eMRDtjz0gReeEOVlcP6YfOVlJBrOhw8jLN5qmKEJrPq2A5/9iW46t6yQJoNjqqWps
	24GMKJWn5nx+MilKPcvsrXRHrPKbqXb4sSC4wVEgLix5ZQw0jg/tHKOa0AXvYjDbzerhBB
	Z+NxKdw+DyQm8lbs6dyx5HFlsefnTdI=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-47-rgTxubdvNbalKSgvbx3TNg-1; Mon,
 11 Nov 2024 10:48:25 -0500
X-MC-Unique: rgTxubdvNbalKSgvbx3TNg-1
X-Mimecast-MFC-AGG-ID: rgTxubdvNbalKSgvbx3TNg
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E779319560AB;
	Mon, 11 Nov 2024 15:48:23 +0000 (UTC)
Received: from [10.45.225.96] (unknown [10.45.225.96])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A72791956054;
	Mon, 11 Nov 2024 15:48:22 +0000 (UTC)
Date: Mon, 11 Nov 2024 16:48:18 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>
cc: dm-devel@lists.linux.dev
Subject: [PATCH] dm-bufio: fix warnings about duplicate slab caches
Message-ID: <e356abe0-308e-fa18-1925-ce80de92a10c@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 0szMrZsAYqWl6qPQc1oxiduvxTnaLPkUhcAX-bvpb5Y_1731340104
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

The commit 4c39529663b9 adds a warning about duplicate cache names if
CONFIG_DEBUG_VM is selected. These warnings are triggered by the dm-bufio
code. The dm-bufio code allocates a slab cache with each client. It is
not possible to preallocate the caches in the module init function
because the size of auxiliary per-buffer data is not known at this point.

So, this commit changes dm-bufio so that it appends a unique atomic value
to the cache name, to avoid the warnings.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: 4c39529663b9 ("slab: Warn on duplicate cache names when DEBUG_VM=y")

---
 drivers/md/dm-bufio.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

Index: linux-2.6/drivers/md/dm-bufio.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-bufio.c	2024-10-16 16:41:33.000000000 +0200
+++ linux-2.6/drivers/md/dm-bufio.c	2024-11-07 12:56:24.000000000 +0100
@@ -2471,7 +2471,8 @@ struct dm_bufio_client *dm_bufio_client_
 	int r;
 	unsigned int num_locks;
 	struct dm_bufio_client *c;
-	char slab_name[27];
+	char slab_name[64];
+	static atomic_t seqno = ATOMIC_INIT(0);
 
 	if (!block_size || block_size & ((1 << SECTOR_SHIFT) - 1)) {
 		DMERR("%s: block size not specified or is not multiple of 512b", __func__);
@@ -2522,7 +2523,8 @@ struct dm_bufio_client *dm_bufio_client_
 	    (block_size < PAGE_SIZE || !is_power_of_2(block_size))) {
 		unsigned int align = min(1U << __ffs(block_size), (unsigned int)PAGE_SIZE);
 
-		snprintf(slab_name, sizeof(slab_name), "dm_bufio_cache-%u", block_size);
+		snprintf(slab_name, sizeof(slab_name), "dm_bufio_cache-%u-%u",
+					block_size, atomic_inc_return(&seqno));
 		c->slab_cache = kmem_cache_create(slab_name, block_size, align,
 						  SLAB_RECLAIM_ACCOUNT, NULL);
 		if (!c->slab_cache) {
@@ -2531,9 +2533,11 @@ struct dm_bufio_client *dm_bufio_client_
 		}
 	}
 	if (aux_size)
-		snprintf(slab_name, sizeof(slab_name), "dm_bufio_buffer-%u", aux_size);
+		snprintf(slab_name, sizeof(slab_name), "dm_bufio_buffer-%u-%u",
+					aux_size, atomic_inc_return(&seqno));
 	else
-		snprintf(slab_name, sizeof(slab_name), "dm_bufio_buffer");
+		snprintf(slab_name, sizeof(slab_name), "dm_bufio_buffer-%u",
+					atomic_inc_return(&seqno));
 	c->slab_buffer = kmem_cache_create(slab_name, sizeof(struct dm_buffer) + aux_size,
 					   0, SLAB_RECLAIM_ACCOUNT, NULL);
 	if (!c->slab_buffer) {

