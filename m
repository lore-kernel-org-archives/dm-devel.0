Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0DC755E48
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 20:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709326045; cv=none; b=f89R3lCPydEp1B/jdUozgm5yK9tk9LcFmqtMmFkWk41eNxBPcA64XttqdgfvN41u9gJ+WeC9UBBVRXViBk3w0CKdqxORiGmn/HkvDaqTMVe3v2eFslwZd1MoVZTHnZtPgU+vErHvgnPzIrLXfMW///Axbe07AMymykasgDnqTgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709326045; c=relaxed/simple;
	bh=uAWWm5QObn/2gFEzTzn6vEeq1jJ+OHUJqAle1nUqAoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J2ub+oqXOLc1aHxOgJDaBIOSU7mP4fURnP8qAcvp6RCW13vJ6dMlzN+9mVQeLyxRi3Dje/rwjjFjUMXyPRbWqXoAccUS8ZjOQDYBuad38W/xyg4a8NPFzaDIo+BL72z3xUgBitmmbc7y6/z0VTn9xZzpDkYFxaEzsjaLITcP5ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FMQGYLVQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FMQGYLVQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709326041;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/KlUStSjU5b3pGPpsEsQ7nmEkF37mJTo4y+OBbz99M8=;
	b=FMQGYLVQ0KaNK0GAfzHCAGOnTrZp6OezN36dabj9krvlNCmLJgEGAq2ZBC1IdQ0NUtvCm4
	JQv4XGf4vD2BdQrtSzIsuBjkzCGeRms6cQyXIGal54drjlzmt4CdqMJ3ughpEby5YJHujC
	Xs+6ddOvheVwsDvJPRSs/7DA9jqqXsw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-287-mBLfKtmgN0uz__zqYx4GIw-1; Fri, 01 Mar 2024 15:47:20 -0500
X-MC-Unique: mBLfKtmgN0uz__zqYx4GIw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 18DB185A59A;
	Fri,  1 Mar 2024 20:47:20 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 131292166B31;
	Fri,  1 Mar 2024 20:47:20 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 0DDBDA1B84; Fri,  1 Mar 2024 15:47:20 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 4/4] dm vdo logger: remove log level to string conversion code
Date: Fri,  1 Mar 2024 15:47:19 -0500
Message-ID: <1b15059930ac76c40eee88de5a7a610a4e6d2fa5.1709325896.git.msakai@redhat.com>
In-Reply-To: <cover.1709325895.git.msakai@redhat.com>
References: <cover.1709325895.git.msakai@redhat.com>
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

Was only used by sysfs code, can be reinstated if/when needed.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Ken Raeburn <raeburn@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/logger.c | 53 --------------------------------------
 drivers/md/dm-vdo/logger.h |  4 ---
 2 files changed, 57 deletions(-)

diff --git a/drivers/md/dm-vdo/logger.c b/drivers/md/dm-vdo/logger.c
index 5d27cd6483a9..80f1e4c62ac6 100644
--- a/drivers/md/dm-vdo/logger.c
+++ b/drivers/md/dm-vdo/logger.c
@@ -16,39 +16,6 @@
 #include "thread-device.h"
 #include "thread-utils.h"
 
-struct priority_name {
-	const char *name;
-	const int priority;
-};
-
-static const struct priority_name PRIORITIES[] = {
-	{ "ALERT", UDS_LOG_ALERT },
-	{ "CRITICAL", UDS_LOG_CRIT },
-	{ "CRIT", UDS_LOG_CRIT },
-	{ "DEBUG", UDS_LOG_DEBUG },
-	{ "EMERGENCY", UDS_LOG_EMERG },
-	{ "EMERG", UDS_LOG_EMERG },
-	{ "ERROR", UDS_LOG_ERR },
-	{ "ERR", UDS_LOG_ERR },
-	{ "INFO", UDS_LOG_INFO },
-	{ "NOTICE", UDS_LOG_NOTICE },
-	{ "PANIC", UDS_LOG_EMERG },
-	{ "WARN", UDS_LOG_WARNING },
-	{ "WARNING", UDS_LOG_WARNING },
-	{ NULL, -1 },
-};
-
-static const char *const PRIORITY_STRINGS[] = {
-	"EMERGENCY",
-	"ALERT",
-	"CRITICAL",
-	"ERROR",
-	"WARN",
-	"NOTICE",
-	"INFO",
-	"DEBUG",
-};
-
 int vdo_log_level = UDS_LOG_DEFAULT;
 
 int uds_get_log_level(void)
@@ -62,26 +29,6 @@ int uds_get_log_level(void)
 	return log_level_latch;
 }
 
-int uds_log_string_to_priority(const char *string)
-{
-	int i;
-
-	for (i = 0; PRIORITIES[i].name != NULL; i++) {
-		if (strcasecmp(string, PRIORITIES[i].name) == 0)
-			return PRIORITIES[i].priority;
-	}
-
-	return UDS_LOG_INFO;
-}
-
-const char *uds_log_priority_to_string(int priority)
-{
-	if ((priority < 0) || (priority >= (int) ARRAY_SIZE(PRIORITY_STRINGS)))
-		return "unknown";
-
-	return PRIORITY_STRINGS[priority];
-}
-
 static const char *get_current_interrupt_type(void)
 {
 	if (in_nmi())
diff --git a/drivers/md/dm-vdo/logger.h b/drivers/md/dm-vdo/logger.h
index 095532afc9a3..a8cdf46b6fc1 100644
--- a/drivers/md/dm-vdo/logger.h
+++ b/drivers/md/dm-vdo/logger.h
@@ -45,10 +45,6 @@ extern int vdo_log_level;
 
 int uds_get_log_level(void);
 
-int uds_log_string_to_priority(const char *string);
-
-const char *uds_log_priority_to_string(int priority);
-
 void uds_log_embedded_message(int priority, const char *module, const char *prefix,
 			      const char *fmt1, va_list args1, const char *fmt2, ...)
 	__printf(4, 0) __printf(6, 7);
-- 
2.42.0

