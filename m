Return-Path: <SRS0=dXIA=QF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F32A6C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 23:03:17 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9491361A86
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 23:03:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9491361A86
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-523-ex7LvfESMtiqllj2Ukf58Q-1; Thu, 18 Nov 2021 18:03:12 -0500
X-MC-Unique: ex7LvfESMtiqllj2Ukf58Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ED50010168C3;
	Thu, 18 Nov 2021 23:03:07 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D19C060BF1;
	Thu, 18 Nov 2021 23:03:07 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A952F4EA2F;
	Thu, 18 Nov 2021 23:03:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AIMx7e3002085 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 18 Nov 2021 17:59:07 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E309C400DFBC; Thu, 18 Nov 2021 22:59:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DE29740CFD11
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 22:59:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C77FB805B0A
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 22:59:06 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-506-XWVH0utROUO-DqsINKsRiA-1; Thu, 18 Nov 2021 17:59:04 -0500
X-MC-Unique: XWVH0utROUO-DqsINKsRiA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 37CD01FD38;
	Thu, 18 Nov 2021 22:59:03 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D9E3A13B11;
	Thu, 18 Nov 2021 22:59:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id 2DA3M7balmGHPAAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 18 Nov 2021 22:59:02 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 18 Nov 2021 23:58:10 +0100
Message-Id: <20211118225840.19810-19-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AIMx7e3002085
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, Chongyun Wu <wu.chongyun@h3c.com>,
	dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v2 18/48] multipathd: uxlsnr: data structure for
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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
 multipathd/uxlsnr.c | 27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index 98a9f71..e701a1c 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -40,10 +40,30 @@
 #include "main.h"
 #include "cli.h"
 #include "uxlsnr.h"
+#include "strbuf.h"
+
+/* state of client connection */
+enum {
+	CLT_RECV,
+	CLT_PARSE,
+	CLT_WAIT_LOCK,
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
@@ -104,14 +124,14 @@ static void new_client(int ux_sock)
 	if (fd == -1)
 		return;
 
-	c = (struct client *)MALLOC(sizeof(*c));
+	c = calloc(1, sizeof(*c));
 	if (!c) {
 		close(fd);
 		return;
 	}
-	memset(c, 0, sizeof(*c));
 	INIT_LIST_HEAD(&c->node);
 	c->fd = fd;
+	c->state = CLT_RECV;
 
 	/* put it in our linked list */
 	pthread_mutex_lock(&client_lock);
@@ -127,6 +147,9 @@ static void _dead_client(struct client *c)
 	int fd = c->fd;
 	list_del_init(&c->node);
 	c->fd = -1;
+	reset_strbuf(&c->reply);
+	if (c->cmdvec)
+		free_keys(c->cmdvec);
 	FREE(c);
 	close(fd);
 }
-- 
2.33.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

