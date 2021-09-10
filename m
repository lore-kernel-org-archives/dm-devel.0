Return-Path: <SRS0=FvAS=OA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 870E3C433EF
	for <dm-devel@archiver.kernel.org>; Fri, 10 Sep 2021 11:43:39 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1BF04611B0
	for <dm-devel@archiver.kernel.org>; Fri, 10 Sep 2021 11:43:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1BF04611B0
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-585-9QnOQhWKPg2EMZoQ6ACMWQ-1; Fri, 10 Sep 2021 07:43:36 -0400
X-MC-Unique: 9QnOQhWKPg2EMZoQ6ACMWQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9948B108468D;
	Fri, 10 Sep 2021 11:43:30 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7D60C5C1D1;
	Fri, 10 Sep 2021 11:43:30 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 53A344EA3F;
	Fri, 10 Sep 2021 11:43:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18ABh6c5010380 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 10 Sep 2021 07:43:06 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 0D5B210BC29D; Fri, 10 Sep 2021 11:43:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 08F7B10AF42D
	for <dm-devel@redhat.com>; Fri, 10 Sep 2021 11:43:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1E62E8934E1
	for <dm-devel@redhat.com>; Fri, 10 Sep 2021 11:43:03 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-122-zX_Psrm0NIKcJ5gW_8Tw5w-1; Fri, 10 Sep 2021 07:43:01 -0400
X-MC-Unique: zX_Psrm0NIKcJ5gW_8Tw5w-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0931D22436;
	Fri, 10 Sep 2021 11:43:00 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id AC2FB13D34;
	Fri, 10 Sep 2021 11:42:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id SFr5J8NEO2GPOAAAMHmgww
	(envelope-from <mwilck@suse.com>); Fri, 10 Sep 2021 11:42:59 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 10 Sep 2021 13:41:12 +0200
Message-Id: <20210910114120.13665-28-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 18ABh6c5010380
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, Chongyun Wu <wu.chongyun@h3c.com>,
	dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 27/35] multipathd: uxlsnr: pass struct client to
	uxsock_trigger() and parse_cmd()
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

As a next step towards the state machine, give the handler functions
access to the state of the client connection.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/uxlsnr.c | 61 +++++++++++++++++++++------------------------
 1 file changed, 29 insertions(+), 32 deletions(-)

diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index 9cf6964..65cb5ca 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -293,31 +293,28 @@ static void handle_inotify(int fd, struct watch_descriptors *wds)
 
 static const struct timespec ts_zero = { .tv_sec = 0, };
 
-static int parse_cmd (char *cmd, struct strbuf *reply, void *data,
-		      int timeout)
+static int parse_cmd (struct client *c, void *data, int timeout)
 {
 	int r;
 	struct handler * h;
-	vector cmdvec = NULL;
 	struct timespec tmo;
 
-	r = get_cmdvec(cmd, &cmdvec);
+	r = get_cmdvec(c->cmd, &c->cmdvec);
 
 	if (r) {
-		genhelp_handler(cmd, r, reply);
-		if (get_strbuf_len(reply) == 0)
+		genhelp_handler(c->cmd, r, &c->reply);
+		if (get_strbuf_len(&c->reply) == 0)
 			return EINVAL;
 		return 0;
 	}
 
-	h = find_handler_for_cmdvec(cmdvec);
+	h = find_handler_for_cmdvec(c->cmdvec);
 
 	if (!h || !h->fn) {
-		free_keys(cmdvec);
-		genhelp_handler(cmd, EINVAL, reply);
-		if (get_strbuf_len(reply) == 0)
-			return EINVAL;
-		return 0;
+		genhelp_handler(c->cmd, EINVAL, &c->reply);
+		if (get_strbuf_len(&c->reply) == 0)
+			r = EINVAL;
+		goto free_cmdvec;
 	}
 
 	/*
@@ -342,46 +339,47 @@ static int parse_cmd (char *cmd, struct strbuf *reply, void *data,
 		if (r == 0) {
 			locked = 1;
 			pthread_testcancel();
-			r = h->fn(cmdvec, reply, data);
+			r = h->fn(c->cmdvec, &c->reply, data);
 		}
 		pthread_cleanup_pop(locked);
 	} else
-		r = h->fn(cmdvec, reply, data);
-	free_keys(cmdvec);
+		r = h->fn(c->cmdvec, &c->reply, data);
+
+free_cmdvec:
+	free_keys(c->cmdvec);
+	c->cmdvec = NULL;
 
 	return r;
 }
 
-static int uxsock_trigger(char *str, struct strbuf *reply,
-			  bool is_root, void *trigger_data)
+static int uxsock_trigger(struct client *c, void *trigger_data)
 {
 	struct vectors * vecs;
-	int r;
+	int r = 1;
 
 	vecs = (struct vectors *)trigger_data;
 
-	if ((str != NULL) && (is_root == false) &&
-	    (strncmp(str, "list", strlen("list")) != 0) &&
-	    (strncmp(str, "show", strlen("show")) != 0)) {
-		append_strbuf_str(reply, "permission deny: need to be root");
-		return 1;
+
+	if (!c->is_root &&
+	    (strncmp(c->cmd, "list", strlen("list")) != 0) &&
+	    (strncmp(c->cmd, "show", strlen("show")) != 0)) {
+		append_strbuf_str(&c->reply, "permission deny: need to be root");
+		return r;
 	}
 
-	r = parse_cmd(str, reply, vecs, uxsock_timeout / 1000);
+	r = parse_cmd(c, vecs, uxsock_timeout / 1000);
 
 	if (r > 0) {
 		if (r == ETIMEDOUT)
-			append_strbuf_str(reply, "timeout\n");
+			append_strbuf_str(&c->reply, "timeout\n");
 		else
-			append_strbuf_str(reply, "fail\n");
-		r = 1;
+			append_strbuf_str(&c->reply, "fail\n");
 	}
-	else if (!r && get_strbuf_len(reply) == 0) {
-		append_strbuf_str(reply, "ok\n");
+	else if (!r && get_strbuf_len(&c->reply) == 0) {
+		append_strbuf_str(&c->reply, "ok\n");
 		r = 0;
 	}
 	/* else if (r < 0) leave *reply alone */
-
 	return r;
 }
 
@@ -454,8 +452,7 @@ static void handle_client(struct client *c, void *trigger_data)
 	}
 
 	condlog(4, "cli[%d]: Got request [%s]", c->fd, c->cmd);
-	uxsock_trigger(c->cmd, &c->reply, _socket_client_is_root(c->fd),
-		       trigger_data);
+	uxsock_trigger(c, trigger_data);
 
 	if (get_strbuf_len(&c->reply) > 0) {
 		const char *buf = get_strbuf_str(&c->reply);
-- 
2.33.0


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

