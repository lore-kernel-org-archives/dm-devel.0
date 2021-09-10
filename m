Return-Path: <SRS0=FvAS=OA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFE6EC4332F
	for <dm-devel@archiver.kernel.org>; Fri, 10 Sep 2021 11:43:45 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6E5AA61153
	for <dm-devel@archiver.kernel.org>; Fri, 10 Sep 2021 11:43:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6E5AA61153
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-506-53pnBGOkOl6CvqpsZL8hRw-1; Fri, 10 Sep 2021 07:43:43 -0400
X-MC-Unique: 53pnBGOkOl6CvqpsZL8hRw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 63DC784A5EC;
	Fri, 10 Sep 2021 11:43:38 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4231919C79;
	Fri, 10 Sep 2021 11:43:38 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1B5021832DDE;
	Fri, 10 Sep 2021 11:43:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18ABh6T5010396 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 10 Sep 2021 07:43:06 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 5284720BC8F4; Fri, 10 Sep 2021 11:43:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4D74420BC8F1
	for <dm-devel@redhat.com>; Fri, 10 Sep 2021 11:43:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 33247811E80
	for <dm-devel@redhat.com>; Fri, 10 Sep 2021 11:43:06 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-292-mWoyXsjKPGq-7et1k-bdxA-1; Fri, 10 Sep 2021 07:43:02 -0400
X-MC-Unique: mWoyXsjKPGq-7et1k-bdxA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2A84E22434;
	Fri, 10 Sep 2021 11:43:01 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CFFF813D34;
	Fri, 10 Sep 2021 11:43:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id 2GKUMMREO2GPOAAAMHmgww
	(envelope-from <mwilck@suse.com>); Fri, 10 Sep 2021 11:43:00 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 10 Sep 2021 13:41:15 +0200
Message-Id: <20210910114120.13665-31-mwilck@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 18ABh6T5010396
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, Chongyun Wu <wu.chongyun@h3c.com>,
	dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 30/35] multipathd: uxlsnr: merge uxsock_trigger()
	into state machine
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

This patch sets up the bulk of the state machine. The idea is to
fall through the case labels as long as possible (when steps succeed)
and return to the caller if either an error occurs, or it becomes
necessary to wait for some pollable condition.

While doing this, switch to negative error codes for the functions
in uxlsnr.c (e.g. parse_cmd()). Positive return codes are reserved
for the cli_handler functions themselves. This way we can clearly
distinguish the error source, and avoid confusion and misleading
error messages. No cli_handler returns negative values.

Note: with this patch applied, clients may hang and time out if
the handler fails to acquire the vecs lock. This will be fixed in the
follow-up patch "multipathd: uxlsnr: add idle notification".

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/uxlsnr.c | 145 ++++++++++++++++++++++++--------------------
 1 file changed, 80 insertions(+), 65 deletions(-)

diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index ff9604f..553274b 100644
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
@@ -355,50 +346,29 @@ static int execute_handler(struct client *c, struct vectors *vecs, int timeout)
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
+		genhelp_handler(c->cmd, r, &c->reply);
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
+		append_strbuf_str(&c->reply, "fail\n");
+		break;
 	}
-	/* else if (r < 0) leave *reply alone */
-	return r;
 }
 
 static void set_client_state(struct client *c, int state)
@@ -409,6 +379,7 @@ static void set_client_state(struct client *c, int state)
 		reset_strbuf(&c->reply);
 		memset(c->cmd, '\0', sizeof(c->cmd));
 		c->expires = ts_zero;
+		c->error = 0;
 		/* fallthrough */
 	case CLT_SEND:
 		/* reuse these fields for next data transfer */
@@ -420,10 +391,13 @@ static void set_client_state(struct client *c, int state)
 	c->state = state;
 }
 
-static void handle_client(struct client *c, void *trigger_data)
+static void handle_client(struct client *c, struct vectors *vecs)
 {
 	ssize_t n;
 
+	condlog(4, "%s: cli[%d] state=%d cmd=\"%s\" repl \"%s\"", __func__,
+		c->fd, c->state, c->cmd, get_strbuf_str(&c->reply));
+
 	switch (c->state) {
 	case CLT_RECV:
 		if (c->cmd_len == 0) {
@@ -464,15 +438,52 @@ static void handle_client(struct client *c, void *trigger_data)
 				return;
 			set_client_state(c, CLT_PARSE);
 		}
-		break;
-	default:
-		break;
-	}
+		condlog(4, "cli[%d]: Got request [%s]", c->fd, c->cmd);
+		/* fallthrough */
 
-	condlog(4, "cli[%d]: Got request [%s]", c->fd, c->cmd);
-	uxsock_trigger(c, trigger_data);
+	case CLT_PARSE:
+		condlog(4, "%s: cli[%d] state=%d cmd=\"%s\" repl \"%s\"", __func__,
+			c->fd, c->state, c->cmd,  get_strbuf_str(&c->reply));
+		c->error = parse_cmd(c);
+
+		/* Permission check */
+		if (c->error == 0 && c->cmdvec && VECTOR_SIZE(c->cmdvec) > 0) {
+			struct key *kw = VECTOR_SLOT(c->cmdvec, 0);
+
+			if (!c->is_root && kw->code != LIST) {
+				/* this will fall through to CLT_SEND */
+				c->error = -EPERM;
+				condlog(0, "%s: cli[%d]: unauthorized cmd \"%s\"",
+					__func__, c->fd, c->cmd);
+			}
+		}
+		set_client_state(c, CLT_WAIT_LOCK);
+		/* fallthrough */
+
+	case CLT_WAIT_LOCK:
+		condlog(4, "%s: cli[%d] state=%d cmd=\"%s\" repl \"%s\"", __func__,
+			c->fd, c->state, c->cmd, get_strbuf_str(&c->reply));
+		/* tbd */
+		set_client_state(c, CLT_WORK);
+		/* fallthrough */
+
+	case CLT_WORK:
+		condlog(4, "%s: cli[%d] state=%d cmd=\"%s\" repl \"%s\"", __func__,
+			c->fd, c->state, c->cmd, get_strbuf_str(&c->reply));
+		if (c->error == 0 && c->handler)
+			c->error = execute_handler(c, vecs, uxsock_timeout / 1000);
+
+		if (c->cmdvec) {
+			free_keys(c->cmdvec);
+			c->cmdvec = NULL;
+		}
+		set_client_state(c, CLT_SEND);
+		/* fallthrough */
+
+	case CLT_SEND:
+		if (get_strbuf_len(&c->reply) == 0)
+			default_reply(c, c->error);
 
-	if (get_strbuf_len(&c->reply) > 0) {
 		const char *buf = get_strbuf_str(&c->reply);
 
 		if (send_packet(c->fd, buf) != 0)
@@ -481,9 +492,13 @@ static void handle_client(struct client *c, void *trigger_data)
 			condlog(4, "cli[%d]: Reply [%zu bytes]", c->fd,
 				get_strbuf_len(&c->reply) + 1);
 		reset_strbuf(&c->reply);
-	}
 
-	set_client_state(c, CLT_RECV);
+		set_client_state(c, CLT_RECV);
+		break;
+
+	default:
+		break;
+	}
 }
 
 /*
-- 
2.33.0


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

