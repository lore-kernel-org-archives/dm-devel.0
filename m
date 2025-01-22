Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B17BB249F9
	for <dm-devel@lists.linux.dev>; Wed, 22 Jan 2025 02:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737513765; cv=none; b=FoubEGaH9LOaMpldSf6UHWUwL/yzOUFWSSx2MFjP+Y/e1JztlHRP5JU7or99+7+BldZPCqNseeEfxg/f7XZcP3I8YD6DP7jperEFKx1ERcFtSnZtFWpS51KiDRAgIUWvO6JYdyHHvaSHD6fi3QDaz0FPBckY7De9rse4Zx2sKtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737513765; c=relaxed/simple;
	bh=QALzVIZC+KZ76z/q74gOMzJx/0+XU3bgkK7EHEsfhnA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Olrogv9OVdw1dk/w9E5GGHHpELccazVt81G1VZXKTZ4A1yBviRN9PO/zQJ/rrFonYv0XHn5j+StE13eEmST0JkJfzc0kqWaZYS+Yd7SaowmqCWj9o3yuSUK1pogO7CzY+hUSw0HKLwrPUv0BCmNf8/zMGJFirq9f+Sdwnpiqpyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YYk2ngPo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YYk2ngPo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737513762;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=MUOjnDxLI69owTZhA+YqUrW+ZmM28gyTFZFTLztNkno=;
	b=YYk2ngPoQ81K7kBIu53YYu69Qbd1pSCQ90xfPq8NmM6zn21lSMgHTvwjyrNbElYK7deOO+
	N+GVVKZesJkuPTaOYdvw/OD8D4j2NExwpCf414h+aVIIX62AFn+TlDjxXei12xk3AXVgJy
	a6Y5gWHdl4AW4ntC/HCKkf4AKgp5Csk=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-244-vuQvwUKqMgGSKivIIb6r3Q-1; Tue,
 21 Jan 2025 21:42:38 -0500
X-MC-Unique: vuQvwUKqMgGSKivIIb6r3Q-1
X-Mimecast-MFC-AGG-ID: vuQvwUKqMgGSKivIIb6r3Q
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A57031955D81;
	Wed, 22 Jan 2025 02:42:37 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (unknown [10.0.103.170])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4617B19560AA;
	Wed, 22 Jan 2025 02:42:37 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 6CBC75E9B8; Tue, 21 Jan 2025 21:42:36 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Matthew Sakai <msakai@redhat.com>,
	John Garry <john.g.garry@oracle.com>
Subject: [PATCH] dm vdo: use a short static string for thread name prefix
Date: Tue, 21 Jan 2025 21:42:04 -0500
Message-ID: <9146ca1541ef988061c22eddd03ae5f5905fc78e.1737513476.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 31dOq_omHKGHQAixuJEZ9rWw_nbW15YTpc_QNOCvOpI_1737513758
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Also remove MODULE_NAME, which is now unused.

This fixes a warning about string truncation in snprintf that
will never happen in practice:

drivers/md/dm-vdo/vdo.c: In function ‘vdo_make’:
drivers/md/dm-vdo/vdo.c:564:5: error: ‘%s’ directive output may be truncated writing up to 55 bytes into a region of size 16 [-Werror=format-truncation=]
    "%s%u", MODULE_NAME, instance);
     ^~
drivers/md/dm-vdo/vdo.c:563:2: note: ‘snprintf’ output between 2 and 66 bytes into a destination of size 16
  snprintf(vdo->thread_name_prefix, sizeof(vdo->thread_name_prefix),
  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    "%s%u", MODULE_NAME, instance);
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Suggested-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/vdo.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/md/dm-vdo/vdo.c b/drivers/md/dm-vdo/vdo.c
index a7e32baab4af..40b3ff8c49cc 100644
--- a/drivers/md/dm-vdo/vdo.c
+++ b/drivers/md/dm-vdo/vdo.c
@@ -142,12 +142,6 @@ static void finish_vdo_request_queue(void *ptr)
 	vdo_unregister_allocating_thread();
 }
 
-#ifdef MODULE
-#define MODULE_NAME THIS_MODULE->name
-#else
-#define MODULE_NAME "dm-vdo"
-#endif  /* MODULE */
-
 static const struct vdo_work_queue_type default_queue_type = {
 	.start = start_vdo_request_queue,
 	.finish = finish_vdo_request_queue,
@@ -559,7 +553,7 @@ int vdo_make(unsigned int instance, struct device_config *config, char **reason,
 	*vdo_ptr = vdo;
 
 	snprintf(vdo->thread_name_prefix, sizeof(vdo->thread_name_prefix),
-		 "%s%u", MODULE_NAME, instance);
+		 "%s%u", "vdo", instance);
 	BUG_ON(vdo->thread_name_prefix[0] == '\0');
 	result = vdo_allocate(vdo->thread_config.thread_count,
 			      struct vdo_thread, __func__, &vdo->threads);
-- 
2.45.2

