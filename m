Return-Path: <SRS0=dIwz=KR=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94A79C2B9F2
	for <dm-devel@archiver.kernel.org>; Sat, 22 May 2021 19:18:07 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1978461073
	for <dm-devel@archiver.kernel.org>; Sat, 22 May 2021 19:18:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1978461073
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-267-AHdAE9F2NgexT3dDoWMiTA-1; Sat, 22 May 2021 15:18:03 -0400
X-MC-Unique: AHdAE9F2NgexT3dDoWMiTA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C36BD107ACC7;
	Sat, 22 May 2021 19:17:57 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CBCF410023AB;
	Sat, 22 May 2021 19:17:55 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6586C1800FFC;
	Sat, 22 May 2021 19:17:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14MJHj4x002509 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 22 May 2021 15:17:45 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id F2562200E1F8; Sat, 22 May 2021 19:17:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EDF6B200E1ED
	for <dm-devel@redhat.com>; Sat, 22 May 2021 19:17:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 93FC3101A531
	for <dm-devel@redhat.com>; Sat, 22 May 2021 19:17:42 +0000 (UTC)
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com
	[209.85.128.41]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-172-ygbbjgGkMiKCTHgQLY0K-Q-1; Sat, 22 May 2021 15:17:40 -0400
X-MC-Unique: ygbbjgGkMiKCTHgQLY0K-Q-1
Received: by mail-wm1-f41.google.com with SMTP id o127so12815200wmo.4;
	Sat, 22 May 2021 12:17:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=xYl0S39e7/b4SokgKa/b+n1Z28O99ZbZlEdvU4/cZLw=;
	b=qujiMH965uQMvYjzFkg58WSZgb0RhNntlkxUoIAyEr3Zc8er09ygSSnp/VK6cu0beU
	Q4GrS+fpJa/ZIPWzH92jlV7mvXcTNzK495DOGDuZ4L18SfIgqJU/ygZM5opn4Dvc+7dw
	Un+Xrx44BUfv+Ajj0vuYtpNXFJ5jt1VGdgIedfC7o2BuoXO73MiNx7StnlszoZg/mntM
	bHCubM6fLRQ7/Ni3kg39JSmJzw4SjRRF6J9rkx0EI01VpT72YMf748vs0u/saJGx5QBZ
	d75SvLzi0TDk9UiksA6uMm4CMOrVD+swqtkWEeYVPM9mumtGAFtAgGiCMIrRO8+JX0Ay
	oOrQ==
X-Gm-Message-State: AOAM531nXrBLwAI/p7ZE8uEfpEV0IQb3kb1yJq4saOgP1WfPVJPtASzx
	jrDAQ0NX8IoyRkg6+3p+Jg==
X-Google-Smtp-Source: ABdhPJz/+K2MMycE+xtMDEoZncv+xIqwPvbMxExbHFGsTEjGvBsS/RD2x8nos/2VsmXouGv5wYxMMA==
X-Received: by 2002:a7b:cc88:: with SMTP id p8mr14428338wma.171.1621711058762; 
	Sat, 22 May 2021 12:17:38 -0700 (PDT)
Received: from localhost (117.red-83-46-157.dynamicip.rima-tde.net.
	[83.46.157.117])
	by smtp.gmail.com with ESMTPSA id 11sm3254615wmo.24.2021.05.22.12.17.38
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Sat, 22 May 2021 12:17:38 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Sat, 22 May 2021 21:17:36 +0200
Message-Id: <20210522191736.62042-1-xose.vazquez@gmail.com>
MIME-Version: 1.0
X-Patchwork-Bot: notify
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>,
	DM-DEVEL ML <dm-devel@redhat.com>
Subject: [dm-devel] [PATCH] multipath-tools: Remove trailing/leading
	whitespaces
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 Makefile.inc              | 2 +-
 libmultipath/configure.c  | 2 +-
 libmultipath/devmapper.c  | 4 ++--
 libmultipath/sysfs.c      | 2 +-
 multipath/multipath.8     | 2 +-
 multipathd/cli_handlers.c | 2 +-
 multipathd/main.c         | 2 +-
 7 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/Makefile.inc b/Makefile.inc
index 91100a20..d0ec9b44 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -101,7 +101,7 @@ OPTFLAGS	:= -O2 -g $(STACKPROT) --param=ssp-buffer-size=4
 WARNFLAGS	:= -Werror -Wall -Wextra -Wformat=2 $(WFORMATOVERFLOW) -Werror=implicit-int \
 		  -Werror=implicit-function-declaration -Werror=format-security \
 		  $(WNOCLOBBERED) -Werror=cast-qual $(ERROR_DISCARDED_QUALIFIERS)
-CPPFLAGS	:= -Wp,-D_FORTIFY_SOURCE=2 
+CPPFLAGS	:= -Wp,-D_FORTIFY_SOURCE=2
 CFLAGS		:= --std=gnu99 $(CFLAGS) $(OPTFLAGS) $(WARNFLAGS) -pipe \
 		   -DBIN_DIR=\"$(bindir)\" -DLIB_STRING=\"${LIB}\" -DRUN_DIR=\"${RUN}\" \
 		   -MMD -MP
diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 6ca1f4bb..a6ae3359 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -397,7 +397,7 @@ int setup_map(struct multipath *mpp, char *params, int params_size,
 		start_io_err_stat_thread(vecs);
 
 	n_paths = VECTOR_SIZE(mpp->paths);
-        /*
+	/*
 	 * assign paths to path groups -- start with no groups and all paths
 	 * in mpp->paths
 	 */
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 095cbc0c..98ec2a58 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -598,8 +598,8 @@ int dm_addmap_reload(struct multipath *mpp, char *params, int flush)
 		return r;
 
 	/* If the resume failed, dm will leave the device suspended, and
- 	 * drop the new table, so doing a second resume will try using
- 	 * the original table */
+	 * drop the new table, so doing a second resume will try using
+	 * the original table */
 	if (dm_is_suspended(mpp->alias))
 		dm_simplecmd(DM_DEVICE_RESUME, mpp->alias, !flush, 1,
 			     udev_flags, 0);
diff --git a/libmultipath/sysfs.c b/libmultipath/sysfs.c
index 7a2af1ea..9ff145f2 100644
--- a/libmultipath/sysfs.c
+++ b/libmultipath/sysfs.c
@@ -358,7 +358,7 @@ bool sysfs_is_multipathed(struct path *pp, bool set_wwid)
 					strchop(pp->wwid);
 				}
 			}
-                } else if (nr < 0)
+		} else if (nr < 0)
 			condlog(1, "%s: error reading from %s: %m",
 				__func__, pathbuf);
 
diff --git a/multipath/multipath.8 b/multipath/multipath.8
index 5b29a5d9..17df59f5 100644
--- a/multipath/multipath.8
+++ b/multipath/multipath.8
@@ -225,7 +225,7 @@ Dry run, do not create or update devmaps.
 .TP
 .B \-e
 Enable all foreign libraries. This overrides the
-.I enable_foreign 
+.I enable_foreign
 option from \fBmultipath.conf(5)\fR.
 .
 .TP
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 59d44b45..d70e1dbc 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -1215,7 +1215,7 @@ cli_reconfigure(void * v, char ** reply, int * len, void * data)
 
 	condlog(2, "reconfigure (operator)");
 
-	rc = set_config_state(DAEMON_CONFIGURE); 
+	rc = set_config_state(DAEMON_CONFIGURE);
 	if (rc == ETIMEDOUT) {
 		condlog(2, "timeout starting reconfiguration");
 		return 1;
diff --git a/multipathd/main.c b/multipathd/main.c
index 2251e02c..bdd629e7 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2014,7 +2014,7 @@ static int check_path_reinstate_state(struct path * pp) {
 
 		/* If path became failed again or continue failed, should reset
 		 * path san_path_err_forget_rate and path dis_reinstate_time to
-		 * start a new stable check. 
+		 * start a new stable check.
 		 */
 		if ((pp->state != PATH_UP) && (pp->state != PATH_GHOST) &&
 			(pp->state != PATH_DELAYED)) {
-- 
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

