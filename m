Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65746C433FE
	for <dm-devel@archiver.kernel.org>; Sat, 27 Nov 2021 15:20:43 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-496-FR19Y7-qNbyxZsLGw_Gl1Q-1; Sat, 27 Nov 2021 10:20:38 -0500
X-MC-Unique: FR19Y7-qNbyxZsLGw_Gl1Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A9356185302B;
	Sat, 27 Nov 2021 15:20:32 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8FB8E6788F;
	Sat, 27 Nov 2021 15:20:32 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6B4E24A7CD;
	Sat, 27 Nov 2021 15:20:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ARFJqt9032733 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 27 Nov 2021 10:19:52 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 38F522166B2D; Sat, 27 Nov 2021 15:19:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 337292166B25
	for <dm-devel@redhat.com>; Sat, 27 Nov 2021 15:19:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 349F0811E76
	for <dm-devel@redhat.com>; Sat, 27 Nov 2021 15:19:49 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-2-CnhLCO1qOQm5M6AVTRX4Bw-1; Sat, 27 Nov 2021 10:19:47 -0500
X-MC-Unique: CnhLCO1qOQm5M6AVTRX4Bw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BA1451FD2A;
	Sat, 27 Nov 2021 15:19:45 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6411513AAD;
	Sat, 27 Nov 2021 15:19:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id cJc3FpFMomErFgAAMHmgww
	(envelope-from <mwilck@suse.com>); Sat, 27 Nov 2021 15:19:45 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Sat, 27 Nov 2021 16:19:04 +0100
Message-Id: <20211127151929.7727-12-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1ARFJqt9032733
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, Chongyun Wu <wu.chongyun@h3c.com>,
	dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v3 11/35] multipathd: make all cli_handlers static
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

The cli_handler functions are only called from the handler table and
need not be exported.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/cli_handlers.c | 214 ++++++++++++++++++++++----------------
 multipathd/cli_handlers.h |  61 ++---------
 multipathd/main.c         |  58 +----------
 3 files changed, 134 insertions(+), 199 deletions(-)

diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index db2708b..911272c 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -38,7 +38,7 @@
 		*(__len) = *(__rep) ? sizeof(string_literal) : 0;	\
 	} while (0)
 
-int
+static int
 show_paths (char ** r, int * len, struct vectors * vecs, char * style,
 	    int pretty)
 {
@@ -69,7 +69,7 @@ show_paths (char ** r, int * len, struct vectors * vecs, char * style,
 	return 0;
 }
 
-int
+static int
 show_path (char ** r, int * len, struct vectors * vecs, struct path *pp,
 	   char * style)
 {
@@ -84,7 +84,7 @@ show_path (char ** r, int * len, struct vectors * vecs, struct path *pp,
 	return 0;
 }
 
-int
+static int
 show_map_topology (char ** r, int * len, struct multipath * mpp,
 		   struct vectors * vecs)
 {
@@ -101,7 +101,7 @@ show_map_topology (char ** r, int * len, struct multipath * mpp,
 	return 0;
 }
 
-int
+static int
 show_maps_topology (char ** r, int * len, struct vectors * vecs)
 {
 	STRBUF_ON_STACK(reply);
@@ -127,7 +127,7 @@ show_maps_topology (char ** r, int * len, struct vectors * vecs)
 	return 0;
 }
 
-int
+static int
 show_maps_json (char ** r, int * len, struct vectors * vecs)
 {
 	STRBUF_ON_STACK(reply);
@@ -148,7 +148,7 @@ show_maps_json (char ** r, int * len, struct vectors * vecs)
 	return 0;
 }
 
-int
+static int
 show_map_json (char ** r, int * len, struct multipath * mpp,
 		   struct vectors * vecs)
 {
@@ -193,7 +193,7 @@ reset_stats(struct multipath * mpp)
 	mpp->stat_map_failures = 0;
 }
 
-int
+static int
 cli_list_config (void * v, char ** reply, int * len, void * data)
 {
 	condlog(3, "list config (operator)");
@@ -206,7 +206,7 @@ static void v_free(void *x)
 	vector_free(x);
 }
 
-int
+static int
 cli_list_config_local (void * v, char ** reply, int * len, void * data)
 {
 	struct vectors * vecs = (struct vectors *)data;
@@ -222,7 +222,7 @@ cli_list_config_local (void * v, char ** reply, int * len, void * data)
 	return ret;
 }
 
-int
+static int
 cli_list_paths (void * v, char ** reply, int * len, void * data)
 {
 	struct vectors * vecs = (struct vectors *)data;
@@ -232,7 +232,7 @@ cli_list_paths (void * v, char ** reply, int * len, void * data)
 	return show_paths(reply, len, vecs, PRINT_PATH_CHECKER, 1);
 }
 
-int
+static int
 cli_list_paths_fmt (void * v, char ** reply, int * len, void * data)
 {
 	struct vectors * vecs = (struct vectors *)data;
@@ -243,7 +243,7 @@ cli_list_paths_fmt (void * v, char ** reply, int * len, void * data)
 	return show_paths(reply, len, vecs, fmt, 1);
 }
 
-int
+static int
 cli_list_paths_raw (void * v, char ** reply, int * len, void * data)
 {
 	struct vectors * vecs = (struct vectors *)data;
@@ -254,7 +254,7 @@ cli_list_paths_raw (void * v, char ** reply, int * len, void * data)
 	return show_paths(reply, len, vecs, fmt, 0);
 }
 
-int
+static int
 cli_list_path (void * v, char ** reply, int * len, void * data)
 {
 	struct vectors * vecs = (struct vectors *)data;
@@ -271,7 +271,7 @@ cli_list_path (void * v, char ** reply, int * len, void * data)
 	return show_path(reply, len, vecs, pp, "%o");
 }
 
-int
+static int
 cli_list_map_topology (void * v, char ** reply, int * len, void * data)
 {
 	struct multipath * mpp;
@@ -290,7 +290,7 @@ cli_list_map_topology (void * v, char ** reply, int * len, void * data)
 	return show_map_topology(reply, len, mpp, vecs);
 }
 
-int
+static int
 cli_list_maps_topology (void * v, char ** reply, int * len, void * data)
 {
 	struct vectors * vecs = (struct vectors *)data;
@@ -300,7 +300,7 @@ cli_list_maps_topology (void * v, char ** reply, int * len, void * data)
 	return show_maps_topology(reply, len, vecs);
 }
 
-int
+static int
 cli_list_map_json (void * v, char ** reply, int * len, void * data)
 {
 	struct multipath * mpp;
@@ -319,7 +319,7 @@ cli_list_map_json (void * v, char ** reply, int * len, void * data)
 	return show_map_json(reply, len, mpp, vecs);
 }
 
-int
+static int
 cli_list_maps_json (void * v, char ** reply, int * len, void * data)
 {
 	struct vectors * vecs = (struct vectors *)data;
@@ -329,7 +329,7 @@ cli_list_maps_json (void * v, char ** reply, int * len, void * data)
 	return show_maps_json(reply, len, vecs);
 }
 
-int
+static int
 cli_list_wildcards (void * v, char ** reply, int * len, void * data)
 {
 	STRBUF_ON_STACK(buf);
@@ -342,7 +342,7 @@ cli_list_wildcards (void * v, char ** reply, int * len, void * data)
 	return 0;
 }
 
-int
+static int
 show_status (char ** r, int *len, struct vectors * vecs)
 {
 	STRBUF_ON_STACK(reply);
@@ -355,7 +355,7 @@ show_status (char ** r, int *len, struct vectors * vecs)
 	return 0;
 }
 
-int
+static int
 show_daemon (char ** r, int *len)
 {
 	STRBUF_ON_STACK(reply);
@@ -369,7 +369,7 @@ show_daemon (char ** r, int *len)
 	return 0;
 }
 
-int
+static int
 show_map (char ** r, int *len, struct multipath * mpp, char * style,
 	  int pretty)
 {
@@ -383,7 +383,7 @@ show_map (char ** r, int *len, struct multipath * mpp, char * style,
 	return 0;
 }
 
-int
+static int
 show_maps (char ** r, int *len, struct vectors * vecs, char * style,
 	   int pretty)
 {
@@ -418,7 +418,7 @@ show_maps (char ** r, int *len, struct vectors * vecs, char * style,
 	return 0;
 }
 
-int
+static int
 cli_list_maps_fmt (void * v, char ** reply, int * len, void * data)
 {
 	struct vectors * vecs = (struct vectors *)data;
@@ -429,7 +429,7 @@ cli_list_maps_fmt (void * v, char ** reply, int * len, void * data)
 	return show_maps(reply, len, vecs, fmt, 1);
 }
 
-int
+static int
 cli_list_maps_raw (void * v, char ** reply, int * len, void * data)
 {
 	struct vectors * vecs = (struct vectors *)data;
@@ -440,7 +440,7 @@ cli_list_maps_raw (void * v, char ** reply, int * len, void * data)
 	return show_maps(reply, len, vecs, fmt, 0);
 }
 
-int
+static int
 cli_list_map_fmt (void * v, char ** reply, int * len, void * data)
 {
 	struct multipath * mpp;
@@ -460,27 +460,7 @@ cli_list_map_fmt (void * v, char ** reply, int * len, void * data)
 	return show_map(reply, len, mpp, fmt, 1);
 }
 
-int
-cli_list_map_raw (void * v, char ** reply, int * len, void * data)
-{
-	struct multipath * mpp;
-	struct vectors * vecs = (struct vectors *)data;
-	char * param = get_keyparam(v, MAP);
-	char * fmt = get_keyparam(v, FMT);
-
-	param = convert_dev(param, 0);
-	get_path_layout(vecs->pathvec, 0);
-	get_multipath_layout(vecs->mpvec, 1);
-	mpp = find_mp_by_str(vecs->mpvec, param);
-	if (!mpp)
-		return 1;
-
-	condlog(3, "list map %s fmt %s (operator)", param, fmt);
-
-	return show_map(reply, len, mpp, fmt, 0);
-}
-
-int
+static int
 cli_list_maps (void * v, char ** reply, int * len, void * data)
 {
 	struct vectors * vecs = (struct vectors *)data;
@@ -490,7 +470,7 @@ cli_list_maps (void * v, char ** reply, int * len, void * data)
 	return show_maps(reply, len, vecs, PRINT_MAP_NAMES, 1);
 }
 
-int
+static int
 cli_list_status (void * v, char ** reply, int * len, void * data)
 {
 	struct vectors * vecs = (struct vectors *)data;
@@ -500,7 +480,7 @@ cli_list_status (void * v, char ** reply, int * len, void * data)
 	return show_status(reply, len, vecs);
 }
 
-int
+static int
 cli_list_maps_status (void * v, char ** reply, int * len, void * data)
 {
 	struct vectors * vecs = (struct vectors *)data;
@@ -510,7 +490,7 @@ cli_list_maps_status (void * v, char ** reply, int * len, void * data)
 	return show_maps(reply, len, vecs, PRINT_MAP_STATUS, 1);
 }
 
-int
+static int
 cli_list_maps_stats (void * v, char ** reply, int * len, void * data)
 {
 	struct vectors * vecs = (struct vectors *)data;
@@ -520,7 +500,7 @@ cli_list_maps_stats (void * v, char ** reply, int * len, void * data)
 	return show_maps(reply, len, vecs, PRINT_MAP_STATS, 1);
 }
 
-int
+static int
 cli_list_daemon (void * v, char ** reply, int * len, void * data)
 {
 	condlog(3, "list daemon (operator)");
@@ -528,7 +508,7 @@ cli_list_daemon (void * v, char ** reply, int * len, void * data)
 	return show_daemon(reply, len);
 }
 
-int
+static int
 cli_reset_maps_stats (void * v, char ** reply, int * len, void * data)
 {
 	struct vectors * vecs = (struct vectors *)data;
@@ -543,7 +523,7 @@ cli_reset_maps_stats (void * v, char ** reply, int * len, void * data)
 	return 0;
 }
 
-int
+static int
 cli_reset_map_stats (void * v, char ** reply, int * len, void * data)
 {
 	struct vectors * vecs = (struct vectors *)data;
@@ -561,7 +541,7 @@ cli_reset_map_stats (void * v, char ** reply, int * len, void * data)
 	return 0;
 }
 
-int
+static int
 cli_add_path (void * v, char ** reply, int * len, void * data)
 {
 	struct vectors * vecs = (struct vectors *)data;
@@ -677,7 +657,7 @@ blacklisted:
 	return 0;
 }
 
-int
+static int
 cli_del_path (void * v, char ** reply, int * len, void * data)
 {
 	struct vectors * vecs = (struct vectors *)data;
@@ -700,7 +680,7 @@ cli_del_path (void * v, char ** reply, int * len, void * data)
 	return (ret == REMOVE_PATH_FAILURE);
 }
 
-int
+static int
 cli_add_map (void * v, char ** reply, int * len, void * data)
 {
 	struct vectors * vecs = (struct vectors *)data;
@@ -760,7 +740,7 @@ cli_add_map (void * v, char ** reply, int * len, void * data)
 	return rc;
 }
 
-int
+static int
 cli_del_map (void * v, char ** reply, int * len, void * data)
 {
 	struct vectors * vecs = (struct vectors *)data;
@@ -789,7 +769,7 @@ cli_del_map (void * v, char ** reply, int * len, void * data)
 	return rc;
 }
 
-int
+static int
 cli_del_maps (void *v, char **reply, int *len, void *data)
 {
 	struct vectors * vecs = (struct vectors *)data;
@@ -808,7 +788,7 @@ cli_del_maps (void *v, char **reply, int *len, void *data)
 	return ret;
 }
 
-int
+static int
 cli_reload(void *v, char **reply, int *len, void *data)
 {
 	struct vectors * vecs = (struct vectors *)data;
@@ -836,7 +816,7 @@ cli_reload(void *v, char **reply, int *len, void *data)
 	return reload_and_sync_map(mpp, vecs, 0);
 }
 
-int resize_map(struct multipath *mpp, unsigned long long size,
+static int resize_map(struct multipath *mpp, unsigned long long size,
 	       struct vectors * vecs)
 {
 	char *params __attribute__((cleanup(cleanup_charp))) = NULL;
@@ -861,7 +841,7 @@ int resize_map(struct multipath *mpp, unsigned long long size,
 	return 0;
 }
 
-int
+static int
 cli_resize(void *v, char **reply, int *len, void *data)
 {
 	struct vectors * vecs = (struct vectors *)data;
@@ -926,7 +906,7 @@ cli_resize(void *v, char **reply, int *len, void *data)
 	return 0;
 }
 
-int
+static int
 cli_force_no_daemon_q(void * v, char ** reply, int * len, void * data)
 {
 	struct config *conf;
@@ -939,7 +919,7 @@ cli_force_no_daemon_q(void * v, char ** reply, int * len, void * data)
 	return 0;
 }
 
-int
+static int
 cli_restore_no_daemon_q(void * v, char ** reply, int * len, void * data)
 {
 	struct config *conf;
@@ -952,7 +932,7 @@ cli_restore_no_daemon_q(void * v, char ** reply, int * len, void * data)
 	return 0;
 }
 
-int
+static int
 cli_restore_queueing(void *v, char **reply, int *len, void *data)
 {
 	struct vectors * vecs = (struct vectors *)data;
@@ -993,7 +973,7 @@ cli_restore_queueing(void *v, char **reply, int *len, void *data)
 	return 0;
 }
 
-int
+static int
 cli_restore_all_queueing(void *v, char **reply, int *len, void *data)
 {
 	struct vectors * vecs = (struct vectors *)data;
@@ -1015,7 +995,7 @@ cli_restore_all_queueing(void *v, char **reply, int *len, void *data)
 	return 0;
 }
 
-int
+static int
 cli_disable_queueing(void *v, char **reply, int *len, void *data)
 {
 	struct vectors * vecs = (struct vectors *)data;
@@ -1044,7 +1024,7 @@ cli_disable_queueing(void *v, char **reply, int *len, void *data)
 	return 0;
 }
 
-int
+static int
 cli_disable_all_queueing(void *v, char **reply, int *len, void *data)
 {
 	struct vectors * vecs = (struct vectors *)data;
@@ -1063,7 +1043,7 @@ cli_disable_all_queueing(void *v, char **reply, int *len, void *data)
 	return 0;
 }
 
-int
+static int
 cli_switch_group(void * v, char ** reply, int * len, void * data)
 {
 	char * mapname = get_keyparam(v, MAP);
@@ -1075,7 +1055,7 @@ cli_switch_group(void * v, char ** reply, int * len, void * data)
 	return dm_switchgroup(mapname, groupnum);
 }
 
-int
+static int
 cli_reconfigure(void * v, char ** reply, int * len, void * data)
 {
 	condlog(2, "reconfigure (operator)");
@@ -1084,7 +1064,7 @@ cli_reconfigure(void * v, char ** reply, int * len, void * data)
 	return 0;
 }
 
-int
+static int
 cli_suspend(void * v, char ** reply, int * len, void * data)
 {
 	struct vectors * vecs = (struct vectors *)data;
@@ -1114,7 +1094,7 @@ cli_suspend(void * v, char ** reply, int * len, void * data)
 	return 0;
 }
 
-int
+static int
 cli_resume(void * v, char ** reply, int * len, void * data)
 {
 	struct vectors * vecs = (struct vectors *)data;
@@ -1146,7 +1126,7 @@ cli_resume(void * v, char ** reply, int * len, void * data)
 	return 0;
 }
 
-int
+static int
 cli_reinstate(void * v, char ** reply, int * len, void * data)
 {
 	struct vectors * vecs = (struct vectors *)data;
@@ -1169,7 +1149,7 @@ cli_reinstate(void * v, char ** reply, int * len, void * data)
 	return dm_reinstate_path(pp->mpp->alias, pp->dev_t);
 }
 
-int
+static int
 cli_reassign (void * v, char ** reply, int * len, void * data)
 {
 	struct vectors * vecs = (struct vectors *)data;
@@ -1193,7 +1173,7 @@ cli_reassign (void * v, char ** reply, int * len, void * data)
 	return 0;
 }
 
-int
+static int
 cli_fail(void * v, char ** reply, int * len, void * data)
 {
 	struct vectors * vecs = (struct vectors *)data;
@@ -1222,7 +1202,7 @@ cli_fail(void * v, char ** reply, int * len, void * data)
 	return r;
 }
 
-int
+static int
 show_blacklist (char ** r, int * len)
 {
 	STRBUF_ON_STACK(reply);
@@ -1242,7 +1222,7 @@ show_blacklist (char ** r, int * len)
 	return 0;
 }
 
-int
+static int
 cli_list_blacklist (void * v, char ** reply, int * len, void * data)
 {
 	condlog(3, "list blacklist (operator)");
@@ -1250,7 +1230,7 @@ cli_list_blacklist (void * v, char ** reply, int * len, void * data)
 	return show_blacklist(reply, len);
 }
 
-int
+static int
 show_devices (char ** r, int * len, struct vectors *vecs)
 {
 	STRBUF_ON_STACK(reply);
@@ -1271,7 +1251,7 @@ show_devices (char ** r, int * len, struct vectors *vecs)
 	return 0;
 }
 
-int
+static int
 cli_list_devices (void * v, char ** reply, int * len, void * data)
 {
 	struct vectors * vecs = (struct vectors *)data;
@@ -1281,13 +1261,13 @@ cli_list_devices (void * v, char ** reply, int * len, void * data)
 	return show_devices(reply, len, vecs);
 }
 
-int
+static int
 cli_quit (void * v, char ** reply, int * len, void * data)
 {
 	return 0;
 }
 
-int
+static int
 cli_shutdown (void * v, char ** reply, int * len, void * data)
 {
 	condlog(3, "shutdown (operator)");
@@ -1295,7 +1275,7 @@ cli_shutdown (void * v, char ** reply, int * len, void * data)
 	return 0;
 }
 
-int
+static int
 cli_getprstatus (void * v, char ** reply, int * len, void * data)
 {
 	struct multipath * mpp;
@@ -1320,7 +1300,7 @@ cli_getprstatus (void * v, char ** reply, int * len, void * data)
 	return 0;
 }
 
-int
+static int
 cli_setprstatus(void * v, char ** reply, int * len, void * data)
 {
 	struct multipath * mpp;
@@ -1343,7 +1323,7 @@ cli_setprstatus(void * v, char ** reply, int * len, void * data)
 	return 0;
 }
 
-int
+static int
 cli_unsetprstatus(void * v, char ** reply, int * len, void * data)
 {
 	struct multipath * mpp;
@@ -1365,7 +1345,7 @@ cli_unsetprstatus(void * v, char ** reply, int * len, void * data)
 	return 0;
 }
 
-int
+static int
 cli_getprkey(void * v, char ** reply, int * len, void * data)
 {
 	struct multipath * mpp;
@@ -1397,7 +1377,7 @@ cli_getprkey(void * v, char ** reply, int * len, void * data)
 	return 0;
 }
 
-int
+static int
 cli_unsetprkey(void * v, char ** reply, int * len, void * data)
 {
 	struct multipath * mpp;
@@ -1421,7 +1401,7 @@ cli_unsetprkey(void * v, char ** reply, int * len, void * data)
 	return ret;
 }
 
-int
+static int
 cli_setprkey(void * v, char ** reply, int * len, void * data)
 {
 	struct multipath * mpp;
@@ -1453,7 +1433,7 @@ cli_setprkey(void * v, char ** reply, int * len, void * data)
 	return ret;
 }
 
-int cli_set_marginal(void * v, char ** reply, int * len, void * data)
+static int cli_set_marginal(void * v, char ** reply, int * len, void * data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 	char * param = get_keyparam(v, PATH);
@@ -1480,7 +1460,7 @@ int cli_set_marginal(void * v, char ** reply, int * len, void * data)
 	return reload_and_sync_map(pp->mpp, vecs, 0);
 }
 
-int cli_unset_marginal(void * v, char ** reply, int * len, void * data)
+static int cli_unset_marginal(void * v, char ** reply, int * len, void * data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 	char * param = get_keyparam(v, PATH);
@@ -1507,7 +1487,7 @@ int cli_unset_marginal(void * v, char ** reply, int * len, void * data)
 	return reload_and_sync_map(pp->mpp, vecs, 0);
 }
 
-int cli_unset_all_marginal(void * v, char ** reply, int * len, void * data)
+static int cli_unset_all_marginal(void * v, char ** reply, int * len, void * data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 	char * mapname = get_keyparam(v, MAP);
@@ -1543,3 +1523,63 @@ int cli_unset_all_marginal(void * v, char ** reply, int * len, void * data)
 
 	return reload_and_sync_map(mpp, vecs, 0);
 }
+
+void init_handler_callbacks(void)
+{
+	set_handler_callback(LIST+PATHS, cli_list_paths);
+	set_handler_callback(LIST+PATHS+FMT, cli_list_paths_fmt);
+	set_handler_callback(LIST+PATHS+RAW+FMT, cli_list_paths_raw);
+	set_handler_callback(LIST+PATH, cli_list_path);
+	set_handler_callback(LIST+MAPS, cli_list_maps);
+	set_handler_callback(LIST+STATUS, cli_list_status);
+	set_unlocked_handler_callback(LIST+DAEMON, cli_list_daemon);
+	set_handler_callback(LIST+MAPS+STATUS, cli_list_maps_status);
+	set_handler_callback(LIST+MAPS+STATS, cli_list_maps_stats);
+	set_handler_callback(LIST+MAPS+FMT, cli_list_maps_fmt);
+	set_handler_callback(LIST+MAPS+RAW+FMT, cli_list_maps_raw);
+	set_handler_callback(LIST+MAPS+TOPOLOGY, cli_list_maps_topology);
+	set_handler_callback(LIST+TOPOLOGY, cli_list_maps_topology);
+	set_handler_callback(LIST+MAPS+JSON, cli_list_maps_json);
+	set_handler_callback(LIST+MAP+TOPOLOGY, cli_list_map_topology);
+	set_handler_callback(LIST+MAP+FMT, cli_list_map_fmt);
+	set_handler_callback(LIST+MAP+RAW+FMT, cli_list_map_fmt);
+	set_handler_callback(LIST+MAP+JSON, cli_list_map_json);
+	set_handler_callback(LIST+CONFIG+LOCAL, cli_list_config_local);
+	set_handler_callback(LIST+CONFIG, cli_list_config);
+	set_handler_callback(LIST+BLACKLIST, cli_list_blacklist);
+	set_handler_callback(LIST+DEVICES, cli_list_devices);
+	set_handler_callback(LIST+WILDCARDS, cli_list_wildcards);
+	set_handler_callback(RESET+MAPS+STATS, cli_reset_maps_stats);
+	set_handler_callback(RESET+MAP+STATS, cli_reset_map_stats);
+	set_handler_callback(ADD+PATH, cli_add_path);
+	set_handler_callback(DEL+PATH, cli_del_path);
+	set_handler_callback(ADD+MAP, cli_add_map);
+	set_handler_callback(DEL+MAP, cli_del_map);
+	set_handler_callback(DEL+MAPS, cli_del_maps);
+	set_handler_callback(SWITCH+MAP+GROUP, cli_switch_group);
+	set_unlocked_handler_callback(RECONFIGURE, cli_reconfigure);
+	set_handler_callback(SUSPEND+MAP, cli_suspend);
+	set_handler_callback(RESUME+MAP, cli_resume);
+	set_handler_callback(RESIZE+MAP, cli_resize);
+	set_handler_callback(RELOAD+MAP, cli_reload);
+	set_handler_callback(RESET+MAP, cli_reassign);
+	set_handler_callback(REINSTATE+PATH, cli_reinstate);
+	set_handler_callback(FAIL+PATH, cli_fail);
+	set_handler_callback(DISABLEQ+MAP, cli_disable_queueing);
+	set_handler_callback(RESTOREQ+MAP, cli_restore_queueing);
+	set_handler_callback(DISABLEQ+MAPS, cli_disable_all_queueing);
+	set_handler_callback(RESTOREQ+MAPS, cli_restore_all_queueing);
+	set_unlocked_handler_callback(QUIT, cli_quit);
+	set_unlocked_handler_callback(SHUTDOWN, cli_shutdown);
+	set_handler_callback(GETPRSTATUS+MAP, cli_getprstatus);
+	set_handler_callback(SETPRSTATUS+MAP, cli_setprstatus);
+	set_handler_callback(UNSETPRSTATUS+MAP, cli_unsetprstatus);
+	set_handler_callback(FORCEQ+DAEMON, cli_force_no_daemon_q);
+	set_handler_callback(RESTOREQ+DAEMON, cli_restore_no_daemon_q);
+	set_handler_callback(GETPRKEY+MAP, cli_getprkey);
+	set_handler_callback(SETPRKEY+MAP+KEY, cli_setprkey);
+	set_handler_callback(UNSETPRKEY+MAP, cli_unsetprkey);
+	set_handler_callback(SETMARGINAL+PATH, cli_set_marginal);
+	set_handler_callback(UNSETMARGINAL+PATH, cli_unset_marginal);
+	set_handler_callback(UNSETMARGINAL+MAP, cli_unset_all_marginal);
+}
diff --git a/multipathd/cli_handlers.h b/multipathd/cli_handlers.h
index 6f57b42..7eaf847 100644
--- a/multipathd/cli_handlers.h
+++ b/multipathd/cli_handlers.h
@@ -1,55 +1,6 @@
-int cli_list_paths (void * v, char ** reply, int * len, void * data);
-int cli_list_paths_fmt (void * v, char ** reply, int * len, void * data);
-int cli_list_paths_raw (void * v, char ** reply, int * len, void * data);
-int cli_list_path (void * v, char ** reply, int * len, void * data);
-int cli_list_status (void * v, char ** reply, int * len, void * data);
-int cli_list_daemon (void * v, char ** reply, int * len, void * data);
-int cli_list_maps (void * v, char ** reply, int * len, void * data);
-int cli_list_maps_fmt (void * v, char ** reply, int * len, void * data);
-int cli_list_maps_raw (void * v, char ** reply, int * len, void * data);
-int cli_list_map_fmt (void * v, char ** reply, int * len, void * data);
-int cli_list_map_raw (void * v, char ** reply, int * len, void * data);
-int cli_list_maps_status (void * v, char ** reply, int * len, void * data);
-int cli_list_maps_stats (void * v, char ** reply, int * len, void * data);
-int cli_list_map_topology (void * v, char ** reply, int * len, void * data);
-int cli_list_maps_topology (void * v, char ** reply, int * len, void * data);
-int cli_list_map_json (void * v, char ** reply, int * len, void * data);
-int cli_list_maps_json (void * v, char ** reply, int * len, void * data);
-int cli_list_config (void * v, char ** reply, int * len, void * data);
-int cli_list_config_local (void * v, char ** reply, int * len, void * data);
-int cli_list_blacklist (void * v, char ** reply, int * len, void * data);
-int cli_list_devices (void * v, char ** reply, int * len, void * data);
-int cli_list_wildcards (void * v, char ** reply, int * len, void * data);
-int cli_reset_maps_stats (void * v, char ** reply, int * len, void * data);
-int cli_reset_map_stats (void * v, char ** reply, int * len, void * data);
-int cli_add_path (void * v, char ** reply, int * len, void * data);
-int cli_del_path (void * v, char ** reply, int * len, void * data);
-int cli_add_map (void * v, char ** reply, int * len, void * data);
-int cli_del_map (void * v, char ** reply, int * len, void * data);
-int cli_del_maps (void * v, char ** reply, int * len, void * data);
-int cli_switch_group(void * v, char ** reply, int * len, void * data);
-int cli_reconfigure(void * v, char ** reply, int * len, void * data);
-int cli_resize(void * v, char ** reply, int * len, void * data);
-int cli_reload(void * v, char ** reply, int * len, void * data);
-int cli_disable_queueing(void * v, char ** reply, int * len, void * data);
-int cli_disable_all_queueing(void * v, char ** reply, int * len, void * data);
-int cli_restore_queueing(void * v, char ** reply, int * len, void * data);
-int cli_restore_all_queueing(void * v, char ** reply, int * len, void * data);
-int cli_suspend(void * v, char ** reply, int * len, void * data);
-int cli_resume(void * v, char ** reply, int * len, void * data);
-int cli_reinstate(void * v, char ** reply, int * len, void * data);
-int cli_fail(void * v, char ** reply, int * len, void * data);
-int cli_force_no_daemon_q(void * v, char ** reply, int * len, void * data);
-int cli_restore_no_daemon_q(void * v, char ** reply, int * len, void * data);
-int cli_quit(void * v, char ** reply, int * len, void * data);
-int cli_shutdown(void * v, char ** reply, int * len, void * data);
-int cli_reassign (void * v, char ** reply, int * len, void * data);
-int cli_getprstatus(void * v, char ** reply, int * len, void * data);
-int cli_setprstatus(void * v, char ** reply, int * len, void * data);
-int cli_unsetprstatus(void * v, char ** reply, int * len, void * data);
-int cli_getprkey(void * v, char ** reply, int * len, void * data);
-int cli_setprkey(void * v, char ** reply, int * len, void * data);
-int cli_unsetprkey(void * v, char ** reply, int * len, void * data);
-int cli_set_marginal(void * v, char ** reply, int * len, void * data);
-int cli_unset_marginal(void * v, char ** reply, int * len, void * data);
-int cli_unset_all_marginal(void * v, char ** reply, int * len, void * data);
+#ifndef _CLI_HANDLERS_H
+#define _CLI_HANDLERS_H
+
+void init_handler_callbacks(void);
+
+#endif
diff --git a/multipathd/main.c b/multipathd/main.c
index 6054fd5..3062f3d 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1703,63 +1703,7 @@ uxlsnrloop (void * ap)
 	/* Tell main thread that thread has started */
 	post_config_state(DAEMON_CONFIGURE);
 
-	set_handler_callback(LIST+PATHS, cli_list_paths);
-	set_handler_callback(LIST+PATHS+FMT, cli_list_paths_fmt);
-	set_handler_callback(LIST+PATHS+RAW+FMT, cli_list_paths_raw);
-	set_handler_callback(LIST+PATH, cli_list_path);
-	set_handler_callback(LIST+MAPS, cli_list_maps);
-	set_handler_callback(LIST+STATUS, cli_list_status);
-	set_unlocked_handler_callback(LIST+DAEMON, cli_list_daemon);
-	set_handler_callback(LIST+MAPS+STATUS, cli_list_maps_status);
-	set_handler_callback(LIST+MAPS+STATS, cli_list_maps_stats);
-	set_handler_callback(LIST+MAPS+FMT, cli_list_maps_fmt);
-	set_handler_callback(LIST+MAPS+RAW+FMT, cli_list_maps_raw);
-	set_handler_callback(LIST+MAPS+TOPOLOGY, cli_list_maps_topology);
-	set_handler_callback(LIST+TOPOLOGY, cli_list_maps_topology);
-	set_handler_callback(LIST+MAPS+JSON, cli_list_maps_json);
-	set_handler_callback(LIST+MAP+TOPOLOGY, cli_list_map_topology);
-	set_handler_callback(LIST+MAP+FMT, cli_list_map_fmt);
-	set_handler_callback(LIST+MAP+RAW+FMT, cli_list_map_fmt);
-	set_handler_callback(LIST+MAP+JSON, cli_list_map_json);
-	set_handler_callback(LIST+CONFIG+LOCAL, cli_list_config_local);
-	set_handler_callback(LIST+CONFIG, cli_list_config);
-	set_handler_callback(LIST+BLACKLIST, cli_list_blacklist);
-	set_handler_callback(LIST+DEVICES, cli_list_devices);
-	set_handler_callback(LIST+WILDCARDS, cli_list_wildcards);
-	set_handler_callback(RESET+MAPS+STATS, cli_reset_maps_stats);
-	set_handler_callback(RESET+MAP+STATS, cli_reset_map_stats);
-	set_handler_callback(ADD+PATH, cli_add_path);
-	set_handler_callback(DEL+PATH, cli_del_path);
-	set_handler_callback(ADD+MAP, cli_add_map);
-	set_handler_callback(DEL+MAP, cli_del_map);
-	set_handler_callback(DEL+MAPS, cli_del_maps);
-	set_handler_callback(SWITCH+MAP+GROUP, cli_switch_group);
-	set_unlocked_handler_callback(RECONFIGURE, cli_reconfigure);
-	set_handler_callback(SUSPEND+MAP, cli_suspend);
-	set_handler_callback(RESUME+MAP, cli_resume);
-	set_handler_callback(RESIZE+MAP, cli_resize);
-	set_handler_callback(RELOAD+MAP, cli_reload);
-	set_handler_callback(RESET+MAP, cli_reassign);
-	set_handler_callback(REINSTATE+PATH, cli_reinstate);
-	set_handler_callback(FAIL+PATH, cli_fail);
-	set_handler_callback(DISABLEQ+MAP, cli_disable_queueing);
-	set_handler_callback(RESTOREQ+MAP, cli_restore_queueing);
-	set_handler_callback(DISABLEQ+MAPS, cli_disable_all_queueing);
-	set_handler_callback(RESTOREQ+MAPS, cli_restore_all_queueing);
-	set_unlocked_handler_callback(QUIT, cli_quit);
-	set_unlocked_handler_callback(SHUTDOWN, cli_shutdown);
-	set_handler_callback(GETPRSTATUS+MAP, cli_getprstatus);
-	set_handler_callback(SETPRSTATUS+MAP, cli_setprstatus);
-	set_handler_callback(UNSETPRSTATUS+MAP, cli_unsetprstatus);
-	set_handler_callback(FORCEQ+DAEMON, cli_force_no_daemon_q);
-	set_handler_callback(RESTOREQ+DAEMON, cli_restore_no_daemon_q);
-	set_handler_callback(GETPRKEY+MAP, cli_getprkey);
-	set_handler_callback(SETPRKEY+MAP+KEY, cli_setprkey);
-	set_handler_callback(UNSETPRKEY+MAP, cli_unsetprkey);
-	set_handler_callback(SETMARGINAL+PATH, cli_set_marginal);
-	set_handler_callback(UNSETMARGINAL+PATH, cli_unset_marginal);
-	set_handler_callback(UNSETMARGINAL+MAP, cli_unset_all_marginal);
-
+	init_handler_callbacks();
 	umask(077);
 	uxsock_listen(&uxsock_trigger, ux_sock, ap);
 
-- 
2.33.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

