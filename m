Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D17329C77
	for <dm-devel@lists.linux.dev>; Mon, 17 Nov 2025 20:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763412142; cv=none; b=kbpSpzdze4K/4BWOtvwdwifmTIhZfE/ypd49ssDl2v7IdW0lQ3gH8xDgZyJj121kGg5qDdHXzX87CUAhh61Tw+0J0JLIgEPYByG4O1REij8C8Y8df0ZVDyYUCJqudP7lwHIQKBtjc4sEkAJP+Rv24vSowiW9y49YPOstZJZGS2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763412142; c=relaxed/simple;
	bh=oxm+py6oTw6jW/oGtxKe6cf5GImMBgpaiBqqYd0Yrj4=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=gfpwiPSEgbK+Ry0Wa1SSR67nnJLPBmzU1MI6R/WGAk7q7yOkQYhMz1MhGc2LDEIQVnx1c3CjzhWoAZOB/oCWXRkt22J9rgAFb4j1gPHYSS5TjGBwnF1IYEfXL1WVruFUbDcgvl5chigG9Ps8lCb8tYybZ/BrsY77tnPxL2YD5SA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OvO6AKp5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OvO6AKp5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763412139;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=/+pHjH2ipP+YKCGYitO1VWx4JXk5Yy2lmWsmKGcCUN8=;
	b=OvO6AKp5Qd4gF8ENxSI4/js/ccVn+CQFOeatk0Oq5wS+QokEUZiHhsFAPtWOhLNi+kjj6V
	vnaDeOYeun1pk/fok8z+KmpawFG56nsxRZ9y52Osd0y3f4QaABB0dzsFaFioeHiSbPgAet
	A8kieY2m3LHIzYIEu8//uweo04fte6o=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-683-78VmUfYJNbOsqvZpqDpkrA-1; Mon,
 17 Nov 2025 15:42:18 -0500
X-MC-Unique: 78VmUfYJNbOsqvZpqDpkrA-1
X-Mimecast-MFC-AGG-ID: 78VmUfYJNbOsqvZpqDpkrA_1763412137
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1988B19373D8;
	Mon, 17 Nov 2025 20:42:17 +0000 (UTC)
Received: from [10.44.32.60] (unknown [10.44.32.60])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EDD6B19560A7;
	Mon, 17 Nov 2025 20:42:14 +0000 (UTC)
Date: Mon, 17 Nov 2025 21:42:02 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Sami Tolvanen <samitolvanen@google.com>, Alasdair Kergon <agk@redhat.com>, 
    Mike Snitzer <snitzer@kernel.org>
cc: dm-devel@lists.linux.dev, Ondrej Kozina <okozina@redhat.com>, 
    Milan Broz <gmazyland@gmail.com>
Subject: [PATCH] dm-verity: fix unreliable memory allocation
Message-ID: <0da5850a-05ee-6cff-3c25-e2c9037c52eb@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: bu69xrMkyMHgo8HsHM-qeu81jVIJMFCo-KxO2suk6bk_1763412137
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

GFP_NOWAIT allocation may fail anytime. It needs to be changed to 
GFP_NOIO. There's no need to handle an error because mempool_alloc with 
GFP_NOIO can't fail.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/md/dm-verity-fec.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

Index: linux-2.6/drivers/md/dm-verity-fec.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-verity-fec.c	2025-11-15 15:59:23.000000000 +0100
+++ linux-2.6/drivers/md/dm-verity-fec.c	2025-11-15 16:01:23.000000000 +0100
@@ -320,11 +320,7 @@ static int fec_alloc_bufs(struct dm_veri
 		if (fio->bufs[n])
 			continue;
 
-		fio->bufs[n] = mempool_alloc(&v->fec->prealloc_pool, GFP_NOWAIT);
-		if (unlikely(!fio->bufs[n])) {
-			DMERR("failed to allocate FEC buffer");
-			return -ENOMEM;
-		}
+		fio->bufs[n] = mempool_alloc(&v->fec->prealloc_pool, GFP_NOIO);
 	}
 
 	/* try to allocate the maximum number of buffers */

