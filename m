Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 257BA20DCD
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 21:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709327617; cv=none; b=FnfRNzsSRsaJQuBw3VJ+hB58yVP4wO8Y80sAuAFvtClMhnNEY0hG9ifRlwdyASNwdBcslbbTf4ySpKu+e5iwUIh/YF+NKma89RRaGEMp8iM7px9wNwaPVM+ACv+zPmb+3MP+SivIzY12z2V3oDae+aHF+dBpUmsysaR95RJ6FWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709327617; c=relaxed/simple;
	bh=phg/U/5632w83m3XiNkl7RUoga0dECzZ7QzxfaZRNYU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=bnuDCF5zxg25tZJf0yivEg6mlVyq5zdc/yOfUfb/LY0oXNCnrBUjwT0TL0q2iqsVT8CwSVrOCmq6ok3mVJiRUf2Ylde4gVy0wkLWewdt9TkTmWthEs2g9pTLwWw/elUQa8dEu5QhM2qFMYTPfOOKaZri6JjEE+wgB510NcppSlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=c+0HxJus; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c+0HxJus"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709327615;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=IGJlD1MTIzfD/rvYcM+aDNNfSqS8oD0oMfz20weUotw=;
	b=c+0HxJusLCW5bun/dlKjlu34yB3VwkVIY+KwvZLGjI0A23GeHr56NVdvcCsL7DiHZeoV0m
	j2ONR3qqkwrtr+EQpEXV2ZRNq3BOp5QSOuOHotAdL6cdb95yqQd6qHIrFQaL0EVDakx2X9
	g3uhxuKeuMwLYR2IUaguGD2dbXiZs20=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-617-5o0XUKUZNiakVpTtgFj2Vw-1; Fri,
 01 Mar 2024 16:13:33 -0500
X-MC-Unique: 5o0XUKUZNiakVpTtgFj2Vw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1E42F380670C
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 21:13:33 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1604D1121312;
	Fri,  1 Mar 2024 21:13:33 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 0C804A1B8C; Fri,  1 Mar 2024 16:13:33 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Matthew Sakai <msakai@redhat.com>
Subject: [PATCH] dm vdo indexer: fix use after free
Date: Fri,  1 Mar 2024 16:13:33 -0500
Message-ID: <7d10a39b4762d75dba24912140f5879f6a5a22e4.1709327473.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Fixes: b46d79bdb82a ("dm vdo: add deduplication index storage interface")
Reported-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/indexer/index-layout.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-vdo/indexer/index-layout.c b/drivers/md/dm-vdo/indexer/index-layout.c
index 349b3022f1e1..74fd44c20e5c 100644
--- a/drivers/md/dm-vdo/indexer/index-layout.c
+++ b/drivers/md/dm-vdo/indexer/index-layout.c
@@ -1561,10 +1561,11 @@ static int __must_check load_index_save(struct index_save_layout *isl,
 
 
 	if (table->header.type != RH_TYPE_SAVE) {
+		uds_log_error_strerror(UDS_CORRUPT_DATA,
+				       "unexpected index save %u header type %u",
+				       instance, table->header.type);
 		vdo_free(table);
-		return uds_log_error_strerror(UDS_CORRUPT_DATA,
-					      "unexpected index save %u header type %u",
-					      instance, table->header.type);
+		return UDS_CORRUPT_DATA;
 	}
 
 	result = read_index_save_data(reader, isl, table->header.payload);
-- 
2.42.0

