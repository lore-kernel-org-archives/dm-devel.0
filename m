Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2599B3112DC
	for <dm-devel@lists.linux.dev>; Tue,  9 Sep 2025 00:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757376014; cv=none; b=Vu7hsYJJ39jmgivexx8c7u6ai0qpx86pGSfi7fSAfYGMwLJMZBsiWwREigDsZY6FuaiBAN73K+f5RGJv/HRKNXVI+awxhK1F0HJcbschGrK87+7NLnII0geFWq4ZE44mS9B1oqR1Ki3nbVZTJ8428VU7qcTC8ApN5uKacCrBOWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757376014; c=relaxed/simple;
	bh=oKsJEWLWRtL4XytGOwzgYhUvw+mnqfhbd3zd+tJG69g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=oBXYIGHDDE9VvRQwwuwKYAVrgIzym9W+p/s3LpvcJckCl1PIBn7/ZvRxnI6i9VwuS5+dA7itBjtEfJVk4NltKxzLiXPg1bdKeKZhu8EKWa1Spd5cpTGtrmdfGLq7j5pL17v5gZRTGmKoXjqzFVfENZi5yUECyRfXiKfQFgU+N7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fXA5NR3a; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fXA5NR3a"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757376011;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5yPKTdSUVcCismFw/bCplxfirXkFTDfHuB8MX9ZidLA=;
	b=fXA5NR3a55nnouNUem+Ksu9FFZfI6KUK/0vmGFRE/31IJA7RNLu+set6TmVT/j+t+lg8SO
	U4ML9+Fvt//q08dB5LzEJHfQhjwJSMD8qwHrQDt6DNpQkjaPRfjNDQ29A3OJ/3pz2hOLw5
	J4fDiEa6QsT/hYE43Sxg2+q6wdUrZvg=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-641-1jto_A1PPdWeyy_dJ3OEdA-1; Mon,
 08 Sep 2025 20:00:09 -0400
X-MC-Unique: 1jto_A1PPdWeyy_dJ3OEdA-1
X-Mimecast-MFC-AGG-ID: 1jto_A1PPdWeyy_dJ3OEdA_1757376008
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 40B3C180034D;
	Tue,  9 Sep 2025 00:00:08 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0230B1800446;
	Tue,  9 Sep 2025 00:00:07 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 589006Gn751167
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 8 Sep 2025 20:00:06 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 5890062k751166;
	Mon, 8 Sep 2025 20:00:06 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 21/32] multipathd: unregister PR key when path is restored if necessary
Date: Mon,  8 Sep 2025 19:59:51 -0400
Message-ID: <20250909000002.751039-22-bmarzins@redhat.com>
In-Reply-To: <20250909000002.751039-1-bmarzins@redhat.com>
References: <20250909000002.751039-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 37wFm6WQkRGrZjiu9VsAOV33M3XeIm_dbOOnAmrNmqk_1757376008
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

It is possible that a path was unavailable and either the registered PR
key was removed or the registered PR key was changed and then that new
key was preempted. In both of these situations, this path will still
have a registered key (just not one that matches mpp->reservation_key)
but it should not have one. If the path becomes usable again in this
state, it may allow the multipath device to access storage that it
shouldn't be allowed to access.

To deal with this, track if a multipath device ever had a registered PR
key. If so, and the device no longer has a registered key, explicitly
clear the key when paths get restored.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/structs.h |  2 ++
 multipathd/main.c      | 45 +++++++++++++++++++++++++++++++-----------
 2 files changed, 36 insertions(+), 11 deletions(-)

diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 97093675..a206a7d1 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -524,6 +524,8 @@ struct multipath {
 	int prflag;
 	int prhold;
 	int all_tg_pt;
+	bool ever_registered_pr;
+
 	struct gen_multipath generic_mp;
 	bool fpin_must_reload;
 };
diff --git a/multipathd/main.c b/multipathd/main.c
index 11beaf4e..86d9a098 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2638,7 +2638,7 @@ update_path_state (struct vectors * vecs, struct path * pp)
 
 		/* newstate == PATH_UP || newstate == PATH_GHOST */
 
-		if (pp->mpp->prflag != PR_UNSET) {
+		if (pp->mpp->prflag != PR_UNSET || pp->mpp->ever_registered_pr) {
 			int prflag = pp->mpp->prflag;
 			/*
 			 * Check Persistent Reservation.
@@ -4247,6 +4247,7 @@ static void check_prhold(struct multipath *mpp, struct path *pp)
 
 void set_pr(struct multipath *mpp)
 {
+	mpp->ever_registered_pr = true;
 	mpp->prflag = PR_SET;
 }
 
@@ -4257,16 +4258,21 @@ void unset_pr(struct multipath *mpp)
 	mpp->sa_flags = 0;
 }
 
+/*
+ * Returns MPATH_PR_SUCCESS unless if fails to read the PR keys. If
+ * MPATH_PR_SUCCESS is returned, mpp->prflag will be either PR_SET or
+ * PR_UNSET.
+ */
 static int update_map_pr(struct multipath *mpp, struct path *pp)
 {
 	struct prin_resp resp;
 	unsigned int i;
-	int ret = MPATH_PR_OTHER, isFound;
+	int ret, isFound;
 	bool was_set = (mpp->prflag == PR_SET);
 
 	/* If pr is explicitly unset, it must be manually set */
 	if (mpp->prflag == PR_UNSET)
-		return MPATH_PR_SKIP;
+		return MPATH_PR_SUCCESS;
 
 	if (!get_be64(mpp->reservation_key)) {
 		/* Nothing to do. Assuming pr mgmt feature is disabled*/
@@ -4274,7 +4280,7 @@ static int update_map_pr(struct multipath *mpp, struct path *pp)
 		condlog(was_set ? 2 : 4,
 			"%s: reservation_key not set in multipath.conf",
 			mpp->alias);
-		return MPATH_PR_SKIP;
+		return MPATH_PR_SUCCESS;
 	}
 
 	memset(&resp, 0, sizeof(resp));
@@ -4323,6 +4329,7 @@ static void mpath_pr_event_handle(struct path *pp)
 	struct multipath *mpp = pp->mpp;
 	int ret;
 	struct prout_param_descriptor param;
+	bool clear_reg = false;
 
 	if (pp->bus != SYSFS_BUS_SCSI) {
 		unset_pr(mpp);
@@ -4334,20 +4341,36 @@ static void mpath_pr_event_handle(struct path *pp)
 
 	check_prhold(mpp, pp);
 
-	if (mpp->prflag != PR_SET)
-		return;
+	if (mpp->prflag != PR_SET) {
+		if (!mpp->ever_registered_pr)
+			return;
+		/*
+		 * This path may have been unusable and either the
+		 * registration was cleared or the registered
+		 * key was switched and then that new key was preempted.
+		 * In either case, this path should not have a registration
+		 * but it might still have one, just with a different
+		 * key than mpp->reservation_key is currently set to.
+		 * clear it to be sure.
+		 */
+		clear_reg = true;
+	}
 
 	memset(&param, 0, sizeof(param));
 
-	param.sa_flags = mpp->sa_flags;
-	memcpy(param.sa_key, &mpp->reservation_key, 8);
-	param.num_transportid = 0;
+	if (!clear_reg) {
+		param.sa_flags = mpp->sa_flags;
+		memcpy(param.sa_key, &mpp->reservation_key, 8);
+		param.num_transportid = 0;
+	}
 
-	condlog(3, "device %s:%s", pp->dev, pp->mpp->wwid);
+	condlog(3, "%s registration for device %s:%s",
+		clear_reg ? "Clearing" : "Setting", pp->dev, pp->mpp->wwid);
 
 	ret = prout_do_scsi_ioctl(pp->dev, MPATH_PROUT_REG_IGN_SA, 0, 0, &param, 0);
 	if (ret != MPATH_PR_SUCCESS )
 	{
-		condlog(0,"%s: Reservation registration failed. Error: %d", pp->dev, ret);
+		condlog(0, "%s: %s reservation registration failed. Error: %d",
+			clear_reg ? "Clearing" : "Setting", pp->dev, ret);
 	}
 }
-- 
2.50.1

