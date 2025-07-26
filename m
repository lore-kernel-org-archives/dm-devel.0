Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B09B1F2BAD
	for <dm-devel@lists.linux.dev>; Sat, 26 Jul 2025 03:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753502349; cv=none; b=CDKD1NuKJ9AYsgslpLE0lt9xuPcse/RSXAR9VKf58mdRqALyrnfn7YiGubTh+8yAzQOAueKi4Oo2fmB86urrX4d9XBumddAevwn5BLOkw89SqQ2867y7hvANX2+BkIqBSkP3G4Qw1Y30YqU9meTa3iCCUyYIS3RO5tqx+8cXQhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753502349; c=relaxed/simple;
	bh=gLfBnO3QXL0UlTE5DUewkJquzSMSSaG7EitRilnu2kE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=HqKBDJzJ7DsLXkbk+y6+dKZQTkptYGZ8eBTFh68NcrC44sI4VJP4mx9ERerGO5UIehiuSeDZ831wCn8c19bArqTrrRpWHNrT3QSzyUaFISoD8Qfc8ckaVTLuo1C0b1TuWo4nI2XpTq2uxhTD92dCcr3RGm/GI1WZsNfeYY64hWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QgYQInlV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QgYQInlV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753502345;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NDtu+mXPqSeeUk96UM6QMXuTwoQ0JMx0Alg4yB5VB38=;
	b=QgYQInlVFryXvWTCRWPTTiXm6vNf6MJ7ZhAQYd5/IHEcOcQDG6RG2L8EjtRrCNaBRZlAIN
	1ixHx0ufYeETJ6saKeruynJVC4s9zU4MsmZsyp6x2uXx2azMTH3ZGPB2DodcKtBgc3u0Pe
	wR/iRQoZpq7Yq9EDpYNeUL4TuKEgeA0=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-17-n58B0lSDNqWVCAmcTfTXeA-1; Fri,
 25 Jul 2025 23:58:59 -0400
X-MC-Unique: n58B0lSDNqWVCAmcTfTXeA-1
X-Mimecast-MFC-AGG-ID: n58B0lSDNqWVCAmcTfTXeA_1753502339
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F3F001800115;
	Sat, 26 Jul 2025 03:58:58 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BF5621800D86;
	Sat, 26 Jul 2025 03:58:58 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 56Q3wv26363337
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 25 Jul 2025 23:58:57 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 56Q3wvaK363336;
	Fri, 25 Jul 2025 23:58:57 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 06/14] multipathd: unregister PR key when path is restored if necessary
Date: Fri, 25 Jul 2025 23:58:47 -0400
Message-ID: <20250726035855.363290-7-bmarzins@redhat.com>
In-Reply-To: <20250726035855.363290-1-bmarzins@redhat.com>
References: <20250726035855.363290-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: PtKek9yhEx18BzimaNuYsUa39A7s7v5A5ZDcNruUOYg_1753502339
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
---
 libmultipath/structs.h |  2 ++
 multipathd/main.c      | 46 ++++++++++++++++++++++++++++++++----------
 2 files changed, 37 insertions(+), 11 deletions(-)

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
index c1ed1488..cb00c1f8 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2638,7 +2638,8 @@ update_path_state (struct vectors * vecs, struct path * pp)
 
 		/* newstate == PATH_UP || newstate == PATH_GHOST */
 
-		if (pp->mpp->prflag != PR_UNSET) {
+		if (pp->mpp->prflag != PR_UNSET ||
+		    pp->mpp->ever_registered_pr) {
 			int prflag = pp->mpp->prflag;
 			/*
 			 * Check Persistent Reservation.
@@ -4246,6 +4247,7 @@ static void check_prhold(struct multipath *mpp, struct path *pp)
 
 void set_pr(struct multipath *mpp)
 {
+	mpp->ever_registered_pr = true;
 	mpp->prflag = PR_SET;
 }
 
@@ -4256,23 +4258,28 @@ void unset_pr(struct multipath *mpp)
 	mpp->sa_flags = 0;
 }
 
+/*
+ * Returns MPATH_PR_SUCCESS unless if fails to read the PR keys. If
+ * MPATH_PR_SUCCESS is returned, mpp->prflag will be either PR_SET or
+ * PR_UNSET.
+ */
 static int update_map_pr(struct multipath *mpp, struct path *pp)
 {
 	int noisy=0;
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
 		unset_pr(mpp);
 		condlog(was_set ? 2 : 4, "%s: reservation_key not set in multipath.conf", mpp->alias);
-		return MPATH_PR_SKIP;
+		return MPATH_PR_SUCCESS;
 	}
 
 	memset(&resp, 0, sizeof(resp));
@@ -4320,6 +4327,7 @@ static void mpath_pr_event_handle(struct path *pp)
 	struct multipath *mpp = pp->mpp;
 	int ret;
 	struct prout_param_descriptor param;
+	bool clear_reg = false;
 
 	if (pp->bus != SYSFS_BUS_SCSI) {
 		unset_pr(mpp);
@@ -4331,20 +4339,36 @@ static void mpath_pr_event_handle(struct path *pp)
 
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
2.48.1

