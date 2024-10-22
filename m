Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79504811EB
	for <dm-devel@lists.linux.dev>; Tue, 22 Oct 2024 07:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729581203; cv=none; b=eERh+XSUWMChb9t8T1q23bF6NylaZSLLvQon5F5CZwtHEIH4ElhDcy14E0UEJFBX8FAb5bJCbr73CYfulFIsleOag1VZJsWEkAvDkw9+8EoYZh3BeKMxziSBFgTJGYeW/amXnLKWfQq9km30wx8uTJFb+8cSg5F9i9B/M2rE1wU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729581203; c=relaxed/simple;
	bh=unU4UT6uHhuCMbnR3FDf75CJxVt9vCvUoOXnUuj6lYs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=pCYCOKRuzUXv4IDGonnihpbb6Xy1SrCaGKzP3O+Z1B9RbVUg9ZLJvxk0CuNAFiM9cPJDvLCPalMtVoLo85S7dF5hzRNQ2IfRJcJSFJ42C12ESVEkMLBzPXhhdBgzKEtwnbyUFp0dLBTilcj7SV9malyhBKh6eexIWIjQxdE6Zi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NtPCR6Lf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NtPCR6Lf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729581200;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=IVpuDtQU3pAVsys2rDmJn13j/4rUMXRgZrmwgtPiep8=;
	b=NtPCR6LfWOYy7POA5UOUo/Wwrsl4wl+JB0Tki4swP8R4fe2rBZp2nbzgArLpQqCEjLH0w5
	cKl1li5VfgVWcMtroJrJP6tpZB4MDbx5uyDq8IkmI1sibYgLRmLgOFIS9y/4H7Nzl+Sdri
	nhz1AYridmqEGsuOpnpXPAcJ1Uzjsng=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-288-ZIiRLEW3Oo6I02T16cFZ9g-1; Tue,
 22 Oct 2024 03:13:17 -0400
X-MC-Unique: ZIiRLEW3Oo6I02T16cFZ9g-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2FE331956089;
	Tue, 22 Oct 2024 07:13:16 +0000 (UTC)
Received: from thinkpad.redhat.com (unknown [10.67.24.92])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 29C4319560B2;
	Tue, 22 Oct 2024 07:13:11 +0000 (UTC)
From: Ming-Hung Tsai <mtsai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: mpatocka@redhat.com,
	thornber@redhat.com,
	heinzm@redhat.com,
	snitzer@kernel.org,
	luomeng12@huawei.com,
	Ming-Hung Tsai <mtsai@redhat.com>
Subject: [PATCH 2/5] dm cache: fix flushing uninitialized delayed_work on cache_ctr error
Date: Tue, 22 Oct 2024 15:12:49 +0800
Message-ID: <20241022071249.778584-1-mtsai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

An unexpected WARN_ON from flush_work() may occur when cache creation
fails, caused by destroying the uninitialized delayed_work waker in the
error path of cache_create(). For example, the warning appears on the
superblock checksum error.

Reproduce steps:

dmsetup create cmeta --table "0 8192 linear /dev/sdc 0"
dmsetup create cdata --table "0 65536 linear /dev/sdc 8192"
dmsetup create corig --table "0 524288 linear /dev/sdc 262144"
dd if=/dev/urandom of=/dev/mapper/cmeta bs=4k count=1 oflag=direct
dmsetup create cache --table "0 524288 cache /dev/mapper/cmeta \
/dev/mapper/cdata /dev/mapper/corig 128 2 metadata2 writethrough smq 0"

Kernel logs:

(snip)
WARNING: CPU: 0 PID: 84 at kernel/workqueue.c:4178 __flush_work+0x5d4/0x890

Fix by pulling out the cancel_delayed_work_sync() from the constructor's
error path. This patch doesn't affect the use-after-free fix for
concurrent dm_resume and dm_destroy (commit 6a459d8edbdb ("dm cache: Fix
UAF in destroy()")) as cache_dtr is not changed.

Signed-off-by: Ming-Hung Tsai <mtsai@redhat.com>
Fixes: 6a459d8edbdb ("dm cache: Fix UAF in destroy()")
---
 drivers/md/dm-cache-target.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 90772b42c234..68e9a1abd303 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -1905,16 +1905,13 @@ static void check_migrations(struct work_struct *ws)
  * This function gets called on the error paths of the constructor, so we
  * have to cope with a partially initialised struct.
  */
-static void destroy(struct cache *cache)
+static void __destroy(struct cache *cache)
 {
-	unsigned int i;
-
 	mempool_exit(&cache->migration_pool);
 
 	if (cache->prison)
 		dm_bio_prison_destroy_v2(cache->prison);
 
-	cancel_delayed_work_sync(&cache->waker);
 	if (cache->wq)
 		destroy_workqueue(cache->wq);
 
@@ -1942,13 +1939,22 @@ static void destroy(struct cache *cache)
 	if (cache->policy)
 		dm_cache_policy_destroy(cache->policy);
 
+	bioset_exit(&cache->bs);
+
+	kfree(cache);
+}
+
+static void destroy(struct cache *cache)
+{
+	unsigned int i;
+
+	cancel_delayed_work_sync(&cache->waker);
+
 	for (i = 0; i < cache->nr_ctr_args ; i++)
 		kfree(cache->ctr_args[i]);
 	kfree(cache->ctr_args);
 
-	bioset_exit(&cache->bs);
-
-	kfree(cache);
+	__destroy(cache);
 }
 
 static void cache_dtr(struct dm_target *ti)
@@ -2561,7 +2567,7 @@ static int cache_create(struct cache_args *ca, struct cache **result)
 	*result = cache;
 	return 0;
 bad:
-	destroy(cache);
+	__destroy(cache);
 	return r;
 }
 
@@ -2612,7 +2618,7 @@ static int cache_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 	r = copy_ctr_args(cache, argc - 3, (const char **)argv + 3);
 	if (r) {
-		destroy(cache);
+		__destroy(cache);
 		goto out;
 	}
 
-- 
2.47.0

