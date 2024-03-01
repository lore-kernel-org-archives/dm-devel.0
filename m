Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7551947F4D
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 03:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709265191; cv=none; b=F99fkm5eFjLp0aAIgYNziQLnD8JzzyqgQJoFVd0McSsX64NseXnNZr/KX4HTZvRHRtUtWQ7U6dSdY2rycZa8wpeXNVB4/cnTv9onLUS+d1fzDw3OhmvpRqkWASC+P+KufjycBGBArXUx9n/MprSUMl0wXQ+2pdnkBG+YBB6VWRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709265191; c=relaxed/simple;
	bh=r7zSo+RNNK2+o5bU9pFLrRrFyJ127uHAr+yvUVlRA7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ePAHOE1PH8O8BChrPTuOlEiMkHvf2cc7Fa9qVO3j3k5UDcfNpZvwDTJudoBZaZ8lIm7j+3TZl9xUJAFpMztnhoAKIDq/FnpdlV6ZxioZNN7ARIhQ8xo8dDglHD8rFASIPwgtJeUZG12CWGZvkf9X5ZTlLmwbxaP1F153rB9bQtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bTa1rPjN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bTa1rPjN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709265188;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1IFhI/SOcwbc4D/MwSjquBWcGINKeR5yoGNhbbKn6Iw=;
	b=bTa1rPjN3Us+0KXz6H/ieajOBwN4jVZkFYiFnEM/Es3pkRKlt/h8RAY2OFglQMp2jmbHJO
	B0SPwNMgpDvd6fsNTsO2PphhaxvYTxym73SAv3y7hfS1mcjgJvYMWPFfrIjXes6aFKBd3i
	YR3i3AnyAo6o9McTWk2f7n69Yo2fK6A=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-157--S6TriF2OmiYWoz35ErEQw-1; Thu,
 29 Feb 2024 22:53:05 -0500
X-MC-Unique: -S6TriF2OmiYWoz35ErEQw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 663E1280A9A3;
	Fri,  1 Mar 2024 03:53:05 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5E6801121312;
	Fri,  1 Mar 2024 03:53:05 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 5BFB69EB2B; Thu, 29 Feb 2024 22:53:05 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 05/13] dm vdo: rename uds-threads.[ch] to thread-utils.[ch]
Date: Thu, 29 Feb 2024 22:52:57 -0500
Message-ID: <9ca8e03cc02edd7ce41e8bb53641c5f39a9dad37.1709264538.git.msakai@redhat.com>
In-Reply-To: <cover.1709264538.git.msakai@redhat.com>
References: <cover.1709264538.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Mike Snitzer <snitzer@kernel.org>

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/Makefile                          | 2 +-
 drivers/md/dm-vdo/config.c                          | 2 +-
 drivers/md/dm-vdo/funnel-requestqueue.c             | 2 +-
 drivers/md/dm-vdo/index-page-map.c                  | 2 +-
 drivers/md/dm-vdo/index-session.h                   | 2 +-
 drivers/md/dm-vdo/logger.c                          | 2 +-
 drivers/md/dm-vdo/status-codes.c                    | 2 +-
 drivers/md/dm-vdo/thread-cond-var.c                 | 2 +-
 drivers/md/dm-vdo/{uds-threads.c => thread-utils.c} | 2 +-
 drivers/md/dm-vdo/{uds-threads.h => thread-utils.h} | 5 ++---
 drivers/md/dm-vdo/volume-index.c                    | 2 +-
 drivers/md/dm-vdo/volume-index.h                    | 2 +-
 drivers/md/dm-vdo/volume.c                          | 2 +-
 drivers/md/dm-vdo/volume.h                          | 2 +-
 14 files changed, 15 insertions(+), 16 deletions(-)
 rename drivers/md/dm-vdo/{uds-threads.c => thread-utils.c} (99%)
 rename drivers/md/dm-vdo/{uds-threads.h => thread-utils.h} (94%)

diff --git a/drivers/md/dm-vdo/Makefile b/drivers/md/dm-vdo/Makefile
index 8c06c3b969e3..be5020b81c47 100644
--- a/drivers/md/dm-vdo/Makefile
+++ b/drivers/md/dm-vdo/Makefile
@@ -51,8 +51,8 @@ dm-vdo-objs := \
 	thread-cond-var.o \
 	thread-device.o \
 	thread-registry.o \
+	thread-utils.o \
 	uds-sysfs.o \
-	uds-threads.o \
 	vdo.o \
 	vio.o \
 	volume-index.o \
diff --git a/drivers/md/dm-vdo/config.c b/drivers/md/dm-vdo/config.c
index e9c7e9bdbce0..0bf315e7b5d1 100644
--- a/drivers/md/dm-vdo/config.c
+++ b/drivers/md/dm-vdo/config.c
@@ -9,7 +9,7 @@
 #include "memory-alloc.h"
 #include "numeric.h"
 #include "string-utils.h"
-#include "uds-threads.h"
+#include "thread-utils.h"
 
 static const u8 INDEX_CONFIG_MAGIC[] = "ALBIC";
 static const u8 INDEX_CONFIG_VERSION_6_02[] = "06.02";
diff --git a/drivers/md/dm-vdo/funnel-requestqueue.c b/drivers/md/dm-vdo/funnel-requestqueue.c
index c8ba04c1089c..e7a3a4962295 100644
--- a/drivers/md/dm-vdo/funnel-requestqueue.c
+++ b/drivers/md/dm-vdo/funnel-requestqueue.c
@@ -12,7 +12,7 @@
 #include "funnel-queue.h"
 #include "logger.h"
 #include "memory-alloc.h"
-#include "uds-threads.h"
+#include "thread-utils.h"
 
 /*
  * This queue will attempt to handle requests in reasonably sized batches instead of reacting
diff --git a/drivers/md/dm-vdo/index-page-map.c b/drivers/md/dm-vdo/index-page-map.c
index f3748a915c03..8441f86ef3a4 100644
--- a/drivers/md/dm-vdo/index-page-map.c
+++ b/drivers/md/dm-vdo/index-page-map.c
@@ -12,7 +12,7 @@
 #include "numeric.h"
 #include "permassert.h"
 #include "string-utils.h"
-#include "uds-threads.h"
+#include "thread-utils.h"
 #include "uds.h"
 
 /*
diff --git a/drivers/md/dm-vdo/index-session.h b/drivers/md/dm-vdo/index-session.h
index c77ee021d510..62a9020dd9fa 100644
--- a/drivers/md/dm-vdo/index-session.h
+++ b/drivers/md/dm-vdo/index-session.h
@@ -10,7 +10,7 @@
 #include <linux/cache.h>
 
 #include "config.h"
-#include "uds-threads.h"
+#include "thread-utils.h"
 #include "uds.h"
 
 /*
diff --git a/drivers/md/dm-vdo/logger.c b/drivers/md/dm-vdo/logger.c
index 1efbf8d52f2c..ff1c570f81bf 100644
--- a/drivers/md/dm-vdo/logger.c
+++ b/drivers/md/dm-vdo/logger.c
@@ -12,7 +12,7 @@
 #include <linux/sched.h>
 
 #include "thread-device.h"
-#include "uds-threads.h"
+#include "thread-utils.h"
 
 struct priority_name {
 	const char *name;
diff --git a/drivers/md/dm-vdo/status-codes.c b/drivers/md/dm-vdo/status-codes.c
index b4d7eb7f94ff..d77bc5e4a99a 100644
--- a/drivers/md/dm-vdo/status-codes.c
+++ b/drivers/md/dm-vdo/status-codes.c
@@ -8,7 +8,7 @@
 #include "errors.h"
 #include "logger.h"
 #include "permassert.h"
-#include "uds-threads.h"
+#include "thread-utils.h"
 
 const struct error_info vdo_status_list[] = {
 	{ "VDO_NOT_IMPLEMENTED", "Not implemented" },
diff --git a/drivers/md/dm-vdo/thread-cond-var.c b/drivers/md/dm-vdo/thread-cond-var.c
index ed7f0b79ca0a..82b80338b448 100644
--- a/drivers/md/dm-vdo/thread-cond-var.c
+++ b/drivers/md/dm-vdo/thread-cond-var.c
@@ -7,8 +7,8 @@
 #include <linux/minmax.h>
 
 #include "errors.h"
+#include "thread-utils.h"
 #include "time-utils.h"
-#include "uds-threads.h"
 
 int uds_init_cond(struct cond_var *cv)
 {
diff --git a/drivers/md/dm-vdo/uds-threads.c b/drivers/md/dm-vdo/thread-utils.c
similarity index 99%
rename from drivers/md/dm-vdo/uds-threads.c
rename to drivers/md/dm-vdo/thread-utils.c
index 3bfd22bae8b1..1a1eb9ae9e33 100644
--- a/drivers/md/dm-vdo/uds-threads.c
+++ b/drivers/md/dm-vdo/thread-utils.c
@@ -3,7 +3,7 @@
  * Copyright 2023 Red Hat
  */
 
-#include "uds-threads.h"
+#include "thread-utils.h"
 
 #include <linux/completion.h>
 #include <linux/delay.h>
diff --git a/drivers/md/dm-vdo/uds-threads.h b/drivers/md/dm-vdo/thread-utils.h
similarity index 94%
rename from drivers/md/dm-vdo/uds-threads.h
rename to drivers/md/dm-vdo/thread-utils.h
index 2a0580e4482b..30637dd264cc 100644
--- a/drivers/md/dm-vdo/uds-threads.h
+++ b/drivers/md/dm-vdo/thread-utils.h
@@ -3,8 +3,8 @@
  * Copyright 2023 Red Hat
  */
 
-#ifndef UDS_THREADS_H
-#define UDS_THREADS_H
+#ifndef THREAD_UTILS_H
+#define THREAD_UTILS_H
 
 #include <linux/atomic.h>
 #include <linux/delay.h>
@@ -14,7 +14,6 @@
 #include <linux/wait.h>
 
 #include "errors.h"
-#include "time-utils.h"
 
 /* Thread and synchronization utilities for UDS */
 
diff --git a/drivers/md/dm-vdo/volume-index.c b/drivers/md/dm-vdo/volume-index.c
index eebc19fe7d6f..daeafe7691ea 100644
--- a/drivers/md/dm-vdo/volume-index.c
+++ b/drivers/md/dm-vdo/volume-index.c
@@ -18,8 +18,8 @@
 #include "memory-alloc.h"
 #include "numeric.h"
 #include "permassert.h"
+#include "thread-utils.h"
 #include "uds.h"
-#include "uds-threads.h"
 
 /*
  * The volume index is a combination of two separate subindexes, one containing sparse hook entries
diff --git a/drivers/md/dm-vdo/volume-index.h b/drivers/md/dm-vdo/volume-index.h
index 537e9947cf4a..2eb2cee7ee58 100644
--- a/drivers/md/dm-vdo/volume-index.h
+++ b/drivers/md/dm-vdo/volume-index.h
@@ -10,8 +10,8 @@
 
 #include "config.h"
 #include "delta-index.h"
+#include "thread-utils.h"
 #include "uds.h"
-#include "uds-threads.h"
 
 /*
  * The volume index is the primary top-level index for UDS. It contains records which map a record
diff --git a/drivers/md/dm-vdo/volume.c b/drivers/md/dm-vdo/volume.c
index 8bd64057c2ca..5b3cb5d89e47 100644
--- a/drivers/md/dm-vdo/volume.c
+++ b/drivers/md/dm-vdo/volume.c
@@ -20,7 +20,7 @@
 #include "permassert.h"
 #include "sparse-cache.h"
 #include "string-utils.h"
-#include "uds-threads.h"
+#include "thread-utils.h"
 
 /*
  * The first block of the volume layout is reserved for the volume header, which is no longer used.
diff --git a/drivers/md/dm-vdo/volume.h b/drivers/md/dm-vdo/volume.h
index 066680282340..7ef9945d8403 100644
--- a/drivers/md/dm-vdo/volume.h
+++ b/drivers/md/dm-vdo/volume.h
@@ -19,8 +19,8 @@
 #include "permassert.h"
 #include "radix-sort.h"
 #include "sparse-cache.h"
+#include "thread-utils.h"
 #include "uds.h"
-#include "uds-threads.h"
 
 /*
  * The volume manages deduplication records on permanent storage. The term "volume" can also refer
-- 
2.42.0

