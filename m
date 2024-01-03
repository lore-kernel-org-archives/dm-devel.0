Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F51C1CA93
	for <dm-devel@lists.linux.dev>; Wed,  3 Jan 2024 17:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DtXRsTdB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704304609;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bvvWiv4tpC/ql7wtECdaLVX/NaYMRvjb8zNOyEYy4Q0=;
	b=DtXRsTdB87cnQjPoelaQ2HgtPqlHspKpfEkGnE+Mh4YIeFSXgPfAzjrjF3W302ddhqgvk6
	qQK4AF6sNCxvc3e6zBQeZ1s2ZIVlRU76z5QDYAgYw3fIZZPTVlCGb7SgLP6IeHifJuou6G
	YMAuATOowiaduAYkVIg/UgREI/WemkQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-606-gLbqcypYOyWw4S_Ie5E00g-1; Wed, 03 Jan 2024 12:56:46 -0500
X-MC-Unique: gLbqcypYOyWw4S_Ie5E00g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D0662882083;
	Wed,  3 Jan 2024 17:56:45 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CA93C2026D66;
	Wed,  3 Jan 2024 17:56:45 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 403HujnK018515
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 3 Jan 2024 12:56:45 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 403Huj1b018514;
	Wed, 3 Jan 2024 12:56:45 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 12/18] multipathd: make cli_handlers check for paths by dev and devt
Date: Wed,  3 Jan 2024 12:56:37 -0500
Message-ID: <20240103175643.18438-13-bmarzins@redhat.com>
In-Reply-To: <20240103175643.18438-1-bmarzins@redhat.com>
References: <20240103175643.18438-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Some of the client handlers checked for paths by both dev and devt, but
not all. Also, many of the client handlers don't print anything if they
failed to find a path. Make all the client handlers which work on path
devices use a new function, find_path_by_str(), which will try both
methods to find a path, and can print out an error message if none is
found.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/cli_handlers.c | 40 ++++++++++++++++++++-------------------
 1 file changed, 21 insertions(+), 19 deletions(-)

diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 21fb9dd3..6d5d53bc 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -33,6 +33,20 @@
 #include "cli_handlers.h"
 #include "devmapper.h"
 
+static struct path *
+find_path_by_str(const struct _vector *pathvec, const char *str,
+		  const char *action_str)
+{
+	struct path *pp;
+
+	if (!(pp = find_path_by_devt(pathvec, str)))
+		pp = find_path_by_dev(pathvec, str);
+
+	if (!pp && action_str)
+		condlog(2, "%s: invalid path name. cannot %s", str, action_str);
+	return pp;
+}
+
 static int
 show_paths (struct strbuf *reply, struct vectors *vecs, char *style, int pretty)
 {
@@ -241,7 +255,7 @@ cli_list_path (void *v, struct strbuf *reply, void *data)
 	param = convert_dev(param, 1);
 	condlog(3, "%s: list path (operator)", param);
 
-	pp = find_path_by_dev(vecs->pathvec, param);
+	pp = find_path_by_str(vecs->pathvec, param, "list path");
 	if (!pp)
 		return 1;
 
@@ -556,7 +570,7 @@ cli_add_path (void *v, struct strbuf *reply, void *data)
 	if (invalid)
 		goto blacklisted;
 
-	pp = find_path_by_dev(vecs->pathvec, param);
+	pp = find_path_by_str(vecs->pathvec, param, NULL);
 	if (pp && pp->initialized != INIT_REMOVED) {
 		condlog(2, "%s: path already in pathvec", param);
 
@@ -665,7 +679,7 @@ cli_del_path (void * v, struct strbuf *reply, void * data)
 
 	param = convert_dev(param, 1);
 	condlog(2, "%s: remove path (operator)", param);
-	pp = find_path_by_dev(vecs->pathvec, param);
+	pp = find_path_by_str(vecs->pathvec, param, NULL);
 	if (!pp) {
 		condlog(0, "%s: path already removed", param);
 		return 1;
@@ -1092,10 +1106,7 @@ cli_reinstate(void * v, struct strbuf *reply, void * data)
 	struct path * pp;
 
 	param = convert_dev(param, 1);
-	pp = find_path_by_dev(vecs->pathvec, param);
-
-	if (!pp)
-		 pp = find_path_by_devt(vecs->pathvec, param);
+	pp = find_path_by_str(vecs->pathvec, param, "reinstate path");
 
 	if (!pp || !pp->mpp || !pp->mpp->alias)
 		return 1;
@@ -1140,10 +1151,7 @@ cli_fail(void * v, struct strbuf *reply, void * data)
 	int r;
 
 	param = convert_dev(param, 1);
-	pp = find_path_by_dev(vecs->pathvec, param);
-
-	if (!pp)
-		 pp = find_path_by_devt(vecs->pathvec, param);
+	pp = find_path_by_str(vecs->pathvec, param, "fail path");
 
 	if (!pp || !pp->mpp || !pp->mpp->alias)
 		return 1;
@@ -1384,10 +1392,7 @@ static int cli_set_marginal(void * v, struct strbuf *reply, void * data)
 	struct path * pp;
 
 	param = convert_dev(param, 1);
-	pp = find_path_by_dev(vecs->pathvec, param);
-
-	if (!pp)
-		pp = find_path_by_devt(vecs->pathvec, param);
+	pp = find_path_by_str(vecs->pathvec, param, "set marginal path");
 
 	if (!pp || !pp->mpp || !pp->mpp->alias)
 		return 1;
@@ -1411,10 +1416,7 @@ static int cli_unset_marginal(void * v, struct strbuf *reply, void * data)
 	struct path * pp;
 
 	param = convert_dev(param, 1);
-	pp = find_path_by_dev(vecs->pathvec, param);
-
-	if (!pp)
-		pp = find_path_by_devt(vecs->pathvec, param);
+	pp = find_path_by_str(vecs->pathvec, param, "unset marginal path");
 
 	if (!pp || !pp->mpp || !pp->mpp->alias)
 		return 1;
-- 
2.43.0

