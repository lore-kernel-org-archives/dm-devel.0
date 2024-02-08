Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBAEE80C05
	for <dm-devel@lists.linux.dev>; Thu,  8 Feb 2024 18:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707415760; cv=none; b=kwGSbI5w2Xc7yC3amqaCeuiYpMGXiQtUKRoK2ZCPq/sCo/FA5+6jrdntwHkZJAc2neja/w+PyJvu0VesgXbWmWV00FWPbv8h84Bvf+20jls/KUtyHe2Kv02DcvJrGj79xyddZgJ1WH2EKIQUIvKc1VEGGLpX+K2kcUZPhx/dX6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707415760; c=relaxed/simple;
	bh=irlaGSV5itdCw2m5oYAneHHRQ1/xGvVJ8aRcP7UKuJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bCFftbqPDtUW55dWC/s9Gjr+1mhSLuRRWI8J/OaJS9PQLYu70sMiBhiUxgekOYJiNff2EsdMrnAdNHNlrQeDkZ4WPVponGUSG5SY3CuWrg+F/MU0kYT6UQVfUpuC8DhhYTckr3dihdblJybpfbe1kC6uB254UPLeN8Ifj1Ly+Ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dD1cTF56; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dD1cTF56"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707415757;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zpw/DARoA1ej5K15RZbMC/mP9mMaCQ2cbSnwutlCVME=;
	b=dD1cTF56OltGzgral38e5A1K0YT9g6+7KAUBDGsT/Gon2nwIwtaiQC4bJNaRDhQsLVpih+
	BHjKBzhK7XrSPWgkRq2gBjSfS2Tku9utgosAXPx3XQnWlgnV37mh1v8MaHJ0iK6L+atuHn
	eSafyjQuAlnH1iIiP4+ouMQcFwMm2Lc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-227-ya3v_qLrNbSxNnhNpNFtXg-1; Thu, 08 Feb 2024 13:09:16 -0500
X-MC-Unique: ya3v_qLrNbSxNnhNpNFtXg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1C030101FA30
	for <dm-devel@lists.linux.dev>; Thu,  8 Feb 2024 18:09:16 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 16D2A2BA;
	Thu,  8 Feb 2024 18:09:16 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 123C656C64; Thu,  8 Feb 2024 13:09:16 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 3/3] dm vdo: add documentation details on zones and locking
Date: Thu,  8 Feb 2024 13:09:15 -0500
Message-ID: <1d3315cdb3273ec316fa4d5f3925ca160ad559cf.1707415327.git.msakai@redhat.com>
In-Reply-To: <cover.1707415327.git.msakai@redhat.com>
References: <cover.1707415327.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Add details describing the vdo zone and thread model to the
documentation comments for major vdo components. Also added
some high-level description of the block map structure.

Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/block-map.h        | 15 +++++++++++++++
 drivers/md/dm-vdo/dedupe.c           |  5 +++++
 drivers/md/dm-vdo/recovery-journal.h |  4 ++++
 drivers/md/dm-vdo/slab-depot.h       | 16 +++++++++++-----
 4 files changed, 35 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-vdo/block-map.h b/drivers/md/dm-vdo/block-map.h
index c574bd524bc2..b662c318c2ea 100644
--- a/drivers/md/dm-vdo/block-map.h
+++ b/drivers/md/dm-vdo/block-map.h
@@ -19,6 +19,21 @@
 #include "vio.h"
 #include "wait-queue.h"
 
+/*
+ * The block map is responsible for tracking all the logical to physical mappings of a VDO. It
+ * consists of a collection of 60 radix trees gradually allocated as logical addresses are used.
+ * Each tree is assigned to a logical zone such that it is easy to compute which zone must handle
+ * each logical address. Each logical zone also has a dedicated portion of the leaf page cache.
+ *
+ * Each logical zone has a single dedicated queue and thread for performing all updates to the
+ * radix trees assigned to that zone. The concurrency guarantees of this single-threaded model
+ * allow the code to omit more fine-grained locking for the block map structures.
+ *
+ * Load operations must be performed on the admin thread. Normal operations, such as reading and
+ * updating mappings, must be performed on the appropriate logical zone thread. Save operations
+ * must be launched from the same admin thread as the original load operation.
+ */
+
 enum {
 	BLOCK_MAP_VIO_POOL_SIZE = 64,
 };
diff --git a/drivers/md/dm-vdo/dedupe.c b/drivers/md/dm-vdo/dedupe.c
index 4b00135511dd..d81065a0951c 100644
--- a/drivers/md/dm-vdo/dedupe.c
+++ b/drivers/md/dm-vdo/dedupe.c
@@ -14,6 +14,11 @@
  * deduplicate against a single block instead of being serialized through a PBN read lock. Only one
  * index query is needed for each hash_lock, instead of one for every data_vio.
  *
+ * Hash_locks are assigned to hash_zones by computing a modulus on the hash itself. Each hash_zone
+ * has a single dedicated queue and thread for performing all operations on the hash_locks assigned
+ * to that zone. The concurrency guarantees of this single-threaded model allow the code to omit
+ * more fine-grained locking for the hash_lock structures.
+ *
  * A hash_lock acts like a state machine perhaps more than as a lock. Other than the starting and
  * ending states INITIALIZING and BYPASSING, every state represents and is held for the duration of
  * an asynchronous operation. All state transitions are performed on the thread of the hash_zone
diff --git a/drivers/md/dm-vdo/recovery-journal.h b/drivers/md/dm-vdo/recovery-journal.h
index 19fa7ed9648a..d78c6c7da4ea 100644
--- a/drivers/md/dm-vdo/recovery-journal.h
+++ b/drivers/md/dm-vdo/recovery-journal.h
@@ -26,6 +26,10 @@
  * write amplification of writes by providing amortization of slab journal and block map page
  * updates.
  *
+ * The recovery journal has a single dedicated queue and thread for performing all journal updates.
+ * The concurrency guarantees of this single-threaded model allow the code to omit more
+ * fine-grained locking for recovery journal structures.
+ *
  * The journal consists of a set of on-disk blocks arranged as a circular log with monotonically
  * increasing sequence numbers. Three sequence numbers serve to define the active extent of the
  * journal. The 'head' is the oldest active block in the journal. The 'tail' is the end of the
diff --git a/drivers/md/dm-vdo/slab-depot.h b/drivers/md/dm-vdo/slab-depot.h
index efdef566709a..fba293f9713e 100644
--- a/drivers/md/dm-vdo/slab-depot.h
+++ b/drivers/md/dm-vdo/slab-depot.h
@@ -29,11 +29,17 @@
  * a single array of slabs in order to eliminate the need for additional math in order to compute
  * which physical zone a PBN is in. It also has a block_allocator per zone.
  *
- * Load operations are required to be performed on a single thread. Normal operations are assumed
- * to be performed in the appropriate zone. Allocations and reference count updates must be done
- * from the thread of their physical zone. Requests to commit slab journal tail blocks from the
- * recovery journal must be done on the journal zone thread. Save operations are required to be
- * launched from the same thread as the original load operation.
+ * Each physical zone has a single dedicated queue and thread for performing all updates to the
+ * slabs assigned to that zone. The concurrency guarantees of this single-threaded model allow the
+ * code to omit more fine-grained locking for the various slab structures. Each physical zone
+ * maintains a separate copy of the slab summary to remove the need for explicit locking on that
+ * structure as well.
+ *
+ * Load operations must be performed on the admin thread. Normal operations, such as allocations
+ * and reference count updates, must be performed on the appropriate physical zone thread. Requests
+ * from the recovery journal to commit slab journal tail blocks must be scheduled from the recovery
+ * journal thread to run on the appropriate physical zone thread. Save operations must be launched
+ * from the same admin thread as the original load operation.
  */
 
 enum {
-- 
2.42.0

