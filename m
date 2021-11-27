Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E146C433EF
	for <dm-devel@archiver.kernel.org>; Sat, 27 Nov 2021 15:22:52 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-602-xkqjxuLZONGWc3OL2jKsyw-1; Sat, 27 Nov 2021 10:22:49 -0500
X-MC-Unique: xkqjxuLZONGWc3OL2jKsyw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D044D801B24;
	Sat, 27 Nov 2021 15:22:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B69A86788F;
	Sat, 27 Nov 2021 15:22:45 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 94A151826D14;
	Sat, 27 Nov 2021 15:22:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ARFJuXJ000367 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 27 Nov 2021 10:19:56 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 192121121319; Sat, 27 Nov 2021 15:19:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 14C3F1121315
	for <dm-devel@redhat.com>; Sat, 27 Nov 2021 15:19:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F02BA185A7B2
	for <dm-devel@redhat.com>; Sat, 27 Nov 2021 15:19:55 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-153-XVwBeO0xOp6vNjvCVQEnhA-1; Sat, 27 Nov 2021 10:19:53 -0500
X-MC-Unique: XVwBeO0xOp6vNjvCVQEnhA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B01C81FD2A;
	Sat, 27 Nov 2021 15:19:52 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6418813AAD;
	Sat, 27 Nov 2021 15:19:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id cDFIFphMomErFgAAMHmgww
	(envelope-from <mwilck@suse.com>); Sat, 27 Nov 2021 15:19:52 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Sat, 27 Nov 2021 16:19:22 +0100
Message-Id: <20211127151929.7727-30-mwilck@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1ARFJuXJ000367
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, Chongyun Wu <wu.chongyun@h3c.com>,
	dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v3 29/35] multipathd: uxlsnr: merge
	uxsock_trigger() into state machine
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

This patch sets up the bulk of the state machine. client_state_machine()
is called in a loop, proceeding from state to state until it needs
to poll for input or wait for a lock, in which case it returns
STM_BREAK.

While doing this, switch to negative error codes for the functions
in uxlsnr.c (e.g. parse_cmd()). Positive return codes are reserved
for the cli_handler functions themselves. This way we can clearly
distinguish the error source, and avoid confusion and misleading
error messages. No cli_handler returns negative values.

Note: with this patch applied, clients may hang and time out if
the handler fails to acquire the vecs lock. This will be fixed in the
follow-up patch "multipathd: uxlsnr: add idle notification".

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/uxlsnr.c | 158 ++++++++++++++++++++++++--------------------
 1 file changed, 88 insertions(+), 70 deletions(-)

diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index 62b9fe5..c393477 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -299,22 +299,13 @@ static int parse_cmd(struct client *c)
 
 	r = get_cmdvec(c->cmd, &c->cmdvec);
 
-	if (r) {
-		genhelp_handler(c->cmd, r, &c->reply);
-		if (get_strbuf_len(&c->reply) == 0)
-			return EINVAL;
-		return 0;
-	}
+	if (r)
+		return -r;
 
 	c->handler = find_handler_for_cmdvec(c->cmdvec);
 
-	if (!c->handler || !c->handler->fn) {
-		genhelp_handler(c->cmd, EINVAL, &c->reply);
-		if (get_strbuf_len(&c->reply) == 0)
-			r = EINVAL;
-		else
-			r = 0;
-	}
+	if (!c->handler || !c->handler->fn)
+		return -EINVAL;
 
 	return r;
 }
@@ -325,7 +316,7 @@ static int execute_handler(struct client *c, struct vectors *vecs, int timeout)
 	struct timespec tmo;
 
 	if (!c->handler)
-		return EINVAL;
+		return -EINVAL;
 
 	if (clock_gettime(CLOCK_REALTIME, &tmo) == 0) {
 		tmo.tv_sec += timeout;
@@ -355,50 +346,30 @@ static int execute_handler(struct client *c, struct vectors *vecs, int timeout)
 	return r;
 }
 
-static int uxsock_trigger(struct client *c, void *trigger_data)
+void default_reply(struct client *c, int r)
 {
-	struct vectors * vecs;
-	int r = 1;
-
-	vecs = (struct vectors *)trigger_data;
-
-	r = parse_cmd(c);
-
-	if (r == 0 && c->cmdvec && VECTOR_SIZE(c->cmdvec) > 0) {
-		struct key *kw = VECTOR_SLOT(c->cmdvec, 0);
-
-		if (!c->is_root && kw->code != LIST)
-			r = EPERM;
-	}
-
-	if (r == 0 && c->handler)
-		r = execute_handler(c, vecs, uxsock_timeout / 1000);
-
-	if (c->cmdvec) {
-		free_keys(c->cmdvec);
-		c->cmdvec = NULL;
-	}
-
-	if (r > 0) {
-		switch(r) {
-		case ETIMEDOUT:
-			append_strbuf_str(&c->reply, "timeout\n");
-			break;
-		case EPERM:
-			append_strbuf_str(&c->reply,
-					  "permission deny: need to be root\n");
-			break;
-		default:
-			append_strbuf_str(&c->reply, "fail\n");
-			break;
-		}
-	}
-	else if (!r && get_strbuf_len(&c->reply) == 0) {
+	switch(r) {
+	case -EINVAL:
+	case -ESRCH:
+	case -ENOMEM:
+		/* return codes from get_cmdvec() */
+		genhelp_handler(c->cmd, -r, &c->reply);
+		break;
+	case -EPERM:
+		append_strbuf_str(&c->reply,
+				  "permission deny: need to be root\n");
+		break;
+	case -ETIMEDOUT:
+		append_strbuf_str(&c->reply, "timeout\n");
+		break;
+	case 0:
 		append_strbuf_str(&c->reply, "ok\n");
-		r = 0;
+		break;
+	default:
+		/* cli_handler functions return 1 on unspecified error */
+		append_strbuf_str(&c->reply, "fail\n");
+		break;
 	}
-	/* else if (r < 0) leave *reply alone */
-	return r;
 }
 
 static void set_client_state(struct client *c, int state)
@@ -409,6 +380,7 @@ static void set_client_state(struct client *c, int state)
 		reset_strbuf(&c->reply);
 		memset(c->cmd, '\0', sizeof(c->cmd));
 		c->expires = ts_zero;
+		c->error = 0;
 		/* fallthrough */
 	case CLT_SEND:
 		/* reuse these fields for next data transfer */
@@ -420,9 +392,18 @@ static void set_client_state(struct client *c, int state)
 	c->state = state;
 }
 
-static void handle_client(struct client *c, void *trigger_data)
+enum {
+	STM_CONT,
+	STM_BREAK,
+};
+
+static int client_state_machine(struct client *c, struct vectors *vecs)
 {
 	ssize_t n;
+	const char *buf;
+
+	condlog(4, "%s: cli[%d] state=%d cmd=\"%s\" repl \"%s\"", __func__,
+		c->fd, c->state, c->cmd, get_strbuf_str(&c->reply));
 
 	switch (c->state) {
 	case CLT_RECV:
@@ -449,31 +430,59 @@ static void handle_client(struct client *c, void *trigger_data)
 				condlog(4, "%s: cli[%d]: connected", __func__, c->fd);
 			}
 			/* poll for data */
-			return;
+			return STM_BREAK;
 		} else if (c->len < c->cmd_len) {
 			n = recv(c->fd, c->cmd + c->len, c->cmd_len - c->len, 0);
 			if (n <= 0 && errno != EINTR && errno != EAGAIN) {
 				condlog(1, "%s: cli[%d]: error in recv: %m",
 					__func__, c->fd);
 				c->error = -ECONNRESET;
-				return;
+				return STM_BREAK;
 			}
 			c->len += n;
 			if (c->len < c->cmd_len)
 				/* continue polling */
-				return;
-			set_client_state(c, CLT_PARSE);
+				return STM_BREAK;
 		}
-		break;
-	default:
-		break;
-	}
+		condlog(4, "cli[%d]: Got request [%s]", c->fd, c->cmd);
+		set_client_state(c, CLT_PARSE);
+		return STM_CONT;
 
-	condlog(4, "cli[%d]: Got request [%s]", c->fd, c->cmd);
-	uxsock_trigger(c, trigger_data);
+	case CLT_PARSE:
+		c->error = parse_cmd(c);
+		if (!c->error) {
+			/* Permission check */
+			struct key *kw = VECTOR_SLOT(c->cmdvec, 0);
 
-	if (get_strbuf_len(&c->reply) > 0) {
-		const char *buf = get_strbuf_str(&c->reply);
+			if (!c->is_root && kw->code != LIST) {
+				c->error = -EPERM;
+				condlog(0, "%s: cli[%d]: unauthorized cmd \"%s\"",
+					__func__, c->fd, c->cmd);
+			}
+		}
+		if (c->error)
+			set_client_state(c, CLT_SEND);
+		else
+			set_client_state(c, CLT_WORK);
+		return STM_CONT;
+
+	case CLT_LOCKED_WORK:
+		/* tbd */
+		set_client_state(c, CLT_WORK);
+		return STM_CONT;
+
+	case CLT_WORK:
+		c->error = execute_handler(c, vecs, uxsock_timeout / 1000);
+		free_keys(c->cmdvec);
+		c->cmdvec = NULL;
+		set_client_state(c, CLT_SEND);
+		return STM_CONT;
+
+	case CLT_SEND:
+		if (get_strbuf_len(&c->reply) == 0)
+			default_reply(c, c->error);
+
+		buf = get_strbuf_str(&c->reply);
 
 		if (send_packet(c->fd, buf) != 0)
 			dead_client(c);
@@ -481,9 +490,18 @@ static void handle_client(struct client *c, void *trigger_data)
 			condlog(4, "cli[%d]: Reply [%zu bytes]", c->fd,
 				get_strbuf_len(&c->reply) + 1);
 		reset_strbuf(&c->reply);
-	}
 
-	set_client_state(c, CLT_RECV);
+		set_client_state(c, CLT_RECV);
+		return STM_BREAK;
+
+	default:
+		return STM_BREAK;
+	}
+}
+
+static void handle_client(struct client *c, struct vectors *vecs)
+{
+	while (client_state_machine(c, vecs) == STM_CONT);
 }
 
 /*
-- 
2.33.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

