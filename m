Return-Path: <SRS0=dXIA=QF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DF0CC433EF
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 23:06:04 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 17CEB61A79
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 23:06:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 17CEB61A79
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-564-cYRVQ-qLOkKi3JvGHO185g-1; Thu, 18 Nov 2021 18:06:01 -0500
X-MC-Unique: cYRVQ-qLOkKi3JvGHO185g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8A6D0A40C6;
	Thu, 18 Nov 2021 23:05:57 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 759021980E;
	Thu, 18 Nov 2021 23:05:57 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 51CF51832DD4;
	Thu, 18 Nov 2021 23:05:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AIMxBPs002214 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 18 Nov 2021 17:59:11 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id EF548400DFBC; Thu, 18 Nov 2021 22:59:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E9D3240CFD11
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 22:59:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CB4541066682
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 22:59:10 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-552-Nc8YcMKWM6-kS9xQDW31tw-1; Thu, 18 Nov 2021 17:59:09 -0500
X-MC-Unique: Nc8YcMKWM6-kS9xQDW31tw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BD216212CC;
	Thu, 18 Nov 2021 22:59:07 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7572613B11;
	Thu, 18 Nov 2021 22:59:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id 4EitGrvalmGHPAAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 18 Nov 2021 22:59:07 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 18 Nov 2021 23:58:23 +0100
Message-Id: <20211118225840.19810-32-mwilck@suse.com>
In-Reply-To: <20211118225840.19810-1-mwilck@suse.com>
References: <20211118225840.19810-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AIMxBPs002214
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, Chongyun Wu <wu.chongyun@h3c.com>,
	dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v2 31/48] multipathd: uxlsnr: add timeout handling
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/uxlsnr.c | 57 +++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 52 insertions(+), 5 deletions(-)

diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index bf9780d..45fe7b5 100644
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
 
@@ -580,6 +628,7 @@ void *uxsock_listen(long ux_sock, void *trigger_data)
 	while (1) {
 		struct client *c, *tmp;
 		int i, n_pfds, poll_count, num_clients;
+		struct timespec __timeout, *timeout;
 
 		/* setup for a poll */
 		pthread_mutex_lock(&client_lock);
@@ -647,10 +696,12 @@ void *uxsock_listen(long ux_sock, void *trigger_data)
                                 break;
                 }
                 n_pfds = i;
+		timeout = __get_soonest_timeout(&__timeout);
+
 		pthread_cleanup_pop(1);
 
 		/* most of our life is spent in this call */
-		poll_count = ppoll(polls, n_pfds, NULL, &mask);
+		poll_count = ppoll(polls, n_pfds, timeout, &mask);
 
 		handle_signals(false);
 		if (poll_count == -1) {
@@ -665,10 +716,6 @@ void *uxsock_listen(long ux_sock, void *trigger_data)
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

