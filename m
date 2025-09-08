Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D80684A07
	for <dm-devel@lists.linux.dev>; Tue,  9 Sep 2025 00:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757376013; cv=none; b=SUapwWGMK/ZH4IY7JNs/IIPVTrZlDBSJN+8Zj4+uWtIRFrtPiQET/sTA7XEExCKOkW6p1tZE/POJVtRSvudDVbWrjCkU3xQb7ROqSEZQwyC1BoQCcYWr+5RF3/DoYqkWXacgcWseasAuDISazVXbrKV8mtoazjll8QzdfZeQnRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757376013; c=relaxed/simple;
	bh=6vhwEF8oUCfgHO2xif0M0v/WGp9pNVrhk3fFaHIXGoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=HR2HYRyD5pecVBbnFxBlq/mzcRUoLzu/FeiOAvovFEmjTsZiDrMnf1QDvM9YlFgkvItRU98zZI4GWXg9OXr8QfgCt+KxGAA8LInzcwgR121NidvF4Z0Kv6IJe9ezBSO27tNSdwChT1IULqRg8VGT9bmoDZTdEsh6/48uFwsps2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WsYVc6E7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WsYVc6E7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757376010;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xBdrKNS8jyJ1xgny0HQFUVJWhiS2k++6mI2r4bzzqLA=;
	b=WsYVc6E7vwZiMT6h3dLXTq9r3ckQg8DoIor/zTu29qtQMsYpmjOt1PlQweA+v2oyGeTDxg
	7+t2SVIhIRqCvimi91KKuIK2WqIgwtSRe/qSxzMwRB40uooOUpVrPQbRnUZs6+64WyyKpE
	nNrzxCybp+vwT5y2AcC6R0fcNTMxdvA=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-529-GE--HtRAPmi9Vuu76KYMZA-1; Mon,
 08 Sep 2025 20:00:09 -0400
X-MC-Unique: GE--HtRAPmi9Vuu76KYMZA-1
X-Mimecast-MFC-AGG-ID: GE--HtRAPmi9Vuu76KYMZA_1757376008
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1BFDA195608B;
	Tue,  9 Sep 2025 00:00:08 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D054D1800452;
	Tue,  9 Sep 2025 00:00:07 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 5890068R751163
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 8 Sep 2025 20:00:06 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 589006UC751162;
	Mon, 8 Sep 2025 20:00:06 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 20/32] multipathd: wrap setting and unsetting prflag
Date: Mon,  8 Sep 2025 19:59:50 -0400
Message-ID: <20250909000002.751039-21-bmarzins@redhat.com>
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
X-Mimecast-MFC-PROC-ID: mVqzn7nPkGzi-RMy5Wz1QZ8xAkdpkPAD6HFLZ60qruw_1757376008
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

When prflag is unset, prhold and sa_flags should also be unset. A future
patch will add another variable to be set when prflag is set. Wrap all
these actions in set_pr() and unset_pr().

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/cli_handlers.c | 10 ++++------
 multipathd/main.c         | 34 ++++++++++++++++++++--------------
 multipathd/main.h         |  2 ++
 3 files changed, 26 insertions(+), 20 deletions(-)

diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 36552c24..0c65e7d2 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -1290,7 +1290,7 @@ cli_setprstatus(void * v, struct strbuf *reply, void * data)
 		return -ENODEV;
 
 	if (mpp->prflag != PR_SET) {
-		mpp->prflag = PR_SET;
+		set_pr(mpp);
 		condlog(2, "%s: prflag set", param);
 	}
 
@@ -1311,12 +1311,10 @@ cli_unsetprstatus(void * v, struct strbuf *reply, void * data)
 		return -ENODEV;
 
 	if (mpp->prflag != PR_UNSET) {
-		mpp->prflag = PR_UNSET;
 		condlog(2, "%s: prflag unset", param);
-	}
-	if (mpp->prhold != PR_UNSET) {
-		mpp->prhold = PR_UNSET;
-		condlog(2, "%s: prhold unset (by clearing prflag)", param);
+		if (mpp->prhold != PR_UNSET)
+			condlog(2, "%s: prhold unset (by clearing prflag)", param);
+		unset_pr(mpp);
 	}
 
 	return 0;
diff --git a/multipathd/main.c b/multipathd/main.c
index 394fd47a..11beaf4e 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -4227,10 +4227,6 @@ static void check_prhold(struct multipath *mpp, struct path *pp)
 	struct prin_resp resp = {{{.prgeneration = 0}}};
 	int status;
 
-	if (mpp->prflag == PR_UNSET) {
-		mpp->prhold = PR_UNSET;
-		return;
-	}
 	if (mpp->prflag != PR_SET || mpp->prhold != PR_UNKNOWN)
 		return;
 
@@ -4249,6 +4245,18 @@ static void check_prhold(struct multipath *mpp, struct path *pp)
 		mpp->prhold = PR_SET;
 }
 
+void set_pr(struct multipath *mpp)
+{
+	mpp->prflag = PR_SET;
+}
+
+void unset_pr(struct multipath *mpp)
+{
+	mpp->prflag = PR_UNSET;
+	mpp->prhold = PR_UNSET;
+	mpp->sa_flags = 0;
+}
+
 static int update_map_pr(struct multipath *mpp, struct path *pp)
 {
 	struct prin_resp resp;
@@ -4262,7 +4270,7 @@ static int update_map_pr(struct multipath *mpp, struct path *pp)
 
 	if (!get_be64(mpp->reservation_key)) {
 		/* Nothing to do. Assuming pr mgmt feature is disabled*/
-		mpp->prflag = PR_UNSET;
+		unset_pr(mpp);
 		condlog(was_set ? 2 : 4,
 			"%s: reservation_key not set in multipath.conf",
 			mpp->alias);
@@ -4274,12 +4282,11 @@ static int update_map_pr(struct multipath *mpp, struct path *pp)
 	ret = prin_do_scsi_ioctl(pp->dev, MPATH_PRIN_RKEY_SA, &resp, 0);
 	if (ret != MPATH_PR_SUCCESS) {
 		if (ret == MPATH_PR_ILLEGAL_REQ)
-			mpp->prflag = PR_UNSET;
+			unset_pr(mpp);
 		condlog(0, "%s : pr in read keys service action failed Error=%d",
 			mpp->alias, ret);
 		return ret;
 	}
-	mpp->prflag = PR_UNSET;
 
 	condlog(4, "%s: Multipath reservation_key: 0x%" PRIx64 " ", mpp->alias,
 		get_be64(mpp->reservation_key));
@@ -4300,11 +4307,13 @@ static int update_map_pr(struct multipath *mpp, struct path *pp)
 	}
 
 	if (isFound) {
-		mpp->prflag = PR_SET;
+		set_pr(mpp);
 		condlog(was_set ? 3 : 2, "%s: key found. prflag set.", mpp->alias);
-	} else
+	} else {
+		unset_pr(mpp);
 		condlog(was_set ? 1 : 3, "%s: key not found. prflag unset.",
 			mpp->alias);
+	}
 
 	return MPATH_PR_SUCCESS;
 }
@@ -4316,15 +4325,12 @@ static void mpath_pr_event_handle(struct path *pp)
 	struct prout_param_descriptor param;
 
 	if (pp->bus != SYSFS_BUS_SCSI) {
-		mpp->prflag = PR_UNSET;
+		unset_pr(mpp);
 		return;
 	}
 
-	if (update_map_pr(mpp, pp) != MPATH_PR_SUCCESS) {
-		if (mpp->prflag == PR_UNSET)
-			mpp->prhold = PR_UNSET;
+	if (update_map_pr(mpp, pp) != MPATH_PR_SUCCESS)
 		return;
-	}
 
 	check_prhold(mpp, pp);
 
diff --git a/multipathd/main.h b/multipathd/main.h
index c94362e4..29b57e3d 100644
--- a/multipathd/main.h
+++ b/multipathd/main.h
@@ -52,4 +52,6 @@ bool check_path_wwid_change(struct path *pp);
 int finish_path_init(struct path *pp, struct vectors * vecs);
 int resize_map(struct multipath *mpp, unsigned long long size,
 	       struct vectors *vecs);
+void set_pr(struct multipath *mpp);
+void unset_pr(struct multipath *mpp);
 #endif /* MAIN_H_INCLUDED */
-- 
2.50.1

