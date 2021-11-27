Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F546C433EF
	for <dm-devel@archiver.kernel.org>; Sat, 27 Nov 2021 15:22:43 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-561-rVh8Dxx-OB-VcsXDE_yEQg-1; Sat, 27 Nov 2021 10:22:39 -0500
X-MC-Unique: rVh8Dxx-OB-VcsXDE_yEQg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EBD3B801B29;
	Sat, 27 Nov 2021 15:22:34 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D73CF60854;
	Sat, 27 Nov 2021 15:22:34 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B59E11826D08;
	Sat, 27 Nov 2021 15:22:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ARFJrlh032749 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 27 Nov 2021 10:19:53 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 06C832166B2D; Sat, 27 Nov 2021 15:19:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 016A22166B25
	for <dm-devel@redhat.com>; Sat, 27 Nov 2021 15:19:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DA725811E78
	for <dm-devel@redhat.com>; Sat, 27 Nov 2021 15:19:52 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-94-JvgDaBGtPSS21LuNNFaayA-1; Sat, 27 Nov 2021 10:19:48 -0500
X-MC-Unique: JvgDaBGtPSS21LuNNFaayA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8F8BA1FD37;
	Sat, 27 Nov 2021 15:19:47 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DF0D113AAD;
	Sat, 27 Nov 2021 15:19:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id iIpANJJMomErFgAAMHmgww
	(envelope-from <mwilck@suse.com>); Sat, 27 Nov 2021 15:19:46 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Sat, 27 Nov 2021 16:19:08 +0100
Message-Id: <20211127151929.7727-16-mwilck@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1ARFJrlh032749
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, Chongyun Wu <wu.chongyun@h3c.com>,
	dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v3 15/35] multipathd: uxlsnr: handle client HUP
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

The unix socket listener thread doesn't even look at the revents
returned by poll() while the daemon is configuring. This may cause a
closed client socket to be kept open for a long time by the server,
while the listener basically performs a busy loop, as ppoll() always
returns immediately as long as the POLLHUP condition exists.

Worse, it can happen that multipathd reads data from such a closed
client socket after the client has disconnected. See the description
of POLLHUP in poll(2).

Close connections immediately if HUP is received.

Also, use the fd in log messages to identify the client rather
than the random index.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/uxlsnr.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index 400375c..9a6ab72 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -392,7 +392,7 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, long ux_sock,
 
 		/* see if a client wants to speak to us */
 		for (i = POLLFDS_BASE; i < n_pfds; i++) {
-			if (polls[i].revents & POLLIN) {
+			if (polls[i].revents & (POLLIN|POLLHUP|POLLERR)) {
 				struct timespec start_time;
 
 				c = NULL;
@@ -409,6 +409,12 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, long ux_sock,
 						i, polls[i].fd);
 					continue;
 				}
+				if (polls[i].revents & (POLLHUP|POLLERR)) {
+					condlog(4, "cli[%d]: Disconnected",
+						c->fd);
+					dead_client(c);
+					continue;
+				}
 				get_monotonic_time(&start_time);
 				if (recv_packet_from_client(c->fd, &inbuf,
 							    uxsock_timeout)
@@ -422,7 +428,7 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, long ux_sock,
 					continue;
 				}
 				condlog(4, "cli[%d]: Got request [%s]",
-					i, inbuf);
+					polls[i].fd, inbuf);
 				uxsock_trigger(inbuf, &reply, &rlen,
 					       _socket_client_is_root(c->fd),
 					       trigger_data);
@@ -433,7 +439,7 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, long ux_sock,
 					} else {
 						condlog(4, "cli[%d]: "
 							"Reply [%d bytes]",
-							i, rlen);
+							polls[i].fd, rlen);
 					}
 					free(reply);
 					reply = NULL;
-- 
2.33.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

