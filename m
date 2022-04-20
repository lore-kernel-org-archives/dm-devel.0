Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D53A6C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 20 Apr 2022 06:47:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-218-r4u6hNSsPR2oH4nqclg9rg-1; Wed, 20 Apr 2022 02:46:58 -0400
X-MC-Unique: r4u6hNSsPR2oH4nqclg9rg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0A1583C172C6;
	Wed, 20 Apr 2022 06:46:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EC2572166BB3;
	Wed, 20 Apr 2022 06:46:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 899FA19451F2;
	Wed, 20 Apr 2022 06:46:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 312F719452D2
 for <dm-devel@listman.corp.redhat.com>; Wed, 20 Apr 2022 05:12:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1040A145B967; Wed, 20 Apr 2022 05:12:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0C402145B966
 for <dm-devel@redhat.com>; Wed, 20 Apr 2022 05:12:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DE061801E67
 for <dm-devel@redhat.com>; Wed, 20 Apr 2022 05:12:39 +0000 (UTC)
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-668-8wcmZXGLM0qmfC_c8MmhYg-1; Wed, 20 Apr 2022 01:12:35 -0400
X-MC-Unique: 8wcmZXGLM0qmfC_c8MmhYg-1
Received: from fsav119.sakura.ne.jp (fsav119.sakura.ne.jp [27.133.134.246])
 by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 23K5CSXo057057;
 Wed, 20 Apr 2022 14:12:28 +0900 (JST)
 (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav119.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav119.sakura.ne.jp);
 Wed, 20 Apr 2022 14:12:28 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav119.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
 (authenticated bits=0)
 by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 23K5CSju057052
 (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
 Wed, 20 Apr 2022 14:12:28 +0900 (JST)
 (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <e3ac2722-01c4-decb-2b79-bfd1b6c2b782@I-love.SAKURA.ne.jp>
Date: Wed, 20 Apr 2022 14:12:26 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Mimecast-Spam-Signature: yes
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Mailman-Approved-At: Wed, 20 Apr 2022 06:46:52 +0000
Subject: [dm-devel] [PATCH] dm: Avoid flush_scheduled_work() usage
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
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Flushing system-wide workqueues is dangerous and will be forbidden.
Remove flush_scheduled_work() from local_init() in dm.c and instead
use local workqueue to dm-mpath.c, dm-raid1.c, dm-stripe.c.

Link: https://lkml.kernel.org/r/49925af7-78a8-a3dd-bce6-cfc02e1a9236@I-love.SAKURA.ne.jp
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
Note: This patch was made blindly and completely untested. Maybe simply
removing flush_scheduled_work() from local_init() is sufficient. But I
don't know dependency across all files. Therefore, please carefully check
which schedule_work() needs to be converted to queue_work().

As far as I can see, dm-stripe.c which contains dm_stripe_exit() which is
called via _exits[] before local_exit() calls flush_scheduled_work() is
the only file which calls schedule_work(). Therefore, I used dm_stripe_wq
for dm-stripe.c.

Since I don't know dependency, and dm-raid1.c and dm-mpath.c are also calling
schedule_work(), I used dm_raid1_wq and dm_mpath_wq. But these changes might be
unnecessary because of not calling flush_scheduled_work().

 drivers/md/dm-mpath.c  | 17 +++++++++++++----
 drivers/md/dm-raid1.c  | 14 +++++++++++---
 drivers/md/dm-stripe.c | 12 ++++++++++--
 drivers/md/dm.c        |  1 -
 4 files changed, 34 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 6ed9d2731254..9b592ff2e387 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -27,6 +27,8 @@
 #include <linux/atomic.h>
 #include <linux/blk-mq.h>
 
+static struct workqueue_struct *dm_mpath_wq;
+
 #define DM_MSG_PREFIX "multipath"
 #define DM_PG_INIT_DELAY_MSECS 2000
 #define DM_PG_INIT_DELAY_DEFAULT ((unsigned) -1)
@@ -1342,7 +1344,7 @@ static int fail_path(struct pgpath *pgpath)
 	dm_path_uevent(DM_UEVENT_PATH_FAILED, m->ti,
 		       pgpath->path.dev->name, atomic_read(&m->nr_valid_paths));
 
-	schedule_work(&m->trigger_event);
+	queue_work(dm_mpath_wq, &m->trigger_event);
 
 	enable_nopath_timeout(m);
 
@@ -2190,12 +2192,11 @@ static struct target_type multipath_target = {
 
 static int __init dm_multipath_init(void)
 {
-	int r;
+	int r = -ENOMEM;
 
 	kmultipathd = alloc_workqueue("kmpathd", WQ_MEM_RECLAIM, 0);
 	if (!kmultipathd) {
 		DMERR("failed to create workqueue kmpathd");
-		r = -ENOMEM;
 		goto bad_alloc_kmultipathd;
 	}
 
@@ -2209,10 +2210,15 @@ static int __init dm_multipath_init(void)
 						  WQ_MEM_RECLAIM);
 	if (!kmpath_handlerd) {
 		DMERR("failed to create workqueue kmpath_handlerd");
-		r = -ENOMEM;
 		goto bad_alloc_kmpath_handlerd;
 	}
 
+	dm_mpath_wq = alloc_workqueue("dm_mpath_wq", 0, 0);
+	if (!dm_mpath_wq) {
+		DMERR("failed to create workqueue dm_mpath_wq");
+		goto bad_alloc_dm_mpath_wq;
+	}
+
 	r = dm_register_target(&multipath_target);
 	if (r < 0) {
 		DMERR("request-based register failed %d", r);
@@ -2223,6 +2229,8 @@ static int __init dm_multipath_init(void)
 	return 0;
 
 bad_register_target:
+	destroy_workqueue(dm_mpath_wq);
+bad_alloc_dm_mpath_wq:
 	destroy_workqueue(kmpath_handlerd);
 bad_alloc_kmpath_handlerd:
 	destroy_workqueue(kmultipathd);
@@ -2232,6 +2240,7 @@ static int __init dm_multipath_init(void)
 
 static void __exit dm_multipath_exit(void)
 {
+	destroy_workqueue(dm_mpath_wq);
 	destroy_workqueue(kmpath_handlerd);
 	destroy_workqueue(kmultipathd);
 
diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index 8811d484fdd1..df630d7f2b9b 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -19,6 +19,8 @@
 #include <linux/dm-kcopyd.h>
 #include <linux/dm-region-hash.h>
 
+static struct workqueue_struct *dm_raid1_wq;
+
 #define DM_MSG_PREFIX "raid1"
 
 #define MAX_RECOVERY 1	/* Maximum number of regions recovered in parallel. */
@@ -248,7 +250,7 @@ static void fail_mirror(struct mirror *m, enum dm_raid1_error error_type)
 		DMWARN("All sides of mirror have failed.");
 
 out:
-	schedule_work(&ms->trigger_event);
+	queue_work(dm_raid1_wq, &ms->trigger_event);
 }
 
 static int mirror_flush(struct dm_target *ti)
@@ -1486,22 +1488,28 @@ static struct target_type mirror_target = {
 
 static int __init dm_mirror_init(void)
 {
-	int r;
+	int r = -ENOMEM;
+
+	dm_raid1_wq = alloc_workqueue("dm_raid1_wq", 0, 0);
+	if (!dm_raid1_wq)
+		goto bad_target;
 
 	r = dm_register_target(&mirror_target);
 	if (r < 0) {
-		DMERR("Failed to register mirror target");
+		destroy_workqueue(dm_raid1_wq);
 		goto bad_target;
 	}
 
 	return 0;
 
 bad_target:
+	DMERR("Failed to register mirror target");
 	return r;
 }
 
 static void __exit dm_mirror_exit(void)
 {
+	destroy_workqueue(dm_raid1_wq);
 	dm_unregister_target(&mirror_target);
 }
 
diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index c81d331d1afe..e44d3c98568d 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -15,6 +15,8 @@
 #include <linux/slab.h>
 #include <linux/log2.h>
 
+static struct workqueue_struct *dm_stripe_wq;
+
 #define DM_MSG_PREFIX "striped"
 #define DM_IO_ERROR_THRESHOLD 15
 
@@ -423,7 +425,7 @@ static int stripe_end_io(struct dm_target *ti, struct bio *bio,
 			atomic_inc(&(sc->stripe[i].error_count));
 			if (atomic_read(&(sc->stripe[i].error_count)) <
 			    DM_IO_ERROR_THRESHOLD)
-				schedule_work(&sc->trigger_event);
+				queue_work(dm_stripe_wq, &sc->trigger_event);
 		}
 
 	return DM_ENDIO_DONE;
@@ -475,9 +477,14 @@ int __init dm_stripe_init(void)
 {
 	int r;
 
+	dm_stripe_wq = alloc_workqueue("dm_stripe_wq", 0, 0);
+	if (!dm_stripe_wq)
+		return -ENOMEM;
 	r = dm_register_target(&stripe_target);
-	if (r < 0)
+	if (r < 0) {
+		destroy_workqueue(dm_stripe_wq);
 		DMWARN("target registration failed");
+	}
 
 	return r;
 }
@@ -485,4 +492,5 @@ int __init dm_stripe_init(void)
 void dm_stripe_exit(void)
 {
 	dm_unregister_target(&stripe_target);
+	destroy_workqueue(dm_stripe_wq);
 }
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 7e3b5bdcf520..ed0f7aa82b35 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -243,7 +243,6 @@ static int __init local_init(void)
 
 static void local_exit(void)
 {
-	flush_scheduled_work();
 	destroy_workqueue(deferred_remove_workqueue);
 
 	unregister_blkdev(_major, _name);
-- 
2.32.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

