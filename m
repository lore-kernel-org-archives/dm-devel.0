Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794927497;
	b=wvQGknBu1LbBz3IDgojnObGWszFUpj1PBbVpsaVkUp6xl5MJzppF+zjWAZQ7u7xd4fn0
	 QRi7tgPuZ45MdpITP3dFjgdiE+SOvjfR3lpBLT6u9utCirmUyMfpQpCMkKTFqkLnBE68u
	 utQee2B0hFCQ3xkNZ8XNPKjmmJEW3BJT3IZsDY2fQNDlWWp7DngoikSqwnkHDGBH0WAg9
	 QwhnkX/V6mPIGI2DplGeKGolP5hdy1P+fbtkh935gqmGVeWt1DnL+9UPeNFBEpdNBbgIO
	 w4lmTXl94spxY+m7A0drEC9X3O1d39MFQhjeTihgY1gC6AmvvJdBusIhURxqc0LNMbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794927497;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:MIME-Version:X-Scanned-By:X-Mimecast-Spam-Score:
	 X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:
	 Content-Transfer-Encoding:content-type;
	bh=1shAETC3SJeIpe96YEpTJTZtDKnjaho6oF8ppd/EmEk=;
	b=adjQ0dHheZ2DJtMOI/AJMGxKjXPoIdzDyQDLy6P4TrhRpeoJKjR0obJF4nyKTMcfZahw
	 Equjxie1Ln8aRyBF9O7z8/yk6IJK2vVVU0wTqPKP78iSDO9IWxbPyS0+SMqX1l9gWd/NY
	 8IFxAZa4eS2YOL22C5J9i3utrzwXags35dsQjhk3qNlb0n9qrRMcrlQLrU//pkYOQJ17K
	 zNfc/6le1cJ7g6TJ9GSCkhGlN3tjw52tIuWB5t3AcEMxX1+eTowT0DY8Fx7sXG9JJFNbH
	 tg2isMBKrYWF17sGO90rJOvqy4qNdyQ7DXIEdsWSDG5NbnpXcKzyI2i6T8u+4cG+7WA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=V15t+EnE;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD4E9606A335
	for <dm-devel@lists.linux.dev>; Tue, 17 Nov 2026 14:58:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DD4E9606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=V15t+EnE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794927495;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=1shAETC3SJeIpe96YEpTJTZtDKnjaho6oF8ppd/EmEk=;
	b=V15t+EnEZ6937B6dkKUy/sDG52asRdOwCc0oaQ307Y98EfWzqYmDv9T2IZk/qj0a79bLkx
	WB13dvxX5YgKsIuf44B+RHBBIBWDHklATpOl9hYHUfFcwqwUut3WsNWjujNFBUZf2zvTmK
	6KJuvTw3gxGXuwJ2KnzMjr8iZzRc5Ig=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-226-E-T3gkwnOqK3g5Cf3QL-AQ-1; Tue,
 17 Nov 2026 09:58:14 -0500
X-MC-Unique: E-T3gkwnOqK3g5Cf3QL-AQ-1
X-Mimecast-MFC-AGG-ID: E-T3gkwnOqK3g5Cf3QL-AQ_1794927492
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5529A1955F73;
	Tue, 17 Nov 2026 14:58:12 +0000 (UTC)
Received: from localhost (unknown [10.64.240.3])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1BB5B1956059;
	Tue, 17 Nov 2026 14:58:09 +0000 (UTC)
From: Ming-Hung Tsai <mtsai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	Ben Marzinski <bmarzins@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Ming-Hung Tsai <mtsai@redhat.com>
Subject: [PATCH] dm thin metadata: don't remove nonexistent details if create_snap fails
Date: Tue, 17 Nov 2026 22:57:58 +0800
Message-ID: <20261117145758.66590-1-mtsai@redhat.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: NpMREB3cEnNomWbU0WbiKq4BZD7lAfViDAaC0JXg9LA_1794927492
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

When __create_snap() fails after the mapping tree insertion, the error
path at the bad: label tries to revert the details tree, which is
unnecessary. The details entry is not present during __create_snap(),
so dm_btree_remove() returns -ENODATA.

The failed removal leaves the metadata inconsistent. Even on -ENODATA,
the removal is not a no-op. It leaks shadow copies and drops the old
root's reference count, while details_root still points at the old root.
The next metadata commit writes this stale details_root and the leaked
blocks to disk, corrupting the metadata.

Fix by removing the dm_btree_remove() call on the details tree.

Fixes: 991d9fa02da0 ("dm: add thin provisioning target")
Signed-off-by: Ming-Hung Tsai <mtsai@redhat.com>
---
 drivers/md/dm-thin-metadata.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index 03df0b1aab78..88c3342ef4df 100644
--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -1234,8 +1234,6 @@ static int __create_snap(struct dm_pool_metadata *pmd,
 	kfree(td);
 bad:
 	dm_btree_remove(&pmd->tl_info, pmd->root, &key, &pmd->root);
-	dm_btree_remove(&pmd->details_info, pmd->details_root,
-			&key, &pmd->details_root);
 	return r;
 }
 
-- 
2.49.0

