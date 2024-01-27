Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 791C8BA5F
	for <dm-devel@lists.linux.dev>; Sat, 27 Jan 2024 03:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706324493; cv=none; b=rP4+3uFy858Q9RuOhuhZEAgZjFMn5w5HCjmFeBMh2pG8Kqzozk+1CpDHXZtzyNeWSYMlMvxOoJQm+NI/H48lIqsCiB9Z6Dp0F4Ntr3lIbqVjdsHZlXVCnVeAc8U1Ow4XKQGvoRVVlCOgod1Ubw1CvFiWLgMwrAkw2w6dFAomfDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706324493; c=relaxed/simple;
	bh=Ib7L8H/hDvPyFUHtR5q7ORjFTG608MU0f3lEJndjYag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QhV6zcutzPkt7ab3ZzYXggKBy26aNlGi+xE1VJd3LtBcFOSZfTJIP8Xdd4AuoOeQ8hmnIPc7vvc7wmHqSrcBk9ufjwXiRn2vWSFKJnn15cplDLn1po03aGT1t4UfLnwVhoV8dyv5eUcrGgannDtyjdFza9CWDKeIQEVLo62ECe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KsinfLAq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KsinfLAq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706324490;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CGpAIX93U6r22aJVvjAav61+jnEG/LZ0lOoy7VQn7Zo=;
	b=KsinfLAq4IIHh+66Uez+ifcdT4Q/8OLEBrNov3pLSCccmrz35+rapNA7bB+/K6n2GVrsHW
	tdtSP8pPoWe9Tl1UC6Y7ntf+Jk8j1I4hLsh74ZXEO7HqUYEOr3rxBuun5ZUwMp4HN6khNS
	hqjiTokU2DALIpEw/9L07HYX6e6YCqs=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-436-0Pd-pKgVNSyVj5zyBpG3Tw-1; Fri,
 26 Jan 2024 22:01:27 -0500
X-MC-Unique: 0Pd-pKgVNSyVj5zyBpG3Tw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8A6BF1C04B66;
	Sat, 27 Jan 2024 03:01:27 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 84A432166B32;
	Sat, 27 Jan 2024 03:01:27 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 7D7CE560E2; Fri, 26 Jan 2024 22:01:27 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 1/3] dm vdo slab-depot: fix various small nits
Date: Fri, 26 Jan 2024 22:01:25 -0500
Message-ID: <5ffc61d16c5a8c897178eda8bbe0df3634feafa6.1706324127.git.msakai@redhat.com>
In-Reply-To: <cover.1706324127.git.msakai@redhat.com>
References: <cover.1706324127.git.msakai@redhat.com>
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

Comment typo, whitespace issues, mark function inline.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Chung Chung <cchung@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/slab-depot.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm-vdo/slab-depot.c b/drivers/md/dm-vdo/slab-depot.c
index 56d975c98752..42126bd60242 100644
--- a/drivers/md/dm-vdo/slab-depot.c
+++ b/drivers/md/dm-vdo/slab-depot.c
@@ -1360,7 +1360,7 @@ static unsigned int calculate_slab_priority(struct vdo_slab *slab)
 
 /*
  * Slabs are essentially prioritized by an approximation of the number of free blocks in the slab
- * so slabs with lots of free blocks with be opened for allocation before slabs that have few free
+ * so slabs with lots of free blocks will be opened for allocation before slabs that have few free
  * blocks.
  */
 static void prioritize_slab(struct vdo_slab *slab)
@@ -1374,14 +1374,14 @@ static void prioritize_slab(struct vdo_slab *slab)
 
 /**
  * adjust_free_block_count() - Adjust the free block count and (if needed) reprioritize the slab.
- * @increment: should be true if the free block count went up.
+ * @incremented: true if the free block count went up.
  */
-static void adjust_free_block_count(struct vdo_slab *slab, bool increment)
+static void adjust_free_block_count(struct vdo_slab *slab, bool incremented)
 {
 	struct block_allocator *allocator = slab->allocator;
 
 	WRITE_ONCE(allocator->allocated_blocks,
-		   allocator->allocated_blocks + (increment ? -1 : 1));
+		   allocator->allocated_blocks + (incremented ? -1 : 1));
 
 	/* The open slab doesn't need to be reprioritized until it is closed. */
 	if (slab == allocator->open_slab)
@@ -1747,9 +1747,8 @@ static void add_entry_from_waiter(struct vdo_waiter *waiter, void *context)
 static inline bool is_next_entry_a_block_map_increment(struct slab_journal *journal)
 {
 	struct vdo_waiter *waiter = vdo_waitq_get_first_waiter(&journal->entry_waiters);
-	struct reference_updater *updater = container_of(waiter,
-							 struct reference_updater,
-							 waiter);
+	struct reference_updater *updater =
+		container_of(waiter, struct reference_updater, waiter);
 
 	return (updater->operation == VDO_JOURNAL_BLOCK_MAP_REMAPPING);
 }
@@ -2642,7 +2641,7 @@ static struct vdo_slab *get_next_slab(struct slab_scrubber *scrubber)
  *
  * Return: true if the scrubber has slabs to scrub.
  */
-static bool __must_check has_slabs_to_scrub(struct slab_scrubber *scrubber)
+static inline bool __must_check has_slabs_to_scrub(struct slab_scrubber *scrubber)
 {
 	return (get_next_slab(scrubber) != NULL);
 }
@@ -2817,8 +2816,8 @@ static int apply_block_entries(struct packed_slab_journal_block *block,
 static void apply_journal_entries(struct vdo_completion *completion)
 {
 	int result;
-	struct slab_scrubber *scrubber
-		= container_of(as_vio(completion), struct slab_scrubber, vio);
+	struct slab_scrubber *scrubber =
+		container_of(as_vio(completion), struct slab_scrubber, vio);
 	struct vdo_slab *slab = scrubber->slab;
 	struct slab_journal *journal = &slab->journal;
 
-- 
2.42.0

