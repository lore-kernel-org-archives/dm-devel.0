Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C539D47F73
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 04:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709267194; cv=none; b=XjCZMJXDU9xlYWtoR3xzp4tPI7o436Zj/dXTCukJYis8JVi5+BzZrFfqrVybdmyKZUynr1pHyx9wi5aGZQeyWBfwQHovoOBZst7hJIWQ7tHQPYHd5/rVmsZLZbPLr04yqcVRH90X9yKAuIdc9rJrlda3fkuXOEnr0nNNY3nmXMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709267194; c=relaxed/simple;
	bh=tA2XtGRCxOadpkZnlVD2KjRwwSc3AP+DtSQvfHBbEtw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B6ic6z/boCwqstjhS8LY6aozJ9XdDWTiw6H7ZZeIAJ/67yJQH8N35WWKJqhDN8igJREBG5hRP7onsEJSF8cV/AiUMewnyYkrL1jD5xZwPL/+ogY4d6jR+uwFa1bOAuj4Jh7m3Kf+D9SwnERFLfWq6/DRWw7VYbCwMi5R87QGrYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IV+r5wEw; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IV+r5wEw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709267191;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IZ9lJymOn1ivSv/jTVm/qE8Z31HN9Y693I79hhU9YJ8=;
	b=IV+r5wEw/0IDPjNRqXvfnke4+zO5+3Ge1XwG1TAOU69xWRwdvJzvGSf2uangg9pAmGIVc0
	ssW+s2iSIIV11w1x76h9StRVUM+RBxd42l+l1zbCO1gLFKWwTu6riMFG/U7KGbQVvOjSIr
	Dc6J2f1qV3uzhdsWVvh5l9VJKuKK7fc=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-196-TeKRbHHTPdqbX02Iy6opiA-1; Thu,
 29 Feb 2024 23:26:30 -0500
X-MC-Unique: TeKRbHHTPdqbX02Iy6opiA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 18C223C0ED68
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 04:26:30 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 125911C060B1;
	Fri,  1 Mar 2024 04:26:30 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 00BF2A15DD; Thu, 29 Feb 2024 23:26:29 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 10/11] dm vdo: update module comments
Date: Thu, 29 Feb 2024 23:26:28 -0500
Message-ID: <a12bbdfc6ec6467fbefac431c316ee9f55787e22.1709266694.git.msakai@redhat.com>
In-Reply-To: <cover.1709266694.git.msakai@redhat.com>
References: <cover.1709266694.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Update outdated comments referring to separate VDO and UDS
modules.

Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/dm-vdo-target.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm-vdo/dm-vdo-target.c b/drivers/md/dm-vdo/dm-vdo-target.c
index 0114fa4d48a2..429a285cbc4a 100644
--- a/drivers/md/dm-vdo/dm-vdo-target.c
+++ b/drivers/md/dm-vdo/dm-vdo-target.c
@@ -2907,9 +2907,7 @@ static int __init vdo_init(void)
 {
 	int result = 0;
 
-	/*
-	 * UDS module level initialization must be done first, as VDO initialization depends on it
-	 */
+	/* Memory tracking must be initialized first for accurate accounting. */
 	uds_memory_init();
 	uds_init_sysfs();
 
@@ -2917,7 +2915,7 @@ static int __init vdo_init(void)
 	vdo_initialize_device_registry_once();
 	uds_log_info("loaded version %s", CURRENT_VERSION);
 
-	/* Add VDO errors to the already existing set of errors in UDS. */
+	/* Add VDO errors to the set of errors registered by the indexer. */
 	result = vdo_register_status_codes();
 	if (result != UDS_SUCCESS) {
 		uds_log_error("vdo_register_status_codes failed %d", result);
@@ -2939,11 +2937,8 @@ static int __init vdo_init(void)
 static void __exit vdo_exit(void)
 {
 	vdo_module_destroy();
-	/*
-	 * UDS module level exit processing must be done after all VDO module exit processing is
-	 * complete.
-	 */
 	uds_put_sysfs();
+	/* Memory tracking cleanup must be done last. */
 	uds_memory_exit();
 }
 
-- 
2.42.0

