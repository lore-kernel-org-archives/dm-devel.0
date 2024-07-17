Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 175D7803
	for <dm-devel@lists.linux.dev>; Wed, 17 Jul 2024 00:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721176349; cv=none; b=YP/I41DqXCu71PROSxKm9QQX0gRPFESOwgrMn/vuRJ11wfAJ7IxM2KlULsk1F4avPxKyyj5xqCF4gMTnSrS03kJqD3s6udSZgI2qoh+eaOUj/3QV/+uYuCc44pbRzNft8WpDf6pDEi448sZlTuJCfBEuhiRjpmdUEBKK8Ge71oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721176349; c=relaxed/simple;
	bh=cIIsAwAMSjcR/04CUi9T6SHV1vLIhBVmuGxlSMh77zA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=WBMqoNKsJjW1aXJwGl2+hHM0qio6a5DWYpznF7smgaNU60pkC7cj/OhjALtrX6hlv/b7IBpzfZgduPAnB7EoiZJ+AXMJYxk77+hp9KfG3PoH3fYDRWEccv2bG1MD+h6h/z/ms4X81Lk3SNLkxRsHYvCpOm4YupxQAP8DxlP9H5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KwEXAfTd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KwEXAfTd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721176344;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=cN2mcQyTz2ethFQBb5WT02kP1Z+j3ofZns4w/G2uOl0=;
	b=KwEXAfTd4eAfNn72hGqFa1xwjlOEKLMIzC27SFMnpiXiymZ24koWbrjWuR0MhHv8EcU9+f
	1Q/Wh/7IdJCm2QP5lZXDSk5kZQbmPI7ZEV+EHjRLAm8thxVoxgyOpcytRe7Qu+mRPZrhUk
	4sXeEKJhKidm08MduC6nrvHAANY87To=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-669-mnKylbz6M4CaClQoD03Uiw-1; Tue,
 16 Jul 2024 20:32:22 -0400
X-MC-Unique: mnKylbz6M4CaClQoD03Uiw-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C6A8E1955F3B
	for <dm-devel@lists.linux.dev>; Wed, 17 Jul 2024 00:32:21 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4AF8E1955D42;
	Wed, 17 Jul 2024 00:32:21 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id A9EA35329E; Tue, 16 Jul 2024 20:32:20 -0400 (EDT)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Matthew Sakai <msakai@redhat.com>
Subject: [PATCH] dm vdo repair: add missing kerneldoc fields
Date: Tue, 16 Jul 2024 20:32:20 -0400
Message-ID: <a1a3c5ac26639e526eeec526acc4dc9908151251.1721156310.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Also remove trivial comment for increment_recovery_point.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=9518
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/repair.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-vdo/repair.c b/drivers/md/dm-vdo/repair.c
index defc9359f10e..b6f3d0710a21 100644
--- a/drivers/md/dm-vdo/repair.c
+++ b/drivers/md/dm-vdo/repair.c
@@ -318,6 +318,7 @@ static bool __must_check abort_on_error(int result, struct repair_completion *re
 /**
  * drain_slab_depot() - Flush out all dirty refcounts blocks now that they have been rebuilt or
  *                      recovered.
+ * @completion: The repair completion.
  */
 static void drain_slab_depot(struct vdo_completion *completion)
 {
@@ -653,9 +654,6 @@ static void rebuild_reference_counts(struct vdo_completion *completion)
 	vdo_traverse_forest(vdo->block_map, process_entry, completion);
 }
 
-/**
- * increment_recovery_point() - Move the given recovery point forward by one entry.
- */
 static void increment_recovery_point(struct recovery_point *point)
 {
 	if (++point->entry_count < RECOVERY_JOURNAL_ENTRIES_PER_SECTOR)
@@ -952,6 +950,7 @@ static void abort_block_map_recovery(struct repair_completion *repair, int resul
 /**
  * find_entry_starting_next_page() - Find the first journal entry after a given entry which is not
  *                                   on the same block map page.
+ * @repair: The repair completion.
  * @current_entry: The entry to search from.
  * @needs_sort: Whether sorting is needed to proceed.
  *
@@ -1218,6 +1217,7 @@ static bool __must_check is_exact_recovery_journal_block(const struct recovery_j
 
 /**
  * find_recovery_journal_head_and_tail() - Find the tail and head of the journal.
+ * @repair: The repair completion.
  *
  * Return: True if there were valid journal blocks.
  */
@@ -1446,6 +1446,7 @@ static int validate_heads(struct repair_completion *repair)
 
 /**
  * extract_new_mappings() - Find all valid new mappings to be applied to the block map.
+ * @repair: The repair completion.
  *
  * The mappings are extracted from the journal and stored in a sortable array so that all of the
  * mappings to be applied to a given block map page can be done in a single page fetch.
@@ -1500,6 +1501,7 @@ static int extract_new_mappings(struct repair_completion *repair)
 /**
  * compute_usages() - Compute the lbns in use and block map data blocks counts from the tail of
  *                    the journal.
+ * @repair: The repair completion.
  */
 static noinline int compute_usages(struct repair_completion *repair)
 {
-- 
2.45.2

