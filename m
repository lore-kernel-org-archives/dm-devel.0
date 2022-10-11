Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 370ABC4167B
	for <dm-devel@archiver.kernel.org>; Tue, 11 Oct 2022 21:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1665525196;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=EosWGsCSQ01TDa43lu2ZhGoeLJ/tzjeBbWcLb12W5uU=;
	b=gPw1SyHP7DBdHN1bRiuSloVe0aJguGfk2RWEZFf80mJXRWD43WkFU4ea83yK4w6yEAILTu
	LUi1hIZerOZCdqHqfIrZMbA+jGqiYOdHk7AmIt1Dhf7g6+vaqapNcxZE2PEvidBQj6UXwF
	3bl7f3ztY27ZqfIDFfwqApQXkS6fO68=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-537-e4uihibLOaWLPyWAYzjdTA-1; Tue, 11 Oct 2022 17:53:13 -0400
X-MC-Unique: e4uihibLOaWLPyWAYzjdTA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BC0CD2801A40;
	Tue, 11 Oct 2022 21:53:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AA13D40C6FA0;
	Tue, 11 Oct 2022 21:53:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9563419465B3;
	Tue, 11 Oct 2022 21:53:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DC2AC1946589
 for <dm-devel@listman.corp.redhat.com>; Tue, 11 Oct 2022 21:53:08 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D09F3111E3FD; Tue, 11 Oct 2022 21:53:08 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AE825111E3FB;
 Tue, 11 Oct 2022 21:53:08 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 29BLr7HV027429;
 Tue, 11 Oct 2022 16:53:07 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 29BLr7jD027426;
 Tue, 11 Oct 2022 16:53:07 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Tue, 11 Oct 2022 16:53:02 -0500
Message-Id: <1665525183-27377-4-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1665525183-27377-1-git-send-email-bmarzins@redhat.com>
References: <1665525183-27377-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: [dm-devel] [PATCH 3/4] libmultipath: use regular array for field
 widths
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: device-mapper development <dm-devel@redhat.com>,
 Martin Wilck <Martin.Wilck@suse.com>
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

We know the size of these arrays, so we can just allocate them on the
stack. Also, show_path() doesn't use the width, so don't initialize it
in the first place.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/foreign.c            |  5 ++--
 libmultipath/libmultipath.version |  4 +--
 libmultipath/print.c              | 32 +++++++++++-------------
 libmultipath/print.h              |  4 +--
 multipath/main.c                  |  5 ++--
 multipathd/cli_handlers.c         | 41 ++++++++++++-------------------
 6 files changed, 38 insertions(+), 53 deletions(-)

diff --git a/libmultipath/foreign.c b/libmultipath/foreign.c
index 8981ff58..4cc2a8e3 100644
--- a/libmultipath/foreign.c
+++ b/libmultipath/foreign.c
@@ -550,10 +550,9 @@ void print_foreign_topology(int verbosity)
 	struct strbuf buf = STRBUF_INIT;
 	struct foreign *fgn;
 	int i;
-	fieldwidth_t *width __attribute__((cleanup(cleanup_ucharp))) = NULL;
+	fieldwidth_t width[path_layout_size()];
 
-	if ((width = alloc_path_layout()) == NULL)
-		return;
+	memset(width, 0, sizeof(width));
 	rdlock_foreigns();
 	if (foreigns == NULL) {
 		unlock_foreigns(NULL);
diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index 8a447f7f..af7c5ed2 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -38,9 +38,7 @@ global:
 	add_map_with_path;
 	adopt_paths;
 	alloc_multipath;
-	alloc_multipath_layout;
 	alloc_path;
-	alloc_path_layout;
 	alloc_path_with_pathinfo;
 	change_foreign;
 	check_alias_settings;
@@ -126,6 +124,7 @@ global:
 	libmultipath_exit;
 	libmultipath_init;
 	load_config;
+	multipath_layout_size;
 	need_io_err_check;
 	orphan_path;
 	parse_prkey_flags;
@@ -133,6 +132,7 @@ global:
 	path_discovery;
 	path_get_tpgs;
 	pathinfo;
+	path_layout_size;
 	path_offline;
 	print_all_paths;
 	print_foreign_topology;
diff --git a/libmultipath/print.c b/libmultipath/print.c
index 97f9a177..87d6a329 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -805,6 +805,12 @@ static const struct multipath_data mpd[] = {
 	{'g', "vpd page data", snprint_multipath_vpd_data},
 };
 
+
+int multipath_layout_size(void)
+{
+	return ARRAY_SIZE(mpd);
+}
+
 static const struct path_data pd[] = {
 	{'w', "uuid",          snprint_path_uuid},
 	{'i', "hcil",          snprint_hcil},
@@ -834,6 +840,11 @@ static const struct path_data pd[] = {
 	{'L', "LUN hex",       snprint_path_lunhex},
 };
 
+int path_layout_size(void)
+{
+	return ARRAY_SIZE(pd);
+}
+
 static const struct pathgroup_data pgd[] = {
 	{'s', "selector",      snprint_pg_selector},
 	{'p', "pri",           snprint_pg_pri},
@@ -871,10 +882,6 @@ int snprint_wildcards(struct strbuf *buff)
 	return get_strbuf_len(buff) - initial_len;
 }
 
-fieldwidth_t *alloc_path_layout(void) {
-	return calloc(ARRAY_SIZE(pd), sizeof(fieldwidth_t));
-}
-
 void get_path_layout(vector pathvec, int header, fieldwidth_t *width)
 {
 	vector gpvec = vector_convert(NULL, pathvec, struct path,
@@ -929,11 +936,6 @@ void _get_path_layout (const struct _vector *gpvec, enum layout_reset reset,
 	}
 }
 
-fieldwidth_t *alloc_multipath_layout(void) {
-
-	return calloc(ARRAY_SIZE(mpd), sizeof(fieldwidth_t));
-}
-
 void get_multipath_layout (vector mpvec, int header, fieldwidth_t *width) {
 	vector gmvec = vector_convert(NULL, mpvec, struct multipath,
 				      dm_multipath_to_gen);
@@ -1187,12 +1189,11 @@ int _snprint_pathgroup(const struct gen_pathgroup *ggp, struct strbuf *line,
 void _print_multipath_topology(const struct gen_multipath *gmp, int verbosity)
 {
 	struct strbuf buff = STRBUF_INIT;
-	fieldwidth_t *p_width __attribute__((cleanup(cleanup_ucharp))) = NULL;
+	fieldwidth_t p_width[ARRAY_SIZE(pd)] = {0};
 	const struct gen_pathgroup *gpg;
 	const struct _vector *pgvec, *pathvec;
 	int j;
 
-	p_width = alloc_path_layout();
 	pgvec = gmp->ops->get_pathgroups(gmp);
 
 	if (pgvec != NULL) {
@@ -1236,14 +1237,11 @@ int _snprint_multipath_topology(const struct gen_multipath *gmp,
 	const struct gen_pathgroup *gpg;
 	struct strbuf style = STRBUF_INIT;
 	size_t initial_len = get_strbuf_len(buff);
-	fieldwidth_t *width __attribute__((cleanup(cleanup_ucharp))) = NULL;
+	fieldwidth_t width[ARRAY_SIZE(mpd)] = {0};
 
 	if (verbosity <= 0)
 		return 0;
 
-	if ((width = alloc_multipath_layout()) == NULL)
-		return -ENOMEM;
-
 	if (verbosity == 1)
 		return _snprint_multipath(gmp, buff, "%n", width);
 
@@ -2027,7 +2025,7 @@ static void print_all_paths_custo(vector pathvec, int banner, const char *fmt)
 	int i;
 	struct path * pp;
 	struct strbuf line = STRBUF_INIT;
-	fieldwidth_t *width __attribute__((cleanup(cleanup_ucharp))) = NULL;
+	fieldwidth_t width[ARRAY_SIZE(pd)] = {0};
 
 	if (!VECTOR_SIZE(pathvec)) {
 		if (banner)
@@ -2035,8 +2033,6 @@ static void print_all_paths_custo(vector pathvec, int banner, const char *fmt)
 		return;
 	}
 
-	if ((width = alloc_path_layout()) == NULL)
-		return;
 	get_path_layout(pathvec, 1, width);
 
 	pthread_cleanup_push_cast(reset_strbuf, &line);
diff --git a/libmultipath/print.h b/libmultipath/print.h
index 52f5b256..4e50827d 100644
--- a/libmultipath/print.h
+++ b/libmultipath/print.h
@@ -16,11 +16,11 @@ enum layout_reset {
 };
 
 /* fieldwidth_t is defined in generic.h */
-fieldwidth_t *alloc_path_layout(void);
+int multipath_layout_size(void);
+int path_layout_size(void);
 void _get_path_layout (const struct _vector *gpvec, enum layout_reset,
 		       fieldwidth_t *width);
 void get_path_layout (vector pathvec, int header, fieldwidth_t *width);
-fieldwidth_t *alloc_multipath_layout(void);
 void _get_multipath_layout (const struct _vector *gmvec, enum layout_reset,
 			    fieldwidth_t *width);
 void get_multipath_layout (vector mpvec, int header, fieldwidth_t *width);
diff --git a/multipath/main.c b/multipath/main.c
index 7b69a3ce..f4c85409 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -457,7 +457,7 @@ configure (struct config *conf, enum mpath_cmds cmd,
 	int di_flag = 0;
 	char * refwwid = NULL;
 	char * dev = NULL;
-	fieldwidth_t *width __attribute__((cleanup(cleanup_ucharp))) = NULL;
+	fieldwidth_t width[path_layout_size()];
 
 	/*
 	 * allocate core vectors to store paths and multipaths
@@ -544,8 +544,7 @@ configure (struct config *conf, enum mpath_cmds cmd,
 	if (libmp_verbosity > 2)
 		print_all_paths(pathvec, 1);
 
-	if ((width = alloc_path_layout()) == NULL)
-		goto out;
+	memset(width, 0, sizeof(width));
 	get_path_layout(pathvec, 0, width);
 	foreign_path_layout(width);
 
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 5b8f647b..ddc807a1 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -38,11 +38,10 @@ show_paths (struct strbuf *reply, struct vectors *vecs, char *style, int pretty)
 	int i;
 	struct path * pp;
 	int hdr_len = 0;
-	fieldwidth_t *width __attribute__((cleanup(cleanup_ucharp))) = NULL;
+	fieldwidth_t width[path_layout_size()];
 
+	memset(width, 0, sizeof(width));
 	if (pretty) {
-		if ((width = alloc_path_layout()) == NULL)
-			return 1;
 		get_path_layout(vecs->pathvec, 1, width);
 		foreign_path_layout(width);
 	}
@@ -50,10 +49,10 @@ show_paths (struct strbuf *reply, struct vectors *vecs, char *style, int pretty)
 		return 1;
 
 	vector_foreach_slot(vecs->pathvec, pp, i) {
-		if (snprint_path(reply, style, pp, width) < 0)
+		if (snprint_path(reply, style, pp, pretty? width : NULL) < 0)
 			return 1;
 	}
-	if (snprint_foreign_paths(reply, style, width) < 0)
+	if (snprint_foreign_paths(reply, style, pretty? width : NULL) < 0)
 		return 1;
 
 	if (pretty && get_strbuf_len(reply) == (size_t)hdr_len)
@@ -67,12 +66,7 @@ static int
 show_path (struct strbuf *reply, struct vectors *vecs, struct path *pp,
 	   char *style)
 {
-	fieldwidth_t *width __attribute__((cleanup(cleanup_ucharp))) = NULL;
-
-	if ((width = alloc_path_layout()) == NULL)
-		return 1;
-	get_path_layout(vecs->pathvec, 1, width);
-	if (snprint_path(reply, style, pp, 0) < 0)
+	if (snprint_path(reply, style, pp, NULL) < 0)
 		return 1;
 	return 0;
 }
@@ -95,10 +89,9 @@ show_maps_topology (struct strbuf *reply, struct vectors * vecs)
 {
 	int i;
 	struct multipath * mpp;
-	fieldwidth_t *p_width __attribute__((cleanup(cleanup_ucharp))) = NULL;
+	fieldwidth_t p_width[path_layout_size()];
 
-	if ((p_width = alloc_path_layout()) == NULL)
-		return 1;
+	memset(p_width, 0, sizeof(p_width));
 	get_path_layout(vecs->pathvec, 0, p_width);
 	foreign_path_layout(p_width);
 
@@ -258,10 +251,9 @@ cli_list_map_topology (void *v, struct strbuf *reply, void *data)
 	struct multipath * mpp;
 	struct vectors * vecs = (struct vectors *)data;
 	char * param = get_keyparam(v, MAP);
-	fieldwidth_t *p_width __attribute__((cleanup(cleanup_ucharp))) = NULL;
+	fieldwidth_t p_width[path_layout_size()];
 
-	if ((p_width = alloc_path_layout()) == NULL)
-		return 1;
+	memset(p_width, 0, sizeof(p_width));
 	get_path_layout(vecs->pathvec, 0, p_width);
 	param = convert_dev(param, 0);
 	mpp = find_mp_by_str(vecs->mpvec, param);
@@ -357,11 +349,10 @@ show_maps (struct strbuf *reply, struct vectors *vecs, char *style,
 	int i;
 	struct multipath * mpp;
 	int hdr_len = 0;
-	fieldwidth_t *width __attribute__((cleanup(cleanup_ucharp))) = NULL;
+	fieldwidth_t width[multipath_layout_size()];
 
+	memset(width, 0, sizeof(width));
 	if (pretty) {
-		if ((width = alloc_multipath_layout()) == NULL)
-			return 1;
 		get_multipath_layout(vecs->mpvec, 1, width);
 		foreign_multipath_layout(width);
 	}
@@ -374,10 +365,11 @@ show_maps (struct strbuf *reply, struct vectors *vecs, char *style,
 			i--;
 			continue;
 		}
-		if (snprint_multipath(reply, style, mpp, width) < 0)
+		if (snprint_multipath(reply, style, mpp,
+				      pretty? width : NULL) < 0)
 			return 1;
 	}
-	if (snprint_foreign_multipaths(reply, style, width) < 0)
+	if (snprint_foreign_multipaths(reply, style, pretty? width : NULL) < 0)
 		return 1;
 
 	if (pretty && get_strbuf_len(reply) == (size_t)hdr_len)
@@ -416,10 +408,9 @@ cli_list_map_fmt (void *v, struct strbuf *reply, void *data)
 	struct vectors * vecs = (struct vectors *)data;
 	char * param = get_keyparam(v, MAP);
 	char * fmt = get_keyparam(v, FMT);
-	fieldwidth_t *width __attribute__((cleanup(cleanup_ucharp))) = NULL;
+	fieldwidth_t width[multipath_layout_size()];
 
-	if ((width = alloc_multipath_layout()) == NULL)
-		return 1;
+	memset(width, 0, sizeof(width));
 	get_multipath_layout(vecs->mpvec, 1, width);
 	param = convert_dev(param, 0);
 	mpp = find_mp_by_str(vecs->mpvec, param);
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

