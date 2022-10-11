Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D1DCC433FE
	for <dm-devel@archiver.kernel.org>; Tue, 11 Oct 2022 21:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1665525196;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=xK9ot/oi7XCsId45BJVFnz2vxYUDapnNYopL6sMX5rM=;
	b=R8QEzb9Af9eAclpuZ05lbww2rC3Ti1AUx8+qhNUu7VssktLGxLQCgTd8Bey8+9ln71I8ZD
	ppKrADbcBbeb3xUih/kEJUMJ3lH1ySXcde1Gp9zOHS3LixV9/lYf65BltBUeHf38svW2OA
	Ox3yuJZI0eCBu1oI11k9QeRS3p9i7WE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-66-bATrYE0rPoianvtRaaQpdw-1; Tue, 11 Oct 2022 17:53:12 -0400
X-MC-Unique: bATrYE0rPoianvtRaaQpdw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 162D01C05AB9;
	Tue, 11 Oct 2022 21:53:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 02ACB4B3FC6;
	Tue, 11 Oct 2022 21:53:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CF52E194658F;
	Tue, 11 Oct 2022 21:53:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E9B2A194658F
 for <dm-devel@listman.corp.redhat.com>; Tue, 11 Oct 2022 21:53:09 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CBC6BC23F71; Tue, 11 Oct 2022 21:53:09 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AE62BC23F6F;
 Tue, 11 Oct 2022 21:53:09 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 29BLr8PE027433;
 Tue, 11 Oct 2022 16:53:08 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 29BLr8JJ027432;
 Tue, 11 Oct 2022 16:53:08 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Tue, 11 Oct 2022 16:53:03 -0500
Message-Id: <1665525183-27377-5-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1665525183-27377-1-git-send-email-bmarzins@redhat.com>
References: <1665525183-27377-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: [dm-devel] [PATCH 4/4] libmultipath: avoid cleanup __attribute__
 with cancellation points
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

the cleanup __attribute__ doesn't get run when a thread is cancelled, so
it is only safe in cases where there aren't pthreads or no cancellation
points happen in the code block after the variable needs cleaning up.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/configure.c                 |  6 +--
 libmultipath/dmparser.c                  |  2 +-
 libmultipath/generic.c                   |  4 +-
 libmultipath/prioritizers/weightedpath.c |  6 ++-
 multipathd/cli_handlers.c                | 11 ++++--
 multipathd/main.c                        | 49 ++++++++++++++----------
 6 files changed, 48 insertions(+), 30 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index e5249fc1..25708257 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -1075,7 +1075,7 @@ int coalesce_paths (struct vectors *vecs, vector mpvec, char *refwwid,
 	int ret = CP_FAIL;
 	int k, i, r;
 	int is_daemon = (cmd == CMD_NONE) ? 1 : 0;
-	char *params __attribute__((cleanup(cleanup_charp))) = NULL;
+	char *params = NULL;
 	struct multipath * mpp;
 	struct path * pp1 = NULL;
 	struct path * pp2;
@@ -1208,6 +1208,7 @@ int coalesce_paths (struct vectors *vecs, vector mpvec, char *refwwid,
 			remove_map(mpp, vecs->pathvec, NULL);
 			continue;
 		}
+		pthread_cleanup_push(cleanup_free_ptr, &params);
 
 		if (cmd == CMD_DRY_RUN)
 			mpp->action = ACT_DRY_RUN;
@@ -1216,8 +1217,7 @@ int coalesce_paths (struct vectors *vecs, vector mpvec, char *refwwid,
 				      force_reload == FORCE_RELOAD_YES ? 1 : 0);
 
 		r = domap(mpp, params, is_daemon);
-		free(params);
-		params = NULL;
+		pthread_cleanup_pop(1);
 
 		if (r == DOMAP_FAIL || r == DOMAP_RETRY) {
 			condlog(3, "%s: domap (%u) failure "
diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
index 44650aaa..066a33af 100644
--- a/libmultipath/dmparser.c
+++ b/libmultipath/dmparser.c
@@ -94,8 +94,8 @@ int assemble_map(struct multipath *mp, char **params)
 		}
 	}
 
+	condlog(4, "%s: assembled map [%s]", mp->alias, get_strbuf_str(&buff));
 	*params = steal_strbuf_str(&buff);
-	condlog(4, "%s: assembled map [%s]", mp->alias, *params);
 	r = 0;
 out:
 	pthread_cleanup_pop(1);
diff --git a/libmultipath/generic.c b/libmultipath/generic.c
index 3e2268e6..cdee21d9 100644
--- a/libmultipath/generic.c
+++ b/libmultipath/generic.c
@@ -24,11 +24,12 @@ int generic_style(const struct gen_multipath* gm, struct strbuf *buf,
 		  __attribute__((unused)) int verbosity)
 {
 	struct strbuf tmp = STRBUF_INIT;
-	char *alias_buf __attribute__((cleanup(cleanup_charp)));
+	char *alias_buf = NULL;
 	const char *wwid_buf;
 	int ret;
 
 	pthread_cleanup_push_cast(reset_strbuf, &tmp);
+	pthread_cleanup_push(cleanup_free_ptr, &alias_buf);
 	gm->ops->snprint(gm, &tmp, 'n');
 	alias_buf = steal_strbuf_str(&tmp);
 	gm->ops->snprint(gm, &tmp, 'w');
@@ -37,5 +38,6 @@ int generic_style(const struct gen_multipath* gm, struct strbuf *buf,
 	ret = print_strbuf(buf, "%%n %s[%%G]:%%d %%s",
 			   strcmp(alias_buf, wwid_buf) ? "(%w) " : "");
 	pthread_cleanup_pop(1);
+	pthread_cleanup_pop(1);
 	return ret;
 }
diff --git a/libmultipath/prioritizers/weightedpath.c b/libmultipath/prioritizers/weightedpath.c
index df700bf3..02d40a3d 100644
--- a/libmultipath/prioritizers/weightedpath.c
+++ b/libmultipath/prioritizers/weightedpath.c
@@ -64,7 +64,7 @@ build_wwn_path(struct path *pp, struct strbuf *buf)
 int prio_path_weight(struct path *pp, char *prio_args)
 {
 	struct strbuf path = STRBUF_INIT;
-	char *arg __attribute__((cleanup(cleanup_charp))) = NULL;
+	char *arg = NULL;
 	char *temp, *regex, *prio;
 	char split_char[] = " \t";
 	int priority = DEFAULT_PRIORITY, path_found = 0;
@@ -77,11 +77,12 @@ int prio_path_weight(struct path *pp, char *prio_args)
 	arg = strdup(prio_args);
 	temp = arg;
 
+	pthread_cleanup_push(cleanup_free_ptr, &arg);
 	regex = get_next_string(&temp, split_char);
 
 	/* Return default priority if the argument is not parseable */
 	if (!regex) {
-		return priority;
+		goto out;
 	}
 
 	pthread_cleanup_push_cast(reset_strbuf, &path);
@@ -123,6 +124,7 @@ int prio_path_weight(struct path *pp, char *prio_args)
 		}
 	}
 out:
+	pthread_cleanup_pop(1);
 	pthread_cleanup_pop(1);
 	return priority;
 }
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index ddc807a1..2d1c5cfe 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -812,8 +812,9 @@ cli_reload(void *v, struct strbuf *reply, void *data)
 static int resize_map(struct multipath *mpp, unsigned long long size,
 	       struct vectors * vecs)
 {
-	char *params __attribute__((cleanup(cleanup_charp))) = NULL;
+	char *params = NULL;
 	unsigned long long orig_size = mpp->size;
+	int r = 1;
 
 	mpp->size = size;
 	update_mpp_paths(mpp, vecs->pathvec);
@@ -823,15 +824,19 @@ static int resize_map(struct multipath *mpp, unsigned long long size,
 		mpp->size = orig_size;
 		return 1;
 	}
+	pthread_cleanup_push(cleanup_free_ptr, &params);
 	mpp->action = ACT_RESIZE;
 	mpp->force_udev_reload = 1;
 	if (domap(mpp, params, 1) == DOMAP_FAIL) {
 		condlog(0, "%s: failed to resize map : %s", mpp->alias,
 			strerror(errno));
 		mpp->size = orig_size;
-		return 1;
+		goto out;
 	}
-	return 0;
+	r = 0;
+out:
+	pthread_cleanup_pop(1);
+	return r;
 }
 
 static int
diff --git a/multipathd/main.c b/multipathd/main.c
index ba52d393..2517b541 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -589,9 +589,9 @@ static int
 update_map (struct multipath *mpp, struct vectors *vecs, int new_map)
 {
 	int retries = 3;
-	char *params __attribute__((cleanup(cleanup_charp))) = NULL;
+	char *params = NULL;
 	struct path *pp;
-	int i;
+	int i, r;
 
 retry:
 	condlog(4, "%s: updating new map", mpp->alias);
@@ -622,10 +622,11 @@ retry:
 		retries = -1;
 		goto fail;
 	}
-	if (domap(mpp, params, 1) == DOMAP_FAIL && retries-- > 0) {
+	pthread_cleanup_push(cleanup_free_ptr, &params);
+	r = domap(mpp, params, 1);
+	pthread_cleanup_pop(1);
+	if (r == DOMAP_FAIL && retries-- > 0) {
 		condlog(0, "%s: map_udate sleep", mpp->alias);
-		free(params);
-		params = NULL;
 		sleep(1);
 		goto retry;
 	}
@@ -1185,7 +1186,7 @@ int
 ev_add_path (struct path * pp, struct vectors * vecs, int need_do_map)
 {
 	struct multipath * mpp;
-	char *params __attribute((cleanup(cleanup_charp))) = NULL;
+	char *params = NULL;
 	int retries = 3;
 	int start_waiter = 0;
 	int ret;
@@ -1277,6 +1278,7 @@ rescan:
 	/*
 	 * reload the map for the multipath mapped device
 	 */
+	pthread_cleanup_push(cleanup_free_ptr, &params);
 	ret = domap(mpp, params, 1);
 	while (ret == DOMAP_RETRY && retries-- > 0) {
 		condlog(0, "%s: retry domap for addition of new "
@@ -1284,6 +1286,7 @@ rescan:
 		sleep(1);
 		ret = domap(mpp, params, 1);
 	}
+	pthread_cleanup_pop(1);
 	if (ret == DOMAP_FAIL || ret == DOMAP_RETRY) {
 		condlog(0, "%s: failed in domap for addition of new "
 			"path %s", mpp->alias, pp->dev);
@@ -1294,8 +1297,6 @@ rescan:
 			condlog(0, "%s: ev_add_path sleep", mpp->alias);
 			sleep(1);
 			update_mpp_paths(mpp, vecs->pathvec);
-			free(params);
-			params = NULL;
 			goto rescan;
 		}
 		else if (mpp->action == ACT_RELOAD)
@@ -1356,8 +1357,9 @@ ev_remove_path (struct path *pp, struct vectors * vecs, int need_do_map)
 {
 	struct multipath * mpp;
 	int i, retval = REMOVE_PATH_SUCCESS;
-	char *params __attribute__((cleanup(cleanup_charp))) = NULL;
+	char *params = NULL;
 
+	pthread_cleanup_push(cleanup_free_ptr, &params);
 	/*
 	 * avoid referring to the map of an orphaned path
 	 */
@@ -1376,7 +1378,8 @@ ev_remove_path (struct path *pp, struct vectors * vecs, int need_do_map)
 		if (update_mpp_paths(mpp, vecs->pathvec)) {
 			condlog(0, "%s: failed to update paths",
 				mpp->alias);
-			goto fail;
+			retval = REMOVE_PATH_MAP_ERROR;
+			goto out;
 		}
 
 		/*
@@ -1398,7 +1401,8 @@ ev_remove_path (struct path *pp, struct vectors * vecs, int need_do_map)
 		if (setup_map(mpp, &params, vecs)) {
 			condlog(0, "%s: failed to setup map for"
 				" removal of path %s", mpp->alias, pp->dev);
-			goto fail;
+			retval = REMOVE_PATH_MAP_ERROR;
+			goto out;
 		}
 
 		if (mpp->wait_for_udev) {
@@ -1431,8 +1435,10 @@ ev_remove_path (struct path *pp, struct vectors * vecs, int need_do_map)
 			/* setup_multipath will free the path
 			 * regardless of whether it succeeds or
 			 * fails */
-			if (setup_multipath(vecs, mpp))
-				return REMOVE_PATH_MAP_ERROR;
+			if (setup_multipath(vecs, mpp)) {
+				retval = REMOVE_PATH_MAP_ERROR;
+				goto fail;
+			}
 			sync_map_state(mpp);
 
 			condlog(2, "%s: path removed from map %s",
@@ -1445,13 +1451,14 @@ ev_remove_path (struct path *pp, struct vectors * vecs, int need_do_map)
 		free_path(pp);
 	}
 out:
-	return retval;
-
+	if (retval == REMOVE_PATH_MAP_ERROR) {
+		condlog(0, "%s: error removing path. removing map %s", pp->dev,
+			mpp->alias);
+		remove_map_and_stop_waiter(mpp, vecs);
+	}
 fail:
-	condlog(0, "%s: error removing path. removing map %s", pp->dev,
-		mpp->alias);
-	remove_map_and_stop_waiter(mpp, vecs);
-	return REMOVE_PATH_MAP_ERROR;
+	pthread_cleanup_pop(1);
+	return retval;
 }
 
 int
@@ -2067,7 +2074,7 @@ int update_prio(struct path *pp, int refresh_all)
 static int reload_map(struct vectors *vecs, struct multipath *mpp, int refresh,
 		      int is_daemon)
 {
-	char *params __attribute__((cleanup(cleanup_charp))) = NULL;
+	char *params = NULL;
 	struct path *pp;
 	int i, r;
 
@@ -2089,9 +2096,11 @@ static int reload_map(struct vectors *vecs, struct multipath *mpp, int refresh,
 		condlog(0, "%s: failed to setup map", mpp->alias);
 		return 1;
 	}
+	pthread_cleanup_push(cleanup_free_ptr, &params);
 	select_action(mpp, vecs->mpvec, 1);
 
 	r = domap(mpp, params, is_daemon);
+	pthread_cleanup_pop(1);
 	if (r == DOMAP_FAIL || r == DOMAP_RETRY) {
 		condlog(3, "%s: domap (%u) failure "
 			"for reload map", mpp->alias, r);
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

