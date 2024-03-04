Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA11710A25
	for <dm-devel@lists.linux.dev>; Mon,  4 Mar 2024 20:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709585124; cv=none; b=f+2AQ3ra5jbvDR529ohTGy86MRVnIk7dmYwdnUpBQEQ2qN5R1R/MU38E+bgUe20Ez+uEcMDLnwNRMpG61CeeEg/tmbHsxzubJqOE9t9T2RMKrHDaSPks6m+PS8rBSA2y+dLXT0bb5gJKZQxCoTWooacKzQdXgal5U7CzaQ8gYV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709585124; c=relaxed/simple;
	bh=YIoQV5T8cH27QxXENc+mXDDvmzInkHrL8zx0sxdNdtU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=cEIFrm2+NU7Lae+SQz9P2K8c85lOB3N/EKOAtOsDHNyxiHIWEgPRCexto/aIZjlWR2w+EP65wpmAwoCh73XMxVvSURsciCZej9rGmGBeJE1FZrITx+NfX7cA6zuLx7edHl98bUqyPPJUUQESsgnTOySJTdjopi46sadv9fg3bzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E8CvioKB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E8CvioKB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709585121;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=nUoyS5dWVZxV7H04bxoBPG56Xdte54AQ4XFJQecSJSI=;
	b=E8CvioKB7sOjzxpmTFmGy3p4XF9/uU0yTzu8KoMgU3p7RQMKPdUf9mslfKXvymzCAH/v8B
	1wMgz0EbfOU0muR9EXGGgyLcQmezxw09nNMRmAftOfVXsVewJtOuQYmLcPEnCfD9n4ndGl
	f4g+OIaYag3AwiDfn9AtdirLGFPcNyQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-147-f-OyWzjRNtavNJzpJQPmJw-1; Mon, 04 Mar 2024 15:45:20 -0500
X-MC-Unique: f-OyWzjRNtavNJzpJQPmJw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D4A6D848C05
	for <dm-devel@lists.linux.dev>; Mon,  4 Mar 2024 20:45:19 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CBAC4AD1;
	Mon,  4 Mar 2024 20:45:19 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id C8A6EA29F1; Mon,  4 Mar 2024 15:45:19 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Matthew Sakai <msakai@redhat.com>
Subject: [PATCH] dm vdo: remove meaningless version number constant
Date: Mon,  4 Mar 2024 15:45:19 -0500
Message-ID: <fd30b219d5f88e2a928987cc78d0b27762db654f.1709584941.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Also remove related log messages.

Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/dm-vdo-target.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/md/dm-vdo/dm-vdo-target.c b/drivers/md/dm-vdo/dm-vdo-target.c
index 9128e6cd0844..5a4b0a927f56 100644
--- a/drivers/md/dm-vdo/dm-vdo-target.c
+++ b/drivers/md/dm-vdo/dm-vdo-target.c
@@ -39,8 +39,6 @@
 #include "vdo.h"
 #include "vio.h"
 
-#define	CURRENT_VERSION "8.3.0.65"
-
 enum admin_phases {
 	GROW_LOGICAL_PHASE_START,
 	GROW_LOGICAL_PHASE_GROW_BLOCK_MAP,
@@ -2863,8 +2861,6 @@ static void vdo_module_destroy(void)
 			    instances.count);
 	vdo_free(instances.words);
 	memset(&instances, 0, sizeof(struct instance_tracker));
-
-	vdo_log_info("unloaded version %s", CURRENT_VERSION);
 }
 
 static int __init vdo_init(void)
@@ -2876,7 +2872,6 @@ static int __init vdo_init(void)
 	vdo_initialize_threads_mutex();
 	vdo_initialize_thread_device_registry();
 	vdo_initialize_device_registry_once();
-	vdo_log_info("loaded version %s", CURRENT_VERSION);
 
 	/* Add VDO errors to the set of errors registered by the indexer. */
 	result = vdo_register_status_codes();
-- 
2.42.0

