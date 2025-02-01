Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5601A926
	for <dm-devel@lists.linux.dev>; Sat,  1 Feb 2025 01:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738374617; cv=none; b=FsPRi7sxdfAX78Tjw08Sv8Npl9aLfLZJpah91jFWkTonAs1obrlN1uVanG84KNiFLSvR5AxNuSDwvttz0EvDfi/x+ihXQEebZHJB4K+nTNrT8Xi5dTdRVISs4DUzCJSxQNn993/+FvfiOxnZJeueZyvDmI1ZfFkSyUsCG1oJCeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738374617; c=relaxed/simple;
	bh=02l3BtDq9zgESzNT58DJhsbML5KAIze+HM8rQr0gSY8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=CJYRh2PROgCdzvbh2vFZyjzgFKFyiejxI8PN1gnGvQZDov2aGbVK9oo5BUO9YwUV7sjaFLNaMv937Lw7jiDR+a8dmaeN1jEBGBZT3giMrRsKkOEGQC8GHagHp+rJorhxPkSsBxxTkoLcvcpZKD4nJP8UoIyyHs981IjYBX54Kr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=be9DCFAz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="be9DCFAz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738374611;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=wB4u7cU0LHirVg0A0FHvz5/gYAxE0vI1NhHPG6wQng4=;
	b=be9DCFAzE/vyMNS5IRRFBgd9mcg2oGs5OVMUeQI7cd5oxcDuZsTb3FaZwtQ/FXEoTgC6fE
	Vjbxzt1E/dTDVCh/tyQh7obiG7SmpPn6b1R2JDo65XyVxHsrzlK6Fr5inMRg1dptZevUAv
	8K15ej7qrL7qeH0CEk1aqg1lbSikvQA=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-590-1GF1qqn3MIqaBWFwDxknNA-1; Fri,
 31 Jan 2025 20:50:09 -0500
X-MC-Unique: 1GF1qqn3MIqaBWFwDxknNA-1
X-Mimecast-MFC-AGG-ID: 1GF1qqn3MIqaBWFwDxknNA
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C813D19560B7
	for <dm-devel@lists.linux.dev>; Sat,  1 Feb 2025 01:50:08 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (unknown [10.0.103.170])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 82F2E180035E;
	Sat,  1 Feb 2025 01:50:08 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 904595F298; Fri, 31 Jan 2025 20:50:07 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Matthew Sakai <msakai@redhat.com>
Subject: [PATCH] dm vdo: remove checks that can not fail
Date: Fri, 31 Jan 2025 20:50:07 -0500
Message-ID: <b42764f9b9f809ef30989a41f94e7b6545e6a265.1738374358.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: KjdKKvJ2THTesY6VtDqffa5voez-6FjuYC2tM5dD2iE_1738374608
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/constants.h |  3 ---
 drivers/md/dm-vdo/encodings.c | 20 +-------------------
 2 files changed, 1 insertion(+), 22 deletions(-)

diff --git a/drivers/md/dm-vdo/constants.h b/drivers/md/dm-vdo/constants.h
index a8c4d6e24b38..2a8b03779f87 100644
--- a/drivers/md/dm-vdo/constants.h
+++ b/drivers/md/dm-vdo/constants.h
@@ -44,9 +44,6 @@ enum {
 	/* The default size of each slab journal, in blocks */
 	DEFAULT_VDO_SLAB_JOURNAL_SIZE = 224,
 
-	/* Unit test minimum */
-	MINIMUM_VDO_SLAB_JOURNAL_BLOCKS = 2,
-
 	/*
 	 * The initial size of lbn_operations and pbn_operations, which is based upon the expected
 	 * maximum number of outstanding VIOs. This value was chosen to make it highly unlikely
diff --git a/drivers/md/dm-vdo/encodings.c b/drivers/md/dm-vdo/encodings.c
index 100e92f8f866..b7cc0f41caca 100644
--- a/drivers/md/dm-vdo/encodings.c
+++ b/drivers/md/dm-vdo/encodings.c
@@ -711,24 +711,11 @@ int vdo_configure_slab(block_count_t slab_size, block_count_t slab_journal_block
 	ref_blocks = vdo_get_saved_reference_count_size(slab_size - slab_journal_blocks);
 	meta_blocks = (ref_blocks + slab_journal_blocks);
 
-	/* Make sure test code hasn't configured slabs to be too small. */
+	/* Make sure configured slabs are not too small. */
 	if (meta_blocks >= slab_size)
 		return VDO_BAD_CONFIGURATION;
 
-	/*
-	 * If the slab size is very small, assume this must be a unit test and override the number
-	 * of data blocks to be a power of two (wasting blocks in the slab). Many tests need their
-	 * data_blocks fields to be the exact capacity of the configured volume, and that used to
-	 * fall out since they use a power of two for the number of data blocks, the slab size was
-	 * a power of two, and every block in a slab was a data block.
-	 *
-	 * TODO: Try to figure out some way of structuring testParameters and unit tests so this
-	 * hack isn't needed without having to edit several unit tests every time the metadata size
-	 * changes by one block.
-	 */
 	data_blocks = slab_size - meta_blocks;
-	if ((slab_size < 1024) && !is_power_of_2(data_blocks))
-		data_blocks = ((block_count_t) 1 << ilog2(data_blocks));
 
 	/*
 	 * Configure the slab journal thresholds. The flush threshold is 168 of 224 blocks in
@@ -1221,11 +1208,6 @@ int vdo_validate_config(const struct vdo_config *config,
 	if (result != VDO_SUCCESS)
 		return result;
 
-	result = VDO_ASSERT(config->slab_journal_blocks >= MINIMUM_VDO_SLAB_JOURNAL_BLOCKS,
-			    "slab journal size meets minimum size");
-	if (result != VDO_SUCCESS)
-		return result;
-
 	result = VDO_ASSERT(config->slab_journal_blocks <= config->slab_size,
 			    "slab journal size is within expected bound");
 	if (result != VDO_SUCCESS)
-- 
2.45.2

