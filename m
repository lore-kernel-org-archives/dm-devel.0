Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 737AB56766
	for <dm-devel@lists.linux.dev>; Tue,  6 Feb 2024 02:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707185067; cv=none; b=hs0zcQHBQV4kHI4zBB0r9jAHsBpnAN1bG6faF0E+XZnRLfTfvGWBy2Ds4mTZaqVJTjEeYqXnro5EmwSlAK9WNvtNwXeWSrew4i/ff2MEdr1w6npqxL8IExXrZYZIJoei7qvsCKOHI+SedxR8ojC+EZmqXaZ7KISp0hCbwHJlvIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707185067; c=relaxed/simple;
	bh=Ojs6Y0xoYdr0pXOS88rFZbDg6kwZfb38ana5KhSkQGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZhBAAA5E+sLS7F9JrN9UfJo6xn5ekhQXgdckRwyix1CfDdHcqvMo8PQszIvWAgK+PcbkkAXvOISqs3dBmynBMIGrMalY2F3blqyaRRPkNppBzQsjm2CHgmuLPt1R/GRHpElKMGZlUFiIKFjfb1K13OLwBe8abHy0qdeO4ilFPNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EgwGUIKy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EgwGUIKy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707185064;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cppm0AAV5/kpwWZMY+i724CaJV6s98ZVpMkhhLnGFss=;
	b=EgwGUIKyVUVEB8rjzzQJ//GgUogrPYsiaKfSYK3Qdhv30sf9D/iv0LtMg9m4D6Ua0z8K1j
	5DzHqaKeLlH9VtXpbc3jVqml9Db6A/94pboAYc3LqogWKXcVrIGmoZNk7E2Ik08XZOn+Xr
	M25bGkVGKJuIWVd3ArRzNDwMXVFulPM=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-302-WD1VIUMuMmCs-mnPJ7kDoA-1; Mon,
 05 Feb 2024 21:04:22 -0500
X-MC-Unique: WD1VIUMuMmCs-mnPJ7kDoA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9AEF438117FD;
	Tue,  6 Feb 2024 02:04:22 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 957102026D66;
	Tue,  6 Feb 2024 02:04:22 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 8E41E569F8; Mon,  5 Feb 2024 21:04:22 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 1/7] dm vdo: fix sparse warnings about missing statics
Date: Mon,  5 Feb 2024 21:04:16 -0500
Message-ID: <f3a26da9d9230041ffb18a8987293d28fd9adda1.1707184413.git.msakai@redhat.com>
In-Reply-To: <cover.1707184413.git.msakai@redhat.com>
References: <cover.1707184413.git.msakai@redhat.com>
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

Addresses various sparse warnings like:
warning: symbol 'SYMBOL' was not declared. Should it be static?

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Susan LeGendre-McGhee <slegendr@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/Makefile    |  1 -
 drivers/md/dm-vdo/block-map.c |  2 +-
 drivers/md/dm-vdo/constants.c | 15 ---------------
 drivers/md/dm-vdo/constants.h |  6 +++---
 drivers/md/dm-vdo/encodings.c |  2 +-
 5 files changed, 5 insertions(+), 21 deletions(-)
 delete mode 100644 drivers/md/dm-vdo/constants.c

diff --git a/drivers/md/dm-vdo/Makefile b/drivers/md/dm-vdo/Makefile
index 8f8d161a6dbe..8c06c3b969e3 100644
--- a/drivers/md/dm-vdo/Makefile
+++ b/drivers/md/dm-vdo/Makefile
@@ -9,7 +9,6 @@ dm-vdo-objs := \
 	chapter-index.o \
 	completion.o \
 	config.o \
-	constants.o \
 	data-vio.o \
 	dedupe.o \
 	delta-index.o \
diff --git a/drivers/md/dm-vdo/block-map.c b/drivers/md/dm-vdo/block-map.c
index 54ad6939cab7..1278a5791160 100644
--- a/drivers/md/dm-vdo/block-map.c
+++ b/drivers/md/dm-vdo/block-map.c
@@ -67,7 +67,7 @@ struct block_map_tree_segment {
 
 struct block_map_tree {
 	struct block_map_tree_segment *segments;
-} block_map_tree;
+};
 
 struct forest {
 	struct block_map *map;
diff --git a/drivers/md/dm-vdo/constants.c b/drivers/md/dm-vdo/constants.c
deleted file mode 100644
index 14ac047101f8..000000000000
--- a/drivers/md/dm-vdo/constants.c
+++ /dev/null
@@ -1,15 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * Copyright 2023 Red Hat
- */
-
-#include "types.h"
-
-/* The maximum logical space is 4 petabytes, which is 1 terablock. */
-const block_count_t MAXIMUM_VDO_LOGICAL_BLOCKS = 1024ULL * 1024 * 1024 * 1024;
-
-/* The maximum physical space is 256 terabytes, which is 64 gigablocks. */
-const block_count_t MAXIMUM_VDO_PHYSICAL_BLOCKS = 1024ULL * 1024 * 1024 * 64;
-
-/* unit test minimum */
-const block_count_t MINIMUM_VDO_SLAB_JOURNAL_BLOCKS = 2;
diff --git a/drivers/md/dm-vdo/constants.h b/drivers/md/dm-vdo/constants.h
index 9ae3917d00de..3a997dd7d0b1 100644
--- a/drivers/md/dm-vdo/constants.h
+++ b/drivers/md/dm-vdo/constants.h
@@ -91,12 +91,12 @@ enum {
 };
 
 /** The maximum logical space is 4 petabytes, which is 1 terablock. */
-extern const block_count_t MAXIMUM_VDO_LOGICAL_BLOCKS;
+static const block_count_t MAXIMUM_VDO_LOGICAL_BLOCKS = 1024ULL * 1024 * 1024 * 1024;
 
 /** The maximum physical space is 256 terabytes, which is 64 gigablocks. */
-extern const block_count_t MAXIMUM_VDO_PHYSICAL_BLOCKS;
+static const block_count_t MAXIMUM_VDO_PHYSICAL_BLOCKS = 1024ULL * 1024 * 1024 * 64;
 
 /** unit test minimum */
-extern const block_count_t MINIMUM_VDO_SLAB_JOURNAL_BLOCKS;
+static const block_count_t MINIMUM_VDO_SLAB_JOURNAL_BLOCKS = 2;
 
 #endif /* VDO_CONSTANTS_H */
diff --git a/drivers/md/dm-vdo/encodings.c b/drivers/md/dm-vdo/encodings.c
index 2d9d8645f66b..6b3e9a5b3a91 100644
--- a/drivers/md/dm-vdo/encodings.c
+++ b/drivers/md/dm-vdo/encodings.c
@@ -85,7 +85,7 @@ const struct header VDO_SLAB_DEPOT_HEADER_2_0 = {
 	.size = sizeof(struct slab_depot_state_2_0),
 };
 
-const struct header VDO_LAYOUT_HEADER_3_0 = {
+static const struct header VDO_LAYOUT_HEADER_3_0 = {
 	.id = VDO_LAYOUT,
 	.version = {
 		.major_version = 3,
-- 
2.42.0

