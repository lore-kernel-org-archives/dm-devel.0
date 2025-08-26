Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF56335AAD6
	for <dm-devel@lists.linux.dev>; Tue, 26 Aug 2025 14:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219200; cv=none; b=O4s83YfbPox8M7IsX3Z05N68z3Gid6Rq+/Lgrf/wSSyOSbCh79eN+79V4x9MvVq16BrkeqNrwuysmNBlBCYTlVwTgztaiGFY5piB/5gQKRYw3YP4+NJHajnInOCTDgbyMCJ7o+rxfZSjGoxu2HE/6GuF3qUQD47i0KGWw+aSvMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219200; c=relaxed/simple;
	bh=PWzBuhRiLykW9Jk2IT8JkXB/nA9MhhV+YpfUaL0mF4Y=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=NNpPGNOY8PD4s9udmcO1/byTuqIoOm17wNe2q57uNJsdGENpb7pqCUf3ecpkiDbcH+ZCI0iQcgPdI7uC55omR93EBBQBlsP+vaRZZMk3XiGPEP1sLLto0XdkQKW3kRNCMSlhiL9wKzCtqlGetIQuYfQBlvH86x/1QQ0+Qfd0L0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HJw3poOD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HJw3poOD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756219197;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 references:references; bh=cu4zFAZ8jWl3w1cb/yYaFbQbv6iTdi9cTxYu8IqqX5Y=;
	b=HJw3poODQHsKc/ZGOcBQdK1kcfPuWQZ8ljzttgMLWEy0UQQBi9nPSI0F5r4EGUQ8la6FFE
	586oKAWMnkt/LpUW5zj10WPnbJKvkki7eSiO6nrdDXJNMe/24nsPLp41h7VEh8bGkjQZb1
	y5IzGHqEnu9ZorryF5zeTA3LG36ynJ8=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-695-IZ-2mFt3M5WmGOrMH3NLCA-1; Tue,
 26 Aug 2025 10:39:53 -0400
X-MC-Unique: IZ-2mFt3M5WmGOrMH3NLCA-1
X-Mimecast-MFC-AGG-ID: IZ-2mFt3M5WmGOrMH3NLCA_1756219192
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EA4151800345;
	Tue, 26 Aug 2025 14:39:51 +0000 (UTC)
Received: from debian4.vm (unknown [10.22.80.227])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id B750118004A3;
	Tue, 26 Aug 2025 14:39:47 +0000 (UTC)
Received: by debian4.vm (sSMTP sendmail emulation); Tue, 26 Aug 2025 16:39:46 +0200
Message-ID: <20250826143946.002151840@debian4.vm>
User-Agent: quilt/0.68
Date: Tue, 26 Aug 2025 16:36:50 +0200
From: Mikulas Patocka <mpatocka@redhat.com>
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 Eric Biggers <ebiggers@kernel.org>,
 dengler@linux.ibm.com,
 linux-s390@vger.kernel.org,
 dm-devel@lists.linux.dev,
 ifranzki@linux.ibm.com,
 agk@redhat.com,
 snitzer@kernel.org,
 gmazyland@gmail.com,
 Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 4/7] dm-integrity: allocate the recalculate buffer with kmalloc
References: <20250826143646.570314717@debian4.vm>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Allocate the recalculate buffer with kmalloc rather than vmalloc. This
will be needed later, for the simplification of the asynchronous hash
interface.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
---
 drivers/md/dm-integrity.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2025-08-21 18:22:55.000000000 +0200
+++ linux-2.6/drivers/md/dm-integrity.c	2025-08-21 18:22:55.000000000 +0200
@@ -2998,7 +2998,7 @@ static void integrity_recalc(struct work
 	unsigned recalc_sectors = RECALC_SECTORS;
 
 retry:
-	recalc_buffer = __vmalloc(recalc_sectors << SECTOR_SHIFT, GFP_NOIO);
+	recalc_buffer = kmalloc(recalc_sectors << SECTOR_SHIFT, GFP_NOIO | __GFP_NOWARN);
 	if (!recalc_buffer) {
 oom:
 		recalc_sectors >>= 1;
@@ -3012,7 +3012,7 @@ oom:
 		recalc_tags_size += ic->internal_hash_digestsize - ic->tag_size;
 	recalc_tags = kvmalloc(recalc_tags_size, GFP_NOIO);
 	if (!recalc_tags) {
-		vfree(recalc_buffer);
+		kfree(recalc_buffer);
 		recalc_buffer = NULL;
 		goto oom;
 	}
@@ -3078,7 +3078,7 @@ next_chunk:
 		goto err;
 
 	io_req.bi_opf = REQ_OP_READ;
-	io_req.mem.type = DM_IO_VMA;
+	io_req.mem.type = DM_IO_KMEM;
 	io_req.mem.ptr.addr = recalc_buffer;
 	io_req.notify.fn = NULL;
 	io_req.client = ic->io;
@@ -3136,7 +3136,7 @@ unlock_ret:
 	recalc_write_super(ic);
 
 free_ret:
-	vfree(recalc_buffer);
+	kfree(recalc_buffer);
 	kvfree(recalc_tags);
 }
 

