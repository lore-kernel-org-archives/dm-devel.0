Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EE7D803
	for <dm-devel@lists.linux.dev>; Wed, 17 Jul 2024 00:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721176359; cv=none; b=Dxvz65vLCqK1R8DcavoSlGJXSBlccLIF7fzAJTjsotllVkEKrHF5123pLgLaU6LlyZwcKJ67RXwwNvmzLnzjzFLI3LJgcNo/PRwAZbRz5/DabojRUyDDGn8DqDqtxGUBIDB87HVAY3UzXPDDfsXrErH7PwC33p2ZSM7E+VjAHNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721176359; c=relaxed/simple;
	bh=PXDVUWAuyhsPRpYPUBjXm3iF8cuoshZHW5TkQafAl44=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=eFSAAefFVCVEQjn4i3TzKzRtzy2U5yofrPkryRCJiNunqIi+hdEI9kWkYOGObKGOrpymDefpvUjgpbo/84IaDXVlpL77qKEtHl07AS6YBqICvvL/azqkgYECpe9QJ0qMeFoWRU89pCaWJWXzStx7wyJzOcDcctSt180F7kWTif4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=assbZGyL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="assbZGyL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721176356;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ODO1/f6Oqw8iDIRAdj4wuoYPdx3kXAy7ZEzoJ+ojSyA=;
	b=assbZGyL8oyLFFeu5uvdXQrpOFj1GqxjHmvPBnduADwnxpDo0VuTWh711wr4WEogoKz3hG
	UQaOCiF9aCrXJC3JVl2K5gt1urxhcmHpa48rA6Jb2/+DAqbQ/5gU/hTmSgNPgLiC31ArSW
	X3yntZdIwrhoddcXMTD95TUqm6MwucM=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-582-pc8HuS6zOhmUcInZXPn9LA-1; Tue,
 16 Jul 2024 20:32:35 -0400
X-MC-Unique: pc8HuS6zOhmUcInZXPn9LA-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 877EF19560B4
	for <dm-devel@lists.linux.dev>; Wed, 17 Jul 2024 00:32:34 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DDD62300018F;
	Wed, 17 Jul 2024 00:32:33 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 6037C532A1; Tue, 16 Jul 2024 20:32:33 -0400 (EDT)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Matthew Sakai <msakai@redhat.com>
Subject: [PATCH] dm vdo int-map: fix kerneldoc formatting
Date: Tue, 16 Jul 2024 20:32:33 -0400
Message-ID: <b636b3257d039e13a0f28edb2560a922c9b40257.1721156276.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202407141607.M3E2XQ0Z-lkp@intel.com/
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/int-map.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-vdo/int-map.c b/drivers/md/dm-vdo/int-map.c
index 3aa438f84ea1..f6fe58e437b3 100644
--- a/drivers/md/dm-vdo/int-map.c
+++ b/drivers/md/dm-vdo/int-map.c
@@ -96,7 +96,7 @@ struct int_map {
 	size_t size;
 	/** @capacity: The number of neighborhoods in the map. */
 	size_t capacity;
-	/* @bucket_count: The number of buckets in the bucket array. */
+	/** @bucket_count: The number of buckets in the bucket array. */
 	size_t bucket_count;
 	/** @buckets: The array of hash buckets. */
 	struct bucket *buckets;
-- 
2.45.2

