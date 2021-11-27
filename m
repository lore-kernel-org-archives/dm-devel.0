Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52878C433F5
	for <dm-devel@archiver.kernel.org>; Sat, 27 Nov 2021 15:20:35 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-349-7AMyN7CTPES9r5pNKiiXEQ-1; Sat, 27 Nov 2021 10:20:30 -0500
X-MC-Unique: 7AMyN7CTPES9r5pNKiiXEQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 83C281006AA4;
	Sat, 27 Nov 2021 15:20:26 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6CA6060854;
	Sat, 27 Nov 2021 15:20:26 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 81F004CA9B;
	Sat, 27 Nov 2021 15:20:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ARFJoAx032706 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 27 Nov 2021 10:19:50 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 37DC540CFD13; Sat, 27 Nov 2021 15:19:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 32E9740CFD07
	for <dm-devel@redhat.com>; Sat, 27 Nov 2021 15:19:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1B8ED80A0AC
	for <dm-devel@redhat.com>; Sat, 27 Nov 2021 15:19:50 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-380-SL7W0M6BNYq2PuXBtSLYLA-1; Sat, 27 Nov 2021 10:19:48 -0500
X-MC-Unique: SL7W0M6BNYq2PuXBtSLYLA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CFBF62170E;
	Sat, 27 Nov 2021 15:19:46 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 823A213AAD;
	Sat, 27 Nov 2021 15:19:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id sLF2HZJMomErFgAAMHmgww
	(envelope-from <mwilck@suse.com>); Sat, 27 Nov 2021 15:19:46 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Sat, 27 Nov 2021 16:19:07 +0100
Message-Id: <20211127151929.7727-15-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1ARFJoAx032706
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, Chongyun Wu <wu.chongyun@h3c.com>,
	dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v3 14/35] multipathd: uxlsnr: avoid stalled
	clients during reconfigure
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

Since 47cc1d3 ("multipathd: fix client response for socket
activation"), we hold back clients while reconfigure is running.
The idea of 47cc1d3 was to fix the behavior during initial
start up. When multipathd reconfigures itself during runtime,
and the reconfiguration takes a long time (a minute or more is
not unusual in big configurations), clients will time out with
no response ("timeout receiving packet"). Waiting for reconfigure
to finish breaks our timeout handling.

Therefore we should only apply the logic of 47cc1d3 during initial
configuration. In this case, the client that triggered socket
activation may still encounter a timeout, but there's not much we can
do about that.

Fixes: 47cc1d3 ("multipathd: fix client response for socket activation")
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c   |  9 +++++++++
 multipathd/uxlsnr.c | 12 ------------
 2 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 3062f3d..309c11e 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1705,6 +1705,15 @@ uxlsnrloop (void * ap)
 
 	init_handler_callbacks();
 	umask(077);
+
+	/*
+	 * Wait for initial reconfiguration to finish, while
+	 * hadling signals
+	 */
+	while (wait_for_state_change_if(DAEMON_CONFIGURE, 50)
+	       == DAEMON_CONFIGURE)
+		handle_signals(false);
+
 	uxsock_listen(&uxsock_trigger, ux_sock, ap);
 
 out_sock:
diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index 912c35b..400375c 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -390,18 +390,6 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, long ux_sock,
 			continue;
 		}
 
-		/*
-		 * Client connection. We shouldn't answer while we're
-		 * configuring - nothing may be configured yet.
-		 * But we can't wait forever either, because this thread
-		 * must handle signals. So wait a short while only.
-		 */
-		if (wait_for_state_change_if(DAEMON_CONFIGURE, 10)
-		    == DAEMON_CONFIGURE) {
-			handle_signals(false);
-			continue;
-		}
-
 		/* see if a client wants to speak to us */
 		for (i = POLLFDS_BASE; i < n_pfds; i++) {
 			if (polls[i].revents & POLLIN) {
-- 
2.33.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

