Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795670684;
	b=gBxMViN5Moa8yMmNSElhFMaCAmTT465lB9n0s8uywRWRkXvEc1Xzd0ql8OaCEuk0IexF
	 NUKVPgZ+hB3QKjPqXjO5EWobADlf2pTDMvR17asz2v4U+eLxuBL+S0Bp1qk+lgcuQIq8C
	 uPy6jj61+va9uKYK2nWAOS7lwkXpqlPjOuJfyFNntbkK5SkIDlzTha462OZDcDPqHs0Un
	 LqdRH8v2rASAamOQNPbtpupZp8Jcnm43ARuIdbkzBcLPYwk23r/JgQAIJZ8JzojXi+8d4
	 3skR5XSTTUQ4NG2i43uwHfFQYw8cqVnSUoAcuG9zO5xBINUQbfcpSD1KodyaqzwOkvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795670684;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:In-Reply-To:References:MIME-Version:
	 X-Scanned-By:X-Mimecast-Spam-Score:X-Mimecast-MFC-PROC-ID:
	 X-Mimecast-Originator:Content-Transfer-Encoding:content-type;
	bh=X95zpiKOyev2TRqSGjYBGo2ydKFXkxrFxHSDfq6+VZI=;
	b=WChRv//xKF/KKUuIXp7pxf8rLr8o85ofSZL/baPVmL0jz0kN1vQvJNMhCvlWSR4T8y39
	 1Ct1PFZl1AVzMnL9SwTES7GaN+e4tvXPxhjso15mbDhadLf7+W1PXz3rqLNCjpMPCtuDL
	 Rw7Xl/itjzL83cG3IvzbAYdT4h2I1efq5RfWdFsyr4guoGYvL6jxhXdMnSY3iUVm4HHD7
	 NZzUjfOx+Vh1AVwvwwvPmGg2lXyjLJgihfoRqxhSk2damuo90kvNSsWWtvpaVIrPrpZd+
	 otKKt2TkUJLE5+XtVCE7V2nydKaVL6UdbxesyvRA+QXlBkq0v1KHFI87OKM9jOjoWWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=fDzBEDeK;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64702606A326
	for <dm-devel@lists.linux.dev>; Thu, 26 Nov 2026 05:24:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 64702606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=fDzBEDeK
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795670682;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X95zpiKOyev2TRqSGjYBGo2ydKFXkxrFxHSDfq6+VZI=;
	b=fDzBEDeK9uvF2HOXdlvFnztfLSMdGsLb6BMLYdSfDPOko7GeEzzkp7MoYgVKRoW/2vEeAF
	Gri7FkcsglM5TTNwSQtpeXorCpD0276/iKJzCmSvSPcg1VSXeTIf5wGC7g6iUvdNBUC9HR
	VZs4yDJ17IUItLdZwKOm0swmEG+RQH4=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-624-EmiF1WABOEaPqRAREBkJPw-1; Thu,
 26 Nov 2026 05:24:38 +0000
X-MC-Unique: EmiF1WABOEaPqRAREBkJPw-1
X-Mimecast-MFC-AGG-ID: EmiF1WABOEaPqRAREBkJPw_1795670677
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CCD6D18005B0;
	Thu, 26 Nov 2026 05:24:36 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 682E330000E7;
	Thu, 26 Nov 2026 05:24:36 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 6AQ5OZZI725790
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 26 Nov 2026 00:24:35 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 6AQ5OZxJ725789;
	Thu, 26 Nov 2026 00:24:35 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 2/4] multipathd: add infrastructure for uxlsnr waiting on events
Date: Thu, 26 Nov 2026 00:24:32 -0500
Message-ID: <20261126052434.725762-3-bmarzins@redhat.com>
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3dP2cCzdI2NbEtFVLwCfO02XO4Fjdc0a4nqMiyxV3Vg_1795670677
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

There are multiple things that can happen to multipathd and the
devices it tracks, that multipathd only finishes handling later. User
programs may need to wait for these changes to complete before
continuing.

This commit add the architecture for waiting for events to occur. A
future patch will add the ability to actually register these wait
events. uxlnsr clients waiting for events will put themselves on a wait
list with wait_for_event(). If they exit early, they will take
themselves off with stop_waiting_for_event(). When the event occurs, the
thread processing the event will call wakeup_event_waiter() to remove
all clients from that wait list, and send a wakeup to the uslsnr thread.
This works via an eventfd, using the same code as idle_fd currently
does. Waiting clients check if their event has occured by checking if
they are still on a wait list.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c   |   7 +++
 multipathd/uxlsnr.c | 120 ++++++++++++++++++++++++++++++++++++++++----
 multipathd/uxlsnr.h |   4 ++
 3 files changed, 122 insertions(+), 9 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 9bce4d6b..1bb8eac8 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2009,6 +2009,12 @@ uxlsnrloop (void * ap)
 		goto out_sock;
 	}
 
+	if (init_wait_fd() < 0) {
+		condlog(1, "Failed to open wait_fd: %m");
+		exit_daemon();
+		goto out_sock;
+	}
+
 	/* Tell main thread that thread has started */
 	post_config_state(DAEMON_CONFIGURE);
 
@@ -3917,6 +3923,7 @@ static void cleanup_child(void)
 	cleanup_threads();
 	cleanup_vecs();
 	cleanup_bindings();
+	cleanup_wait_fd();
 	if (poll_dmevents)
 		cleanup_dmevent_waiter();
 
diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index e92784e5..09306918 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -49,11 +49,13 @@ enum {
 	CLT_PARSE,
 	CLT_LOCKED_WORK,
 	CLT_WORK,
+	CLT_WAIT,
 	CLT_SEND,
 };
 
 struct client {
 	struct list_head node;
+	struct list_head wait_node; /* for clients waiting on an event */
 	struct timespec expires;
 	int state;
 	int fd;
@@ -73,9 +75,13 @@ enum {
 	POLLFD_UX2,
 	POLLFD_NOTIFY,
 	POLLFD_IDLE,
+	POLLFD_WAIT,
 	POLLFDS_BASE,
 };
 
+/* Add a new revents value to signal that a waiter wakeup event occurred */
+#define POLLWAIT 0x10000
+
 #define POLLFD_CHUNK (4096 / sizeof(struct pollfd))
 /* Minimum number of pollfds to reserve for clients */
 #define MIN_POLLS (POLLFD_CHUNK - POLLFDS_BASE)
@@ -99,6 +105,8 @@ static LIST_HEAD(clients);
 static struct pollfd *polls;
 static int notify_fd = -1;
 static int idle_fd = -1;
+static int wait_fd = -1;
+static pthread_mutex_t client_wait_lock = PTHREAD_MUTEX_INITIALIZER;
 static bool clients_need_lock = false;
 
 static bool _socket_client_is_root(int fd)
@@ -116,6 +124,8 @@ static bool _socket_client_is_root(int fd)
 	return false;
 }
 
+static void stop_waiting_for_event(struct client *c);
+
 /*
  * kill off a dead client
  */
@@ -123,6 +133,7 @@ static void dead_client(struct client *c)
 {
 	int fd = c->fd;
 	list_del_init(&c->node);
+	stop_waiting_for_event(c);
 	c->fd = -1;
 	reset_strbuf(&c->reply);
 	if (c->cmdvec)
@@ -152,6 +163,7 @@ static void new_client(int ux_sock, int non_root_clients)
 		return;
 	}
 	INIT_LIST_HEAD(&c->node);
+	INIT_LIST_HEAD(&c->wait_node);
 	c->fd = fd;
 	c->state = CLT_RECV;
 	c->is_root = _socket_client_is_root(c->fd);
@@ -384,6 +396,21 @@ static int execute_handler(struct client *c, struct vectors *vecs)
 	return c->handler->fn(c->cmdvec, &c->reply, vecs);
 }
 
+int init_wait_fd(void)
+{
+	wait_fd = eventfd(0, EFD_NONBLOCK | EFD_CLOEXEC);
+
+	if (wait_fd < 0)
+		return -1;
+	return 0;
+}
+
+void cleanup_wait_fd(void)
+{
+	if (wait_fd >= 0)
+		close(wait_fd);
+}
+
 static void wakeup_listener(int event_fd)
 {
 	uint64_t one = 1;
@@ -397,6 +424,55 @@ static void wakeup_idle_listener(void)
 	wakeup_listener(idle_fd);
 }
 
+void wait_for_event(struct list_head *wait_node, struct list_head *wait_list)
+{
+	pthread_mutex_lock(&client_wait_lock);
+	list_add(wait_node, wait_list);
+	pthread_mutex_unlock(&client_wait_lock);
+}
+
+void wakeup_event_waiter(struct list_head *wait_list)
+{
+	bool have_waiter = false;
+
+	pthread_mutex_lock(&client_wait_lock);
+	while (list_pop(wait_list))
+		have_waiter = true;
+	pthread_mutex_unlock(&client_wait_lock);
+	if (have_waiter)
+		wakeup_listener(wait_fd);
+}
+
+/* must only be called by uxlsnr_thr */
+static void stop_waiting_for_event(struct client *c)
+{
+	/*
+	 * As long as clients will only be added to wait lists by uxlsnr_thr
+	 * and only removed with list_del_init(), it is safe to check if
+	 * wait_node is empty without holding client_wait_lock. uxlsnr_thr
+	 * can't miss a client being added to the list, since a process is
+	 * guaranteed to see all memory changes it did. It can miss a client
+	 * being removed from the list or see a torn write from a concurrent
+	 * removal, but this will just cause it to unnecessarily grab the lock
+	 * and redo the removal.
+	 */
+	if (!list_empty(&c->wait_node)) {
+		pthread_mutex_lock(&client_wait_lock);
+		list_del_init(&c->wait_node);
+		pthread_mutex_unlock(&client_wait_lock);
+	}
+}
+
+static bool finished_waiting(struct client *c)
+{
+	bool ret;
+
+	pthread_mutex_lock(&client_wait_lock);
+	ret = list_empty(&c->wait_node);
+	pthread_mutex_unlock(&client_wait_lock);
+	return ret;
+}
+
 static void drain_event_fd(int event_fd)
 {
 	uint64_t val;
@@ -466,8 +542,7 @@ enum {
 	STM_BREAK,
 };
 
-static int client_state_machine(struct client *c, struct vectors *vecs,
-				short revents)
+static int client_state_machine(struct client *c, struct vectors *vecs, int revents)
 {
 	ssize_t n;
 
@@ -549,8 +624,15 @@ static int client_state_machine(struct client *c, struct vectors *vecs,
 			check_for_locked_work(c);
 			pthread_cleanup_pop(1);
 			condlog(4, "%s: cli[%d] grabbed lock", __func__, c->fd);
-			set_client_state(c, CLT_SEND);
-			/* Wait for POLLOUT */
+			/*
+			 * This list_empty() is safe to test without a lock for
+			 * the same reason as in stop_waiting_for_event().
+			 */
+			if (!c->error && !list_empty(&c->wait_node))
+				set_client_state(c, CLT_WAIT);
+			else
+				set_client_state(c, CLT_SEND);
+			/* Wait for POLLOUT or POLLWAIT */
 			return STM_BREAK;
 		} else {
 			condlog(4, "%s: cli[%d] waiting for lock", __func__, c->fd);
@@ -559,8 +641,18 @@ static int client_state_machine(struct client *c, struct vectors *vecs,
 
 	case CLT_WORK:
 		c->error = execute_handler(c, vecs);
-		set_client_state(c, CLT_SEND);
-		/* Wait for POLLOUT */
+		if (!c->error && !list_empty(&c->wait_node))
+			set_client_state(c, CLT_WAIT);
+		else
+			set_client_state(c, CLT_SEND);
+		/* Wait for POLLOUT or POLLWAIT */
+		return STM_BREAK;
+
+	case CLT_WAIT:
+		if (!(revents & POLLWAIT))
+			return STM_BREAK;
+		if (finished_waiting(c))
+			set_client_state(c, CLT_SEND);
 		return STM_BREAK;
 
 	case CLT_SEND:
@@ -617,10 +709,11 @@ static void check_timeout(struct client *c)
 		c->fd, (long)c->expires.tv_sec, c->expires.tv_nsec / 1000000);
 
 	c->error = -ETIMEDOUT;
+	stop_waiting_for_event(c);
 	set_client_state(c, CLT_SEND);
 }
 
-static void handle_client(struct client *c, struct vectors *vecs, short revents)
+static void handle_client(struct client *c, struct vectors *vecs, int revents)
 {
 	if (revents & (POLLHUP|POLLERR)) {
 		c->error = -ECONNRESET;
@@ -677,6 +770,7 @@ void *uxsock_listen(int n_socks, long *ux_sock_in, void *trigger_data)
 	sigdelset(&mask, SIGHUP);
 	sigdelset(&mask, SIGUSR1);
 	while (1) {
+		int wait_event = 0;
 		struct client *c, *tmp;
 		int i, n_pfds, poll_count, num_clients, non_root_clients;
 		struct timespec __timeout, *timeout;
@@ -733,6 +827,9 @@ void *uxsock_listen(int n_socks, long *ux_sock_in, void *trigger_data)
 		else
 			polls[POLLFD_IDLE].events = 0;
 
+		polls[POLLFD_WAIT].fd = wait_fd;
+		polls[POLLFD_WAIT].events = POLLIN;
+
 		/* setup the clients */
 		i = POLLFDS_BASE;
 		list_for_each_entry(c, &clients, node) {
@@ -775,13 +872,18 @@ void *uxsock_listen(int n_socks, long *ux_sock_in, void *trigger_data)
 		    polls[POLLFD_IDLE].revents & POLLIN)
 			drain_event_fd(idle_fd);
 
+		if (polls[POLLFD_WAIT].revents & POLLIN) {
+			drain_event_fd(wait_fd);
+			wait_event = POLLWAIT;
+		}
+
 		/* see if a client needs handling */
 		list_for_each_entry_safe(c, tmp, &clients, node) {
-			short revents = 0;
+			int revents = wait_event;
 
 			for (i = POLLFDS_BASE; i < n_pfds; i++) {
 				if (polls[i].fd == c->fd) {
-					revents = polls[i].revents;
+					revents |= polls[i].revents;
 					break;
 				}
 			}
diff --git a/multipathd/uxlsnr.h b/multipathd/uxlsnr.h
index a331e23b..d33920ea 100644
--- a/multipathd/uxlsnr.h
+++ b/multipathd/uxlsnr.h
@@ -6,5 +6,9 @@
 bool waiting_clients(void);
 void uxsock_cleanup(void *arg);
 void *uxsock_listen(int n_socks, long *ux_sock, void *trigger_data);
+int init_wait_fd(void);
+void cleanup_wait_fd(void);
+void wait_for_event(struct list_head *wait_node, struct list_head *wait_list);
+void wakeup_event_waiter(struct list_head *wait_list);
 
 #endif
-- 
2.56.0

