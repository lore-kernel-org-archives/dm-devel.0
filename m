Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795005147;
	b=JEc0UILLXh11/2J2ScHmOcf12+JjRimsGBgCThOQhk5LFR+aNl0BZY57ebHrRAevyCLP
	 FacU4KWiolbsWYiVaTNdq4V3B9gTTKGSbKi0zYNaHyHZlp86mPDJcJcnJXBFbsP9qKU3f
	 7nB4ZNdp7FO+chqR4Qlk4jWartZtJsZIoyH+xY5XB+AKjUIYaMMASsnEFur2lGgHUmnDa
	 PdtvxkeZbBDKE08MWZHaHXo3O0cWCwAJoU07rROsW7RDd8Z82oD5VlR00OI79Wk71zde2
	 uXW9ONAxhbifxg7AZT0j6T7s20cj7ICYd2t3AQF/HMkh/4AUIVu5oJJXql0nNj/RkXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795005147;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:MIME-Version:X-Scanned-By:X-Mimecast-Spam-Score:
	 X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:
	 Content-Transfer-Encoding:content-type;
	bh=Vk/RxvhLoUZJlV7/xcLSUVF7OjMXM6s5SCrjymf7lSQ=;
	b=l/azClWdUnbR8XKHekPORyCF7k3cAdneu/8QN06hjtVyjpir0fUFdPXU0kRqUYD2o362
	 CpatCVYBs381VE2NiFWpDzyEr6wWlwMIolbcFGZ6FOr55iqiAOaVF0ANbKOp0XAbnjzkw
	 vL0ui3sQ97EscAaDyv+iQyA7W1Gmn0YHeFbo8OE3ixd+06399x5pMtQ719BfwZQPp0zSQ
	 XxdQ8GUKR4DR92vAIm7Y6fA+vDM/rPrEbYDTd6iIyu67nW6mSTe1IomEpYWLrgrl9c1OJ
	 +WiRwShEn+3aCMLT6ZYcpjDgL6EWoohbmGAmYnBiHzEEdxkf/0K2PhAC6GvbCfTLnRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=LrZc2xEk;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44FE2606A31C
	for <dm-devel@lists.linux.dev>; Wed, 18 Nov 2026 12:32:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 44FE2606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=LrZc2xEk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795005145;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Vk/RxvhLoUZJlV7/xcLSUVF7OjMXM6s5SCrjymf7lSQ=;
	b=LrZc2xEkuvZo7CQVv5sK+w5w7RpsyZqW+1E1qUGlVSkrqN/wuL2XdaYvKpmalLpcDg905k
	N2GA1BemTKQ4olLKagUK0WYIxG+kx1u7OgSUC01fE0KpLOuD24c+FZsb1wKFbPb3ZSHKHV
	db93oLmPhutqcTKLDbtfIu2QBos+QMc=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-437-SQ0kuEORMTSsqziiq9PlxA-1; Wed,
 18 Nov 2026 07:32:24 -0500
X-MC-Unique: SQ0kuEORMTSsqziiq9PlxA-1
X-Mimecast-MFC-AGG-ID: SQ0kuEORMTSsqziiq9PlxA_1795005143
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 189DF18004FF;
	Wed, 18 Nov 2026 12:32:23 +0000 (UTC)
Received: from localhost (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B75CA436;
	Wed, 18 Nov 2026 12:32:20 +0000 (UTC)
From: Ming-Hung Tsai <mtsai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	Ben Marzinski <bmarzins@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Ming-Hung Tsai <mtsai@redhat.com>
Subject: [PATCH] dm thin metadata: don't treat a device id lookup error as unused
Date: Wed, 18 Nov 2026 20:32:06 +0800
Message-ID: <20261118123206.61942-1-mtsai@redhat.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: NAD308OQGqbwP8uJcubYc-cVjBKYOFBgCrd_QkLPbyU_1795005143
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Both __create_thin() and __create_snap() check that the device id is
unused before creating the device. The check only tests for a
successful lookup, so it treats any lookup error as an unused id and
proceeds to the create path.

On a lookup error such as -EIO, the create path inserts the device into
the top-level tree. If the id already exists, the insert overwrites its
entry and deletes the corresponding mapping tree. This happens before
__open_device() runs, so __open_device() cannot catch it.

Fix by propagating the lookup error and creating the device only on
-ENODATA.

Fixes: 991d9fa02da0 ("dm: add thin provisioning target")
Signed-off-by: Ming-Hung Tsai <mtsai@redhat.com>
---
 drivers/md/dm-thin-metadata.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index 88c3342ef4df..8fca13dcbe53 100644
--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -1116,8 +1116,8 @@ static int __create_thin(struct dm_pool_metadata *pmd,
 
 	r = dm_btree_lookup(&pmd->details_info, pmd->details_root,
 			    &key, NULL);
-	if (!r)
-		return -EEXIST;
+	if (r != -ENODATA)
+		return r ? r : -EEXIST;
 
 	/*
 	 * Create an empty btree for the mappings.
@@ -1193,8 +1193,8 @@ static int __create_snap(struct dm_pool_metadata *pmd,
 	/* check this device is unused */
 	r = dm_btree_lookup(&pmd->details_info, pmd->details_root,
 			    &dev_key, NULL);
-	if (!r)
-		return -EEXIST;
+	if (r != -ENODATA)
+		return r ? r : -EEXIST;
 
 	/* find the mapping tree for the origin */
 	r = dm_btree_lookup(&pmd->tl_info, pmd->root, &key, &value);
-- 
2.49.0

