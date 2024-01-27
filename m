Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2A1A8BE7
	for <dm-devel@lists.linux.dev>; Sat, 27 Jan 2024 02:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706323355; cv=none; b=HMKIrHO/Il8HWOaSYXaQuXJ2fg8NQ6Zso5JuUyO+n8KlYGZ3/KG+9QkG39xHjSa5QrNmpLhS8b+glKypTHmrnYI9ZvZV2eR6wfGHOZxNOwwaMrtCKDU9n2y9TP5sMw3toxY9dT4A8SO5Y3Ft7aXpSqV530Sbb+dQG5Y2e/FNZgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706323355; c=relaxed/simple;
	bh=dtrfhtOn1jNKTvkUCcozUFggqs9bFqFd0GJRN6mWgXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HsxgA2YDBcdTls5Ngf6LEui+Pgh9rE3FOZ4UJ1o+BgYTbzTO/WKiNgqwNPNYidQ2AUHAaeAU8hNkqoC7HUSSeaJ1XxxtSW4TJ+PUrIWNhRon8EzOt5DQNAejgyBpu4Yr6fJbeQ5yGOrD8ceR7IlfEZpW8ebL/ClXgR4BAtMJa18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LSG7+V2C; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LSG7+V2C"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706323352;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OSKnttY/0A8IHdZo0nC0ZBoR6jBKbRYsjKe4w3jQsws=;
	b=LSG7+V2CaxQjTimSG5IC0nhcWs01QKkk/NJQydhCzSZzqowxq6JTkFo+rc6fUrOrQtciF8
	NMq46Qcvn+daYAOtUQUFGF8sxmqyZDgDdM1UgP2th5wIXNlWi5e8iYNiArqwXt/NfnMaVg
	wZZ/lq5P28mgvE5qHT6ASVaqChO1/SA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-517-NV8bqavBOrKjCrbrG81NHA-1; Fri, 26 Jan 2024 21:42:29 -0500
X-MC-Unique: NV8bqavBOrKjCrbrG81NHA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9A620101376E;
	Sat, 27 Jan 2024 02:42:29 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9493D5012;
	Sat, 27 Jan 2024 02:42:29 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 8BD76560D2; Fri, 26 Jan 2024 21:42:29 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 1/3] dm vdo: slight cleanup of UDS error codes
Date: Fri, 26 Jan 2024 21:42:27 -0500
Message-ID: <ef09aa6e52a1b1db5eb78f1a78ce389cbeb6b5b0.1706323002.git.msakai@redhat.com>
In-Reply-To: <cover.1706323002.git.msakai@redhat.com>
References: <cover.1706323002.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Mike Snitzer <snitzer@kernel.org>

No need to increment each UDS_ error code manually (relative to
UDS_ERROR_CODE_BASE).

Also, remove unused PRP_BLOCK_START and PRP_BLOCK_END.

Lastly, UDS_SUCCESS and VDO_SUCCESS are used interchangeably; so best
to explicitly set VDO_SUCCESS equal to UDS_SUCCESS.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Susan LeGendre-McGhee <slegendr@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/errors.h       | 35 ++++++++++++++++----------------
 drivers/md/dm-vdo/status-codes.h |  4 +---
 2 files changed, 18 insertions(+), 21 deletions(-)

diff --git a/drivers/md/dm-vdo/errors.h b/drivers/md/dm-vdo/errors.h
index 0129fa37d8d8..c37f198a159c 100644
--- a/drivers/md/dm-vdo/errors.h
+++ b/drivers/md/dm-vdo/errors.h
@@ -15,43 +15,42 @@
 enum uds_status_codes {
 	/* Successful return */
 	UDS_SUCCESS = 0,
-
 	/* Used as a base value for reporting internal errors */
 	UDS_ERROR_CODE_BASE = 1024,
 	/* Index overflow */
-	UDS_OVERFLOW = UDS_ERROR_CODE_BASE + 0,
+	UDS_OVERFLOW = UDS_ERROR_CODE_BASE,
 	/* Invalid argument passed to internal routine */
-	UDS_INVALID_ARGUMENT = UDS_ERROR_CODE_BASE + 1,
+	UDS_INVALID_ARGUMENT,
 	/* UDS data structures are in an invalid state */
-	UDS_BAD_STATE = UDS_ERROR_CODE_BASE + 2,
+	UDS_BAD_STATE,
 	/* Attempt to enter the same name into an internal structure twice */
-	UDS_DUPLICATE_NAME = UDS_ERROR_CODE_BASE + 3,
+	UDS_DUPLICATE_NAME,
 	/* An assertion failed */
-	UDS_ASSERTION_FAILED = UDS_ERROR_CODE_BASE + 4,
+	UDS_ASSERTION_FAILED,
 	/* A request has been queued for later processing (not an error) */
-	UDS_QUEUED = UDS_ERROR_CODE_BASE + 5,
+	UDS_QUEUED,
 	/* A problem has occurred with a buffer */
-	UDS_BUFFER_ERROR = UDS_ERROR_CODE_BASE + 6,
+	UDS_BUFFER_ERROR,
 	/* No directory was found where one was expected */
-	UDS_NO_DIRECTORY = UDS_ERROR_CODE_BASE + 7,
+	UDS_NO_DIRECTORY,
 	/* This error range has already been registered */
-	UDS_ALREADY_REGISTERED = UDS_ERROR_CODE_BASE + 8,
+	UDS_ALREADY_REGISTERED,
 	/* Attempt to read or write data outside the valid range */
-	UDS_OUT_OF_RANGE = UDS_ERROR_CODE_BASE + 9,
+	UDS_OUT_OF_RANGE,
 	/* Could not load modules */
-	UDS_EMODULE_LOAD = UDS_ERROR_CODE_BASE + 10,
+	UDS_EMODULE_LOAD,
 	/* The index session is disabled */
-	UDS_DISABLED = UDS_ERROR_CODE_BASE + 11,
+	UDS_DISABLED,
 	/* Unknown error */
-	UDS_UNKNOWN_ERROR = UDS_ERROR_CODE_BASE + 12,
+	UDS_UNKNOWN_ERROR,
 	/* The index configuration or volume format is no longer supported */
-	UDS_UNSUPPORTED_VERSION = UDS_ERROR_CODE_BASE + 13,
+	UDS_UNSUPPORTED_VERSION,
 	/* Some index structure is corrupt */
-	UDS_CORRUPT_DATA = UDS_ERROR_CODE_BASE + 14,
+	UDS_CORRUPT_DATA,
 	/* No index state found */
-	UDS_NO_INDEX = UDS_ERROR_CODE_BASE + 15,
+	UDS_NO_INDEX,
 	/* Attempt to access incomplete index save data */
-	UDS_INDEX_NOT_SAVED_CLEANLY = UDS_ERROR_CODE_BASE + 16,
+	UDS_INDEX_NOT_SAVED_CLEANLY,
 	/* One more than the last UDS_INTERNAL error code */
 	UDS_ERROR_CODE_LAST,
 	/* One more than the last error this block will ever use */
diff --git a/drivers/md/dm-vdo/status-codes.h b/drivers/md/dm-vdo/status-codes.h
index c5da37ec8b55..9e0126a83c6b 100644
--- a/drivers/md/dm-vdo/status-codes.h
+++ b/drivers/md/dm-vdo/status-codes.h
@@ -12,14 +12,12 @@ enum {
 	UDS_BLOCK_SIZE = UDS_ERROR_CODE_BLOCK_END - UDS_ERROR_CODE_BASE,
 	VDO_BLOCK_START = UDS_ERROR_CODE_BLOCK_END,
 	VDO_BLOCK_END = VDO_BLOCK_START + UDS_BLOCK_SIZE,
-	PRP_BLOCK_START = VDO_BLOCK_END,
-	PRP_BLOCK_END = PRP_BLOCK_START + UDS_BLOCK_SIZE,
 };
 
 /* VDO-specific status codes. */
 enum vdo_status_codes {
 	/* successful result */
-	VDO_SUCCESS,
+	VDO_SUCCESS = UDS_SUCCESS,
 	/* base of all VDO errors */
 	VDO_STATUS_CODE_BASE = VDO_BLOCK_START,
 	/* we haven't written this yet */
-- 
2.42.0

