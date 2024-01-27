Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80D3C148
	for <dm-devel@lists.linux.dev>; Sat, 27 Jan 2024 03:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706324494; cv=none; b=Yw5je4Vl8yfx0ApvHr0PjsqnzxtS0PGeiYycWgLnFT/ebut+WdLVWcjrqRDFkii773bN+X/Mdk/7qWW90M+MoG4TGWPBUmjO7uMp+5Gaql9z1KA11cHdx0K3MPJFoGW24awk5MD6UflkgqPMiXQaRYVQAk1QstOu5NypgXDzquA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706324494; c=relaxed/simple;
	bh=6QxsblFRxCmPabIdwTmnfvN2yMZsbG9GlrpqBo7d4k4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eGD8Qgru5Wia1nRJlH8Zq/y+jdCfXD4GBo+VLtLVv5LQWuD5X1yzDS2urrGuilPxXt15Tt42zwqeyZINTogngM2ORCGKwRxMpEeAlCkYcG2aJ/GMflThlyP1jazcvoi/1qgCh7D4gGic07oruNdKGmElP+LLqnMH8882xOJ+dl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BPkV8aVh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BPkV8aVh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706324491;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EUa76riJYvt1BZ4O6uadLv5nDjODISijq/hBRJ1eQj0=;
	b=BPkV8aVhI3JFNX7SrJKCTE3IZow9Wr1NSdpDY+qk7cWCjfnUFPaOsVQxR3Eaz/j75/JSv/
	l0Girg6XdAYEuCX/yEREww9ogbAhPyvCftRUWk3Ko/hYgUH8LCXIfiQDg355tpH0ylYeiL
	q1N2wGJ2DJT8lOhAusA8YJEMD+jAMHU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-145-T7R_WaISMNGc9u3p8hRE1g-1; Fri, 26 Jan 2024 22:01:27 -0500
X-MC-Unique: T7R_WaISMNGc9u3p8hRE1g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8D08F185A785;
	Sat, 27 Jan 2024 03:01:27 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 882AB40C9444;
	Sat, 27 Jan 2024 03:01:27 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 8303D560E4; Fri, 26 Jan 2024 22:01:27 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 2/3] dm vdo dedupe: fix various small nits
Date: Fri, 26 Jan 2024 22:01:26 -0500
Message-ID: <0b120dd755a2b39a2b2cc087a4b1315aa42d5467.1706324128.git.msakai@redhat.com>
In-Reply-To: <cover.1706324127.git.msakai@redhat.com>
References: <cover.1706324127.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Mike Snitzer <snitzer@kernel.org>

Remove extra blank line, mark function inline, add missing
braces, and fix a typo in a comment.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Chung Chung <cchung@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/dedupe.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-vdo/dedupe.c b/drivers/md/dm-vdo/dedupe.c
index b3ffb85518c3..8533f1669a01 100644
--- a/drivers/md/dm-vdo/dedupe.c
+++ b/drivers/md/dm-vdo/dedupe.c
@@ -1061,7 +1061,7 @@ static void start_deduping(struct hash_lock *lock, struct data_vio *agent,
  * increment_stat() - Increment a statistic counter in a non-atomic yet thread-safe manner.
  * @stat: The statistic field to increment.
  */
-static void increment_stat(u64 *stat)
+static inline void increment_stat(u64 *stat)
 {
 	/*
 	 * Must only be mutated on the hash zone thread. Prevents any compiler shenanigans from
@@ -1130,7 +1130,6 @@ static bool blocks_equal(char *block1, char *block2)
 {
 	int i;
 
-
 	for (i = 0; i < VDO_BLOCK_SIZE; i += sizeof(u64)) {
 		if (*((u64 *) &block1[i]) != *((u64 *) &block2[i]))
 			return false;
@@ -1456,13 +1455,13 @@ static void finish_writing(struct hash_lock *lock, struct data_vio *agent)
 	lock->duplicate = agent->new_mapped;
 	lock->verified = true;
 
-	if (vdo_is_state_compressed(lock->duplicate.state) &&
-	    lock->registered)
+	if (vdo_is_state_compressed(lock->duplicate.state) && lock->registered) {
 		/*
 		 * Compression means the location we gave in the UDS query is not the location
 		 * we're using to deduplicate.
 		 */
 		lock->update_advice = true;
+	}
 
 	/* If there are any waiters, we need to start deduping them. */
 	if (vdo_waitq_has_waiters(&lock->waiters)) {
@@ -2366,7 +2365,7 @@ static void timeout_index_operations_callback(struct vdo_completion *completion)
 					  DEDUPE_CONTEXT_TIMED_OUT)) {
 			/*
 			 * This context completed between the time the timeout fired, and now. We
-			 * can treat it as a a successful query, its requestor is already enqueued
+			 * can treat it as a successful query, its requestor is already enqueued
 			 * to process it.
 			 */
 			continue;
-- 
2.42.0

