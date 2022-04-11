Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6952DC4332F
	for <dm-devel@archiver.kernel.org>; Tue, 12 Apr 2022 07:06:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-511-ULRQ0zkAP9Sq7olo__YNhQ-1; Tue, 12 Apr 2022 03:06:18 -0400
X-MC-Unique: ULRQ0zkAP9Sq7olo__YNhQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 85995833978;
	Tue, 12 Apr 2022 07:06:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 74021416156;
	Tue, 12 Apr 2022 07:06:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 45F001940365;
	Tue, 12 Apr 2022 07:06:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5C6C71940365
 for <dm-devel@listman.corp.redhat.com>; Mon, 11 Apr 2022 22:03:52 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4B5E0C44B17; Mon, 11 Apr 2022 22:03:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 478CFC35993
 for <dm-devel@redhat.com>; Mon, 11 Apr 2022 22:03:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2D77B811E76
 for <dm-devel@redhat.com>; Mon, 11 Apr 2022 22:03:52 +0000 (UTC)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-581-IOSIw62TNOulZ1B-YZRnZQ-1; Mon, 11 Apr 2022 18:03:48 -0400
X-MC-Unique: IOSIw62TNOulZ1B-YZRnZQ-1
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-2ec08c1dd2dso42313057b3.20
 for <dm-devel@redhat.com>; Mon, 11 Apr 2022 15:03:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=l2QzeSk04rscKqYK/6Xxv0lnCMF21ToL3+36JhEqxOk=;
 b=T3DJ/0U7/HoBZfg6vMxAGlFnq6xuM+kkgicFw8+/E1x9zwxmQ6yNnkuz3lnQyeu9Vi
 oL18WN0Ti7j0nG1gsBCdHygq6ANfnN1+b2/ggXgP6aTTSMjPXOa7w3lq3k89HstHr2NX
 FHcB6L/4Mx71ngj/a6R4D79a4v9A2fT3Qf4taDY6n1QFTdza8e53186zYAWnGbvbvOiz
 m0HM9OFQW+ft69njyJq6umy1BtO1uSDdNs9LJCj/66x+6+aoeTXxaDs1mF+RthVxXC1L
 48BZmtFOICWt7FYRN/9pEqYlm30baeiLso+F2cJ1noQ0qzlH4JzebEiyxL0mfCMlOqPz
 ABwQ==
X-Gm-Message-State: AOAM530ngfM3jape3eKb7m63wJr68NUfIkECowpMv6qzb5hpHl7LqXYB
 CK6XHvCL86cK0rfWlvGdfdAPMEG1T4w=
X-Google-Smtp-Source: ABdhPJwDLlkf85gP5BXpLbyFhFWAMCG10eECpoQO3suC9ziOOLNTGKW5qLuohyOKwHOWL6ThskypAEuFd9c=
X-Received: from khazhy-linux.svl.corp.google.com
 ([2620:15c:2cd:202:9b6b:62a3:4704:a1d8])
 (user=khazhy job=sendgmr) by 2002:a25:6652:0:b0:641:25c9:9c04 with SMTP id
 z18-20020a256652000000b0064125c99c04mr8744992ybm.94.1649714627632; Mon, 11
 Apr 2022 15:03:47 -0700 (PDT)
Date: Mon, 11 Apr 2022 15:03:35 -0700
Message-Id: <20220411220335.1235363-1-khazhy@google.com>
Mime-Version: 1.0
From: Khazhismel Kumykov <khazhy@google.com>
To: Mike Snitzer <snitzer@kernel.org>, Alasdair Kergon <agk@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Mailman-Approved-At: Tue, 12 Apr 2022 07:06:10 +0000
Subject: [dm-devel] [PATCH] dm mpath: fixup sched_clock() usage in
 historical selector
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
Cc: dm-devel@redhat.com, Gabriel Krisman Bertazi <krisman@collabora.com>,
 linux-kernel@vger.kernel.org, Khazhismel Kumykov <khazhy@google.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

mixing sched_clock() and ktime_get_ns() will give bad results, don't do
it

Fixes: 2613eab11996 ("dm mpath: add Historical Service Time Path Selector")
Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
---
 drivers/md/dm-ps-historical-service-time.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-ps-historical-service-time.c b/drivers/md/dm-ps-historical-service-time.c
index 875bca30a0dd..82f2a06153dc 100644
--- a/drivers/md/dm-ps-historical-service-time.c
+++ b/drivers/md/dm-ps-historical-service-time.c
@@ -27,7 +27,6 @@
 #include <linux/blkdev.h>
 #include <linux/slab.h>
 #include <linux/module.h>
-#include <linux/sched/clock.h>
 
 
 #define DM_MSG_PREFIX	"multipath historical-service-time"
@@ -433,7 +432,7 @@ static struct dm_path *hst_select_path(struct path_selector *ps,
 {
 	struct selector *s = ps->context;
 	struct path_info *pi = NULL, *best = NULL;
-	u64 time_now = sched_clock();
+	u64 time_now = ktime_get_ns();
 	struct dm_path *ret = NULL;
 	unsigned long flags;
 
@@ -474,7 +473,7 @@ static int hst_start_io(struct path_selector *ps, struct dm_path *path,
 
 static u64 path_service_time(struct path_info *pi, u64 start_time)
 {
-	u64 sched_now = ktime_get_ns();
+	u64 now = ktime_get_ns();
 
 	/* if a previous disk request has finished after this IO was
 	 * sent to the hardware, pretend the submission happened
@@ -483,11 +482,11 @@ static u64 path_service_time(struct path_info *pi, u64 start_time)
 	if (time_after64(pi->last_finish, start_time))
 		start_time = pi->last_finish;
 
-	pi->last_finish = sched_now;
-	if (time_before64(sched_now, start_time))
+	pi->last_finish = now;
+	if (time_before64(now, start_time))
 		return 0;
 
-	return sched_now - start_time;
+	return now - start_time;
 }
 
 static int hst_end_io(struct path_selector *ps, struct dm_path *path,
-- 
2.35.1.1178.g4f1659d476-goog

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

