Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85F0D84A3E
	for <dm-devel@lists.linux.dev>; Wed, 22 Jan 2025 22:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737585058; cv=none; b=rKZDOy4D52m/IxfWWDvYacgY6bJKBNBhkiy8+/uvjHfL5ZuklxWjJ6hRgYf5bSzAwJuFAtNnRD3lAlx8Z6ujgehCdi35Wxkszn+P3i89qaHF2F/s28UwSCd9cCIPWH5xNtMo96m434F5rT2YJO4hZsgG1Qi6euPwVGhac7Qk7G8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737585058; c=relaxed/simple;
	bh=EaIL1GY1NM+BhoADr58kVKP8VEaBBia9nNgrl4t55GY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=rCUL/bqRqSWI5qnp6Tz7SF8MtNs1s0Koy2K5paz3LgY5Ib9HGVt547v9D0/oN4XLeEv0jBDjzDcc7ei2CYO49924EHp1sMzSOjtkMpllCIIlQlp9OEsE7Pi2bN/hpSms8fHiFyNB3azWZn66oPwutqBVW7UUjYbpdDTOUbi3hzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bI0MKoMi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bI0MKoMi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737585055;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=YkJLpcPVYDP3mV+VGE+IfFUMEmnOW740Svq/Bvs4XGA=;
	b=bI0MKoMiW01O3a+pntMA/2ZaUfF2fclQAcceM6Kqmm8NmIec+fT2qRG9JUR8mzER58pTh+
	xLUiIjEl5jIWWFMnDNqdQjKpG8V3D9MPmt5eyt3ssh+siNkynv6gv9w8drWmCq/kGNm9Hz
	w4CvjkVAItXOGLrIWBTc8vb9+nirUUc=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-362-L-7vJFYEP-u382ClWxNgmQ-1; Wed,
 22 Jan 2025 17:30:52 -0500
X-MC-Unique: L-7vJFYEP-u382ClWxNgmQ-1
X-Mimecast-MFC-AGG-ID: L-7vJFYEP-u382ClWxNgmQ
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 888B1193530B;
	Wed, 22 Jan 2025 22:30:21 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (unknown [10.0.103.170])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3653D19560B5;
	Wed, 22 Jan 2025 22:30:21 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 7B32E5EA83; Wed, 22 Jan 2025 17:30:20 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Matthew Sakai <msakai@redhat.com>,
	John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2] dm vdo: use a short static string for thread name prefix
Date: Wed, 22 Jan 2025 17:30:17 -0500
Message-ID: <ba07663c444baf7dfe539f41f9cb088354af4106.1737584895.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: f-crRWGQ1j76JuQqZUC4-mBZ55yhc4jzJ2waerjh8WA_1737585051
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
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/vdo.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/md/dm-vdo/vdo.c b/drivers/md/dm-vdo/vdo.c
index a7e32baab4af..eb4a9e2442dc 100644
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
@@ -559,8 +553,7 @@ int vdo_make(unsigned int instance, struct device_config *config, char **reason,
 	*vdo_ptr = vdo;
 
 	snprintf(vdo->thread_name_prefix, sizeof(vdo->thread_name_prefix),
-		 "%s%u", MODULE_NAME, instance);
-	BUG_ON(vdo->thread_name_prefix[0] == '\0');
+		 "%s%u", "vdo", instance);
 	result = vdo_allocate(vdo->thread_config.thread_count,
 			      struct vdo_thread, __func__, &vdo->threads);
 	if (result != VDO_SUCCESS) {
-- 
2.45.2

