Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795670684;
	b=rTBnKA3sakmwnYBTkC36VQzpS4f+4sw18R0xfbR6tPNXLCpWDx+o1vzaaOdOjVXnXzuD
	 mxqV9seKtikjQF8TGEyLoBDe3GRpl5V/KO/N8k5IqUiELqsg21RJqv0vFCkAPVb0hpopr
	 uINTGIaYkSF3Alsr+BFiHwDaeXpkOBjSuHAkFA0b/Lr8aWROp/bobHOcwQFrTHIZ7ve7S
	 oAvtuYVTs82MMaogUW3dkyCsohczrlNSazyFy8ZYxq8K0RtT4yECLYvTK+nHatOTg5pty
	 jgY7lEhKJTyXI8UvN+0AH3J503f4lAdqEdvX97PMyY5LyF4v6Uh2KEMFor8hHXA8QwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795670684;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:In-Reply-To:References:MIME-Version:
	 X-Scanned-By:X-Mimecast-Spam-Score:X-Mimecast-MFC-PROC-ID:
	 X-Mimecast-Originator:Content-Transfer-Encoding:content-type;
	bh=r7Jv/1hIpAAJ2lN0lfawmlPAKAx/pl4W3D4qvmP28wQ=;
	b=x5nzGzCwwtnh/lirkwmNJpk0OfpUgnLwkoFt4LgUGtBZ/kX6wFXRFoN3KJDg0fpDAbnq
	 aUt4c4DBBLbiOci/Cvj9kartDMU+ZMfDhc4o+7k6ZmrRgYhfbQdwe8dM1MzrlqfphZorF
	 rZrwIeINrlMDgFODdMlFVAFmAPqqRoqJHvDalMBoQdL+Oz+C8fK+5W10XghgXQE7kpYgg
	 RMASAc/iOP2PpCGjo77bHVeI4/R0e6AhyQw/YbYxnTz2oebLjw+nlPpg+54uKaL0itxJk
	 pc/lyd39KcgnlPkseEtn7BkiAr9OiMHArYe4UC03fIYd7C+usbQf6D0PEfzeZIJS1Ug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ORk0Lkoc;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D9D606A321
	for <dm-devel@lists.linux.dev>; Thu, 26 Nov 2026 05:24:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 55D9D606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ORk0Lkoc
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795670682;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r7Jv/1hIpAAJ2lN0lfawmlPAKAx/pl4W3D4qvmP28wQ=;
	b=ORk0LkocdFt0ik76JOAfBViIixXhhGbS5mhxTcvDkgRTylGBzz0pqSVY7vn0m+00LBNyYJ
	s3HVajwfqlTugcxN76G1abfdNeceWyslREl7grYBYndjIwh2xbOYsQJWItBGS2PPTsi469
	wQCNLToJsjMxa2Z7d7HhWK96KnUOJ7U=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-125-s_yr69nHMK-XBMO20lbQUg-1; Thu,
 26 Nov 2026 05:24:38 +0000
X-MC-Unique: s_yr69nHMK-XBMO20lbQUg-1
X-Mimecast-MFC-AGG-ID: s_yr69nHMK-XBMO20lbQUg_1795670677
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 010301800359;
	Thu, 26 Nov 2026 05:24:37 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A5A9C195608B;
	Thu, 26 Nov 2026 05:24:36 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 6AQ5OZY9725794
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 26 Nov 2026 00:24:35 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 6AQ5OZlj725793;
	Thu, 26 Nov 2026 00:24:35 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 3/4] multipathd: make cli_handlers take a wait_node
Date: Thu, 26 Nov 2026 00:24:33 -0500
Message-ID: <20261126052434.725762-4-bmarzins@redhat.com>
In-Reply-To: <20261126052434.725762-1-bmarzins@redhat.com>
References: <20261126052434.725762-1-bmarzins@redhat.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: gHEfT9k92GUpfdxnuFjJpxCo3O89YQwS4sX2vBP52K0_1795670677
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

To enable client handler functions to add clients to wait lists, add
c->wait_node as a cli_handler argument.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/cli.h          |   4 +-
 multipathd/cli_handlers.c | 224 ++++++++++++++++++++------------------
 multipathd/uxlsnr.c       |   2 +-
 3 files changed, 120 insertions(+), 110 deletions(-)

diff --git a/multipathd/cli.h b/multipathd/cli.h
index 3e607389..6d599ca7 100644
--- a/multipathd/cli.h
+++ b/multipathd/cli.h
@@ -2,6 +2,7 @@
 #define CLI_H_INCLUDED
 
 #include <stdint.h>
+#include "list.h"
 
 /*
  * CLI commands consist of 4 bytes, a verb (byte 0) and up to
@@ -133,7 +134,8 @@ struct key {
 
 struct strbuf;
 
-typedef int (cli_handler)(void *keywords, struct strbuf *reply, void *data);
+typedef int (cli_handler)(void *keywords, struct strbuf *reply,
+			  struct list_head *wait_node, void *data);
 
 struct handler {
 	uint32_t fingerprint;
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index f5a13c46..e5c43bd8 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -184,8 +184,8 @@ reset_stats(struct multipath * mpp)
 	mpp->stat_map_failures = 0;
 }
 
-static int
-cli_list_config (void *v, struct strbuf *reply, void *data)
+static int cli_list_config(void *v, struct strbuf *reply,
+			   struct list_head *wait_node, void *data)
 {
 	condlog(3, "list config (operator)");
 
@@ -197,8 +197,8 @@ static void v_free(void *x)
 	vector_free(x);
 }
 
-static int
-cli_list_config_local (void *v, struct strbuf *reply, void *data)
+static int cli_list_config_local(void *v, struct strbuf *reply,
+				 struct list_head *wait_node, void *data)
 {
 	struct vectors *vecs = (struct vectors *)data;
 	vector hwes;
@@ -213,8 +213,8 @@ cli_list_config_local (void *v, struct strbuf *reply, void *data)
 	return ret;
 }
 
-static int
-cli_list_paths (void *v, struct strbuf *reply, void *data)
+static int cli_list_paths(void *v, struct strbuf *reply,
+			  struct list_head *wait_node, void *data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 
@@ -223,8 +223,8 @@ cli_list_paths (void *v, struct strbuf *reply, void *data)
 	return show_paths(reply, vecs, PRINT_PATH_CHECKER, 1);
 }
 
-static int
-cli_list_paths_fmt (void *v, struct strbuf *reply, void *data)
+static int cli_list_paths_fmt(void *v, struct strbuf *reply,
+			      struct list_head *wait_node, void *data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 	char * fmt = get_keyparam(v, KEY_FMT);
@@ -234,8 +234,8 @@ cli_list_paths_fmt (void *v, struct strbuf *reply, void *data)
 	return show_paths(reply, vecs, fmt, 1);
 }
 
-static int
-cli_list_paths_raw (void *v, struct strbuf *reply, void * data)
+static int cli_list_paths_raw(void *v, struct strbuf *reply,
+			      struct list_head *wait_node, void *data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 	char * fmt = get_keyparam(v, KEY_FMT);
@@ -245,8 +245,8 @@ cli_list_paths_raw (void *v, struct strbuf *reply, void * data)
 	return show_paths(reply, vecs, fmt, 0);
 }
 
-static int
-cli_list_path (void *v, struct strbuf *reply, void *data)
+static int cli_list_path(void *v, struct strbuf *reply,
+			 struct list_head *wait_node, void *data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 	char * param = get_keyparam(v, KEY_PATH);
@@ -262,8 +262,8 @@ cli_list_path (void *v, struct strbuf *reply, void *data)
 	return show_path(reply, vecs, pp, "%o");
 }
 
-static int
-cli_list_map_topology (void *v, struct strbuf *reply, void *data)
+static int cli_list_map_topology(void *v, struct strbuf *reply,
+				 struct list_head *wait_node, void *data)
 {
 	struct multipath * mpp;
 	struct vectors * vecs = (struct vectors *)data;
@@ -284,8 +284,8 @@ cli_list_map_topology (void *v, struct strbuf *reply, void *data)
 	return show_map_topology(reply, mpp, vecs, p_width);
 }
 
-static int
-cli_list_maps_topology (void *v, struct strbuf *reply, void *data)
+static int cli_list_maps_topology(void *v, struct strbuf *reply,
+				  struct list_head *wait_node, void *data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 
@@ -294,8 +294,8 @@ cli_list_maps_topology (void *v, struct strbuf *reply, void *data)
 	return show_maps_topology(reply, vecs);
 }
 
-static int
-cli_list_map_json (void *v, struct strbuf *reply, void *data)
+static int cli_list_map_json(void *v, struct strbuf *reply,
+			     struct list_head *wait_node, void *data)
 {
 	struct multipath * mpp;
 	struct vectors * vecs = (struct vectors *)data;
@@ -312,8 +312,8 @@ cli_list_map_json (void *v, struct strbuf *reply, void *data)
 	return show_map_json(reply, mpp, vecs);
 }
 
-static int
-cli_list_maps_json (void *v, struct strbuf *reply, void *data)
+static int cli_list_maps_json(void *v, struct strbuf *reply,
+			      struct list_head *wait_node, void *data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 
@@ -322,8 +322,8 @@ cli_list_maps_json (void *v, struct strbuf *reply, void *data)
 	return show_maps_json(reply, vecs);
 }
 
-static int
-cli_list_wildcards (void *v, struct strbuf *reply, void *data)
+static int cli_list_wildcards(void *v, struct strbuf *reply,
+			      struct list_head *wait_node, void *data)
 {
 	if (snprint_wildcards(reply) < 0)
 		return 1;
@@ -404,8 +404,8 @@ show_maps (struct strbuf *reply, struct vectors *vecs, char *style,
 	return 0;
 }
 
-static int
-cli_list_maps_fmt (void *v, struct strbuf *reply, void *data)
+static int cli_list_maps_fmt(void *v, struct strbuf *reply,
+			     struct list_head *wait_node, void *data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 	char * fmt = get_keyparam(v, KEY_FMT);
@@ -415,8 +415,8 @@ cli_list_maps_fmt (void *v, struct strbuf *reply, void *data)
 	return show_maps(reply, vecs, fmt, 1);
 }
 
-static int
-cli_list_maps_raw (void *v, struct strbuf *reply, void *data)
+static int cli_list_maps_raw(void *v, struct strbuf *reply,
+			     struct list_head *wait_node, void *data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 	char * fmt = get_keyparam(v, KEY_FMT);
@@ -426,8 +426,8 @@ cli_list_maps_raw (void *v, struct strbuf *reply, void *data)
 	return show_maps(reply, vecs, fmt, 0);
 }
 
-static int
-cli_list_map_fmt (void *v, struct strbuf *reply, void *data)
+static int cli_list_map_fmt(void *v, struct strbuf *reply,
+			    struct list_head *wait_node, void *data)
 {
 	struct multipath * mpp;
 	struct vectors * vecs = (struct vectors *)data;
@@ -448,8 +448,8 @@ cli_list_map_fmt (void *v, struct strbuf *reply, void *data)
 	return show_map(reply, mpp, fmt, width);
 }
 
-static int
-cli_list_maps (void *v, struct strbuf *reply, void *data)
+static int cli_list_maps(void *v, struct strbuf *reply,
+			 struct list_head *wait_node, void *data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 
@@ -458,8 +458,8 @@ cli_list_maps (void *v, struct strbuf *reply, void *data)
 	return show_maps(reply, vecs, PRINT_MAP_NAMES, 1);
 }
 
-static int
-cli_list_status (void *v, struct strbuf *reply, void *data)
+static int cli_list_status(void *v, struct strbuf *reply,
+			   struct list_head *wait_node, void *data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 
@@ -468,8 +468,8 @@ cli_list_status (void *v, struct strbuf *reply, void *data)
 	return show_status(reply, vecs);
 }
 
-static int
-cli_list_maps_status (void *v, struct strbuf *reply, void *data)
+static int cli_list_maps_status(void *v, struct strbuf *reply,
+				struct list_head *wait_node, void *data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 
@@ -478,8 +478,8 @@ cli_list_maps_status (void *v, struct strbuf *reply, void *data)
 	return show_maps(reply, vecs, PRINT_MAP_STATUS, 1);
 }
 
-static int
-cli_list_maps_stats (void *v, struct strbuf *reply, void *data)
+static int cli_list_maps_stats(void *v, struct strbuf *reply,
+			       struct list_head *wait_node, void *data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 
@@ -488,16 +488,16 @@ cli_list_maps_stats (void *v, struct strbuf *reply, void *data)
 	return show_maps(reply, vecs, PRINT_MAP_STATS, 1);
 }
 
-static int
-cli_list_daemon (void *v, struct strbuf *reply, void *data)
+static int cli_list_daemon(void *v, struct strbuf *reply,
+			   struct list_head *wait_node, void *data)
 {
 	condlog(3, "list daemon (operator)");
 
 	return show_daemon(reply);
 }
 
-static int
-cli_reset_maps_stats (void *v, struct strbuf *reply, void *data)
+static int cli_reset_maps_stats(void *v, struct strbuf *reply,
+				struct list_head *wait_node, void *data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 	int i;
@@ -511,8 +511,8 @@ cli_reset_maps_stats (void *v, struct strbuf *reply, void *data)
 	return 0;
 }
 
-static int
-cli_reset_map_stats (void *v, struct strbuf *reply, void *data)
+static int cli_reset_map_stats(void *v, struct strbuf *reply,
+			       struct list_head *wait_node, void *data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 	struct multipath * mpp;
@@ -560,8 +560,8 @@ add_partial_path(struct path *pp, struct vectors *vecs)
 	return finish_path_init(pp, vecs);
 }
 
-static int
-cli_add_path (void *v, struct strbuf *reply, void *data)
+static int cli_add_path(void *v, struct strbuf *reply,
+			struct list_head *wait_node, void *data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 	char * param = get_keyparam(v, KEY_PATH);
@@ -680,8 +680,8 @@ blacklisted:
 	return 0;
 }
 
-static int
-cli_del_path (void * v, struct strbuf *reply, void * data)
+static int cli_del_path(void *v, struct strbuf *reply,
+			struct list_head *wait_node, void *data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 	char * param = get_keyparam(v, KEY_PATH);
@@ -703,8 +703,8 @@ cli_del_path (void * v, struct strbuf *reply, void * data)
 	return (ret == REMOVE_PATH_FAILURE);
 }
 
-static int
-cli_add_map (void * v, struct strbuf *reply, void * data)
+static int cli_add_map(void *v, struct strbuf *reply,
+		       struct list_head *wait_node, void *data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 	char * param = get_keyparam(v, KEY_MAP);
@@ -749,8 +749,8 @@ cli_add_map (void * v, struct strbuf *reply, void * data)
 	return rc;
 }
 
-static int
-cli_del_map (void * v, struct strbuf *reply, void * data)
+static int cli_del_map(void *v, struct strbuf *reply,
+		       struct list_head *wait_node, void *data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 	char * param = get_keyparam(v, KEY_MAP);
@@ -773,8 +773,8 @@ cli_del_map (void * v, struct strbuf *reply, void * data)
 	return 1;
 }
 
-static int
-cli_del_maps (void *v, struct strbuf *reply, void *data)
+static int cli_del_maps(void *v, struct strbuf *reply,
+			struct list_head *wait_node, void *data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 	struct multipath *mpp;
@@ -799,8 +799,8 @@ cli_del_maps (void *v, struct strbuf *reply, void *data)
 	return r;
 }
 
-static int
-cli_reload(void *v, struct strbuf *reply, void *data)
+static int cli_reload(void *v, struct strbuf *reply,
+		      struct list_head *wait_node, void *data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 	char * mapname = get_keyparam(v, KEY_MAP);
@@ -823,8 +823,8 @@ cli_reload(void *v, struct strbuf *reply, void *data)
 	return reload_and_sync_map(mpp, vecs);
 }
 
-static int
-cli_resize(void *v, struct strbuf *reply, void *data)
+static int cli_resize(void *v, struct strbuf *reply,
+		      struct list_head *wait_node, void *data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 	char * mapname = get_keyparam(v, KEY_MAP);
@@ -885,8 +885,8 @@ cli_resize(void *v, struct strbuf *reply, void *data)
 	return (ret != 0);
 }
 
-static int
-cli_force_no_daemon_q(void * v, struct strbuf *reply, void * data)
+static int cli_force_no_daemon_q(void *v, struct strbuf *reply,
+				 struct list_head *wait_node, void *data)
 {
 	struct config *conf;
 
@@ -898,8 +898,8 @@ cli_force_no_daemon_q(void * v, struct strbuf *reply, void * data)
 	return 0;
 }
 
-static int
-cli_restore_no_daemon_q(void * v, struct strbuf *reply, void * data)
+static int cli_restore_no_daemon_q(void *v, struct strbuf *reply,
+				   struct list_head *wait_node, void *data)
 {
 	struct config *conf;
 
@@ -911,8 +911,8 @@ cli_restore_no_daemon_q(void * v, struct strbuf *reply, void * data)
 	return 0;
 }
 
-static int
-cli_restore_queueing(void *v, struct strbuf *reply, void *data)
+static int cli_restore_queueing(void *v, struct strbuf *reply,
+				struct list_head *wait_node, void *data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 	char * mapname = get_keyparam(v, KEY_MAP);
@@ -939,8 +939,8 @@ cli_restore_queueing(void *v, struct strbuf *reply, void *data)
 	return 0;
 }
 
-static int
-cli_restore_all_queueing(void *v, struct strbuf *reply, void *data)
+static int cli_restore_all_queueing(void *v, struct strbuf *reply,
+				    struct list_head *wait_node, void *data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 	struct multipath *mpp;
@@ -962,8 +962,8 @@ cli_restore_all_queueing(void *v, struct strbuf *reply, void *data)
 	return 0;
 }
 
-static int
-cli_disable_queueing(void *v, struct strbuf *reply, void *data)
+static int cli_disable_queueing(void *v, struct strbuf *reply,
+				struct list_head *wait_node, void *data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 	char * mapname = get_keyparam(v, KEY_MAP);
@@ -985,8 +985,8 @@ cli_disable_queueing(void *v, struct strbuf *reply, void *data)
 	return 0;
 }
 
-static int
-cli_disable_all_queueing(void *v, struct strbuf *reply, void *data)
+static int cli_disable_all_queueing(void *v, struct strbuf *reply,
+				    struct list_head *wait_node, void *data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 	struct multipath *mpp;
@@ -1004,8 +1004,8 @@ cli_disable_all_queueing(void *v, struct strbuf *reply, void *data)
 	return 0;
 }
 
-static int
-cli_switch_group(void * v, struct strbuf *reply, void * data)
+static int cli_switch_group(void *v, struct strbuf *reply,
+			    struct list_head *wait_node, void *data)
 {
 	char * mapname = get_keyparam(v, KEY_MAP);
 	int groupnum = atoi(get_keyparam(v, KEY_GROUP));
@@ -1016,8 +1016,8 @@ cli_switch_group(void * v, struct strbuf *reply, void * data)
 	return dm_switchgroup(mapname, groupnum);
 }
 
-static int
-cli_reconfigure(void * v, struct strbuf *reply, void * data)
+static int cli_reconfigure(void *v, struct strbuf *reply,
+			   struct list_head *wait_node, void *data)
 {
 	condlog(2, "reconfigure (operator)");
 
@@ -1025,8 +1025,8 @@ cli_reconfigure(void * v, struct strbuf *reply, void * data)
 	return 0;
 }
 
-int
-cli_reconfigure_all(void * v, struct strbuf *reply, void * data)
+int cli_reconfigure_all(void *v, struct strbuf *reply,
+			struct list_head *wait_node, void *data)
 {
 	condlog(2, "reconfigure all (operator)");
 
@@ -1034,8 +1034,8 @@ cli_reconfigure_all(void * v, struct strbuf *reply, void * data)
 	return 0;
 }
 
-static int
-cli_suspend(void * v, struct strbuf *reply, void * data)
+static int cli_suspend(void *v, struct strbuf *reply,
+		       struct list_head *wait_node, void *data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 	char * param = get_keyparam(v, KEY_MAP);
@@ -1064,8 +1064,8 @@ cli_suspend(void * v, struct strbuf *reply, void * data)
 	return 0;
 }
 
-static int
-cli_resume(void * v, struct strbuf *reply, void * data)
+static int cli_resume(void *v, struct strbuf *reply,
+		      struct list_head *wait_node, void *data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 	char * param = get_keyparam(v, KEY_MAP);
@@ -1096,8 +1096,8 @@ cli_resume(void * v, struct strbuf *reply, void * data)
 	return 0;
 }
 
-static int
-cli_reinstate(void * v, struct strbuf *reply, void * data)
+static int cli_reinstate(void *v, struct strbuf *reply,
+			 struct list_head *wait_node, void *data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 	char * param = get_keyparam(v, KEY_PATH);
@@ -1132,8 +1132,8 @@ cli_reinstate(void * v, struct strbuf *reply, void * data)
 	return dm_reinstate_path(pp->mpp->alias, pp->dev_t);
 }
 
-static int
-cli_reassign (void * v, struct strbuf *reply, void * data)
+static int cli_reassign(void *v, struct strbuf *reply,
+			struct list_head *wait_node, void *data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 	char * param = get_keyparam(v, KEY_MAP);
@@ -1157,7 +1157,7 @@ cli_reassign (void * v, struct strbuf *reply, void * data)
 }
 
 static int
-cli_fail(void * v, struct strbuf *reply, void * data)
+cli_fail(void *v, struct strbuf *reply, struct list_head *wait_node, void *data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 	char * param = get_keyparam(v, KEY_PATH);
@@ -1202,8 +1202,8 @@ show_blacklist (struct strbuf *reply)
 	return 0;
 }
 
-static int
-cli_list_blacklist (void * v, struct strbuf *reply, void * data)
+static int cli_list_blacklist(void *v, struct strbuf *reply,
+			      struct list_head *wait_node, void *data)
 {
 	condlog(3, "list blacklist (operator)");
 
@@ -1227,8 +1227,8 @@ show_devices (struct strbuf *reply, struct vectors *vecs)
 	return 0;
 }
 
-static int
-cli_list_devices (void * v, struct strbuf *reply, void * data)
+static int cli_list_devices(void *v, struct strbuf *reply,
+			    struct list_head *wait_node, void *data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 
@@ -1238,13 +1238,13 @@ cli_list_devices (void * v, struct strbuf *reply, void * data)
 }
 
 static int
-cli_quit (void * v, struct strbuf *reply, void * data)
+cli_quit(void *v, struct strbuf *reply, struct list_head *wait_node, void *data)
 {
 	return 0;
 }
 
-static int
-cli_shutdown (void * v, struct strbuf *reply, void * data)
+static int cli_shutdown(void *v, struct strbuf *reply,
+			struct list_head *wait_node, void *data)
 {
 	condlog(3, "shutdown (operator)");
 	exit_daemon();
@@ -1257,8 +1257,8 @@ static const char *const pr_str[] = {
 	[PR_SET] = "set\n",
 };
 
-static int
-cli_getprstatus (void * v, struct strbuf *reply, void * data)
+static int cli_getprstatus(void *v, struct strbuf *reply,
+			   struct list_head *wait_node, void *data)
 {
 	struct multipath * mpp;
 	struct vectors * vecs = (struct vectors *)data;
@@ -1303,12 +1303,14 @@ static int do_setprstatus(void *v, struct strbuf *reply, void *data,
 	return 0;
 }
 
-static int cli_setprstatus(void *v, struct strbuf *reply, void *data)
+static int cli_setprstatus(void *v, struct strbuf *reply,
+			   struct list_head *wait_node, void *data)
 {
 	return do_setprstatus(v, reply, data, NULL);
 }
 
-static int cli_setprstatus_list(void *v, struct strbuf *reply, void *data)
+static int cli_setprstatus_list(void *v, struct strbuf *reply,
+				struct list_head *wait_node, void *data)
 {
 	int r;
 	struct vector_s registered_paths_vec = {.allocated = 0};
@@ -1331,8 +1333,8 @@ static int cli_setprstatus_list(void *v, struct strbuf *reply, void *data)
 	return r;
 }
 
-static int
-cli_unsetprstatus(void * v, struct strbuf *reply, void * data)
+static int cli_unsetprstatus(void *v, struct strbuf *reply,
+			     struct list_head *wait_node, void *data)
 {
 	struct multipath * mpp;
 	struct vectors * vecs = (struct vectors *)data;
@@ -1354,8 +1356,8 @@ cli_unsetprstatus(void * v, struct strbuf *reply, void * data)
 	return 0;
 }
 
-static int
-cli_getprkey(void * v, struct strbuf *reply, void * data)
+static int cli_getprkey(void *v, struct strbuf *reply,
+			struct list_head *wait_node, void *data)
 {
 	struct multipath * mpp;
 	struct vectors * vecs = (struct vectors *)data;
@@ -1381,8 +1383,8 @@ cli_getprkey(void * v, struct strbuf *reply, void * data)
 	return 0;
 }
 
-static int
-cli_unsetprkey(void * v, struct strbuf *reply, void * data)
+static int cli_unsetprkey(void *v, struct strbuf *reply,
+			  struct list_head *wait_node, void *data)
 {
 	struct multipath * mpp;
 	struct vectors * vecs = (struct vectors *)data;
@@ -1405,8 +1407,8 @@ cli_unsetprkey(void * v, struct strbuf *reply, void * data)
 	return ret;
 }
 
-static int
-cli_setprkey(void * v, struct strbuf *reply, void * data)
+static int cli_setprkey(void *v, struct strbuf *reply,
+			struct list_head *wait_node, void *data)
 {
 	struct multipath * mpp;
 	struct vectors * vecs = (struct vectors *)data;
@@ -1452,17 +1454,20 @@ static int do_prhold(struct vectors *vecs, char *param, int prhold)
 	return 0;
 }
 
-static int cli_setprhold(void *v, struct strbuf *reply, void *data)
+static int cli_setprhold(void *v, struct strbuf *reply,
+			 struct list_head *wait_node, void *data)
 {
 	return do_prhold((struct vectors *)data, get_keyparam(v, KEY_MAP), PR_SET);
 }
 
-static int cli_unsetprhold(void *v, struct strbuf *reply, void *data)
+static int cli_unsetprhold(void *v, struct strbuf *reply,
+			   struct list_head *wait_node, void *data)
 {
 	return do_prhold((struct vectors *)data, get_keyparam(v, KEY_MAP), PR_UNSET);
 }
 
-static int cli_getprhold(void *v, struct strbuf *reply, void *data)
+static int cli_getprhold(void *v, struct strbuf *reply,
+			 struct list_head *wait_node, void *data)
 {
 	struct multipath *mpp;
 	struct vectors *vecs = (struct vectors *)data;
@@ -1479,7 +1484,8 @@ static int cli_getprhold(void *v, struct strbuf *reply, void *data)
 	return 0;
 }
 
-static int cli_set_marginal(void * v, struct strbuf *reply, void * data)
+static int cli_set_marginal(void *v, struct strbuf *reply,
+			    struct list_head *wait_node, void *data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 	char * param = get_keyparam(v, KEY_PATH);
@@ -1506,7 +1512,8 @@ static int cli_set_marginal(void * v, struct strbuf *reply, void * data)
 	return reload_and_sync_map(pp->mpp, vecs);
 }
 
-static int cli_unset_marginal(void * v, struct strbuf *reply, void * data)
+static int cli_unset_marginal(void *v, struct strbuf *reply,
+			      struct list_head *wait_node, void *data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 	char * param = get_keyparam(v, KEY_PATH);
@@ -1533,7 +1540,8 @@ static int cli_unset_marginal(void * v, struct strbuf *reply, void * data)
 	return reload_and_sync_map(pp->mpp, vecs);
 }
 
-static int cli_unset_all_marginal(void * v, struct strbuf *reply, void * data)
+static int cli_unset_all_marginal(void *v, struct strbuf *reply,
+				  struct list_head *wait_node, void *data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 	char * mapname = get_keyparam(v, KEY_MAP);
diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index 09306918..e8ce459d 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -393,7 +393,7 @@ static int execute_handler(struct client *c, struct vectors *vecs)
 	if (!c->handler || !c->handler->fn)
 		return -EINVAL;
 
-	return c->handler->fn(c->cmdvec, &c->reply, vecs);
+	return c->handler->fn(c->cmdvec, &c->reply, &c->wait_node, vecs);
 }
 
 int init_wait_fd(void)
-- 
2.56.0

