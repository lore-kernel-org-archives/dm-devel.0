Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95EE1E3791
	for <dm-devel@lists.linux.dev>; Mon, 20 Jan 2025 15:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737386201; cv=none; b=VYDnJzcyE3M8d5Xrs/gxqVJhqrsdbQpMqJZN6H82uS311svS48tZtwdP2SeSZt/JYa80G3Msl+0S/EOFqlpu2/dZIU7OD6wT8sUhCJetohrYiO0gURVrfIoxpL0Y9uDAOxQYc5QBiQjqComgVaw+lVlHkuBQUiHoMGy+tRjDkDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737386201; c=relaxed/simple;
	bh=N/09wP0BL+H92OwKbasER3ehiHFLHhxOkwKi4aXhZqU=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=GHQAFdBQC8HrH1OeG224q1+XyfuSygKv7jFts0M9p1APkn0baBxGGQQWr8jQoUYp8XHnS70QJ1xUZf5H9k48PnsJPJJuiY3AQvYBXJJxjvu9tTk1F6v+PeBuS46RzRPhdFwgm4P0srZb1Nzu8M4n/E7UaatAWT9xpPN1NIYfo04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cUo11nGJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cUo11nGJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737386198;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=DtCbR8FTF1GLHpSQcORCkWOKw6JmrqvTdAcRj4GwZpE=;
	b=cUo11nGJwdm9HUwntsf0pHC3k4Z8qd53ysJpYvMPoW8keHLZWHZoYAUlrkK3ID6yNRFusT
	NHp2FrC/tpbeCjPk/H8r7N+ftDpBZejbNAT0WXAIuT0vXGMk8dBsQKSHtomK+mEX9Rx3c/
	79cG2B/N9pSESyQhPJT/1LxuZRqhWIE=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-530-JwY416IONamA_MimYDbvow-1; Mon,
 20 Jan 2025 10:16:35 -0500
X-MC-Unique: JwY416IONamA_MimYDbvow-1
X-Mimecast-MFC-AGG-ID: JwY416IONamA_MimYDbvow
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 977971955DCD;
	Mon, 20 Jan 2025 15:16:33 +0000 (UTC)
Received: from [10.45.224.57] (unknown [10.45.224.57])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C08C53003E7F;
	Mon, 20 Jan 2025 15:16:31 +0000 (UTC)
Date: Mon, 20 Jan 2025 16:16:26 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Zdenek Kabelac <zkabelac@redhat.com>, linux-block@vger.kernel.org, 
    dm-devel@lists.linux.dev
Subject: [PATCH] blk-settings: round down io_opt to at least 4K
Message-ID: <81b399f6-55f5-4aa2-0f31-8b4f8a44e6a4@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Some SATA SSDs and most NVMe SSDs report physical block size 512 bytes,
but they use 4K remapping table internally and they do slow
read-modify-write cycle for requests that are not aligned on 4K boundary.
Therefore, io_opt should be aligned on 4K.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: a23634644afc ("block: take io_opt and io_min into account for max_sectors")
Fixes: 9c0ba14828d6 ("blk-settings: round down io_opt to physical_block_size")
Cc: stable@vger.kernel.org	# v6.11+

---
 block/blk-settings.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: linux-2.6/block/blk-settings.c
===================================================================
--- linux-2.6.orig/block/blk-settings.c	2025-01-03 21:10:56.000000000 +0100
+++ linux-2.6/block/blk-settings.c	2025-01-20 15:59:13.000000000 +0100
@@ -269,8 +269,12 @@ int blk_validate_limits(struct queue_lim
 	 * The optimal I/O size may not be aligned to physical block size
 	 * (because it may be limited by dma engines which have no clue about
 	 * block size of the disks attached to them), so we round it down here.
+	 *
+	 * Note that some SSDs erroneously report physical_block_size 512
+	 * despite the fact that they have remapping table granularity 4K and
+	 * they perform read-modify-write for unaligned requests.
 	 */
-	lim->io_opt = round_down(lim->io_opt, lim->physical_block_size);
+	lim->io_opt = round_down(lim->io_opt, max(4096, lim->physical_block_size));
 
 	/*
 	 * max_hw_sectors has a somewhat weird default for historical reason,

