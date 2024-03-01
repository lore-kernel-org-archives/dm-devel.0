Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A061550261
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 04:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709267938; cv=none; b=fCinfc0BAYa5V//NwygxGWdy/DFqMhK7GgDcw7FRe+64GS0RyChfU7QJHRBTGFx7TxMZmyeN3im8RYfs6avlaFTZRzVV/tKH2YMBRy0cw31tfUiq/hBJ99pmh8nmF/PTZvDWYnSqxqr9B1KdIF5Wt5d7xbTYWn8Bc7jotylGizA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709267938; c=relaxed/simple;
	bh=ss7vCGO77nSIuiyuclbVXYwhiwGzGpFmSkJ1fhd899Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mqCSImGaQX4OLkOwjd9vwDurlVHEPrXaSIJq7CfOg5+r44P2JU3Pw2o7ap2Jg/o7VVFokqhgB9poTZr/y9oIfNvoGvWBdNzT2r0wCDpclcr+MxjtvRm32KyYtjEtlTtYH2hJEo+vbi45wRKcbmyFTVZIliFD/wqiyE8fYWrvIyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JYS5U4Bt; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JYS5U4Bt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709267935;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Je33jA3b8Qca5p6zd6AGM+0D7kMvflIJ+NRAjn+lvqI=;
	b=JYS5U4BtofrXzRDwqAtOX2EcQ87ykmszs1luvFJhv6Jkv9fKpTMZOLYOY4Sau6jwVYszSr
	hNENPnNMlEA9VdEcvwobOP00oxYufN823c13l7s8+GniLgeMz9Y+IoqCzaNfEuUw3civcs
	e5aa53dfhQJ/5SxJj8XqHb3UZNSP7ow=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-481-ZsYLPgVdPrOzwzg5rn1wng-1; Thu,
 29 Feb 2024 23:38:54 -0500
X-MC-Unique: ZsYLPgVdPrOzwzg5rn1wng-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B8A7E1C05AFB
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 04:38:53 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B3CE7492BE2;
	Fri,  1 Mar 2024 04:38:53 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id AD1FEA161A; Thu, 29 Feb 2024 23:38:53 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 01/10] dm vdo errors: remove unused error codes
Date: Thu, 29 Feb 2024 23:38:44 -0500
Message-ID: <71e1a606ed732a0ee77aecd3d73e75f63903cc7e.1709267597.git.msakai@redhat.com>
In-Reply-To: <cover.1709267597.git.msakai@redhat.com>
References: <cover.1709267597.git.msakai@redhat.com>
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

Also define VDO_SUCCESS in a more central location, and
rename error block constants for clarity.

Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/errors.c       |  4 ----
 drivers/md/dm-vdo/errors.h       | 13 +++----------
 drivers/md/dm-vdo/status-codes.c | 10 ----------
 drivers/md/dm-vdo/status-codes.h | 32 +++++---------------------------
 4 files changed, 8 insertions(+), 51 deletions(-)

diff --git a/drivers/md/dm-vdo/errors.c b/drivers/md/dm-vdo/errors.c
index dc1f0533bd7a..df2498553312 100644
--- a/drivers/md/dm-vdo/errors.c
+++ b/drivers/md/dm-vdo/errors.c
@@ -58,13 +58,9 @@ static const struct error_info error_list[] = {
 	{ "UDS_DUPLICATE_NAME", "Attempt to enter the same name into a delta index twice" },
 	{ "UDS_ASSERTION_FAILED", "Assertion failed" },
 	{ "UDS_QUEUED", "Request queued" },
-	{ "UDS_BUFFER_ERROR", "Buffer error" },
-	{ "UDS_NO_DIRECTORY", "Expected directory is missing" },
 	{ "UDS_ALREADY_REGISTERED", "Error range already registered" },
 	{ "UDS_OUT_OF_RANGE", "Cannot access data outside specified limits" },
-	{ "UDS_EMODULE_LOAD", "Could not load modules" },
 	{ "UDS_DISABLED", "UDS library context is disabled" },
-	{ "UDS_UNKNOWN_ERROR", "Unknown error" },
 	{ "UDS_UNSUPPORTED_VERSION", "Unsupported version" },
 	{ "UDS_CORRUPT_DATA", "Some index structure is corrupt" },
 	{ "UDS_NO_INDEX", "No index found" },
diff --git a/drivers/md/dm-vdo/errors.h b/drivers/md/dm-vdo/errors.h
index cf15d7243204..c6c085b26a0e 100644
--- a/drivers/md/dm-vdo/errors.h
+++ b/drivers/md/dm-vdo/errors.h
@@ -9,12 +9,13 @@
 #include <linux/compiler.h>
 #include <linux/types.h>
 
-/* Custom error codes and error-related utilities for UDS */
+/* Custom error codes and error-related utilities */
+#define VDO_SUCCESS 0
 
 /* Valid status codes for internal UDS functions. */
 enum uds_status_codes {
 	/* Successful return */
-	UDS_SUCCESS = 0,
+	UDS_SUCCESS = VDO_SUCCESS,
 	/* Used as a base value for reporting internal errors */
 	UDS_ERROR_CODE_BASE = 1024,
 	/* Index overflow */
@@ -29,20 +30,12 @@ enum uds_status_codes {
 	UDS_ASSERTION_FAILED,
 	/* A request has been queued for later processing (not an error) */
 	UDS_QUEUED,
-	/* A problem has occurred with a buffer */
-	UDS_BUFFER_ERROR,
-	/* No directory was found where one was expected */
-	UDS_NO_DIRECTORY,
 	/* This error range has already been registered */
 	UDS_ALREADY_REGISTERED,
 	/* Attempt to read or write data outside the valid range */
 	UDS_OUT_OF_RANGE,
-	/* Could not load modules */
-	UDS_EMODULE_LOAD,
 	/* The index session is disabled */
 	UDS_DISABLED,
-	/* Unknown error */
-	UDS_UNKNOWN_ERROR,
 	/* The index configuration or volume format is no longer supported */
 	UDS_UNSUPPORTED_VERSION,
 	/* Some index structure is corrupt */
diff --git a/drivers/md/dm-vdo/status-codes.c b/drivers/md/dm-vdo/status-codes.c
index efba1ead0aca..92c42b8bbb8b 100644
--- a/drivers/md/dm-vdo/status-codes.c
+++ b/drivers/md/dm-vdo/status-codes.c
@@ -15,22 +15,16 @@ const struct error_info vdo_status_list[] = {
 	{ "VDO_OUT_OF_RANGE", "Out of range" },
 	{ "VDO_REF_COUNT_INVALID", "Reference count would become invalid" },
 	{ "VDO_NO_SPACE", "Out of space" },
-	{ "VDO_UNEXPECTED_EOF", "Unexpected EOF on block read" },
 	{ "VDO_BAD_CONFIGURATION", "Bad configuration option" },
-	{ "VDO_SOCKET_ERROR", "Socket error" },
-	{ "VDO_BAD_ALIGNMENT", "Mis-aligned block reference" },
 	{ "VDO_COMPONENT_BUSY", "Prior operation still in progress" },
 	{ "VDO_BAD_PAGE", "Corrupt or incorrect page" },
 	{ "VDO_UNSUPPORTED_VERSION", "Unsupported component version" },
 	{ "VDO_INCORRECT_COMPONENT", "Component id mismatch in decoder" },
 	{ "VDO_PARAMETER_MISMATCH", "Parameters have conflicting values" },
-	{ "VDO_BLOCK_SIZE_TOO_SMALL", "The block size is too small" },
 	{ "VDO_UNKNOWN_PARTITION", "No partition exists with a given id" },
 	{ "VDO_PARTITION_EXISTS", "A partition already exists with a given id" },
-	{ "VDO_NOT_READ_ONLY", "The device is not in read-only mode" },
 	{ "VDO_INCREMENT_TOO_SMALL", "Physical block growth of too few blocks" },
 	{ "VDO_CHECKSUM_MISMATCH", "Incorrect checksum" },
-	{ "VDO_RECOVERY_JOURNAL_FULL", "The recovery journal is full" },
 	{ "VDO_LOCK_ERROR", "A lock is held incorrectly" },
 	{ "VDO_READ_ONLY", "The device is in read-only mode" },
 	{ "VDO_SHUTTING_DOWN", "The device is shutting down" },
@@ -38,11 +32,7 @@ const struct error_info vdo_status_list[] = {
 	{ "VDO_TOO_MANY_SLABS", "Exceeds maximum number of slabs supported" },
 	{ "VDO_INVALID_FRAGMENT", "Compressed block fragment is invalid" },
 	{ "VDO_RETRY_AFTER_REBUILD", "Retry operation after rebuilding finishes" },
-	{ "VDO_UNKNOWN_COMMAND", "The extended command is not known" },
-	{ "VDO_COMMAND_ERROR", "Bad extended command parameters" },
-	{ "VDO_CANNOT_DETERMINE_SIZE", "Cannot determine config sizes to fit" },
 	{ "VDO_BAD_MAPPING", "Invalid page mapping" },
-	{ "VDO_READ_CACHE_BUSY", "Read cache has no free slots" },
 	{ "VDO_BIO_CREATION_FAILED", "Bio creation failed" },
 	{ "VDO_BAD_MAGIC", "Bad magic number" },
 	{ "VDO_BAD_NONCE", "Bad nonce" },
diff --git a/drivers/md/dm-vdo/status-codes.h b/drivers/md/dm-vdo/status-codes.h
index 5d1e8bbe54b4..eb847def8eb4 100644
--- a/drivers/md/dm-vdo/status-codes.h
+++ b/drivers/md/dm-vdo/status-codes.h
@@ -9,17 +9,15 @@
 #include "errors.h"
 
 enum {
-	UDS_BLOCK_SIZE = UDS_ERROR_CODE_BLOCK_END - UDS_ERROR_CODE_BASE,
-	VDO_BLOCK_START = UDS_ERROR_CODE_BLOCK_END,
-	VDO_BLOCK_END = VDO_BLOCK_START + UDS_BLOCK_SIZE,
+	UDS_ERRORS_BLOCK_SIZE = UDS_ERROR_CODE_BLOCK_END - UDS_ERROR_CODE_BASE,
+	VDO_ERRORS_BLOCK_START = UDS_ERROR_CODE_BLOCK_END,
+	VDO_ERRORS_BLOCK_END = VDO_ERRORS_BLOCK_START + UDS_ERRORS_BLOCK_SIZE,
 };
 
 /* VDO-specific status codes. */
 enum vdo_status_codes {
-	/* successful result */
-	VDO_SUCCESS = UDS_SUCCESS,
 	/* base of all VDO errors */
-	VDO_STATUS_CODE_BASE = VDO_BLOCK_START,
+	VDO_STATUS_CODE_BASE = VDO_ERRORS_BLOCK_START,
 	/* we haven't written this yet */
 	VDO_NOT_IMPLEMENTED = VDO_STATUS_CODE_BASE,
 	/* input out of range */
@@ -28,14 +26,8 @@ enum vdo_status_codes {
 	VDO_REF_COUNT_INVALID,
 	/* a free block could not be allocated */
 	VDO_NO_SPACE,
-	/* unexpected EOF on block read */
-	VDO_UNEXPECTED_EOF,
 	/* improper or missing configuration option */
 	VDO_BAD_CONFIGURATION,
-	/* socket opening or binding problem */
-	VDO_SOCKET_ERROR,
-	/* read or write on non-aligned offset */
-	VDO_BAD_ALIGNMENT,
 	/* prior operation still in progress */
 	VDO_COMPONENT_BUSY,
 	/* page contents incorrect or corrupt data */
@@ -46,20 +38,14 @@ enum vdo_status_codes {
 	VDO_INCORRECT_COMPONENT,
 	/* parameters have conflicting values */
 	VDO_PARAMETER_MISMATCH,
-	/* the block size is too small */
-	VDO_BLOCK_SIZE_TOO_SMALL,
 	/* no partition exists with a given id */
 	VDO_UNKNOWN_PARTITION,
 	/* a partition already exists with a given id */
 	VDO_PARTITION_EXISTS,
-	/* the VDO is not in read-only mode */
-	VDO_NOT_READ_ONLY,
 	/* physical block growth of too few blocks */
 	VDO_INCREMENT_TOO_SMALL,
 	/* incorrect checksum */
 	VDO_CHECKSUM_MISMATCH,
-	/* the recovery journal is full */
-	VDO_RECOVERY_JOURNAL_FULL,
 	/* a lock is held incorrectly */
 	VDO_LOCK_ERROR,
 	/* the VDO is in read-only mode */
@@ -74,16 +60,8 @@ enum vdo_status_codes {
 	VDO_INVALID_FRAGMENT,
 	/* action is unsupported while rebuilding */
 	VDO_RETRY_AFTER_REBUILD,
-	/* the extended command is not known */
-	VDO_UNKNOWN_COMMAND,
-	/* bad extended command parameters */
-	VDO_COMMAND_ERROR,
-	/* cannot determine sizes to fit */
-	VDO_CANNOT_DETERMINE_SIZE,
 	/* a block map entry is invalid */
 	VDO_BAD_MAPPING,
-	/* read cache has no free slots */
-	VDO_READ_CACHE_BUSY,
 	/* bio_add_page failed */
 	VDO_BIO_CREATION_FAILED,
 	/* bad magic number */
@@ -98,7 +76,7 @@ enum vdo_status_codes {
 	VDO_CANT_ADD_SYSFS_NODE,
 	/* one more than last error code */
 	VDO_STATUS_CODE_LAST,
-	VDO_STATUS_CODE_BLOCK_END = VDO_BLOCK_END
+	VDO_STATUS_CODE_BLOCK_END = VDO_ERRORS_BLOCK_END
 };
 
 extern const struct error_info vdo_status_list[];
-- 
2.42.0

