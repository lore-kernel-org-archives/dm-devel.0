Return-Path: <SRS0=dXIA=QF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CA5AC433EF
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 23:03:20 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A49F86128E
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 23:03:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A49F86128E
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-518-scrZ6hfDOtigOAdYLlYtJw-1; Thu, 18 Nov 2021 18:03:15 -0500
X-MC-Unique: scrZ6hfDOtigOAdYLlYtJw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6D5501018726;
	Thu, 18 Nov 2021 23:03:10 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 525B95D9D5;
	Thu, 18 Nov 2021 23:03:10 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2CD4C1832DD4;
	Thu, 18 Nov 2021 23:03:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AIMx71r002091 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 18 Nov 2021 17:59:07 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2371C218013A; Thu, 18 Nov 2021 22:59:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1DA3F218012A
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 22:59:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 03654802814
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 22:59:07 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-41-PDhje39FNbWq8bkDGz5v5A-1; Thu, 18 Nov 2021 17:59:05 -0500
X-MC-Unique: PDhje39FNbWq8bkDGz5v5A-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D88062177B;
	Thu, 18 Nov 2021 22:59:03 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9149213B11;
	Thu, 18 Nov 2021 22:59:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id wE2KIbfalmGHPAAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 18 Nov 2021 22:59:03 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 18 Nov 2021 23:58:12 +0100
Message-Id: <20211118225840.19810-21-mwilck@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AIMx71r002091
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, Chongyun Wu <wu.chongyun@h3c.com>,
	dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v2 20/48] multipathd: move parse_cmd() to uxlsnr.c
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

parse_cmd() does more than the name says - it parses, executes
handlers, and even provides reply strings for some cases. This doesn't
work well with the state machine idea. Thus move it to uxlsnr.c,
where later patches will move some functionality elsewhere.

No functional changes.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/cli.c    | 74 +++++----------------------------------------
 multipathd/cli.h    |  5 ++-
 multipathd/uxlsnr.c | 61 +++++++++++++++++++++++++++++++++++++
 3 files changed, 73 insertions(+), 67 deletions(-)

diff --git a/multipathd/cli.c b/multipathd/cli.c
index 93a3f5d..eb94c75 100644
--- a/multipathd/cli.c
+++ b/multipathd/cli.c
@@ -254,8 +254,7 @@ find_key (const char * str)
  * ESRCH: command not found
  * EINVAL: argument missing for command
  */
-static int
-get_cmdvec (char * cmd, vector *v)
+int get_cmdvec (char *cmd, vector *v)
 {
 	int i;
 	int r = 0;
@@ -320,7 +319,7 @@ out:
 }
 
 static uint64_t
-fingerprint(vector vec)
+fingerprint(const struct _vector *vec)
 {
 	int i;
 	uint64_t fp = 0;
@@ -335,6 +334,11 @@ fingerprint(vector vec)
 	return fp;
 }
 
+struct handler *find_handler_for_cmdvec(const struct _vector *v)
+{
+	return find_handler(fingerprint(v));
+}
+
 int
 alloc_handlers (void)
 {
@@ -413,8 +417,7 @@ do_genhelp(struct strbuf *reply, const char *cmd, int error) {
 }
 
 
-static char *
-genhelp_handler (const char *cmd, int error)
+char *genhelp_handler(const char *cmd, int error)
 {
 	STRBUF_ON_STACK(reply);
 
@@ -423,67 +426,6 @@ genhelp_handler (const char *cmd, int error)
 	return steal_strbuf_str(&reply);
 }
 
-int
-parse_cmd (char * cmd, char ** reply, int * len, void * data, int timeout )
-{
-	int r;
-	struct handler * h;
-	vector cmdvec = NULL;
-	struct timespec tmo;
-
-	r = get_cmdvec(cmd, &cmdvec);
-
-	if (r) {
-		*reply = genhelp_handler(cmd, r);
-		if (*reply == NULL)
-			return EINVAL;
-		*len = strlen(*reply) + 1;
-		return 0;
-	}
-
-	h = find_handler(fingerprint(cmdvec));
-
-	if (!h || !h->fn) {
-		free_keys(cmdvec);
-		*reply = genhelp_handler(cmd, EINVAL);
-		if (*reply == NULL)
-			return EINVAL;
-		*len = strlen(*reply) + 1;
-		return 0;
-	}
-
-	/*
-	 * execute handler
-	 */
-	if (clock_gettime(CLOCK_REALTIME, &tmo) == 0) {
-		tmo.tv_sec += timeout;
-	} else {
-		tmo.tv_sec = 0;
-	}
-	if (h->locked) {
-		int locked = 0;
-		struct vectors * vecs = (struct vectors *)data;
-
-		pthread_cleanup_push(cleanup_lock, &vecs->lock);
-		if (tmo.tv_sec) {
-			r = timedlock(&vecs->lock, &tmo);
-		} else {
-			lock(&vecs->lock);
-			r = 0;
-		}
-		if (r == 0) {
-			locked = 1;
-			pthread_testcancel();
-			r = h->fn(cmdvec, reply, len, data);
-		}
-		pthread_cleanup_pop(locked);
-	} else
-		r = h->fn(cmdvec, reply, len, data);
-	free_keys(cmdvec);
-
-	return r;
-}
-
 char *
 get_keyparam (vector v, uint64_t code)
 {
diff --git a/multipathd/cli.h b/multipathd/cli.h
index 479a745..f795826 100644
--- a/multipathd/cli.h
+++ b/multipathd/cli.h
@@ -137,7 +137,10 @@ int __set_handler_callback (uint64_t fp, cli_handler *fn, bool locked);
 #define set_handler_callback(fp, fn) __set_handler_callback(fp, fn, true)
 #define set_unlocked_handler_callback(fp, fn) __set_handler_callback(fp, fn, false)
 
-int parse_cmd (char * cmd, char ** reply, int * len, void *, int);
+int get_cmdvec (char *cmd, vector *v);
+struct handler *find_handler_for_cmdvec(const struct _vector *v);
+char *genhelp_handler (const char *cmd, int error);
+
 int load_keys (void);
 char * get_keyparam (vector v, uint64_t code);
 void free_keys (vector vec);
diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index 622aac1..cbbcb2c 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -311,6 +311,67 @@ static void handle_inotify(int fd, struct watch_descriptors *wds)
 		condlog(1, "Multipath configuration updated.\nReload multipathd for changes to take effect");
 }
 
+static int parse_cmd (char *cmd, char **reply, int *len, void *data,
+		      int timeout)
+{
+	int r;
+	struct handler * h;
+	vector cmdvec = NULL;
+	struct timespec tmo;
+
+	r = get_cmdvec(cmd, &cmdvec);
+
+	if (r) {
+		*reply = genhelp_handler(cmd, r);
+		if (*reply == NULL)
+			return EINVAL;
+		*len = strlen(*reply) + 1;
+		return 0;
+	}
+
+	h = find_handler_for_cmdvec(cmdvec);
+
+	if (!h || !h->fn) {
+		free_keys(cmdvec);
+		*reply = genhelp_handler(cmd, EINVAL);
+		if (*reply == NULL)
+			return EINVAL;
+		*len = strlen(*reply) + 1;
+		return 0;
+	}
+
+	/*
+	 * execute handler
+	 */
+	if (clock_gettime(CLOCK_REALTIME, &tmo) == 0) {
+		tmo.tv_sec += timeout;
+	} else {
+		tmo.tv_sec = 0;
+	}
+	if (h->locked) {
+		int locked = 0;
+		struct vectors * vecs = (struct vectors *)data;
+
+		pthread_cleanup_push(cleanup_lock, &vecs->lock);
+		if (tmo.tv_sec) {
+			r = timedlock(&vecs->lock, &tmo);
+		} else {
+			lock(&vecs->lock);
+			r = 0;
+		}
+		if (r == 0) {
+			locked = 1;
+			pthread_testcancel();
+			r = h->fn(cmdvec, reply, len, data);
+		}
+		pthread_cleanup_pop(locked);
+	} else
+		r = h->fn(cmdvec, reply, len, data);
+	free_keys(cmdvec);
+
+	return r;
+}
+
 static int uxsock_trigger(char *str, char **reply, int *len,
 			  bool is_root, void *trigger_data)
 {
-- 
2.33.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

