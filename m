Return-Path: <SRS0=cnJz=DX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E081C433E7
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 10:45:30 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id AEF4D2084C
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 10:45:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AEF4D2084C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-346-Y_UQaBODMxiS5N5pnbxCVQ-1; Fri, 16 Oct 2020 06:45:26 -0400
X-MC-Unique: Y_UQaBODMxiS5N5pnbxCVQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B0357803F42;
	Fri, 16 Oct 2020 10:45:21 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8FEEA26164;
	Fri, 16 Oct 2020 10:45:21 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 66A3C58111;
	Fri, 16 Oct 2020 10:45:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09GAjJWh020684 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 16 Oct 2020 06:45:19 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 4064B2166B28; Fri, 16 Oct 2020 10:45:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3272A2156A38
	for <dm-devel@redhat.com>; Fri, 16 Oct 2020 10:45:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BC566182360F
	for <dm-devel@redhat.com>; Fri, 16 Oct 2020 10:45:16 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-566-3ibBHodjNduwSoiZbrM3rQ-1;
	Fri, 16 Oct 2020 06:45:11 -0400
X-MC-Unique: 3ibBHodjNduwSoiZbrM3rQ-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 68B2FAF2C;
	Fri, 16 Oct 2020 10:45:10 +0000 (UTC)
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 16 Oct 2020 12:44:33 +0200
Message-Id: <20201016104501.8700-2-mwilck@suse.com>
In-Reply-To: <20201016104501.8700-1-mwilck@suse.com>
References: <20201016104501.8700-1-mwilck@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 09GAjJWh020684
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v2 01/29] multipathd: uxlsnr: avoid deadlock on
	exit
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

The uxlsnr wouldn't always release the client lock when cancelled,
causing a deadlock in uxsock_cleanup(). While this hasn't been
caused by commit 3d611a2, the deadlock seems to have become much
more likely after that patch. Solving this means that we have to
treat reallocation failure of the pollfd array differently.
We will now just ignore any clients above the last valid pfd index.
That's a minor problem, as we're in an OOM situation anyway.

Moreover, client_lock is not a "struct lock", but a plain
pthread_mutex_t.

Fixes: 3d611a2 ("multipathd: cancel threads early during shutdown")
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/uxlsnr.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index 1c5ce9d..ce2b680 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -35,6 +35,7 @@
 #include "config.h"
 #include "mpath_cmd.h"
 #include "time-util.h"
+#include "util.h"
 
 #include "main.h"
 #include "cli.h"
@@ -116,7 +117,7 @@ static void _dead_client(struct client *c)
 
 static void dead_client(struct client *c)
 {
-	pthread_cleanup_push(cleanup_lock, &client_lock);
+	pthread_cleanup_push(cleanup_mutex, &client_lock);
 	pthread_mutex_lock(&client_lock);
 	_dead_client(c);
 	pthread_cleanup_pop(1);
@@ -302,10 +303,11 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, long ux_sock,
 	sigdelset(&mask, SIGUSR1);
 	while (1) {
 		struct client *c, *tmp;
-		int i, poll_count, num_clients;
+		int i, n_pfds, poll_count, num_clients;
 
 		/* setup for a poll */
 		pthread_mutex_lock(&client_lock);
+		pthread_cleanup_push(cleanup_mutex, &client_lock);
 		num_clients = 0;
 		list_for_each_entry(c, &clients, node) {
 			num_clients++;
@@ -322,14 +324,13 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, long ux_sock,
 						sizeof(struct pollfd));
 			}
 			if (!new) {
-				pthread_mutex_unlock(&client_lock);
 				condlog(0, "%s: failed to realloc %d poll fds",
 					"uxsock", 2 + num_clients);
-				sched_yield();
-				continue;
+				num_clients = old_clients;
+			} else {
+				old_clients = num_clients;
+				polls = new;
 			}
-			old_clients = num_clients;
-			polls = new;
 		}
 		polls[0].fd = ux_sock;
 		polls[0].events = POLLIN;
@@ -347,11 +348,14 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, long ux_sock,
 			polls[i].fd = c->fd;
 			polls[i].events = POLLIN;
 			i++;
+			if (i >= 2 + num_clients)
+				break;
 		}
-		pthread_mutex_unlock(&client_lock);
+		n_pfds = i;
+		pthread_cleanup_pop(1);
 
 		/* most of our life is spent in this call */
-		poll_count = ppoll(polls, i, &sleep_time, &mask);
+		poll_count = ppoll(polls, n_pfds, &sleep_time, &mask);
 
 		handle_signals(false);
 		if (poll_count == -1) {
@@ -384,7 +388,7 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, long ux_sock,
 		}
 
 		/* see if a client wants to speak to us */
-		for (i = 2; i < num_clients + 2; i++) {
+		for (i = 2; i < n_pfds; i++) {
 			if (polls[i].revents & POLLIN) {
 				struct timespec start_time;
 
-- 
2.28.0


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

