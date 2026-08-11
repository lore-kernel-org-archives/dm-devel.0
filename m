Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C509F3769E0
	for <dm-devel@lists.linux.dev>; Tue, 11 Aug 2026 19:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786474960; cv=none; b=alzvv4q2xF6IGFg/IZOOy2pS5CoJCpljs4lO0SZFBvuXfoSQupvpoXxNgNIaVSc7w233HpqUUDjU8HmrC1RmXR1hIrpctDt1mqAVVEqL8JgFOGUC5id7fpNOEJwiGRYoiul/UsdOXnWb3+2BUPG24+/zX/pncm3wTOgw4N4f/Nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786474960; c=relaxed/simple;
	bh=FxDj5DLtgVTxbB5qwyRpTRbsXkkles7554XWVtzprug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=LNRwyB4GGprRagfPaX+o61zOIQJ7De8RQLAzs8VJi/RgWgnu2VI9oHLANItA6VTfC5M1i8bjQTJrxIqPCBAcLETZNRDozivY8N16WkT/rNi03c7CZH+yIV3V8HynorCIOyCn0Or6W95X5D8beG+MTSUVYJ2mV6P+S4SGq/L1n0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IldQJJr7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IldQJJr7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786474957;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y7AeeUwW8vYRYcK+33OhPGx1BEMk/4FijIEeeLCE+H8=;
	b=IldQJJr7CenREeFkwx8Y88JtmsesHtYW+04d6lAmpfDWYdgwlnO5QtRho1XuLXQgByTDZ+
	Z5wmb2IA+LDybsk6asQrLpqUKkQqxTtw2frZcqx9ndycQ7da3s5vxWUEYnc57kMdvGiJY8
	gYtd3Pmyu06otts8KFw2c057IGMorto=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-36-n1qNoP20PE2NWkpjS0QL-Q-1; Tue,
 11 Aug 2026 15:02:36 -0400
X-MC-Unique: n1qNoP20PE2NWkpjS0QL-Q-1
X-Mimecast-MFC-AGG-ID: n1qNoP20PE2NWkpjS0QL-Q_1786474955
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E32E218002C4
	for <dm-devel@lists.linux.dev>; Tue, 11 Aug 2026 19:02:34 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (ci-vm-10-0-103-170.hosted.upshift.rdu2.redhat.com [10.0.103.170])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C7DDB180034C;
	Tue, 11 Aug 2026 19:02:34 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 4B72C2586C; Tue, 11 Aug 2026 15:02:34 -0400 (EDT)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 2/2] dm vdo indexer: validate record page numbers better
Date: Tue, 11 Aug 2026 15:02:34 -0400
Message-ID: <f7a7dd5fb8f423d4a23a7b043dfc9291c6f17bc8.1786473832.git.msakai@redhat.com>
In-Reply-To: <5478fe5fa3f94b04799e76c4e93229438773a32e.1786473832.git.msakai@redhat.com>
References: <5478fe5fa3f94b04799e76c4e93229438773a32e.1786473832.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: vG8Yd4rWVZOExkhgjuFXO0euz3EhQJaSGpBr3me_dKc_1786474955
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Move the record_page_number validation check into the
chapter index lookup function in order to detect (and
discard) corrupted values on all paths.

Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/indexer/chapter-index.c | 15 +++++++++++----
 drivers/md/dm-vdo/indexer/volume.c        |  6 ------
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm-vdo/indexer/chapter-index.c b/drivers/md/dm-vdo/indexer/chapter-index.c
index bb3b0ab5d50d..9fb9e59238d4 100644
--- a/drivers/md/dm-vdo/indexer/chapter-index.c
+++ b/drivers/md/dm-vdo/indexer/chapter-index.c
@@ -284,10 +284,17 @@ int uds_search_chapter_index_page(struct delta_index_page *index_page,
 	if (result != UDS_SUCCESS)
 		return result;
 
-	if (was_entry_found(&entry, address))
-		*record_page_ptr = uds_get_delta_entry_value(&entry);
-	else
+	if (!was_entry_found(&entry, address)) {
 		*record_page_ptr = NO_CHAPTER_INDEX_ENTRY;
+		return UDS_SUCCESS;
+	}
 
-	return UDS_SUCCESS;
+	*record_page_ptr = uds_get_delta_entry_value(&entry);
+	result = VDO_ASSERT(*record_page_ptr < geometry->record_pages_per_chapter,
+			    "0 <= %d < %u", *record_page_ptr,
+			    geometry->record_pages_per_chapter);
+	if (result != VDO_SUCCESS)
+		*record_page_ptr = NO_CHAPTER_INDEX_ENTRY;
+
+	return result;
 }
diff --git a/drivers/md/dm-vdo/indexer/volume.c b/drivers/md/dm-vdo/indexer/volume.c
index 78c3729f1f65..38e51fa1cbd0 100644
--- a/drivers/md/dm-vdo/indexer/volume.c
+++ b/drivers/md/dm-vdo/indexer/volume.c
@@ -891,12 +891,6 @@ int uds_search_cached_record_page(struct volume *volume, struct uds_request *req
 	if (record_page_number == NO_CHAPTER_INDEX_ENTRY)
 		return UDS_SUCCESS;
 
-	result = VDO_ASSERT(record_page_number < geometry->record_pages_per_chapter,
-			    "0 <= %d < %u", record_page_number,
-			    geometry->record_pages_per_chapter);
-	if (result != VDO_SUCCESS)
-		return result;
-
 	page_number = geometry->index_pages_per_chapter + record_page_number;
 
 	physical_page = map_to_physical_page(&volume->geometry, chapter, page_number);
-- 
2.53.0

