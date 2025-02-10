Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3944623C371
	for <dm-devel@lists.linux.dev>; Mon, 10 Feb 2025 15:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739200473; cv=none; b=htzMyky3/Zxcr5+Q7ZpbHf03C5RDuiwK46xJ5vHq8Jhyh6iNnZo0Qdj8KBxGVcmLLLzUck/6VEj6JFgeEzFHBooGP/jx31Lyf1odPaxCceiNOAZ/Yr2N6KP7Ynf80i8x8TLL/94GYC7ZgNg4+JZGQhhvdABOPEZmvaEGIJ692ME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739200473; c=relaxed/simple;
	bh=UoPmzkugXE9DdhPv8nuH2Dmce2TTfPMkHCjWvDvu8BI=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=F5xzHGU3sqhOqqiXuEzQxkP8sawl4qIkNEZlge8LKg+D+JFcGkqyUwseNRUq7bHVnYMUZTzGTqoFV4AqQ1O59YERtcSfDIjdkeyIMNSLDRI7u7bXM91+S+5K1LsmirIHWdsHQolPXJF6La20bFn1KG5h2yU+LSIVIwfMYRknI9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bmG1w9v3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bmG1w9v3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739200470;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=la8NgKedPDSSX59N/H6Ii8Xk4VGtkXduxexIJ1TT2Ko=;
	b=bmG1w9v37gHx//2mru8E90lVj568W5pgxAecstbgZGR/yMKbGsyV7ib5vp2YBM0DO+G7Rz
	cycSGpufL7RfCJQ9kMI0YNzODEMEIWYqn3UAdrdW0xyzYUFaREaGpKfpJf/WWG3QzvSujk
	dckUn7sgSZiISMVQRyGS2+c8LezRmc8=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-111-yq-vgyhzOnqzqI_LohsonA-1; Mon,
 10 Feb 2025 10:14:28 -0500
X-MC-Unique: yq-vgyhzOnqzqI_LohsonA-1
X-Mimecast-MFC-AGG-ID: yq-vgyhzOnqzqI_LohsonA
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E47FA1956096;
	Mon, 10 Feb 2025 15:14:27 +0000 (UTC)
Received: from [10.45.225.131] (unknown [10.45.225.131])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 99EB21800570;
	Mon, 10 Feb 2025 15:14:26 +0000 (UTC)
Date: Mon, 10 Feb 2025 16:14:22 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: dm-devel@lists.linux.dev
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH] dm-integrity: set ti->error on memory allocation failure
Message-ID: <0568e000-4b12-1b08-d70f-d530f64aeb6e@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 1xioFSZf7b3nV9PQh6m0DYqL8ISA6rW_IwKa04AlRUk_1739200468
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

The dm-integrity target didn't set the error string when memory
allocation failed. This patch fixes it.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/md/dm-integrity.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2025-02-05 18:44:43.000000000 +0100
+++ linux-2.6/drivers/md/dm-integrity.c	2025-02-05 18:50:05.000000000 +0100
@@ -5081,16 +5081,19 @@ try_smaller_buffer:
 
 		ic->recalc_bitmap = dm_integrity_alloc_page_list(n_bitmap_pages);
 		if (!ic->recalc_bitmap) {
+			ti->error = "Could not allocate memory for bitmap";
 			r = -ENOMEM;
 			goto bad;
 		}
 		ic->may_write_bitmap = dm_integrity_alloc_page_list(n_bitmap_pages);
 		if (!ic->may_write_bitmap) {
+			ti->error = "Could not allocate memory for bitmap";
 			r = -ENOMEM;
 			goto bad;
 		}
 		ic->bbs = kvmalloc_array(ic->n_bitmap_blocks, sizeof(struct bitmap_block_status), GFP_KERNEL);
 		if (!ic->bbs) {
+			ti->error = "Could not allocate memory for bitmap";
 			r = -ENOMEM;
 			goto bad;
 		}

