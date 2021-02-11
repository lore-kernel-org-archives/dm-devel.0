Return-Path: <SRS0=OsX1=HN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA5FDC433E0
	for <dm-devel@archiver.kernel.org>; Thu, 11 Feb 2021 23:47:25 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 75AC664E45
	for <dm-devel@archiver.kernel.org>; Thu, 11 Feb 2021 23:47:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 75AC664E45
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-34-InIHLDcFPUeLiKwChBjJ2Q-1; Thu, 11 Feb 2021 18:47:22 -0500
X-MC-Unique: InIHLDcFPUeLiKwChBjJ2Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F2CCE192CC47;
	Thu, 11 Feb 2021 23:47:17 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D3CE52BFEC;
	Thu, 11 Feb 2021 23:47:17 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A93BF4EE4D;
	Thu, 11 Feb 2021 23:47:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11BNl4Pu010515 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 11 Feb 2021 18:47:04 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 945CA200E1F1; Thu, 11 Feb 2021 23:47:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8F8D6200E1F0
	for <dm-devel@redhat.com>; Thu, 11 Feb 2021 23:47:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8F94080122F
	for <dm-devel@redhat.com>; Thu, 11 Feb 2021 23:47:01 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-154-zVX6XeYvObWdlslL4haRUA-1;
	Thu, 11 Feb 2021 18:46:58 -0500
X-MC-Unique: zVX6XeYvObWdlslL4haRUA-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 8D814AD29;
	Thu, 11 Feb 2021 23:46:57 +0000 (UTC)
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 12 Feb 2021 00:46:49 +0100
Message-Id: <20210211234650.21890-3-mwilck@suse.com>
In-Reply-To: <20210211234650.21890-1-mwilck@suse.com>
References: <20210211234650.21890-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 11BNl4Pu010515
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 3/4] multipath-tools: fix compilation errors on
	32-bit musl
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

gcc on alpine Linux/i386 throws errors because the "tv_sec" element
of struct timespec is a time_t, which is a "long long" in that
environment. In general, time_t is signed. As we only use CLOCK_MONOTONIC,
which starts at boot time, a cast to long should be no problem, even
in 32bit environments.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/main.c    |  2 +-
 multipathd/main.c   | 16 ++++++++--------
 multipathd/uxlsnr.c |  4 ++--
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/multipath/main.c b/multipath/main.c
index 9ac4286..3f97582 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -417,7 +417,7 @@ static int print_cmd_valid(int k, const vector pathvec,
 		wait = find_multipaths_check_timeout(pp, 0, &until);
 	if (wait == FIND_MULTIPATHS_WAITING)
 		printf("FIND_MULTIPATHS_WAIT_UNTIL=\"%ld.%06ld\"\n",
-			       until.tv_sec, until.tv_nsec/1000);
+		       (long)until.tv_sec, until.tv_nsec/1000);
 	else if (wait == FIND_MULTIPATHS_WAIT_DONE)
 		printf("FIND_MULTIPATHS_WAIT_UNTIL=\"0\"\n");
 	printf("DM_MULTIPATH_DEVICE_PATH=\"%d\"\n",
diff --git a/multipathd/main.c b/multipathd/main.c
index 1967984..5316643 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2408,8 +2408,8 @@ checkerloop (void *ap)
 		get_monotonic_time(&start_time);
 		if (start_time.tv_sec && last_time.tv_sec) {
 			timespecsub(&start_time, &last_time, &diff_time);
-			condlog(4, "tick (%lu.%06lu secs)",
-				diff_time.tv_sec, diff_time.tv_nsec / 1000);
+			condlog(4, "tick (%ld.%06lu secs)",
+				(long)diff_time.tv_sec, diff_time.tv_nsec / 1000);
 			last_time = start_time;
 			ticks = diff_time.tv_sec;
 		} else {
@@ -2470,18 +2470,18 @@ checkerloop (void *ap)
 			if (num_paths) {
 				unsigned int max_checkint;
 
-				condlog(4, "checked %d path%s in %lu.%06lu secs",
+				condlog(4, "checked %d path%s in %ld.%06lu secs",
 					num_paths, num_paths > 1 ? "s" : "",
-					diff_time.tv_sec,
+					(long)diff_time.tv_sec,
 					diff_time.tv_nsec / 1000);
 				conf = get_multipath_config();
 				max_checkint = conf->max_checkint;
 				put_multipath_config(conf);
 				if (diff_time.tv_sec > (time_t)max_checkint)
 					condlog(1, "path checkers took longer "
-						"than %lu seconds, consider "
+						"than %ld seconds, consider "
 						"increasing max_polling_interval",
-						diff_time.tv_sec);
+						(long)diff_time.tv_sec);
 			}
 		}
 
@@ -2507,8 +2507,8 @@ checkerloop (void *ap)
 			} else
 				diff_time.tv_sec = 1;
 
-			condlog(3, "waiting for %lu.%06lu secs",
-				diff_time.tv_sec,
+			condlog(3, "waiting for %ld.%06lu secs",
+				(long)diff_time.tv_sec,
 				diff_time.tv_nsec / 1000);
 			if (nanosleep(&diff_time, NULL) != 0) {
 				condlog(3, "nanosleep failed with error %d",
diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index cd462b6..dbee0d6 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -154,8 +154,8 @@ static void check_timeout(struct timespec start_time, char *inbuf,
 			diff_time.tv_nsec / (1000 * 1000);
 		if (msecs > timeout)
 			condlog(2, "cli cmd '%s' timeout reached "
-				"after %lu.%06lu secs", inbuf,
-				diff_time.tv_sec, diff_time.tv_nsec / 1000);
+				"after %ld.%06lu secs", inbuf,
+				(long)diff_time.tv_sec, diff_time.tv_nsec / 1000);
 	}
 }
 
-- 
2.29.2


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

