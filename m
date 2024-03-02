Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E0A763CB
	for <dm-devel@lists.linux.dev>; Sat,  2 Mar 2024 00:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709339862; cv=none; b=IcOxXy5wHm3QstNQBAwPykpTplAKFQ5D3a6SiZHaT2agPQhp8vw+2+MWOyVFok4Ev/SRqBU/B45W87ow5Voz8Uu+khkTY0AP9mum8WdAP+NXfyQJaxrz/Eipo7Vd9WOzwEzzRiUE0op63ubtiXrRAxwpf+0oANLrVkMlXcbszbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709339862; c=relaxed/simple;
	bh=VlatRZoS0Acq0pQGUd1oFzLW9NmnwiZEJ4/cH2RH9aM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p4YxXSrNOoYB8I0q1d1Dpm0YKhH3ab1fMy42jHV1Z1jWH3v7XjV3D8CAc8ZfMLZ9zb0ttiGR5iOkn8Ck+4ZXn619rVOAoHVmIgv/rPAPvox0xS5HrPmMSQaKsa2GkYOOYWVUI79UOkrENdn8wkkjIuemPymCM+l5jkdr/dm5fpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LQtFh60w; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LQtFh60w"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709339859;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fViZPgIBaaU6/uASMiuol/wapeUTcG13eHrPcl7x55U=;
	b=LQtFh60wJNgi88bFYmwEjxt+0eDFwdU+F38IxhvlZFntZq9B2T1yiGVBKjYTadLfRChusI
	ms5ZW9/I+sYsTlKxLEmRj0C6UyF33hyp8dI8rbyC2OvDvojmjoTr6z0ZwboiLeyAW7VXhx
	Kt37tVY1xKyeVCucndDEJ8kUBj2o3xY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-551-TBurVUFtMpiOs2TNXA3aHA-1; Fri, 01 Mar 2024 19:37:36 -0500
X-MC-Unique: TBurVUFtMpiOs2TNXA3aHA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 16C68185A780;
	Sat,  2 Mar 2024 00:37:31 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 10F8A40C6EBA;
	Sat,  2 Mar 2024 00:37:31 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 4220bU0h782713
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 1 Mar 2024 19:37:30 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 4220bUnx782712;
	Fri, 1 Mar 2024 19:37:30 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>,
        sushmbha <sushmita.bhattacharya@oracle.com>
Subject: [PATCH v2 2/2] multipathd: make multipathd scheduling configurable
Date: Fri,  1 Mar 2024 19:37:30 -0500
Message-ID: <20240302003730.782685-3-bmarzins@redhat.com>
In-Reply-To: <20240302003730.782685-1-bmarzins@redhat.com>
References: <20240302003730.782685-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Currently multipathd always tries to run as a realtime process with a
priority of 99. This is excessive. As a first step towards fixing this,
make it possible at compile time to lower the priority or keep
multipathd from making itself a realtime process.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 Makefile.inc        | 6 ++++++
 README.md           | 3 +++
 multipathd/Makefile | 3 +++
 multipathd/main.c   | 5 +++--
 4 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/Makefile.inc b/Makefile.inc
index 5668e638..6d206281 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -18,6 +18,12 @@ READLINE :=
 # SCSI_DH_MODULES_PRELOAD := scsi_dh_alua scsi_dh_rdac
 SCSI_DH_MODULES_PRELOAD :=
 
+# Multipathd scheduling priority. Set value from 1 to 99 to make multipathd
+# change its scheduling policy to SCHED_RR and its priority to the specified
+# value. set to 0 to stop multipathd from changing the scheduling policy and
+# priority it was started with.
+SCHED_RT_PRIO := 99
+
 EXTRAVERSION := $(shell rev=$$(git rev-parse --short=7 HEAD 2>/dev/null); echo $${rev:+-g$$rev})
 
 # PKG_CONFIG must be read from the environment to enable compilation
diff --git a/README.md b/README.md
index d4f35f57..bb41bf0e 100644
--- a/README.md
+++ b/README.md
@@ -98,6 +98,9 @@ The following variables can be passed to the `make` command line:
     By default, command line editing is disabled.
     Note that using libreadline may
     [make binary indistributable due to license incompatibility](https://github.com/opensvc/multipath-tools/issues/36).
+ * `SCHED_RT_PRIO={0-99}`: for values {1-99} set the realtime priority
+    multipathd will attempt to run with. for value 0, disable multipathd
+    changing itself to a realtime process.
  * `ENABLE_LIBDMMP=0`: disable building libdmmp
  * `ENABLE_DMEVENTS_POLL=0`: disable support for the device-mapper event
    polling API. For use with pre-5.0 kernels that don't support dmevent polling
diff --git a/multipathd/Makefile b/multipathd/Makefile
index 997b40cf..7300f07a 100644
--- a/multipathd/Makefile
+++ b/multipathd/Makefile
@@ -57,6 +57,9 @@ $(CLI):  $(CLI_OBJS)
 cli_handlers.o:	cli_handlers.c
 	$(Q)$(CC) $(CPPFLAGS) $(CFLAGS) -Wno-unused-parameter -c -o $@ $<
 
+main.o:	main.c
+	$(Q)$(CC) $(CPPFLAGS) -DSCHED_RT_PRIO=$(SCHED_RT_PRIO) $(CFLAGS) -c -o $@ $<
+
 install:
 	$(Q)$(INSTALL_PROGRAM) -d $(DESTDIR)$(bindir)
 	$(Q)$(INSTALL_PROGRAM) -m 755 $(EXEC) $(DESTDIR)$(bindir)
diff --git a/multipathd/main.c b/multipathd/main.c
index 85ac540f..9486a8a3 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -3172,7 +3172,7 @@ setscheduler (void)
 {
 	int res;
 	static struct sched_param sched_param = {
-		.sched_priority = 99
+		.sched_priority = SCHED_RT_PRIO
 	};
 
 	res = sched_setscheduler (0, SCHED_RR, &sched_param);
@@ -3471,7 +3471,8 @@ child (__attribute__((unused)) void *param)
 	if (!vecs)
 		goto failed;
 
-	setscheduler();
+	if (SCHED_RT_PRIO)
+		setscheduler();
 	set_oom_adj();
 #ifdef FPIN_EVENT_HANDLER
 	if (conf->marginal_pathgroups == MARGINAL_PATHGROUP_FPIN)
-- 
2.43.0

