Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1A9CEEB3
	for <dm-devel@lists.linux.dev>; Sat, 10 Aug 2024 02:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723258069; cv=none; b=YHpYcfRPRVLpjgqQzn3somqcTESOYK2qJGevNJa/MZRBC/0ZBDXRo+OM1o+9w9KVWnU4P/JAoao6Rk7lPmlzyE3PvZLJ2NpbwPbgrYfQfNRp6oQLRI7ah0QILbjtqgH5dPPtB5cjkGYTWvipW4CVCI3CDrGKKNqcq5PJsrD2n40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723258069; c=relaxed/simple;
	bh=xg+vPdAJGg4nDNkcxzvcoKdQuwPXKjzuddgwvgIC61c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=scpFKHdIDduzeh/SCPZm0MiVK0h4alThfPt0nu5AxyoLCeZI5GtfY7MvfW3uj/1QlCVfHP0wiqHKIEjRwmCQmibsaxYI15wmni7AzK8gRQ3V/Z8pgNijYJ+VHmawrdqSBqrev6JhCCOUPnnWLSyrbflMw49CK9J3ap7Sq8mkC18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TD+I5iZA; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TD+I5iZA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723258067;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vIZqm+52/Zh5iWB6aqbR8bE+rASvZ0uAB88fHbQWA1U=;
	b=TD+I5iZABsY0yY9tF/vL9h31rH8U79QgD7ivGHiadBUcOJ8hI1AvzF/qgMb7fxkiw3BkHu
	w8HV9065NW5ITbpRwhtdsc8TIzaO+220y3GkXXoNzIuZqlWfxpq3eomVzPrR737p/yFPCu
	Ovx/ceVHcGd8fZEqWGFxgd0rZfxTtGE=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-245-yr-Tj1x_Pv-OQOIxm7LjTg-1; Fri,
 09 Aug 2024 22:47:45 -0400
X-MC-Unique: yr-Tj1x_Pv-OQOIxm7LjTg-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8915E1944D30
	for <dm-devel@lists.linux.dev>; Sat, 10 Aug 2024 02:47:44 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E62F819560AA;
	Sat, 10 Aug 2024 02:47:43 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 4D24154762; Fri,  9 Aug 2024 22:47:43 -0400 (EDT)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Susan LeGendre-McGhee <slegendr@redhat.com>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 2/2] dm vdo: force read-only mode for a corrupt recovery journal
Date: Fri,  9 Aug 2024 22:47:43 -0400
Message-ID: <5ed988956f881b9746790be3140b9fea6af9aac6.1723249375.git.msakai@redhat.com>
In-Reply-To: <cover.1723249375.git.msakai@redhat.com>
References: <cover.1723249375.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Susan LeGendre-McGhee <slegendr@redhat.com>

Ensure the recovery journal does not attempt recovery when blocks
with mismatched metadata versions are detected. This check is
performed after determining that the blocks are otherwise valid
so that it does not interfere with normal recovery.

Signed-off-by: Susan LeGendre-McGhee <slegendr@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/repair.c       | 39 ++++++++++++++++++--------------
 drivers/md/dm-vdo/status-codes.c |  2 +-
 drivers/md/dm-vdo/status-codes.h |  2 +-
 3 files changed, 24 insertions(+), 19 deletions(-)

diff --git a/drivers/md/dm-vdo/repair.c b/drivers/md/dm-vdo/repair.c
index 28475eee0058..c8a8a75b45b9 100644
--- a/drivers/md/dm-vdo/repair.c
+++ b/drivers/md/dm-vdo/repair.c
@@ -1201,17 +1201,14 @@ static bool __must_check is_valid_recovery_journal_block(const struct recovery_j
  * @journal: The journal to use.
  * @header: The unpacked block header to check.
  * @sequence: The expected sequence number.
- * @type: The expected metadata type.
  *
  * Return: True if the block matches.
  */
 static bool __must_check is_exact_recovery_journal_block(const struct recovery_journal *journal,
 							 const struct recovery_block_header *header,
-							 sequence_number_t sequence,
-							 enum vdo_metadata_type type)
+							 sequence_number_t sequence)
 {
-	return ((header->metadata_type == type) &&
-		(header->sequence_number == sequence) &&
+	return ((header->sequence_number == sequence) &&
 		(is_valid_recovery_journal_block(journal, header, true)));
 }
 
@@ -1370,7 +1367,8 @@ static void extract_entries_from_block(struct repair_completion *repair,
 		get_recovery_journal_block_header(journal, repair->journal_data,
 						  sequence);
 
-	if (!is_exact_recovery_journal_block(journal, &header, sequence, format)) {
+	if (!is_exact_recovery_journal_block(journal, &header, sequence) ||
+	    (header.metadata_type != format)) {
 		/* This block is invalid, so skip it. */
 		return;
 	}
@@ -1556,10 +1554,13 @@ static int parse_journal_for_recovery(struct repair_completion *repair)
 	sequence_number_t i, head;
 	bool found_entries = false;
 	struct recovery_journal *journal = repair->completion.vdo->recovery_journal;
+	struct recovery_block_header header;
+	enum vdo_metadata_type expected_format;
 
 	head = min(repair->block_map_head, repair->slab_journal_head);
+	header = get_recovery_journal_block_header(journal, repair->journal_data, head);
+	expected_format = header.metadata_type;
 	for (i = head; i <= repair->highest_tail; i++) {
-		struct recovery_block_header header;
 		journal_entry_count_t block_entries;
 		u8 j;
 
@@ -1571,17 +1572,15 @@ static int parse_journal_for_recovery(struct repair_completion *repair)
 		};
 
 		header = get_recovery_journal_block_header(journal, repair->journal_data, i);
-		if (header.metadata_type == VDO_METADATA_RECOVERY_JOURNAL) {
-			/* This is an old format block, so we need to upgrade */
-			vdo_log_error_strerror(VDO_UNSUPPORTED_VERSION,
-					       "Recovery journal is in the old format. Downgrade and complete recovery, then upgrade with a clean volume");
-			return VDO_UNSUPPORTED_VERSION;
-		}
-
-		if (!is_exact_recovery_journal_block(journal, &header, i,
-						     VDO_METADATA_RECOVERY_JOURNAL_2)) {
+		if (!is_exact_recovery_journal_block(journal, &header, i)) {
 			/* A bad block header was found so this must be the end of the journal. */
 			break;
+		} else if (header.metadata_type != expected_format) {
+			/* There is a mix of old and new format blocks, so we need to rebuild. */
+			vdo_log_error_strerror(VDO_CORRUPT_JOURNAL,
+					       "Recovery journal is in an invalid format, a read-only rebuild is required.");
+			vdo_enter_read_only_mode(repair->completion.vdo, VDO_CORRUPT_JOURNAL);
+			return VDO_CORRUPT_JOURNAL;
 		}
 
 		block_entries = header.entry_count;
@@ -1617,8 +1616,14 @@ static int parse_journal_for_recovery(struct repair_completion *repair)
 			break;
 	}
 
-	if (!found_entries)
+	if (!found_entries) {
 		return validate_heads(repair);
+	} else if (expected_format == VDO_METADATA_RECOVERY_JOURNAL) {
+		/* All journal blocks have the old format, so we need to upgrade. */
+		vdo_log_error_strerror(VDO_UNSUPPORTED_VERSION,
+				       "Recovery journal is in the old format. Downgrade and complete recovery, then upgrade with a clean volume");
+		return VDO_UNSUPPORTED_VERSION;
+	}
 
 	/* Set the tail to the last valid tail block, if there is one. */
 	if (repair->tail_recovery_point.sector_count == 0)
diff --git a/drivers/md/dm-vdo/status-codes.c b/drivers/md/dm-vdo/status-codes.c
index d3493450b169..dd252d660b6d 100644
--- a/drivers/md/dm-vdo/status-codes.c
+++ b/drivers/md/dm-vdo/status-codes.c
@@ -28,7 +28,7 @@ const struct error_info vdo_status_list[] = {
 	{ "VDO_LOCK_ERROR", "A lock is held incorrectly" },
 	{ "VDO_READ_ONLY", "The device is in read-only mode" },
 	{ "VDO_SHUTTING_DOWN", "The device is shutting down" },
-	{ "VDO_CORRUPT_JOURNAL", "Recovery journal entries corrupted" },
+	{ "VDO_CORRUPT_JOURNAL", "Recovery journal corrupted" },
 	{ "VDO_TOO_MANY_SLABS", "Exceeds maximum number of slabs supported" },
 	{ "VDO_INVALID_FRAGMENT", "Compressed block fragment is invalid" },
 	{ "VDO_RETRY_AFTER_REBUILD", "Retry operation after rebuilding finishes" },
diff --git a/drivers/md/dm-vdo/status-codes.h b/drivers/md/dm-vdo/status-codes.h
index 72da04159f88..426dc8e2ca5d 100644
--- a/drivers/md/dm-vdo/status-codes.h
+++ b/drivers/md/dm-vdo/status-codes.h
@@ -52,7 +52,7 @@ enum vdo_status_codes {
 	VDO_READ_ONLY,
 	/* the VDO is shutting down */
 	VDO_SHUTTING_DOWN,
-	/* the recovery journal has corrupt entries */
+	/* the recovery journal has corrupt entries or corrupt metadata */
 	VDO_CORRUPT_JOURNAL,
 	/* exceeds maximum number of slabs supported */
 	VDO_TOO_MANY_SLABS,
-- 
2.45.2

