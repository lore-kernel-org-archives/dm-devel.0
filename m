Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20BD32EB860
	for <dm-devel@lists.linux.dev>; Fri, 30 Jan 2026 21:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769809823; cv=none; b=Gjw52/WbwClHHZuv8uKfeumAVTYfQJMB5lR4zYnnt5kyzFEIh4sHye6OPllFbuKrRkLM4z9ZOrbbTJt6fsssPQotJqTK1l3Krh3hrHSVEB8kn39PC1voCAj+h2oPOw4T1KKiKLs7tUocwsI4tKETZ5vnjMgnG9NCudrXWureI48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769809823; c=relaxed/simple;
	bh=3yw2KnTIQrapdylaLDJ980OIK9NfLVXDiRdSdCH8VaA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=TLBaoV2EYzg78Kt3MxXjoWlddpCao1+oLEafKKze/0H+TA1kHoXwsZVm2mRFY6QFwegszBRxykJRZZumNARkPMZlD8Y8sX6ZMS0cZnaYkPNnz6W1lcyKmpOihdIm9kSEEH9/AVqx7XM6awZosYnRC4KD5AjEejWizksWDjFTV2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N0q/yh0A; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N0q/yh0A"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769809821;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=KhYzmtntFG8vFTiyBIUehs8/9+KXhztYSjTBWVbgXzU=;
	b=N0q/yh0AhD1Olq1OwqIaAUP7s3jMMlbqNkDuUirWIbTJrSdwpfxzqNkslGEdRXY04jQFQG
	6O324l4JeA+EmkuTzUk6Hhhn4KY9oBxPY4jopK/tydebH339vFPpidnks/v286Gth6qndf
	sIeoGEqM2G3zwQNxQjXTE09Bm7VFZPA=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-166-baBnSI7cPcaUGVfrAZNGSw-1; Fri,
 30 Jan 2026 16:50:18 -0500
X-MC-Unique: baBnSI7cPcaUGVfrAZNGSw-1
X-Mimecast-MFC-AGG-ID: baBnSI7cPcaUGVfrAZNGSw_1769809818
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E49031956050
	for <dm-devel@lists.linux.dev>; Fri, 30 Jan 2026 21:50:17 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (unknown [10.0.103.170])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7BD801800870;
	Fri, 30 Jan 2026 21:50:17 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id E00F9125919; Fri, 30 Jan 2026 16:50:16 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Matthew Sakai <msakai@redhat.com>
Subject: [PATCH] dm vdo logger: remove redundant logging info
Date: Fri, 30 Jan 2026 16:50:16 -0500
Message-ID: <fc522f07bab3369a35dea11fbd201ee940a9c5bf.1769809573.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: o7u7C02czVfEzlA74G5qQVu1um_dF_OQ9ZsTq0pRd-U_1769809818
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Also update comments to reflect current log output style.

Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/logger.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-vdo/logger.c b/drivers/md/dm-vdo/logger.c
index 3f7dc2cb6b98..1c57f03fd275 100644
--- a/drivers/md/dm-vdo/logger.c
+++ b/drivers/md/dm-vdo/logger.c
@@ -94,10 +94,10 @@ static void emit_log_message_to_kernel(int priority, const char *fmt, ...)
  *
  * Context info formats:
  *
- * interrupt:           uds[NMI]: blah
- * kvdo thread:         kvdo12:foobarQ: blah
- * thread w/device id:  kvdo12:myprog: blah
- * other thread:        uds: myprog: blah
+ * interrupt:           device-mapper: vdo[NMI]: blah
+ * thread w/device id:  device-mapper: vdo12:myprog: blah
+ * dm-vdo thread:       device-mapper: vdo12:foobarQ: blah
+ * other thread:        device-mapper: vdo: myprog: blah
  *
  * Fields: module name, interrupt level, process name, device ID.
  *
@@ -134,13 +134,13 @@ static void emit_log_message(int priority, const char *module, const char *prefi
 	}
 
 	/*
-	 * If it's a kernel thread and the module name is a prefix of its name, assume it is ours
-	 * and only identify the thread.
+	 * If it's a kernel thread and the target name is a prefix of the thread name, assume it
+	 * is ours and collapse the names.
 	 */
 	if (((current->flags & PF_KTHREAD) != 0) &&
-	    (strncmp(module, current->comm, strlen(module)) == 0)) {
-		emit_log_message_to_kernel(priority, "%s: %s%pV%pV\n", current->comm,
-					   prefix, vaf1, vaf2);
+	    (strncmp(DM_MSG_PREFIX, current->comm, strlen(DM_MSG_PREFIX)) == 0)) {
+		emit_log_message_to_kernel(priority, "%s: %s: %s%pV%pV\n", DM_NAME,
+					   current->comm, prefix, vaf1, vaf2);
 		return;
 	}
 
-- 
2.48.1

