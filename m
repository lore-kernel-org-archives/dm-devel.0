Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB3143157
	for <dm-devel@lists.linux.dev>; Wed, 14 Feb 2024 15:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707924344; cv=none; b=B6l/Ere474tgj8zO/59T+ToPJwfrRXHEu6H86w/O6jnAYB2Vea+50KrqwlSoxbdXNKC+e2FuUtkK6XeSP6AOW9aOnDPuD+sMEccG4/TufExTBMc8uObRTFvGDHw9ieXXw83ZJ3L9MjKc/nehsPk+CYQDIYHfTKKSFgTu+mbblK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707924344; c=relaxed/simple;
	bh=6xBdF5pof9fSr011HDtWg0+9rNY8H7Jk6gtIJRCKtSc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=YbHZ99xnT7WnIL0ak/PVd3Ar/DFY4iEEXYATcPY7UfQYl2Z5YxXtKOWwsYoIkg4ikZC+x8Al/AqP6it2BGaxCvwU3yxpiCbBvH9peZz8UVf/SoNtsGbUJtoW+N+p3OxXavqvxemkf3XZOVI6yXXpXA1NQILUsnVf/wHMEs1MIEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S+nBxzjk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S+nBxzjk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707924341;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=KRg9KKNUdbMCrKGJQ1CF1B0aSH+f5mj6ye1Wtr8BxXE=;
	b=S+nBxzjk4k7NkWqirpRrDldcNwpSwWbd2sSyLNPXRaq1wfhRRLYL0mNDXIBSeNainGGkCt
	RDUJabCSbUsQ6zX1x7G58KRpa2hTWYEoq9yNal8DkD9+bhU/nIJ8JlxGs5A3iwOoGc6cwa
	gECelwpqKs99vqQD6Gzaf0Z2W0Bxb10=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-618-NIWZrVSiMRO2Vh-K91YS4A-1; Wed, 14 Feb 2024 10:25:40 -0500
X-MC-Unique: NIWZrVSiMRO2Vh-K91YS4A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B6F76828CE5;
	Wed, 14 Feb 2024 15:25:39 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B01C620229A7;
	Wed, 14 Feb 2024 15:25:39 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id A4DF757E8B; Wed, 14 Feb 2024 10:25:39 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH] dm vdo: tweak wait_for_completion_interruptible callers
Date: Wed, 14 Feb 2024 10:25:39 -0500
Message-ID: <32f7919af0b262a91cc64d3dc3e3a576914b4e6d.1707923469.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Mike Snitzer <snitzer@kernel.org>

Update uds_join_threads to delay in wait_for_completion_interruptible
loop. And cleanup style nits in perform_admin_operation().

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Susan LeGendre-McGhee <slegendr@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/dm-vdo-target.c | 5 +++--
 drivers/md/dm-vdo/uds-threads.c   | 6 +++---
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-vdo/dm-vdo-target.c b/drivers/md/dm-vdo/dm-vdo-target.c
index e2e60a29e873..e754b9e30cab 100644
--- a/drivers/md/dm-vdo/dm-vdo-target.c
+++ b/drivers/md/dm-vdo/dm-vdo-target.c
@@ -1235,9 +1235,10 @@ static int perform_admin_operation(struct vdo *vdo, u32 starting_phase,
 	 * Using the "interruptible" interface means that Linux will not log a message when we wait
 	 * for more than 120 seconds.
 	 */
-	while (wait_for_completion_interruptible(&admin->callback_sync) != 0)
-		/* * However, if we get a signal in a user-mode process, we could spin... */
+	while (wait_for_completion_interruptible(&admin->callback_sync)) {
+		/* However, if we get a signal in a user-mode process, we could spin... */
 		fsleep(1000);
+	}
 
 	result = admin->completion.result;
 	/* pairs with implicit barrier in cmpxchg above */
diff --git a/drivers/md/dm-vdo/uds-threads.c b/drivers/md/dm-vdo/uds-threads.c
index e7524617f9f8..769c783e342a 100644
--- a/drivers/md/dm-vdo/uds-threads.c
+++ b/drivers/md/dm-vdo/uds-threads.c
@@ -6,6 +6,7 @@
 #include "uds-threads.h"
 
 #include <linux/completion.h>
+#include <linux/delay.h>
 #include <linux/err.h>
 #include <linux/kthread.h>
 #include <linux/sched.h>
@@ -125,9 +126,8 @@ int uds_create_thread(void (*thread_function)(void *), void *thread_data,
 
 int uds_join_threads(struct thread *thread)
 {
-	while (wait_for_completion_interruptible(&thread->thread_done) != 0)
-		/* empty loop */
-		;
+	while (wait_for_completion_interruptible(&thread->thread_done))
+		fsleep(1000);
 
 	mutex_lock(&thread_mutex);
 	hlist_del(&thread->thread_links);
-- 
2.42.0

