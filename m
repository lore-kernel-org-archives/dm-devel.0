Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEA3D2877D5
	for <dm-devel@lists.linux.dev>; Wed, 11 Feb 2026 15:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770822363; cv=none; b=Vpl+Q2k0p5Ueui1rR3mVwYgC+fx7AMRczO6Crk2YQVEQEOzfkr/RX2HiuiM87DXNiJCEYOBPd9IAPs5IybmkSasuz+B8D377snkXaUysVGdFp2N5a71Q+BdV1eDClt6SWcseNKDXJj/Oj1sQZJU3VIDYE6xSWycf7AOoMsKbraU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770822363; c=relaxed/simple;
	bh=f8ZU9X1jxb9sQtRETw2Ojm3qdkClh936hPJFROivdgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=QOhvWOSYNaKyhhNN69W8HvrtsGHvBNCBzMeuA7sN0+t7mxB0XzAqhjGs7jFU6kda6WJy0HVJf/l6FN6SAbYAmPWNDvrtiFrDRFzVDHaz47w3/eQOudRmXE1KiTAigMCXwS0kXmUoLYe2IZU6bbgsfBfXKL6wb7IQFVEs4K3jRU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FrQboLiB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FrQboLiB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770822361;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FXLMjrw+mRzPtaQ5vaZMo2HxwEpNccgUjBIRD2RdbCU=;
	b=FrQboLiBdAC/m/ZtOMRB+yf7ZRFhTXexSTjtWDMukzEfYCX9+IWbwCICVAk0AtXX2vtADX
	kvyPiH5p4t/1FsITBWDgwWWXb/ZU/pMg+8atP0kgHOmCxDnPNyyqex/Fceq6kK9ORPz3NA
	HmSbQbn0trZ77rbIC6hq+EFoGWuv/3c=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-540-dBnTmWTIN0-3BbgK-odeoA-1; Wed,
 11 Feb 2026 10:05:57 -0500
X-MC-Unique: dBnTmWTIN0-3BbgK-odeoA-1
X-Mimecast-MFC-AGG-ID: dBnTmWTIN0-3BbgK-odeoA_1770822356
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C10741956050
	for <dm-devel@lists.linux.dev>; Wed, 11 Feb 2026 15:05:56 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (unknown [10.0.103.170])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8C6931956053;
	Wed, 11 Feb 2026 15:05:56 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 0CD311279DD; Wed, 11 Feb 2026 10:05:56 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 1/2] dm vdo indexer: validate saved zone count
Date: Wed, 11 Feb 2026 10:05:54 -0500
Message-ID: <d5a993c1d724a5a2ae3c9a7179eedf68afa16f67.1770818146.git.msakai@redhat.com>
In-Reply-To: <cover.1770818146.git.msakai@redhat.com>
References: <cover.1770818146.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: EVN2GMJFbZ4nTMEyB0RRJUpXiVUtOsTtqBgKrewzojQ_1770822356
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Verify that the loaded zone count is in the valid range
before using it as a loop iterator.

Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/indexer/index-layout.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/md/dm-vdo/indexer/index-layout.c b/drivers/md/dm-vdo/indexer/index-layout.c
index 61edf2b72427..37144249f7ba 100644
--- a/drivers/md/dm-vdo/indexer/index-layout.c
+++ b/drivers/md/dm-vdo/indexer/index-layout.c
@@ -1445,6 +1445,9 @@ static int __must_check reconstruct_index_save(struct index_save_layout *isl,
 	u64 last_block = next_block + isl->index_save.block_count;
 
 	isl->zone_count = table->header.region_count - 3;
+	if (isl->zone_count > MAX_ZONES)
+		return vdo_log_error_strerror(UDS_CORRUPT_DATA,
+					      "invalid zone count");
 
 	last_region = &table->regions[table->header.region_count - 1];
 	if (last_region->kind == RL_KIND_EMPTY) {
-- 
2.48.1

