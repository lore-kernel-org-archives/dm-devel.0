Return-Path: <SRS0=FvAS=OA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BA3EC433F5
	for <dm-devel@archiver.kernel.org>; Fri, 10 Sep 2021 11:43:37 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1784060041
	for <dm-devel@archiver.kernel.org>; Fri, 10 Sep 2021 11:43:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1784060041
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-557-NJ6-R3o_PO-VAPjh4iQ9cQ-1; Fri, 10 Sep 2021 07:43:33 -0400
X-MC-Unique: NJ6-R3o_PO-VAPjh4iQ9cQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1F9AC1005E4D;
	Fri, 10 Sep 2021 11:43:29 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 02D3460C82;
	Fri, 10 Sep 2021 11:43:29 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CD62F1832DD2;
	Fri, 10 Sep 2021 11:43:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18ABh29x010280 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 10 Sep 2021 07:43:02 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 76DAF20807F0; Fri, 10 Sep 2021 11:43:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 71F7F2079761
	for <dm-devel@redhat.com>; Fri, 10 Sep 2021 11:43:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5B0F2800883
	for <dm-devel@redhat.com>; Fri, 10 Sep 2021 11:43:02 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-164-wgvrt1bwM1iKutPuiZtrBQ-1; Fri, 10 Sep 2021 07:42:58 -0400
X-MC-Unique: wgvrt1bwM1iKutPuiZtrBQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2782A2243A;
	Fri, 10 Sep 2021 11:42:57 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9373E13EC8;
	Fri, 10 Sep 2021 11:42:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id eOnvIcBEO2GPOAAAMHmgww
	(envelope-from <mwilck@suse.com>); Fri, 10 Sep 2021 11:42:56 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 10 Sep 2021 13:41:04 +0200
Message-Id: <20210910114120.13665-20-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 18ABh29x010280
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, Chongyun Wu <wu.chongyun@h3c.com>,
	dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 19/35] multipathd: uxlsnr: data structure for
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
2.33.0


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

