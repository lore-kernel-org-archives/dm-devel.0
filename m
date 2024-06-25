Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C634A176225
	for <dm-devel@lists.linux.dev>; Tue, 25 Jun 2024 17:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719338225; cv=none; b=rfy0ARtYJx3RoLMG9xlzSLk8DBBr+mOHgPIMMZ+5CmVKkihQHDZaqV21DMKpeLwy9BJL8O92dS15Tw+GJbzgFINMuRz+Nu4C76m2uQtG3NfMVR9QxaTmEc+IYW5njQc93rzUVFuIBKpd4JjygR6oY9cyNBdzepID2if6ohVdKnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719338225; c=relaxed/simple;
	bh=2YiUjNhzGrx6oyMeOAJWojuB5lnWLCy46jv1fqUGiUc=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=cw5Ri2xSb1ZBDcHp65c9874O+x3Mu7yIzLmcKiiS+ExGDwCIOuatjUIKkhGm3EvAkhkGIh+TOPnG8RbPtn78WgzvoWZL2FTpqW7nxGrRnq7VLcfn0mNYqFxG3TQe3fqiTV41AbFQj9JOKS+lJEIkaGB07nmXw0rSvmwYaiWNPU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Cc24YJmD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Cc24YJmD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1719338222;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=0rpW0NQTyIQdUHLqnT4yOcOIbOm9Zd9PW1MKwLZ/FGM=;
	b=Cc24YJmD6hox9rW+qlFle5mzcPgpAR7vIEizsNJuNJMwou3QOPSqYfyW6vhqV9AdGzGH3N
	WsX9U+V8gYXMhJP7kT2a0M/PqaoHEQQ3GKjVXV/PtAJVRoeE2HqwR5AVPdvgDiz8c4DjNi
	GjjP6VEejlR70zSr9Saw4CIpDleB0yI=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-197-ZTXraDkEMCGzswBSEE4jKQ-1; Tue,
 25 Jun 2024 13:56:59 -0400
X-MC-Unique: ZTXraDkEMCGzswBSEE4jKQ-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1B0BA19560AE;
	Tue, 25 Jun 2024 17:56:58 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CA6CF3000601;
	Tue, 25 Jun 2024 17:56:57 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id BF9C230C1C04; Tue, 25 Jun 2024 17:56:56 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id BD15F3FB52;
	Tue, 25 Jun 2024 19:56:56 +0200 (CEST)
Date: Tue, 25 Jun 2024 19:56:56 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Mike Snitzer <snitzer@kernel.org>
cc: dm-devel@lists.linux.dev
Subject: [PATCH 1/2] dm: introduce the target flag mempool_needs_integrity
Message-ID: <a5896fbb-9538-2f79-29cf-c820152158@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

This commit introduces the dm target flag mempool_needs_integrity. When
the flag is set, device mapper will call bioset_integrity_create on it's
bio sets. The target can then call bio_integrity_alloc on the bios
allocated from the table's mempool.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-table.c         |    7 +++++--
 include/linux/device-mapper.h |    6 ++++++
 2 files changed, 11 insertions(+), 2 deletions(-)

Index: linux-2.6/include/linux/device-mapper.h
===================================================================
--- linux-2.6.orig/include/linux/device-mapper.h	2024-06-25 19:25:12.000000000 +0200
+++ linux-2.6/include/linux/device-mapper.h	2024-06-25 19:25:30.000000000 +0200
@@ -397,6 +397,12 @@ struct dm_target {
 	 * bio_set_dev(). NOTE: ideally a target should _not_ need this.
 	 */
 	bool needs_bio_set_dev:1;
+
+	/*
+	 * Set if the target calls bio_integrity_alloc on bios received
+	 * in the map method.
+	 */
+	bool mempool_needs_integrity:1;
 };
 
 void *dm_per_bio_data(struct bio *bio, size_t data_size);
Index: linux-2.6/drivers/md/dm-table.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-table.c	2024-06-25 19:25:15.000000000 +0200
+++ linux-2.6/drivers/md/dm-table.c	2024-06-25 19:25:44.000000000 +0200
@@ -1022,6 +1022,7 @@ static int dm_table_alloc_md_mempools(st
 	unsigned int per_io_data_size = 0, front_pad, io_front_pad;
 	unsigned int min_pool_size = 0, pool_size;
 	struct dm_md_mempools *pools;
+	bool mempool_needs_integrity = t->integrity_supported;
 
 	if (unlikely(type == DM_TYPE_NONE)) {
 		DMERR("no table type is set, can't allocate mempools");
@@ -1043,6 +1044,8 @@ static int dm_table_alloc_md_mempools(st
 
 		per_io_data_size = max(per_io_data_size, ti->per_io_data_size);
 		min_pool_size = max(min_pool_size, ti->num_flush_bios);
+
+		mempool_needs_integrity |= ti->mempool_needs_integrity;
 	}
 	pool_size = max(dm_get_reserved_bio_based_ios(), min_pool_size);
 	front_pad = roundup(per_io_data_size,
@@ -1053,13 +1056,13 @@ static int dm_table_alloc_md_mempools(st
 	if (bioset_init(&pools->io_bs, pool_size, io_front_pad,
 			dm_table_supports_poll(t) ? BIOSET_PERCPU_CACHE : 0))
 		goto out_free_pools;
-	if (t->integrity_supported &&
+	if (mempool_needs_integrity &&
 	    bioset_integrity_create(&pools->io_bs, pool_size))
 		goto out_free_pools;
 init_bs:
 	if (bioset_init(&pools->bs, pool_size, front_pad, 0))
 		goto out_free_pools;
-	if (t->integrity_supported &&
+	if (mempool_needs_integrity &&
 	    bioset_integrity_create(&pools->bs, pool_size))
 		goto out_free_pools;
 

