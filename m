Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5F65C433EF
	for <dm-devel@archiver.kernel.org>; Sat, 27 Nov 2021 15:20:57 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-383-2GCIb799OSuZOEPqtJKktQ-1; Sat, 27 Nov 2021 10:20:53 -0500
X-MC-Unique: 2GCIb799OSuZOEPqtJKktQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A453E1006AA3;
	Sat, 27 Nov 2021 15:20:48 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8AD7FADC8;
	Sat, 27 Nov 2021 15:20:48 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 670E44A70D;
	Sat, 27 Nov 2021 15:20:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ARFJvAm000401 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 27 Nov 2021 10:19:57 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id EF04E51E3; Sat, 27 Nov 2021 15:19:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E964F51DC
	for <dm-devel@redhat.com>; Sat, 27 Nov 2021 15:19:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D058D185A7B2
	for <dm-devel@redhat.com>; Sat, 27 Nov 2021 15:19:56 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-281-wqqjaSmjNbydq7W3PGZeGA-1; Sat, 27 Nov 2021 10:19:55 -0500
X-MC-Unique: wqqjaSmjNbydq7W3PGZeGA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CC18C2170C;
	Sat, 27 Nov 2021 15:19:53 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8132B13AAD;
	Sat, 27 Nov 2021 15:19:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id kFF5HZlMomErFgAAMHmgww
	(envelope-from <mwilck@suse.com>); Sat, 27 Nov 2021 15:19:53 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Sat, 27 Nov 2021 16:19:25 +0100
Message-Id: <20211127151929.7727-33-mwilck@suse.com>
In-Reply-To: <20211127151929.7727-1-mwilck@suse.com>
References: <20211127151929.7727-1-mwilck@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1ARFJvAm000401
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, Chongyun Wu <wu.chongyun@h3c.com>,
	dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v3 31/35] rmultipathd: uxlsnr: add timeout
	handling
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Our ppoll() call needs to wake up when a client request times out.
This logic can be added by determining the first client that's about
to time out. The logic in handle_client() will then cause a timeout
reply to be sent to the client. This is more client-friendly
as the client timing out without receiving a reply.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/uxlsnr.c | 56 +++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 51 insertions(+), 5 deletions(-)

diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index f559a23..1ebcf10 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -306,6 +306,35 @@ static void handle_inotify(int fd, struct watch_descriptors *wds)
 }
 
 static const struct timespec ts_zero = { .tv_sec = 0, };
+static const struct timespec ts_max = { .tv_sec = LONG_MAX, .tv_nsec = 999999999 };
+
+/* call with clients lock held */
+static struct timespec *__get_soonest_timeout(struct timespec *ts)
+{
+	struct timespec ts_min = ts_max, now;
+	bool any = false;
+	struct client *c;
+
+	list_for_each_entry(c, &clients, node) {
+		if (timespeccmp(&c->expires, &ts_zero) != 0 &&
+		    timespeccmp(&c->expires, &ts_min) < 0) {
+			ts_min = c->expires;
+			any = true;
+		}
+	}
+
+	if (!any)
+		return NULL;
+
+	get_monotonic_time(&now);
+	timespecsub(&ts_min, &now, ts);
+	if (timespeccmp(ts, &ts_zero) < 0)
+		*ts = ts_zero;
+
+	condlog(4, "%s: next client expires in %ld.%03lds", __func__,
+		(long)ts->tv_sec, ts->tv_nsec / 1000000);
+	return ts;
+}
 
 /* call with clients lock held */
 static bool __need_vecs_lock(void)
@@ -532,6 +561,24 @@ static int client_state_machine(struct client *c, struct vectors *vecs,
 	}
 }
 
+static void check_timeout(struct client *c)
+{
+	struct timespec now;
+
+	if (timespeccmp(&c->expires, &ts_zero) == 0)
+		return;
+
+	get_monotonic_time(&now);
+	if (timespeccmp(&c->expires, &now) > 0)
+		return;
+
+	condlog(2, "%s: cli[%d]: timed out at %ld.%03ld", __func__,
+		c->fd, (long)c->expires.tv_sec, c->expires.tv_nsec / 1000000);
+
+	c->error = -ETIMEDOUT;
+	set_client_state(c, CLT_SEND);
+}
+
 static void handle_client(struct client *c, struct vectors *vecs, short revents)
 {
 	if (revents & (POLLHUP|POLLERR)) {
@@ -539,6 +586,7 @@ static void handle_client(struct client *c, struct vectors *vecs, short revents)
 		return;
 	}
 
+	check_timeout(c);
         while (client_state_machine(c, vecs, revents) == STM_CONT);
 }
 
@@ -581,6 +629,7 @@ void *uxsock_listen(long ux_sock, void *trigger_data)
 	while (1) {
 		struct client *c, *tmp;
 		int i, n_pfds, poll_count, num_clients;
+		struct timespec __timeout, *timeout;
 
 		/* setup for a poll */
 		pthread_mutex_lock(&client_lock);
@@ -648,10 +697,11 @@ void *uxsock_listen(long ux_sock, void *trigger_data)
 				break;
 		}
 		n_pfds = i;
+		timeout = __get_soonest_timeout(&__timeout);
 		pthread_cleanup_pop(1);
 
 		/* most of our life is spent in this call */
-		poll_count = ppoll(polls, n_pfds, NULL, &mask);
+		poll_count = ppoll(polls, n_pfds, timeout, &mask);
 
 		handle_signals(false);
 		if (poll_count == -1) {
@@ -666,10 +716,6 @@ void *uxsock_listen(long ux_sock, void *trigger_data)
 			break;
 		}
 
-		if (poll_count == 0) {
-			handle_signals(true);
-			continue;
-		}
 		if (polls[POLLFD_IDLE].fd != -1 &&
 		    polls[POLLFD_IDLE].revents & POLLIN)
 			drain_idle_fd(idle_fd);
-- 
2.33.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

