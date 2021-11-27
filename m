Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9CE5C4332F
	for <dm-devel@archiver.kernel.org>; Sat, 27 Nov 2021 15:20:48 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-560-2XqbzRsGPDS45yXnR50TCA-1; Sat, 27 Nov 2021 10:20:44 -0500
X-MC-Unique: 2XqbzRsGPDS45yXnR50TCA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9B8EA39392;
	Sat, 27 Nov 2021 15:20:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8240B5D740;
	Sat, 27 Nov 2021 15:20:40 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5DC364A708;
	Sat, 27 Nov 2021 15:20:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ARFJsJ2000319 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 27 Nov 2021 10:19:54 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 5A97640CFD13; Sat, 27 Nov 2021 15:19:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 55D0340CFD07
	for <dm-devel@redhat.com>; Sat, 27 Nov 2021 15:19:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3D16985A5B5
	for <dm-devel@redhat.com>; Sat, 27 Nov 2021 15:19:54 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-543-F3GyNGPYOsOIVQQtIE30Kw-1; Sat, 27 Nov 2021 10:19:49 -0500
X-MC-Unique: F3GyNGPYOsOIVQQtIE30Kw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A25E71FD38;
	Sat, 27 Nov 2021 15:19:48 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5453F13AAD;
	Sat, 27 Nov 2021 15:19:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id YDltEpRMomErFgAAMHmgww
	(envelope-from <mwilck@suse.com>); Sat, 27 Nov 2021 15:19:48 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Sat, 27 Nov 2021 16:19:11 +0100
Message-Id: <20211127151929.7727-19-mwilck@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1ARFJsJ2000319
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, Chongyun Wu <wu.chongyun@h3c.com>,
	dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v3 18/35] multipathd: uxlsnr: data structure for
	stateful client connection
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Currently the uxlsnr handles each client request (receive requset -
handle request - respond) in a single loop iteration. This has
severe disadvantages. In particular, the code may wait in poll()
called from read_all(), or wait for the vecs lock, while other
clients are ready to be serviced or signals to be handled.

This patch adds some fields to "struct client" which will be used
by later patches to change this into a state machine that basically
waits only in place, the ppoll() call in uxsock_listen().

For now, we just introduce and initialize the fields.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/uxlsnr.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index 7bbec29..38a9d97 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -39,10 +39,30 @@
 #include "main.h"
 #include "cli.h"
 #include "uxlsnr.h"
+#include "strbuf.h"
+
+/* state of client connection */
+enum {
+	CLT_RECV,
+	CLT_PARSE,
+	CLT_LOCKED_WORK,
+	CLT_WORK,
+	CLT_SEND,
+};
 
 struct client {
 	struct list_head node;
+	struct timespec expires;
+	int state;
 	int fd;
+	vector cmdvec;
+	/* NUL byte at end */
+	char cmd[_MAX_CMD_LEN + 1];
+	struct strbuf reply;
+	struct handler *handler;
+	size_t cmd_len, len;
+	int error;
+	bool is_root;
 };
 
 /* Indices for array of poll fds */
@@ -110,6 +130,7 @@ static void new_client(int ux_sock)
 	}
 	INIT_LIST_HEAD(&c->node);
 	c->fd = fd;
+	c->state = CLT_RECV;
 
 	/* put it in our linked list */
 	pthread_mutex_lock(&client_lock);
@@ -125,6 +146,9 @@ static void _dead_client(struct client *c)
 	int fd = c->fd;
 	list_del_init(&c->node);
 	c->fd = -1;
+	reset_strbuf(&c->reply);
+	if (c->cmdvec)
+		free_keys(c->cmdvec);
 	free(c);
 	close(fd);
 }
-- 
2.33.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

