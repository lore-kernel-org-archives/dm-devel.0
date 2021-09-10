Return-Path: <SRS0=FvAS=OA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E62F3C433FE
	for <dm-devel@archiver.kernel.org>; Fri, 10 Sep 2021 11:43:36 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8C7F561153
	for <dm-devel@archiver.kernel.org>; Fri, 10 Sep 2021 11:43:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8C7F561153
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-456-ZGezlTfKPDSMXfS6VC0isA-1; Fri, 10 Sep 2021 07:43:33 -0400
X-MC-Unique: ZGezlTfKPDSMXfS6VC0isA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A40B33630F;
	Fri, 10 Sep 2021 11:43:28 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 83E2919C79;
	Fri, 10 Sep 2021 11:43:28 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5A3B14EA3D;
	Fri, 10 Sep 2021 11:43:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18ABh6G0010379 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 10 Sep 2021 07:43:06 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id E9C251FA840; Fri, 10 Sep 2021 11:43:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E45B61FA864
	for <dm-devel@redhat.com>; Fri, 10 Sep 2021 11:43:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CDAF71875067
	for <dm-devel@redhat.com>; Fri, 10 Sep 2021 11:43:05 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-490-RAxMra5sPn23BvEdFfp4sQ-1; Fri, 10 Sep 2021 07:43:03 -0400
X-MC-Unique: RAxMra5sPn23BvEdFfp4sQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A65CF20203;
	Fri, 10 Sep 2021 11:43:02 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 59A3D13D34;
	Fri, 10 Sep 2021 11:43:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id YKvRE8ZEO2GPOAAAMHmgww
	(envelope-from <mwilck@suse.com>); Fri, 10 Sep 2021 11:43:02 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 10 Sep 2021 13:41:19 +0200
Message-Id: <20210910114120.13665-35-mwilck@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 18ABh6G0010379
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, Chongyun Wu <wu.chongyun@h3c.com>,
	dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 34/35] multipathd: uxlsnr: drop client_lock
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

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/uxlsnr.c | 21 ++-------------------
 1 file changed, 2 insertions(+), 19 deletions(-)

diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index c18b2c4..7b763b6 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -89,7 +89,6 @@ enum {
 static __attribute__((unused)) char ___a[-(MIN_POLLS <= 0)];
 
 static LIST_HEAD(clients);
-static pthread_mutex_t client_lock = PTHREAD_MUTEX_INITIALIZER;
 static struct pollfd *polls;
 static int notify_fd = -1;
 static int idle_fd = -1;
@@ -150,15 +149,13 @@ static void new_client(int ux_sock)
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
@@ -170,14 +167,6 @@ static void _dead_client(struct client *c)
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
@@ -194,11 +183,9 @@ void uxsock_cleanup(void *arg)
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
@@ -668,8 +655,6 @@ void *uxsock_listen(long ux_sock, void *trigger_data)
 		struct timespec __timeout, *timeout;
 
 		/* setup for a poll */
-		pthread_mutex_lock(&client_lock);
-		pthread_cleanup_push(cleanup_mutex, &client_lock);
 		num_clients = 0;
 		list_for_each_entry(c, &clients, node) {
 			num_clients++;
@@ -738,8 +723,6 @@ void *uxsock_listen(long ux_sock, void *trigger_data)
                 n_pfds = i;
 		timeout = __get_soonest_timeout(&__timeout);
 
-		pthread_cleanup_pop(1);
-
 		/* most of our life is spent in this call */
 		poll_count = ppoll(polls, n_pfds, timeout, &mask);
 
-- 
2.33.0


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

