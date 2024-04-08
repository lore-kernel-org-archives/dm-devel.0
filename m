Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 737571E489
	for <dm-devel@lists.linux.dev>; Mon,  8 Apr 2024 19:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712605023; cv=none; b=M6feN3BRMkWNVMRlXhq3RtJUuBnpJrAEHqSiQOSV+eB0P0ve9DKEj3w/lD2lBk+AoFRaXPu9hzEfomztCTegWqmVaZgFie03Ue6QstesZBaJeN9b64O4JvoxuedTrFPy84b6crxqdescoHgDvp4C4Cm5CYoBzK9BYt4+4YnNN+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712605023; c=relaxed/simple;
	bh=B2qB36/uQsKHAg9ciu9fxPNT/FufU4K+2ca6UsyUBGg=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=Ih+UQb4vA8wySNFkqgstffl++NcqpTxxIACN+YxLvLa6+ms0u8mHEWgLFfiIOqqRVe/iLHK7twYRx92WWrwXHbLRSObZBU5W3M3cx+G4tMhC4J6wNUWzqJKGF5xQU+a5b0Ggw5B+TzcQwIc+YQC+Ao3Ef7iltlCzVB7T7O/oa70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eje/C9mS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eje/C9mS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712605020;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=9CyQJzLRnEB2mn7LtsfHdXBVGu/u4weOGAsjV1w2j4U=;
	b=eje/C9mS90mtw9daDULV9Wk+3gr/p41h/H8qpulm2VG35N4QzBz1x19N0MbqmQowj0TBxl
	bsTo0tjOKicjMnBOtwTMz894KyJy98+U47JH38xXt5UhlEXWCnsSXsfp+XNnQr41SqWnxy
	XHJputu8aNOIRZ+cTpcVF/H9VqWiWlY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-639-fdKi9Qg4N0WTG98zoI3P9Q-1; Mon, 08 Apr 2024 15:36:57 -0400
X-MC-Unique: fdKi9Qg4N0WTG98zoI3P9Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AFCD180171B;
	Mon,  8 Apr 2024 19:36:56 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8A736200B09C;
	Mon,  8 Apr 2024 19:36:56 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 731A130BE3C1; Mon,  8 Apr 2024 19:36:56 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 6DA883FD64;
	Mon,  8 Apr 2024 21:36:56 +0200 (CEST)
Date: Mon, 8 Apr 2024 21:36:56 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Mike Snitzer <msnitzer@redhat.com>
cc: dm-devel@lists.linux.dev, Milan Broz <gmazyland@gmail.com>, 
    yangerkun@huawei.com, Bart Van Assche <bvanassche@acm.org>, 
    "Alasdair G. Kergon" <agk@redhat.com>, 
    Laurence Oberman <loberman@redhat.com>
Subject: [PATCH resend] dm-crypt: add the "high_priority" flag
Message-ID: <f53ff8a9-da8e-da35-cdf8-3bd260d9af33@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

It was reported that dm-crypt performs badly when the system is loaded[1]. 
So I'm adding an option "high_priority" that sets the workqueues and the 
write_thread to nice level -20. This used to be default in the past, but 
it caused audio skipping, so it had to be reverted - see the commit 
f612b2132db529feac4f965f28a1b9258ea7c22b. This commit makes it optional, 
so that normal users won't be harmed by it.

[1] https://listman.redhat.com/archives/dm-devel/2023-February/053410.html

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 Documentation/admin-guide/device-mapper/dm-crypt.rst |    5 +++
 drivers/md/dm-crypt.c                                |   28 +++++++++++++------
 2 files changed, 25 insertions(+), 8 deletions(-)

Index: linux-2.6/drivers/md/dm-crypt.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-crypt.c	2024-04-08 19:54:41.000000000 +0200
+++ linux-2.6/drivers/md/dm-crypt.c	2024-04-08 19:54:58.000000000 +0200
@@ -137,9 +137,9 @@ struct iv_elephant_private {
  * and encrypts / decrypts at the same time.
  */
 enum flags { DM_CRYPT_SUSPENDED, DM_CRYPT_KEY_VALID,
-	     DM_CRYPT_SAME_CPU, DM_CRYPT_NO_OFFLOAD,
-	     DM_CRYPT_NO_READ_WORKQUEUE, DM_CRYPT_NO_WRITE_WORKQUEUE,
-	     DM_CRYPT_WRITE_INLINE };
+	     DM_CRYPT_SAME_CPU, DM_CRYPT_HIGH_PRIORITY,
+	     DM_CRYPT_NO_OFFLOAD, DM_CRYPT_NO_READ_WORKQUEUE,
+	     DM_CRYPT_NO_WRITE_WORKQUEUE, DM_CRYPT_WRITE_INLINE };
 
 enum cipher_flags {
 	CRYPT_MODE_INTEGRITY_AEAD,	/* Use authenticated mode for cipher */
@@ -3134,7 +3134,7 @@ static int crypt_ctr_optional(struct dm_
 	struct crypt_config *cc = ti->private;
 	struct dm_arg_set as;
 	static const struct dm_arg _args[] = {
-		{0, 8, "Invalid number of feature args"},
+		{0, 9, "Invalid number of feature args"},
 	};
 	unsigned int opt_params, val;
 	const char *opt_string, *sval;
@@ -3161,6 +3161,8 @@ static int crypt_ctr_optional(struct dm_
 
 		else if (!strcasecmp(opt_string, "same_cpu_crypt"))
 			set_bit(DM_CRYPT_SAME_CPU, &cc->flags);
+		else if (!strcasecmp(opt_string, "high_priority"))
+			set_bit(DM_CRYPT_HIGH_PRIORITY, &cc->flags);
 
 		else if (!strcasecmp(opt_string, "submit_from_crypt_cpus"))
 			set_bit(DM_CRYPT_NO_OFFLOAD, &cc->flags);
@@ -3399,18 +3401,22 @@ static int crypt_ctr(struct dm_target *t
 	}
 
 	ret = -ENOMEM;
-	cc->io_queue = alloc_workqueue("kcryptd_io/%s", WQ_MEM_RECLAIM, 1, devname);
+	cc->io_queue = alloc_workqueue("kcryptd_io/%s", WQ_MEM_RECLAIM |
+				       test_bit(DM_CRYPT_HIGH_PRIORITY, &cc->flags) * WQ_HIGHPRI,
+				       1, devname);
 	if (!cc->io_queue) {
 		ti->error = "Couldn't create kcryptd io queue";
 		goto bad;
 	}
 
 	if (test_bit(DM_CRYPT_SAME_CPU, &cc->flags))
-		cc->crypt_queue = alloc_workqueue("kcryptd/%s", WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM,
+		cc->crypt_queue = alloc_workqueue("kcryptd/%s", WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM |
+						  test_bit(DM_CRYPT_HIGH_PRIORITY, &cc->flags) * WQ_HIGHPRI,
 						  1, devname);
 	else
 		cc->crypt_queue = alloc_workqueue("kcryptd/%s",
-						  WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM | WQ_UNBOUND,
+						  WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM | WQ_UNBOUND |
+						  test_bit(DM_CRYPT_HIGH_PRIORITY, &cc->flags) * WQ_HIGHPRI,
 						  num_online_cpus(), devname);
 	if (!cc->crypt_queue) {
 		ti->error = "Couldn't create kcryptd queue";
@@ -3427,6 +3433,8 @@ static int crypt_ctr(struct dm_target *t
 		ti->error = "Couldn't spawn write thread";
 		goto bad;
 	}
+	if (test_bit(DM_CRYPT_HIGH_PRIORITY, &cc->flags))
+		set_user_nice(cc->write_thread, MIN_NICE);
 
 	ti->num_flush_bios = 1;
 	ti->limit_swap_bios = true;
@@ -3547,6 +3555,7 @@ static void crypt_status(struct dm_targe
 
 		num_feature_args += !!ti->num_discard_bios;
 		num_feature_args += test_bit(DM_CRYPT_SAME_CPU, &cc->flags);
+		num_feature_args += test_bit(DM_CRYPT_HIGH_PRIORITY, &cc->flags);
 		num_feature_args += test_bit(DM_CRYPT_NO_OFFLOAD, &cc->flags);
 		num_feature_args += test_bit(DM_CRYPT_NO_READ_WORKQUEUE, &cc->flags);
 		num_feature_args += test_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags);
@@ -3560,6 +3569,8 @@ static void crypt_status(struct dm_targe
 				DMEMIT(" allow_discards");
 			if (test_bit(DM_CRYPT_SAME_CPU, &cc->flags))
 				DMEMIT(" same_cpu_crypt");
+			if (test_bit(DM_CRYPT_HIGH_PRIORITY, &cc->flags))
+				DMEMIT(" high_priority");
 			if (test_bit(DM_CRYPT_NO_OFFLOAD, &cc->flags))
 				DMEMIT(" submit_from_crypt_cpus");
 			if (test_bit(DM_CRYPT_NO_READ_WORKQUEUE, &cc->flags))
@@ -3579,6 +3590,7 @@ static void crypt_status(struct dm_targe
 		DMEMIT_TARGET_NAME_VERSION(ti->type);
 		DMEMIT(",allow_discards=%c", ti->num_discard_bios ? 'y' : 'n');
 		DMEMIT(",same_cpu_crypt=%c", test_bit(DM_CRYPT_SAME_CPU, &cc->flags) ? 'y' : 'n');
+		DMEMIT(",high_priority=%c", test_bit(DM_CRYPT_HIGH_PRIORITY, &cc->flags) ? 'y' : 'n');
 		DMEMIT(",submit_from_crypt_cpus=%c", test_bit(DM_CRYPT_NO_OFFLOAD, &cc->flags) ?
 		       'y' : 'n');
 		DMEMIT(",no_read_workqueue=%c", test_bit(DM_CRYPT_NO_READ_WORKQUEUE, &cc->flags) ?
@@ -3706,7 +3718,7 @@ static void crypt_io_hints(struct dm_tar
 
 static struct target_type crypt_target = {
 	.name   = "crypt",
-	.version = {1, 25, 0},
+	.version = {1, 26, 0},
 	.module = THIS_MODULE,
 	.ctr    = crypt_ctr,
 	.dtr    = crypt_dtr,
Index: linux-2.6/Documentation/admin-guide/device-mapper/dm-crypt.rst
===================================================================
--- linux-2.6.orig/Documentation/admin-guide/device-mapper/dm-crypt.rst	2024-04-08 19:54:41.000000000 +0200
+++ linux-2.6/Documentation/admin-guide/device-mapper/dm-crypt.rst	2024-04-08 19:54:41.000000000 +0200
@@ -113,6 +113,11 @@ same_cpu_crypt
     The default is to use an unbound workqueue so that encryption work
     is automatically balanced between available CPUs.
 
+high_priority
+    Set dm-crypt workqueues and the writer thread to high priority. This
+    improves throughput and latency of dm-crypt while degrading general
+    responsiveness of the system.
+
 submit_from_crypt_cpus
     Disable offloading writes to a separate thread after encryption.
     There are some situations where offloading write bios from the

