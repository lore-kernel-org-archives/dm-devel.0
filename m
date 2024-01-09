Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 587972C865
	for <dm-devel@lists.linux.dev>; Tue,  9 Jan 2024 15:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q2CACbbm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704812463;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=efaiUw4ksbYOOHINuk50aXrd+jNp5HJHani05/lICM8=;
	b=Q2CACbbmYZ2HwbW1YuQHhQWqC5Tez9DF7WLYWokYG5hMQMfVPPpAEe0YYVkPp2OTwaIE8t
	5/oS9vnb0N2Nujy+JrMoy66QJl0DNP8AAs3Jjp9srPW7GOX02TZaSXuUUfaX+IPRV8OQmd
	yXwTEOugtGlg7HiWkju5PX7eTieqoXw=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-367-wM51cFMkMI6g6vYyhesZPA-1; Tue,
 09 Jan 2024 10:00:59 -0500
X-MC-Unique: wM51cFMkMI6g6vYyhesZPA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0FF823C11C8A
	for <dm-devel@lists.linux.dev>; Tue,  9 Jan 2024 15:00:58 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 074DBC15E6A;
	Tue,  9 Jan 2024 15:00:58 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id E7D4730C1C03; Tue,  9 Jan 2024 15:00:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id E51693FB49;
	Tue,  9 Jan 2024 16:00:57 +0100 (CET)
Date: Tue, 9 Jan 2024 16:00:57 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Mike Snitzer <msnitzer@redhat.com>
cc: dm-devel@lists.linux.dev
Subject: [PATCH] dm-writecache: allow allocations larger than 2GiB
Message-ID: <c20860-62cc-bb15-5b24-5e7e5631977@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

The function kvmalloc_node limits the allocation size to INT_MAX. This
limit will be overflowed if dm-writecache attempts to map a device with
1TiB or larger length. This commit changes kvmalloc_array to vmalloc_array
to avoid the limit.

The commit also changes vmalloc(array_size()) to vmalloc_array().

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-writecache.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6/drivers/md/dm-writecache.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-writecache.c	2023-09-05 14:45:58.000000000 +0200
+++ linux-2.6/drivers/md/dm-writecache.c	2024-01-08 22:22:22.000000000 +0100
@@ -299,7 +299,7 @@ static int persistent_memory_claim(struc
 		long i;
 
 		wc->memory_map = NULL;
-		pages = kvmalloc_array(p, sizeof(struct page *), GFP_KERNEL);
+		pages = vmalloc_array(p, sizeof(struct page *));
 		if (!pages) {
 			r = -ENOMEM;
 			goto err2;
@@ -330,7 +330,7 @@ static int persistent_memory_claim(struc
 			r = -ENOMEM;
 			goto err3;
 		}
-		kvfree(pages);
+		vfree(pages);
 		wc->memory_vmapped = true;
 	}
 
@@ -341,7 +341,7 @@ static int persistent_memory_claim(struc
 
 	return 0;
 err3:
-	kvfree(pages);
+	vfree(pages);
 err2:
 	dax_read_unlock(id);
 err1:
@@ -962,7 +962,7 @@ static int writecache_alloc_entries(stru
 
 	if (wc->entries)
 		return 0;
-	wc->entries = vmalloc(array_size(sizeof(struct wc_entry), wc->n_blocks));
+	wc->entries = vmalloc_array(wc->n_blocks, sizeof(struct wc_entry));
 	if (!wc->entries)
 		return -ENOMEM;
 	for (b = 0; b < wc->n_blocks; b++) {

