Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793990601;
	b=ETvxhtApd/AHUvZSSJAiVK+OfbQOjqeeFQhxCGv1HR32PYb81SBBTDQxko+agMhfXlTC
	 50SotquNy78Az6/tx7f5s3ZA0/blXuyUTlVVAvEh0pFRd52L3LlZJBDGbe/Nz5hBHeqOk
	 j9pXXtZRaL1GWjHUTJuSn+OYSdattZJoCyKCBrpjmAtL1ZLOGXVMWRMy9eS15biGrogRc
	 GBOWdqLinauloFY+/0mu9EjiJYbUj4BQpswP5hkT1aRWf3HVksuEDvg/ZkaFORGUgnQin
	 UPBp47vNOXCkti6gO3qNsSda5gO4+r2aOCR2HaiqBjHm37efAWqTmG43d+DJb36qnuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793990601;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Date:From:To:cc:Subject:
	 Message-ID:MIME-Version:X-Scanned-By:X-Mimecast-Spam-Score:
	 X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:Content-Type;
	bh=bPeou7BEYm9C9/PhUffIlSlk6gVMToEaaW03FYyzg3o=;
	b=C7nILUq2qb/Qe3pcTOpcXFOLx+PTWhHKfvdvpQBIXCxVEfmFeGP6kc5ihd22pYzGNpRC
	 zJPD+t4AZKWQiOHIU+1e/LTjidOoLeIS/xjax0UkdSxP4bAY+zzsgtnwlpr1pO7Bi1XkI
	 Uwb6lQ4ajmUTAmzK02JrUkgP+BGXe1YaUas6IZYFH8nusYkN2+yVp/tySZKg0bPSpGTxq
	 8BUI05LHziTMsbiPiFR5DX1P2QOroMX53AYsRlmFY8CTFs9+ssSPXnS8rtZVm/QNjICZ3
	 b+I97VPxfGcsk599Xafi/gDgDMROAc8KZ4klCjCExJW9HuUKWVChywjaruxehAq5ofg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b="J9/n2Kcv";
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47909606A329
	for <dm-devel@lists.linux.dev>; Fri,  6 Nov 2026 18:43:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 47909606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=J9/n2Kcv
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793990600;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=bPeou7BEYm9C9/PhUffIlSlk6gVMToEaaW03FYyzg3o=;
	b=J9/n2Kcv/ei4UCc0CxEcCYNTSCFM8ucy0m7K4iUr0FDqd+xIgeWafQk88QHMOd+1XRXH2w
	0u0Ejr5TaAeg3hEoG9Z1Cmz/+yBTFZIJbeCQ/dnwznem+dZ+53Vosljt040qf5p6e+z01n
	hIDBcAX0VhnfnNfu9tVj7NlcYe/fuKk=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-178-QObENiuBPWi3VCqw78kXvA-1; Fri,
 06 Nov 2026 13:43:19 -0500
X-MC-Unique: QObENiuBPWi3VCqw78kXvA-1
X-Mimecast-MFC-AGG-ID: QObENiuBPWi3VCqw78kXvA_1793990598
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 256B819560BB;
	Fri,  6 Nov 2026 18:43:18 +0000 (UTC)
Received: from mpatocka-thinkpadx1carbongen12.rmtcz.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DC63618004E9;
	Fri,  6 Nov 2026 18:43:16 +0000 (UTC)
Date: Fri, 6 Nov 2026 19:43:14 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>
cc: dm-devel@lists.linux.dev
Subject: [PATCH] dm-thin: fix leak if __set_snapshot_details fails
Message-ID: <6a3e4a64-3719-3a3f-1d51-1a7b478e046e@redhat.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _btImxbjoaJe-IgSb8wm81dG5t0Mus3nyYPZjpuJY68_1793990598
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

If __set_snapshot_details fails, the variable td is leaked - this
prevents any other snapshot with the same id from being created.

Fix this by removing it from the list and freeing it.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-5
Cc: stable@vger.kernel.org
Fixes: 991d9fa02da0 ("dm: add thin provisioning target")

---
 drivers/md/dm-thin-metadata.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/md/dm-thin-metadata.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-thin-metadata.c
+++ linux-2.6/drivers/md/dm-thin-metadata.c
@@ -1225,10 +1225,13 @@ static int __create_snap(struct dm_pool_
 	__close_device(td);
 
 	if (r)
-		goto bad;
+		goto bad2;
 
 	return 0;
 
+bad2:
+	list_del(&td->list);
+	kfree(td);
 bad:
 	dm_btree_remove(&pmd->tl_info, pmd->root, &key, &pmd->root);
 	dm_btree_remove(&pmd->details_info, pmd->details_root,

