Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECD78141996
	for <dm-devel@lists.linux.dev>; Wed, 14 Feb 2024 23:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707953120; cv=none; b=hdujENoUu0Ybe0JVC7go5BBavkg3DhxIO33JelYq2LXUZIvTdUQesLYTqjq4dY3Sg6HQxSGZ2ubk4Co013zM0D3UyVPfQ/uFy/6hsq+L4I06zeoxtTFm8vNGHTqogdhOj61d1C0JHfzyPImA3Ltyp5is6QxIChbJHLeTnRA2nFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707953120; c=relaxed/simple;
	bh=H9QV3tcVa2PQLKiAWabS7t6W5iks9j9DDqEeYkpnK1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b9OJlTCDnvtxGapwiRiHzkKcePtYRB1k4jt2EwIvb1OxqFfzXaRqS8i2QhdS8gH5WvWzbxL01AOeZvgals/SLoAeyVO6XnQG83Hc7PWaATmIyZ8NXtLx+TFuBPDgvWYj5gSNUndFBuOe1ZsFUdWBB0tZ7KWQdWbyCMTM4I5+DoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UuWeqUE2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UuWeqUE2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707953117;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mwIWaje9AHs1br106v2Jss/sI/atQldeLKBZ3xh5CeU=;
	b=UuWeqUE2KOpLZMZhcdMoOCt/iQGRh0jcDdS6slXBhZqH/clR7VDV6Wwko99n38HoYXOqvZ
	PjfI6mXkJWP2ss5NQ8MJyD64yunHCRxOTx0cx5qxGb22hJ30kJB0wYjW5Vc88atn2Pj0mu
	x5ewhlOQgrVC1NC2ZCFL8Y9JI25bq4M=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-645-SVcX5LqDPHmFetMUdP0yHQ-1; Wed,
 14 Feb 2024 18:25:14 -0500
X-MC-Unique: SVcX5LqDPHmFetMUdP0yHQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 617351C0513B;
	Wed, 14 Feb 2024 23:25:14 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 55F6B2026D06;
	Wed, 14 Feb 2024 23:25:14 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 5147057EC3; Wed, 14 Feb 2024 18:25:14 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 2/2] dm vdo logger: update logging to start with "device-mapper: vdo"
Date: Wed, 14 Feb 2024 18:25:14 -0500
Message-ID: <339bd684f8ad3139f4bd4316af0175c6947dcdb3.1707952829.git.msakai@redhat.com>
In-Reply-To: <cover.1707952829.git.msakai@redhat.com>
References: <cover.1707952829.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Mike Snitzer <snitzer@kernel.org>

Stops short of actually using DM's various logging macros (e.g. DMERR,
DMINFO, etc) because VDO's logger isn't quite compatible with them.

Also switch emit_log_message_to_kernel() from open-coding printk with
log-level to using corresponding pr_ macro.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Bruce Johnston <bjohnsto@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/logger.c | 10 +++++-----
 drivers/md/dm-vdo/logger.h |  8 +++-----
 2 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm-vdo/logger.c b/drivers/md/dm-vdo/logger.c
index 322224a07cf5..1efbf8d52f2c 100644
--- a/drivers/md/dm-vdo/logger.c
+++ b/drivers/md/dm-vdo/logger.c
@@ -115,20 +115,20 @@ static void emit_log_message_to_kernel(int priority, const char *fmt, ...)
 	case UDS_LOG_EMERG:
 	case UDS_LOG_ALERT:
 	case UDS_LOG_CRIT:
-		printk(KERN_CRIT "%pV", &vaf);
+		pr_crit("%pV", &vaf);
 		break;
 	case UDS_LOG_ERR:
-		printk(KERN_ERR "%pV", &vaf);
+		pr_err("%pV", &vaf);
 		break;
 	case UDS_LOG_WARNING:
-		printk(KERN_WARNING "%pV", &vaf);
+		pr_warn("%pV", &vaf);
 		break;
 	case UDS_LOG_NOTICE:
 	case UDS_LOG_INFO:
-		printk(KERN_INFO "%pV", &vaf);
+		pr_info("%pV", &vaf);
 		break;
 	case UDS_LOG_DEBUG:
-		printk(KERN_DEBUG "%pV", &vaf);
+		pr_debug("%pV", &vaf);
 		break;
 	default:
 		printk(KERN_DEFAULT "%pV", &vaf);
diff --git a/drivers/md/dm-vdo/logger.h b/drivers/md/dm-vdo/logger.h
index 09d448ff9ca9..4e2f18042ba7 100644
--- a/drivers/md/dm-vdo/logger.h
+++ b/drivers/md/dm-vdo/logger.h
@@ -8,6 +8,7 @@
 
 #include <linux/module.h>
 #include <linux/ratelimit.h>
+#include <linux/device-mapper.h>
 
 /* Custom logging utilities for UDS */
 
@@ -20,11 +21,8 @@
 #define UDS_LOG_INFO 6
 #define UDS_LOG_DEBUG 7
 
-#if defined(MODULE)
-#define UDS_LOGGING_MODULE_NAME THIS_MODULE->name
-#else /* compiled into the kernel */
-#define UDS_LOGGING_MODULE_NAME "vdo"
-#endif
+#define DM_MSG_PREFIX "vdo"
+#define UDS_LOGGING_MODULE_NAME DM_NAME ": " DM_MSG_PREFIX
 
 /* Apply a rate limiter to a log method call. */
 #define uds_log_ratelimit(log_fn, ...)                                    \
-- 
2.42.0

