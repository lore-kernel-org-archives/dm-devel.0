Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97847387
	for <dm-devel@lists.linux.dev>; Fri,  1 Dec 2023 00:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HtBkJ+Bx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701392098;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=1RqkUZ4a8hcttU9zAcb93Q61dtuGisWIOd3vyHzECKI=;
	b=HtBkJ+BxZPod5nMcSzL51bXw4gb25iB/ezeH/yzuN5MbbUVV3/xG9GIM7h1+8usa4O+kJ7
	/D7y9UAVfaF6QpOr2oGbNIMc+KNBd7uAwKyIfK7lvZVEtqaQ+da4Pa1pkqZi2dN5vfQYOl
	IbKqDDcqS102k2snolRJOJa5HcRfIgI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-97-HeZ-g078ONe8EMuUjBUkog-1; Thu, 30 Nov 2023 19:54:56 -0500
X-MC-Unique: HeZ-g078ONe8EMuUjBUkog-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 95329811E7E;
	Fri,  1 Dec 2023 00:54:56 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8FEB42166B26;
	Fri,  1 Dec 2023 00:54:56 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 836BE52635; Thu, 30 Nov 2023 19:54:56 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH] dm vdo: fix how dm_kcopyd_client_create() failure is checked
Date: Thu, 30 Nov 2023 19:54:56 -0500
Message-ID: <7e331c292fb28930e9a9a0062b179eb5797ad90e.1701391400.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Mike Snitzer <snitzer@kernel.org>

dm_kcopyd_client_create() returns an ERR_PTR so its return must be
checked with IS_ERR().

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Chung Chung <cchung@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo-target.c     | 8 ++++++--
 drivers/md/dm-vdo/slab-depot.c | 7 +++++--
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-vdo-target.c b/drivers/md/dm-vdo-target.c
index 72d2291dd93f..4fbc148681e5 100644
--- a/drivers/md/dm-vdo-target.c
+++ b/drivers/md/dm-vdo-target.c
@@ -8,6 +8,7 @@
 #include <linux/completion.h>
 #include <linux/delay.h>
 #include <linux/device-mapper.h>
+#include <linux/err.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
@@ -1683,8 +1684,11 @@ static int grow_layout(struct vdo *vdo, block_count_t old_size, block_count_t ne
 	/* Make a copy completion if there isn't one */
 	if (vdo->partition_copier == NULL) {
 		vdo->partition_copier = dm_kcopyd_client_create(NULL);
-		if (vdo->partition_copier == NULL)
-			return -ENOMEM;
+		if (IS_ERR(vdo->partition_copier)) {
+			result = PTR_ERR(vdo->partition_copier);
+			vdo->partition_copier = NULL;
+			return result;
+		}
 	}
 
 	/* Free any unused preparation. */
diff --git a/drivers/md/dm-vdo/slab-depot.c b/drivers/md/dm-vdo/slab-depot.c
index 2125e256aa86..56d975c98752 100644
--- a/drivers/md/dm-vdo/slab-depot.c
+++ b/drivers/md/dm-vdo/slab-depot.c
@@ -7,6 +7,7 @@
 
 #include <linux/atomic.h>
 #include <linux/bio.h>
+#include <linux/err.h>
 #include <linux/log2.h>
 #include <linux/min_heap.h>
 #include <linux/minmax.h>
@@ -3445,8 +3446,10 @@ static void initiate_load(struct admin_state *state)
 						   handle_operation_error,
 						   allocator->thread_id, NULL);
 		allocator->eraser = dm_kcopyd_client_create(NULL);
-		if (allocator->eraser == NULL) {
-			vdo_fail_completion(&allocator->completion, -ENOMEM);
+		if (IS_ERR(allocator->eraser)) {
+			vdo_fail_completion(&allocator->completion,
+					    PTR_ERR(allocator->eraser));
+			allocator->eraser = NULL;
 			return;
 		}
 		allocator->slabs_to_erase = get_slab_iterator(allocator);
-- 
2.42.0

