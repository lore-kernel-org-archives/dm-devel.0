Return-Path: <SRS0=FvAS=OA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F253EC433FE
	for <dm-devel@archiver.kernel.org>; Fri, 10 Sep 2021 11:43:33 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9269B60041
	for <dm-devel@archiver.kernel.org>; Fri, 10 Sep 2021 11:43:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9269B60041
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-178-SNJ237osMDWRk232_0AXoA-1; Fri, 10 Sep 2021 07:43:30 -0400
X-MC-Unique: SNJ237osMDWRk232_0AXoA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 343CC18B3133;
	Fri, 10 Sep 2021 11:43:21 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1268F19D9B;
	Fri, 10 Sep 2021 11:43:21 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DBA604EA37;
	Fri, 10 Sep 2021 11:43:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18ABh1eu010238 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 10 Sep 2021 07:43:01 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 421181FA840; Fri, 10 Sep 2021 11:43:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3D6EA63536
	for <dm-devel@redhat.com>; Fri, 10 Sep 2021 11:43:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 25FF2800B24
	for <dm-devel@redhat.com>; Fri, 10 Sep 2021 11:43:01 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-517-v_5g7LESOAa_NtMs4yo0kw-1; Fri, 10 Sep 2021 07:42:59 -0400
X-MC-Unique: v_5g7LESOAa_NtMs4yo0kw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C34D022428;
	Fri, 10 Sep 2021 11:42:57 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 00BDB13D34;
	Fri, 10 Sep 2021 11:42:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id CLN5OcBEO2GPOAAAMHmgww
	(envelope-from <mwilck@suse.com>); Fri, 10 Sep 2021 11:42:56 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 10 Sep 2021 13:41:05 +0200
Message-Id: <20210910114120.13665-21-mwilck@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 18ABh1eu010238
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, Chongyun Wu <wu.chongyun@h3c.com>,
	dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 20/35] multipathd: move uxsock_trigger() to
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

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c   | 44 +-------------------------------------------
 multipathd/uxlsnr.c | 44 ++++++++++++++++++++++++++++++++++++++++++--
 multipathd/uxlsnr.h |  4 +---
 3 files changed, 44 insertions(+), 48 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index c6357ef..ec4bcc3 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1526,48 +1526,6 @@ map_discovery (struct vectors * vecs)
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
-		*reply = STRDUP("permission deny: need to be root");
-		if (*reply)
-			*len = strlen(*reply) + 1;
-		return 1;
-	}
-
-	r = parse_cmd(str, reply, len, vecs, uxsock_timeout / 1000);
-
-	if (r > 0) {
-		if (r == ETIMEDOUT)
-			*reply = STRDUP("timeout\n");
-		else
-			*reply = STRDUP("fail\n");
-		if (*reply)
-			*len = strlen(*reply) + 1;
-		r = 1;
-	}
-	else if (!r && *len == 0) {
-		*reply = STRDUP("ok\n");
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
@@ -1704,7 +1662,7 @@ uxlsnrloop (void * ap)
 	       == DAEMON_CONFIGURE)
 		handle_signals(false);
 
-	uxsock_listen(&uxsock_trigger, ux_sock, ap);
+	uxsock_listen(ux_sock, ap);
 
 out_sock:
 	pthread_cleanup_pop(1); /* uxsock_cleanup */
diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index e701a1c..622aac1 100644
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
+		*reply = STRDUP("permission deny: need to be root");
+		if (*reply)
+			*len = strlen(*reply) + 1;
+		return 1;
+	}
+
+	r = parse_cmd(str, reply, len, vecs, uxsock_timeout / 1000);
+
+	if (r > 0) {
+		if (r == ETIMEDOUT)
+			*reply = STRDUP("timeout\n");
+		else
+			*reply = STRDUP("fail\n");
+		if (*reply)
+			*len = strlen(*reply) + 1;
+		r = 1;
+	}
+	else if (!r && *len == 0) {
+		*reply = STRDUP("ok\n");
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
2.33.0


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

