Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01A5EC433F5
	for <dm-devel@archiver.kernel.org>; Sat, 27 Nov 2021 15:20:44 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-222-uWECrXrbP4K4QTFIUXvKzQ-1; Sat, 27 Nov 2021 10:20:40 -0500
X-MC-Unique: uWECrXrbP4K4QTFIUXvKzQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C115A8042FA;
	Sat, 27 Nov 2021 15:20:35 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AAAA62B178;
	Sat, 27 Nov 2021 15:20:35 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8620E1809CB7;
	Sat, 27 Nov 2021 15:20:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ARFJrms032758 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 27 Nov 2021 10:19:53 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 7AA0E1121319; Sat, 27 Nov 2021 15:19:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 76CAC1121315
	for <dm-devel@redhat.com>; Sat, 27 Nov 2021 15:19:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5E4DF185A7B2
	for <dm-devel@redhat.com>; Sat, 27 Nov 2021 15:19:53 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-603-8sZZxSNCNIqgNas7f-bW2g-1; Sat, 27 Nov 2021 10:19:51 -0500
X-MC-Unique: 8sZZxSNCNIqgNas7f-bW2g-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 17C2C1FC9E;
	Sat, 27 Nov 2021 15:19:50 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C1BE713AAD;
	Sat, 27 Nov 2021 15:19:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id uJcoLZVMomErFgAAMHmgww
	(envelope-from <mwilck@suse.com>); Sat, 27 Nov 2021 15:19:49 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Sat, 27 Nov 2021 16:19:15 +0100
Message-Id: <20211127151929.7727-23-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1ARFJrms032758
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, Chongyun Wu <wu.chongyun@h3c.com>,
	dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v3 22/35] multipathd: uxlsnr: move client
	handling to separate function
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

No functional changes at this point. handle_client() will become
the state machine for handling client requests.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/uxlsnr.c | 67 ++++++++++++++++++++++-----------------------
 1 file changed, 32 insertions(+), 35 deletions(-)

diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index daa86c9..bfeb30d 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -394,14 +394,42 @@ static int uxsock_trigger(char *str, char **reply, int *len,
 	return r;
 }
 
+static void handle_client(struct client *c, void *trigger_data)
+{
+	int rlen;
+	char *inbuf, *reply;
+
+	if (recv_packet_from_client(c->fd, &inbuf, uxsock_timeout) != 0) {
+		dead_client(c);
+		return;
+	}
+
+	if (!inbuf) {
+		condlog(4, "recv_packet_from_client get null request");
+		return;
+	}
+
+	condlog(4, "cli[%d]: Got request [%s]", c->fd, inbuf);
+	uxsock_trigger(inbuf, &reply, &rlen,
+		       _socket_client_is_root(c->fd),
+		       trigger_data);
+
+	if (reply) {
+		if (send_packet(c->fd, reply) != 0)
+			dead_client(c);
+		else
+			condlog(4, "cli[%d]: Reply [%d bytes]", c->fd, rlen);
+		free(reply);
+		reply = NULL;
+	}
+	free(inbuf);
+}
+
 /*
  * entry point
  */
 void *uxsock_listen(long ux_sock, void *trigger_data)
 {
-	int rlen;
-	char *inbuf;
-	char *reply;
 	sigset_t mask;
 	int max_pfds = MIN_POLLS + POLLFDS_BASE;
 	/* conf->sequence_nr will be 1 when uxsock_listen is first called */
@@ -504,8 +532,6 @@ void *uxsock_listen(long ux_sock, void *trigger_data)
 		/* see if a client wants to speak to us */
 		for (i = POLLFDS_BASE; i < n_pfds; i++) {
 			if (polls[i].revents & (POLLIN|POLLHUP|POLLERR)) {
-				struct timespec start_time;
-
 				c = NULL;
 				pthread_mutex_lock(&client_lock);
 				list_for_each_entry(tmp, &clients, node) {
@@ -526,36 +552,7 @@ void *uxsock_listen(long ux_sock, void *trigger_data)
 					dead_client(c);
 					continue;
 				}
-				get_monotonic_time(&start_time);
-				if (recv_packet_from_client(c->fd, &inbuf,
-							    uxsock_timeout)
-				    != 0) {
-					dead_client(c);
-					continue;
-				}
-				if (!inbuf) {
-					condlog(4, "recv_packet_from_client "
-						"get null request");
-					continue;
-				}
-				condlog(4, "cli[%d]: Got request [%s]",
-					polls[i].fd, inbuf);
-				uxsock_trigger(inbuf, &reply, &rlen,
-					       _socket_client_is_root(c->fd),
-					       trigger_data);
-				if (reply) {
-					if (send_packet(c->fd,
-							reply) != 0) {
-						dead_client(c);
-					} else {
-						condlog(4, "cli[%d]: "
-							"Reply [%d bytes]",
-							polls[i].fd, rlen);
-					}
-					free(reply);
-					reply = NULL;
-				}
-				free(inbuf);
+				handle_client(c, trigger_data);
 			}
 		}
 		/* see if we got a non-fatal signal */
-- 
2.33.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

