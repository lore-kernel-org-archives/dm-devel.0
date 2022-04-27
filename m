Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A874C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 27 Apr 2022 16:57:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-130-nK4XQUPMOPa7WGAjd_Ax1Q-1; Wed, 27 Apr 2022 12:57:33 -0400
X-MC-Unique: nK4XQUPMOPa7WGAjd_Ax1Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A1812185A79C;
	Wed, 27 Apr 2022 16:57:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 24147407E1C0;
	Wed, 27 Apr 2022 16:57:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CE7BC1947042;
	Wed, 27 Apr 2022 16:57:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 735821947041
 for <dm-devel@listman.corp.redhat.com>; Wed, 27 Apr 2022 16:57:28 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 42236C28137; Wed, 27 Apr 2022 16:57:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3E178C28135
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 16:57:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0D86B3C02B6B
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 16:57:28 +0000 (UTC)
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk
 [46.235.227.227]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-591-rfaC8-ZSM-yNcZ2FdbN1Fg-1; Wed, 27 Apr 2022 12:57:26 -0400
X-MC-Unique: rfaC8-ZSM-yNcZ2FdbN1Fg-1
Received: from localhost (unknown [IPv6:2a00:5f00:102:0:8862:e6ff:fea2:2548])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 (Authenticated sender: krisman)
 by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 1DB6E1F44B6F;
 Wed, 27 Apr 2022 17:57:24 +0100 (BST)
From: Gabriel Krisman Bertazi <krisman@collabora.com>
To: snitzer@redhat.com
Date: Wed, 27 Apr 2022 12:57:10 -0400
Message-Id: <20220427165710.225808-1-krisman@collabora.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: [dm-devel] [PATCH] dm: dm-mpath: Provide high-resolution timer to
 HST with bio-mpath
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
Cc: dm-devel@redhat.com, kernel@collabora.com,
 Gabriel Krisman Bertazi <krisman@collabora.com>, khazhy@google.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The precision loss of reading IO start_time with jiffies_to_nsecs
instead of using a high resolution timer degrades HST path prediction
for BIO-based mpath on high load workloads.

Below, I show the utilization percentage of a 10 disk multipath with
asymmetrical disk access cost, while being exercised by a randwrite FIO
benchmark with high submission queue depth (depth=64).  It is possible
to see that the HST path selection degrades heavily for high-iops in
BIO-mpath, underutilizing the slower paths way beyond expected.  This
seems to be caused by the start_time truncation, which makes some IO to
seem much slower than they actually is.  In this scenario ST outperforms
HST for bio-mpath, but not for mq-mpath, which already uses ktime_get_ns().

The third column shows utilization with this patch applied.  It is easy
to see that now HST prediction is much closer to the ideal distribution
(calculated considering the real cost of each path).

|     |   ST | HST (orig) | HST(ktime) | Best |
| sdd | 0.17 |       0.20 |       0.17 | 0.18 |
| sde | 0.17 |       0.20 |       0.17 | 0.18 |
| sdf | 0.17 |       0.20 |       0.17 | 0.18 |
| sdg | 0.06 |       0.00 |       0.06 | 0.04 |
| sdh | 0.03 |       0.00 |       0.03 | 0.02 |
| sdi | 0.03 |       0.00 |       0.03 | 0.02 |
| sdj | 0.02 |       0.00 |       0.01 | 0.01 |
| sdk | 0.02 |       0.00 |       0.01 | 0.01 |
| sdl | 0.17 |       0.20 |       0.17 | 0.18 |
| sdm | 0.17 |       0.20 |       0.17 | 0.18 |

This issue was originally discussed [1] when we first merged HST, and
this patch was left as a low hanging fruit to be solved later.  I don't
think anyone is using HST with BIO mpath, but it'd be neat to get it
sorted out.

Regarding the implementation, as suggested by Mike in that mail thread,
in order to avoid the overhead of ktime_get_ns for other selectors, this
patch adds a flag for the selector code to request the high-resolution
timer.

I tested this using the same benchmark used in the original HST submission.

Full test and benchmark scripts are available here:

  https://people.collabora.com/~krisman/HST-BIO-MPATH/

[1] https://lore.kernel.org/lkml/85tv0am9de.fsf@collabora.com/T/

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Acked-by: Gabriel Krisman Bertazi <krisman@collabora.com>
---
 drivers/md/dm-mpath.c                      | 16 ++++++++++++++--
 drivers/md/dm-path-selector.h              | 13 +++++++++++++
 drivers/md/dm-ps-historical-service-time.c |  1 +
 3 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index f4719b65e5e3..c58cfcd87d04 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -105,6 +105,7 @@ struct multipath {
 struct dm_mpath_io {
 	struct pgpath *pgpath;
 	size_t nr_bytes;
+	u64 start_time_ns;
 };
 
 typedef int (*action_fn) (struct pgpath *pgpath);
@@ -647,6 +648,11 @@ static int __multipath_map_bio(struct multipath *m, struct bio *bio,
 
 	mpio->pgpath = pgpath;
 
+	if (pgpath->pg->ps.type->flags & PS_NEED_HR_TIMER_FL)
+		mpio->start_time_ns = ktime_get_ns();
+	else
+		mpio->start_time_ns = 0;
+
 	bio->bi_status = 0;
 	bio_set_dev(bio, pgpath->path.dev->bdev);
 	bio->bi_opf |= REQ_FAILFAST_TRANSPORT;
@@ -1715,9 +1721,15 @@ static int multipath_end_io_bio(struct dm_target *ti, struct bio *clone,
 	if (pgpath) {
 		struct path_selector *ps = &pgpath->pg->ps;
 
-		if (ps->type->end_io)
+		if (ps->type->end_io) {
+			u64 st_time = mpio->start_time_ns;
+
+			if (!st_time)
+				st_time = dm_start_time_ns_from_clone(clone);
+
 			ps->type->end_io(ps, &pgpath->path, mpio->nr_bytes,
-					 dm_start_time_ns_from_clone(clone));
+					 st_time);
+		}
 	}
 
 	return r;
diff --git a/drivers/md/dm-path-selector.h b/drivers/md/dm-path-selector.h
index c47bc0e20275..46710f364286 100644
--- a/drivers/md/dm-path-selector.h
+++ b/drivers/md/dm-path-selector.h
@@ -26,6 +26,18 @@ struct path_selector {
 	void *context;
 };
 
+/* If a path selector uses this flag, a more precise timer
+ * (ktime_get_ns) is used to account for IO start time in BIO-based
+ * mpath.  This improves performance of some path selectors (i.e. HST),
+ * in exchange of a slightly higher overhead when submiting the
+ * BIO. The extra cost is usually offset by improved path selection for
+ * some benchmarks.
+ *
+ * This has no effect for request-based mpath, since it already uses a
+ * higher precision timer by default.
+ */
+#define PS_NEED_HR_TIMER_FL 0x1
+
 /* Information about a path selector type */
 struct path_selector_type {
 	char *name;
@@ -33,6 +45,7 @@ struct path_selector_type {
 
 	unsigned int table_args;
 	unsigned int info_args;
+	unsigned int flags;
 
 	/*
 	 * Constructs a path selector object, takes custom arguments
diff --git a/drivers/md/dm-ps-historical-service-time.c b/drivers/md/dm-ps-historical-service-time.c
index 82f2a06153dc..d2233cc4ea97 100644
--- a/drivers/md/dm-ps-historical-service-time.c
+++ b/drivers/md/dm-ps-historical-service-time.c
@@ -523,6 +523,7 @@ static int hst_end_io(struct path_selector *ps, struct dm_path *path,
 static struct path_selector_type hst_ps = {
 	.name		= "historical-service-time",
 	.module		= THIS_MODULE,
+	.flags		= PS_NEED_HR_TIMER_FL,
 	.table_args	= 1,
 	.info_args	= 3,
 	.create		= hst_create,
-- 
2.35.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

