Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D68AE1D63EE
	for <dm-devel@lists.linux.dev>; Wed, 29 Jan 2025 23:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738193171; cv=none; b=OCbX6YKMvAmMIrFYJuEWIkF3uw2eNoLKVnzU4QdLYuubbVHiRjMMjipUYhL0kmhIWzhfOvYoghUh4RMaNtnjknRDN/RgA9zNpwQdGfVX5wyfDgvPs25q6OF/FbbVARBmxBcWHe0WHwnICbSfySUPkwHjun6H9bwdEZ/8xEvz2lE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738193171; c=relaxed/simple;
	bh=94mFgbAeaK5IEFZp6fXy/0CEgAQfx23993CE6bC8Gnc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=WDi108jVHWCB2CHeLj1kx1VHRmB34Dcx9bNlv60miQDnUZWxGDx7drlUvJVtiR19if3r3eeiPBRxu7hGgC0Kx2A6SMVvyE/8Q0KNgXzYdH7oTAeMXn2iF6I7l+VJMSSwk9ax+0PvsFukVv421p8jT1xSHN0voQMRxT7K3MNTZNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PaDGJsRu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PaDGJsRu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738193168;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=9731EjN8QRx4BDHARfSLHMf1XAyYnA3s4C3IeySj9XI=;
	b=PaDGJsRuNYBqxB2DOE665WzArKWCCX+rT14IjWDtN6Oox2D7kyFINKb+dRzqWuyQ+piKC8
	ofSIeu26UguRpCh7pDUJaT5WBVxpuPIxUmsn47wWJhrTn23I80M0mRU3dn5mm0MCExdYlD
	Nms0oGfNNN3g/FmrTR/MSWNVN73LfuY=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-608-6AmWqaE9Nu6TiTd3jcU3RA-1; Wed,
 29 Jan 2025 18:26:07 -0500
X-MC-Unique: 6AmWqaE9Nu6TiTd3jcU3RA-1
X-Mimecast-MFC-AGG-ID: 6AmWqaE9Nu6TiTd3jcU3RA
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 39824180035F
	for <dm-devel@lists.linux.dev>; Wed, 29 Jan 2025 23:26:06 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (unknown [10.0.103.170])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EC46D1800352;
	Wed, 29 Jan 2025 23:26:05 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 22DD75F0CA; Wed, 29 Jan 2025 18:26:05 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Matthew Sakai <msakai@redhat.com>
Subject: [PATCH v3] dm vdo: use a short static string for thread name prefix
Date: Wed, 29 Jan 2025 18:26:05 -0500
Message-ID: <97956b2f64cbb9eea08254d7a822a602c9e3d1df.1738193094.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: eZs-CidMAz142FQfu4zhV-A6U564jq7Er4K_VQcwqgY_1738193166
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Also remove MODULE_NAME and a BUG_ON check, both unneeded.

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

Reported-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/vdo.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/md/dm-vdo/vdo.c b/drivers/md/dm-vdo/vdo.c
index a7e32baab4af..80b608674022 100644
--- a/drivers/md/dm-vdo/vdo.c
+++ b/drivers/md/dm-vdo/vdo.c
@@ -31,9 +31,7 @@
 
 #include <linux/completion.h>
 #include <linux/device-mapper.h>
-#include <linux/kernel.h>
 #include <linux/lz4.h>
-#include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
 #include <linux/types.h>
@@ -142,12 +140,6 @@ static void finish_vdo_request_queue(void *ptr)
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
@@ -559,8 +551,7 @@ int vdo_make(unsigned int instance, struct device_config *config, char **reason,
 	*vdo_ptr = vdo;
 
 	snprintf(vdo->thread_name_prefix, sizeof(vdo->thread_name_prefix),
-		 "%s%u", MODULE_NAME, instance);
-	BUG_ON(vdo->thread_name_prefix[0] == '\0');
+		 "vdo%u", instance);
 	result = vdo_allocate(vdo->thread_config.thread_count,
 			      struct vdo_thread, __func__, &vdo->threads);
 	if (result != VDO_SUCCESS) {
-- 
2.45.2

