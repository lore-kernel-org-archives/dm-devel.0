Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8A51A9F85
	for <dm-devel@lists.linux.dev>; Tue, 24 Feb 2026 02:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771898935; cv=none; b=XEOYJ+h6qJw8SMQSd81WhNokcJ9csPalXzPVx/mFxkIXZsGXwzyeM7JJiAxe/FkRiy0YJs8yRFcn2V1yiiQKo9cndJrELuX3j/kSAIgfDT13SOT6EpiXLFyIh5UxW6fw5n+V0pVG2zmWcp0MFRn+txX14eMUj7LoTLvP9PLSM24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771898935; c=relaxed/simple;
	bh=7mTqxaSMUnHomnMfICJKWgJ/bKwtiRisF5F0hLvT7oE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=ShcJyLre6480RGtp6k5P8Wc88FAkhurh9Y8kqP5lnY75E7pf5gOtb32H2iLIHhOou7JyLPF+zQECNd/hpK2KdrupNkruhCheDUgY34MEbr7gDowVOmZSErBwoI7MEQwyfaLpk+MCaU65jE7AgFmQWl+p68kV8ejuRnblKGd8fzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bNgCF+7K; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bNgCF+7K"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771898931;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bZpZXsOCH2MfrChGaxHPEQs/QFM+Iydg5rgl0pNGpbs=;
	b=bNgCF+7KUntTfKA0vwM4nd6wPfiUDxa5anLWP6Ohxday2K5PzV7cWCP5jqYYz6SnTa5RGs
	fF/I5n0LywIISLOTJhRoWqt2AGaqtxIb9zkrhebq2jcdsQEvmjmaLZM2NtB6cg3oJUWRtN
	5kjFAqpoHfvF04Mhuq3dBhYSIJtei+Y=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-627-oWRUEsdIP3alyoqeaglnKg-1; Mon,
 23 Feb 2026 21:08:50 -0500
X-MC-Unique: oWRUEsdIP3alyoqeaglnKg-1
X-Mimecast-MFC-AGG-ID: oWRUEsdIP3alyoqeaglnKg_1771898929
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4DB8E180025B
	for <dm-devel@lists.linux.dev>; Tue, 24 Feb 2026 02:08:49 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (unknown [10.0.103.170])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2FEF41955F43;
	Tue, 24 Feb 2026 02:08:49 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 85773129C85; Mon, 23 Feb 2026 21:08:48 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Matthew Sakai <msakai@redhat.com>
Subject: [PATCH v2 1/2] dm vdo indexer: validate saved region and zone counts
Date: Mon, 23 Feb 2026 21:08:47 -0500
Message-ID: <68ec95009a78684b92108925ce51df6d4e3ae882.1771898188.git.msakai@redhat.com>
In-Reply-To: <cover.1771898188.git.msakai@redhat.com>
References: <cover.1771898188.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: VyiUC59lecazWuwxdeNhDP3y_IdRDGa4Y2F8Z8mDgx8_1771898929
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Verify that the loaded zone count is in the valid range before
using it as a loop iterator. Also validate the region_count
to catch cases where too few regions are defined.

Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/indexer/index-layout.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-vdo/indexer/index-layout.c b/drivers/md/dm-vdo/indexer/index-layout.c
index 61edf2b72427..90a2e4b7345c 100644
--- a/drivers/md/dm-vdo/indexer/index-layout.c
+++ b/drivers/md/dm-vdo/indexer/index-layout.c
@@ -1444,8 +1444,11 @@ static int __must_check reconstruct_index_save(struct index_save_layout *isl,
 	u64 next_block = isl->index_save.start_block;
 	u64 last_block = next_block + isl->index_save.block_count;
 
-	isl->zone_count = table->header.region_count - 3;
+	if (table->header.region_count < 4)
+		return vdo_log_error_strerror(UDS_CORRUPT_DATA,
+					      "invalid region count");
 
+	isl->zone_count = table->header.region_count - 3;
 	last_region = &table->regions[table->header.region_count - 1];
 	if (last_region->kind == RL_KIND_EMPTY) {
 		isl->free_space = *last_region;
@@ -1459,6 +1462,10 @@ static int __must_check reconstruct_index_save(struct index_save_layout *isl,
 		};
 	}
 
+	if (isl->zone_count > MAX_ZONES)
+		return vdo_log_error_strerror(UDS_CORRUPT_DATA,
+					      "invalid zone count");
+
 	isl->header = table->regions[0];
 	result = verify_region(&isl->header, next_block++, RL_KIND_HEADER,
 			       RL_SOLE_INSTANCE);
-- 
2.48.1

