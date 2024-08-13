Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC33219D886
	for <dm-devel@lists.linux.dev>; Tue, 13 Aug 2024 14:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723559722; cv=none; b=C6bXeYmRVnS/Xp4/GqMpVP+/r1oEtQyugvEgwViY77LA06dCpmw25SziUEyxtfIgDMjNZ1/3uXOmeqATDAz+9WrpuJrBYtAJl1dxP3FP+K4+FywlVMOQs2/pDXq4E+kNJkEp7M08r1aslfF8eObi6pf+V/xGZl1J66ds0WNGid0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723559722; c=relaxed/simple;
	bh=iuxaZ9tQUgOVs6N1EnoNar9ZBB3S82JZoi+q3pi4+pg=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=gsn7mBgfsF+qclnODnUdksKfguxzXMkha+z1crMo9BXtffVJv+jRiSKCWZfzrMGLOkFfdXaCQtmjNdDm02rKPDT6Yjo1roIgRSiIuxbIfC5ALHg+I6CAx90miW6NXFDaqMJpLjGAq4c3K9EBz2CmamLxw5PuiCPws0SYdobY2gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OGacVGp1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OGacVGp1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723559719;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=9v6R9z/Hy13sfzaiyhVYCShdcPKp/GOIQtvkFzlxSuA=;
	b=OGacVGp13ibYeUMfQnuXTH7xFrBWsUswO4f5odnWdW82upxBb15TRR8mRMsS28jF2E23YY
	/2yuKdezw52y8cnq8yKTw5s6lC4IR+tE7WXkO7FYd3HJKTa/WlysIB9YblYiLR6dRlPqLQ
	np9YFXXvfSmYFQs+BotLSiMvt+SGQgw=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-493-9JqLvhuzOG6jJU0zi5bpkw-1; Tue,
 13 Aug 2024 10:35:16 -0400
X-MC-Unique: 9JqLvhuzOG6jJU0zi5bpkw-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C1D9E19541A7;
	Tue, 13 Aug 2024 14:35:15 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6C28B1955F40;
	Tue, 13 Aug 2024 14:35:15 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 6192730C1C18; Tue, 13 Aug 2024 14:35:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 601203FB48;
	Tue, 13 Aug 2024 16:35:14 +0200 (CEST)
Date: Tue, 13 Aug 2024 16:35:14 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Joe Thornber <thornber@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
cc: dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH] dm persistent data: fix memory allocation failure
Message-ID: <12f6fc8a-a0cb-48c-e792-57f09b62cd@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

kmalloc is unreliable when allocating more than 8 pages of memory. It may
fail when there is plenty of free memory but the memory is fragmented.
Zdenek Kabelac observed such failure in his tests.

This commit changes kmalloc to kvmalloc - kvmalloc will fall back to
vmalloc if the large allocation fails.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/md/persistent-data/dm-space-map-metadata.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/md/persistent-data/dm-space-map-metadata.c
===================================================================
--- linux-2.6.orig/drivers/md/persistent-data/dm-space-map-metadata.c	2024-08-13 13:25:04.000000000 +0200
+++ linux-2.6/drivers/md/persistent-data/dm-space-map-metadata.c	2024-08-13 14:39:08.000000000 +0200
@@ -277,7 +277,7 @@ static void sm_metadata_destroy(struct d
 {
 	struct sm_metadata *smm = container_of(sm, struct sm_metadata, sm);
 
-	kfree(smm);
+	kvfree(smm);
 }
 
 static int sm_metadata_get_nr_blocks(struct dm_space_map *sm, dm_block_t *count)
@@ -772,7 +772,7 @@ struct dm_space_map *dm_sm_metadata_init
 {
 	struct sm_metadata *smm;
 
-	smm = kmalloc(sizeof(*smm), GFP_KERNEL);
+	smm = kvmalloc(sizeof(*smm), GFP_KERNEL);
 	if (!smm)
 		return ERR_PTR(-ENOMEM);
 

