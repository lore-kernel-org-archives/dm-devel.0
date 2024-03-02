Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B267489
	for <dm-devel@lists.linux.dev>; Sat,  2 Mar 2024 02:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709348340; cv=none; b=OJTYB6sLpCYVMHDgXdEtAXERyeFo5hSAPDDCb7H8cvHYoibwK4snaCP3ZZAAQwaj2g7vm7DRrUGQdy49wqLxlwxD23mrxRWsn8q4jAEOLI1WDc2LHVCji5jOOSMuAgcqy5bRrF1o+16+FHNI9M+UW250W7xwQUBuTG29WEMf9mI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709348340; c=relaxed/simple;
	bh=w0M9MxwQ0omuNV24FA+DXuAbIs+SsLBUQuyNUu7D+5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=acDZ6oZDizowHBm3BPtao1ZdEn/ByzDyYOm9GGgK2jBsKB2FqDtRq1UDKj4FXPgpo0WDIYI1ej04xadj8Wfd4EYcAwZd30XzRFvxxiQk5raGh2xo8isN+LNB3Dndr4wMqkj236f+jCvFVP2Wq9T3Z95YyWZQpHE69ABtIIxlt7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y7zwXS5Y; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y7zwXS5Y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709348337;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FZi/A8A040dY1K16MWf2TNyupvEplqrJOd+QK8pGeVQ=;
	b=Y7zwXS5YOzGhjX0nL8NX9PMnjCSZBUKtea8vjHOHWvSIUDH6xaW8O/S6uEEOHkgudIrZu/
	p3KvQZZvSm+vRVwPFzEMg9BnQamg1FXEOxjgSKBFwT9KCeVbm51YOtlxJibsTesQloR9Q8
	bfR6RaULNyTfXN/D7ksvMqkao1+4YY0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-641-wy0adJrxMIuE0YCBWeyiQQ-1; Fri, 01 Mar 2024 21:58:55 -0500
X-MC-Unique: wy0adJrxMIuE0YCBWeyiQQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7D5EF85A588;
	Sat,  2 Mar 2024 02:58:55 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 785D3492BE8;
	Sat,  2 Mar 2024 02:58:55 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 739DDA1C0B; Fri,  1 Mar 2024 21:58:55 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 3/3] dm vdo string-utils: change from uds_ to vdo_ namespace
Date: Fri,  1 Mar 2024 21:58:55 -0500
Message-ID: <df0467ed815fa000734097ee9cf3842251766646.1709348197.git.msakai@redhat.com>
In-Reply-To: <cover.1709348197.git.msakai@redhat.com>
References: <cover.1709348197.git.msakai@redhat.com>
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

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Chung Chung <cchung@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/dm-vdo-target.c |  2 +-
 drivers/md/dm-vdo/errors.c        | 16 ++++++++--------
 drivers/md/dm-vdo/logical-zone.c  |  2 +-
 drivers/md/dm-vdo/slab-depot.c    |  6 +++---
 drivers/md/dm-vdo/string-utils.c  |  2 +-
 drivers/md/dm-vdo/string-utils.h  | 10 +++++-----
 6 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/md/dm-vdo/dm-vdo-target.c b/drivers/md/dm-vdo/dm-vdo-target.c
index 4908996f5224..b7b3eec39522 100644
--- a/drivers/md/dm-vdo/dm-vdo-target.c
+++ b/drivers/md/dm-vdo/dm-vdo-target.c
@@ -340,7 +340,7 @@ static int join_strings(char **substring_array, size_t array_length, char separa
 	current_position = &output[0];
 
 	for (i = 0; (i < array_length) && (substring_array[i] != NULL); i++) {
-		current_position = uds_append_to_buffer(current_position,
+		current_position = vdo_append_to_buffer(current_position,
 							output + string_length, "%s",
 							substring_array[i]);
 		*current_position = separator;
diff --git a/drivers/md/dm-vdo/errors.c b/drivers/md/dm-vdo/errors.c
index 8b2d22381274..6f89eb1c63a3 100644
--- a/drivers/md/dm-vdo/errors.c
+++ b/drivers/md/dm-vdo/errors.c
@@ -154,19 +154,19 @@ const char *uds_string_error(int errnum, char *buf, size_t buflen)
 	block_name = get_error_info(errnum, &info);
 	if (block_name != NULL) {
 		if (info != NULL) {
-			buffer = uds_append_to_buffer(buffer, buf_end, "%s: %s",
+			buffer = vdo_append_to_buffer(buffer, buf_end, "%s: %s",
 						      block_name, info->message);
 		} else {
-			buffer = uds_append_to_buffer(buffer, buf_end, "Unknown %s %d",
+			buffer = vdo_append_to_buffer(buffer, buf_end, "Unknown %s %d",
 						      block_name, errnum);
 		}
 	} else if (info != NULL) {
-		buffer = uds_append_to_buffer(buffer, buf_end, "%s", info->message);
+		buffer = vdo_append_to_buffer(buffer, buf_end, "%s", info->message);
 	} else {
 		const char *tmp = system_string_error(errnum, buffer, buf_end - buffer);
 
 		if (tmp != buffer)
-			buffer = uds_append_to_buffer(buffer, buf_end, "%s", tmp);
+			buffer = vdo_append_to_buffer(buffer, buf_end, "%s", tmp);
 		else
 			buffer += strlen(tmp);
 	}
@@ -188,19 +188,19 @@ const char *uds_string_error_name(int errnum, char *buf, size_t buflen)
 	block_name = get_error_info(errnum, &info);
 	if (block_name != NULL) {
 		if (info != NULL) {
-			buffer = uds_append_to_buffer(buffer, buf_end, "%s", info->name);
+			buffer = vdo_append_to_buffer(buffer, buf_end, "%s", info->name);
 		} else {
-			buffer = uds_append_to_buffer(buffer, buf_end, "%s %d",
+			buffer = vdo_append_to_buffer(buffer, buf_end, "%s %d",
 						      block_name, errnum);
 		}
 	} else if (info != NULL) {
-		buffer = uds_append_to_buffer(buffer, buf_end, "%s", info->name);
+		buffer = vdo_append_to_buffer(buffer, buf_end, "%s", info->name);
 	} else {
 		const char *tmp;
 
 		tmp = system_string_error(errnum, buffer, buf_end - buffer);
 		if (tmp != buffer)
-			buffer = uds_append_to_buffer(buffer, buf_end, "%s", tmp);
+			buffer = vdo_append_to_buffer(buffer, buf_end, "%s", tmp);
 		else
 			buffer += strlen(tmp);
 	}
diff --git a/drivers/md/dm-vdo/logical-zone.c b/drivers/md/dm-vdo/logical-zone.c
index 258bc55e419b..026f031ffc9e 100644
--- a/drivers/md/dm-vdo/logical-zone.c
+++ b/drivers/md/dm-vdo/logical-zone.c
@@ -368,6 +368,6 @@ void vdo_dump_logical_zone(const struct logical_zone *zone)
 		     (unsigned long long) READ_ONCE(zone->flush_generation),
 		     (unsigned long long) READ_ONCE(zone->oldest_active_generation),
 		     (unsigned long long) READ_ONCE(zone->notification_generation),
-		     uds_bool_to_string(READ_ONCE(zone->notifying)),
+		     vdo_bool_to_string(READ_ONCE(zone->notifying)),
 		     (unsigned long long) READ_ONCE(zone->ios_in_flush_generation));
 }
diff --git a/drivers/md/dm-vdo/slab-depot.c b/drivers/md/dm-vdo/slab-depot.c
index dc9f3d3c3995..46e4721e5b4f 100644
--- a/drivers/md/dm-vdo/slab-depot.c
+++ b/drivers/md/dm-vdo/slab-depot.c
@@ -3597,8 +3597,8 @@ void vdo_dump_block_allocator(const struct block_allocator *allocator)
 
 		vdo_log_info("  slab journal: entry_waiters=%zu waiting_to_commit=%s updating_slab_summary=%s head=%llu unreapable=%llu tail=%llu next_commit=%llu summarized=%llu last_summarized=%llu recovery_lock=%llu dirty=%s",
 			     vdo_waitq_num_waiters(&journal->entry_waiters),
-			     uds_bool_to_string(journal->waiting_to_commit),
-			     uds_bool_to_string(journal->updating_slab_summary),
+			     vdo_bool_to_string(journal->waiting_to_commit),
+			     vdo_bool_to_string(journal->updating_slab_summary),
 			     (unsigned long long) journal->head,
 			     (unsigned long long) journal->unreapable,
 			     (unsigned long long) journal->tail,
@@ -3606,7 +3606,7 @@ void vdo_dump_block_allocator(const struct block_allocator *allocator)
 			     (unsigned long long) journal->summarized,
 			     (unsigned long long) journal->last_summarized,
 			     (unsigned long long) journal->recovery_lock,
-			     uds_bool_to_string(journal->recovery_lock != 0));
+			     vdo_bool_to_string(journal->recovery_lock != 0));
 		/*
 		 * Given the frequency with which the locks are just a tiny bit off, it might be
 		 * worth dumping all the locks, but that might be too much logging.
diff --git a/drivers/md/dm-vdo/string-utils.c b/drivers/md/dm-vdo/string-utils.c
index 6cdf018cdaf0..71e44b4683ea 100644
--- a/drivers/md/dm-vdo/string-utils.c
+++ b/drivers/md/dm-vdo/string-utils.c
@@ -5,7 +5,7 @@
 
 #include "string-utils.h"
 
-char *uds_append_to_buffer(char *buffer, char *buf_end, const char *fmt, ...)
+char *vdo_append_to_buffer(char *buffer, char *buf_end, const char *fmt, ...)
 {
 	va_list args;
 	size_t n;
diff --git a/drivers/md/dm-vdo/string-utils.h b/drivers/md/dm-vdo/string-utils.h
index 8275af582cf7..96eecd38b1c2 100644
--- a/drivers/md/dm-vdo/string-utils.h
+++ b/drivers/md/dm-vdo/string-utils.h
@@ -3,21 +3,21 @@
  * Copyright 2023 Red Hat
  */
 
-#ifndef UDS_STRING_UTILS_H
-#define UDS_STRING_UTILS_H
+#ifndef VDO_STRING_UTILS_H
+#define VDO_STRING_UTILS_H
 
 #include <linux/kernel.h>
 #include <linux/string.h>
 
 /* Utilities related to string manipulation */
 
-static inline const char *uds_bool_to_string(bool value)
+static inline const char *vdo_bool_to_string(bool value)
 {
 	return value ? "true" : "false";
 }
 
 /* Append a formatted string to the end of a buffer. */
-char *uds_append_to_buffer(char *buffer, char *buf_end, const char *fmt, ...)
+char *vdo_append_to_buffer(char *buffer, char *buf_end, const char *fmt, ...)
 	__printf(3, 4);
 
-#endif /* UDS_STRING_UTILS_H */
+#endif /* VDO_STRING_UTILS_H */
-- 
2.42.0

