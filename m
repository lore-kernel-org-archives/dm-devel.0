Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A3213472B
	for <dm-devel@lists.linux.dev>; Wed, 14 Feb 2024 23:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707953119; cv=none; b=XdSxdOCP0HaHGdF8AnpNYxMkuBaDqaT3U4JCnwPpb5wFc53ofGKG26dAEyQAX4qgB299cr7dik//CS0Ywa46EXCNm49pVeQHxDysxZzLPxexjVnYJhg+EqgdWrcLvI/w+ZxQHFaET7DmcggKGbBxfRVluNZAmvX84/AElqLavr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707953119; c=relaxed/simple;
	bh=Xs6GV2u2R5nrOwkOUj65a7w8ow3Us/wR/WAgRhkJrBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hMBG9ELZKRIS51Y10zNPSFDpeXk6G2cp7sFMooijPqufdBDW1H5GLqx3ivFns5pL9GoHwUGIm4zSvzydKgcYwz61KHnBgZH3Tes11wnBZDyGuaSSPZy+NkuI0qgR6AHV9kJp3SZ/WsigPC7yPuCZJly0bgSi/lI/+aEByDVoWqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dZTWpFJN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dZTWpFJN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707953116;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Orc1DmHIPAWLcklJ/SzQM+GdWFPmtkL4/s7YIqNozds=;
	b=dZTWpFJNNzwVaMM/9cClDhoYlYfnbo8TCNvZ8maLCjrtjf9jEYhHpPKfV3DpI2RtCRzFdk
	YMgElL57NffwxXZlkM0XdUMm63BvIa02M/KWI824m36avI+frrvTH40ypUce4IKtq+COPk
	0LtR1OI3pWMT/UrXxdC00VIhPq5KXwg=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-686-hSRedq9CNiSzuAPnVT6uqw-1; Wed,
 14 Feb 2024 18:25:14 -0500
X-MC-Unique: hSRedq9CNiSzuAPnVT6uqw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8B5473806624;
	Wed, 14 Feb 2024 23:25:14 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 83DB4C185C4;
	Wed, 14 Feb 2024 23:25:14 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 4C19757EC1; Wed, 14 Feb 2024 18:25:14 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 1/2] dm vdo logger: switch UDS_LOG_NOTICE to be alias for UDS_LOG_INFO
Date: Wed, 14 Feb 2024 18:25:13 -0500
Message-ID: <5da271aa66adb24bd2a7a27a416be54a4ebd2d8e.1707952829.git.msakai@redhat.com>
In-Reply-To: <cover.1707952829.git.msakai@redhat.com>
References: <cover.1707952829.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Mike Snitzer <snitzer@kernel.org>

Prepare to bring VDO's logging closer to DM's logging by eliminating
support for KERN_NOTICE log level (DM hasn't ever had a need for it).

Only one message in index-session.c used UDS_LOG_NOTICE, convert it to
log with uds_log_info().

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Bruce Johnston <bjohnsto@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/index-session.c | 2 +-
 drivers/md/dm-vdo/logger.c        | 2 --
 drivers/md/dm-vdo/logger.h        | 5 -----
 3 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/md/dm-vdo/index-session.c b/drivers/md/dm-vdo/index-session.c
index 9b5d2cacfffd..7afc19748712 100644
--- a/drivers/md/dm-vdo/index-session.c
+++ b/drivers/md/dm-vdo/index-session.c
@@ -378,7 +378,7 @@ int uds_open_index(enum uds_open_index_type open_type,
 
 	session->parameters = *parameters;
 	format_dev_t(name, parameters->bdev->bd_dev);
-	uds_log_notice("%s: %s", get_open_type_string(open_type), name);
+	uds_log_info("%s: %s", get_open_type_string(open_type), name);
 
 	result = initialize_index_session(session, open_type);
 	if (result != UDS_SUCCESS)
diff --git a/drivers/md/dm-vdo/logger.c b/drivers/md/dm-vdo/logger.c
index fe632f10b5d9..322224a07cf5 100644
--- a/drivers/md/dm-vdo/logger.c
+++ b/drivers/md/dm-vdo/logger.c
@@ -124,8 +124,6 @@ static void emit_log_message_to_kernel(int priority, const char *fmt, ...)
 		printk(KERN_WARNING "%pV", &vaf);
 		break;
 	case UDS_LOG_NOTICE:
-		printk(KERN_NOTICE "%pV", &vaf);
-		break;
 	case UDS_LOG_INFO:
 		printk(KERN_INFO "%pV", &vaf);
 		break;
diff --git a/drivers/md/dm-vdo/logger.h b/drivers/md/dm-vdo/logger.h
index 246aa43db9ee..09d448ff9ca9 100644
--- a/drivers/md/dm-vdo/logger.h
+++ b/drivers/md/dm-vdo/logger.h
@@ -74,9 +74,6 @@ int uds_vlog_strerror(int priority, int errnum, const char *module, const char *
 #define uds_log_info_strerror(errnum, ...) \
 	uds_log_strerror(UDS_LOG_INFO, errnum, __VA_ARGS__)
 
-#define uds_log_notice_strerror(errnum, ...) \
-	uds_log_strerror(UDS_LOG_NOTICE, errnum, __VA_ARGS__)
-
 #define uds_log_warning_strerror(errnum, ...) \
 	uds_log_strerror(UDS_LOG_WARNING, errnum, __VA_ARGS__)
 
@@ -93,8 +90,6 @@ void __uds_log_message(int priority, const char *module, const char *format, ...
 
 #define uds_log_info(...) uds_log_message(UDS_LOG_INFO, __VA_ARGS__)
 
-#define uds_log_notice(...) uds_log_message(UDS_LOG_NOTICE, __VA_ARGS__)
-
 #define uds_log_warning(...) uds_log_message(UDS_LOG_WARNING, __VA_ARGS__)
 
 #define uds_log_error(...) uds_log_message(UDS_LOG_ERR, __VA_ARGS__)
-- 
2.42.0

