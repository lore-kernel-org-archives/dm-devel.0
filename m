Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BAC22C197
	for <dm-devel@lists.linux.dev>; Fri, 29 Mar 2024 18:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711736901; cv=none; b=jpUWbqdcR33jnPhLlfX3j9UdM5kPr5KnzaZNP1oUSk9g4no769xQoBdRNpcK/OEEneuEWx6OJDS/cRG0aRtNdiAk+z7vVVYadOSvkHKLu0JUBKhAThX9XWZlGEaPJWTQuJfEzSUg7LmHg8KNMrmDkbDyh94WMQvv+VtOXtXHhSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711736901; c=relaxed/simple;
	bh=YaCs/oBWhjfW7UCplMT1932Nyqp/n69grVWBOiVWy0k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=kZ+c8/Q9zunwzW0wRu5AFoYmHA9Y161gCx5e8Iic/XwERxfHhwJAXMsQKC2hN1nQpNTb4fi6C3DwXsN5gpIClQyZ2TM5mnOavzRSa4+ADhWcvPIPCOWUIXM8QnBBrGW6HjHNQSsImT6R4epPlDqyuG8dQyxJJdEJImp+ivxhkxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M/+tGuLv; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M/+tGuLv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711736897;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=gkyuqpeBe4KOuGQXiP0cwTgfFCDwWDUgVD45MVvJ/Kw=;
	b=M/+tGuLvb1PVDO8EI4ogHkk5S5QXk9OuAuusVONZ5seYwd/TNMTVtFx31E4DTzp216WrXU
	eX02dEy89y7n3NFVTE87Kq6veuKvR+lDSUG3rlgTuxnjQKvyPVa8S2NCJljlvTk2ue3SJS
	3w+QhlC80vn0TUj1tTv+kZXGRMkQ0f8=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-68-o7VP__gxPbutPRBkHM4Tgw-1; Fri,
 29 Mar 2024 14:28:14 -0400
X-MC-Unique: o7VP__gxPbutPRBkHM4Tgw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 062F12803622;
	Fri, 29 Mar 2024 18:28:14 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F1CC33C85;
	Fri, 29 Mar 2024 18:28:13 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 42TISDJe1455029
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 29 Mar 2024 14:28:13 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 42TISDTH1455028;
	Fri, 29 Mar 2024 14:28:13 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH] multipathd: make multipathd set priority to RLIMIT_RTPRIO
Date: Fri, 29 Mar 2024 14:28:13 -0400
Message-ID: <20240329182813.1455019-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

With this change, if the SCHED_RT_PRIO compiler flag is not set,
multipathd will call getrlimit(RLIMIT_RTPRIO, ...) and look at the hard
limit. It it's 0, multipath will do nothing. Otherwise it will change
its scheduling policy to SCHED_RR and its priority to the hard limit.

This allows users to change the priority of that multipathd runs with by
adding

LimitRTPRIO=<prio>

to the [Service] section of the multipathd.service unit file. Setting
LimitRTPRIO=0 will make multipathd run as a normal process, while
setting LimitRTPRIO=infinity will make it use the maximum SCHED_RR prio,
which is 99.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 Makefile.inc        |  7 +++++--
 README.md           |  2 +-
 multipathd/Makefile |  5 ++++-
 multipathd/main.c   | 28 +++++++++++++++++++++-------
 4 files changed, 31 insertions(+), 11 deletions(-)

diff --git a/Makefile.inc b/Makefile.inc
index 6d206281..75935fd3 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -20,8 +20,11 @@ SCSI_DH_MODULES_PRELOAD :=
 
 # Multipathd scheduling priority. Set value from 1 to 99 to make multipathd
 # change its scheduling policy to SCHED_RR and its priority to the specified
-# value. set to 0 to stop multipathd from changing the scheduling policy and
-# priority it was started with.
+# value. Set to 0 to stop multipathd from changing the scheduling policy and
+# priority it was started with. If undefined, multipathd will call
+# getrlimit(RLIMIT_RTPRIO, ...) and look at the hard limit. It it's 0,
+# multipath will do nothing. Otherwise it will change its scheduling policy
+# to SCHED_RR and its priority to the hard limit.
 SCHED_RT_PRIO := 99
 
 EXTRAVERSION := $(shell rev=$$(git rev-parse --short=7 HEAD 2>/dev/null); echo $${rev:+-g$$rev})
diff --git a/README.md b/README.md
index bb41bf0e..fda3a086 100644
--- a/README.md
+++ b/README.md
@@ -99,7 +99,7 @@ The following variables can be passed to the `make` command line:
     Note that using libreadline may
     [make binary indistributable due to license incompatibility](https://github.com/opensvc/multipath-tools/issues/36).
  * `SCHED_RT_PRIO={0-99}`: for values {1-99} set the realtime priority
-    multipathd will attempt to run with. for value 0, disable multipathd
+    multipathd will attempt to run with. For value 0, disable multipathd
     changing itself to a realtime process.
  * `ENABLE_LIBDMMP=0`: disable building libdmmp
  * `ENABLE_DMEVENTS_POLL=0`: disable support for the device-mapper event
diff --git a/multipathd/Makefile b/multipathd/Makefile
index 7300f07a..138d9562 100644
--- a/multipathd/Makefile
+++ b/multipathd/Makefile
@@ -21,6 +21,9 @@ CLI_LIBDEPS	:=  -L$(mpathutildir) -lmpathutil -L$(mpathcmddir) -lmpathcmd \
 LIBDEPS		:= -L$(multipathdir) -lmultipath -L$(mpathpersistdir) -lmpathpersist \
 	  	-ldevmapper $(CLI_LIBDEPS)
 
+ifdef SCHED_RT_PRIO
+PR_CPPFLAGS	:= -DSCHED_RT_PRIO=$(SCHED_RT_PRIO)
+endif
 ifeq ($(READLINE),libedit)
 RL_CPPFLAGS	:= -DUSE_LIBEDIT
 RL_LIBDEPS	:= -ledit
@@ -58,7 +61,7 @@ cli_handlers.o:	cli_handlers.c
 	$(Q)$(CC) $(CPPFLAGS) $(CFLAGS) -Wno-unused-parameter -c -o $@ $<
 
 main.o:	main.c
-	$(Q)$(CC) $(CPPFLAGS) -DSCHED_RT_PRIO=$(SCHED_RT_PRIO) $(CFLAGS) -c -o $@ $<
+	$(Q)$(CC) $(CPPFLAGS) $(PR_CPPFLAGS) $(CFLAGS) -c -o $@ $<
 
 install:
 	$(Q)$(INSTALL_PROGRAM) -d $(DESTDIR)$(bindir)
diff --git a/multipathd/main.c b/multipathd/main.c
index 9486a8a3..1ca70c90 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -3171,14 +3171,29 @@ static void
 setscheduler (void)
 {
 	int res;
-	static struct sched_param sched_param = {
-		.sched_priority = SCHED_RT_PRIO
-	};
+	static struct sched_param sched_param;
+
+#ifdef SCHED_RT_PRIO
+	if (SCHED_RT_PRIO <= 0)
+		return;
+	sched_param.sched_priority = SCHED_RT_PRIO;
+#else
+	struct rlimit rlim;
+
+	if (getrlimit(RLIMIT_RTPRIO, &rlim) < 0 || rlim.rlim_max == 0)
+		return;
+	sched_param.sched_priority = rlim.rlim_max > INT_MAX ? INT_MAX :
+				     rlim.rlim_max;
+#endif
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
 
@@ -3471,8 +3486,7 @@ child (__attribute__((unused)) void *param)
 	if (!vecs)
 		goto failed;
 
-	if (SCHED_RT_PRIO)
-		setscheduler();
+	setscheduler();
 	set_oom_adj();
 #ifdef FPIN_EVENT_HANDLER
 	if (conf->marginal_pathgroups == MARGINAL_PATHGROUP_FPIN)
-- 
2.43.0

