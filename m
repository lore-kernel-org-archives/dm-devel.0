Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76238C433FE
	for <dm-devel@archiver.kernel.org>; Sat, 27 Nov 2021 15:20:55 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-54-dW-U0C7MO7yIRfOGhaAQeA-1; Sat, 27 Nov 2021 10:20:50 -0500
X-MC-Unique: dW-U0C7MO7yIRfOGhaAQeA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9B35739384;
	Sat, 27 Nov 2021 15:20:46 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 80A6119D9F;
	Sat, 27 Nov 2021 15:20:46 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5D4714A70C;
	Sat, 27 Nov 2021 15:20:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ARFJurb000382 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 27 Nov 2021 10:19:56 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4DB7E2166B2D; Sat, 27 Nov 2021 15:19:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 483E32166B25
	for <dm-devel@redhat.com>; Sat, 27 Nov 2021 15:19:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2EFE9801E6E
	for <dm-devel@redhat.com>; Sat, 27 Nov 2021 15:19:56 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-368-WbrlQBXJOSKj8rPGeZ9ttQ-1; Sat, 27 Nov 2021 10:19:50 -0500
X-MC-Unique: WbrlQBXJOSKj8rPGeZ9ttQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0535C217BA;
	Sat, 27 Nov 2021 15:19:49 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id AEBD313AAD;
	Sat, 27 Nov 2021 15:19:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id kO2aKJRMomErFgAAMHmgww
	(envelope-from <mwilck@suse.com>); Sat, 27 Nov 2021 15:19:48 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Sat, 27 Nov 2021 16:19:12 +0100
Message-Id: <20211127151929.7727-20-mwilck@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1ARFJurb000382
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, Chongyun Wu <wu.chongyun@h3c.com>,
	dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v3 19/35] multipathd: move uxsock_trigger() to
	uxlsnr.c
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

uxsock_trigger() really belongs into cli.c. I suppose that way back in
the past there were strong reasons to call this function via a
pointer. I don't think these reasons are valid any more. Moving
the function to cli.c allows restructuring the code.

No functional changes.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c   | 44 +-------------------------------------------
 multipathd/uxlsnr.c | 44 ++++++++++++++++++++++++++++++++++++++++++--
 multipathd/uxlsnr.h |  4 +---
 3 files changed, 44 insertions(+), 48 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 309c11e..cd9a127 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1536,48 +1536,6 @@ map_discovery (struct vectors * vecs)
 	return 0;
 }
 
-int
-uxsock_trigger (char * str, char ** reply, int * len, bool is_root,
-		void * trigger_data)
-{
-	struct vectors * vecs;
-	int r;
-
-	*reply = NULL;
-	*len = 0;
-	vecs = (struct vectors *)trigger_data;
-
-	if ((str != NULL) && (is_root == false) &&
-	    (strncmp(str, "list", strlen("list")) != 0) &&
-	    (strncmp(str, "show", strlen("show")) != 0)) {
-		*reply = strdup("permission deny: need to be root");
-		if (*reply)
-			*len = strlen(*reply) + 1;
-		return 1;
-	}
-
-	r = parse_cmd(str, reply, len, vecs, uxsock_timeout / 1000);
-
-	if (r > 0) {
-		if (r == ETIMEDOUT)
-			*reply = strdup("timeout\n");
-		else
-			*reply = strdup("fail\n");
-		if (*reply)
-			*len = strlen(*reply) + 1;
-		r = 1;
-	}
-	else if (!r && *len == 0) {
-		*reply = strdup("ok\n");
-		if (*reply)
-			*len = strlen(*reply) + 1;
-		r = 0;
-	}
-	/* else if (r < 0) leave *reply alone */
-
-	return r;
-}
-
 int
 uev_trigger (struct uevent * uev, void * trigger_data)
 {
@@ -1714,7 +1672,7 @@ uxlsnrloop (void * ap)
 	       == DAEMON_CONFIGURE)
 		handle_signals(false);
 
-	uxsock_listen(&uxsock_trigger, ux_sock, ap);
+	uxsock_listen(ux_sock, ap);
 
 out_sock:
 	pthread_cleanup_pop(1); /* uxsock_cleanup */
diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index 38a9d97..449f149 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -311,11 +311,51 @@ static void handle_inotify(int fd, struct watch_descriptors *wds)
 		condlog(1, "Multipath configuration updated.\nReload multipathd for changes to take effect");
 }
 
+static int uxsock_trigger(char *str, char **reply, int *len,
+			  bool is_root, void *trigger_data)
+{
+	struct vectors * vecs;
+	int r;
+
+	*reply = NULL;
+	*len = 0;
+	vecs = (struct vectors *)trigger_data;
+
+	if ((str != NULL) && (is_root == false) &&
+	    (strncmp(str, "list", strlen("list")) != 0) &&
+	    (strncmp(str, "show", strlen("show")) != 0)) {
+		*reply = strdup("permission deny: need to be root");
+		if (*reply)
+			*len = strlen(*reply) + 1;
+		return 1;
+	}
+
+	r = parse_cmd(str, reply, len, vecs, uxsock_timeout / 1000);
+
+	if (r > 0) {
+		if (r == ETIMEDOUT)
+			*reply = strdup("timeout\n");
+		else
+			*reply = strdup("fail\n");
+		if (*reply)
+			*len = strlen(*reply) + 1;
+		r = 1;
+	}
+	else if (!r && *len == 0) {
+		*reply = strdup("ok\n");
+		if (*reply)
+			*len = strlen(*reply) + 1;
+		r = 0;
+	}
+	/* else if (r < 0) leave *reply alone */
+
+	return r;
+}
+
 /*
  * entry point
  */
-void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, long ux_sock,
-		     void * trigger_data)
+void *uxsock_listen(long ux_sock, void *trigger_data)
 {
 	int rlen;
 	char *inbuf;
diff --git a/multipathd/uxlsnr.h b/multipathd/uxlsnr.h
index 18f008d..60c3a2c 100644
--- a/multipathd/uxlsnr.h
+++ b/multipathd/uxlsnr.h
@@ -3,10 +3,8 @@
 
 #include <stdbool.h>
 
-typedef int (uxsock_trigger_fn)(char *, char **, int *, bool, void *);
-
 void uxsock_cleanup(void *arg);
-void *uxsock_listen(uxsock_trigger_fn uxsock_trigger, long ux_sock,
+void *uxsock_listen(long ux_sock,
 		    void * trigger_data);
 
 #endif
-- 
2.33.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

