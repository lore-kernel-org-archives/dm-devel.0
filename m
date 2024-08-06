Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38738374C4
	for <dm-devel@lists.linux.dev>; Tue,  6 Aug 2024 22:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722984891; cv=none; b=aEW7je2ooPkeRBF7pS6bc/4WUTIaj+40tDCDtlqZL1CiOlmKiKrEe5CFTDtw5j2QC+gTURGhZham439UuSzXeSlKIEGCHC4p6jWiqXKWk0gkQYWP4iDeQd+cMIMbUppH89nt3h0nSMPCoAJM0sqoshFXje1zuC+gGMuyCsCSagY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722984891; c=relaxed/simple;
	bh=avq/gM21A/GXkFkH3VMLI8MvZKa4UpBBab6Wbp3ThQA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=QtQh5ZsIRctEwxKRBCpPe+BZzBGDgWY32jUnONQkIWPDvUztaLb91HO1qt8anv/5FvPLS8PSnDoYoFxH0heI/JIo8g8l30+brf5CsUK6W2K3lPue8xbphmuGP8clmdzKHpYVrSGZG/vtgy/tk/Qr3HhTArsNhPjzcxRgZYODLmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fHJzGRZB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fHJzGRZB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722984888;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=TpjA62yMurGGanq8vAxBKhHFRaTd2dHQp9l9dsgnyRw=;
	b=fHJzGRZBb6srXcdVQOdS2XDxqadGaC4qHtZ1e8LBsYFM4jbGh4tsiUJoArjLcadnd2R4+M
	wNIdr0wR9A+gbO8Xt33VZE3hn+QXNlVU3mkXHx1y1yhnl7unqCRrfLcyjNNG5gFfUUyPN1
	lYrv4V9as6TMX3ZDtVHOCYT2IVLkRTA=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-395-BtMMLOr1MyG1DgVe2lbM8w-1; Tue,
 06 Aug 2024 18:54:45 -0400
X-MC-Unique: BtMMLOr1MyG1DgVe2lbM8w-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 749BD1955D52;
	Tue,  6 Aug 2024 22:54:44 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CC3F319560AA;
	Tue,  6 Aug 2024 22:54:43 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 476Msgsb3227904
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 6 Aug 2024 18:54:42 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 476MsfDX3227903;
	Tue, 6 Aug 2024 18:54:41 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH] multipathd: show pending reconfigs in 'show daemon' output
Date: Tue,  6 Aug 2024 18:54:41 -0400
Message-ID: <20240806225441.3227895-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Since the "multipathd reconfigure" command simply schedules a
reconfigure, and doesn't wait until it has occurred, it would be nice to
be able to query multipathd to see if the reconfigure has completed.
"multipathd show daemon" doesn't work for this. The reconfigure could be
delayed, and the output gives no indication that there is a pending
reconfigure.

Change the ouput to add " (pending reconfigure)" if a reconfigure is
pending.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/cli_handlers.c | 11 +++++++++--
 multipathd/main.c         | 15 ++++++++-------
 multipathd/main.h         |  2 +-
 3 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 4b6cfba2..ef5f53e2 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -342,8 +342,15 @@ show_status (struct strbuf *reply, struct vectors *vecs)
 static int
 show_daemon (struct strbuf *reply)
 {
-	if (print_strbuf(reply, "pid %d %s\n",
-			 daemon_pid, daemon_status()) < 0)
+	const char *status;
+	bool pending_reconfig;
+
+	status = daemon_status(&pending_reconfig);
+	if (status == NULL)
+		return 1;
+	if (print_strbuf(reply, "pid %d %s%s\n",
+			 daemon_pid, status,
+			 pending_reconfig ? " (pending reconfigure)" : "") < 0)
 		return 1;
 
 	return 0;
diff --git a/multipathd/main.c b/multipathd/main.c
index daec9e93..f43ff549 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -132,6 +132,8 @@ static int poll_dmevents = 1;
 static enum daemon_status running_state = DAEMON_INIT;
 /* Don't access this variable without holding config_lock */
 static bool __delayed_reconfig;
+/* Don't access this variable without holding config_lock */
+static enum force_reload_types reconfigure_pending = FORCE_RELOAD_NONE;
 pid_t daemon_pid;
 static pthread_mutex_t config_lock = PTHREAD_MUTEX_INITIALIZER;
 static pthread_cond_t config_cond;
@@ -142,19 +144,21 @@ static bool check_thr_started, uevent_thr_started, uxlsnr_thr_started,
 	fpin_consumer_thr_started;
 static int pid_fd = -1;
 
-static inline enum daemon_status get_running_state(void)
+static inline enum daemon_status get_running_state(bool *pending_reconfig)
 {
 	enum daemon_status st;
 
 	pthread_mutex_lock(&config_lock);
 	st = running_state;
+	if (pending_reconfig != NULL)
+		*pending_reconfig = (reconfigure_pending != FORCE_RELOAD_NONE);
 	pthread_mutex_unlock(&config_lock);
 	return st;
 }
 
 int should_exit(void)
 {
-	return get_running_state() == DAEMON_SHUTDOWN;
+	return get_running_state(NULL) == DAEMON_SHUTDOWN;
 }
 
 /*
@@ -179,9 +183,9 @@ static const char *daemon_status_msg[DAEMON_STATUS_SIZE] = {
 };
 
 const char *
-daemon_status(void)
+daemon_status(bool *pending_reconfig)
 {
-	int status = get_running_state();
+	int status = get_running_state(pending_reconfig);
 
 	if (status < DAEMON_INIT || status >= DAEMON_STATUS_SIZE)
 		return NULL;
@@ -277,9 +281,6 @@ enum daemon_status wait_for_state_change_if(enum daemon_status oldstate,
 	return st;
 }
 
-/* Don't access this variable without holding config_lock */
-static enum force_reload_types reconfigure_pending = FORCE_RELOAD_NONE;
-
 /* must be called with config_lock held */
 static void __post_config_state(enum daemon_status state)
 {
diff --git a/multipathd/main.h b/multipathd/main.h
index 7aa93ca3..ef838a02 100644
--- a/multipathd/main.h
+++ b/multipathd/main.h
@@ -31,7 +31,7 @@ extern pid_t daemon_pid;
 extern int uxsock_timeout;
 
 void exit_daemon(void);
-const char * daemon_status(void);
+const char *daemon_status(bool *pending_reconfig);
 enum daemon_status wait_for_state_change_if(enum daemon_status oldstate,
 					    unsigned long ms);
 void schedule_reconfigure(enum force_reload_types requested_type);
-- 
2.45.0

