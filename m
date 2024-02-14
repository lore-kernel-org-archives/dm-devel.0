Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F327E4687
	for <dm-devel@lists.linux.dev>; Wed, 14 Feb 2024 01:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707873302; cv=none; b=F5TnIWX1DNLH1F0xOuW1G59WgWLhVcWm7JS8zRkHHCMbLDmWVEPPG25Ry3IjW4Bt0H74Mxg3pOb5IISW52nTej1yYE++01UttR72BvGTByDZbaklvW5q5ZHP2IqbC6eItbNV/V+JwbCz9Q7EFb/rWSrfSO2Kc1gHtLN4QY4xWTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707873302; c=relaxed/simple;
	bh=gst90mjes8U3bhflSH2g/+3crPpJ1f5rbpocjXcemlM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=fJxfKtRVaYS2tOJkMVjyNNM3Ze+bKZJnNOqk4hrQ1+pWKNAJdTF+CEv9nn8VQDthU67UQM/S44Ci5ZKDZIvAnVlFFipUc3pG6cwZr+l/0RLn7+jHO6Socib69mAoKgZVmzhbxxXFfDpJHPw93QG656xaNzYTv51OV46t0V13hms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W8fOc/dF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W8fOc/dF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707873297;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=hXT+ZDWhiHG6UuyTC2OhyOOh/4Uo/cniIV6/XUasXEY=;
	b=W8fOc/dFo3zPbRy4uGycokmAXGLul+YaBO59NQD1x82doDeT9bB9T/fM6sKZzmUulPDqtN
	O21kznJQDwZV8egmno2oxXl0Ckhhcj1xpZkPZot987hezIJrVukb8Zg2TObQPU5IqFXeeX
	MlPZ+FaRA46vz3mwbCMgpwgMHgpXz2A=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-625-OInF3n5iOdyZFLMe3LtYfA-1; Tue, 13 Feb 2024 20:14:56 -0500
X-MC-Unique: OInF3n5iOdyZFLMe3LtYfA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 306FC83B86B
	for <dm-devel@lists.linux.dev>; Wed, 14 Feb 2024 01:14:56 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2A674112131D;
	Wed, 14 Feb 2024 01:14:56 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 221975712E; Tue, 13 Feb 2024 20:14:56 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Ken Raeburn <raeburn@redhat.com>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH] dm vdo: reformat message-stats.c
Date: Tue, 13 Feb 2024 20:14:56 -0500
Message-ID: <83961ad5ef87b019d688b14415dd18d3df46ea9e.1707873187.git.msakai@redhat.com>
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

From: Ken Raeburn <raeburn@redhat.com>

Remove excessive newlines.

Signed-off-by: Ken Raeburn <raeburn@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/message-stats.c | 787 +++++++-----------------------
 1 file changed, 172 insertions(+), 615 deletions(-)

diff --git a/drivers/md/dm-vdo/message-stats.c b/drivers/md/dm-vdo/message-stats.c
index 5be8503ed96e..af964e55b98c 100644
--- a/drivers/md/dm-vdo/message-stats.c
+++ b/drivers/md/dm-vdo/message-stats.c
@@ -11,16 +11,11 @@
 #include "thread-device.h"
 #include "vdo.h"
 
-static int write_u64(char *prefix,
-		     u64 value,
-		     char *suffix,
-		     char **buf,
+static int write_u64(char *prefix, u64 value, char *suffix, char **buf,
 		     unsigned int *maxlen)
 {
-	int count = scnprintf(*buf, *maxlen, "%s%llu%s",
-			      prefix == NULL ? "" : prefix,
-			      value,
-			      suffix == NULL ? "" : suffix);
+	int count = scnprintf(*buf, *maxlen, "%s%llu%s", prefix == NULL ? "" : prefix,
+			      value, suffix == NULL ? "" : suffix);
 	*buf += count;
 	*maxlen -= count;
 	if (count >= *maxlen)
@@ -28,16 +23,11 @@ static int write_u64(char *prefix,
 	return VDO_SUCCESS;
 }
 
-static int write_u32(char *prefix,
-		     u32 value,
-		     char *suffix,
-		     char **buf,
+static int write_u32(char *prefix, u32 value, char *suffix, char **buf,
 		     unsigned int *maxlen)
 {
-	int count = scnprintf(*buf, *maxlen, "%s%u%s",
-			      prefix == NULL ? "" : prefix,
-			      value,
-			      suffix == NULL ? "" : suffix);
+	int count = scnprintf(*buf, *maxlen, "%s%u%s", prefix == NULL ? "" : prefix,
+			      value, suffix == NULL ? "" : suffix);
 	*buf += count;
 	*maxlen -= count;
 	if (count >= *maxlen)
@@ -45,16 +35,11 @@ static int write_u32(char *prefix,
 	return VDO_SUCCESS;
 }
 
-static int write_block_count_t(char *prefix,
-			       block_count_t value,
-			       char *suffix,
-			       char **buf,
-			       unsigned int *maxlen)
+static int write_block_count_t(char *prefix, block_count_t value, char *suffix,
+			       char **buf, unsigned int *maxlen)
 {
-	int count = scnprintf(*buf, *maxlen, "%s%llu%s",
-			      prefix == NULL ? "" : prefix,
-			      value,
-			      suffix == NULL ? "" : suffix);
+	int count = scnprintf(*buf, *maxlen, "%s%llu%s", prefix == NULL ? "" : prefix,
+			      value, suffix == NULL ? "" : suffix);
 	*buf += count;
 	*maxlen -= count;
 	if (count >= *maxlen)
@@ -62,16 +47,11 @@ static int write_block_count_t(char *prefix,
 	return VDO_SUCCESS;
 }
 
-static int write_string(char *prefix,
-			char *value,
-			char *suffix,
-			char **buf,
+static int write_string(char *prefix, char *value, char *suffix, char **buf,
 			unsigned int *maxlen)
 {
-	int count = scnprintf(*buf, *maxlen, "%s%s%s",
-			      prefix == NULL ? "" : prefix,
-			      value,
-			      suffix == NULL ? "" : suffix);
+	int count = scnprintf(*buf, *maxlen, "%s%s%s", prefix == NULL ? "" : prefix,
+			      value, suffix == NULL ? "" : suffix);
 	*buf += count;
 	*maxlen -= count;
 	if (count >= *maxlen)
@@ -79,16 +59,11 @@ static int write_string(char *prefix,
 	return VDO_SUCCESS;
 }
 
-static int write_bool(char *prefix,
-		      bool value,
-		      char *suffix,
-		      char **buf,
+static int write_bool(char *prefix, bool value, char *suffix, char **buf,
 		      unsigned int *maxlen)
 {
-	int count = scnprintf(*buf, *maxlen, "%s%d%s",
-			      prefix == NULL ? "" : prefix,
-			      value,
-			      suffix == NULL ? "" : suffix);
+	int count = scnprintf(*buf, *maxlen, "%s%d%s", prefix == NULL ? "" : prefix,
+			      value, suffix == NULL ? "" : suffix);
 	*buf += count;
 	*maxlen -= count;
 	if (count >= *maxlen)
@@ -96,16 +71,11 @@ static int write_bool(char *prefix,
 	return VDO_SUCCESS;
 }
 
-static int write_u8(char *prefix,
-		    u8 value,
-		    char *suffix,
-		    char **buf,
+static int write_u8(char *prefix, u8 value, char *suffix, char **buf,
 		    unsigned int *maxlen)
 {
-	int count = scnprintf(*buf, *maxlen, "%s%u%s",
-			      prefix == NULL ? "" : prefix,
-			      value,
-			      suffix == NULL ? "" : suffix);
+	int count = scnprintf(*buf, *maxlen, "%s%u%s", prefix == NULL ? "" : prefix,
+			      value, suffix == NULL ? "" : suffix);
 	*buf += count;
 	*maxlen -= count;
 	if (count >= *maxlen)
@@ -115,8 +85,7 @@ static int write_u8(char *prefix,
 
 static int write_block_allocator_statistics(char *prefix,
 					    struct block_allocator_statistics *stats,
-					    char *suffix,
-					    char **buf,
+					    char *suffix, char **buf,
 					    unsigned int *maxlen)
 {
 	int result;
@@ -125,27 +94,15 @@ static int write_block_allocator_statistics(char *prefix,
 	if (result != VDO_SUCCESS)
 		return result;
 	/* The total number of slabs from which blocks may be allocated */
-	result = write_u64("slabCount : ",
-			   stats->slab_count,
-			   ", ",
-			   buf,
-			   maxlen);
+	result = write_u64("slabCount : ", stats->slab_count, ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* The total number of slabs from which blocks have ever been allocated */
-	result = write_u64("slabsOpened : ",
-			   stats->slabs_opened,
-			   ", ",
-			   buf,
-			   maxlen);
+	result = write_u64("slabsOpened : ", stats->slabs_opened, ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* The number of times since loading that a slab has been re-opened */
-	result = write_u64("slabsReopened : ",
-			   stats->slabs_reopened,
-			   ", ",
-			   buf,
-			   maxlen);
+	result = write_u64("slabsReopened : ", stats->slabs_reopened, ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	result = write_string(NULL, "}", suffix, buf, maxlen);
@@ -154,11 +111,8 @@ static int write_block_allocator_statistics(char *prefix,
 	return VDO_SUCCESS;
 }
 
-static int write_commit_statistics(char *prefix,
-				   struct commit_statistics *stats,
-				   char *suffix,
-				   char **buf,
-				   unsigned int *maxlen)
+static int write_commit_statistics(char *prefix, struct commit_statistics *stats,
+				   char *suffix, char **buf, unsigned int *maxlen)
 {
 	int result;
 
@@ -166,27 +120,15 @@ static int write_commit_statistics(char *prefix,
 	if (result != VDO_SUCCESS)
 		return result;
 	/* The total number of items on which processing has started */
-	result = write_u64("started : ",
-			   stats->started,
-			   ", ",
-			   buf,
-			   maxlen);
+	result = write_u64("started : ", stats->started, ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* The total number of items for which a write operation has been issued */
-	result = write_u64("written : ",
-			   stats->written,
-			   ", ",
-			   buf,
-			   maxlen);
+	result = write_u64("written : ", stats->written, ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* The total number of items for which a write operation has completed */
-	result = write_u64("committed : ",
-			   stats->committed,
-			   ", ",
-			   buf,
-			   maxlen);
+	result = write_u64("committed : ", stats->committed, ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	result = write_string(NULL, "}", suffix, buf, maxlen);
@@ -197,8 +139,7 @@ static int write_commit_statistics(char *prefix,
 
 static int write_recovery_journal_statistics(char *prefix,
 					     struct recovery_journal_statistics *stats,
-					     char *suffix,
-					     char **buf,
+					     char *suffix, char **buf,
 					     unsigned int *maxlen)
 {
 	int result;
@@ -207,35 +148,21 @@ static int write_recovery_journal_statistics(char *prefix,
 	if (result != VDO_SUCCESS)
 		return result;
 	/* Number of times the on-disk journal was full */
-	result = write_u64("diskFull : ",
-			   stats->disk_full,
-			   ", ",
-			   buf,
-			   maxlen);
+	result = write_u64("diskFull : ", stats->disk_full, ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* Number of times the recovery journal requested slab journal commits. */
 	result = write_u64("slabJournalCommitsRequested : ",
-			   stats->slab_journal_commits_requested,
-			   ", ",
-			   buf,
-			   maxlen);
+			   stats->slab_journal_commits_requested, ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* Write/Commit totals for individual journal entries */
-	result = write_commit_statistics("entries : ",
-					 &stats->entries,
-					 ", ",
-					 buf,
+	result = write_commit_statistics("entries : ", &stats->entries, ", ", buf,
 					 maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* Write/Commit totals for journal blocks */
-	result = write_commit_statistics("blocks : ",
-					 &stats->blocks,
-					 ", ",
-					 buf,
-					 maxlen);
+	result = write_commit_statistics("blocks : ", &stats->blocks, ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	result = write_string(NULL, "}", suffix, buf, maxlen);
@@ -244,11 +171,8 @@ static int write_recovery_journal_statistics(char *prefix,
 	return VDO_SUCCESS;
 }
 
-static int write_packer_statistics(char *prefix,
-				   struct packer_statistics *stats,
-				   char *suffix,
-				   char **buf,
-				   unsigned int *maxlen)
+static int write_packer_statistics(char *prefix, struct packer_statistics *stats,
+				   char *suffix, char **buf, unsigned int *maxlen)
 {
 	int result;
 
@@ -257,26 +181,17 @@ static int write_packer_statistics(char *prefix,
 		return result;
 	/* Number of compressed data items written since startup */
 	result = write_u64("compressedFragmentsWritten : ",
-			   stats->compressed_fragments_written,
-			   ", ",
-			   buf,
-			   maxlen);
+			   stats->compressed_fragments_written, ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* Number of blocks containing compressed items written since startup */
 	result = write_u64("compressedBlocksWritten : ",
-			   stats->compressed_blocks_written,
-			   ", ",
-			   buf,
-			   maxlen);
+			   stats->compressed_blocks_written, ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* Number of VIOs that are pending in the packer */
 	result = write_u64("compressedFragmentsInPacker : ",
-			   stats->compressed_fragments_in_packer,
-			   ", ",
-			   buf,
-			   maxlen);
+			   stats->compressed_fragments_in_packer, ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	result = write_string(NULL, "}", suffix, buf, maxlen);
@@ -287,9 +202,7 @@ static int write_packer_statistics(char *prefix,
 
 static int write_slab_journal_statistics(char *prefix,
 					 struct slab_journal_statistics *stats,
-					 char *suffix,
-					 char **buf,
-					 unsigned int *maxlen)
+					 char *suffix, char **buf, unsigned int *maxlen)
 {
 	int result;
 
@@ -297,42 +210,24 @@ static int write_slab_journal_statistics(char *prefix,
 	if (result != VDO_SUCCESS)
 		return result;
 	/* Number of times the on-disk journal was full */
-	result = write_u64("diskFullCount : ",
-			   stats->disk_full_count,
-			   ", ",
-			   buf,
+	result = write_u64("diskFullCount : ", stats->disk_full_count, ", ", buf,
 			   maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* Number of times an entry was added over the flush threshold */
-	result = write_u64("flushCount : ",
-			   stats->flush_count,
-			   ", ",
-			   buf,
-			   maxlen);
+	result = write_u64("flushCount : ", stats->flush_count, ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* Number of times an entry was added over the block threshold */
-	result = write_u64("blockedCount : ",
-			   stats->blocked_count,
-			   ", ",
-			   buf,
-			   maxlen);
+	result = write_u64("blockedCount : ", stats->blocked_count, ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* Number of times a tail block was written */
-	result = write_u64("blocksWritten : ",
-			   stats->blocks_written,
-			   ", ",
-			   buf,
-			   maxlen);
+	result = write_u64("blocksWritten : ", stats->blocks_written, ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* Number of times we had to wait for the tail to write */
-	result = write_u64("tailBusyCount : ",
-			   stats->tail_busy_count,
-			   ", ",
-			   buf,
+	result = write_u64("tailBusyCount : ", stats->tail_busy_count, ", ", buf,
 			   maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
@@ -344,9 +239,7 @@ static int write_slab_journal_statistics(char *prefix,
 
 static int write_slab_summary_statistics(char *prefix,
 					 struct slab_summary_statistics *stats,
-					 char *suffix,
-					 char **buf,
-					 unsigned int *maxlen)
+					 char *suffix, char **buf, unsigned int *maxlen)
 {
 	int result;
 
@@ -354,11 +247,7 @@ static int write_slab_summary_statistics(char *prefix,
 	if (result != VDO_SUCCESS)
 		return result;
 	/* Number of blocks written */
-	result = write_u64("blocksWritten : ",
-			   stats->blocks_written,
-			   ", ",
-			   buf,
-			   maxlen);
+	result = write_u64("blocksWritten : ", stats->blocks_written, ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	result = write_string(NULL, "}", suffix, buf, maxlen);
@@ -367,11 +256,8 @@ static int write_slab_summary_statistics(char *prefix,
 	return VDO_SUCCESS;
 }
 
-static int write_ref_counts_statistics(char *prefix,
-				       struct ref_counts_statistics *stats,
-				       char *suffix,
-				       char **buf,
-				       unsigned int *maxlen)
+static int write_ref_counts_statistics(char *prefix, struct ref_counts_statistics *stats,
+				       char *suffix, char **buf, unsigned int *maxlen)
 {
 	int result;
 
@@ -379,11 +265,7 @@ static int write_ref_counts_statistics(char *prefix,
 	if (result != VDO_SUCCESS)
 		return result;
 	/* Number of reference blocks written */
-	result = write_u64("blocksWritten : ",
-			   stats->blocks_written,
-			   ", ",
-			   buf,
-			   maxlen);
+	result = write_u64("blocksWritten : ", stats->blocks_written, ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	result = write_string(NULL, "}", suffix, buf, maxlen);
@@ -392,11 +274,8 @@ static int write_ref_counts_statistics(char *prefix,
 	return VDO_SUCCESS;
 }
 
-static int write_block_map_statistics(char *prefix,
-				      struct block_map_statistics *stats,
-				      char *suffix,
-				      char **buf,
-				      unsigned int *maxlen)
+static int write_block_map_statistics(char *prefix, struct block_map_statistics *stats,
+				      char *suffix, char **buf, unsigned int *maxlen)
 {
 	int result;
 
@@ -404,163 +283,84 @@ static int write_block_map_statistics(char *prefix,
 	if (result != VDO_SUCCESS)
 		return result;
 	/* number of dirty (resident) pages */
-	result = write_u32("dirtyPages : ",
-			   stats->dirty_pages,
-			   ", ",
-			   buf,
-			   maxlen);
+	result = write_u32("dirtyPages : ", stats->dirty_pages, ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* number of clean (resident) pages */
-	result = write_u32("cleanPages : ",
-			   stats->clean_pages,
-			   ", ",
-			   buf,
-			   maxlen);
+	result = write_u32("cleanPages : ", stats->clean_pages, ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* number of free pages */
-	result = write_u32("freePages : ",
-			   stats->free_pages,
-			   ", ",
-			   buf,
-			   maxlen);
+	result = write_u32("freePages : ", stats->free_pages, ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* number of pages in failed state */
-	result = write_u32("failedPages : ",
-			   stats->failed_pages,
-			   ", ",
-			   buf,
-			   maxlen);
+	result = write_u32("failedPages : ", stats->failed_pages, ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* number of pages incoming */
-	result = write_u32("incomingPages : ",
-			   stats->incoming_pages,
-			   ", ",
-			   buf,
-			   maxlen);
+	result = write_u32("incomingPages : ", stats->incoming_pages, ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* number of pages outgoing */
-	result = write_u32("outgoingPages : ",
-			   stats->outgoing_pages,
-			   ", ",
-			   buf,
-			   maxlen);
+	result = write_u32("outgoingPages : ", stats->outgoing_pages, ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* how many times free page not avail */
-	result = write_u32("cachePressure : ",
-			   stats->cache_pressure,
-			   ", ",
-			   buf,
-			   maxlen);
+	result = write_u32("cachePressure : ", stats->cache_pressure, ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* number of get_vdo_page() calls for read */
-	result = write_u64("readCount : ",
-			   stats->read_count,
-			   ", ",
-			   buf,
-			   maxlen);
+	result = write_u64("readCount : ", stats->read_count, ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* number of get_vdo_page() calls for write */
-	result = write_u64("writeCount : ",
-			   stats->write_count,
-			   ", ",
-			   buf,
-			   maxlen);
+	result = write_u64("writeCount : ", stats->write_count, ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* number of times pages failed to read */
-	result = write_u64("failedReads : ",
-			   stats->failed_reads,
-			   ", ",
-			   buf,
-			   maxlen);
+	result = write_u64("failedReads : ", stats->failed_reads, ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* number of times pages failed to write */
-	result = write_u64("failedWrites : ",
-			   stats->failed_writes,
-			   ", ",
-			   buf,
-			   maxlen);
+	result = write_u64("failedWrites : ", stats->failed_writes, ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* number of gets that are reclaimed */
-	result = write_u64("reclaimed : ",
-			   stats->reclaimed,
-			   ", ",
-			   buf,
-			   maxlen);
+	result = write_u64("reclaimed : ", stats->reclaimed, ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* number of gets for outgoing pages */
-	result = write_u64("readOutgoing : ",
-			   stats->read_outgoing,
-			   ", ",
-			   buf,
-			   maxlen);
+	result = write_u64("readOutgoing : ", stats->read_outgoing, ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* number of gets that were already there */
-	result = write_u64("foundInCache : ",
-			   stats->found_in_cache,
-			   ", ",
-			   buf,
-			   maxlen);
+	result = write_u64("foundInCache : ", stats->found_in_cache, ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* number of gets requiring discard */
-	result = write_u64("discardRequired : ",
-			   stats->discard_required,
-			   ", ",
-			   buf,
+	result = write_u64("discardRequired : ", stats->discard_required, ", ", buf,
 			   maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* number of gets enqueued for their page */
-	result = write_u64("waitForPage : ",
-			   stats->wait_for_page,
-			   ", ",
-			   buf,
-			   maxlen);
+	result = write_u64("waitForPage : ", stats->wait_for_page, ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* number of gets that have to fetch */
-	result = write_u64("fetchRequired : ",
-			   stats->fetch_required,
-			   ", ",
-			   buf,
-			   maxlen);
+	result = write_u64("fetchRequired : ", stats->fetch_required, ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* number of page fetches */
-	result = write_u64("pagesLoaded : ",
-			   stats->pages_loaded,
-			   ", ",
-			   buf,
-			   maxlen);
+	result = write_u64("pagesLoaded : ", stats->pages_loaded, ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* number of page saves */
-	result = write_u64("pagesSaved : ",
-			   stats->pages_saved,
-			   ", ",
-			   buf,
-			   maxlen);
+	result = write_u64("pagesSaved : ", stats->pages_saved, ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* the number of flushes issued */
-	result = write_u64("flushCount : ",
-			   stats->flush_count,
-			   ", ",
-			   buf,
-			   maxlen);
+	result = write_u64("flushCount : ", stats->flush_count, ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	result = write_string(NULL, "}", suffix, buf, maxlen);
@@ -569,11 +369,8 @@ static int write_block_map_statistics(char *prefix,
 	return VDO_SUCCESS;
 }
 
-static int write_hash_lock_statistics(char *prefix,
-				      struct hash_lock_statistics *stats,
-				      char *suffix,
-				      char **buf,
-				      unsigned int *maxlen)
+static int write_hash_lock_statistics(char *prefix, struct hash_lock_statistics *stats,
+				      char *suffix, char **buf, unsigned int *maxlen)
 {
 	int result;
 
@@ -581,42 +378,27 @@ static int write_hash_lock_statistics(char *prefix,
 	if (result != VDO_SUCCESS)
 		return result;
 	/* Number of times the UDS advice proved correct */
-	result = write_u64("dedupeAdviceValid : ",
-			   stats->dedupe_advice_valid,
-			   ", ",
-			   buf,
+	result = write_u64("dedupeAdviceValid : ", stats->dedupe_advice_valid, ", ", buf,
 			   maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* Number of times the UDS advice proved incorrect */
-	result = write_u64("dedupeAdviceStale : ",
-			   stats->dedupe_advice_stale,
-			   ", ",
-			   buf,
+	result = write_u64("dedupeAdviceStale : ", stats->dedupe_advice_stale, ", ", buf,
 			   maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* Number of writes with the same data as another in-flight write */
-	result = write_u64("concurrentDataMatches : ",
-			   stats->concurrent_data_matches,
-			   ", ",
-			   buf,
-			   maxlen);
+	result = write_u64("concurrentDataMatches : ", stats->concurrent_data_matches,
+			   ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* Number of writes whose hash collided with an in-flight write */
 	result = write_u64("concurrentHashCollisions : ",
-			   stats->concurrent_hash_collisions,
-			   ", ",
-			   buf,
-			   maxlen);
+			   stats->concurrent_hash_collisions, ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* Current number of dedupe queries that are in flight */
-	result = write_u32("currDedupeQueries : ",
-			   stats->curr_dedupe_queries,
-			   ", ",
-			   buf,
+	result = write_u32("currDedupeQueries : ", stats->curr_dedupe_queries, ", ", buf,
 			   maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
@@ -626,11 +408,8 @@ static int write_hash_lock_statistics(char *prefix,
 	return VDO_SUCCESS;
 }
 
-static int write_error_statistics(char *prefix,
-				  struct error_statistics *stats,
-				  char *suffix,
-				  char **buf,
-				  unsigned int *maxlen)
+static int write_error_statistics(char *prefix, struct error_statistics *stats,
+				  char *suffix, char **buf, unsigned int *maxlen)
 {
 	int result;
 
@@ -638,27 +417,18 @@ static int write_error_statistics(char *prefix,
 	if (result != VDO_SUCCESS)
 		return result;
 	/* number of times VDO got an invalid dedupe advice PBN from UDS */
-	result = write_u64("invalidAdvicePBNCount : ",
-			   stats->invalid_advice_pbn_count,
-			   ", ",
-			   buf,
-			   maxlen);
+	result = write_u64("invalidAdvicePBNCount : ", stats->invalid_advice_pbn_count,
+			   ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* number of times a VIO completed with a VDO_NO_SPACE error */
-	result = write_u64("noSpaceErrorCount : ",
-			   stats->no_space_error_count,
-			   ", ",
-			   buf,
-			   maxlen);
+	result = write_u64("noSpaceErrorCount : ", stats->no_space_error_count, ", ",
+			   buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* number of times a VIO completed with a VDO_READ_ONLY error */
-	result = write_u64("readOnlyErrorCount : ",
-			   stats->read_only_error_count,
-			   ", ",
-			   buf,
-			   maxlen);
+	result = write_u64("readOnlyErrorCount : ", stats->read_only_error_count, ", ",
+			   buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	result = write_string(NULL, "}", suffix, buf, maxlen);
@@ -667,11 +437,8 @@ static int write_error_statistics(char *prefix,
 	return VDO_SUCCESS;
 }
 
-static int write_bio_stats(char *prefix,
-			   struct bio_stats *stats,
-			   char *suffix,
-			   char **buf,
-			   unsigned int *maxlen)
+static int write_bio_stats(char *prefix, struct bio_stats *stats, char *suffix,
+			   char **buf, unsigned int *maxlen)
 {
 	int result;
 
@@ -679,51 +446,27 @@ static int write_bio_stats(char *prefix,
 	if (result != VDO_SUCCESS)
 		return result;
 	/* Number of REQ_OP_READ bios */
-	result = write_u64("read : ",
-			   stats->read,
-			   ", ",
-			   buf,
-			   maxlen);
+	result = write_u64("read : ", stats->read, ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* Number of REQ_OP_WRITE bios with data */
-	result = write_u64("write : ",
-			   stats->write,
-			   ", ",
-			   buf,
-			   maxlen);
+	result = write_u64("write : ", stats->write, ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* Number of bios tagged with REQ_PREFLUSH and containing no data */
-	result = write_u64("emptyFlush : ",
-			   stats->empty_flush,
-			   ", ",
-			   buf,
-			   maxlen);
+	result = write_u64("emptyFlush : ", stats->empty_flush, ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* Number of REQ_OP_DISCARD bios */
-	result = write_u64("discard : ",
-			   stats->discard,
-			   ", ",
-			   buf,
-			   maxlen);
+	result = write_u64("discard : ", stats->discard, ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* Number of bios tagged with REQ_PREFLUSH */
-	result = write_u64("flush : ",
-			   stats->flush,
-			   ", ",
-			   buf,
-			   maxlen);
+	result = write_u64("flush : ", stats->flush, ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* Number of bios tagged with REQ_FUA */
-	result = write_u64("fua : ",
-			   stats->fua,
-			   ", ",
-			   buf,
-			   maxlen);
+	result = write_u64("fua : ", stats->fua, ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	result = write_string(NULL, "}", suffix, buf, maxlen);
@@ -732,11 +475,8 @@ static int write_bio_stats(char *prefix,
 	return VDO_SUCCESS;
 }
 
-static int write_memory_usage(char *prefix,
-			      struct memory_usage *stats,
-			      char *suffix,
-			      char **buf,
-			      unsigned int *maxlen)
+static int write_memory_usage(char *prefix, struct memory_usage *stats, char *suffix,
+			      char **buf, unsigned int *maxlen)
 {
 	int result;
 
@@ -744,18 +484,11 @@ static int write_memory_usage(char *prefix,
 	if (result != VDO_SUCCESS)
 		return result;
 	/* Tracked bytes currently allocated. */
-	result = write_u64("bytesUsed : ",
-			   stats->bytes_used,
-			   ", ",
-			   buf,
-			   maxlen);
+	result = write_u64("bytesUsed : ", stats->bytes_used, ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* Maximum tracked bytes allocated. */
-	result = write_u64("peakBytesUsed : ",
-			   stats->peak_bytes_used,
-			   ", ",
-			   buf,
+	result = write_u64("peakBytesUsed : ", stats->peak_bytes_used, ", ", buf,
 			   maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
@@ -765,11 +498,8 @@ static int write_memory_usage(char *prefix,
 	return VDO_SUCCESS;
 }
 
-static int write_index_statistics(char *prefix,
-				  struct index_statistics *stats,
-				  char *suffix,
-				  char **buf,
-				  unsigned int *maxlen)
+static int write_index_statistics(char *prefix, struct index_statistics *stats,
+				  char *suffix, char **buf, unsigned int *maxlen)
 {
 	int result;
 
@@ -777,66 +507,39 @@ static int write_index_statistics(char *prefix,
 	if (result != VDO_SUCCESS)
 		return result;
 	/* Number of records stored in the index */
-	result = write_u64("entriesIndexed : ",
-			   stats->entries_indexed,
-			   ", ",
-			   buf,
+	result = write_u64("entriesIndexed : ", stats->entries_indexed, ", ", buf,
 			   maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* Number of post calls that found an existing entry */
-	result = write_u64("postsFound : ",
-			   stats->posts_found,
-			   ", ",
-			   buf,
-			   maxlen);
+	result = write_u64("postsFound : ", stats->posts_found, ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* Number of post calls that added a new entry */
-	result = write_u64("postsNotFound : ",
-			   stats->posts_not_found,
-			   ", ",
-			   buf,
+	result = write_u64("postsNotFound : ", stats->posts_not_found, ", ", buf,
 			   maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* Number of query calls that found an existing entry */
-	result = write_u64("queriesFound : ",
-			   stats->queries_found,
-			   ", ",
-			   buf,
-			   maxlen);
+	result = write_u64("queriesFound : ", stats->queries_found, ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* Number of query calls that added a new entry */
-	result = write_u64("queriesNotFound : ",
-			   stats->queries_not_found,
-			   ", ",
-			   buf,
+	result = write_u64("queriesNotFound : ", stats->queries_not_found, ", ", buf,
 			   maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* Number of update calls that found an existing entry */
-	result = write_u64("updatesFound : ",
-			   stats->updates_found,
-			   ", ",
-			   buf,
-			   maxlen);
+	result = write_u64("updatesFound : ", stats->updates_found, ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* Number of update calls that added a new entry */
-	result = write_u64("updatesNotFound : ",
-			   stats->updates_not_found,
-			   ", ",
-			   buf,
+	result = write_u64("updatesNotFound : ", stats->updates_not_found, ", ", buf,
 			   maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* Number of entries discarded */
-	result = write_u64("entriesDiscarded : ",
-			   stats->entries_discarded,
-			   ", ",
-			   buf,
+	result = write_u64("entriesDiscarded : ", stats->entries_discarded, ", ", buf,
 			   maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
@@ -846,349 +549,205 @@ static int write_index_statistics(char *prefix,
 	return VDO_SUCCESS;
 }
 
-static int write_vdo_statistics(char *prefix,
-				struct vdo_statistics *stats,
-				char *suffix,
-				char **buf,
-				unsigned int *maxlen)
+static int write_vdo_statistics(char *prefix, struct vdo_statistics *stats, char *suffix,
+				char **buf, unsigned int *maxlen)
 {
 	int result;
 
 	result = write_string(prefix, "{ ", NULL, buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
-	result = write_u32("version : ",
-			   stats->version,
-			   ", ",
-			   buf,
-			   maxlen);
+	result = write_u32("version : ", stats->version, ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* Number of blocks used for data */
-	result = write_u64("dataBlocksUsed : ",
-			   stats->data_blocks_used,
-			   ", ",
-			   buf,
+	result = write_u64("dataBlocksUsed : ", stats->data_blocks_used, ", ", buf,
 			   maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* Number of blocks used for VDO metadata */
-	result = write_u64("overheadBlocksUsed : ",
-			   stats->overhead_blocks_used,
-			   ", ",
-			   buf,
-			   maxlen);
+	result = write_u64("overheadBlocksUsed : ", stats->overhead_blocks_used, ", ",
+			   buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* Number of logical blocks that are currently mapped to physical blocks */
-	result = write_u64("logicalBlocksUsed : ",
-			   stats->logical_blocks_used,
-			   ", ",
-			   buf,
+	result = write_u64("logicalBlocksUsed : ", stats->logical_blocks_used, ", ", buf,
 			   maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* number of physical blocks */
-	result = write_block_count_t("physicalBlocks : ",
-				     stats->physical_blocks,
-				     ", ",
-				     buf,
-				     maxlen);
+	result = write_block_count_t("physicalBlocks : ", stats->physical_blocks, ", ",
+				     buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* number of logical blocks */
-	result = write_block_count_t("logicalBlocks : ",
-				     stats->logical_blocks,
-				     ", ",
-				     buf,
-				     maxlen);
+	result = write_block_count_t("logicalBlocks : ", stats->logical_blocks, ", ",
+				     buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* Size of the block map page cache, in bytes */
-	result = write_u64("blockMapCacheSize : ",
-			   stats->block_map_cache_size,
-			   ", ",
-			   buf,
-			   maxlen);
+	result = write_u64("blockMapCacheSize : ", stats->block_map_cache_size, ", ",
+			   buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* The physical block size */
-	result = write_u64("blockSize : ",
-			   stats->block_size,
-			   ", ",
-			   buf,
-			   maxlen);
+	result = write_u64("blockSize : ", stats->block_size, ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* Number of times the VDO has successfully recovered */
-	result = write_u64("completeRecoveries : ",
-			   stats->complete_recoveries,
-			   ", ",
-			   buf,
-			   maxlen);
+	result = write_u64("completeRecoveries : ", stats->complete_recoveries, ", ",
+			   buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* Number of times the VDO has recovered from read-only mode */
-	result = write_u64("readOnlyRecoveries : ",
-			   stats->read_only_recoveries,
-			   ", ",
-			   buf,
-			   maxlen);
+	result = write_u64("readOnlyRecoveries : ", stats->read_only_recoveries, ", ",
+			   buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* String describing the operating mode of the VDO */
-	result = write_string("mode : ",
-			      stats->mode,
-			      ", ",
-			      buf,
-			      maxlen);
+	result = write_string("mode : ", stats->mode, ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* Whether the VDO is in recovery mode */
-	result = write_bool("inRecoveryMode : ",
-			    stats->in_recovery_mode,
-			    ", ",
-			    buf,
+	result = write_bool("inRecoveryMode : ", stats->in_recovery_mode, ", ", buf,
 			    maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* What percentage of recovery mode work has been completed */
-	result = write_u8("recoveryPercentage : ",
-			  stats->recovery_percentage,
-			  ", ",
-			  buf,
+	result = write_u8("recoveryPercentage : ", stats->recovery_percentage, ", ", buf,
 			  maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* The statistics for the compressed block packer */
-	result = write_packer_statistics("packer : ",
-					 &stats->packer,
-					 ", ",
-					 buf,
-					 maxlen);
+	result = write_packer_statistics("packer : ", &stats->packer, ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* Counters for events in the block allocator */
-	result = write_block_allocator_statistics("allocator : ",
-						  &stats->allocator,
-						  ", ",
-						  buf,
-						  maxlen);
+	result = write_block_allocator_statistics("allocator : ", &stats->allocator,
+						  ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* Counters for events in the recovery journal */
-	result = write_recovery_journal_statistics("journal : ",
-						   &stats->journal,
-						   ", ",
-						   buf,
-						   maxlen);
+	result = write_recovery_journal_statistics("journal : ", &stats->journal, ", ",
+						   buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* The statistics for the slab journals */
-	result = write_slab_journal_statistics("slabJournal : ",
-					       &stats->slab_journal,
-					       ", ",
-					       buf,
-					       maxlen);
+	result = write_slab_journal_statistics("slabJournal : ", &stats->slab_journal,
+					       ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* The statistics for the slab summary */
-	result = write_slab_summary_statistics("slabSummary : ",
-					       &stats->slab_summary,
-					       ", ",
-					       buf,
-					       maxlen);
+	result = write_slab_summary_statistics("slabSummary : ", &stats->slab_summary,
+					       ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* The statistics for the reference counts */
-	result = write_ref_counts_statistics("refCounts : ",
-					     &stats->ref_counts,
-					     ", ",
-					     buf,
-					     maxlen);
+	result = write_ref_counts_statistics("refCounts : ", &stats->ref_counts, ", ",
+					     buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* The statistics for the block map */
-	result = write_block_map_statistics("blockMap : ",
-					    &stats->block_map,
-					    ", ",
-					    buf,
+	result = write_block_map_statistics("blockMap : ", &stats->block_map, ", ", buf,
 					    maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* The dedupe statistics from hash locks */
-	result = write_hash_lock_statistics("hashLock : ",
-					    &stats->hash_lock,
-					    ", ",
-					    buf,
+	result = write_hash_lock_statistics("hashLock : ", &stats->hash_lock, ", ", buf,
 					    maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* Counts of error conditions */
-	result = write_error_statistics("errors : ",
-					&stats->errors,
-					", ",
-					buf,
-					maxlen);
+	result = write_error_statistics("errors : ", &stats->errors, ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* The VDO instance */
-	result = write_u32("instance : ",
-			   stats->instance,
-			   ", ",
-			   buf,
-			   maxlen);
+	result = write_u32("instance : ", stats->instance, ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* Current number of active VIOs */
-	result = write_u32("currentVIOsInProgress : ",
-			   stats->current_vios_in_progress,
-			   ", ",
-			   buf,
-			   maxlen);
+	result = write_u32("currentVIOsInProgress : ", stats->current_vios_in_progress,
+			   ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* Maximum number of active VIOs */
-	result = write_u32("maxVIOs : ",
-			   stats->max_vios,
-			   ", ",
-			   buf,
-			   maxlen);
+	result = write_u32("maxVIOs : ", stats->max_vios, ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* Number of times the UDS index was too slow in responding */
-	result = write_u64("dedupeAdviceTimeouts : ",
-			   stats->dedupe_advice_timeouts,
-			   ", ",
-			   buf,
-			   maxlen);
+	result = write_u64("dedupeAdviceTimeouts : ", stats->dedupe_advice_timeouts,
+			   ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* Number of flush requests submitted to the storage device */
-	result = write_u64("flushOut : ",
-			   stats->flush_out,
-			   ", ",
-			   buf,
-			   maxlen);
+	result = write_u64("flushOut : ", stats->flush_out, ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* Logical block size */
-	result = write_u64("logicalBlockSize : ",
-			   stats->logical_block_size,
-			   ", ",
-			   buf,
+	result = write_u64("logicalBlockSize : ", stats->logical_block_size, ", ", buf,
 			   maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* Bios submitted into VDO from above */
-	result = write_bio_stats("biosIn : ",
-				 &stats->bios_in,
-				 ", ",
-				 buf,
-				 maxlen);
+	result = write_bio_stats("biosIn : ", &stats->bios_in, ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
-	result = write_bio_stats("biosInPartial : ",
-				 &stats->bios_in_partial,
-				 ", ",
-				 buf,
+	result = write_bio_stats("biosInPartial : ", &stats->bios_in_partial, ", ", buf,
 				 maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* Bios submitted onward for user data */
-	result = write_bio_stats("biosOut : ",
-				 &stats->bios_out,
-				 ", ",
-				 buf,
-				 maxlen);
+	result = write_bio_stats("biosOut : ", &stats->bios_out, ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* Bios submitted onward for metadata */
-	result = write_bio_stats("biosMeta : ",
-				 &stats->bios_meta,
-				 ", ",
-				 buf,
-				 maxlen);
+	result = write_bio_stats("biosMeta : ", &stats->bios_meta, ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
-	result = write_bio_stats("biosJournal : ",
-				 &stats->bios_journal,
-				 ", ",
-				 buf,
+	result = write_bio_stats("biosJournal : ", &stats->bios_journal, ", ", buf,
 				 maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
-	result = write_bio_stats("biosPageCache : ",
-				 &stats->bios_page_cache,
-				 ", ",
-				 buf,
+	result = write_bio_stats("biosPageCache : ", &stats->bios_page_cache, ", ", buf,
 				 maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
-	result = write_bio_stats("biosOutCompleted : ",
-				 &stats->bios_out_completed,
-				 ", ",
-				 buf,
-				 maxlen);
+	result = write_bio_stats("biosOutCompleted : ", &stats->bios_out_completed, ", ",
+				 buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
-	result = write_bio_stats("biosMetaCompleted : ",
-				 &stats->bios_meta_completed,
-				 ", ",
-				 buf,
-				 maxlen);
+	result = write_bio_stats("biosMetaCompleted : ", &stats->bios_meta_completed,
+				 ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	result = write_bio_stats("biosJournalCompleted : ",
-				 &stats->bios_journal_completed,
-				 ", ",
-				 buf,
-				 maxlen);
+				 &stats->bios_journal_completed, ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	result = write_bio_stats("biosPageCacheCompleted : ",
-				 &stats->bios_page_cache_completed,
-				 ", ",
-				 buf,
-				 maxlen);
+				 &stats->bios_page_cache_completed, ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
-	result = write_bio_stats("biosAcknowledged : ",
-				 &stats->bios_acknowledged,
-				 ", ",
-				 buf,
-				 maxlen);
+	result = write_bio_stats("biosAcknowledged : ", &stats->bios_acknowledged, ", ",
+				 buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	result = write_bio_stats("biosAcknowledgedPartial : ",
-				 &stats->bios_acknowledged_partial,
-				 ", ",
-				 buf,
-				 maxlen);
+				 &stats->bios_acknowledged_partial, ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* Current number of bios in progress */
-	result = write_bio_stats("biosInProgress : ",
-				 &stats->bios_in_progress,
-				 ", ",
-				 buf,
-				 maxlen);
+	result = write_bio_stats("biosInProgress : ", &stats->bios_in_progress, ", ",
+				 buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* Memory usage stats. */
-	result = write_memory_usage("memoryUsage : ",
-				    &stats->memory_usage,
-				    ", ",
-				    buf,
+	result = write_memory_usage("memoryUsage : ", &stats->memory_usage, ", ", buf,
 				    maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	/* The statistics for the UDS index */
-	result = write_index_statistics("index : ",
-					&stats->index,
-					", ",
-					buf,
-					maxlen);
+	result = write_index_statistics("index : ", &stats->index, ", ", buf, maxlen);
 	if (result != VDO_SUCCESS)
 		return result;
 	result = write_string(NULL, "}", suffix, buf, maxlen);
@@ -1197,9 +756,7 @@ static int write_vdo_statistics(char *prefix,
 	return VDO_SUCCESS;
 }
 
-int vdo_write_stats(struct vdo *vdo,
-		    char *buf,
-		    unsigned int maxlen)
+int vdo_write_stats(struct vdo *vdo, char *buf, unsigned int maxlen)
 {
 	struct vdo_statistics *stats;
 	int result;
-- 
2.42.0

