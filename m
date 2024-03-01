Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B15C4D599
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 03:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709265196; cv=none; b=cUPF5IRCDLN2bsAXiSqCD4sjReiqAmThulCEvkR2CjSEziPS5ooA+tEBJ4wAa76Wx2NLO1JoKdOiuWB2/SydLx27pye5hkq9PnRk9s7puHl4qejT9hYRYVI7JQniUnljhNINSVWuLtDdNqAQnPcF+SU1+KZV9DJ44Qn8+8ktUUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709265196; c=relaxed/simple;
	bh=mj5pjnZ8XgnCYKNg75MptJdF9QwUEQBpQEx83x0fsiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ekyJ7W3heOTPAA7aiUAqR+Atz/4VMPCmiKmKnpSiAnp82DBjVwbqDvP6cQsBYAT1d4zp7vBWEZRZhWRoU2yARB/BtZTmLE+dRevqI/T3pPXGnFwKS/3uKtZC4zjeN8GhwKGwoetLjUl3rVdpm9gahoPvg+F1bjThTyUOxzv97dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LPGI9zYy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LPGI9zYy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709265190;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s+lgfMidItN1CHikYe+UCfKfYSeBFHXEvTTnixqxMoc=;
	b=LPGI9zYyCAS+zDXMX5eG7C6TRkHktZ64Bhuf3v0g3ZI5l43OC8rjN5VswmqjsgUYgXRS5m
	6Hv1Dg85T6C0ciFQHAuHmMF+/618dweNQ4FbGvZRPfxvwj5zMbwmOfAsCl5OYmrMYpU2Wo
	5T1W3OVWvz6gcC7IP90LYOz6sYKNZ8M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-157-VarjnThUOZKN96DM8R-AvQ-1; Thu, 29 Feb 2024 22:53:05 -0500
X-MC-Unique: VarjnThUOZKN96DM8R-AvQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 68D3985A589;
	Fri,  1 Mar 2024 03:53:05 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 63C86492BE8;
	Fri,  1 Mar 2024 03:53:05 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 6166A9EB2D; Thu, 29 Feb 2024 22:53:05 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 06/13] dm vdo indexer: rename uds.h to indexer.h
Date: Thu, 29 Feb 2024 22:52:58 -0500
Message-ID: <e9f1c5533379f7663a6ede6d0876f010a9bab00d.1709264538.git.msakai@redhat.com>
In-Reply-To: <cover.1709264538.git.msakai@redhat.com>
References: <cover.1709264538.git.msakai@redhat.com>
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

From: Mike Snitzer <snitzer@kernel.org>

Also remove unnecessary include from funnel-queue.c.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/chapter-index.c       | 2 +-
 drivers/md/dm-vdo/config.h              | 2 +-
 drivers/md/dm-vdo/data-vio.h            | 2 +-
 drivers/md/dm-vdo/dedupe.c              | 2 +-
 drivers/md/dm-vdo/dedupe.h              | 2 +-
 drivers/md/dm-vdo/delta-index.c         | 2 +-
 drivers/md/dm-vdo/encodings.h           | 2 +-
 drivers/md/dm-vdo/funnel-queue.c        | 1 -
 drivers/md/dm-vdo/funnel-requestqueue.h | 2 +-
 drivers/md/dm-vdo/geometry.c            | 2 +-
 drivers/md/dm-vdo/geometry.h            | 2 +-
 drivers/md/dm-vdo/hash-utils.h          | 2 +-
 drivers/md/dm-vdo/index-layout.h        | 2 +-
 drivers/md/dm-vdo/index-page-map.c      | 2 +-
 drivers/md/dm-vdo/index-session.h       | 2 +-
 drivers/md/dm-vdo/{uds.h => indexer.h}  | 6 +++---
 drivers/md/dm-vdo/sparse-cache.h        | 2 +-
 drivers/md/dm-vdo/uds-sysfs.c           | 2 +-
 drivers/md/dm-vdo/vdo.h                 | 2 +-
 drivers/md/dm-vdo/volume-index.c        | 2 +-
 drivers/md/dm-vdo/volume-index.h        | 2 +-
 drivers/md/dm-vdo/volume.h              | 2 +-
 22 files changed, 23 insertions(+), 24 deletions(-)
 rename drivers/md/dm-vdo/{uds.h => indexer.h} (99%)

diff --git a/drivers/md/dm-vdo/chapter-index.c b/drivers/md/dm-vdo/chapter-index.c
index 363991d56218..9b9185c2c237 100644
--- a/drivers/md/dm-vdo/chapter-index.c
+++ b/drivers/md/dm-vdo/chapter-index.c
@@ -7,10 +7,10 @@
 
 #include "errors.h"
 #include "hash-utils.h"
+#include "indexer.h"
 #include "logger.h"
 #include "memory-alloc.h"
 #include "permassert.h"
-#include "uds.h"
 
 int uds_make_open_chapter_index(struct open_chapter_index **chapter_index,
 				const struct index_geometry *geometry, u64 volume_nonce)
diff --git a/drivers/md/dm-vdo/config.h b/drivers/md/dm-vdo/config.h
index 7d19863800d6..08507dc2f7a1 100644
--- a/drivers/md/dm-vdo/config.h
+++ b/drivers/md/dm-vdo/config.h
@@ -7,8 +7,8 @@
 #define UDS_CONFIG_H
 
 #include "geometry.h"
+#include "indexer.h"
 #include "io-factory.h"
-#include "uds.h"
 
 /*
  * The uds_configuration records a variety of parameters used to configure a new UDS index. Some
diff --git a/drivers/md/dm-vdo/data-vio.h b/drivers/md/dm-vdo/data-vio.h
index 78744d064e96..e7729623a6bb 100644
--- a/drivers/md/dm-vdo/data-vio.h
+++ b/drivers/md/dm-vdo/data-vio.h
@@ -10,8 +10,8 @@
 #include <linux/bio.h>
 #include <linux/list.h>
 
+#include "indexer.h"
 #include "permassert.h"
-#include "uds.h"
 
 #include "block-map.h"
 #include "completion.h"
diff --git a/drivers/md/dm-vdo/dedupe.c b/drivers/md/dm-vdo/dedupe.c
index 2a1902c4423c..942a50ef8b0d 100644
--- a/drivers/md/dm-vdo/dedupe.c
+++ b/drivers/md/dm-vdo/dedupe.c
@@ -126,12 +126,12 @@
 #include <linux/spinlock.h>
 #include <linux/timer.h>
 
+#include "indexer.h"
 #include "logger.h"
 #include "memory-alloc.h"
 #include "numeric.h"
 #include "permassert.h"
 #include "string-utils.h"
-#include "uds.h"
 
 #include "action-manager.h"
 #include "admin-state.h"
diff --git a/drivers/md/dm-vdo/dedupe.h b/drivers/md/dm-vdo/dedupe.h
index 773dde5f9365..1566fc972ea7 100644
--- a/drivers/md/dm-vdo/dedupe.h
+++ b/drivers/md/dm-vdo/dedupe.h
@@ -9,7 +9,7 @@
 #include <linux/list.h>
 #include <linux/timer.h>
 
-#include "uds.h"
+#include "indexer.h"
 
 #include "admin-state.h"
 #include "constants.h"
diff --git a/drivers/md/dm-vdo/delta-index.c b/drivers/md/dm-vdo/delta-index.c
index 6306777bb202..66f51b5f8fd2 100644
--- a/drivers/md/dm-vdo/delta-index.c
+++ b/drivers/md/dm-vdo/delta-index.c
@@ -13,13 +13,13 @@
 #include "config.h"
 #include "cpu.h"
 #include "errors.h"
+#include "indexer.h"
 #include "logger.h"
 #include "memory-alloc.h"
 #include "numeric.h"
 #include "permassert.h"
 #include "string-utils.h"
 #include "time-utils.h"
-#include "uds.h"
 
 /*
  * The entries in a delta index could be stored in a single delta list, but to reduce search times
diff --git a/drivers/md/dm-vdo/encodings.h b/drivers/md/dm-vdo/encodings.h
index ba3db9867f4a..18794fd59b0b 100644
--- a/drivers/md/dm-vdo/encodings.h
+++ b/drivers/md/dm-vdo/encodings.h
@@ -11,8 +11,8 @@
 #include <linux/limits.h>
 #include <linux/uuid.h>
 
+#include "indexer.h"
 #include "numeric.h"
-#include "uds.h"
 
 #include "constants.h"
 #include "types.h"
diff --git a/drivers/md/dm-vdo/funnel-queue.c b/drivers/md/dm-vdo/funnel-queue.c
index 6940b282086d..d5d96bb38b94 100644
--- a/drivers/md/dm-vdo/funnel-queue.c
+++ b/drivers/md/dm-vdo/funnel-queue.c
@@ -8,7 +8,6 @@
 #include "cpu.h"
 #include "memory-alloc.h"
 #include "permassert.h"
-#include "uds.h"
 
 int uds_make_funnel_queue(struct funnel_queue **queue_ptr)
 {
diff --git a/drivers/md/dm-vdo/funnel-requestqueue.h b/drivers/md/dm-vdo/funnel-requestqueue.h
index e74c231fe269..9b0f53939b4d 100644
--- a/drivers/md/dm-vdo/funnel-requestqueue.h
+++ b/drivers/md/dm-vdo/funnel-requestqueue.h
@@ -6,7 +6,7 @@
 #ifndef UDS_REQUEST_QUEUE_H
 #define UDS_REQUEST_QUEUE_H
 
-#include "uds.h"
+#include "indexer.h"
 
 /*
  * A simple request queue which will handle new requests in the order in which they are received,
diff --git a/drivers/md/dm-vdo/geometry.c b/drivers/md/dm-vdo/geometry.c
index 0e83bba4184a..04c07195a01c 100644
--- a/drivers/md/dm-vdo/geometry.c
+++ b/drivers/md/dm-vdo/geometry.c
@@ -10,10 +10,10 @@
 
 #include "delta-index.h"
 #include "errors.h"
+#include "indexer.h"
 #include "logger.h"
 #include "memory-alloc.h"
 #include "permassert.h"
-#include "uds.h"
 
 /*
  * An index volume is divided into a fixed number of fixed-size chapters, each consisting of a
diff --git a/drivers/md/dm-vdo/geometry.h b/drivers/md/dm-vdo/geometry.h
index 9a4a66ac2e46..a2ecdb238cf2 100644
--- a/drivers/md/dm-vdo/geometry.h
+++ b/drivers/md/dm-vdo/geometry.h
@@ -6,7 +6,7 @@
 #ifndef UDS_INDEX_GEOMETRY_H
 #define UDS_INDEX_GEOMETRY_H
 
-#include "uds.h"
+#include "indexer.h"
 
 /*
  * The index_geometry records parameters that define the layout of a UDS index volume, and the size and
diff --git a/drivers/md/dm-vdo/hash-utils.h b/drivers/md/dm-vdo/hash-utils.h
index e22be69695be..e3b865bbe9b2 100644
--- a/drivers/md/dm-vdo/hash-utils.h
+++ b/drivers/md/dm-vdo/hash-utils.h
@@ -7,8 +7,8 @@
 #define UDS_HASH_UTILS_H
 
 #include "geometry.h"
+#include "indexer.h"
 #include "numeric.h"
-#include "uds.h"
 
 /* Utilities for extracting portions of a request name for various uses. */
 
diff --git a/drivers/md/dm-vdo/index-layout.h b/drivers/md/dm-vdo/index-layout.h
index 84a9eb43a49d..e9ac6f4302d6 100644
--- a/drivers/md/dm-vdo/index-layout.h
+++ b/drivers/md/dm-vdo/index-layout.h
@@ -7,8 +7,8 @@
 #define UDS_INDEX_LAYOUT_H
 
 #include "config.h"
+#include "indexer.h"
 #include "io-factory.h"
-#include "uds.h"
 
 /*
  * The index layout describes the format of the index on the underlying storage, and is responsible
diff --git a/drivers/md/dm-vdo/index-page-map.c b/drivers/md/dm-vdo/index-page-map.c
index 8441f86ef3a4..1bb12066ad1a 100644
--- a/drivers/md/dm-vdo/index-page-map.c
+++ b/drivers/md/dm-vdo/index-page-map.c
@@ -7,13 +7,13 @@
 
 #include "errors.h"
 #include "hash-utils.h"
+#include "indexer.h"
 #include "logger.h"
 #include "memory-alloc.h"
 #include "numeric.h"
 #include "permassert.h"
 #include "string-utils.h"
 #include "thread-utils.h"
-#include "uds.h"
 
 /*
  * The index page map is conceptually a two-dimensional array indexed by chapter number and index
diff --git a/drivers/md/dm-vdo/index-session.h b/drivers/md/dm-vdo/index-session.h
index 62a9020dd9fa..733d10f8a56c 100644
--- a/drivers/md/dm-vdo/index-session.h
+++ b/drivers/md/dm-vdo/index-session.h
@@ -10,8 +10,8 @@
 #include <linux/cache.h>
 
 #include "config.h"
+#include "indexer.h"
 #include "thread-utils.h"
-#include "uds.h"
 
 /*
  * The index session mediates all interactions with a UDS index. Once the index session is created,
diff --git a/drivers/md/dm-vdo/uds.h b/drivers/md/dm-vdo/indexer.h
similarity index 99%
rename from drivers/md/dm-vdo/uds.h
rename to drivers/md/dm-vdo/indexer.h
index 1264362f8372..59e6a5ca2acb 100644
--- a/drivers/md/dm-vdo/uds.h
+++ b/drivers/md/dm-vdo/indexer.h
@@ -3,8 +3,8 @@
  * Copyright 2023 Red Hat
  */
 
-#ifndef UDS_H
-#define UDS_H
+#ifndef INDEXER_H
+#define INDEXER_H
 
 #include <linux/types.h>
 
@@ -326,4 +326,4 @@ int __must_check uds_get_index_session_stats(struct uds_index_session *session,
 /* This function will fail if any required field of the request is not set. */
 int __must_check uds_launch_request(struct uds_request *request);
 
-#endif /* UDS_H */
+#endif /* INDEXER_H */
diff --git a/drivers/md/dm-vdo/sparse-cache.h b/drivers/md/dm-vdo/sparse-cache.h
index 90b0be155453..45e2dcf165b5 100644
--- a/drivers/md/dm-vdo/sparse-cache.h
+++ b/drivers/md/dm-vdo/sparse-cache.h
@@ -7,7 +7,7 @@
 #define UDS_SPARSE_CACHE_H
 
 #include "geometry.h"
-#include "uds.h"
+#include "indexer.h"
 
 /*
  * The sparse cache is a cache of entire chapter indexes from sparse chapters used for searching
diff --git a/drivers/md/dm-vdo/uds-sysfs.c b/drivers/md/dm-vdo/uds-sysfs.c
index eee8a5b7d147..1548092e7de1 100644
--- a/drivers/md/dm-vdo/uds-sysfs.c
+++ b/drivers/md/dm-vdo/uds-sysfs.c
@@ -9,10 +9,10 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 
+#include "indexer.h"
 #include "logger.h"
 #include "memory-alloc.h"
 #include "string-utils.h"
-#include "uds.h"
 
 #define UDS_SYSFS_NAME "uds"
 
diff --git a/drivers/md/dm-vdo/vdo.h b/drivers/md/dm-vdo/vdo.h
index 772317e6db52..3938e519ae6a 100644
--- a/drivers/md/dm-vdo/vdo.h
+++ b/drivers/md/dm-vdo/vdo.h
@@ -17,12 +17,12 @@
 #include "admin-state.h"
 #include "encodings.h"
 #include "funnel-workqueue.h"
+#include "indexer.h"
 #include "packer.h"
 #include "physical-zone.h"
 #include "statistics.h"
 #include "thread-registry.h"
 #include "types.h"
-#include "uds.h"
 
 enum notifier_state {
 	/* Notifications are allowed but not in progress */
diff --git a/drivers/md/dm-vdo/volume-index.c b/drivers/md/dm-vdo/volume-index.c
index daeafe7691ea..39c4be06780f 100644
--- a/drivers/md/dm-vdo/volume-index.c
+++ b/drivers/md/dm-vdo/volume-index.c
@@ -14,12 +14,12 @@
 #include "errors.h"
 #include "geometry.h"
 #include "hash-utils.h"
+#include "indexer.h"
 #include "logger.h"
 #include "memory-alloc.h"
 #include "numeric.h"
 #include "permassert.h"
 #include "thread-utils.h"
-#include "uds.h"
 
 /*
  * The volume index is a combination of two separate subindexes, one containing sparse hook entries
diff --git a/drivers/md/dm-vdo/volume-index.h b/drivers/md/dm-vdo/volume-index.h
index 2eb2cee7ee58..66bf14fddc90 100644
--- a/drivers/md/dm-vdo/volume-index.h
+++ b/drivers/md/dm-vdo/volume-index.h
@@ -10,8 +10,8 @@
 
 #include "config.h"
 #include "delta-index.h"
+#include "indexer.h"
 #include "thread-utils.h"
-#include "uds.h"
 
 /*
  * The volume index is the primary top-level index for UDS. It contains records which map a record
diff --git a/drivers/md/dm-vdo/volume.h b/drivers/md/dm-vdo/volume.h
index 7ef9945d8403..290de5cbf9ec 100644
--- a/drivers/md/dm-vdo/volume.h
+++ b/drivers/md/dm-vdo/volume.h
@@ -14,13 +14,13 @@
 #include "chapter-index.h"
 #include "config.h"
 #include "geometry.h"
+#include "indexer.h"
 #include "index-layout.h"
 #include "index-page-map.h"
 #include "permassert.h"
 #include "radix-sort.h"
 #include "sparse-cache.h"
 #include "thread-utils.h"
-#include "uds.h"
 
 /*
  * The volume manages deduplication records on permanent storage. The term "volume" can also refer
-- 
2.42.0

