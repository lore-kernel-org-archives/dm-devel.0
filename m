Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE7E7C433F5
	for <dm-devel@archiver.kernel.org>; Sat, 27 Nov 2021 15:22:56 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-357-CKSkum-MPQq9AsRrWuM8Sw-1; Sat, 27 Nov 2021 10:22:52 -0500
X-MC-Unique: CKSkum-MPQq9AsRrWuM8Sw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1871210168C4;
	Sat, 27 Nov 2021 15:22:48 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F3CDB196F8;
	Sat, 27 Nov 2021 15:22:47 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CC374473D7;
	Sat, 27 Nov 2021 15:22:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ARFJvwc000403 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 27 Nov 2021 10:19:57 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 0D474404727C; Sat, 27 Nov 2021 15:19:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 09A184047272
	for <dm-devel@redhat.com>; Sat, 27 Nov 2021 15:19:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E6370811E78
	for <dm-devel@redhat.com>; Sat, 27 Nov 2021 15:19:56 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-533-BkelFAaANx27ss1Zgzl9Ew-1; Sat, 27 Nov 2021 10:19:52 -0500
X-MC-Unique: BkelFAaANx27ss1Zgzl9Ew-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 962B9212CB;
	Sat, 27 Nov 2021 15:19:51 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 464C913AAD;
	Sat, 27 Nov 2021 15:19:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id eLICD5dMomErFgAAMHmgww
	(envelope-from <mwilck@suse.com>); Sat, 27 Nov 2021 15:19:51 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Sat, 27 Nov 2021 16:19:19 +0100
Message-Id: <20211127151929.7727-27-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1ARFJvwc000403
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, Chongyun Wu <wu.chongyun@h3c.com>,
	dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v3 26/35] multipathd: uxlsnr: pass struct client
	to uxsock_trigger() and parse_cmd()
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

As a next step towards the state machine, give the handler functions
access to the state of the client connection.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/uxlsnr.c | 61 +++++++++++++++++++++------------------------
 1 file changed, 29 insertions(+), 32 deletions(-)

diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index a2ef9f8..d83d83d 100644
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
2.33.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

