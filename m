Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA49BE566
	for <dm-devel@lists.linux.dev>; Mon,  4 Mar 2024 20:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709585132; cv=none; b=oiKOsvkKhIkqepOVBl/oHFrVvR6kOH6y+K76PHVhnYNtWrYgibpznl3Ocg/olwIN4l8Ho8iQOI7AN6xUlvxBOo+oS78R51v37sQlmKA+pCWXcIrfHRm8uwpv2cYbIxpkZzbuxSdG4DCySYePdr5mh2B46cT9gUHAwE8ua6XVgYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709585132; c=relaxed/simple;
	bh=l6SLw/vwkUWu5/KZ0G9n1sizLdtb8S2ubTadLU9SsaA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=RBWK0UgkZ7ZEXdeGVCZxOH+sJ5NFlcqaAUcOJe+XzkiwFgJt06cCYUcrbhcZ3OJbJhQnEb327143MOI1+K9bB0QhMJRy38ukSAUruiHaWpUkdpT8/4gB6BQVR+Bs7c06qlF/VXme8/YNr707+u1XsC+KGO0qSd92hWBMKt/jmbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H7ETgtSB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H7ETgtSB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709585129;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=BSBsxVjfTZOmYd6TGVKpZ4kHELVbOSLoiYNp7vLSrro=;
	b=H7ETgtSBIgB06wyoabx6GIsbIogWdoWFQZR0zX24MaaXG17Bt5dj7OXsdC/VaEszQheL5/
	sM/bQKflDgSwr2y/98PHDKfL8e9kbcy03gHzkVczA8723Hm82897Iu4DDpx4aL63g2mnSt
	0f3Le2IGm+YU4KKXtuqygBI7Z6j4Bn8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-626-8FD31hofOECPcTneRlrldQ-1; Mon, 04 Mar 2024 15:45:26 -0500
X-MC-Unique: 8FD31hofOECPcTneRlrldQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 330D4863065;
	Mon,  4 Mar 2024 20:45:26 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2DE2D492BE2;
	Mon,  4 Mar 2024 20:45:26 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 28D6BA29F4; Mon,  4 Mar 2024 15:45:26 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Yang Li <yang.lee@linux.alibaba.com>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH] dm vdo: remove unneeded semicolon
Date: Mon,  4 Mar 2024 15:45:26 -0500
Message-ID: <5afbc291bbdf92cc7cd99d58fd35be264676a1ab.1709584943.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Yang Li <yang.lee@linux.alibaba.com>

Remove the unnecessary semicolon at the end of the for statement
which cleans up the code and ensures consistency with the rest
of the kernel coding style.

Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/block-map.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-vdo/block-map.c b/drivers/md/dm-vdo/block-map.c
index e79156dc7cc9..a0a7c1bd634e 100644
--- a/drivers/md/dm-vdo/block-map.c
+++ b/drivers/md/dm-vdo/block-map.c
@@ -2705,7 +2705,7 @@ void vdo_traverse_forest(struct block_map *map, vdo_entry_callback_fn callback,
 
 		cursor->waiter.callback = launch_cursor;
 		acquire_vio_from_pool(cursors->pool, &cursor->waiter);
-	};
+	}
 }
 
 /**
-- 
2.42.0

