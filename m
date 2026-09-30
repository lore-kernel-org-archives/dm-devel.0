Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80CFE433BB0
	for <dm-devel@lists.linux.dev>; Wed, 30 Sep 2026 19:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790797197; cv=none; b=E0wzpXuB7anw+6ZDCTpS7zxU5iiEbM1nAFSqTn4VUr8nLLOpn2oOuqtvthSTKIQ7+CpczbGwexCgqwaUnnkzBbWfdCO5P2kdjCicrPZKWFop+/+GwpsIqyWqvvONnThR8R7jXCleDlTIoxkzVZwaQCUGPXCdtFk3jH4W+d7c2kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790797197; c=relaxed/simple;
	bh=yXOAO3d2RpHWSYvKPCWs2GJvCfPSHlCWKLLJ+GhlLXM=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=FtitMYEVDZ+h3DAPuYpjL4fOcH+OjXPbPc7twEvXZc4vYZ98+t4yaZTAOU4RTRcTiobpt/Rkda43iRusj4QhwhCjB0fqb8q1XkSANh+CrsgyssYHSWp4EnxSBhVcFWK0Shh7mlmxhq/woN7Hf4wXW5kewcipBYYhnm0BCe7p1uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=B/sRBmQY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B/sRBmQY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790797194;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=InbnMGeDTbYwlMwiGMLbDj/OLs7Ug17CAFCcLj99wnY=;
	b=B/sRBmQYmQLyPChkIM36bC95+15HtgBDjPjVc0qc3TBFxJ41adfrPKTZTKLPtj8Dud2aFV
	y15ffy18rjP5g1Cal2xJn40OWaYCxz3Tw/6Rout4WjC0hrHdS6UqxWGt1qjb1GxePzsJWm
	SQcreO8paaKwTRj/seE3AW8q+wmbSvM=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-563-MrJb6JY-MJeC8s1_TCzhsA-1; Wed,
 30 Sep 2026 15:39:49 -0400
X-MC-Unique: MrJb6JY-MJeC8s1_TCzhsA-1
X-Mimecast-MFC-AGG-ID: MrJb6JY-MJeC8s1_TCzhsA_1790797188
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2B6871977316;
	Wed, 30 Sep 2026 19:39:48 +0000 (UTC)
Received: from mpatocka-thinkpadx1carbongen12.rmtcz.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ACD5D433;
	Wed, 30 Sep 2026 19:39:46 +0000 (UTC)
Date: Wed, 30 Sep 2026 21:39:44 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>
cc: dm-devel@lists.linux.dev
Subject: [PATCH 2/5] dm-writecache: fix a quirk in statistics
Message-ID: <d5890c28-cfd1-6df3-6db1-11a6215ac2be@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -j1QGTuclHp4IBJnvfMSjkRHA6jpWqGLEsbJBlTM1e8_1790797188
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

writecache_bio_copy_ssd() unconditionally adds the number of extra blocks
in the merged bio to stats.writes_allocate. That is only correct when the
entries were taken off the freelist.

When the function is called with search_used == true -- i.e. from the
write_hits_uncommitted / write_hits_committed paths in
writecache_map_write() -- the first entry was found in the rbtree and
every following entry is picked up with rb_next(), so nothing is
allocated at all. Accordingly the writes_allocate++ that accompanies a
successful writecache_pop_from_freelist() is skipped for that case, but
the batch accounting below still adds n - 1.

An in-place overwrite of n contiguous cached blocks therefore reports n -
1 allocations that never happened. Only the dmsetup status output is
affected; there is no functional change.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-5
Fixes: b2676e1482af ("dm writecache: count number of blocks written, not number of write bios")

---
 drivers/md/dm-writecache.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/md/dm-writecache.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-writecache.c
+++ linux-2.6/drivers/md/dm-writecache.c
@@ -1424,7 +1424,8 @@ static void writecache_bio_copy_ssd(stru
 	dm_accept_partial_bio(bio, bio_size >> SECTOR_SHIFT);
 
 	wc->stats.writes += bio->bi_iter.bi_size >> wc->block_size_bits;
-	wc->stats.writes_allocate += (bio->bi_iter.bi_size - wc->block_size) >> wc->block_size_bits;
+	if (!search_used)
+		wc->stats.writes_allocate += (bio->bi_iter.bi_size - wc->block_size) >> wc->block_size_bits;
 
 	if (unlikely(wc->uncommitted_blocks >= wc->autocommit_blocks)) {
 		wc->uncommitted_blocks = 0;

