Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E13374E3
	for <dm-devel@lists.linux.dev>; Wed,  8 Nov 2023 23:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W58Ao0GK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699485728;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Iisi6DbH7leSMTPS5QSbebGo05RQHm1AIPo2FdZhuPk=;
	b=W58Ao0GKqCXhbPTbAhK63MYZzmwkWKmlNST5z8O/IGi0mcDfINCoJlgtwTztsmrwJ/k+9z
	zXyO+bTUFynFcqGfJQ9y6pepZIygGiYY6fvOh9UcI2rXkeplzzQr+Lim9YnPuMfEiqRRm0
	co+toSVqroTMG5wAtEDqk7o7Yb2G2e4=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-34-jMTeVYTtOpC8UDkKlVeHVQ-1; Wed,
 08 Nov 2023 18:22:04 -0500
X-MC-Unique: jMTeVYTtOpC8UDkKlVeHVQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B4C4B1C05EA6;
	Wed,  8 Nov 2023 23:22:00 +0000 (UTC)
Received: from pbitcolo-build-10.permabit.com (pbitcolo-build-10.permabit.lab.eng.bos.redhat.com [10.19.117.76])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A55752166B26;
	Wed,  8 Nov 2023 23:22:00 +0000 (UTC)
Received: by pbitcolo-build-10.permabit.com (Postfix, from userid 1138)
	id 6A5193003C; Wed,  8 Nov 2023 18:22:00 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH] dm vdo: add "funnel-" filename prefix to funnel-queue based sources
Date: Wed,  8 Nov 2023 18:22:00 -0500
Message-Id: <20231108232200.1881711-1-msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

From: Mike Snitzer <snitzer@kernel.org>

Reviewed-by: Chung Chung <cchung@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/dump.c                                     | 2 +-
 drivers/md/dm-vdo/flush.h                                    | 2 +-
 drivers/md/dm-vdo/{request-queue.c => funnel-requestqueue.c} | 2 +-
 drivers/md/dm-vdo/{request-queue.h => funnel-requestqueue.h} | 0
 drivers/md/dm-vdo/{work-queue.c => funnel-workqueue.c}       | 2 +-
 drivers/md/dm-vdo/{work-queue.h => funnel-workqueue.h}       | 0
 drivers/md/dm-vdo/index-session.c                            | 2 +-
 drivers/md/dm-vdo/index.c                                    | 2 +-
 drivers/md/dm-vdo/vdo.c                                      | 2 +-
 drivers/md/dm-vdo/vdo.h                                      | 2 +-
 10 files changed, 8 insertions(+), 8 deletions(-)
 rename drivers/md/dm-vdo/{request-queue.c => funnel-requestqueue.c} (99%)
 rename drivers/md/dm-vdo/{request-queue.h => funnel-requestqueue.h} (100%)
 rename drivers/md/dm-vdo/{work-queue.c => funnel-workqueue.c} (99%)
 rename drivers/md/dm-vdo/{work-queue.h => funnel-workqueue.h} (100%)

diff --git a/drivers/md/dm-vdo/dump.c b/drivers/md/dm-vdo/dump.c
index d50db3f7a14d..97b1bdfa3574 100644
--- a/drivers/md/dm-vdo/dump.c
+++ b/drivers/md/dm-vdo/dump.c
@@ -13,11 +13,11 @@
 #include "constants.h"
 #include "data-vio.h"
 #include "dedupe.h"
+#include "funnel-workqueue.h"
 #include "io-submitter.h"
 #include "logger.h"
 #include "types.h"
 #include "vdo.h"
-#include "work-queue.h"
 
 enum dump_options {
 	/* Work queues */
diff --git a/drivers/md/dm-vdo/flush.h b/drivers/md/dm-vdo/flush.h
index f36231c493c5..4d40908462bb 100644
--- a/drivers/md/dm-vdo/flush.h
+++ b/drivers/md/dm-vdo/flush.h
@@ -6,10 +6,10 @@
 #ifndef VDO_FLUSH_H
 #define VDO_FLUSH_H
 
+#include "funnel-workqueue.h"
 #include "types.h"
 #include "vio.h"
 #include "wait-queue.h"
-#include "work-queue.h"
 
 /* A marker for tracking which journal entries are affected by a flush request. */
 struct vdo_flush {
diff --git a/drivers/md/dm-vdo/request-queue.c b/drivers/md/dm-vdo/funnel-requestqueue.c
similarity index 99%
rename from drivers/md/dm-vdo/request-queue.c
rename to drivers/md/dm-vdo/funnel-requestqueue.c
index 1c60b09027a8..18ac5ee6cded 100644
--- a/drivers/md/dm-vdo/request-queue.c
+++ b/drivers/md/dm-vdo/funnel-requestqueue.c
@@ -3,7 +3,7 @@
  * Copyright 2023 Red Hat
  */
 
-#include "request-queue.h"
+#include "funnel-requestqueue.h"
 
 #include <linux/atomic.h>
 #include <linux/compiler.h>
diff --git a/drivers/md/dm-vdo/request-queue.h b/drivers/md/dm-vdo/funnel-requestqueue.h
similarity index 100%
rename from drivers/md/dm-vdo/request-queue.h
rename to drivers/md/dm-vdo/funnel-requestqueue.h
diff --git a/drivers/md/dm-vdo/work-queue.c b/drivers/md/dm-vdo/funnel-workqueue.c
similarity index 99%
rename from drivers/md/dm-vdo/work-queue.c
rename to drivers/md/dm-vdo/funnel-workqueue.c
index 6adf07fc74e1..119f813ea4cb 100644
--- a/drivers/md/dm-vdo/work-queue.c
+++ b/drivers/md/dm-vdo/funnel-workqueue.c
@@ -3,7 +3,7 @@
  * Copyright 2023 Red Hat
  */
 
-#include "work-queue.h"
+#include "funnel-workqueue.h"
 
 #include <linux/atomic.h>
 #include <linux/cache.h>
diff --git a/drivers/md/dm-vdo/work-queue.h b/drivers/md/dm-vdo/funnel-workqueue.h
similarity index 100%
rename from drivers/md/dm-vdo/work-queue.h
rename to drivers/md/dm-vdo/funnel-workqueue.h
diff --git a/drivers/md/dm-vdo/index-session.c b/drivers/md/dm-vdo/index-session.c
index 052ba093fbf1..5c14b0917c4d 100644
--- a/drivers/md/dm-vdo/index-session.c
+++ b/drivers/md/dm-vdo/index-session.c
@@ -7,11 +7,11 @@
 
 #include <linux/atomic.h>
 
+#include "funnel-requestqueue.h"
 #include "index.h"
 #include "index-layout.h"
 #include "logger.h"
 #include "memory-alloc.h"
-#include "request-queue.h"
 #include "time-utils.h"
 
 /*
diff --git a/drivers/md/dm-vdo/index.c b/drivers/md/dm-vdo/index.c
index e8859cee2b93..89ed4c0251f2 100644
--- a/drivers/md/dm-vdo/index.c
+++ b/drivers/md/dm-vdo/index.c
@@ -6,10 +6,10 @@
 
 #include "index.h"
 
+#include "funnel-requestqueue.h"
 #include "hash-utils.h"
 #include "logger.h"
 #include "memory-alloc.h"
-#include "request-queue.h"
 #include "sparse-cache.h"
 
 static const u64 NO_LAST_SAVE = U64_MAX;
diff --git a/drivers/md/dm-vdo/vdo.c b/drivers/md/dm-vdo/vdo.c
index 72cbe6921893..5089a53516f8 100644
--- a/drivers/md/dm-vdo/vdo.c
+++ b/drivers/md/dm-vdo/vdo.c
@@ -48,6 +48,7 @@
 #include "data-vio.h"
 #include "dedupe.h"
 #include "encodings.h"
+#include "funnel-workqueue.h"
 #include "io-submitter.h"
 #include "logical-zone.h"
 #include "packer.h"
@@ -58,7 +59,6 @@
 #include "statistics.h"
 #include "status-codes.h"
 #include "vio.h"
-#include "work-queue.h"
 
 
 enum { PARANOID_THREAD_CONSISTENCY_CHECKS = 0 };
diff --git a/drivers/md/dm-vdo/vdo.h b/drivers/md/dm-vdo/vdo.h
index a2caf54221c8..af540bce72da 100644
--- a/drivers/md/dm-vdo/vdo.h
+++ b/drivers/md/dm-vdo/vdo.h
@@ -16,13 +16,13 @@
 
 #include "admin-state.h"
 #include "encodings.h"
+#include "funnel-workqueue.h"
 #include "packer.h"
 #include "physical-zone.h"
 #include "statistics.h"
 #include "thread-registry.h"
 #include "types.h"
 #include "uds.h"
-#include "work-queue.h"
 
 enum notifier_state {
 	/** Notifications are allowed but not in progress */
-- 
2.40.0

