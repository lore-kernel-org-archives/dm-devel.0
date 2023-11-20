Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D548739841
	for <dm-devel@lists.linux.dev>; Mon, 20 Nov 2023 22:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I5PPFOVN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700519364;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xLaKgKxq3O6edo2s0wTG5CeilgDoyjMhwqUX9j9tGYo=;
	b=I5PPFOVNf8jYarjABk2SeKb3VZXMWmkuKviICbXeqjeKMu4bwLnlSewkKlxjG7esx0cVzu
	kL8QuqEztCgjmd0lV/psvdj45hSoymlbkjG0MQtskh2sMloT7HGqQjZommRNa5cX3tqNao
	1b82Bn0I8nI9+8YI82brhQO61pQ08pE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-492-sTg0WHeJOd-knWDjWt09Lg-1; Mon, 20 Nov 2023 17:29:21 -0500
X-MC-Unique: sTg0WHeJOd-knWDjWt09Lg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2754C887E46;
	Mon, 20 Nov 2023 22:29:21 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 227CC492BE7;
	Mon, 20 Nov 2023 22:29:21 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 207A151CD0; Mon, 20 Nov 2023 17:29:21 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 4/5] dm vdo block-map: optimize enter_zone_read_only_mode
Date: Mon, 20 Nov 2023 17:29:19 -0500
Message-ID: <fbf9ab343410e6bd79d9e4225d6e30d3431839bb.1700516271.git.msakai@redhat.com>
In-Reply-To: <cover.1700516271.git.msakai@redhat.com>
References: <cover.1700516271.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Mike Snitzer <snitzer@kernel.org>

Rather than incrementally dequeue from the zone->flush_waiters
vdo_wait_queue, simply re-initialize it.

Reviewed-by: Ken Raeburn <raeburn@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/block-map.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-vdo/block-map.c b/drivers/md/dm-vdo/block-map.c
index a1f2c9d38192..7f9c4bc05f02 100644
--- a/drivers/md/dm-vdo/block-map.c
+++ b/drivers/md/dm-vdo/block-map.c
@@ -641,12 +641,10 @@ static void enter_zone_read_only_mode(struct block_map_zone *zone, int result)
 	vdo_enter_read_only_mode(zone->block_map->vdo, result);
 
 	/*
-	 * We are in read-only mode, so we won't ever write any page out. Just take all waiters off
-	 * the queue so the zone can drain.
+	 * We are in read-only mode, so we won't ever write any page out.
+	 * Just take all waiters off the waitq so the zone can drain.
 	 */
-	while (vdo_waitq_has_waiters(&zone->flush_waiters))
-		vdo_waitq_dequeue_next_waiter(&zone->flush_waiters);
-
+	vdo_waitq_init(&zone->flush_waiters);
 	check_for_drain_complete(zone);
 }
 
-- 
2.42.0

