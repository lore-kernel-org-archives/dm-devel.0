Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 621D2C61DA4
	for <dm-devel@archiver.kernel.org>; Mon,  6 Mar 2023 19:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678129363;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=P6YEzoQIzYOeetJT+rAB5dOkqBkPf3BZVaZBPp30z9M=;
	b=UsJEEjGpb2Bc9W4HI/cJAx0RoVW6YHHsODdPVLR6tr4ZdUHz/k7aS4a5Zc48/lz0RSAp3c
	aiP+W6bacawtUAwFetT5WkR9G1l/Mo6w9J6fRR0Pir3ckD3/Bp7iylpgVXGXQ4T6vBIWCZ
	S4t7mKeWOhBzsrqgqO1Lw2sVQKvhbFE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-632-UIp3lafGOMqMD0gJQvcynQ-1; Mon, 06 Mar 2023 14:02:39 -0500
X-MC-Unique: UIp3lafGOMqMD0gJQvcynQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 293FA100F908;
	Mon,  6 Mar 2023 19:01:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 234C1175AD;
	Mon,  6 Mar 2023 19:01:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 11DE3194658C;
	Mon,  6 Mar 2023 19:01:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 246B21946589
 for <dm-devel@listman.corp.redhat.com>; Mon,  6 Mar 2023 19:01:53 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 14918403570E; Mon,  6 Mar 2023 19:01:53 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BC38640C83B6;
 Mon,  6 Mar 2023 19:01:52 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 326J1qbn005498; Mon, 6 Mar 2023 14:01:52 -0500
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 326J1q36005494; Mon, 6 Mar 2023 14:01:52 -0500
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Mon, 6 Mar 2023 14:01:52 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: yangerkun <yangerkun@huaweicloud.com>
Message-ID: <alpine.LRH.2.21.2303061353300.3482@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: [dm-devel] [PATCH] dm-crypt: add the "high_priority" flag
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: Bart Van Assche <bvanassche@acm.org>, yangerkun@huawei.com,
 Mike Snitzer <snitzer@kernel.org>, dm-devel@redhat.com,
 Milan Broz <gmazyland@gmail.com>, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On Mon, 6 Mar 2023, Mikulas Patocka wrote:

> > Hi,
> > 
> > Thanks a lot for your review!
> > 
> > It's ok to fix the softlockup, but for async write encrypt, 
> > kcryptd_crypt_write_io_submit will add bio to write_tree, and once we 
> > call cond_resched before every kcryptd_io_write, the write performance 
> > may be poor while we meet a high cpu usage scene.
> 
> Hi
> 
> To fix this problem, find the PID of the process "dmcrypt_write" and 
> change its priority to -20, for example "renice -n -20 -p 34748".
> 
> This is the proper way how to fix it; locking up the process for one 
> second is not.
> 
> We used to have high-priority workqueues by default, but it caused audio 
> playback skipping, so we had to revert it - see 
> f612b2132db529feac4f965f28a1b9258ea7c22b.
> 
> Perhaps we should add an option to have high-priority kernel threads?
> 
> Mikulas

Here I'm sending a patch that makes it optional to raise the priority 
of dm-crypt workqueues and the write thread. Test it, if it helps for you.

Mikulas



From: Mikulas Patocka <mpatocka@redhat.com>

It was reported that dm-crypt performs badly when the system is loaded[1]. 
So I'm adding an option "high_priority" that sets the workqueues and the 
write_thread to nice level -20. This used to be the default in the past, 
but it caused audio skipping, so it had to be reverted - see the commit 
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
--- linux-2.6.orig/drivers/md/dm-crypt.c
+++ linux-2.6/drivers/md/dm-crypt.c
@@ -133,9 +133,9 @@ struct iv_elephant_private {
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
@@ -3087,7 +3087,7 @@ static int crypt_ctr_optional(struct dm_
 	struct crypt_config *cc = ti->private;
 	struct dm_arg_set as;
 	static const struct dm_arg _args[] = {
-		{0, 8, "Invalid number of feature args"},
+		{0, 9, "Invalid number of feature args"},
 	};
 	unsigned int opt_params, val;
 	const char *opt_string, *sval;
@@ -3114,6 +3114,8 @@ static int crypt_ctr_optional(struct dm_
 
 		else if (!strcasecmp(opt_string, "same_cpu_crypt"))
 			set_bit(DM_CRYPT_SAME_CPU, &cc->flags);
+		else if (!strcasecmp(opt_string, "high_priority"))
+			set_bit(DM_CRYPT_HIGH_PRIORITY, &cc->flags);
 
 		else if (!strcasecmp(opt_string, "submit_from_crypt_cpus"))
 			set_bit(DM_CRYPT_NO_OFFLOAD, &cc->flags);
@@ -3352,18 +3354,22 @@ static int crypt_ctr(struct dm_target *t
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
@@ -3380,6 +3386,8 @@ static int crypt_ctr(struct dm_target *t
 		ti->error = "Couldn't spawn write thread";
 		goto bad;
 	}
+	if (test_bit(DM_CRYPT_HIGH_PRIORITY, &cc->flags))
+		set_user_nice(cc->write_thread, MIN_NICE);
 
 	ti->num_flush_bios = 1;
 	ti->limit_swap_bios = true;
@@ -3500,6 +3508,7 @@ static void crypt_status(struct dm_targe
 
 		num_feature_args += !!ti->num_discard_bios;
 		num_feature_args += test_bit(DM_CRYPT_SAME_CPU, &cc->flags);
+		num_feature_args += test_bit(DM_CRYPT_HIGH_PRIORITY, &cc->flags);
 		num_feature_args += test_bit(DM_CRYPT_NO_OFFLOAD, &cc->flags);
 		num_feature_args += test_bit(DM_CRYPT_NO_READ_WORKQUEUE, &cc->flags);
 		num_feature_args += test_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags);
@@ -3513,6 +3522,8 @@ static void crypt_status(struct dm_targe
 				DMEMIT(" allow_discards");
 			if (test_bit(DM_CRYPT_SAME_CPU, &cc->flags))
 				DMEMIT(" same_cpu_crypt");
+			if (test_bit(DM_CRYPT_HIGH_PRIORITY, &cc->flags))
+				DMEMIT(" high_priority");
 			if (test_bit(DM_CRYPT_NO_OFFLOAD, &cc->flags))
 				DMEMIT(" submit_from_crypt_cpus");
 			if (test_bit(DM_CRYPT_NO_READ_WORKQUEUE, &cc->flags))
@@ -3532,6 +3543,7 @@ static void crypt_status(struct dm_targe
 		DMEMIT_TARGET_NAME_VERSION(ti->type);
 		DMEMIT(",allow_discards=%c", ti->num_discard_bios ? 'y' : 'n');
 		DMEMIT(",same_cpu_crypt=%c", test_bit(DM_CRYPT_SAME_CPU, &cc->flags) ? 'y' : 'n');
+		DMEMIT(",high_priority=%c", test_bit(DM_CRYPT_HIGH_PRIORITY, &cc->flags) ? 'y' : 'n');
 		DMEMIT(",submit_from_crypt_cpus=%c", test_bit(DM_CRYPT_NO_OFFLOAD, &cc->flags) ?
 		       'y' : 'n');
 		DMEMIT(",no_read_workqueue=%c", test_bit(DM_CRYPT_NO_READ_WORKQUEUE, &cc->flags) ?
@@ -3659,7 +3671,7 @@ static void crypt_io_hints(struct dm_tar
 
 static struct target_type crypt_target = {
 	.name   = "crypt",
-	.version = {1, 24, 0},
+	.version = {1, 25, 0},
 	.module = THIS_MODULE,
 	.ctr    = crypt_ctr,
 	.dtr    = crypt_dtr,
Index: linux-2.6/Documentation/admin-guide/device-mapper/dm-crypt.rst
===================================================================
--- linux-2.6.orig/Documentation/admin-guide/device-mapper/dm-crypt.rst
+++ linux-2.6/Documentation/admin-guide/device-mapper/dm-crypt.rst
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
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

