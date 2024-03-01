Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFCD3524BE
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 04:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709266685; cv=none; b=Nqk33U5Pv50tOuxwNxNiYbG2ik2V7HEpGIRDzhvYdsbqBC5WTca/UZ5R8h76B/0arizbywZKDDnmCTdOLN/cDRt5NT0aGL/9PIODLWNEE17Uj8tWJpKdLnWVWzysOG0OUvf+UifUxuTpVCSzJrKJIFGgv1+6lbKR6WElrTiTZdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709266685; c=relaxed/simple;
	bh=eyZmYfiyPOIkNKefVjB65uq2KS+/Obr7rul6pMw3Mtg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LI2MODDVZEwU1B7/ZljTV1lbzj0qTICLJhDTvb9DkUH5uNu6BeD/+trxjy2cAjaSheortvNKnjvB14nT/8zz9kWekLaWU6pF9oxKKdoA3SjvHYHWc652Z+CCisHM1kBZ3G6X6M8DMjmbW74GRp6IrGnTyh6tczOezN3pb7VWYeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CWZW+rpI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CWZW+rpI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709266667;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rbU6o8qAe1L5xsJ3hrWi4JqL3EcCgZ0a0ns2Zo1MaHk=;
	b=CWZW+rpIo27Dect03pkqvgw9uuDAbOymKzwPLGV0a7ZuX20biAThuTsq6IfrhEwppC22Aq
	zWjwJWfvLGMGOWhpkiguHG0/+BKqxMJQiU42lWVcZLUQo5VQt7XXXm995RqLwHV4Wulh81
	UiC7PH7ZIHjkd5s52wWvNJj68cROlLM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-596-NydiRMTIM5SR_RUNtzI7XQ-1; Thu, 29 Feb 2024 23:17:43 -0500
X-MC-Unique: NydiRMTIM5SR_RUNtzI7XQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D216A832BCB;
	Fri,  1 Mar 2024 04:17:42 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CB9522026D0A;
	Fri,  1 Mar 2024 04:17:42 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id C4B71A15C3; Thu, 29 Feb 2024 23:17:42 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 2/2] dm vdo: move indexer files into sub-directory
Date: Thu, 29 Feb 2024 23:17:42 -0500
Message-ID: <d90aa1f37ee6f4c34178f6ba2bde8fc1e7477390.1709266548.git.msakai@redhat.com>
In-Reply-To: <cover.1709266547.git.msakai@redhat.com>
References: <cover.1709266547.git.msakai@redhat.com>
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

The goal is to assist high-level understanding of which code is
conceptually specific to VDO's indexer.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/Makefile                    | 34 ++++++++++---------
 drivers/md/dm-vdo/data-vio.h                  |  3 +-
 drivers/md/dm-vdo/dedupe.c                    |  3 +-
 .../md/dm-vdo/{ => indexer}/chapter-index.c   |  5 +--
 .../md/dm-vdo/{ => indexer}/chapter-index.h   |  0
 drivers/md/dm-vdo/{ => indexer}/config.c      |  0
 drivers/md/dm-vdo/{ => indexer}/config.h      |  0
 drivers/md/dm-vdo/{ => indexer}/delta-index.c |  5 +--
 drivers/md/dm-vdo/{ => indexer}/delta-index.h |  5 +--
 .../{ => indexer}/funnel-requestqueue.c       |  0
 .../{ => indexer}/funnel-requestqueue.h       |  0
 drivers/md/dm-vdo/{ => indexer}/geometry.c    |  5 +--
 drivers/md/dm-vdo/{ => indexer}/geometry.h    |  0
 drivers/md/dm-vdo/{ => indexer}/hash-utils.h  |  3 +-
 .../md/dm-vdo/{ => indexer}/index-layout.c    |  5 +--
 .../md/dm-vdo/{ => indexer}/index-layout.h    |  0
 .../md/dm-vdo/{ => indexer}/index-page-map.c  |  5 +--
 .../md/dm-vdo/{ => indexer}/index-page-map.h  |  0
 .../md/dm-vdo/{ => indexer}/index-session.c   |  7 ++--
 .../md/dm-vdo/{ => indexer}/index-session.h   |  3 +-
 drivers/md/dm-vdo/{ => indexer}/index.c       |  5 +--
 drivers/md/dm-vdo/{ => indexer}/index.h       |  0
 drivers/md/dm-vdo/{ => indexer}/indexer.h     |  0
 drivers/md/dm-vdo/{ => indexer}/io-factory.c  |  0
 drivers/md/dm-vdo/{ => indexer}/io-factory.h  |  0
 .../md/dm-vdo/{ => indexer}/open-chapter.c    |  5 +--
 .../md/dm-vdo/{ => indexer}/open-chapter.h    |  0
 drivers/md/dm-vdo/{ => indexer}/radix-sort.c  |  0
 drivers/md/dm-vdo/{ => indexer}/radix-sort.h  |  0
 .../md/dm-vdo/{ => indexer}/sparse-cache.c    |  7 ++--
 .../md/dm-vdo/{ => indexer}/sparse-cache.h    |  0
 .../md/dm-vdo/{ => indexer}/volume-index.c    |  9 ++---
 .../md/dm-vdo/{ => indexer}/volume-index.h    |  3 +-
 drivers/md/dm-vdo/{ => indexer}/volume.c      | 13 +++----
 drivers/md/dm-vdo/{ => indexer}/volume.h      |  5 +--
 drivers/md/dm-vdo/uds-sysfs.c                 |  3 +-
 36 files changed, 77 insertions(+), 56 deletions(-)
 rename drivers/md/dm-vdo/{ => indexer}/chapter-index.c (99%)
 rename drivers/md/dm-vdo/{ => indexer}/chapter-index.h (100%)
 rename drivers/md/dm-vdo/{ => indexer}/config.c (100%)
 rename drivers/md/dm-vdo/{ => indexer}/config.h (100%)
 rename drivers/md/dm-vdo/{ => indexer}/delta-index.c (99%)
 rename drivers/md/dm-vdo/{ => indexer}/delta-index.h (99%)
 rename drivers/md/dm-vdo/{ => indexer}/funnel-requestqueue.c (100%)
 rename drivers/md/dm-vdo/{ => indexer}/funnel-requestqueue.h (100%)
 rename drivers/md/dm-vdo/{ => indexer}/geometry.c (99%)
 rename drivers/md/dm-vdo/{ => indexer}/geometry.h (100%)
 rename drivers/md/dm-vdo/{ => indexer}/hash-utils.h (99%)
 rename drivers/md/dm-vdo/{ => indexer}/index-layout.c (99%)
 rename drivers/md/dm-vdo/{ => indexer}/index-layout.h (100%)
 rename drivers/md/dm-vdo/{ => indexer}/index-page-map.c (99%)
 rename drivers/md/dm-vdo/{ => indexer}/index-page-map.h (100%)
 rename drivers/md/dm-vdo/{ => indexer}/index-session.c (99%)
 rename drivers/md/dm-vdo/{ => indexer}/index-session.h (99%)
 rename drivers/md/dm-vdo/{ => indexer}/index.c (99%)
 rename drivers/md/dm-vdo/{ => indexer}/index.h (100%)
 rename drivers/md/dm-vdo/{ => indexer}/indexer.h (100%)
 rename drivers/md/dm-vdo/{ => indexer}/io-factory.c (100%)
 rename drivers/md/dm-vdo/{ => indexer}/io-factory.h (100%)
 rename drivers/md/dm-vdo/{ => indexer}/open-chapter.c (99%)
 rename drivers/md/dm-vdo/{ => indexer}/open-chapter.h (100%)
 rename drivers/md/dm-vdo/{ => indexer}/radix-sort.c (100%)
 rename drivers/md/dm-vdo/{ => indexer}/radix-sort.h (100%)
 rename drivers/md/dm-vdo/{ => indexer}/sparse-cache.c (99%)
 rename drivers/md/dm-vdo/{ => indexer}/sparse-cache.h (100%)
 rename drivers/md/dm-vdo/{ => indexer}/volume-index.c (99%)
 rename drivers/md/dm-vdo/{ => indexer}/volume-index.h (99%)
 rename drivers/md/dm-vdo/{ => indexer}/volume.c (99%)
 rename drivers/md/dm-vdo/{ => indexer}/volume.h (99%)

diff --git a/drivers/md/dm-vdo/Makefile b/drivers/md/dm-vdo/Makefile
index 32266ab04cc1..502a7a0acbdb 100644
--- a/drivers/md/dm-vdo/Makefile
+++ b/drivers/md/dm-vdo/Makefile
@@ -1,50 +1,39 @@
 # SPDX-License-Identifier: GPL-2.0-only
 
+ccflags-y := -I$(srctree)/$(src) -I$(srctree)/$(src)/indexer
+
 obj-$(CONFIG_DM_VDO) += dm-vdo.o
 
 dm-vdo-objs := \
 	action-manager.o \
 	admin-state.o \
 	block-map.o \
-	chapter-index.o \
 	completion.o \
-	config.o \
 	data-vio.o \
 	dedupe.o \
-	delta-index.o \
 	dm-vdo-target.o \
 	dump.o \
 	encodings.o \
 	errors.o \
 	flush.o \
 	funnel-queue.o \
-	funnel-requestqueue.o \
 	funnel-workqueue.o \
-	geometry.o \
-	index-layout.o \
-	index.o \
-	index-page-map.o \
-	index-session.o \
 	int-map.o \
-	io-factory.o \
 	io-submitter.o \
 	logger.o \
 	logical-zone.o \
 	memory-alloc.o \
 	message-stats.o \
 	murmurhash3.o \
-	open-chapter.o \
 	packer.o \
 	permassert.o \
 	physical-zone.o \
 	pool-sysfs.o \
 	pool-sysfs-stats.o \
 	priority-table.o \
-	radix-sort.o \
 	recovery-journal.o \
 	repair.o \
 	slab-depot.o \
-	sparse-cache.o \
 	status-codes.o \
 	string-utils.o \
 	sysfs.o \
@@ -54,6 +43,19 @@ dm-vdo-objs := \
 	uds-sysfs.o \
 	vdo.o \
 	vio.o \
-	volume-index.o \
-	volume.o \
-	wait-queue.o
+	wait-queue.o \
+	indexer/chapter-index.o \
+	indexer/config.o \
+	indexer/delta-index.o \
+	indexer/funnel-requestqueue.o \
+	indexer/geometry.o \
+	indexer/index.o \
+	indexer/index-layout.o \
+	indexer/index-page-map.o \
+	indexer/index-session.o \
+	indexer/io-factory.o \
+	indexer/open-chapter.o \
+	indexer/radix-sort.o \
+	indexer/sparse-cache.o \
+	indexer/volume.o \
+	indexer/volume-index.o
diff --git a/drivers/md/dm-vdo/data-vio.h b/drivers/md/dm-vdo/data-vio.h
index e7729623a6bb..44fd0d8ccb76 100644
--- a/drivers/md/dm-vdo/data-vio.h
+++ b/drivers/md/dm-vdo/data-vio.h
@@ -10,9 +10,10 @@
 #include <linux/bio.h>
 #include <linux/list.h>
 
-#include "indexer.h"
 #include "permassert.h"
 
+#include "indexer.h"
+
 #include "block-map.h"
 #include "completion.h"
 #include "constants.h"
diff --git a/drivers/md/dm-vdo/dedupe.c b/drivers/md/dm-vdo/dedupe.c
index 942a50ef8b0d..9468d7fad443 100644
--- a/drivers/md/dm-vdo/dedupe.c
+++ b/drivers/md/dm-vdo/dedupe.c
@@ -126,13 +126,14 @@
 #include <linux/spinlock.h>
 #include <linux/timer.h>
 
-#include "indexer.h"
 #include "logger.h"
 #include "memory-alloc.h"
 #include "numeric.h"
 #include "permassert.h"
 #include "string-utils.h"
 
+#include "indexer.h"
+
 #include "action-manager.h"
 #include "admin-state.h"
 #include "completion.h"
diff --git a/drivers/md/dm-vdo/chapter-index.c b/drivers/md/dm-vdo/indexer/chapter-index.c
similarity index 99%
rename from drivers/md/dm-vdo/chapter-index.c
rename to drivers/md/dm-vdo/indexer/chapter-index.c
index 9b9185c2c237..6487825ada90 100644
--- a/drivers/md/dm-vdo/chapter-index.c
+++ b/drivers/md/dm-vdo/indexer/chapter-index.c
@@ -6,12 +6,13 @@
 #include "chapter-index.h"
 
 #include "errors.h"
-#include "hash-utils.h"
-#include "indexer.h"
 #include "logger.h"
 #include "memory-alloc.h"
 #include "permassert.h"
 
+#include "hash-utils.h"
+#include "indexer.h"
+
 int uds_make_open_chapter_index(struct open_chapter_index **chapter_index,
 				const struct index_geometry *geometry, u64 volume_nonce)
 {
diff --git a/drivers/md/dm-vdo/chapter-index.h b/drivers/md/dm-vdo/indexer/chapter-index.h
similarity index 100%
rename from drivers/md/dm-vdo/chapter-index.h
rename to drivers/md/dm-vdo/indexer/chapter-index.h
diff --git a/drivers/md/dm-vdo/config.c b/drivers/md/dm-vdo/indexer/config.c
similarity index 100%
rename from drivers/md/dm-vdo/config.c
rename to drivers/md/dm-vdo/indexer/config.c
diff --git a/drivers/md/dm-vdo/config.h b/drivers/md/dm-vdo/indexer/config.h
similarity index 100%
rename from drivers/md/dm-vdo/config.h
rename to drivers/md/dm-vdo/indexer/config.h
diff --git a/drivers/md/dm-vdo/delta-index.c b/drivers/md/dm-vdo/indexer/delta-index.c
similarity index 99%
rename from drivers/md/dm-vdo/delta-index.c
rename to drivers/md/dm-vdo/indexer/delta-index.c
index 66f51b5f8fd2..4aace707545a 100644
--- a/drivers/md/dm-vdo/delta-index.c
+++ b/drivers/md/dm-vdo/indexer/delta-index.c
@@ -10,10 +10,8 @@
 #include <linux/limits.h>
 #include <linux/log2.h>
 
-#include "config.h"
 #include "cpu.h"
 #include "errors.h"
-#include "indexer.h"
 #include "logger.h"
 #include "memory-alloc.h"
 #include "numeric.h"
@@ -21,6 +19,9 @@
 #include "string-utils.h"
 #include "time-utils.h"
 
+#include "config.h"
+#include "indexer.h"
+
 /*
  * The entries in a delta index could be stored in a single delta list, but to reduce search times
  * and update costs it uses multiple delta lists. These lists are stored in a single chunk of
diff --git a/drivers/md/dm-vdo/delta-index.h b/drivers/md/dm-vdo/indexer/delta-index.h
similarity index 99%
rename from drivers/md/dm-vdo/delta-index.h
rename to drivers/md/dm-vdo/indexer/delta-index.h
index b3b38fb440bf..3d2ea19aef61 100644
--- a/drivers/md/dm-vdo/delta-index.h
+++ b/drivers/md/dm-vdo/indexer/delta-index.h
@@ -8,11 +8,12 @@
 
 #include <linux/cache.h>
 
-#include "config.h"
-#include "io-factory.h"
 #include "numeric.h"
 #include "time-utils.h"
 
+#include "config.h"
+#include "io-factory.h"
+
 /*
  * A delta index is a key-value store, where each entry maps an address (the key) to a payload (the
  * value). The entries are sorted by address, and only the delta between successive addresses is
diff --git a/drivers/md/dm-vdo/funnel-requestqueue.c b/drivers/md/dm-vdo/indexer/funnel-requestqueue.c
similarity index 100%
rename from drivers/md/dm-vdo/funnel-requestqueue.c
rename to drivers/md/dm-vdo/indexer/funnel-requestqueue.c
diff --git a/drivers/md/dm-vdo/funnel-requestqueue.h b/drivers/md/dm-vdo/indexer/funnel-requestqueue.h
similarity index 100%
rename from drivers/md/dm-vdo/funnel-requestqueue.h
rename to drivers/md/dm-vdo/indexer/funnel-requestqueue.h
diff --git a/drivers/md/dm-vdo/geometry.c b/drivers/md/dm-vdo/indexer/geometry.c
similarity index 99%
rename from drivers/md/dm-vdo/geometry.c
rename to drivers/md/dm-vdo/indexer/geometry.c
index 04c07195a01c..38c18283cdde 100644
--- a/drivers/md/dm-vdo/geometry.c
+++ b/drivers/md/dm-vdo/indexer/geometry.c
@@ -8,13 +8,14 @@
 #include <linux/compiler.h>
 #include <linux/log2.h>
 
-#include "delta-index.h"
 #include "errors.h"
-#include "indexer.h"
 #include "logger.h"
 #include "memory-alloc.h"
 #include "permassert.h"
 
+#include "delta-index.h"
+#include "indexer.h"
+
 /*
  * An index volume is divided into a fixed number of fixed-size chapters, each consisting of a
  * fixed number of fixed-size pages. The volume layout is defined by two constants and four
diff --git a/drivers/md/dm-vdo/geometry.h b/drivers/md/dm-vdo/indexer/geometry.h
similarity index 100%
rename from drivers/md/dm-vdo/geometry.h
rename to drivers/md/dm-vdo/indexer/geometry.h
diff --git a/drivers/md/dm-vdo/hash-utils.h b/drivers/md/dm-vdo/indexer/hash-utils.h
similarity index 99%
rename from drivers/md/dm-vdo/hash-utils.h
rename to drivers/md/dm-vdo/indexer/hash-utils.h
index e3b865bbe9b2..6a8dd8ffea6c 100644
--- a/drivers/md/dm-vdo/hash-utils.h
+++ b/drivers/md/dm-vdo/indexer/hash-utils.h
@@ -6,9 +6,10 @@
 #ifndef UDS_HASH_UTILS_H
 #define UDS_HASH_UTILS_H
 
+#include "numeric.h"
+
 #include "geometry.h"
 #include "indexer.h"
-#include "numeric.h"
 
 /* Utilities for extracting portions of a request name for various uses. */
 
diff --git a/drivers/md/dm-vdo/index-layout.c b/drivers/md/dm-vdo/indexer/index-layout.c
similarity index 99%
rename from drivers/md/dm-vdo/index-layout.c
rename to drivers/md/dm-vdo/indexer/index-layout.c
index 2da507b26fd5..af533aa270a8 100644
--- a/drivers/md/dm-vdo/index-layout.c
+++ b/drivers/md/dm-vdo/indexer/index-layout.c
@@ -7,13 +7,14 @@
 
 #include <linux/random.h>
 
-#include "config.h"
 #include "logger.h"
 #include "memory-alloc.h"
 #include "murmurhash3.h"
 #include "numeric.h"
-#include "open-chapter.h"
 #include "time-utils.h"
+
+#include "config.h"
+#include "open-chapter.h"
 #include "volume-index.h"
 
 /*
diff --git a/drivers/md/dm-vdo/index-layout.h b/drivers/md/dm-vdo/indexer/index-layout.h
similarity index 100%
rename from drivers/md/dm-vdo/index-layout.h
rename to drivers/md/dm-vdo/indexer/index-layout.h
diff --git a/drivers/md/dm-vdo/index-page-map.c b/drivers/md/dm-vdo/indexer/index-page-map.c
similarity index 99%
rename from drivers/md/dm-vdo/index-page-map.c
rename to drivers/md/dm-vdo/indexer/index-page-map.c
index 1bb12066ad1a..90d97c33a9c3 100644
--- a/drivers/md/dm-vdo/index-page-map.c
+++ b/drivers/md/dm-vdo/indexer/index-page-map.c
@@ -6,8 +6,6 @@
 #include "index-page-map.h"
 
 #include "errors.h"
-#include "hash-utils.h"
-#include "indexer.h"
 #include "logger.h"
 #include "memory-alloc.h"
 #include "numeric.h"
@@ -15,6 +13,9 @@
 #include "string-utils.h"
 #include "thread-utils.h"
 
+#include "hash-utils.h"
+#include "indexer.h"
+
 /*
  * The index page map is conceptually a two-dimensional array indexed by chapter number and index
  * page number within the chapter. Each entry contains the number of the last delta list on that
diff --git a/drivers/md/dm-vdo/index-page-map.h b/drivers/md/dm-vdo/indexer/index-page-map.h
similarity index 100%
rename from drivers/md/dm-vdo/index-page-map.h
rename to drivers/md/dm-vdo/indexer/index-page-map.h
diff --git a/drivers/md/dm-vdo/index-session.c b/drivers/md/dm-vdo/indexer/index-session.c
similarity index 99%
rename from drivers/md/dm-vdo/index-session.c
rename to drivers/md/dm-vdo/indexer/index-session.c
index a482ccd3981e..07b478f57c68 100644
--- a/drivers/md/dm-vdo/index-session.c
+++ b/drivers/md/dm-vdo/indexer/index-session.c
@@ -7,13 +7,14 @@
 
 #include <linux/atomic.h>
 
-#include "funnel-requestqueue.h"
-#include "index.h"
-#include "index-layout.h"
 #include "logger.h"
 #include "memory-alloc.h"
 #include "time-utils.h"
 
+#include "funnel-requestqueue.h"
+#include "index.h"
+#include "index-layout.h"
+
 /*
  * The index session contains a lock (the request_mutex) which ensures that only one thread can
  * change the state of its index at a time. The state field indicates the current state of the
diff --git a/drivers/md/dm-vdo/index-session.h b/drivers/md/dm-vdo/indexer/index-session.h
similarity index 99%
rename from drivers/md/dm-vdo/index-session.h
rename to drivers/md/dm-vdo/indexer/index-session.h
index 733d10f8a56c..066648f6e062 100644
--- a/drivers/md/dm-vdo/index-session.h
+++ b/drivers/md/dm-vdo/indexer/index-session.h
@@ -9,9 +9,10 @@
 #include <linux/atomic.h>
 #include <linux/cache.h>
 
+#include "thread-utils.h"
+
 #include "config.h"
 #include "indexer.h"
-#include "thread-utils.h"
 
 /*
  * The index session mediates all interactions with a UDS index. Once the index session is created,
diff --git a/drivers/md/dm-vdo/index.c b/drivers/md/dm-vdo/indexer/index.c
similarity index 99%
rename from drivers/md/dm-vdo/index.c
rename to drivers/md/dm-vdo/indexer/index.c
index 9d4a8e5cbaad..35e3b45cdb71 100644
--- a/drivers/md/dm-vdo/index.c
+++ b/drivers/md/dm-vdo/indexer/index.c
@@ -6,10 +6,11 @@
 
 #include "index.h"
 
-#include "funnel-requestqueue.h"
-#include "hash-utils.h"
 #include "logger.h"
 #include "memory-alloc.h"
+
+#include "funnel-requestqueue.h"
+#include "hash-utils.h"
 #include "sparse-cache.h"
 
 static const u64 NO_LAST_SAVE = U64_MAX;
diff --git a/drivers/md/dm-vdo/index.h b/drivers/md/dm-vdo/indexer/index.h
similarity index 100%
rename from drivers/md/dm-vdo/index.h
rename to drivers/md/dm-vdo/indexer/index.h
diff --git a/drivers/md/dm-vdo/indexer.h b/drivers/md/dm-vdo/indexer/indexer.h
similarity index 100%
rename from drivers/md/dm-vdo/indexer.h
rename to drivers/md/dm-vdo/indexer/indexer.h
diff --git a/drivers/md/dm-vdo/io-factory.c b/drivers/md/dm-vdo/indexer/io-factory.c
similarity index 100%
rename from drivers/md/dm-vdo/io-factory.c
rename to drivers/md/dm-vdo/indexer/io-factory.c
diff --git a/drivers/md/dm-vdo/io-factory.h b/drivers/md/dm-vdo/indexer/io-factory.h
similarity index 100%
rename from drivers/md/dm-vdo/io-factory.h
rename to drivers/md/dm-vdo/indexer/io-factory.h
diff --git a/drivers/md/dm-vdo/open-chapter.c b/drivers/md/dm-vdo/indexer/open-chapter.c
similarity index 99%
rename from drivers/md/dm-vdo/open-chapter.c
rename to drivers/md/dm-vdo/indexer/open-chapter.c
index d9d6e5d45bfb..da16afaec07f 100644
--- a/drivers/md/dm-vdo/open-chapter.c
+++ b/drivers/md/dm-vdo/indexer/open-chapter.c
@@ -7,13 +7,14 @@
 
 #include <linux/log2.h>
 
-#include "config.h"
-#include "hash-utils.h"
 #include "logger.h"
 #include "memory-alloc.h"
 #include "numeric.h"
 #include "permassert.h"
 
+#include "config.h"
+#include "hash-utils.h"
+
 /*
  * Each index zone has a dedicated open chapter zone structure which gets an equal share of the
  * open chapter space. Records are assigned to zones based on their record name. Within each zone,
diff --git a/drivers/md/dm-vdo/open-chapter.h b/drivers/md/dm-vdo/indexer/open-chapter.h
similarity index 100%
rename from drivers/md/dm-vdo/open-chapter.h
rename to drivers/md/dm-vdo/indexer/open-chapter.h
diff --git a/drivers/md/dm-vdo/radix-sort.c b/drivers/md/dm-vdo/indexer/radix-sort.c
similarity index 100%
rename from drivers/md/dm-vdo/radix-sort.c
rename to drivers/md/dm-vdo/indexer/radix-sort.c
diff --git a/drivers/md/dm-vdo/radix-sort.h b/drivers/md/dm-vdo/indexer/radix-sort.h
similarity index 100%
rename from drivers/md/dm-vdo/radix-sort.h
rename to drivers/md/dm-vdo/indexer/radix-sort.h
diff --git a/drivers/md/dm-vdo/sparse-cache.c b/drivers/md/dm-vdo/indexer/sparse-cache.c
similarity index 99%
rename from drivers/md/dm-vdo/sparse-cache.c
rename to drivers/md/dm-vdo/indexer/sparse-cache.c
index b43a626a42de..f2141de6ed00 100644
--- a/drivers/md/dm-vdo/sparse-cache.c
+++ b/drivers/md/dm-vdo/indexer/sparse-cache.c
@@ -9,13 +9,14 @@
 #include <linux/delay.h>
 #include <linux/dm-bufio.h>
 
-#include "chapter-index.h"
-#include "config.h"
-#include "index.h"
 #include "logger.h"
 #include "memory-alloc.h"
 #include "permassert.h"
 
+#include "chapter-index.h"
+#include "config.h"
+#include "index.h"
+
 /*
  * Since the cache is small, it is implemented as a simple array of cache entries. Searching for a
  * specific virtual chapter is implemented as a linear search. The cache replacement policy is
diff --git a/drivers/md/dm-vdo/sparse-cache.h b/drivers/md/dm-vdo/indexer/sparse-cache.h
similarity index 100%
rename from drivers/md/dm-vdo/sparse-cache.h
rename to drivers/md/dm-vdo/indexer/sparse-cache.h
diff --git a/drivers/md/dm-vdo/volume-index.c b/drivers/md/dm-vdo/indexer/volume-index.c
similarity index 99%
rename from drivers/md/dm-vdo/volume-index.c
rename to drivers/md/dm-vdo/indexer/volume-index.c
index 36e3c2e3d799..8cbd9280c4bd 100644
--- a/drivers/md/dm-vdo/volume-index.c
+++ b/drivers/md/dm-vdo/indexer/volume-index.c
@@ -10,17 +10,18 @@
 #include <linux/compiler.h>
 #include <linux/log2.h>
 
-#include "config.h"
 #include "errors.h"
-#include "geometry.h"
-#include "hash-utils.h"
-#include "indexer.h"
 #include "logger.h"
 #include "memory-alloc.h"
 #include "numeric.h"
 #include "permassert.h"
 #include "thread-utils.h"
 
+#include "config.h"
+#include "geometry.h"
+#include "hash-utils.h"
+#include "indexer.h"
+
 /*
  * The volume index is a combination of two separate subindexes, one containing sparse hook entries
  * (retained for all chapters), and one containing the remaining entries (retained only for the
diff --git a/drivers/md/dm-vdo/volume-index.h b/drivers/md/dm-vdo/indexer/volume-index.h
similarity index 99%
rename from drivers/md/dm-vdo/volume-index.h
rename to drivers/md/dm-vdo/indexer/volume-index.h
index 66bf14fddc90..583998c547b7 100644
--- a/drivers/md/dm-vdo/volume-index.h
+++ b/drivers/md/dm-vdo/indexer/volume-index.h
@@ -8,10 +8,11 @@
 
 #include <linux/limits.h>
 
+#include "thread-utils.h"
+
 #include "config.h"
 #include "delta-index.h"
 #include "indexer.h"
-#include "thread-utils.h"
 
 /*
  * The volume index is the primary top-level index for UDS. It contains records which map a record
diff --git a/drivers/md/dm-vdo/volume.c b/drivers/md/dm-vdo/indexer/volume.c
similarity index 99%
rename from drivers/md/dm-vdo/volume.c
rename to drivers/md/dm-vdo/indexer/volume.c
index 60416dc8a9d7..eca83b6cab35 100644
--- a/drivers/md/dm-vdo/volume.c
+++ b/drivers/md/dm-vdo/indexer/volume.c
@@ -9,19 +9,20 @@
 #include <linux/dm-bufio.h>
 #include <linux/err.h>
 
-#include "chapter-index.h"
-#include "config.h"
 #include "errors.h"
-#include "geometry.h"
-#include "hash-utils.h"
-#include "index.h"
 #include "logger.h"
 #include "memory-alloc.h"
 #include "permassert.h"
-#include "sparse-cache.h"
 #include "string-utils.h"
 #include "thread-utils.h"
 
+#include "chapter-index.h"
+#include "config.h"
+#include "geometry.h"
+#include "hash-utils.h"
+#include "index.h"
+#include "sparse-cache.h"
+
 /*
  * The first block of the volume layout is reserved for the volume header, which is no longer used.
  * The remainder of the volume is divided into chapters consisting of several pages of records, and
diff --git a/drivers/md/dm-vdo/volume.h b/drivers/md/dm-vdo/indexer/volume.h
similarity index 99%
rename from drivers/md/dm-vdo/volume.h
rename to drivers/md/dm-vdo/indexer/volume.h
index 290de5cbf9ec..8679a5e55347 100644
--- a/drivers/md/dm-vdo/volume.h
+++ b/drivers/md/dm-vdo/indexer/volume.h
@@ -11,16 +11,17 @@
 #include <linux/dm-bufio.h>
 #include <linux/limits.h>
 
+#include "permassert.h"
+#include "thread-utils.h"
+
 #include "chapter-index.h"
 #include "config.h"
 #include "geometry.h"
 #include "indexer.h"
 #include "index-layout.h"
 #include "index-page-map.h"
-#include "permassert.h"
 #include "radix-sort.h"
 #include "sparse-cache.h"
-#include "thread-utils.h"
 
 /*
  * The volume manages deduplication records on permanent storage. The term "volume" can also refer
diff --git a/drivers/md/dm-vdo/uds-sysfs.c b/drivers/md/dm-vdo/uds-sysfs.c
index 1548092e7de1..2c4fb277ba38 100644
--- a/drivers/md/dm-vdo/uds-sysfs.c
+++ b/drivers/md/dm-vdo/uds-sysfs.c
@@ -9,11 +9,12 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 
-#include "indexer.h"
 #include "logger.h"
 #include "memory-alloc.h"
 #include "string-utils.h"
 
+#include "indexer.h"
+
 #define UDS_SYSFS_NAME "uds"
 
 static struct {
-- 
2.42.0

