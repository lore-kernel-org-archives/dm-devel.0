Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795670684;
	b=K+1uKeFAnFTH7e6mpIIHKjxlK8tFmYtSfQvDlQwOkUgV5921CDGY6ZYCsyNM0hFAdT9Q
	 AhjuKAleaOXeY80V8CNz3sV8J/4g+vYBuulxQrgdcADbVtS+QNWuNb/jm/RZjlQZ8Dmox
	 Hr2vKuxfMiqguzMf0j6jRCpMocNbJA/djoW+U6pavgesovAB89/GYwt8WlHBAGnTyVHgl
	 ha4v72ra6/c0SYXUjjKXQ9Ef5NvT3ycjLboI1DoYZx7Vkv56pu/6qGutZlKwemQh4HSLW
	 XmI7J8tmMXi8rOdB+DJ6VrqfdkFDX438mMV3PWW0EDg7Y3ciwoEjHBMLQIKJyBZCHPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795670684;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:In-Reply-To:References:MIME-Version:
	 X-Scanned-By:X-Mimecast-Spam-Score:X-Mimecast-MFC-PROC-ID:
	 X-Mimecast-Originator:Content-Transfer-Encoding:content-type;
	bh=gF3ftaxGJbRZZ7jGC0rs6Wp1LXTPDa44a54Uu+b0e1o=;
	b=o6jz2aEyLbx0+9PZXx8LMLrYHkJUNI9+JmBX/Ku45JK6MNqsz4op+0O2YwDcVHS8wikh
	 9G2x6pPsfAj5iXXs8QAAQGHZVe6yUFguuq9piCuKbdqsVxmdiewVuzODY0v4qjCJPj6QF
	 e1edzVJUal/lT5AVz1PUtlKkIkvjq/CZeDrPPvGULZVhzRppHj8ADYTbycJx0bN7FE3hY
	 lqJleZ3SE5ExArr6LEDr4gbVCJ9ogufDv8KjyJ0FuKMNXphsG/NXhB9mvZ8+ewFsv2lG6
	 SG0GSF9S1jU3zHBGH19c3gJEmGrG9Z/qUdYWYsJsD49Va4iDE+gHeGmadfxuRWc0CGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=CpsTqNPX;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6461C606A323
	for <dm-devel@lists.linux.dev>; Thu, 26 Nov 2026 05:24:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6461C606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=CpsTqNPX
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795670682;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gF3ftaxGJbRZZ7jGC0rs6Wp1LXTPDa44a54Uu+b0e1o=;
	b=CpsTqNPXum/yZUeVJe0bwFmi6HRqB61wU0O/19ihB1tvO6XE4SXJtkNWTr27vPubd8fM98
	6uClqhAh6PBtB4juD4k4ZRibNhoaR7Za8Jg0DOwykPyvLXmPYl28M86wzsnCXKnp3QOH77
	7fLfPYLyivX6aEyQPeBagbzApJ5qWAA=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-624-CeEPZ5oaMT-qsrsTIBD1yQ-1; Thu,
 26 Nov 2026 05:24:38 +0000
X-MC-Unique: CeEPZ5oaMT-qsrsTIBD1yQ-1
X-Mimecast-MFC-AGG-ID: CeEPZ5oaMT-qsrsTIBD1yQ_1795670677
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0BF971955F26;
	Thu, 26 Nov 2026 05:24:37 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B6B0B1956053;
	Thu, 26 Nov 2026 05:24:36 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 6AQ5OZ0v725798
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 26 Nov 2026 00:24:35 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 6AQ5OZMU725797;
	Thu, 26 Nov 2026 00:24:35 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 4/4] multipathd: add commands to wait for reconfigures to complete
Date: Thu, 26 Nov 2026 00:24:34 -0500
Message-ID: <20261126052434.725762-5-bmarzins@redhat.com>
In-Reply-To: <20261126052434.725762-1-bmarzins@redhat.com>
References: <20261126052434.725762-1-bmarzins@redhat.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: zODKzzy3E3P4TsjdtsdJvJ1oLs6Mm9hgGSkS0Zos_0o_1795670677
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Add the "reconfigure wait" and "reconfigure all wait" multipathd
commands. These work just like the non-wait options, but they do not
return until there are no more scheduled reconfigures.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/callbacks.c     |  3 +++
 multipathd/cli.c           |  1 +
 multipathd/cli.h           |  3 +++
 multipathd/cli_handlers.c  | 22 ++++++++++++++++++++--
 multipathd/main.c          | 15 +++++++++++++--
 multipathd/main.h          |  3 ++-
 multipathd/multipathd.8.in | 19 +++++++++++++++++--
 7 files changed, 59 insertions(+), 7 deletions(-)

diff --git a/multipathd/callbacks.c b/multipathd/callbacks.c
index 2027c3a6..60647519 100644
--- a/multipathd/callbacks.c
+++ b/multipathd/callbacks.c
@@ -44,6 +44,9 @@ void init_handler_callbacks(void)
 	set_unlocked_handler_callback(VRB_RECONFIGURE, HANDLER(cli_reconfigure));
 	set_unlocked_handler_callback(VRB_RECONFIGURE | Q1_ALL,
 				      HANDLER(cli_reconfigure_all));
+	set_unlocked_handler_callback(VRB_RECONFIGURE | Q1_WAIT, HANDLER(cli_reconfigure_wait));
+	set_unlocked_handler_callback(VRB_RECONFIGURE | Q1_ALL | Q2_WAIT,
+				      HANDLER(cli_reconfigure_all_wait));
 	set_handler_callback(VRB_SUSPEND | Q1_MAP, HANDLER(cli_suspend));
 	set_handler_callback(VRB_RESUME | Q1_MAP, HANDLER(cli_resume));
 	set_handler_callback(VRB_RESIZE | Q1_MAP, HANDLER(cli_resize));
diff --git a/multipathd/cli.c b/multipathd/cli.c
index 0d679c86..25dce4e5 100644
--- a/multipathd/cli.c
+++ b/multipathd/cli.c
@@ -228,6 +228,7 @@ load_keys (void)
 	r += add_key(keys, "setprhold", VRB_SETPRHOLD, 0);
 	r += add_key(keys, "unsetprhold", VRB_UNSETPRHOLD, 0);
 	r += add_key(keys, "pathlist", KEY_PATHLIST, 1);
+	r += add_key(keys, "wait", KEY_WAIT, 0);
 
 	if (r) {
 		free_keys(keys);
diff --git a/multipathd/cli.h b/multipathd/cli.h
index 6d599ca7..1c6c42e1 100644
--- a/multipathd/cli.h
+++ b/multipathd/cli.h
@@ -64,6 +64,7 @@ enum {
 	KEY_GROUP		= 82,
 	KEY_KEY			= 83,
 	KEY_PATHLIST		= 84,
+	KEY_WAIT		= 85,
 };
 
 /*
@@ -85,6 +86,7 @@ enum {
 	Q1_ALL			= KEY_ALL << 8,
 	Q1_DAEMON		= KEY_DAEMON << 8,
 	Q1_STATUS		= KEY_STATUS << 8,
+	Q1_WAIT			= KEY_WAIT << 8,
 
 	/* byte 2: qualifier 2 */
 	Q2_FMT			= KEY_FMT << 16,
@@ -97,6 +99,7 @@ enum {
 	Q2_GROUP		= KEY_GROUP << 16,
 	Q2_KEY			= KEY_KEY << 16,
 	Q2_PATHLIST		= KEY_PATHLIST << 16,
+	Q2_WAIT			= KEY_WAIT << 16,
 
 	/* byte 3: qualifier 3 */
 	Q3_FMT			= KEY_FMT << 24,
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index e5c43bd8..86f050a0 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -1021,7 +1021,7 @@ static int cli_reconfigure(void *v, struct strbuf *reply,
 {
 	condlog(2, "reconfigure (operator)");
 
-	schedule_reconfigure(FORCE_RELOAD_WEAK);
+	schedule_reconfigure(FORCE_RELOAD_WEAK, NULL);
 	return 0;
 }
 
@@ -1030,7 +1030,25 @@ int cli_reconfigure_all(void *v, struct strbuf *reply,
 {
 	condlog(2, "reconfigure all (operator)");
 
-	schedule_reconfigure(FORCE_RELOAD_YES);
+	schedule_reconfigure(FORCE_RELOAD_YES, NULL);
+	return 0;
+}
+
+static int cli_reconfigure_wait(void *v, struct strbuf *reply,
+				struct list_head *wait_node, void *data)
+{
+	condlog(2, "reconfigure wait (operator)");
+
+	schedule_reconfigure(FORCE_RELOAD_WEAK, wait_node);
+	return 0;
+}
+
+static int cli_reconfigure_all_wait(void *v, struct strbuf *reply,
+			            struct list_head *wait_node, void *data)
+{
+	condlog(2, "reconfigure all wait (operator)");
+
+	schedule_reconfigure(FORCE_RELOAD_YES, wait_node);
 	return 0;
 }
 
diff --git a/multipathd/main.c b/multipathd/main.c
index 1bb8eac8..83773d90 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -135,6 +135,8 @@ static enum daemon_status running_state = DAEMON_INIT;
 static bool delayed_reconfig;
 /* Don't access this variable without holding config_lock */
 static enum force_reload_types reconfigure_pending = FORCE_RELOAD_NONE;
+/* Don't access this variable without holding config_lock */
+LIST_HEAD(config_wait_list);
 pid_t daemon_pid;
 static pthread_mutex_t config_lock = PTHREAD_MUTEX_INITIALIZER;
 static pthread_cond_t config_cond;
@@ -336,7 +338,8 @@ void remove_map_callback(struct multipath *mpp)
 		unblock_reconfigure();
 }
 
-void schedule_reconfigure(enum force_reload_types requested_type)
+void schedule_reconfigure(enum force_reload_types requested_type,
+			  struct list_head *wait_node)
 {
 	pthread_mutex_lock(&config_lock);
 	pthread_cleanup_push(config_cleanup, NULL);
@@ -360,6 +363,8 @@ void schedule_reconfigure(enum force_reload_types requested_type)
 	default:
 		break;
 	}
+	if (wait_node)
+		wait_for_event(wait_node, &config_wait_list);
 	pthread_cleanup_pop(1);
 }
 
@@ -3657,7 +3662,7 @@ handle_signals(bool nonfatal)
 		return;
 	if (reconfig_sig) {
 		condlog(3, "reconfigure (signal)");
-		schedule_reconfigure(FORCE_RELOAD_WEAK);
+		schedule_reconfigure(FORCE_RELOAD_WEAK, NULL);
 	}
 	if (log_reset_sig) {
 		condlog(3, "reset log (signal)");
@@ -4169,6 +4174,12 @@ child (__attribute__((unused)) void *param)
 			pthread_mutex_unlock(&config_lock);
 
 			rc = reconfigure(vecs, reload_type);
+
+			/* wake up waiters if there are no pending reconfigs */
+			pthread_mutex_lock(&config_lock);
+			if (reconfigure_pending == FORCE_RELOAD_NONE)
+				wakeup_event_waiter(&config_wait_list);
+			pthread_mutex_unlock(&config_lock);
 		} else {
 			pthread_mutex_lock(&config_lock);
 			delayed_reconfig = true;
diff --git a/multipathd/main.h b/multipathd/main.h
index b66208ec..76d09196 100644
--- a/multipathd/main.h
+++ b/multipathd/main.h
@@ -34,7 +34,8 @@ void exit_daemon(void);
 const char *daemon_status(bool *pending_reconfig);
 enum daemon_status wait_for_state_change_if(enum daemon_status oldstate,
 					    unsigned long ms);
-void schedule_reconfigure(enum force_reload_types requested_type);
+void schedule_reconfigure(enum force_reload_types requested_type,
+			  struct list_head *wait_node);
 int need_to_delay_reconfig (struct vectors *);
 int ev_add_path (struct path *, struct vectors *, int);
 int ev_remove_path (struct path *, struct vectors *, int);
diff --git a/multipathd/multipathd.8.in b/multipathd/multipathd.8.in
index 632cbe40..aee67004 100644
--- a/multipathd/multipathd.8.in
+++ b/multipathd/multipathd.8.in
@@ -274,13 +274,28 @@ group index, starting with 1.
 .B reconfigure
 Rereads the configuration, and reloads all changed multipath devices. This
 also happens at startup, when the service is reload, or when a SIGHUP is
-received.
+received. This command schedules the reconfiguration and returns immediately.
+.
+.TP
+.B reconfigure wait
+Rereads the configuration, and reloads all changed multipath devices. This
+also happens at startup, when the service is reload, or when a SIGHUP is
+received. This command waits for for the reconfiguration to complete before
+returning
 .
 .TP
 .B reconfigure all
 Rereads the configuration, and reloads all multipath devices regardless of
 whether or not they have changed. This also happens when \fImultipath -r\fR is
-run.
+run. This command schedules the reconfiguration and returns immediately.
+.
+.TP
+.B reconfigure all wait
+Rereads the configuration, and reloads all multipath devices regardless of
+whether or not they have changed. This also happens when \fImultipath -r\fR is
+run. This command waits for for the reconfiguration to complete before
+returning
+.
 .TP
 .B suspend map|multipath $map
 Sets map $map into suspend state.
-- 
2.56.0

