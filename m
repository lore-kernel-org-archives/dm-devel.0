Return-Path: <SRS0=dXIA=QF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E635C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 23:06:19 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0A8B061A81
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 23:06:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0A8B061A81
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-197--c9L_izCOX6iYwufF_tdvg-1; Thu, 18 Nov 2021 18:06:13 -0500
X-MC-Unique: -c9L_izCOX6iYwufF_tdvg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 71734802E6B;
	Thu, 18 Nov 2021 23:06:08 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 599B0179B3;
	Thu, 18 Nov 2021 23:06:08 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 340E84EA31;
	Thu, 18 Nov 2021 23:06:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AIMxEeN002302 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 18 Nov 2021 17:59:14 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id EF228404727C; Thu, 18 Nov 2021 22:59:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EAD5A4047279
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 22:59:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D2299805F4A
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 22:59:13 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-17-dKfHbZN4OGiXrJk8qOx1OQ-1; Thu, 18 Nov 2021 17:59:09 -0500
X-MC-Unique: dKfHbZN4OGiXrJk8qOx1OQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 76AA61FD3B;
	Thu, 18 Nov 2021 22:59:08 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2E9B813B11;
	Thu, 18 Nov 2021 22:59:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id 4IZiCbzalmGHPAAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 18 Nov 2021 22:59:08 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 18 Nov 2021 23:58:25 +0100
Message-Id: <20211118225840.19810-34-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AIMxEeN002302
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, Chongyun Wu <wu.chongyun@h3c.com>,
	dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v2 33/48] multipathd: uxlsnr: drop client_lock
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

The list of clients is never changed anywhere except in
uxsock_listen(). No need to lock.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/uxlsnr.c | 33 ++++++---------------------------
 1 file changed, 6 insertions(+), 27 deletions(-)

diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index 6213454..24db377 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -89,7 +89,6 @@ enum {
 static __attribute__((unused)) char ___a[-(MIN_POLLS <= 0)];
 
 static LIST_HEAD(clients);
-static pthread_mutex_t client_lock = PTHREAD_MUTEX_INITIALIZER;
 static struct pollfd *polls;
 static int notify_fd = -1;
 static int idle_fd = -1;
@@ -136,15 +135,13 @@ static void new_client(int ux_sock)
 	c->is_root = _socket_client_is_root(c->fd);
 
 	/* put it in our linked list */
-	pthread_mutex_lock(&client_lock);
 	list_add_tail(&c->node, &clients);
-	pthread_mutex_unlock(&client_lock);
 }
 
 /*
  * kill off a dead client
  */
-static void _dead_client(struct client *c)
+static void dead_client(struct client *c)
 {
 	int fd = c->fd;
 	list_del_init(&c->node);
@@ -156,14 +153,6 @@ static void _dead_client(struct client *c)
 	close(fd);
 }
 
-static void dead_client(struct client *c)
-{
-	pthread_cleanup_push(cleanup_mutex, &client_lock);
-	pthread_mutex_lock(&client_lock);
-	_dead_client(c);
-	pthread_cleanup_pop(1);
-}
-
 static void free_polls (void)
 {
 	if (polls)
@@ -180,11 +169,9 @@ void uxsock_cleanup(void *arg)
 	close(notify_fd);
 	free(watch_config_dir);
 
-	pthread_mutex_lock(&client_lock);
 	list_for_each_entry_safe(client_loop, client_tmp, &clients, node) {
-		_dead_client(client_loop);
+		dead_client(client_loop);
 	}
-	pthread_mutex_unlock(&client_lock);
 
 	cli_exit();
 	free_polls();
@@ -308,8 +295,7 @@ static void handle_inotify(int fd, struct watch_descriptors *wds)
 static const struct timespec ts_zero = { .tv_sec = 0, };
 static const struct timespec ts_max = { .tv_sec = LONG_MAX, .tv_nsec = 999999999 };
 
-/* call with clients lock held */
-static struct timespec *__get_soonest_timeout(struct timespec *ts)
+static struct timespec *get_soonest_timeout(struct timespec *ts)
 {
 	struct timespec ts_min = ts_max, now;
 	bool any = false;
@@ -336,8 +322,7 @@ static struct timespec *__get_soonest_timeout(struct timespec *ts)
 	return ts;
 }
 
-/* call with clients lock held */
-static bool __need_vecs_lock(void)
+static bool need_vecs_lock(void)
 {
 	struct client *c;
 
@@ -614,7 +599,6 @@ void *uxsock_listen(long ux_sock, void *trigger_data)
 	/* conf->sequence_nr will be 1 when uxsock_listen is first called */
 	unsigned int sequence_nr = 0;
 	struct watch_descriptors wds = { .conf_wd = -1, .dir_wd = -1 };
-	bool need_lock = false;
 	struct vectors *vecs = trigger_data;
 
 	condlog(3, "uxsock: startup listener");
@@ -645,8 +629,6 @@ void *uxsock_listen(long ux_sock, void *trigger_data)
 		struct timespec __timeout, *timeout;
 
 		/* setup for a poll */
-		pthread_mutex_lock(&client_lock);
-		pthread_cleanup_push(cleanup_mutex, &client_lock);
 		num_clients = 0;
 		list_for_each_entry(c, &clients, node) {
 			num_clients++;
@@ -686,9 +668,8 @@ void *uxsock_listen(long ux_sock, void *trigger_data)
 		else
 			polls[POLLFD_NOTIFY].events = POLLIN;
 
-		need_lock = __need_vecs_lock();
 		polls[POLLFD_IDLE].fd = idle_fd;
-		if (need_lock)
+		if (need_vecs_lock())
 			polls[POLLFD_IDLE].events = POLLIN;
 		else
 			polls[POLLFD_IDLE].events = 0;
@@ -713,9 +694,7 @@ void *uxsock_listen(long ux_sock, void *trigger_data)
                                 break;
                 }
                 n_pfds = i;
-		timeout = __get_soonest_timeout(&__timeout);
-
-		pthread_cleanup_pop(1);
+		timeout = get_soonest_timeout(&__timeout);
 
 		/* most of our life is spent in this call */
 		poll_count = ppoll(polls, n_pfds, timeout, &mask);
-- 
2.33.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

