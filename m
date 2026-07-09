Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F0DC3BFE34
	for <dm-devel@lists.linux.dev>; Thu,  9 Jul 2026 19:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783625868; cv=none; b=IJJZNmmr8qFJqZ7ZbssQQIrT0xf/rJN/wx5cF9NHOBJ9PLCfjrlpRQjIpyaww9Ui9DMi+QKvT4+elo7w15bEzY7u7GZpj7egjNIlfV0sZVz89VuoZO5e03+9q3dD5uppN5L32R5S0VnmB9B3bK8A7bTJVlbqBdNPhkCEmoBHRX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783625868; c=relaxed/simple;
	bh=Ibwj1MYWD/qB/E7lyRtE9L7ZjIoQoaFk122hPo/7Y+E=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=gmHmxfCHHoU9zfSMselSjoR51UMwVx7zQWzRiGwAN07Gnh9pFzNrHL8+t9cvLJIS9lvPJZxns8Grk/xZecfCa+hgy3sQ8Xm5SCv0hnc1mP6dYlXFQjycK2bdgqFnXbCZRVxJp3sPYz07CvNVBYvNHsElsDc4CoZW64Nwr2INCZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZtkgEdQI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZtkgEdQI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783625866;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=6LjbRWazt1D5DnKSrokml98lJeOx9Lkp9jXTAseSibE=;
	b=ZtkgEdQI9x08sTQZrNp8ut7D0S8vOX7qhh+Lw0fKpFG1klBj7BKfTfi9Cqp9R50QYwtaja
	EtbenjWXaVorFVkYfBTwleOEKPhWrbP+ufOBt29vhb9+Qsm2n0BWJSWHDjOZ1ZGN5LeeiY
	BU9H/Nfvk7dDf+9Q7rYwSZy2iWDQeCY=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-399-YNy78_ORMsqefOWIVolNng-1; Thu,
 09 Jul 2026 15:37:45 -0400
X-MC-Unique: YNy78_ORMsqefOWIVolNng-1
X-Mimecast-MFC-AGG-ID: YNy78_ORMsqefOWIVolNng_1783625864
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A734C1805A13;
	Thu,  9 Jul 2026 19:37:43 +0000 (UTC)
Received: from [10.44.32.225] (unknown [10.44.32.225])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 36DC71800593;
	Thu,  9 Jul 2026 19:37:42 +0000 (UTC)
Date: Thu, 9 Jul 2026 21:37:38 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>
cc: dm-devel@lists.linux.dev
Subject: [PATCH] dm-verity: make error counter atomic
Message-ID: <0a794a1f-8c16-2378-6770-bbaeae3f7d15@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: q-c-q04G1bA_kLPjUs0ZhyzTVOBbAMActSrhoSIgCmk_1783625864
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

The error counter "v->corrupted_errs" was not atomic, thus it could be
subject to race conditions. The call to
dm_audit_log_target("max-corrupted-errors") may be skipped due to the
races.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-4.6
Fixes: 65ff5b7ddf05 ("dm verity: add error handling modes for corrupted blocks")
Cc: stable@vger.kernel.org

---
 drivers/md/dm-verity-target.c |   12 +++++++-----
 drivers/md/dm-verity.h        |    2 +-
 2 files changed, 8 insertions(+), 6 deletions(-)

Index: linux-2.6/drivers/md/dm-verity-target.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-verity-target.c	2026-07-09 20:49:00.000000000 +0200
+++ linux-2.6/drivers/md/dm-verity-target.c	2026-07-09 21:01:53.000000000 +0200
@@ -180,14 +180,16 @@ static int verity_handle_err(struct dm_v
 	char *envp[] = { verity_env, NULL };
 	const char *type_str = "";
 	struct mapped_device *md = dm_table_get_md(v->ti->table);
+	int ce;
 
 	/* Corruption should be visible in device status in all modes */
 	v->hash_failed = true;
 
-	if (v->corrupted_errs >= DM_VERITY_MAX_CORRUPTED_ERRS)
-		goto out;
-
-	v->corrupted_errs++;
+	ce = atomic_read(&v->corrupted_errs);
+	do {
+		if (ce >= DM_VERITY_MAX_CORRUPTED_ERRS)
+			goto out;
+	} while (!atomic_try_cmpxchg(&v->corrupted_errs, &ce, ce + 1));
 
 	switch (type) {
 	case DM_VERITY_BLOCK_TYPE_DATA:
@@ -203,7 +205,7 @@ static int verity_handle_err(struct dm_v
 	DMERR_LIMIT("%s: %s block %llu is corrupted", v->data_dev->name,
 		    type_str, block);
 
-	if (v->corrupted_errs == DM_VERITY_MAX_CORRUPTED_ERRS) {
+	if (ce + 1 == DM_VERITY_MAX_CORRUPTED_ERRS) {
 		DMERR("%s: reached maximum errors", v->data_dev->name);
 		dm_audit_log_target(DM_MSG_PREFIX, "max-corrupted-errors", v->ti, 0);
 	}
Index: linux-2.6/drivers/md/dm-verity.h
===================================================================
--- linux-2.6.orig/drivers/md/dm-verity.h	2026-04-27 19:06:34.000000000 +0200
+++ linux-2.6/drivers/md/dm-verity.h	2026-07-09 20:52:43.000000000 +0200
@@ -68,7 +68,7 @@ struct dm_verity {
 	unsigned int digest_size;	/* digest size for the current hash algorithm */
 	enum verity_mode mode;	/* mode for handling verification errors */
 	enum verity_mode error_mode;/* mode for handling I/O errors */
-	unsigned int corrupted_errs;/* Number of errors for corrupted blocks */
+	atomic_t corrupted_errs;/* Number of errors for corrupted blocks */
 
 	struct workqueue_struct *verify_wq;
 

