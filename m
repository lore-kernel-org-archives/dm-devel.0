Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF5B035963
	for <dm-devel@lists.linux.dev>; Mon, 10 Feb 2025 15:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739200531; cv=none; b=T/cFmIOlscj39DTRP4The7M3wbDWo2qJ6kS51lkZMQlM5H/Rzo1rm8vnG0Qukr6AAdYNTEJmalv++XB7dMdoUqywd8acV/YY0KiuMn5MkbYFKz25Zz3oOLV0eog19QfNNivjX+kYtM3hEinL4MeB2h6BhHyDP6W81w/NuCiihy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739200531; c=relaxed/simple;
	bh=3L5nxYZ/GzQzET/SgD/4ZbHScudgbg2pLbuHJfr38uA=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=oIavpBdfrDM5xTViSTESrA7sR761tAOitJIcq3yk3FqvoTMatpM2XHVT1J03nY+7nYE7alJp4vAd9OoDWy12dTJim6vBiWoGM/PylaNP4b7fLgijTB2wzn628Tn7lOvymGtqZmWk1O3QvoqcwJyhGsenvZKXIFEEeYHDjEL5gVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gLafW5tQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gLafW5tQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739200528;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=DnU5YmxJy49yfzmlQt85hlfAmQ/vxHu8MybmXT2kom8=;
	b=gLafW5tQ2F6qKXO1VeQu2pvp0tHu+G0PpOFOmpI2VcU0W9FF5Sk8kI6oc+2Bd58HSwlRTF
	1/PWbu4C8nGFDGoXD2Fgjn995b4Vf6bZ/11LUhDYtrD8w95eG/LvqdRL/H3OvlTOJ01BKS
	Kxx4+Ia+DWzLbiIRKapoADGwnPcNXAk=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-232-cy0HOlD2M22W-pADlMfy2w-1; Mon,
 10 Feb 2025 10:15:27 -0500
X-MC-Unique: cy0HOlD2M22W-pADlMfy2w-1
X-Mimecast-MFC-AGG-ID: cy0HOlD2M22W-pADlMfy2w
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5F0BF1800879;
	Mon, 10 Feb 2025 15:15:26 +0000 (UTC)
Received: from [10.45.225.131] (unknown [10.45.225.131])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2974A1800570;
	Mon, 10 Feb 2025 15:15:24 +0000 (UTC)
Date: Mon, 10 Feb 2025 16:15:22 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: dm-devel@lists.linux.dev
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH] dm-bufio: remove unused return value
Message-ID: <35bd630a-ed59-54d8-c77c-3f4960830688@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: lnV2hDbPq4iDOw877Vkgb1JGAxnawWsY_shr9yzvvkU_1739200526
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

The return value of the function "forget_buffer" is not tested, so we can
remove it.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-bufio.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

Index: linux-2.6/drivers/md/dm-bufio.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-bufio.c	2025-01-03 21:10:56.000000000 +0100
+++ linux-2.6/drivers/md/dm-bufio.c	2025-02-10 16:05:57.000000000 +0100
@@ -2234,7 +2234,7 @@ int dm_bufio_issue_discard(struct dm_buf
 }
 EXPORT_SYMBOL_GPL(dm_bufio_issue_discard);
 
-static bool forget_buffer(struct dm_bufio_client *c, sector_t block)
+static void forget_buffer(struct dm_bufio_client *c, sector_t block)
 {
 	struct dm_buffer *b;
 
@@ -2249,8 +2249,6 @@ static bool forget_buffer(struct dm_bufi
 			cache_put_and_wake(c, b);
 		}
 	}
-
-	return b ? true : false;
 }
 
 /*

