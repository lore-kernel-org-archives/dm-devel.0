Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 882382FE59C
	for <dm-devel@lists.linux.dev>; Thu,  8 Jan 2026 19:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767902188; cv=none; b=V02mMrSLqR/1f1TLgW1NQlelQkrIHxJJza7vifU9aK+P9VYJ0TOjn4t3SkAVTUQ9xCBLfeBEZsjPWBeYYlaNX9MeZQ2ZAE4AspILZ/ccXLpnxXWeBRsVs4vXr5w3YhqrAxR2qbILEFwrOBCXGeR8oVprc/Al52tFbAzkl1zbobs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767902188; c=relaxed/simple;
	bh=8mdhflBwhEujFZUdjdL+Qhhqk9n+ScrZ7BGYXVCZqXo=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=ZdUSpiBNk8SHiEH3pmymrL7rCul8Ex0+JuBHgnmSAW/yU7PXqUmPr/X9H8RVBSCu+Clr5y9sVuEc8ylX5DPvJRyXvq94TrWsqNwMyKCLoFgNMce5j5g2nCRtcSeQuOMAwPm06KSgGGdD8UN9S6bArPrWp64lNFNINdZe8RodQSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PRiLEpRy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PRiLEpRy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767902186;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=z+zD4m+PSsrfMgufgdhaPeW/azHrAzOiqqPYN+IH6M8=;
	b=PRiLEpRyJwJtk+HQETfa53fYJAquKucF9BbYBtijDjH7qswUtMMYGYBMIDgoqtsxINDBkF
	nMpWRxDWP5ZgWqJAnqZ4yhj4eFpFOlQkVzw5Aie928MDy4bqBcBhx/e04O+HjkjuGyk8ny
	e3kejO/B+ZMHE/tGqM/Xw0OPy2fZadw=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-389-fu6VFXJQMGyUi9KXiSlOVQ-1; Thu,
 08 Jan 2026 14:56:25 -0500
X-MC-Unique: fu6VFXJQMGyUi9KXiSlOVQ-1
X-Mimecast-MFC-AGG-ID: fu6VFXJQMGyUi9KXiSlOVQ_1767902184
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8AEA71956054;
	Thu,  8 Jan 2026 19:56:24 +0000 (UTC)
Received: from [10.44.33.27] (unknown [10.44.33.27])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 221AD1956048;
	Thu,  8 Jan 2026 19:56:22 +0000 (UTC)
Date: Thu, 8 Jan 2026 20:56:20 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>
cc: dm-devel@lists.linux.dev
Subject: [PATCH] dm: use READ_ONCE in dm_blk_report_zones
Message-ID: <f99c02cf-8d0a-964d-c52b-a9a38c44ba73@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: x4yjkKzFfAnWpZN77X6JfQEumY7EKtdCyi_0FKk7gzQ_1767902184
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

The functon dm_blk_report_zones reads md->zone_revalidate_map, however it
may change while the function is running. Use READ_ONCE.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: 37f53a2c60d0 ("dm: fix dm_blk_report_zones")

---
 drivers/md/dm-zone.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/md/dm-zone.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-zone.c	2026-01-06 22:57:00.000000000 +0100
+++ linux-2.6/drivers/md/dm-zone.c	2026-01-06 22:57:00.000000000 +0100
@@ -50,7 +50,7 @@ int dm_blk_report_zones(struct gendisk *
 {
 	struct mapped_device *md = disk->private_data;
 	struct dm_table *map;
-	struct dm_table *zone_revalidate_map = md->zone_revalidate_map;
+	struct dm_table *zone_revalidate_map = READ_ONCE(md->zone_revalidate_map);
 	int srcu_idx, ret = -EIO;
 	bool put_table = false;
 

