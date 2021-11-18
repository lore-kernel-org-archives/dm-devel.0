Return-Path: <SRS0=dXIA=QF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DDFAC433FE
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 23:04:59 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id AF98461A79
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 23:04:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org AF98461A79
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-215-mXOhDS7dOK6AsZQaEaa7QA-1; Thu, 18 Nov 2021 18:04:54 -0500
X-MC-Unique: mXOhDS7dOK6AsZQaEaa7QA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E7038871812;
	Thu, 18 Nov 2021 23:04:49 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CFD3C57CAB;
	Thu, 18 Nov 2021 23:04:49 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id AAE841832DD7;
	Thu, 18 Nov 2021 23:04:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AIMxBvR002245 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 18 Nov 2021 17:59:11 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 883B3218012A; Thu, 18 Nov 2021 22:59:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8299C218013F
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 22:59:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6AA9B811E76
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 22:59:11 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-386-RT2zIH81OvSJrJxAuRg-eQ-1; Thu, 18 Nov 2021 17:59:07 -0500
X-MC-Unique: RT2zIH81OvSJrJxAuRg-eQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 58A971FD3D;
	Thu, 18 Nov 2021 22:59:06 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 11F0013B11;
	Thu, 18 Nov 2021 22:59:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id OHRqArralmGHPAAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 18 Nov 2021 22:59:06 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 18 Nov 2021 23:58:19 +0100
Message-Id: <20211118225840.19810-28-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AIMxBvR002245
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, Chongyun Wu <wu.chongyun@h3c.com>,
	dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v2 27/48] multipathd: uxlsnr: move handler
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
index 65cb5ca..cfff0ae 100644
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

