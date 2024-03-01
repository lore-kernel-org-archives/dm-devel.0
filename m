Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C4E55E46
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 20:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709326044; cv=none; b=PebhaiQWngVwPciKlmEMxQt6UXimUOIgbVBMH4gjbNrsKpQVEp1dZRLAL5VnhMPNxuLDrVmrQkEVc/dIglrCLakRyDNl9s2ul+N+oZWJWZL6BG4RuGNPYShET3WzzC0hHpXSs7kYGd8X25u0/GgV8aGw1I5jjCdFtQPm2KICAy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709326044; c=relaxed/simple;
	bh=1RY0/iF+FikMd//zMCbOW2mW0L7KyHk4wTWgVNN2t+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tmbzG3D7XwUyMHxDqD1LbYnZJBlCQHmVQ/MhCt67NJ08biwvtqqzaEhCFLRnpX4wIIWk5ixZqtcmn64Sb/MZ0NgGt2ZxSWV84TR5ptWLQWNKu2TwgO5cIh6zoaF8HZ3dDkmRd/NL7e5b8g6t52Vk8xSO2wuQ4qvm0sMDwAVVw3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AqoCZ1H/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AqoCZ1H/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709326041;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nAmxlDBF76j5bqbeJEjSn5enNUV//L+TzS1hUSxGuLk=;
	b=AqoCZ1H/Tq9sF4Ypnk1T2kgSLpIcU6yQIyEmM/+CcTef2RcB43iK0ZGIpY8a4n8mQXn7ds
	y/sODQRep906uX6/v80aGtRArPXLVVP+8MQ2hU54y/SDBfVhw7PbnWDKfYLM7hkIlXHAyd
	XXnqH4zGIJ457zpXxzdZgcX7pAFpGOQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-332-LYHENmTqOA6KkIy2xVzMUQ-1; Fri, 01 Mar 2024 15:47:20 -0500
X-MC-Unique: LYHENmTqOA6KkIy2xVzMUQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0DB2A827E74;
	Fri,  1 Mar 2024 20:47:20 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 08070112132A;
	Fri,  1 Mar 2024 20:47:20 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 0321CA1B80; Fri,  1 Mar 2024 15:47:20 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 2/4] dm vdo: add 'log_level' module parameter
Date: Fri,  1 Mar 2024 15:47:17 -0500
Message-ID: <0e4ec4fe6d612e10829e9ca645e53b06c5a7e45e.1709325896.git.msakai@redhat.com>
In-Reply-To: <cover.1709325895.git.msakai@redhat.com>
References: <cover.1709325895.git.msakai@redhat.com>
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

From: Mike Snitzer <snitzer@kernel.org>

Expose control over dm-vdo's log-level in terms of a module param. It
can be read and written via /sys/module/dm_vdo/parameters/log_level.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Ken Raeburn <raeburn@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/dm-vdo-target.c |  3 +++
 drivers/md/dm-vdo/logger.c        | 10 ++++++++--
 drivers/md/dm-vdo/logger.h        | 24 ++++++++++++++++--------
 3 files changed, 27 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm-vdo/dm-vdo-target.c b/drivers/md/dm-vdo/dm-vdo-target.c
index c6ee8161ba62..288e9b79bf16 100644
--- a/drivers/md/dm-vdo/dm-vdo-target.c
+++ b/drivers/md/dm-vdo/dm-vdo-target.c
@@ -2905,6 +2905,9 @@ static void __exit vdo_exit(void)
 module_init(vdo_init);
 module_exit(vdo_exit);
 
+module_param_named(log_level, vdo_log_level, uint, 0644);
+MODULE_PARM_DESC(log_level, "Log level for log messages");
+
 MODULE_DESCRIPTION(DM_NAME " target for transparent deduplication");
 MODULE_AUTHOR("Red Hat, Inc.");
 MODULE_LICENSE("GPL");
diff --git a/drivers/md/dm-vdo/logger.c b/drivers/md/dm-vdo/logger.c
index bac28fff622d..5d27cd6483a9 100644
--- a/drivers/md/dm-vdo/logger.c
+++ b/drivers/md/dm-vdo/logger.c
@@ -49,11 +49,17 @@ static const char *const PRIORITY_STRINGS[] = {
 	"DEBUG",
 };
 
-static int log_level = UDS_LOG_INFO;
+int vdo_log_level = UDS_LOG_DEFAULT;
 
 int uds_get_log_level(void)
 {
-	return log_level;
+	int log_level_latch = READ_ONCE(vdo_log_level);
+
+	if (unlikely(log_level_latch > UDS_LOG_MAX)) {
+		log_level_latch = UDS_LOG_DEFAULT;
+		WRITE_ONCE(vdo_log_level, log_level_latch);
+	}
+	return log_level_latch;
 }
 
 int uds_log_string_to_priority(const char *string)
diff --git a/drivers/md/dm-vdo/logger.h b/drivers/md/dm-vdo/logger.h
index ceb07aa3231f..095532afc9a3 100644
--- a/drivers/md/dm-vdo/logger.h
+++ b/drivers/md/dm-vdo/logger.h
@@ -6,20 +6,28 @@
 #ifndef UDS_LOGGER_H
 #define UDS_LOGGER_H
 
+#include <linux/kern_levels.h>
 #include <linux/module.h>
 #include <linux/ratelimit.h>
 #include <linux/device-mapper.h>
 
 /* Custom logging utilities for UDS */
 
-#define UDS_LOG_EMERG 0
-#define UDS_LOG_ALERT 1
-#define UDS_LOG_CRIT 2
-#define UDS_LOG_ERR 3
-#define UDS_LOG_WARNING 4
-#define UDS_LOG_NOTICE 5
-#define UDS_LOG_INFO 6
-#define UDS_LOG_DEBUG 7
+enum {
+	UDS_LOG_EMERG = LOGLEVEL_EMERG,
+	UDS_LOG_ALERT = LOGLEVEL_ALERT,
+	UDS_LOG_CRIT = LOGLEVEL_CRIT,
+	UDS_LOG_ERR = LOGLEVEL_ERR,
+	UDS_LOG_WARNING = LOGLEVEL_WARNING,
+	UDS_LOG_NOTICE = LOGLEVEL_NOTICE,
+	UDS_LOG_INFO = LOGLEVEL_INFO,
+	UDS_LOG_DEBUG = LOGLEVEL_DEBUG,
+
+	UDS_LOG_MAX = UDS_LOG_DEBUG,
+	UDS_LOG_DEFAULT = UDS_LOG_INFO,
+};
+
+extern int vdo_log_level;
 
 #define DM_MSG_PREFIX "vdo"
 #define UDS_LOGGING_MODULE_NAME DM_NAME ": " DM_MSG_PREFIX
-- 
2.42.0

