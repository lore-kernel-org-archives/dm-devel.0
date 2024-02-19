Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 239C2524B1
	for <dm-devel@lists.linux.dev>; Mon, 19 Feb 2024 20:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708374532; cv=none; b=tx6uZ71UHoPOBdg4m2h1B+wXXxjNa6QPXtxVtKENbo6bXOH8zPUIVRHTXtRUl/UcYX08Dn6tOoq1gwIfkD4/LdwMsK4056NthBhdgtryb83tkzs7ZAZiw8f0GlI3kPRbPoYcA8yGjo6reIyELvavRZbKNWm22+TDSB0Q2p7vak8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708374532; c=relaxed/simple;
	bh=wWjCnLolROVbQdhkDuavG2U/rqNADSbZT0/USP+jD/0=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=o37ugcwRs8itjRLIArTh40htPul5zr0eahXOGdHlhPoAyJmTeDawlFld/YI5l2MI43wek9JDfBonh4+IV/zvCcslqWefLHlLCUwgXrv0NSUZWAmfYBAsIW4U8pvrVYx+5giEmyU6v3a94DJJMzn0zq6XsJN5Jiq+43On3QaRbiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g3jKWAsG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g3jKWAsG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708374530;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=d92HVd2Av4o1o1NscjhvcRlI0+WRtb6I/jsVspmHbZA=;
	b=g3jKWAsGGEH/IawhRLMApVmSdRo4EeYLzVfOvggQYyHfXQr6LEjWcHbC2ijkNVBGrRp+xq
	YCzqPL0ZsYHutjdF87qCVAGQKNxW+oyFlBB3xvM7IUy/HM08RfuUhzoxrBYRhUmKO5SLrH
	+z2xW7z99BS1CAu0AN/YwtQlwEQ4vyI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-607-7EMsrZG0PzKDykRaTZLmcA-1; Mon, 19 Feb 2024 15:28:48 -0500
X-MC-Unique: 7EMsrZG0PzKDykRaTZLmcA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1AF8385A589
	for <dm-devel@lists.linux.dev>; Mon, 19 Feb 2024 20:28:48 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 156002022AAC;
	Mon, 19 Feb 2024 20:28:48 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 0D6E430C1B8F; Mon, 19 Feb 2024 20:28:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 0C3203FB4E;
	Mon, 19 Feb 2024 21:28:48 +0100 (CET)
Date: Mon, 19 Feb 2024 21:28:48 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Mike Snitzer <msnitzer@redhat.com>
cc: dm-devel@lists.linux.dev
Subject: [PATCH 3/5] dm-verity: revert e9307e3deb52 ("dm verity: only copy
 bvec_iter in verity_verify_io if in_tasklet")
In-Reply-To: <ab6d4358-3430-e2c9-bb93-c1e8cf72395@redhat.com>
Message-ID: <657d9cad-c5b7-2cef-bf5a-9fe3df46296@redhat.com>
References: <ab6d4358-3430-e2c9-bb93-c1e8cf72395@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

The patch e9307e3deb52 was supposed to be an optimization, but it actually
increases the size of the function verity_verify_io (by 112 bytes), so
let's revert it.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-verity-target.c |   21 +++++----------------
 1 file changed, 5 insertions(+), 16 deletions(-)

Index: linux-2.6/drivers/md/dm-verity-target.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-verity-target.c	2024-02-06 14:46:59.000000000 +0100
+++ linux-2.6/drivers/md/dm-verity-target.c	2024-02-06 14:50:50.000000000 +0100
@@ -565,22 +565,11 @@ static int verity_verify_io(struct dm_ve
 	bool is_zero;
 	struct dm_verity *v = io->v;
 	struct bvec_iter start;
-	struct bvec_iter iter_copy;
-	struct bvec_iter *iter;
+	struct bvec_iter iter_copy = io->iter;
 	struct crypto_wait wait;
 	struct bio *bio = dm_bio_from_per_bio_data(io, v->ti->per_io_data_size);
 	unsigned int b;
 
-	if (static_branch_unlikely(&use_tasklet_enabled) && io->in_tasklet) {
-		/*
-		 * Copy the iterator in case we need to restart
-		 * verification in a work-queue.
-		 */
-		iter_copy = io->iter;
-		iter = &iter_copy;
-	} else
-		iter = &io->iter;
-
 	for (b = 0; b < io->n_blocks; b++) {
 		int r;
 		sector_t cur_block = io->block + b;
@@ -588,7 +577,7 @@ static int verity_verify_io(struct dm_ve
 
 		if (v->validated_blocks && bio->bi_status == BLK_STS_OK &&
 		    likely(test_bit(cur_block, v->validated_blocks))) {
-			verity_bv_skip_block(v, io, iter);
+			verity_bv_skip_block(v, io, &iter_copy);
 			continue;
 		}
 
@@ -603,7 +592,7 @@ static int verity_verify_io(struct dm_ve
 			 * If we expect a zero block, don't validate, just
 			 * return zeros.
 			 */
-			r = verity_for_bv_block(v, io, iter,
+			r = verity_for_bv_block(v, io, &iter_copy,
 						verity_bv_zero);
 			if (unlikely(r < 0))
 				return r;
@@ -615,8 +604,8 @@ static int verity_verify_io(struct dm_ve
 		if (unlikely(r < 0))
 			return r;
 
-		start = *iter;
-		r = verity_for_io_block(v, io, iter, &wait);
+		start = iter_copy;
+		r = verity_for_io_block(v, io, &iter_copy, &wait);
 		if (unlikely(r < 0))
 			return r;
 

