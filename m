Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07CBC1F0E58
	for <dm-devel@lists.linux.dev>; Sat, 26 Jul 2025 03:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753502346; cv=none; b=BYmgzvZiMyr0Fo0r5aiZNxaBTKocZGZeK5cgdJq7oiJ+SNfwBnHPN6AWQ6nQAS9DDsrDHlkjBy2T2Tikh83foHBsVOOF4X3a7XxwlUUGxIX6SeIfyPTsqTOus2e023C+LTcxVuPe1WwUfjfLo+wR/E3E/ZQZhxprrfFNqcRvV4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753502346; c=relaxed/simple;
	bh=MP0SK72GLVQ6RQ6z0r4GbKfhpugQh++KD7nVV6vI8GQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=iEDdoRmTvPHEzkbdAtozvI91sUq9rgQhiJaAAVG2vnrvH2KJq2jIYxH6eQ69QfmEID5U83GYTy2D8e//fed9nH/yFud0xEGL4szFVZgziPyV48fz9RcvlalpMs5HzV9td2r5uY8qPvg8WW593RM6aKHJGuxJFznwa7quUgHiZQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VRrA+hAO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VRrA+hAO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753502343;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IdsM1dgrt6saPYeGZKaMyt1zAdXKmO53kN4WcZTMDss=;
	b=VRrA+hAO77QX3/Yul3QdzpZVp2timRo1r+Fy5HJed8RCelAh54Dg7dkyLKzzUKd+vGgUPl
	R/7YFzmRyDapeg4EbzbrZjWoom0Zng9A1MKPcwRRDfYyWS01cpbd6rpSpqYAgahdcOXraB
	hqCrahK6t4bEgPEGNEtYM6DN/+FdOi0=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-324-nfLbX2yFMoiaTI9GPR4RoQ-1; Fri,
 25 Jul 2025 23:59:00 -0400
X-MC-Unique: nfLbX2yFMoiaTI9GPR4RoQ-1
X-Mimecast-MFC-AGG-ID: nfLbX2yFMoiaTI9GPR4RoQ_1753502339
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 188BC19560A3;
	Sat, 26 Jul 2025 03:58:59 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B62F6195608D;
	Sat, 26 Jul 2025 03:58:58 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 56Q3wvBj363333
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 25 Jul 2025 23:58:57 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 56Q3wv6t363332;
	Fri, 25 Jul 2025 23:58:57 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 05/14] multipathd: wrap setting and unsetting prflag
Date: Fri, 25 Jul 2025 23:58:46 -0400
Message-ID: <20250726035855.363290-6-bmarzins@redhat.com>
In-Reply-To: <20250726035855.363290-1-bmarzins@redhat.com>
References: <20250726035855.363290-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: AE18hzba9HFLe2lja3J--3U8dU_UJc8k2cHz2t_9ifs_1753502339
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

When prflag is unset, prhold and sa_flags should also be unset. A future
patch will add another variable to be set when prflag is set. Wrap all
these actions in set_pr() and unset_pr().

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/cli_handlers.c | 11 +++++------
 multipathd/main.c         | 34 ++++++++++++++++++++--------------
 multipathd/main.h         |  2 ++
 3 files changed, 27 insertions(+), 20 deletions(-)

diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 34910c9b..c1051c85 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -1290,7 +1290,7 @@ cli_setprstatus(void * v, struct strbuf *reply, void * data)
 		return -ENODEV;
 
 	if (mpp->prflag != PR_SET) {
-		mpp->prflag = PR_SET;
+		set_pr(mpp);
 		condlog(2, "%s: prflag set", param);
 	}
 
@@ -1311,12 +1311,11 @@ cli_unsetprstatus(void * v, struct strbuf *reply, void * data)
 		return -ENODEV;
 
 	if (mpp->prflag != PR_UNSET) {
-		mpp->prflag = PR_UNSET;
 		condlog(2, "%s: prflag unset", param);
-	}
-	if (mpp->prhold != PR_UNSET) {
-		mpp->prhold = PR_UNSET;
-		condlog(2, "%s: prhold unset (by clearing prflag)", param);
+		if (mpp->prhold != PR_UNSET)
+			condlog(2, "%s: prhold unset (by clearing prflag)",
+				param);
+		unset_pr(mpp);
 	}
 
 	return 0;
diff --git a/multipathd/main.c b/multipathd/main.c
index 0e95ca3a..c1ed1488 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -4227,10 +4227,6 @@ static void check_prhold(struct multipath *mpp, struct path *pp)
 	struct prin_resp resp = {0};
 	int status;
 
-	if (mpp->prflag == PR_UNSET) {
-		mpp->prhold = PR_UNSET;
-		return;
-	}
 	if (mpp->prflag != PR_SET || mpp->prhold != PR_UNKNOWN)
 		return;
 
@@ -4248,6 +4244,18 @@ static void check_prhold(struct multipath *mpp, struct path *pp)
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
 	int noisy=0;
@@ -4262,7 +4270,7 @@ static int update_map_pr(struct multipath *mpp, struct path *pp)
 
 	if (!get_be64(mpp->reservation_key)) {
 		/* Nothing to do. Assuming pr mgmt feature is disabled*/
-		mpp->prflag = PR_UNSET;
+		unset_pr(mpp);
 		condlog(was_set ? 2 : 4, "%s: reservation_key not set in multipath.conf", mpp->alias);
 		return MPATH_PR_SKIP;
 	}
@@ -4272,11 +4280,10 @@ static int update_map_pr(struct multipath *mpp, struct path *pp)
 	ret = prin_do_scsi_ioctl(pp->dev, MPATH_PRIN_RKEY_SA, &resp, noisy);
 	if (ret != MPATH_PR_SUCCESS) {
 		if (ret == MPATH_PR_ILLEGAL_REQ)
-			mpp->prflag = PR_UNSET;
+			unset_pr(mpp);
 		condlog(0,"%s : pr in read keys service action failed Error=%d", mpp->alias, ret);
 		return ret;
 	}
-	mpp->prflag = PR_UNSET;
 
 	condlog(4, "%s: Multipath reservation_key: 0x%" PRIx64 " ", mpp->alias,
 		get_be64(mpp->reservation_key));
@@ -4296,12 +4303,14 @@ static int update_map_pr(struct multipath *mpp, struct path *pp)
 	}
 
 	if (isFound) {
-		mpp->prflag = PR_SET;
+		set_pr(mpp);
 		condlog(was_set ? 3 : 2, "%s: key found. prflag set.",
 			mpp->alias);
-	} else
+	} else {
+		unset_pr(mpp);
 		condlog(was_set ? 1 : 3, "%s: key not found. prflag unset.",
 			mpp->alias);
+	}
 
 	return MPATH_PR_SUCCESS;
 }
@@ -4313,15 +4322,12 @@ static void mpath_pr_event_handle(struct path *pp)
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
2.48.1

