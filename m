Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A577D21ABA0
	for <dm-devel@lists.linux.dev>; Sun,  9 Mar 2025 22:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741559355; cv=none; b=Pq7y53ivtfY2iNadv+y8nK1EJ76JIWhov4XBwiQvxxdrPayi6ijmqZX2xG3jb0oL4F6sVNTsViNPlmT1km2uHJqP1Mi+o1KRkaT9+yJsHpflQcs7qH0YoEx2DDcDpnJrcRFphvIqeAWidVGPSc5urR0KNV+e+35ugxMG1BOuLJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741559355; c=relaxed/simple;
	bh=RqpEUDKRpX+/sxS+/cAxze8je/z92gmcAuFdiNF8+no=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pVa8Dq1VSNyz7alJViOtYXIs2I09P9I3gsE+gQNSvwnkm35b6TMhCO907Fw13qTDd+UsP2Eds4Y1X+mNdelNJS12mdpJeUWMG5BrET2s3FrkQBHTfH2KzNRKJChlhH11AkXvG8X4MEnX+RiYdwk6VsvIlydZzhIWOpfbxTk2Vyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DcgRHsXr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DcgRHsXr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741559352;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y8fv7Z1eNPyvos22f4cRSlyF9ihNCLNiBcEZgwkwgFQ=;
	b=DcgRHsXrBKBURTzET+YQHInE3b6mmP4TiljnuvZYDt6BiWPzLtmJs8EvLBEdsoJFur9yJ1
	w3mGc+2e2zPLhjOl5wp7G95Y60/8qoQtY/rbI6Kxcp5rHFFqI4mYFIgi7HWRhJptUfDQ9U
	b2N9p5KPiJNqjV8vala9xMNHKzcVI2c=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-447-wGI-mortPM-MAOIgFdLTeA-1; Sun,
 09 Mar 2025 18:29:09 -0400
X-MC-Unique: wGI-mortPM-MAOIgFdLTeA-1
X-Mimecast-MFC-AGG-ID: wGI-mortPM-MAOIgFdLTeA_1741559348
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B46481800258;
	Sun,  9 Mar 2025 22:29:07 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 17A7E1956095;
	Sun,  9 Mar 2025 22:29:06 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 529MT5Ce449839
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sun, 9 Mar 2025 18:29:05 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 529MT5um449838;
	Sun, 9 Mar 2025 18:29:05 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Cc: dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
        Damien Le Moal <dlemoal@kernel.org>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5/7] blk-zoned: clean up zone settings for devices without zwplugs
Date: Sun,  9 Mar 2025 18:29:01 -0400
Message-ID: <20250309222904.449803-6-bmarzins@redhat.com>
In-Reply-To: <20250309222904.449803-1-bmarzins@redhat.com>
References: <20250309222904.449803-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Previously disk_free_zone_resources() would only clean up zoned settings
on a disk if the disk had write plugs allocated. Make it clean up zoned
settings on any disk, so disks that don't allocate write plugs can use
it as well.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 block/blk-zoned.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 761ea662ddc3..d7dc89cbdccb 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -1363,24 +1363,23 @@ static unsigned int disk_set_conv_zones_bitmap(struct gendisk *disk,
 
 void disk_free_zone_resources(struct gendisk *disk)
 {
-	if (!disk->zone_wplugs_pool)
-		return;
-
-	if (disk->zone_wplugs_wq) {
-		destroy_workqueue(disk->zone_wplugs_wq);
-		disk->zone_wplugs_wq = NULL;
-	}
+	if (disk->zone_wplugs_pool) {
+		if (disk->zone_wplugs_wq) {
+			destroy_workqueue(disk->zone_wplugs_wq);
+			disk->zone_wplugs_wq = NULL;
+		}
 
-	disk_destroy_zone_wplugs_hash_table(disk);
+		disk_destroy_zone_wplugs_hash_table(disk);
 
-	/*
-	 * Wait for the zone write plugs to be RCU-freed before
-	 * destorying the mempool.
-	 */
-	rcu_barrier();
+		/*
+		 * Wait for the zone write plugs to be RCU-freed before
+		 * destorying the mempool.
+		 */
+		rcu_barrier();
 
-	mempool_destroy(disk->zone_wplugs_pool);
-	disk->zone_wplugs_pool = NULL;
+		mempool_destroy(disk->zone_wplugs_pool);
+		disk->zone_wplugs_pool = NULL;
+	}
 
 	disk_set_conv_zones_bitmap(disk, NULL);
 	disk->zone_capacity = 0;
-- 
2.48.1

