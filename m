Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2BF2757F6
	for <dm-devel@lists.linux.dev>; Tue,  9 Apr 2024 22:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712703379; cv=none; b=NMTYI8+axa0u+AuR56S9fuddyqWetIcsayIwZjs0l0J4SDlHM+2TFKRugjg0725EVjiGJ5GlAHiVky5/iNzKu4Geuc01ZWVZGjVVLJCrKozLLZTx3V815rWWOTuF+e9u0Ehrbg0nGUgFfR8rTpgzDf3pU8pMNXrLE2gE6zmCfGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712703379; c=relaxed/simple;
	bh=cfrCV7iE8OrsDrDDGg2BEWyxy1xmdMpFE/pxvE+jtew=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Rtu4its4qhNKISbzTopoiPk9JCiG7d8hO0jx1m4lkPH7oZ8yKAbU3sA6GpOi2OPU8zsj9GSi7kWyf9wZi8VadSlsuHq6UT3AZCX6MrRRrokQwFo6JI0TSYy40tkdLxuqryY1v4PdQGLeQVgn9YiRxQQL1O1bwrxZcr4j83rCCQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AvCNXBMB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AvCNXBMB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712703376;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=UnpeBCCJEzPJ4O5YTja9ix3fPrS0P2S/BtNjy3OImXc=;
	b=AvCNXBMByJeHxDcROuPtbXebB9MBwL82nkKElTW5vLthhnjQc3Y60BXX9nIm9Qof/9TG0L
	7KxtRmlbcseeVpDTL1MIcWUgN2SD09UyMMRNVU3ou0QshZj4BkLwMpG50KZ5HtHhlzhOAA
	/Np/nwlmPx4ODk5tbAOxZRTodS1E5/k=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-328-wiIjb3kgN42e5vcnfeLO4A-1; Tue, 09 Apr 2024 18:56:13 -0400
X-MC-Unique: wiIjb3kgN42e5vcnfeLO4A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C5BCB1044579;
	Tue,  9 Apr 2024 22:56:12 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BBBAB1C06666;
	Tue,  9 Apr 2024 22:56:12 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 439MuCRq1837914
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 9 Apr 2024 18:56:12 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 439MuCG51837913;
	Tue, 9 Apr 2024 18:56:12 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2] multipathd: make multipathd set priority to RLIMIT_RTPRIO
Date: Tue,  9 Apr 2024 18:56:12 -0400
Message-ID: <20240409225612.1837905-1-bmarzins@redhat.com>
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

With this change, if the SCHED_RT_PRIO compiler flag has been removed.
Instead multipathd will call getrlimit(RLIMIT_RTPRIO, ...) and look at
the hard limit. It it's 0, multipath will do nothing. Otherwise it will
change its scheduling policy to SCHED_RR and its priority to the hard
limit.

This allows users to change the priority of that multipathd runs with by
adding

LimitRTPRIO=<prio>

to the [Service] section of the multipathd.service unit file. Setting
LimitRTPRIO=0 will make multipathd run as a normal process, while
setting LimitRTPRIO=infinity will make it use the maximum SCHED_RR prio,
which is 99.

To keep the existing behavior, multipathd.service now sets
LimitRTPRIO=infinity

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---

Notes:
    v2: Removed SCHED_RT_PRIO compiler flag at Martin Wilck's suggestion.
        Added LimitRTPRIO=infinity to multipathd.service

 Makefile.inc                     |  6 ------
 README.md                        |  3 ---
 multipathd/Makefile              |  3 ---
 multipathd/main.c                | 22 +++++++++++++++-------
 multipathd/multipathd.service.in |  1 +
 5 files changed, 16 insertions(+), 19 deletions(-)

diff --git a/Makefile.inc b/Makefile.inc
index 6d206281..5668e638 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -18,12 +18,6 @@ READLINE :=
 # SCSI_DH_MODULES_PRELOAD := scsi_dh_alua scsi_dh_rdac
 SCSI_DH_MODULES_PRELOAD :=
 
-# Multipathd scheduling priority. Set value from 1 to 99 to make multipathd
-# change its scheduling policy to SCHED_RR and its priority to the specified
-# value. set to 0 to stop multipathd from changing the scheduling policy and
-# priority it was started with.
-SCHED_RT_PRIO := 99
-
 EXTRAVERSION := $(shell rev=$$(git rev-parse --short=7 HEAD 2>/dev/null); echo $${rev:+-g$$rev})
 
 # PKG_CONFIG must be read from the environment to enable compilation
diff --git a/README.md b/README.md
index bb41bf0e..d4f35f57 100644
--- a/README.md
+++ b/README.md
@@ -98,9 +98,6 @@ The following variables can be passed to the `make` command line:
     By default, command line editing is disabled.
     Note that using libreadline may
     [make binary indistributable due to license incompatibility](https://github.com/opensvc/multipath-tools/issues/36).
- * `SCHED_RT_PRIO={0-99}`: for values {1-99} set the realtime priority
-    multipathd will attempt to run with. for value 0, disable multipathd
-    changing itself to a realtime process.
  * `ENABLE_LIBDMMP=0`: disable building libdmmp
  * `ENABLE_DMEVENTS_POLL=0`: disable support for the device-mapper event
    polling API. For use with pre-5.0 kernels that don't support dmevent polling
diff --git a/multipathd/Makefile b/multipathd/Makefile
index 7300f07a..997b40cf 100644
--- a/multipathd/Makefile
+++ b/multipathd/Makefile
@@ -57,9 +57,6 @@ $(CLI):  $(CLI_OBJS)
 cli_handlers.o:	cli_handlers.c
 	$(Q)$(CC) $(CPPFLAGS) $(CFLAGS) -Wno-unused-parameter -c -o $@ $<
 
-main.o:	main.c
-	$(Q)$(CC) $(CPPFLAGS) -DSCHED_RT_PRIO=$(SCHED_RT_PRIO) $(CFLAGS) -c -o $@ $<
-
 install:
 	$(Q)$(INSTALL_PROGRAM) -d $(DESTDIR)$(bindir)
 	$(Q)$(INSTALL_PROGRAM) -m 755 $(EXEC) $(DESTDIR)$(bindir)
diff --git a/multipathd/main.c b/multipathd/main.c
index 9486a8a3..dd17d5c3 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -3171,14 +3171,23 @@ static void
 setscheduler (void)
 {
 	int res;
-	static struct sched_param sched_param = {
-		.sched_priority = SCHED_RT_PRIO
-	};
+	static struct sched_param sched_param;
+	struct rlimit rlim;
+
+	if (getrlimit(RLIMIT_RTPRIO, &rlim) < 0 || rlim.rlim_max == 0)
+		return;
+
+	sched_param.sched_priority = rlim.rlim_max > INT_MAX ? INT_MAX :
+				     rlim.rlim_max;
+	res = sched_get_priority_max(SCHED_RR);
+	if (res > 0 && res < sched_param.sched_priority)
+		sched_param.sched_priority = res;
 
-	res = sched_setscheduler (0, SCHED_RR, &sched_param);
+	res = sched_setscheduler(0, SCHED_RR, &sched_param);
 
 	if (res == -1)
-		condlog(2, "Could not set SCHED_RR at priority 99");
+		condlog(2, "Could not set SCHED_RR at priority %d",
+			sched_param.sched_priority);
 	return;
 }
 
@@ -3471,8 +3480,7 @@ child (__attribute__((unused)) void *param)
 	if (!vecs)
 		goto failed;
 
-	if (SCHED_RT_PRIO)
-		setscheduler();
+	setscheduler();
 	set_oom_adj();
 #ifdef FPIN_EVENT_HANDLER
 	if (conf->marginal_pathgroups == MARGINAL_PATHGROUP_FPIN)
diff --git a/multipathd/multipathd.service.in b/multipathd/multipathd.service.in
index 6d03ff71..18bb367e 100644
--- a/multipathd/multipathd.service.in
+++ b/multipathd/multipathd.service.in
@@ -19,6 +19,7 @@ NotifyAccess=main
 ExecStart=/sbin/multipathd -d -s
 ExecReload=/sbin/multipathd reconfigure
 TasksMax=infinity
+LimitRTPRIO=infinity
 
 [Install]
 WantedBy=sysinit.target
-- 
2.43.0

