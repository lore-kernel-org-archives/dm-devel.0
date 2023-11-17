Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE3312E5C
	for <dm-devel@lists.linux.dev>; Fri, 17 Nov 2023 17:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QZYDBG2e"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700242715;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=FA8PWjrKotrLjBIHTOjzJ0frLnyfvw+F3oVeb/bLmqc=;
	b=QZYDBG2eLb35AxBEUAR3q7z9/1rkQyV+oTkqxIhoQpETh5b+DmaJEdsqTHCoMvX9iHJMCZ
	zIi0DzlqsC9tHAQrGR9a/lPuYc2l9PCr4XY3XucKeoiCSkpBuJgPlAwKcgqfWMZD6XJ1Yk
	S4A2t6fNe6mwjuEiF1frHWHiJIlhXLI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-241--QANTGExM-WtlxR6IXcRvw-1; Fri, 17 Nov 2023 12:38:33 -0500
X-MC-Unique: -QANTGExM-WtlxR6IXcRvw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9E7A381B160
	for <dm-devel@lists.linux.dev>; Fri, 17 Nov 2023 17:38:33 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 96DD52026D4C;
	Fri, 17 Nov 2023 17:38:33 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 8E9B130C1A8C; Fri, 17 Nov 2023 17:38:33 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 8DEE33FB76;
	Fri, 17 Nov 2023 18:38:33 +0100 (CET)
Date: Fri, 17 Nov 2023 18:38:33 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Mike Snitzer <msnitzer@redhat.com>
cc: dm-devel@lists.linux.dev
Subject: [PATCH] dm-crypt: start allocating with MAX_ORDER
Message-ID: <e8d54df0-5cd1-2dd4-ca3e-7f7ef5fe8aaf@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

The patch 23baf831a32c ("mm, treewide: redefine MAX_ORDER sanely") changed
the meaning of MAX_ORDER from exclusive to inclusive. So, we can allocate
compound pages with up to 1 << MAX_ORDER pages.

Reflect this change in dm-crypt and start trying to allocate compound
pages with MAX_ORDER.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-crypt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/md/dm-crypt.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-crypt.c	2023-11-17 17:43:13.000000000 +0100
+++ linux-2.6/drivers/md/dm-crypt.c	2023-11-17 17:43:13.000000000 +0100
@@ -1673,7 +1673,7 @@ static struct bio *crypt_alloc_buffer(st
 	unsigned int nr_iovecs = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	gfp_t gfp_mask = GFP_NOWAIT | __GFP_HIGHMEM;
 	unsigned int remaining_size;
-	unsigned int order = MAX_ORDER - 1;
+	unsigned int order = MAX_ORDER;
 
 retry:
 	if (unlikely(gfp_mask & __GFP_DIRECT_RECLAIM))

