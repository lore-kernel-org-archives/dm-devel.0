Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E34E955C1B
	for <dm-devel@lists.linux.dev>; Mon, 18 Mar 2024 17:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710783311; cv=none; b=ONpxqiCaFCpGagf1R6kIzYucaIKAX9eoGEtECf9TvkEfFMUNOS9Bpom71X2QmNgD16QPz5Z8EbNJq2jM9BabQq4L5/5OZjeEdZWwj1YcuvBW0ADZmgKVgQzzHBrnVpagtBZ7meAgjwcR43nRZdnVomoL0A3ZOAGP8/InZlMv6UE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710783311; c=relaxed/simple;
	bh=y7zjipBGFtRpbf9NLMXi4Rg8sUFg3lALcWQT8mBuKUo=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=icAsBT/EVpQlo/5PYa8zTLdH+HZZtml5L3fLwiGRqNmZjyItGRv7UOBZ5f/aHc6IdLjaXjNFZspUkNl9rFXXme+Iz8b8T0NNUPNW1jLHs8CLQ/G++QlW9yG694lw4Ef7Q0Kr6fLUPERGFbILY5YuoEjznTLaq+qrxBDhd++20zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WmJ8rRgH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WmJ8rRgH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710783308;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=WHyUkwHDdTbJXHl09i29EVxE8QnrFiJ/PmbYHpQP5rY=;
	b=WmJ8rRgHsXuh/kdnNZEJtf1YL0QlI0xtMTdVm7psYJNNuGQRil9nYTriLbitNKwFVJPQKI
	uk4lfosAxU+syFPJBLJT39IJ6tE9WoPFq2XfpeIwYKmNntQUuiqfKHl21Pwt6ThDE4CG3x
	iIYPZt2HvgrMSVB/fSZI9fOcA/pIjw8=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-589-cGzYYrYAM66by1Zz1DOOAg-1; Mon,
 18 Mar 2024 13:35:06 -0400
X-MC-Unique: cGzYYrYAM66by1Zz1DOOAg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8322A380390B
	for <dm-devel@lists.linux.dev>; Mon, 18 Mar 2024 17:35:06 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7E06D1C060A4;
	Mon, 18 Mar 2024 17:35:06 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 6B35130C729B; Mon, 18 Mar 2024 17:35:06 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 69D8A43501;
	Mon, 18 Mar 2024 18:35:06 +0100 (CET)
Date: Mon, 18 Mar 2024 18:35:06 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Mike Snitzer <msnitzer@redhat.com>, 
    Benjamin Marzinski <bmarzins@redhat.com>
cc: dm-devel@lists.linux.dev
Subject: [PATCH] dm-integrity: fix a memory leak when rechecking the data
Message-ID: <4251f231-3423-b664-645d-33f88ada492@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

When we recheck the data after checksum failure, and the recheck is
successful, we would leak the "checksums" pointer.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: c88f5e553fe3 ("dm-integrity: recheck the integrity tag after a failure")
Cc: stable@vger.kernel.org

---
 drivers/md/dm-integrity.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2024-03-11 12:53:59.000000000 +0100
+++ linux-2.6/drivers/md/dm-integrity.c	2024-03-18 17:40:57.000000000 +0100
@@ -1848,12 +1848,12 @@ again:
 			r = dm_integrity_rw_tag(ic, checksums, &dio->metadata_block, &dio->metadata_offset,
 						checksums_ptr - checksums, dio->op == REQ_OP_READ ? TAG_CMP : TAG_WRITE);
 			if (unlikely(r)) {
+				if (likely(checksums != checksums_onstack))
+					kfree(checksums);
 				if (r > 0) {
-					integrity_recheck(dio, checksums);
+					integrity_recheck(dio, checksums_onstack);
 					goto skip_io;
 				}
-				if (likely(checksums != checksums_onstack))
-					kfree(checksums);
 				goto error;
 			}
 

