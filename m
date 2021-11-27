Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37757C433F5
	for <dm-devel@archiver.kernel.org>; Sat, 27 Nov 2021 15:22:51 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-71-aZff979JMyyOxCffukKzWA-1; Sat, 27 Nov 2021 10:22:46 -0500
X-MC-Unique: aZff979JMyyOxCffukKzWA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 637961006AA6;
	Sat, 27 Nov 2021 15:22:42 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4E63F72FA7;
	Sat, 27 Nov 2021 15:22:42 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2AFAB1826D13;
	Sat, 27 Nov 2021 15:22:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ARFJuTu000362 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 27 Nov 2021 10:19:56 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 00F6151E3; Sat, 27 Nov 2021 15:19:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F012951DC
	for <dm-devel@redhat.com>; Sat, 27 Nov 2021 15:19:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CA139101AA64
	for <dm-devel@redhat.com>; Sat, 27 Nov 2021 15:19:55 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-125-a8o5IFl1MOmaOJ_s_Z5Gaw-1; Sat, 27 Nov 2021 10:19:53 -0500
X-MC-Unique: a8o5IFl1MOmaOJ_s_Z5Gaw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id F0CD0212CC;
	Sat, 27 Nov 2021 15:19:51 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A3A7313AAD;
	Sat, 27 Nov 2021 15:19:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id UNLVJZdMomErFgAAMHmgww
	(envelope-from <mwilck@suse.com>); Sat, 27 Nov 2021 15:19:51 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Sat, 27 Nov 2021 16:19:20 +0100
Message-Id: <20211127151929.7727-28-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1ARFJuTu000362
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, Chongyun Wu <wu.chongyun@h3c.com>,
	dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v3 27/35] multipathd: uxlsnr: move handler
	execution to separate function
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Move the actual execution of the handler out of parse_cmd(). For now,
we do it in uxsock_trigger().

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/uxlsnr.c | 47 ++++++++++++++++++++++++++++-----------------
 1 file changed, 29 insertions(+), 18 deletions(-)

diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index d83d83d..2c434cd 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -293,11 +293,9 @@ static void handle_inotify(int fd, struct watch_descriptors *wds)
 
 static const struct timespec ts_zero = { .tv_sec = 0, };
 
-static int parse_cmd (struct client *c, void *data, int timeout)
+static int parse_cmd(struct client *c)
 {
 	int r;
-	struct handler * h;
-	struct timespec tmo;
 
 	r = get_cmdvec(c->cmd, &c->cmdvec);
 
@@ -308,26 +306,35 @@ static int parse_cmd (struct client *c, void *data, int timeout)
 		return 0;
 	}
 
-	h = find_handler_for_cmdvec(c->cmdvec);
+	c->handler = find_handler_for_cmdvec(c->cmdvec);
 
-	if (!h || !h->fn) {
+	if (!c->handler || !c->handler->fn) {
 		genhelp_handler(c->cmd, EINVAL, &c->reply);
 		if (get_strbuf_len(&c->reply) == 0)
 			r = EINVAL;
-		goto free_cmdvec;
+		else
+			r = 0;
 	}
 
-	/*
-	 * execute handler
-	 */
+	return r;
+}
+
+static int execute_handler(struct client *c, struct vectors *vecs, int timeout)
+{
+	int r;
+	struct timespec tmo;
+
+	if (!c->handler)
+		return EINVAL;
+
 	if (clock_gettime(CLOCK_REALTIME, &tmo) == 0) {
 		tmo.tv_sec += timeout;
 	} else {
 		tmo.tv_sec = 0;
 	}
-	if (h->locked) {
+
+	if (c->handler->locked) {
 		int locked = 0;
-		struct vectors * vecs = (struct vectors *)data;
 
 		pthread_cleanup_push(cleanup_lock, &vecs->lock);
 		if (tmo.tv_sec) {
@@ -339,15 +346,11 @@ static int parse_cmd (struct client *c, void *data, int timeout)
 		if (r == 0) {
 			locked = 1;
 			pthread_testcancel();
-			r = h->fn(c->cmdvec, &c->reply, data);
+			r = c->handler->fn(c->cmdvec, &c->reply, vecs);
 		}
 		pthread_cleanup_pop(locked);
 	} else
-		r = h->fn(c->cmdvec, &c->reply, data);
-
-free_cmdvec:
-	free_keys(c->cmdvec);
-	c->cmdvec = NULL;
+		r = c->handler->fn(c->cmdvec, &c->reply, vecs);
 
 	return r;
 }
@@ -367,7 +370,15 @@ static int uxsock_trigger(struct client *c, void *trigger_data)
 		return r;
 	}
 
-	r = parse_cmd(c, vecs, uxsock_timeout / 1000);
+	r = parse_cmd(c);
+
+	if (r == 0 && c->handler)
+		r = execute_handler(c, vecs, uxsock_timeout / 1000);
+
+	if (c->cmdvec) {
+		free_keys(c->cmdvec);
+		c->cmdvec = NULL;
+	}
 
 	if (r > 0) {
 		if (r == ETIMEDOUT)
-- 
2.33.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

