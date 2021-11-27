Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF31DC433EF
	for <dm-devel@archiver.kernel.org>; Sat, 27 Nov 2021 15:23:01 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-578-RkPkWO2PN8S_G-lI1_5Nbg-1; Sat, 27 Nov 2021 10:22:57 -0500
X-MC-Unique: RkPkWO2PN8S_G-lI1_5Nbg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 610A4801564;
	Sat, 27 Nov 2021 15:22:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4651019724;
	Sat, 27 Nov 2021 15:22:53 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 222CA1826D19;
	Sat, 27 Nov 2021 15:22:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ARFJxfJ000435 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 27 Nov 2021 10:20:00 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id CBF7D2166B2D; Sat, 27 Nov 2021 15:19:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C688E2166B25
	for <dm-devel@redhat.com>; Sat, 27 Nov 2021 15:19:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AE058801212
	for <dm-devel@redhat.com>; Sat, 27 Nov 2021 15:19:59 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-326-xsMULVUKPsWb3RmGr5uUnA-1; Sat, 27 Nov 2021 10:19:55 -0500
X-MC-Unique: xsMULVUKPsWb3RmGr5uUnA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8AE78212CA;
	Sat, 27 Nov 2021 15:19:54 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3EAB213AAD;
	Sat, 27 Nov 2021 15:19:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id 0OkzDZpMomErFgAAMHmgww
	(envelope-from <mwilck@suse.com>); Sat, 27 Nov 2021 15:19:54 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Sat, 27 Nov 2021 16:19:27 +0100
Message-Id: <20211127151929.7727-35-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1ARFJxfJ000435
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, Chongyun Wu <wu.chongyun@h3c.com>,
	dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v3 33/35] multipathd: uxlsnr: drop client_lock
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

The list of clients is never changed anywhere except in
uxsock_listen(). No need to lock.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/uxlsnr.c | 32 ++++++--------------------------
 1 file changed, 6 insertions(+), 26 deletions(-)

diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index c5da569..07a484c 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -88,7 +88,6 @@ enum {
 static __attribute__((unused)) char ___a[-(MIN_POLLS <= 0)];
 
 static LIST_HEAD(clients);
-static pthread_mutex_t client_lock = PTHREAD_MUTEX_INITIALIZER;
 static struct pollfd *polls;
 static int notify_fd = -1;
 static int idle_fd = -1;
@@ -135,15 +134,13 @@ static void new_client(int ux_sock)
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
@@ -155,14 +152,6 @@ static void _dead_client(struct client *c)
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
 
@@ -616,7 +601,6 @@ void *uxsock_listen(long ux_sock, void *trigger_data)
 	/* conf->sequence_nr will be 1 when uxsock_listen is first called */
 	unsigned int sequence_nr = 0;
 	struct watch_descriptors wds = { .conf_wd = -1, .dir_wd = -1 };
-	bool need_lock = false;
 	struct vectors *vecs = trigger_data;
 
 	condlog(3, "uxsock: startup listener");
@@ -648,8 +632,6 @@ void *uxsock_listen(long ux_sock, void *trigger_data)
 		struct timespec __timeout, *timeout;
 
 		/* setup for a poll */
-		pthread_mutex_lock(&client_lock);
-		pthread_cleanup_push(cleanup_mutex, &client_lock);
 		num_clients = 0;
 		list_for_each_entry(c, &clients, node) {
 			num_clients++;
@@ -689,9 +671,8 @@ void *uxsock_listen(long ux_sock, void *trigger_data)
 		else
 			polls[POLLFD_NOTIFY].events = POLLIN;
 
-		need_lock = __need_vecs_lock();
 		polls[POLLFD_IDLE].fd = idle_fd;
-		if (need_lock)
+		if (need_vecs_lock())
 			polls[POLLFD_IDLE].events = POLLIN;
 		else
 			polls[POLLFD_IDLE].events = 0;
@@ -716,8 +697,7 @@ void *uxsock_listen(long ux_sock, void *trigger_data)
 				break;
 		}
 		n_pfds = i;
-		timeout = __get_soonest_timeout(&__timeout);
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

