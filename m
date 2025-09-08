Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D31A3126BB
	for <dm-devel@lists.linux.dev>; Tue,  9 Sep 2025 00:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757376014; cv=none; b=fBmanVfAfU8px11+NO1ijHphEQaMTnSd4rm3b5zCOtMqZa4jddEHjpN7buT6o35owoYn8pbjbvZBfKOX8TbSlARs3kt7o1xcAtazzz/UarTWC9ZeRmdX/ewpFVUxlWY0hOv7Ghhg4nRU/8Pmeq32n0dOKZO64usngx26hNWZQjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757376014; c=relaxed/simple;
	bh=ATPpjr2GEYq8EaWHWbQJjlOVjhbu+szwh0oAjHCc97I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=eB9oPWTH3sBgxyghxRaRip8MqON0ibRkyrsqAwZBUXg/vwb62n2pgbDFtpbSx+LRv6LZ8qkoGWXmQgRB1TJFtL1sVBHBUPTgQqhh1lTKt58AYEco79Q1TxYqSgaEfAcJrzyo9vbfEkpBYQTLKtCHQgfogGrQ7gtJcwLUJnRf0JA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DOjMHY+G; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DOjMHY+G"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757376011;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/cKcaf1vupFxRhJnGFTQaSnH/Ow9HBoxPYzjnDPmRCA=;
	b=DOjMHY+GUf7/9Ae84Bg62ObF0omU41/c1sJFCr6hgYqNxP8o7dhXOhW2RoGS9N8uC20W4G
	8pA+k2wT3unGKKM8CIpr3BGP2wPiuIbl5SnoNNWojaR2gmR4ny0Ug53z3/1N3YItorsl8E
	qzlk/IhqfbOP75xwKXFbT4FSdNUN8To=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-121-lhr1W40jMq6Ed7SUsijH_A-1; Mon,
 08 Sep 2025 20:00:08 -0400
X-MC-Unique: lhr1W40jMq6Ed7SUsijH_A-1
X-Mimecast-MFC-AGG-ID: lhr1W40jMq6Ed7SUsijH_A_1757376007
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0DD501800452;
	Tue,  9 Sep 2025 00:00:07 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C0EE119560B4;
	Tue,  9 Sep 2025 00:00:06 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 589005rt751133
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 8 Sep 2025 20:00:05 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 589005a0751131;
	Mon, 8 Sep 2025 20:00:05 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 13/32] libmultipath: rename prflag_value enums
Date: Mon,  8 Sep 2025 19:59:43 -0400
Message-ID: <20250909000002.751039-14-bmarzins@redhat.com>
In-Reply-To: <20250909000002.751039-1-bmarzins@redhat.com>
References: <20250909000002.751039-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 75cKBBDuziYchU7gjkrvlW3AMv9DIr-DbTGL-lkGS0c_1757376007
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

These will also be used by another variable, so make their name more
generic.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 libmpathpersist/mpath_persist_int.c | 16 ++++++++--------
 libmpathpersist/mpath_updatepr.c    |  8 ++++----
 libmultipath/structs.h              |  9 ++++-----
 multipathd/cli_handlers.c           | 22 +++++++++++-----------
 multipathd/main.c                   | 16 +++++++---------
 5 files changed, 34 insertions(+), 37 deletions(-)

diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index 61510d41..dd875792 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -653,10 +653,10 @@ static void set_ignored_key(struct multipath *mpp, uint8_t *key)
 	memset(key, 0, 8);
 	if (!get_be64(mpp->reservation_key))
 		return;
-	if (get_prflag(mpp->alias) == PRFLAG_UNSET)
+	if (get_prflag(mpp->alias) == PR_UNSET)
 		return;
 	update_map_pr(mpp, NULL);
-	if (mpp->prflag != PRFLAG_SET)
+	if (mpp->prflag != PR_SET)
 		return;
 	memcpy(key, &mpp->reservation_key, 8);
 }
@@ -759,16 +759,16 @@ int update_map_pr(struct multipath *mpp, struct path *pp)
 	struct prin_resp *resp;
 	unsigned int i;
 	int ret = MPATH_PR_OTHER, isFound;
-	bool was_set = (mpp->prflag == PRFLAG_SET);
+	bool was_set = (mpp->prflag == PR_SET);
 
 	/* If pr is explicitly unset, it must be manually set */
-	if (mpp->prflag == PRFLAG_UNSET)
+	if (mpp->prflag == PR_UNSET)
 		return MPATH_PR_SKIP;
 
 	if (!get_be64(mpp->reservation_key))
 	{
 		/* Nothing to do. Assuming pr mgmt feature is disabled*/
-		mpp->prflag = PRFLAG_UNSET;
+		mpp->prflag = PR_UNSET;
 		condlog(was_set ? 2 : 4,
 			"%s: reservation_key not set in multipath.conf",
 			mpp->alias);
@@ -793,11 +793,11 @@ int update_map_pr(struct multipath *mpp, struct path *pp)
 	if (ret != MPATH_PR_SUCCESS )
 	{
 		if (ret == MPATH_PR_ILLEGAL_REQ)
-			mpp->prflag = PRFLAG_UNSET;
+			mpp->prflag = PR_UNSET;
 		condlog(0,"%s : pr in read keys service action failed Error=%d", mpp->alias, ret);
 		goto out;
 	}
-	mpp->prflag = PRFLAG_UNSET;
+	mpp->prflag = PR_UNSET;
 
 	if (resp->prin_descriptor.prin_readkeys.additional_length == 0 )
 	{
@@ -832,7 +832,7 @@ int update_map_pr(struct multipath *mpp, struct path *pp)
 
 	if (isFound)
 	{
-		mpp->prflag = PRFLAG_SET;
+		mpp->prflag = PR_SET;
 		condlog(was_set ? 3 : 2, "%s: key found. prflag set.", mpp->alias);
 	} else
 		condlog(was_set ? 1 : 3, "%s: key not found. prflag unset.",
diff --git a/libmpathpersist/mpath_updatepr.c b/libmpathpersist/mpath_updatepr.c
index 7cf82f50..c8fbe4a2 100644
--- a/libmpathpersist/mpath_updatepr.c
+++ b/libmpathpersist/mpath_updatepr.c
@@ -84,13 +84,13 @@ int get_prflag(char *mapname)
 	snprintf(str, sizeof(str), "getprstatus map %s", mapname);
 	reply = do_pr(mapname, str);
 	if (!reply)
-		prflag = PRFLAG_UNKNOWN;
+		prflag = PR_UNKNOWN;
 	else if (strncmp(reply, "unset", 5) == 0)
-		prflag = PRFLAG_UNSET;
+		prflag = PR_UNSET;
 	else if (strncmp(reply, "set", 3) == 0)
-		prflag = PRFLAG_SET;
+		prflag = PR_SET;
 	else
-		prflag = PRFLAG_UNKNOWN;
+		prflag = PR_UNKNOWN;
 
 	free(reply);
 	return prflag;
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 39d1c71c..6c427d6f 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -424,11 +424,10 @@ struct path {
 
 typedef int (pgpolicyfn) (struct multipath *, vector);
 
-
-enum prflag_value {
-	PRFLAG_UNKNOWN,
-	PRFLAG_UNSET,
-	PRFLAG_SET,
+enum pr_value {
+	PR_UNKNOWN,
+	PR_UNSET,
+	PR_SET,
 };
 
 enum prio_update_type {
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index fcb87757..a92b07ce 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -1250,14 +1250,15 @@ cli_shutdown (void * v, struct strbuf *reply, void * data)
 	return 0;
 }
 
+static const char *const pr_str[] = {
+	[PR_UNKNOWN] = "unknown\n",
+	[PR_UNSET] = "unset\n",
+	[PR_SET] = "set\n",
+};
+
 static int
 cli_getprstatus (void * v, struct strbuf *reply, void * data)
 {
-	static const char * const prflag_str[] = {
-		[PRFLAG_UNKNOWN] = "unknown\n",
-		[PRFLAG_UNSET] = "unset\n",
-		[PRFLAG_SET] = "set\n",
-	};
 	struct multipath * mpp;
 	struct vectors * vecs = (struct vectors *)data;
 	char * param = get_keyparam(v, KEY_MAP);
@@ -1268,7 +1269,7 @@ cli_getprstatus (void * v, struct strbuf *reply, void * data)
 	if (!mpp)
 		return -ENODEV;
 
-	append_strbuf_str(reply, prflag_str[mpp->prflag]);
+	append_strbuf_str(reply, pr_str[mpp->prflag]);
 
 	condlog(3, "%s: reply = %s", param, get_strbuf_str(reply));
 
@@ -1288,12 +1289,11 @@ cli_setprstatus(void * v, struct strbuf *reply, void * data)
 	if (!mpp)
 		return -ENODEV;
 
-	if (mpp->prflag != PRFLAG_SET) {
-		mpp->prflag = PRFLAG_SET;
+	if (mpp->prflag != PR_SET) {
+		mpp->prflag = PR_SET;
 		condlog(2, "%s: prflag set", param);
 	}
 
-
 	return 0;
 }
 
@@ -1310,8 +1310,8 @@ cli_unsetprstatus(void * v, struct strbuf *reply, void * data)
 	if (!mpp)
 		return -ENODEV;
 
-	if (mpp->prflag != PRFLAG_UNSET) {
-		mpp->prflag = PRFLAG_UNSET;
+	if (mpp->prflag != PR_UNSET) {
+		mpp->prflag = PR_UNSET;
 		condlog(2, "%s: prflag unset", param);
 	}
 
diff --git a/multipathd/main.c b/multipathd/main.c
index 02cfe8d1..582af880 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -637,7 +637,7 @@ pr_register_active_paths(struct multipath *mpp)
 
 	vector_foreach_slot (mpp->pg, pgp, i) {
 		vector_foreach_slot (pgp->paths, pp, j) {
-			if (mpp->prflag == PRFLAG_UNSET)
+			if (mpp->prflag == PR_UNSET)
 				return;
 			if ((pp->state == PATH_UP) || (pp->state == PATH_GHOST))
 				mpath_pr_event_handle(pp);
@@ -1273,7 +1273,7 @@ ev_add_path (struct path * pp, struct vectors * vecs, int need_do_map)
 	int start_waiter = 0;
 	int ret;
 	int ro;
-	unsigned char prflag = PRFLAG_UNSET;
+	unsigned char prflag = PR_UNSET;
 
 	/*
 	 * need path UID to go any further
@@ -1401,8 +1401,7 @@ rescan:
 	sync_map_state(mpp, false);
 
 	if (retries >= 0) {
-		if ((mpp->prflag == PRFLAG_SET && prflag != PRFLAG_SET) ||
-		    start_waiter)
+		if ((mpp->prflag == PR_SET && prflag != PR_SET) || start_waiter)
 			pr_register_active_paths(mpp);
 		condlog(2, "%s [%s]: path added to devmap %s",
 			pp->dev, pp->dev_t, mpp->alias);
@@ -2639,7 +2638,7 @@ update_path_state (struct vectors * vecs, struct path * pp)
 
 		/* newstate == PATH_UP || newstate == PATH_GHOST */
 
-		if (pp->mpp->prflag != PRFLAG_UNSET) {
+		if (pp->mpp->prflag != PR_UNSET) {
 			int prflag = pp->mpp->prflag;
 			/*
 			 * Check Persistent Reservation.
@@ -2647,8 +2646,7 @@ update_path_state (struct vectors * vecs, struct path * pp)
 			condlog(2, "%s: checking persistent "
 				"reservation registration", pp->dev);
 			mpath_pr_event_handle(pp);
-			if (pp->mpp->prflag == PRFLAG_SET &&
-			    prflag != PRFLAG_SET)
+			if (pp->mpp->prflag == PR_SET && prflag != PR_SET)
 				pr_register_active_paths(pp->mpp);
 		}
 
@@ -4231,14 +4229,14 @@ static void mpath_pr_event_handle(struct path *pp)
 	struct prout_param_descriptor *param;
 
 	if (pp->bus != SYSFS_BUS_SCSI) {
-		mpp->prflag = PRFLAG_UNSET;
+		mpp->prflag = PR_UNSET;
 		return;
 	}
 
 	if (update_map_pr(mpp, pp) != MPATH_PR_SUCCESS)
 		return;
 
-	if (mpp->prflag != PRFLAG_SET)
+	if (mpp->prflag != PR_SET)
 		return;
 
 	param = (struct prout_param_descriptor *)calloc(1, sizeof(struct prout_param_descriptor));
-- 
2.50.1

