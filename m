Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E56A1CAA8
	for <dm-devel@lists.linux.dev>; Wed,  3 Jan 2024 17:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="erFWvBhk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704304609;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D1vfM914ox/W2LeZJt2N5yFmgYa7TQ27CAuUDIP0ezw=;
	b=erFWvBhk9Ixh6GNTbszdGiymIMkrbQO8ii2DmNzEwD/vf8fAIs31f21WRRfXA9CNxr3Y36
	OfsiyromQX/2eMqdT8Oly3wubeJVjhyoVZBPo7olxol0In+QL1R0r+Plq5AlcLsSNF+Qkl
	29rVOH6oWS3zN+cwFlppUZNsdDgk8uM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-644-yMpFUY2ANGW_yVfPM4XbxQ-1; Wed, 03 Jan 2024 12:56:46 -0500
X-MC-Unique: yMpFUY2ANGW_yVfPM4XbxQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A632B859B81;
	Wed,  3 Jan 2024 17:56:45 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A07A9492BC6;
	Wed,  3 Jan 2024 17:56:45 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 403HujOd018511
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 3 Jan 2024 12:56:45 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 403Hujp7018510;
	Wed, 3 Jan 2024 12:56:45 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 11/18] multipathd: don't open code find_mp_by_str() in client handers
Date: Wed,  3 Jan 2024 12:56:36 -0500
Message-ID: <20240103175643.18438-12-bmarzins@redhat.com>
In-Reply-To: <20240103175643.18438-1-bmarzins@redhat.com>
References: <20240103175643.18438-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

multiple client handlers simply open coded find_mp_by_str(). Just
use the function instead.

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/cli_handlers.c | 53 +++++++++------------------------------
 1 file changed, 12 insertions(+), 41 deletions(-)

diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index af211a6b..21fb9dd3 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -794,19 +794,14 @@ cli_reload(void *v, struct strbuf *reply, void *data)
 	struct vectors * vecs = (struct vectors *)data;
 	char * mapname = get_keyparam(v, KEY_MAP);
 	struct multipath *mpp;
-	int minor;
 
 	mapname = convert_dev(mapname, 0);
 	condlog(2, "%s: reload map (operator)", mapname);
-	if (sscanf(mapname, "dm-%d", &minor) == 1)
-		mpp = find_mp_by_minor(vecs->mpvec, minor);
-	else
-		mpp = find_mp_by_alias(vecs->mpvec, mapname);
+	mpp = find_mp_by_str(vecs->mpvec, mapname);
 
-	if (!mpp) {
-		condlog(0, "%s: invalid map name. cannot reload", mapname);
+	if (!mpp)
 		return 1;
-	}
+
 	if (mpp->wait_for_udev) {
 		condlog(2, "%s: device not fully created, failing reload",
 			mpp->alias);
@@ -822,7 +817,6 @@ cli_resize(void *v, struct strbuf *reply, void *data)
 	struct vectors * vecs = (struct vectors *)data;
 	char * mapname = get_keyparam(v, KEY_MAP);
 	struct multipath *mpp;
-	int minor;
 	unsigned long long size = 0;
 	struct pathgroup *pgp;
 	struct path *pp;
@@ -831,15 +825,10 @@ cli_resize(void *v, struct strbuf *reply, void *data)
 
 	mapname = convert_dev(mapname, 0);
 	condlog(2, "%s: resize map (operator)", mapname);
-	if (sscanf(mapname, "dm-%d", &minor) == 1)
-		mpp = find_mp_by_minor(vecs->mpvec, minor);
-	else
-		mpp = find_mp_by_alias(vecs->mpvec, mapname);
+	mpp = find_mp_by_str(vecs->mpvec, mapname);
 
-	if (!mpp) {
-		condlog(0, "%s: invalid map name. cannot resize", mapname);
+	if (!mpp)
 		return 1;
-	}
 
 	if (mpp->wait_for_udev) {
 		condlog(2, "%s: device not fully created, failing resize",
@@ -916,20 +905,14 @@ cli_restore_queueing(void *v, struct strbuf *reply, void *data)
 	struct vectors * vecs = (struct vectors *)data;
 	char * mapname = get_keyparam(v, KEY_MAP);
 	struct multipath *mpp;
-	int minor;
 	struct config *conf;
 
 	mapname = convert_dev(mapname, 0);
 	condlog(2, "%s: restore map queueing (operator)", mapname);
-	if (sscanf(mapname, "dm-%d", &minor) == 1)
-		mpp = find_mp_by_minor(vecs->mpvec, minor);
-	else
-		mpp = find_mp_by_alias(vecs->mpvec, mapname);
+	mpp = find_mp_by_str(vecs->mpvec, mapname);
 
-	if (!mpp) {
-		condlog(0, "%s: invalid map name, cannot restore queueing", mapname);
+	if (!mpp)
 		return 1;
-	}
 
 	if (mpp->disable_queueing) {
 		mpp->disable_queueing = 0;
@@ -973,19 +956,13 @@ cli_disable_queueing(void *v, struct strbuf *reply, void *data)
 	struct vectors * vecs = (struct vectors *)data;
 	char * mapname = get_keyparam(v, KEY_MAP);
 	struct multipath *mpp;
-	int minor;
 
 	mapname = convert_dev(mapname, 0);
 	condlog(2, "%s: disable map queueing (operator)", mapname);
-	if (sscanf(mapname, "dm-%d", &minor) == 1)
-		mpp = find_mp_by_minor(vecs->mpvec, minor);
-	else
-		mpp = find_mp_by_alias(vecs->mpvec, mapname);
+	mpp = find_mp_by_str(vecs->mpvec, mapname);
 
-	if (!mpp) {
-		condlog(0, "%s: invalid map name, cannot disable queueing", mapname);
+	if (!mpp)
 		return 1;
-	}
 
 	if (count_active_paths(mpp) == 0)
 		mpp->stat_map_failures++;
@@ -1462,22 +1439,16 @@ static int cli_unset_all_marginal(void * v, struct strbuf *reply, void * data)
 	struct pathgroup * pgp;
 	struct path * pp;
 	unsigned int i, j;
-	int minor;
 
 	mapname = convert_dev(mapname, 0);
 	condlog(2, "%s: unset all marginal paths (operator)",
 		mapname);
 
-	if (sscanf(mapname, "dm-%d", &minor) == 1)
-		mpp = find_mp_by_minor(vecs->mpvec, minor);
-	else
-		mpp = find_mp_by_alias(vecs->mpvec, mapname);
+	mpp = find_mp_by_str(vecs->mpvec, mapname);
 
-	if (!mpp) {
-		condlog(0, "%s: invalid map name. "
-			"cannot unset marginal paths", mapname);
+	if (!mpp)
 		return 1;
-	}
+
 	if (mpp->wait_for_udev) {
 		condlog(2, "%s: device not fully created, "
 			"failing unset all marginal", mpp->alias);
-- 
2.43.0

