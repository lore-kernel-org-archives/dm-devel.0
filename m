Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C268710796
	for <dm-devel@lists.linux.dev>; Tue, 28 Nov 2023 13:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Rz4bjR5Y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701179288;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=z4TF5iz33oW+fy4e+dhMXa8IUOOcpG76xPKVgc23Mqc=;
	b=Rz4bjR5YoizFd2KEN1H0KgIAS2YQzHL8Wh9u8apIYWP4dyRs+RGQmViwUQ5Y6vzvC1Gxff
	4wVg+g7fkgutKuChXjHAwFPGxF1GNfmeaCH7vNld91agtmrMIvrRLG4SebaZvGJTwbC2Bw
	xpP4XkriQ3Ek2MdBeW+qKyrWsAsZx0c=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-216-MxCGepGSMVWjBTHRTB3m4w-1; Tue, 28 Nov 2023 08:48:07 -0500
X-MC-Unique: MxCGepGSMVWjBTHRTB3m4w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C57BD101A54C
	for <dm-devel@lists.linux.dev>; Tue, 28 Nov 2023 13:48:06 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BFDE81121308;
	Tue, 28 Nov 2023 13:48:06 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id ACC9930C1A8C; Tue, 28 Nov 2023 13:48:06 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id A28F43FB76;
	Tue, 28 Nov 2023 14:48:06 +0100 (CET)
Date: Tue, 28 Nov 2023 14:48:06 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Mike Snitzer <msnitzer@redhat.com>
cc: dm-devel@lists.linux.dev
Subject: [PATCH] dm-flakey: start allocating with MAX_ORDER
Message-ID: <6c1c67fc-1fa-d9b7-6ce2-ed4f21381d9a@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Commit 23baf831a32c ("mm, treewide: redefine MAX_ORDER sanely")
changed the meaning of MAX_ORDER from exclusive to inclusive. So, we
can allocate compound pages with up to 1 << MAX_ORDER pages.

Reflect this change in dm-flakey and start trying to allocate compound
pages with MAX_ORDER.

---
 drivers/md/dm-flakey.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/md/dm-flakey.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-flakey.c	2023-09-05 14:45:58.000000000 +0200
+++ linux-2.6/drivers/md/dm-flakey.c	2023-11-28 14:41:03.000000000 +0100
@@ -434,7 +434,7 @@ static struct bio *clone_bio(struct dm_t
 
 	remaining_size = size;
 
-	order = MAX_ORDER - 1;
+	order = MAX_ORDER;
 	while (remaining_size) {
 		struct page *pages;
 		unsigned size_to_add, to_copy;

