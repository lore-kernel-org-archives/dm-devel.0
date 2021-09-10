Return-Path: <SRS0=4gQq=OD=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61238C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 13 Sep 2021 06:40:26 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B9ED760FE6
	for <dm-devel@archiver.kernel.org>; Mon, 13 Sep 2021 06:40:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B9ED760FE6
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-397-d4Y9SsJ1PAeeJIXmAXo7ig-1; Mon, 13 Sep 2021 02:40:23 -0400
X-MC-Unique: d4Y9SsJ1PAeeJIXmAXo7ig-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F0EFD108468D;
	Mon, 13 Sep 2021 06:40:14 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BA05A5C25A;
	Mon, 13 Sep 2021 06:40:14 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 910314EA2A;
	Mon, 13 Sep 2021 06:40:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18ABh5gx010345 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 10 Sep 2021 07:43:05 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id DC56E1FA840; Fri, 10 Sep 2021 11:43:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D77A363536
	for <dm-devel@redhat.com>; Fri, 10 Sep 2021 11:43:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BC66D8934E0
	for <dm-devel@redhat.com>; Fri, 10 Sep 2021 11:43:04 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-486-GgpGjxJVP0qoNonQWAOnkg-1; Fri, 10 Sep 2021 07:43:02 -0400
X-MC-Unique: GgpGjxJVP0qoNonQWAOnkg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8BF8D20060;
	Fri, 10 Sep 2021 11:43:01 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 394B313D34;
	Fri, 10 Sep 2021 11:43:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id EAHoC8VEO2GPOAAAMHmgww
	(envelope-from <mwilck@suse.com>); Fri, 10 Sep 2021 11:43:01 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 10 Sep 2021 13:41:16 +0200
Message-Id: <20210910114120.13665-32-mwilck@suse.com>
In-Reply-To: <20210910114120.13665-1-mwilck@suse.com>
References: <20210910114120.13665-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 18ABh5gx010345
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 13 Sep 2021 02:39:51 -0400
Cc: lixiaokeng@huawei.com, Chongyun Wu <wu.chongyun@h3c.com>,
	dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 31/35] multipathd: uxlsnr: add idle notification
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

The previous patches added the state machine and the timeout handling,
but there was no wakeup mechanism for the uxlsnr for cases where
client connections were waiting for the vecs lock.

This patch uses the previously introduced wakeup mechanism of
struct mutex_lock for this purpose. Processes which unlock the
"global" vecs lock send an event in an eventfd which the uxlsnr
loop is polling for.

As we are now woken up for servicing client handlers that don't
wait for input but for the lock, we need to set up the pollfds
differently, and iterate over all clients when handling events,
not only over the ones that are receiving. The hangup handling
is changed, too. We have to look at every client, even if one has
hung up. Note that I don't take client_lock for the loop in
uxsock_listen(), it's not necessary and will be removed elsewhere
in a follow-up patch.

With this in place, the lock need not be taken in execute_handler()
any more. The uxlsnr only ever calls trylock() on the vecs lock,
avoiding any waiting for other threads to finish.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/uxlsnr.c | 211 ++++++++++++++++++++++++++++++--------------
 1 file changed, 143 insertions(+), 68 deletions(-)

diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index 553274b..4637954 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -24,6 +24,7 @@
 #include <signal.h>
 #include <stdbool.h>
 #include <sys/inotify.h>
+#include <sys/eventfd.h>
 #include "checkers.h"
 #include "memory.h"
 #include "debug.h"
@@ -70,6 +71,7 @@ struct client {
 enum {
 	POLLFD_UX = 0,
 	POLLFD_NOTIFY,
+	POLLFD_IDLE,
 	POLLFDS_BASE,
 };
 
@@ -90,8 +92,23 @@ static LIST_HEAD(clients);
 static pthread_mutex_t client_lock = PTHREAD_MUTEX_INITIALIZER;
 static struct pollfd *polls;
 static int notify_fd = -1;
+static int idle_fd = -1;
 static char *watch_config_dir;
 
+struct possible_lock {
+	struct mutex_lock *lock;
+	bool held;
+};
+
+static void unlock_if_held(void *arg)
+{
+	struct possible_lock *pl = arg;
+
+	/* don't call unlock_wakeup() here, lest we wakeup ourselves */
+	if (pl->held)
+		__unlock(pl->lock);
+}
+
 static bool _socket_client_is_root(int fd)
 {
 	socklen_t len = 0;
@@ -187,6 +204,17 @@ void uxsock_cleanup(void *arg)
 	free_polls();
 }
 
+void wakeup_cleanup(void *arg)
+{
+	struct mutex_lock *lck = arg;
+	int fd = idle_fd;
+
+	idle_fd = -1;
+	set_wakeup_fn(lck, NULL);
+	if (fd != -1)
+		close(fd);
+}
+
 struct watch_descriptors {
 	int conf_wd;
 	int dir_wd;
@@ -293,6 +321,18 @@ static void handle_inotify(int fd, struct watch_descriptors *wds)
 
 static const struct timespec ts_zero = { .tv_sec = 0, };
 
+/* call with clients lock held */
+static bool __need_lock(void)
+{
+	struct client *c;
+
+	list_for_each_entry(c, &clients, node) {
+		if (c->state == CLT_WAIT_LOCK)
+			return true;
+	}
+	return false;
+}
+
 static int parse_cmd(struct client *c)
 {
 	int r;
@@ -310,40 +350,31 @@ static int parse_cmd(struct client *c)
 	return r;
 }
 
-static int execute_handler(struct client *c, struct vectors *vecs, int timeout)
+static int execute_handler(struct client *c, struct vectors *vecs)
 {
-	int r;
-	struct timespec tmo;
 
-	if (!c->handler)
+	if (!c->handler || !c->handler->fn)
 		return -EINVAL;
 
-	if (clock_gettime(CLOCK_REALTIME, &tmo) == 0) {
-		tmo.tv_sec += timeout;
-	} else {
-		tmo.tv_sec = 0;
-	}
+	return c->handler->fn(c->cmdvec, &c->reply, vecs);
+}
 
-	if (c->handler->locked) {
-		int locked = 0;
+static void wakeup_listener(void)
+{
+	uint64_t one = 1;
 
-		pthread_cleanup_push(cleanup_lock, &vecs->lock);
-		if (tmo.tv_sec) {
-			r = timedlock(&vecs->lock, &tmo);
-		} else {
-			lock(&vecs->lock);
-			r = 0;
-		}
-		if (r == 0) {
-			locked = 1;
-			pthread_testcancel();
-			r = c->handler->fn(c->cmdvec, &c->reply, vecs);
-		}
-		pthread_cleanup_pop(locked);
-	} else
-		r = c->handler->fn(c->cmdvec, &c->reply, vecs);
+	if (idle_fd != -1 &&
+	    write(idle_fd, &one, sizeof(one)) != sizeof(one))
+		condlog(1, "%s: failed", __func__);
+}
 
-	return r;
+static void drain_idle_fd(int fd)
+{
+	uint64_t val;
+	int rc;
+
+	rc = read(fd, &val, sizeof(val));
+	condlog(4, "%s: %d, %"PRIu64, __func__, rc, val);
 }
 
 void default_reply(struct client *c, int r)
@@ -391,15 +422,26 @@ static void set_client_state(struct client *c, int state)
 	c->state = state;
 }
 
-static void handle_client(struct client *c, struct vectors *vecs)
+static void handle_client(struct client *c, struct vectors *vecs, short revents)
 {
 	ssize_t n;
+	struct possible_lock pl = {
+		.lock = &vecs->lock,
+		.held = false,
+	};
 
-	condlog(4, "%s: cli[%d] state=%d cmd=\"%s\" repl \"%s\"", __func__,
-		c->fd, c->state, c->cmd, get_strbuf_str(&c->reply));
+	if (revents & (POLLHUP|POLLERR)) {
+		c->error = -ECONNRESET;
+		return;
+	}
+
+	condlog(4, "%s: cli[%d] poll=%x state=%d cmd=\"%s\" repl \"%s\"", __func__,
+		c->fd, revents, c->state, c->cmd, get_strbuf_str(&c->reply));
 
 	switch (c->state) {
 	case CLT_RECV:
+		if (!(revents & POLLIN))
+			return;
 		if (c->cmd_len == 0) {
 			/*
 			 * We got POLLIN; assume that at least the length can
@@ -463,15 +505,28 @@ static void handle_client(struct client *c, struct vectors *vecs)
 	case CLT_WAIT_LOCK:
 		condlog(4, "%s: cli[%d] state=%d cmd=\"%s\" repl \"%s\"", __func__,
 			c->fd, c->state, c->cmd, get_strbuf_str(&c->reply));
-		/* tbd */
+
+		if (c->error == 0 && c->handler && c->handler->locked) {
+			pl.held = trylock(pl.lock) == 0;
+			if (!pl.held) {
+				condlog(4, "%s: cli[%d] waiting for lock",
+					__func__, c->fd);
+				return;
+			} else
+				condlog(4, "%s: cli[%d] grabbed lock",
+					__func__, c->fd);
+		}
 		set_client_state(c, CLT_WORK);
 		/* fallthrough */
 
 	case CLT_WORK:
 		condlog(4, "%s: cli[%d] state=%d cmd=\"%s\" repl \"%s\"", __func__,
 			c->fd, c->state, c->cmd, get_strbuf_str(&c->reply));
-		if (c->error == 0 && c->handler)
-			c->error = execute_handler(c, vecs, uxsock_timeout / 1000);
+		if (c->error == 0 && c->handler) {
+			pthread_cleanup_push(unlock_if_held, &pl);
+			c->error = execute_handler(c, vecs);
+			pthread_cleanup_pop(1);
+		}
 
 		if (c->cmdvec) {
 			free_keys(c->cmdvec);
@@ -511,6 +566,8 @@ void *uxsock_listen(long ux_sock, void *trigger_data)
 	/* conf->sequence_nr will be 1 when uxsock_listen is first called */
 	unsigned int sequence_nr = 0;
 	struct watch_descriptors wds = { .conf_wd = -1, .dir_wd = -1 };
+	bool need_lock = false;
+	struct vectors *vecs = trigger_data;
 
 	condlog(3, "uxsock: startup listener");
 	polls = MALLOC(max_pfds * sizeof(*polls));
@@ -521,6 +578,14 @@ void *uxsock_listen(long ux_sock, void *trigger_data)
 	notify_fd = inotify_init1(IN_NONBLOCK);
 	if (notify_fd == -1) /* it's fine if notifications fail */
 		condlog(3, "failed to start up configuration notifications");
+
+	pthread_cleanup_push(wakeup_cleanup, &vecs->lock);
+	idle_fd = eventfd(0, EFD_NONBLOCK|EFD_CLOEXEC);
+	if (idle_fd == -1)
+		condlog(1, "failed to create idle fd");
+	else
+		set_wakeup_fn(&vecs->lock, wakeup_listener);
+
 	sigfillset(&mask);
 	sigdelset(&mask, SIGINT);
 	sigdelset(&mask, SIGTERM);
@@ -572,16 +637,30 @@ void *uxsock_listen(long ux_sock, void *trigger_data)
 		else
 			polls[POLLFD_NOTIFY].events = POLLIN;
 
+		need_lock = __need_lock();
+		polls[POLLFD_IDLE].fd = idle_fd;
+		if (need_lock)
+			polls[POLLFD_IDLE].events = POLLIN;
+		else
+			polls[POLLFD_IDLE].events = 0;
+
 		/* setup the clients */
-		i = POLLFDS_BASE;
-		list_for_each_entry(c, &clients, node) {
-			polls[i].fd = c->fd;
-			polls[i].events = POLLIN;
-			i++;
-			if (i >= max_pfds)
-				break;
-		}
-		n_pfds = i;
+                i = POLLFDS_BASE;
+                list_for_each_entry(c, &clients, node) {
+                        switch(c->state) {
+                        case CLT_RECV:
+                                polls[i].events = POLLIN;
+                                break;
+                        default:
+				/* don't poll for this client */
+                                continue;
+                        }
+                        polls[i].fd = c->fd;
+                        i++;
+                        if (i >= max_pfds)
+                                break;
+                }
+                n_pfds = i;
 		pthread_cleanup_pop(1);
 
 		/* most of our life is spent in this call */
@@ -604,33 +683,28 @@ void *uxsock_listen(long ux_sock, void *trigger_data)
 			handle_signals(true);
 			continue;
 		}
+		if (polls[POLLFD_IDLE].fd != -1 &&
+		    polls[POLLFD_IDLE].revents & POLLIN)
+			drain_idle_fd(idle_fd);
 
-		/* see if a client wants to speak to us */
-		for (i = POLLFDS_BASE; i < n_pfds; i++) {
-			if (polls[i].revents & (POLLIN|POLLHUP|POLLERR)) {
-				c = NULL;
-				pthread_mutex_lock(&client_lock);
-				list_for_each_entry(tmp, &clients, node) {
-					if (tmp->fd == polls[i].fd) {
-						c = tmp;
-						break;
-					}
-				}
-				pthread_mutex_unlock(&client_lock);
-				if (!c) {
-					condlog(4, "cli%d: new fd %d",
-						i, polls[i].fd);
-					continue;
-				}
-				if (polls[i].revents & (POLLHUP|POLLERR)) {
-					condlog(4, "cli[%d]: Disconnected",
-						c->fd);
-					dead_client(c);
-					continue;
-				}
-				handle_client(c, trigger_data);
-				if (c->error == -ECONNRESET)
-					dead_client(c);
+		/* see if a client needs handling */
+		list_for_each_entry_safe(c, tmp, &clients, node) {
+			short revents = 0;
+
+			for (i = POLLFDS_BASE; i < n_pfds; i++) {
+                                if (polls[i].fd == c->fd) {
+                                        revents = polls[i].revents;
+                                        break;
+                                }
+                        }
+
+			handle_client(c, trigger_data, revents);
+
+			if (c->error == -ECONNRESET) {
+				condlog(4, "cli[%d]: disconnected", c->fd);
+				dead_client(c);
+				if (i < n_pfds)
+					polls[i].fd = -1;
 			}
 		}
 		/* see if we got a non-fatal signal */
@@ -646,5 +720,6 @@ void *uxsock_listen(long ux_sock, void *trigger_data)
 			handle_inotify(notify_fd, &wds);
 	}
 
+	pthread_cleanup_pop(1);
 	return NULL;
 }
-- 
2.33.0


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

