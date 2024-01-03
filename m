Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF72D1CA97
	for <dm-devel@lists.linux.dev>; Wed,  3 Jan 2024 17:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ie4kDgEf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704304607;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z57tUbs0BXiG5sMi6MqdcM/tVeQWDTFYJW+WdHSDBe0=;
	b=Ie4kDgEfdMu93uviKcxAksnsZYa4+KVQLze+W6YWizmKGXxb8DxG3akAumm8rCGs/r/A/S
	DjlIpQccM5P+UwhIIwYwqjQbPhWjX0emm8GxLCtADUbWZYGRSv0RgRXCEwZCqqYILsPbQt
	ebNNTW0NMP2c0vElf0xw2CWMrOkIZGs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-67-jE30Os3sNu2WZfuoc7RIPQ-1; Wed, 03 Jan 2024 12:56:46 -0500
X-MC-Unique: jE30Os3sNu2WZfuoc7RIPQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 031A785A58B;
	Wed,  3 Jan 2024 17:56:46 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F16E02026D66;
	Wed,  3 Jan 2024 17:56:45 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 403HujXp018519
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 3 Jan 2024 12:56:45 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 403Hujrh018518;
	Wed, 3 Jan 2024 12:56:45 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 13/18] multipathd: add cli_handler reply message for missing devs
Date: Wed,  3 Jan 2024 12:56:38 -0500
Message-ID: <20240103175643.18438-14-bmarzins@redhat.com>
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

When the cli_handlers cannot find the requested map or path, they will
now return -ENODEV, which prints extra information in default_reply().

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/cli_handlers.c | 56 ++++++++++++++++++++++++---------------
 multipathd/uxlsnr.c       |  2 ++
 2 files changed, 36 insertions(+), 22 deletions(-)

diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 6d5d53bc..117570e1 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -257,7 +257,7 @@ cli_list_path (void *v, struct strbuf *reply, void *data)
 
 	pp = find_path_by_str(vecs->pathvec, param, "list path");
 	if (!pp)
-		return 1;
+		return -ENODEV;
 
 	return show_path(reply, vecs, pp, "%o");
 }
@@ -277,7 +277,7 @@ cli_list_map_topology (void *v, struct strbuf *reply, void *data)
 	mpp = find_mp_by_str(vecs->mpvec, param);
 
 	if (!mpp)
-		return 1;
+		return -ENODEV;
 
 	condlog(3, "list multipath %s (operator)", param);
 
@@ -305,7 +305,7 @@ cli_list_map_json (void *v, struct strbuf *reply, void *data)
 	mpp = find_mp_by_str(vecs->mpvec, param);
 
 	if (!mpp)
-		return 1;
+		return -ENODEV;
 
 	condlog(3, "list multipath json %s (operator)", param);
 
@@ -434,7 +434,7 @@ cli_list_map_fmt (void *v, struct strbuf *reply, void *data)
 	param = convert_dev(param, 0);
 	mpp = find_mp_by_str(vecs->mpvec, param);
 	if (!mpp)
-		return 1;
+		return -ENODEV;
 
 	condlog(3, "list map %s fmt %s (operator)", param, fmt);
 
@@ -515,7 +515,7 @@ cli_reset_map_stats (void *v, struct strbuf *reply, void *data)
 	mpp = find_mp_by_str(vecs->mpvec, param);
 
 	if (!mpp)
-		return 1;
+		return -ENODEV;
 
 	condlog(3, "reset multipath %s stats (operator)", param);
 	reset_stats(mpp);
@@ -682,7 +682,7 @@ cli_del_path (void * v, struct strbuf *reply, void * data)
 	pp = find_path_by_str(vecs->pathvec, param, NULL);
 	if (!pp) {
 		condlog(0, "%s: path already removed", param);
-		return 1;
+		return -ENODEV;
 	}
 	ret = ev_remove_path(pp, vecs, 1);
 	if (ret == REMOVE_PATH_DELAY)
@@ -766,7 +766,7 @@ cli_del_map (void * v, struct strbuf *reply, void * data)
 	mpp = find_mp_by_str(vecs->mpvec, param);
 
 	if (!mpp)
-		return 1;
+		return -ENODEV;
 
 	r = flush_map(mpp, vecs);
 	if (r == DM_FLUSH_OK)
@@ -814,7 +814,7 @@ cli_reload(void *v, struct strbuf *reply, void *data)
 	mpp = find_mp_by_str(vecs->mpvec, mapname);
 
 	if (!mpp)
-		return 1;
+		return -ENODEV;
 
 	if (mpp->wait_for_udev) {
 		condlog(2, "%s: device not fully created, failing reload",
@@ -842,7 +842,7 @@ cli_resize(void *v, struct strbuf *reply, void *data)
 	mpp = find_mp_by_str(vecs->mpvec, mapname);
 
 	if (!mpp)
-		return 1;
+		return -ENODEV;
 
 	if (mpp->wait_for_udev) {
 		condlog(2, "%s: device not fully created, failing resize",
@@ -926,7 +926,7 @@ cli_restore_queueing(void *v, struct strbuf *reply, void *data)
 	mpp = find_mp_by_str(vecs->mpvec, mapname);
 
 	if (!mpp)
-		return 1;
+		return -ENODEV;
 
 	if (mpp->disable_queueing) {
 		mpp->disable_queueing = 0;
@@ -976,7 +976,7 @@ cli_disable_queueing(void *v, struct strbuf *reply, void *data)
 	mpp = find_mp_by_str(vecs->mpvec, mapname);
 
 	if (!mpp)
-		return 1;
+		return -ENODEV;
 
 	if (count_active_paths(mpp) == 0)
 		mpp->stat_map_failures++;
@@ -1108,7 +1108,10 @@ cli_reinstate(void * v, struct strbuf *reply, void * data)
 	param = convert_dev(param, 1);
 	pp = find_path_by_str(vecs->pathvec, param, "reinstate path");
 
-	if (!pp || !pp->mpp || !pp->mpp->alias)
+	if (!pp)
+		return -ENODEV;
+
+	if (!pp->mpp || !pp->mpp->alias)
 		return 1;
 
 	condlog(2, "%s: reinstate path %s (operator)",
@@ -1153,7 +1156,10 @@ cli_fail(void * v, struct strbuf *reply, void * data)
 	param = convert_dev(param, 1);
 	pp = find_path_by_str(vecs->pathvec, param, "fail path");
 
-	if (!pp || !pp->mpp || !pp->mpp->alias)
+	if (!pp)
+		return -ENODEV;
+
+	if (!pp->mpp || !pp->mpp->alias)
 		return 1;
 
 	condlog(2, "%s: fail path %s (operator)",
@@ -1250,7 +1256,7 @@ cli_getprstatus (void * v, struct strbuf *reply, void * data)
 	mpp = find_mp_by_str(vecs->mpvec, param);
 
 	if (!mpp)
-		return 1;
+		return -ENODEV;
 
 	append_strbuf_str(reply, prflag_str[mpp->prflag]);
 
@@ -1270,7 +1276,7 @@ cli_setprstatus(void * v, struct strbuf *reply, void * data)
 	mpp = find_mp_by_str(vecs->mpvec, param);
 
 	if (!mpp)
-		return 1;
+		return -ENODEV;
 
 	if (mpp->prflag != PRFLAG_SET) {
 		mpp->prflag = PRFLAG_SET;
@@ -1292,7 +1298,7 @@ cli_unsetprstatus(void * v, struct strbuf *reply, void * data)
 	mpp = find_mp_by_str(vecs->mpvec, param);
 
 	if (!mpp)
-		return 1;
+		return -ENODEV;
 
 	if (mpp->prflag != PRFLAG_UNSET) {
 		mpp->prflag = PRFLAG_UNSET;
@@ -1315,7 +1321,7 @@ cli_getprkey(void * v, struct strbuf *reply, void * data)
 	mpp = find_mp_by_str(vecs->mpvec, mapname);
 
 	if (!mpp)
-		return 1;
+		return -ENODEV;
 
 	key = get_be64(mpp->reservation_key);
 	if (!key) {
@@ -1343,7 +1349,7 @@ cli_unsetprkey(void * v, struct strbuf *reply, void * data)
 	mpp = find_mp_by_str(vecs->mpvec, mapname);
 
 	if (!mpp)
-		return 1;
+		return -ENODEV;
 
 	conf = get_multipath_config();
 	pthread_cleanup_push(put_multipath_config, conf);
@@ -1370,7 +1376,7 @@ cli_setprkey(void * v, struct strbuf *reply, void * data)
 	mpp = find_mp_by_str(vecs->mpvec, mapname);
 
 	if (!mpp)
-		return 1;
+		return -ENODEV;
 
 	if (parse_prkey_flags(keyparam, &prkey, &flags) != 0) {
 		condlog(0, "%s: invalid prkey : '%s'", mapname, keyparam);
@@ -1394,7 +1400,10 @@ static int cli_set_marginal(void * v, struct strbuf *reply, void * data)
 	param = convert_dev(param, 1);
 	pp = find_path_by_str(vecs->pathvec, param, "set marginal path");
 
-	if (!pp || !pp->mpp || !pp->mpp->alias)
+	if (!pp)
+		return -ENODEV;
+
+	if (!pp->mpp || !pp->mpp->alias)
 		return 1;
 
 	condlog(2, "%s: set marginal path %s (operator)",
@@ -1418,7 +1427,10 @@ static int cli_unset_marginal(void * v, struct strbuf *reply, void * data)
 	param = convert_dev(param, 1);
 	pp = find_path_by_str(vecs->pathvec, param, "unset marginal path");
 
-	if (!pp || !pp->mpp || !pp->mpp->alias)
+	if (!pp)
+		return -ENODEV;
+
+	if (!pp->mpp || !pp->mpp->alias)
 		return 1;
 
 	condlog(2, "%s: unset marginal path %s (operator)",
@@ -1449,7 +1461,7 @@ static int cli_unset_all_marginal(void * v, struct strbuf *reply, void * data)
 	mpp = find_mp_by_str(vecs->mpvec, mapname);
 
 	if (!mpp)
-		return 1;
+		return -ENODEV;
 
 	if (mpp->wait_for_udev) {
 		condlog(2, "%s: device not fully created, "
diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index 707ed396..185e0a0a 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -414,6 +414,8 @@ void default_reply(struct client *c, int r)
 	case -EBUSY:
 		append_strbuf_str(&c->reply, "map or partition in use\n");
 		break;
+	case -ENODEV:
+		append_strbuf_str(&c->reply, "device not found\n");
 	}
 }
 
-- 
2.43.0

