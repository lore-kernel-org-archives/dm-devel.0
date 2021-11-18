Return-Path: <SRS0=dXIA=QF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66DA5C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 23:04:57 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 07DB161A79
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 23:04:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 07DB161A79
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-328-oEBWvLtzPJq38V5ZyO38Cw-1; Thu, 18 Nov 2021 18:04:52 -0500
X-MC-Unique: oEBWvLtzPJq38V5ZyO38Cw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 77ED4101AFA7;
	Thu, 18 Nov 2021 23:04:47 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5AF293AEF;
	Thu, 18 Nov 2021 23:04:47 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 35E531832DD6;
	Thu, 18 Nov 2021 23:04:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AIMxAXf002205 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 18 Nov 2021 17:59:10 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A23261121315; Thu, 18 Nov 2021 22:59:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9CFCF1121314
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 22:59:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7D3468011A5
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 22:59:10 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-404-8lK2PxztP92kDozywMXtQA-1; Thu, 18 Nov 2021 17:59:06 -0500
X-MC-Unique: 8lK2PxztP92kDozywMXtQA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 519D8217BA;
	Thu, 18 Nov 2021 22:59:05 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0202F13B11;
	Thu, 18 Nov 2021 22:59:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id qODxObjalmGHPAAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 18 Nov 2021 22:59:04 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 18 Nov 2021 23:58:16 +0100
Message-Id: <20211118225840.19810-25-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AIMxAXf002205
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, Chongyun Wu <wu.chongyun@h3c.com>,
	dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v2 24/48] multipathd: use strbuf in cli_handler
	functions
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

This allows us to simplify callers by not having to track the
reply length separately.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/cli.c          |   7 +-
 multipathd/cli.h          |   6 +-
 multipathd/cli_handlers.c | 316 +++++++++++++++-----------------------
 multipathd/uxlsnr.c       |  49 +++---
 4 files changed, 152 insertions(+), 226 deletions(-)

diff --git a/multipathd/cli.c b/multipathd/cli.c
index eb94c75..1c6351e 100644
--- a/multipathd/cli.c
+++ b/multipathd/cli.c
@@ -417,13 +417,10 @@ do_genhelp(struct strbuf *reply, const char *cmd, int error) {
 }
 
 
-char *genhelp_handler(const char *cmd, int error)
+void genhelp_handler(const char *cmd, int error, struct strbuf *reply)
 {
-	STRBUF_ON_STACK(reply);
-
-	if (do_genhelp(&reply, cmd, error) == -1)
+	if (do_genhelp(reply, cmd, error) == -1)
 		condlog(0, "genhelp_handler: out of memory");
-	return steal_strbuf_str(&reply);
 }
 
 char *
diff --git a/multipathd/cli.h b/multipathd/cli.h
index f795826..b05746f 100644
--- a/multipathd/cli.h
+++ b/multipathd/cli.h
@@ -124,7 +124,9 @@ struct key {
 	int has_param;
 };
 
-typedef int (cli_handler)(void *keywords, char **reply, int *len, void *data);
+struct strbuf;
+
+typedef int (cli_handler)(void *keywords, struct strbuf *reply, void *data);
 
 struct handler {
 	uint64_t fingerprint;
@@ -139,7 +141,7 @@ int __set_handler_callback (uint64_t fp, cli_handler *fn, bool locked);
 
 int get_cmdvec (char *cmd, vector *v);
 struct handler *find_handler_for_cmdvec(const struct _vector *v);
-char *genhelp_handler (const char *cmd, int error);
+void genhelp_handler (const char *cmd, int error, struct strbuf *reply);
 
 int load_keys (void);
 char * get_keyparam (vector v, uint64_t code);
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 1a9c822..f59db3a 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -33,17 +33,9 @@
 #include "strbuf.h"
 #include "cli_handlers.h"
 
-#define SET_REPLY_AND_LEN(__rep, __len, string_literal)			\
-	do {								\
-		*(__rep) = strdup(string_literal);			\
-		*(__len) = *(__rep) ? sizeof(string_literal) : 0;	\
-	} while (0)
-
 static int
-show_paths (char ** r, int * len, struct vectors * vecs, char * style,
-	    int pretty)
+show_paths (struct strbuf *reply, struct vectors *vecs, char *style, int pretty)
 {
-	STRBUF_ON_STACK(reply);
 	int i;
 	struct path * pp;
 	int hdr_len = 0;
@@ -51,61 +43,49 @@ show_paths (char ** r, int * len, struct vectors * vecs, char * style,
 	get_path_layout(vecs->pathvec, 1);
 	foreign_path_layout();
 
-	if (pretty && (hdr_len = snprint_path_header(&reply, style)) < 0)
+	if (pretty && (hdr_len = snprint_path_header(reply, style)) < 0)
 		return 1;
 
 	vector_foreach_slot(vecs->pathvec, pp, i) {
-		if (snprint_path(&reply, style, pp, pretty) < 0)
+		if (snprint_path(reply, style, pp, pretty) < 0)
 			return 1;
 	}
-	if (snprint_foreign_paths(&reply, style, pretty) < 0)
+	if (snprint_foreign_paths(reply, style, pretty) < 0)
 		return 1;
 
-	if (pretty && get_strbuf_len(&reply) == (size_t)hdr_len)
+	if (pretty && get_strbuf_len(reply) == (size_t)hdr_len)
 		/* No output - clear header */
-		truncate_strbuf(&reply, 0);
+		truncate_strbuf(reply, 0);
 
-	*len = (int)get_strbuf_len(&reply) + 1;
-	*r = steal_strbuf_str(&reply);
 	return 0;
 }
 
 static int
-show_path (char ** r, int * len, struct vectors * vecs, struct path *pp,
-	   char * style)
+show_path (struct strbuf *reply, struct vectors *vecs, struct path *pp,
+	   char *style)
 {
-	STRBUF_ON_STACK(reply);
-
 	get_path_layout(vecs->pathvec, 1);
-	if (snprint_path(&reply, style, pp, 0) < 0)
+	if (snprint_path(reply, style, pp, 0) < 0)
 		return 1;
-	*len = (int)get_strbuf_len(&reply) + 1;
-	*r = steal_strbuf_str(&reply);
-
 	return 0;
 }
 
 static int
-show_map_topology (char ** r, int * len, struct multipath * mpp,
-		   struct vectors * vecs)
+show_map_topology (struct strbuf *reply, struct multipath *mpp,
+		   struct vectors *vecs)
 {
-	STRBUF_ON_STACK(reply);
-
 	if (update_multipath(vecs, mpp->alias, 0))
 		return 1;
 
-	if (snprint_multipath_topology(&reply, mpp, 2) < 0)
+	if (snprint_multipath_topology(reply, mpp, 2) < 0)
 		return 1;
-	*len = (int)get_strbuf_len(&reply) + 1;
-	*r = steal_strbuf_str(&reply);
 
 	return 0;
 }
 
 static int
-show_maps_topology (char ** r, int * len, struct vectors * vecs)
+show_maps_topology (struct strbuf *reply, struct vectors * vecs)
 {
-	STRBUF_ON_STACK(reply);
 	int i;
 	struct multipath * mpp;
 
@@ -117,21 +97,18 @@ show_maps_topology (char ** r, int * len, struct vectors * vecs)
 			i--;
 			continue;
 		}
-		if (snprint_multipath_topology(&reply, mpp, 2) < 0)
+		if (snprint_multipath_topology(reply, mpp, 2) < 0)
 			return 1;
 	}
-	if (snprint_foreign_topology(&reply, 2) < 0)
+	if (snprint_foreign_topology(reply, 2) < 0)
 		return 1;
 
-	*len = (int)get_strbuf_len(&reply) + 1;
-	*r = steal_strbuf_str(&reply);
 	return 0;
 }
 
 static int
-show_maps_json (char ** r, int * len, struct vectors * vecs)
+show_maps_json (struct strbuf *reply, struct vectors * vecs)
 {
-	STRBUF_ON_STACK(reply);
 	int i;
 	struct multipath * mpp;
 
@@ -141,45 +118,38 @@ show_maps_json (char ** r, int * len, struct vectors * vecs)
 		}
 	}
 
-	if (snprint_multipath_topology_json(&reply, vecs) < 0)
+	if (snprint_multipath_topology_json(reply, vecs) < 0)
 		return 1;
 
-	*len = (int)get_strbuf_len(&reply) + 1;
-	*r = steal_strbuf_str(&reply);
 	return 0;
 }
 
 static int
-show_map_json (char ** r, int * len, struct multipath * mpp,
-		   struct vectors * vecs)
+show_map_json (struct strbuf *reply, struct multipath * mpp,
+	       struct vectors * vecs)
 {
-	STRBUF_ON_STACK(reply);
-
 	if (update_multipath(vecs, mpp->alias, 0))
 		return 1;
 
-	if (snprint_multipath_map_json(&reply, mpp) < 0)
+	if (snprint_multipath_map_json(reply, mpp) < 0)
 		return 1;
 
-	*len = (int)get_strbuf_len(&reply) + 1;
-	*r = steal_strbuf_str(&reply);
 	return 0;
 }
 
 static int
-show_config (char ** r, int * len, const struct _vector *hwtable,
+show_config (struct strbuf *reply, const struct _vector *hwtable,
 	     const struct _vector *mpvec)
 {
 	struct config *conf;
-	char *reply;
+	int rc;
 
 	conf = get_multipath_config();
 	pthread_cleanup_push(put_multipath_config, conf);
-	reply = snprint_config(conf, len, hwtable, mpvec);
+	rc = __snprint_config(conf, reply, hwtable, mpvec);
 	pthread_cleanup_pop(1);
-	if (reply == NULL)
+	if (rc < 0)
 		return 1;
-	*r = reply;
 	return 0;
 }
 
@@ -195,11 +165,11 @@ reset_stats(struct multipath * mpp)
 }
 
 static int
-cli_list_config (void * v, char ** reply, int * len, void * data)
+cli_list_config (void *v, struct strbuf *reply, void *data)
 {
 	condlog(3, "list config (operator)");
 
-	return show_config(reply, len, NULL, NULL);
+	return show_config(reply, NULL, NULL);
 }
 
 static void v_free(void *x)
@@ -208,9 +178,9 @@ static void v_free(void *x)
 }
 
 static int
-cli_list_config_local (void * v, char ** reply, int * len, void * data)
+cli_list_config_local (void *v, struct strbuf *reply, void *data)
 {
-	struct vectors * vecs = (struct vectors *)data;
+	struct vectors *vecs = (struct vectors *)data;
 	vector hwes;
 	int ret;
 
@@ -218,45 +188,45 @@ cli_list_config_local (void * v, char ** reply, int * len, void * data)
 
 	hwes = get_used_hwes(vecs->pathvec);
 	pthread_cleanup_push(v_free, hwes);
-	ret = show_config(reply, len, hwes, vecs->mpvec);
+	ret = show_config(reply, hwes, vecs->mpvec);
 	pthread_cleanup_pop(1);
 	return ret;
 }
 
 static int
-cli_list_paths (void * v, char ** reply, int * len, void * data)
+cli_list_paths (void *v, struct strbuf *reply, void *data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 
 	condlog(3, "list paths (operator)");
 
-	return show_paths(reply, len, vecs, PRINT_PATH_CHECKER, 1);
+	return show_paths(reply, vecs, PRINT_PATH_CHECKER, 1);
 }
 
 static int
-cli_list_paths_fmt (void * v, char ** reply, int * len, void * data)
+cli_list_paths_fmt (void *v, struct strbuf *reply, void *data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 	char * fmt = get_keyparam(v, FMT);
 
 	condlog(3, "list paths (operator)");
 
-	return show_paths(reply, len, vecs, fmt, 1);
+	return show_paths(reply, vecs, fmt, 1);
 }
 
 static int
-cli_list_paths_raw (void * v, char ** reply, int * len, void * data)
+cli_list_paths_raw (void *v, struct strbuf *reply, void * data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 	char * fmt = get_keyparam(v, FMT);
 
 	condlog(3, "list paths (operator)");
 
-	return show_paths(reply, len, vecs, fmt, 0);
+	return show_paths(reply, vecs, fmt, 0);
 }
 
 static int
-cli_list_path (void * v, char ** reply, int * len, void * data)
+cli_list_path (void *v, struct strbuf *reply, void *data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 	char * param = get_keyparam(v, PATH);
@@ -269,11 +239,11 @@ cli_list_path (void * v, char ** reply, int * len, void * data)
 	if (!pp)
 		return 1;
 
-	return show_path(reply, len, vecs, pp, "%o");
+	return show_path(reply, vecs, pp, "%o");
 }
 
 static int
-cli_list_map_topology (void * v, char ** reply, int * len, void * data)
+cli_list_map_topology (void *v, struct strbuf *reply, void *data)
 {
 	struct multipath * mpp;
 	struct vectors * vecs = (struct vectors *)data;
@@ -288,21 +258,21 @@ cli_list_map_topology (void * v, char ** reply, int * len, void * data)
 
 	condlog(3, "list multipath %s (operator)", param);
 
-	return show_map_topology(reply, len, mpp, vecs);
+	return show_map_topology(reply, mpp, vecs);
 }
 
 static int
-cli_list_maps_topology (void * v, char ** reply, int * len, void * data)
+cli_list_maps_topology (void *v, struct strbuf *reply, void *data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 
 	condlog(3, "list multipaths (operator)");
 
-	return show_maps_topology(reply, len, vecs);
+	return show_maps_topology(reply, vecs);
 }
 
 static int
-cli_list_map_json (void * v, char ** reply, int * len, void * data)
+cli_list_map_json (void *v, struct strbuf *reply, void *data)
 {
 	struct multipath * mpp;
 	struct vectors * vecs = (struct vectors *)data;
@@ -317,78 +287,61 @@ cli_list_map_json (void * v, char ** reply, int * len, void * data)
 
 	condlog(3, "list multipath json %s (operator)", param);
 
-	return show_map_json(reply, len, mpp, vecs);
+	return show_map_json(reply, mpp, vecs);
 }
 
 static int
-cli_list_maps_json (void * v, char ** reply, int * len, void * data)
+cli_list_maps_json (void *v, struct strbuf *reply, void *data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 
 	condlog(3, "list multipaths json (operator)");
 
-	return show_maps_json(reply, len, vecs);
+	return show_maps_json(reply, vecs);
 }
 
 static int
-cli_list_wildcards (void * v, char ** reply, int * len, void * data)
+cli_list_wildcards (void *v, struct strbuf *reply, void *data)
 {
-	STRBUF_ON_STACK(buf);
-
-	if (snprint_wildcards(&buf) < 0)
+	if (snprint_wildcards(reply) < 0)
 		return 1;
 
-	*len = get_strbuf_len(&buf) + 1;
-	*reply = steal_strbuf_str(&buf);
 	return 0;
 }
 
 static int
-show_status (char ** r, int *len, struct vectors * vecs)
+show_status (struct strbuf *reply, struct vectors *vecs)
 {
-	STRBUF_ON_STACK(reply);
-
-	if (snprint_status(&reply, vecs) < 0)
+	if (snprint_status(reply, vecs) < 0)
 		return 1;
 
-	*len = get_strbuf_len(&reply) + 1;
-	*r = steal_strbuf_str(&reply);
 	return 0;
 }
 
 static int
-show_daemon (char ** r, int *len)
+show_daemon (struct strbuf *reply)
 {
-	STRBUF_ON_STACK(reply);
-
-	if (print_strbuf(&reply, "pid %d %s\n",
+	if (print_strbuf(reply, "pid %d %s\n",
 			 daemon_pid, daemon_status()) < 0)
 		return 1;
 
-	*len = get_strbuf_len(&reply) + 1;
-	*r = steal_strbuf_str(&reply);
 	return 0;
 }
 
 static int
-show_map (char ** r, int *len, struct multipath * mpp, char * style,
+show_map (struct strbuf *reply, struct multipath *mpp, char *style,
 	  int pretty)
 {
-	STRBUF_ON_STACK(reply);
-
-	if (snprint_multipath(&reply, style, mpp, pretty) < 0)
+	if (snprint_multipath(reply, style, mpp, pretty) < 0)
 		return 1;
 
-	*len = get_strbuf_len(&reply) + 1;
-	*r = steal_strbuf_str(&reply);
 	return 0;
 }
 
 static int
-show_maps (char ** r, int *len, struct vectors * vecs, char * style,
+show_maps (struct strbuf *reply, struct vectors *vecs, char *style,
 	   int pretty)
 {
-	STRBUF_ON_STACK(reply);
 	int i;
 	struct multipath * mpp;
 	int hdr_len = 0;
@@ -396,7 +349,7 @@ show_maps (char ** r, int *len, struct vectors * vecs, char * style,
 	get_multipath_layout(vecs->mpvec, 1);
 	foreign_multipath_layout();
 
-	if (pretty && (hdr_len = snprint_multipath_header(&reply, style)) < 0)
+	if (pretty && (hdr_len = snprint_multipath_header(reply, style)) < 0)
 		return 1;
 
 	vector_foreach_slot(vecs->mpvec, mpp, i) {
@@ -404,45 +357,43 @@ show_maps (char ** r, int *len, struct vectors * vecs, char * style,
 			i--;
 			continue;
 		}
-		if (snprint_multipath(&reply, style, mpp, pretty) < 0)
+		if (snprint_multipath(reply, style, mpp, pretty) < 0)
 			return 1;
 	}
-	if (snprint_foreign_multipaths(&reply, style, pretty) < 0)
+	if (snprint_foreign_multipaths(reply, style, pretty) < 0)
 		return 1;
 
-	if (pretty && get_strbuf_len(&reply) == (size_t)hdr_len)
+	if (pretty && get_strbuf_len(reply) == (size_t)hdr_len)
 		/* No output - clear header */
-		truncate_strbuf(&reply, 0);
+		truncate_strbuf(reply, 0);
 
-	*len = (int)get_strbuf_len(&reply) + 1;
-	*r = steal_strbuf_str(&reply);
 	return 0;
 }
 
 static int
-cli_list_maps_fmt (void * v, char ** reply, int * len, void * data)
+cli_list_maps_fmt (void *v, struct strbuf *reply, void *data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 	char * fmt = get_keyparam(v, FMT);
 
 	condlog(3, "list maps (operator)");
 
-	return show_maps(reply, len, vecs, fmt, 1);
+	return show_maps(reply, vecs, fmt, 1);
 }
 
 static int
-cli_list_maps_raw (void * v, char ** reply, int * len, void * data)
+cli_list_maps_raw (void *v, struct strbuf *reply, void *data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 	char * fmt = get_keyparam(v, FMT);
 
 	condlog(3, "list maps (operator)");
 
-	return show_maps(reply, len, vecs, fmt, 0);
+	return show_maps(reply, vecs, fmt, 0);
 }
 
 static int
-cli_list_map_fmt (void * v, char ** reply, int * len, void * data)
+cli_list_map_fmt (void *v, struct strbuf *reply, void *data)
 {
 	struct multipath * mpp;
 	struct vectors * vecs = (struct vectors *)data;
@@ -458,59 +409,59 @@ cli_list_map_fmt (void * v, char ** reply, int * len, void * data)
 
 	condlog(3, "list map %s fmt %s (operator)", param, fmt);
 
-	return show_map(reply, len, mpp, fmt, 1);
+	return show_map(reply, mpp, fmt, 1);
 }
 
 static int
-cli_list_maps (void * v, char ** reply, int * len, void * data)
+cli_list_maps (void *v, struct strbuf *reply, void *data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 
 	condlog(3, "list maps (operator)");
 
-	return show_maps(reply, len, vecs, PRINT_MAP_NAMES, 1);
+	return show_maps(reply, vecs, PRINT_MAP_NAMES, 1);
 }
 
 static int
-cli_list_status (void * v, char ** reply, int * len, void * data)
+cli_list_status (void *v, struct strbuf *reply, void *data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 
 	condlog(3, "list status (operator)");
 
-	return show_status(reply, len, vecs);
+	return show_status(reply, vecs);
 }
 
 static int
-cli_list_maps_status (void * v, char ** reply, int * len, void * data)
+cli_list_maps_status (void *v, struct strbuf *reply, void *data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 
 	condlog(3, "list maps status (operator)");
 
-	return show_maps(reply, len, vecs, PRINT_MAP_STATUS, 1);
+	return show_maps(reply, vecs, PRINT_MAP_STATUS, 1);
 }
 
 static int
-cli_list_maps_stats (void * v, char ** reply, int * len, void * data)
+cli_list_maps_stats (void *v, struct strbuf *reply, void *data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 
 	condlog(3, "list maps stats (operator)");
 
-	return show_maps(reply, len, vecs, PRINT_MAP_STATS, 1);
+	return show_maps(reply, vecs, PRINT_MAP_STATS, 1);
 }
 
 static int
-cli_list_daemon (void * v, char ** reply, int * len, void * data)
+cli_list_daemon (void *v, struct strbuf *reply, void *data)
 {
 	condlog(3, "list daemon (operator)");
 
-	return show_daemon(reply, len);
+	return show_daemon(reply);
 }
 
 static int
-cli_reset_maps_stats (void * v, char ** reply, int * len, void * data)
+cli_reset_maps_stats (void *v, struct strbuf *reply, void *data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 	int i;
@@ -525,7 +476,7 @@ cli_reset_maps_stats (void * v, char ** reply, int * len, void * data)
 }
 
 static int
-cli_reset_map_stats (void * v, char ** reply, int * len, void * data)
+cli_reset_map_stats (void *v, struct strbuf *reply, void *data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 	struct multipath * mpp;
@@ -543,7 +494,7 @@ cli_reset_map_stats (void * v, char ** reply, int * len, void * data)
 }
 
 static int
-cli_add_path (void * v, char ** reply, int * len, void * data)
+cli_add_path (void *v, struct strbuf *reply, void *data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 	char * param = get_keyparam(v, PATH);
@@ -653,13 +604,13 @@ cli_add_path (void * v, char ** reply, int * len, void * data)
 	}
 	return ev_add_path(pp, vecs, 1);
 blacklisted:
-	SET_REPLY_AND_LEN(reply, len, "blacklisted\n");
+	append_strbuf_str(reply, "blacklisted\n");
 	condlog(2, "%s: path blacklisted", param);
 	return 0;
 }
 
 static int
-cli_del_path (void * v, char ** reply, int * len, void * data)
+cli_del_path (void * v, struct strbuf *reply, void * data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 	char * param = get_keyparam(v, PATH);
@@ -675,14 +626,14 @@ cli_del_path (void * v, char ** reply, int * len, void * data)
 	}
 	ret = ev_remove_path(pp, vecs, 1);
 	if (ret == REMOVE_PATH_DELAY)
-		SET_REPLY_AND_LEN(reply, len, "delayed\n");
+		append_strbuf_str(reply, "delayed\n");
 	else if (ret == REMOVE_PATH_MAP_ERROR)
-		SET_REPLY_AND_LEN(reply, len, "map reload error. removed\n");
+		append_strbuf_str(reply, "map reload error. removed\n");
 	return (ret == REMOVE_PATH_FAILURE);
 }
 
 static int
-cli_add_map (void * v, char ** reply, int * len, void * data)
+cli_add_map (void * v, struct strbuf *reply, void * data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 	char * param = get_keyparam(v, MAP);
@@ -702,7 +653,7 @@ cli_add_map (void * v, char ** reply, int * len, void * data)
 		invalid = 1;
 	pthread_cleanup_pop(1);
 	if (invalid) {
-		SET_REPLY_AND_LEN(reply, len, "blacklisted\n");
+		append_strbuf_str(reply, "blacklisted\n");
 		condlog(2, "%s: map blacklisted", param);
 		return 1;
 	}
@@ -742,7 +693,7 @@ cli_add_map (void * v, char ** reply, int * len, void * data)
 }
 
 static int
-cli_del_map (void * v, char ** reply, int * len, void * data)
+cli_del_map (void * v, struct strbuf *reply, void * data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 	char * param = get_keyparam(v, MAP);
@@ -764,14 +715,14 @@ cli_del_map (void * v, char ** reply, int * len, void * data)
 	}
 	rc = ev_remove_map(param, alias, minor, vecs);
 	if (rc == 2)
-		*reply = strdup("delayed");
+		append_strbuf_str(reply, "delayed");
 
 	FREE(alias);
 	return rc;
 }
 
 static int
-cli_del_maps (void *v, char **reply, int *len, void *data)
+cli_del_maps (void *v, struct strbuf *reply, void *data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 	struct multipath *mpp;
@@ -790,7 +741,7 @@ cli_del_maps (void *v, char **reply, int *len, void *data)
 }
 
 static int
-cli_reload(void *v, char **reply, int *len, void *data)
+cli_reload(void *v, struct strbuf *reply, void *data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 	char * mapname = get_keyparam(v, MAP);
@@ -843,7 +794,7 @@ static int resize_map(struct multipath *mpp, unsigned long long size,
 }
 
 static int
-cli_resize(void *v, char **reply, int *len, void *data)
+cli_resize(void *v, struct strbuf *reply, void *data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 	char * mapname = get_keyparam(v, MAP);
@@ -908,7 +859,7 @@ cli_resize(void *v, char **reply, int *len, void *data)
 }
 
 static int
-cli_force_no_daemon_q(void * v, char ** reply, int * len, void * data)
+cli_force_no_daemon_q(void * v, struct strbuf *reply, void * data)
 {
 	struct config *conf;
 
@@ -921,7 +872,7 @@ cli_force_no_daemon_q(void * v, char ** reply, int * len, void * data)
 }
 
 static int
-cli_restore_no_daemon_q(void * v, char ** reply, int * len, void * data)
+cli_restore_no_daemon_q(void * v, struct strbuf *reply, void * data)
 {
 	struct config *conf;
 
@@ -934,7 +885,7 @@ cli_restore_no_daemon_q(void * v, char ** reply, int * len, void * data)
 }
 
 static int
-cli_restore_queueing(void *v, char **reply, int *len, void *data)
+cli_restore_queueing(void *v, struct strbuf *reply, void *data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 	char * mapname = get_keyparam(v, MAP);
@@ -975,7 +926,7 @@ cli_restore_queueing(void *v, char **reply, int *len, void *data)
 }
 
 static int
-cli_restore_all_queueing(void *v, char **reply, int *len, void *data)
+cli_restore_all_queueing(void *v, struct strbuf *reply, void *data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 	struct multipath *mpp;
@@ -997,7 +948,7 @@ cli_restore_all_queueing(void *v, char **reply, int *len, void *data)
 }
 
 static int
-cli_disable_queueing(void *v, char **reply, int *len, void *data)
+cli_disable_queueing(void *v, struct strbuf *reply, void *data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 	char * mapname = get_keyparam(v, MAP);
@@ -1026,7 +977,7 @@ cli_disable_queueing(void *v, char **reply, int *len, void *data)
 }
 
 static int
-cli_disable_all_queueing(void *v, char **reply, int *len, void *data)
+cli_disable_all_queueing(void *v, struct strbuf *reply, void *data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 	struct multipath *mpp;
@@ -1045,7 +996,7 @@ cli_disable_all_queueing(void *v, char **reply, int *len, void *data)
 }
 
 static int
-cli_switch_group(void * v, char ** reply, int * len, void * data)
+cli_switch_group(void * v, struct strbuf *reply, void * data)
 {
 	char * mapname = get_keyparam(v, MAP);
 	int groupnum = atoi(get_keyparam(v, GROUP));
@@ -1057,7 +1008,7 @@ cli_switch_group(void * v, char ** reply, int * len, void * data)
 }
 
 static int
-cli_reconfigure(void * v, char ** reply, int * len, void * data)
+cli_reconfigure(void * v, struct strbuf *reply, void * data)
 {
 	condlog(2, "reconfigure (operator)");
 
@@ -1066,7 +1017,7 @@ cli_reconfigure(void * v, char ** reply, int * len, void * data)
 }
 
 static int
-cli_suspend(void * v, char ** reply, int * len, void * data)
+cli_suspend(void * v, struct strbuf *reply, void * data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 	char * param = get_keyparam(v, MAP);
@@ -1096,7 +1047,7 @@ cli_suspend(void * v, char ** reply, int * len, void * data)
 }
 
 static int
-cli_resume(void * v, char ** reply, int * len, void * data)
+cli_resume(void * v, struct strbuf *reply, void * data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 	char * param = get_keyparam(v, MAP);
@@ -1128,7 +1079,7 @@ cli_resume(void * v, char ** reply, int * len, void * data)
 }
 
 static int
-cli_reinstate(void * v, char ** reply, int * len, void * data)
+cli_reinstate(void * v, struct strbuf *reply, void * data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 	char * param = get_keyparam(v, PATH);
@@ -1151,7 +1102,7 @@ cli_reinstate(void * v, char ** reply, int * len, void * data)
 }
 
 static int
-cli_reassign (void * v, char ** reply, int * len, void * data)
+cli_reassign (void * v, struct strbuf *reply, void * data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 	char * param = get_keyparam(v, MAP);
@@ -1175,7 +1126,7 @@ cli_reassign (void * v, char ** reply, int * len, void * data)
 }
 
 static int
-cli_fail(void * v, char ** reply, int * len, void * data)
+cli_fail(void * v, struct strbuf *reply, void * data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 	char * param = get_keyparam(v, PATH);
@@ -1204,72 +1155,65 @@ cli_fail(void * v, char ** reply, int * len, void * data)
 }
 
 static int
-show_blacklist (char ** r, int * len)
+show_blacklist (struct strbuf *reply)
 {
-	STRBUF_ON_STACK(reply);
 	struct config *conf;
 	bool fail;
 
 	conf = get_multipath_config();
 	pthread_cleanup_push(put_multipath_config, conf);
-	fail = snprint_blacklist_report(conf, &reply) < 0;
+	fail = snprint_blacklist_report(conf, reply) < 0;
 	pthread_cleanup_pop(1);
 
 	if (fail)
 		return 1;
 
-	*len = (int)get_strbuf_len(&reply) + 1;
-	*r = steal_strbuf_str(&reply);
 	return 0;
 }
 
 static int
-cli_list_blacklist (void * v, char ** reply, int * len, void * data)
+cli_list_blacklist (void * v, struct strbuf *reply, void * data)
 {
 	condlog(3, "list blacklist (operator)");
 
-	return show_blacklist(reply, len);
+	return show_blacklist(reply);
 }
 
 static int
-show_devices (char ** r, int * len, struct vectors *vecs)
+show_devices (struct strbuf *reply, struct vectors *vecs)
 {
-	STRBUF_ON_STACK(reply);
 	struct config *conf;
 	bool fail;
 
 	conf = get_multipath_config();
 	pthread_cleanup_push(put_multipath_config, conf);
-	fail = snprint_devices(conf, &reply, vecs) < 0;
+	fail = snprint_devices(conf, reply, vecs) < 0;
 	pthread_cleanup_pop(1);
 
 	if (fail)
 		return 1;
 
-	*len = (int)get_strbuf_len(&reply) + 1;
-	*r = steal_strbuf_str(&reply);
-
 	return 0;
 }
 
 static int
-cli_list_devices (void * v, char ** reply, int * len, void * data)
+cli_list_devices (void * v, struct strbuf *reply, void * data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 
 	condlog(3, "list devices (operator)");
 
-	return show_devices(reply, len, vecs);
+	return show_devices(reply, vecs);
 }
 
 static int
-cli_quit (void * v, char ** reply, int * len, void * data)
+cli_quit (void * v, struct strbuf *reply, void * data)
 {
 	return 0;
 }
 
 static int
-cli_shutdown (void * v, char ** reply, int * len, void * data)
+cli_shutdown (void * v, struct strbuf *reply, void * data)
 {
 	condlog(3, "shutdown (operator)");
 	exit_daemon();
@@ -1277,7 +1221,7 @@ cli_shutdown (void * v, char ** reply, int * len, void * data)
 }
 
 static int
-cli_getprstatus (void * v, char ** reply, int * len, void * data)
+cli_getprstatus (void * v, struct strbuf *reply, void * data)
 {
 	struct multipath * mpp;
 	struct vectors * vecs = (struct vectors *)data;
@@ -1292,17 +1236,16 @@ cli_getprstatus (void * v, char ** reply, int * len, void * data)
 
 	condlog(3, "%s: prflag = %u", param, (unsigned int)mpp->prflag);
 
-	*len = asprintf(reply, "%d", mpp->prflag);
-	if (*len < 0)
+	if (print_strbuf(reply, "%d", mpp->prflag) < 0)
 		return 1;
 
-	condlog(3, "%s: reply = %s", param, *reply);
+	condlog(3, "%s: reply = %s", param, get_strbuf_str(reply));
 
 	return 0;
 }
 
 static int
-cli_setprstatus(void * v, char ** reply, int * len, void * data)
+cli_setprstatus(void * v, struct strbuf *reply, void * data)
 {
 	struct multipath * mpp;
 	struct vectors * vecs = (struct vectors *)data;
@@ -1325,7 +1268,7 @@ cli_setprstatus(void * v, char ** reply, int * len, void * data)
 }
 
 static int
-cli_unsetprstatus(void * v, char ** reply, int * len, void * data)
+cli_unsetprstatus(void * v, struct strbuf *reply, void * data)
 {
 	struct multipath * mpp;
 	struct vectors * vecs = (struct vectors *)data;
@@ -1347,7 +1290,7 @@ cli_unsetprstatus(void * v, char ** reply, int * len, void * data)
 }
 
 static int
-cli_getprkey(void * v, char ** reply, int * len, void * data)
+cli_getprkey(void * v, struct strbuf *reply, void * data)
 {
 	struct multipath * mpp;
 	struct vectors * vecs = (struct vectors *)data;
@@ -1361,25 +1304,20 @@ cli_getprkey(void * v, char ** reply, int * len, void * data)
 	if (!mpp)
 		return 1;
 
-	*reply = malloc(26);
-	if (!*reply)
-		return 1;
-
 	key = get_be64(mpp->reservation_key);
 	if (!key) {
-		sprintf(*reply, "none\n");
-		*len = sizeof("none\n");
+		append_strbuf_str(reply, "none\n");
 		return 0;
 	}
 
-	/* This snprintf() can't overflow - PRIx64 needs max 16 chars */
-	*len = snprintf(*reply, 26, "0x%" PRIx64 "%s\n", key,
-			mpp->sa_flags & MPATH_F_APTPL_MASK ? ":aptpl" : "") + 1;
+	if (print_strbuf(reply, "0x%" PRIx64 "%s\n", key,
+			 mpp->sa_flags & MPATH_F_APTPL_MASK ? ":aptpl" : "") < 0)
+		return 1;
 	return 0;
 }
 
 static int
-cli_unsetprkey(void * v, char ** reply, int * len, void * data)
+cli_unsetprkey(void * v, struct strbuf *reply, void * data)
 {
 	struct multipath * mpp;
 	struct vectors * vecs = (struct vectors *)data;
@@ -1403,7 +1341,7 @@ cli_unsetprkey(void * v, char ** reply, int * len, void * data)
 }
 
 static int
-cli_setprkey(void * v, char ** reply, int * len, void * data)
+cli_setprkey(void * v, struct strbuf *reply, void * data)
 {
 	struct multipath * mpp;
 	struct vectors * vecs = (struct vectors *)data;
@@ -1434,7 +1372,7 @@ cli_setprkey(void * v, char ** reply, int * len, void * data)
 	return ret;
 }
 
-static int cli_set_marginal(void * v, char ** reply, int * len, void * data)
+static int cli_set_marginal(void * v, struct strbuf *reply, void * data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 	char * param = get_keyparam(v, PATH);
@@ -1461,7 +1399,7 @@ static int cli_set_marginal(void * v, char ** reply, int * len, void * data)
 	return reload_and_sync_map(pp->mpp, vecs, 0);
 }
 
-static int cli_unset_marginal(void * v, char ** reply, int * len, void * data)
+static int cli_unset_marginal(void * v, struct strbuf *reply, void * data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 	char * param = get_keyparam(v, PATH);
@@ -1488,7 +1426,7 @@ static int cli_unset_marginal(void * v, char ** reply, int * len, void * data)
 	return reload_and_sync_map(pp->mpp, vecs, 0);
 }
 
-static int cli_unset_all_marginal(void * v, char ** reply, int * len, void * data)
+static int cli_unset_all_marginal(void * v, struct strbuf *reply, void * data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 	char * mapname = get_keyparam(v, MAP);
diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index eff4f7b..9a945ea 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -294,7 +294,7 @@ static void handle_inotify(int fd, struct watch_descriptors *wds)
 
 static const struct timespec ts_zero = { .tv_sec = 0, };
 
-static int parse_cmd (char *cmd, char **reply, int *len, void *data,
+static int parse_cmd (char *cmd, struct strbuf *reply, void *data,
 		      int timeout)
 {
 	int r;
@@ -305,10 +305,9 @@ static int parse_cmd (char *cmd, char **reply, int *len, void *data,
 	r = get_cmdvec(cmd, &cmdvec);
 
 	if (r) {
-		*reply = genhelp_handler(cmd, r);
-		if (*reply == NULL)
+		genhelp_handler(cmd, r, reply);
+		if (get_strbuf_len(reply) == 0)
 			return EINVAL;
-		*len = strlen(*reply) + 1;
 		return 0;
 	}
 
@@ -316,10 +315,9 @@ static int parse_cmd (char *cmd, char **reply, int *len, void *data,
 
 	if (!h || !h->fn) {
 		free_keys(cmdvec);
-		*reply = genhelp_handler(cmd, EINVAL);
-		if (*reply == NULL)
+		genhelp_handler(cmd, EINVAL, reply);
+		if (get_strbuf_len(reply) == 0)
 			return EINVAL;
-		*len = strlen(*reply) + 1;
 		return 0;
 	}
 
@@ -345,50 +343,42 @@ static int parse_cmd (char *cmd, char **reply, int *len, void *data,
 		if (r == 0) {
 			locked = 1;
 			pthread_testcancel();
-			r = h->fn(cmdvec, reply, len, data);
+			r = h->fn(cmdvec, reply, data);
 		}
 		pthread_cleanup_pop(locked);
 	} else
-		r = h->fn(cmdvec, reply, len, data);
+		r = h->fn(cmdvec, reply, data);
 	free_keys(cmdvec);
 
 	return r;
 }
 
-static int uxsock_trigger(char *str, char **reply, int *len,
+static int uxsock_trigger(char *str, struct strbuf *reply,
 			  bool is_root, void *trigger_data)
 {
 	struct vectors * vecs;
 	int r;
 
-	*reply = NULL;
-	*len = 0;
 	vecs = (struct vectors *)trigger_data;
 
 	if ((str != NULL) && (is_root == false) &&
 	    (strncmp(str, "list", strlen("list")) != 0) &&
 	    (strncmp(str, "show", strlen("show")) != 0)) {
-		*reply = STRDUP("permission deny: need to be root");
-		if (*reply)
-			*len = strlen(*reply) + 1;
+		append_strbuf_str(reply, "permission deny: need to be root");
 		return 1;
 	}
 
-	r = parse_cmd(str, reply, len, vecs, uxsock_timeout / 1000);
+	r = parse_cmd(str, reply, vecs, uxsock_timeout / 1000);
 
 	if (r > 0) {
 		if (r == ETIMEDOUT)
-			*reply = STRDUP("timeout\n");
+			append_strbuf_str(reply, "timeout\n");
 		else
-			*reply = STRDUP("fail\n");
-		if (*reply)
-			*len = strlen(*reply) + 1;
+			append_strbuf_str(reply, "fail\n");
 		r = 1;
 	}
-	else if (!r && *len == 0) {
-		*reply = STRDUP("ok\n");
-		if (*reply)
-			*len = strlen(*reply) + 1;
+	else if (!r && get_strbuf_len(reply) == 0) {
+		append_strbuf_str(reply, "ok\n");
 		r = 0;
 	}
 	/* else if (r < 0) leave *reply alone */
@@ -417,8 +407,6 @@ static void set_client_state(struct client *c, int state)
 
 static void handle_client(struct client *c, void *trigger_data)
 {
-	int rlen;
-	char *reply;
 	ssize_t n;
 
 	switch (c->state) {
@@ -467,12 +455,13 @@ static void handle_client(struct client *c, void *trigger_data)
 	}
 
 	condlog(4, "cli[%d]: Got request [%s]", c->fd, c->cmd);
-	uxsock_trigger(c->cmd, &reply, &rlen,
-		       _socket_client_is_root(c->fd),
+	uxsock_trigger(c->cmd, &c->reply, _socket_client_is_root(c->fd),
 		       trigger_data);
 
-	if (reply) {
-		if (send_packet(c->fd, reply) != 0)
+	if (get_strbuf_len(&c->reply) > 0) {
+		const char *buf = get_strbuf_str(&c->reply);
+
+		if (send_packet(c->fd, buf) != 0)
 			dead_client(c);
 		else
 			condlog(4, "cli[%d]: Reply [%zu bytes]", c->fd,
-- 
2.33.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

