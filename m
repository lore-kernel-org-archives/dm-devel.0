Return-Path: <SRS0=g9U1=FU=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66DC9C2BBCD
	for <dm-devel@archiver.kernel.org>; Wed, 16 Dec 2020 18:19:15 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D639E25CBA
	for <dm-devel@archiver.kernel.org>; Wed, 16 Dec 2020 18:19:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D639E25CBA
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-61-4rIBiIINPM2_C4URO3sXKQ-1; Wed, 16 Dec 2020 13:19:11 -0500
X-MC-Unique: 4rIBiIINPM2_C4URO3sXKQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3C36B107AD3A;
	Wed, 16 Dec 2020 18:19:05 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 202F460861;
	Wed, 16 Dec 2020 18:19:05 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E440650035;
	Wed, 16 Dec 2020 18:19:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BGIIe2d018105 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 16 Dec 2020 13:18:40 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 75A252166B2C; Wed, 16 Dec 2020 18:18:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 70F3D2166B27
	for <dm-devel@redhat.com>; Wed, 16 Dec 2020 18:18:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5D87A8039DD
	for <dm-devel@redhat.com>; Wed, 16 Dec 2020 18:18:40 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-558-KxPl49DqM6eAS_VbbSAFJg-1;
	Wed, 16 Dec 2020 13:18:37 -0500
X-MC-Unique: KxPl49DqM6eAS_VbbSAFJg-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id B87F4B1A3;
	Wed, 16 Dec 2020 18:18:35 +0000 (UTC)
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Wed, 16 Dec 2020 19:17:07 +0100
Message-Id: <20201216181708.22224-29-mwilck@suse.com>
In-Reply-To: <20201216181708.22224-1-mwilck@suse.com>
References: <20201216181708.22224-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0BGIIe2d018105
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v3 28/29] multipathd: sanitize uxsock_listen()
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

We were allocating 1025 poll fds, which is weird. Change it to a power of two,
and make this more easily customizable in general. Use POLLFDS_BASE rather
than the hard-coded "2" for the number of fds we poll besides client
connections.  Introduce a maximum number of clients that can connect. When
this number is reached, we simply stop polling the accept socket, so that new
connections aren't accepted any more.  Don't attempt to realloc() the pollfd
array if the number of clients decreases. It's unlikely to ever be more than
one or two pages. Finally, there's no need to wake up every 5s. Our signal
handling is robust. Just sleep forever in ppoll() if nothing happens.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/uxlsnr.c | 70 ++++++++++++++++++++++++++++-----------------
 1 file changed, 43 insertions(+), 27 deletions(-)

diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index ce2b680..cd462b6 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -41,14 +41,25 @@
 #include "cli.h"
 #include "uxlsnr.h"
 
-static struct timespec sleep_time = {5, 0};
-
 struct client {
 	struct list_head node;
 	int fd;
 };
 
-#define MIN_POLLS 1023
+/* The number of fds we poll on, other than individual client connections */
+#define POLLFDS_BASE 2
+#define POLLFD_CHUNK (4096 / sizeof(struct pollfd))
+/* Minimum mumber of pollfds to reserve for clients */
+#define MIN_POLLS (POLLFD_CHUNK - POLLFDS_BASE)
+/*
+ * Max number of client connections allowed
+ * During coldplug, there may be a large number of "multipath -u"
+ * processes connecting.
+ */
+#define MAX_CLIENTS (16384 - POLLFDS_BASE)
+
+/* Compile-time error if POLLFD_CHUNK is too small */
+static __attribute__((unused)) char ___a[-(MIN_POLLS <= 0)];
 
 static LIST_HEAD(clients);
 static pthread_mutex_t client_lock = PTHREAD_MUTEX_INITIALIZER;
@@ -282,13 +293,13 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, long ux_sock,
 	char *inbuf;
 	char *reply;
 	sigset_t mask;
-	int old_clients = MIN_POLLS;
+	int max_pfds = MIN_POLLS + POLLFDS_BASE;
 	/* conf->sequence_nr will be 1 when uxsock_listen is first called */
 	unsigned int sequence_nr = 0;
 	struct watch_descriptors wds = { .conf_wd = -1, .dir_wd = -1 };
 
 	condlog(3, "uxsock: startup listener");
-	polls = (struct pollfd *)MALLOC((MIN_POLLS + 2) * sizeof(struct pollfd));
+	polls = MALLOC(max_pfds * sizeof(*polls));
 	if (!polls) {
 		condlog(0, "uxsock: failed to allocate poll fds");
 		exit_daemon();
@@ -312,28 +323,33 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, long ux_sock,
 		list_for_each_entry(c, &clients, node) {
 			num_clients++;
 		}
-		if (num_clients != old_clients) {
+		if (num_clients + POLLFDS_BASE > max_pfds) {
 			struct pollfd *new;
-			if (num_clients <= MIN_POLLS && old_clients > MIN_POLLS) {
-				new = REALLOC(polls, (2 + MIN_POLLS) *
-						sizeof(struct pollfd));
-			} else if (num_clients <= MIN_POLLS && old_clients <= MIN_POLLS) {
-				new = polls;
-			} else {
-				new = REALLOC(polls, (2 + num_clients) *
-						sizeof(struct pollfd));
-			}
-			if (!new) {
-				condlog(0, "%s: failed to realloc %d poll fds",
-					"uxsock", 2 + num_clients);
-				num_clients = old_clients;
-			} else {
-				old_clients = num_clients;
+			int n_new = max_pfds + POLLFD_CHUNK;
+
+			new = REALLOC(polls, n_new * sizeof(*polls));
+			if (new) {
+				max_pfds = n_new;
 				polls = new;
+			} else {
+				condlog(1, "%s: realloc failure, %d clients not served",
+					__func__,
+					num_clients + POLLFDS_BASE - max_pfds);
+				num_clients = max_pfds - POLLFDS_BASE;
 			}
 		}
-		polls[0].fd = ux_sock;
-		polls[0].events = POLLIN;
+		if (num_clients < MAX_CLIENTS) {
+			polls[0].fd = ux_sock;
+			polls[0].events = POLLIN;
+		} else {
+			/*
+			 * New clients can't connect, num_clients won't grow
+			 * to MAX_CLIENTS or higher
+			 */
+			condlog(1, "%s: max client connections reached, pausing polling",
+				__func__);
+			polls[0].fd = -1;
+		}
 
 		reset_watch(notify_fd, &wds, &sequence_nr);
 		if (notify_fd == -1 || (wds.conf_wd == -1 && wds.dir_wd == -1))
@@ -343,19 +359,19 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, long ux_sock,
 		polls[1].events = POLLIN;
 
 		/* setup the clients */
-		i = 2;
+		i = POLLFDS_BASE;
 		list_for_each_entry(c, &clients, node) {
 			polls[i].fd = c->fd;
 			polls[i].events = POLLIN;
 			i++;
-			if (i >= 2 + num_clients)
+			if (i >= max_pfds)
 				break;
 		}
 		n_pfds = i;
 		pthread_cleanup_pop(1);
 
 		/* most of our life is spent in this call */
-		poll_count = ppoll(polls, n_pfds, &sleep_time, &mask);
+		poll_count = ppoll(polls, n_pfds, NULL, &mask);
 
 		handle_signals(false);
 		if (poll_count == -1) {
@@ -388,7 +404,7 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, long ux_sock,
 		}
 
 		/* see if a client wants to speak to us */
-		for (i = 2; i < n_pfds; i++) {
+		for (i = POLLFDS_BASE; i < n_pfds; i++) {
 			if (polls[i].revents & POLLIN) {
 				struct timespec start_time;
 
-- 
2.29.0


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

