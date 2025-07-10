Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C80A2FCE23
	for <dm-devel@lists.linux.dev>; Thu, 10 Jul 2025 18:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752171070; cv=none; b=ANivVQpEEq5tUIR4tvL9NRIxhZ8PG+GI/tEvTodW+gtykm8UsxWBg6gYSyjgZWLrJzfs8bu9zT7sNCasOHW4ZC5xjzzwahxOvK7bc3/76vum6dg2xF1WrcBkjCvU3hwzwLA0ALMUQQFjDtiV/NaZNZPyVePJQehoFXGm8KRS/tU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752171070; c=relaxed/simple;
	bh=70eeWGtrrWfDJYvCYHsxQ0qAX8gUpZH2hI8TikRt2Bc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=UNZm5zO7OH97IjZ17jQrtK//a/oq+fySCEhODnrm3Qluz6acQNh5fVEqJQYUyva3zjAg52TQ7ZmkOGn1VO+eVOLU4vhQ8Xk+AN/iympaVX+SSMsglAOEdq0ZUPBC3ZaBj+nGo+UC1vokHeieUsiPuvK1xHt3DW6zUwfMYC8ASTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cBVglqkY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cBVglqkY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752171067;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bQU8y1IEMlyEpkrJhNxl7G6GU7E3Kkle7VP3u6jDq4M=;
	b=cBVglqkYFWIbHqdQmj8xSQnL4/Yj9U406TZa46sWkaLpzqenYrkKFk3d+USFNo66Xuzr7+
	+6qOTqUx7mUHDelcNzaWy6sC0YsMVKXtq/6vmkLKiICe+ojJJ6SMjh4OhIbm03aRbR3Ax1
	qvKJnjMRB5tYhxb16Mx4OnYnXKka0Ak=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-155-I90PS5MRPkq-nmGX1dUsnA-1; Thu,
 10 Jul 2025 14:11:04 -0400
X-MC-Unique: I90PS5MRPkq-nmGX1dUsnA-1
X-Mimecast-MFC-AGG-ID: I90PS5MRPkq-nmGX1dUsnA_1752171063
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9839A19560B0;
	Thu, 10 Jul 2025 18:11:03 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 580C319560A3;
	Thu, 10 Jul 2025 18:11:03 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 56AIB2Oi3997803
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 10 Jul 2025 14:11:02 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 56AIB2Ov3997802;
	Thu, 10 Jul 2025 14:11:02 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 05/15] multipathd: use update_map_pr in mpath_pr_event_handle
Date: Thu, 10 Jul 2025 14:10:50 -0400
Message-ID: <20250710181100.3997759-6-bmarzins@redhat.com>
In-Reply-To: <20250710181100.3997759-1-bmarzins@redhat.com>
References: <20250710181100.3997759-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: w5-LOgqg9_jJ8DnpVOZVBEWi5U6CH_M41im15tCcee8_1752171063
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Clean up the duplicate code in mpath_pr_event_handle() and
update_map_pr() by making update_map_pr() take an optional path device
to use for its check, instead of checking all path devices and make
mpath_pr_event_handle() call update_map_pr() to do its checking.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathpersist/libmpathpersist.version |  2 +-
 libmpathpersist/mpath_persist_int.c     | 21 +++++---
 libmpathpersist/mpath_persist_int.h     |  2 +-
 multipathd/main.c                       | 68 ++++---------------------
 4 files changed, 25 insertions(+), 68 deletions(-)

diff --git a/libmpathpersist/libmpathpersist.version b/libmpathpersist/libmpathpersist.version
index eed66aa0..b31237db 100644
--- a/libmpathpersist/libmpathpersist.version
+++ b/libmpathpersist/libmpathpersist.version
@@ -34,7 +34,7 @@ global:
 	mpath_persistent_reserve_out__;
 } LIBMPATHPERSIST_2.1.0;
 
-__LIBMPATHPERSIST_INT_1.1.0 {
+__LIBMPATHPERSIST_INT_2.0.0 {
 	/* Internal use by multipath-tools */
 	dumpHex;
 	mpath_alloc_prin_response;
diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index f2c81fa0..92c3ea7e 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -720,7 +720,7 @@ int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
 	return ret;
 }
 
-int update_map_pr(struct multipath *mpp)
+int update_map_pr(struct multipath *mpp, struct path *pp)
 {
 	int noisy=0;
 	struct prin_resp *resp;
@@ -733,7 +733,7 @@ int update_map_pr(struct multipath *mpp)
 		/* Nothing to do. Assuming pr mgmt feature is disabled*/
 		mpp->prflag = PRFLAG_UNSET;
 		condlog(was_set ? 2 : 4, "%s: reservation_key not set in multipath.conf", mpp->alias);
-		return MPATH_PR_SUCCESS;
+		return MPATH_PR_SKIP;
 	}
 
 	resp = mpath_alloc_prin_response(MPATH_PRIN_RKEY_SA);
@@ -742,14 +742,18 @@ int update_map_pr(struct multipath *mpp)
 		condlog(0,"%s : failed to alloc resp in update_map_pr", mpp->alias);
 		return MPATH_PR_OTHER;
 	}
-	if (count_active_paths(mpp) == 0)
-	{
+	if (!pp && count_active_paths(mpp) == 0) {
 		condlog(2, "%s: No available paths to check pr status",
 			mpp->alias);
 		goto out;
 	}
 	mpp->prflag = PRFLAG_UNSET;
-	ret = mpath_prin_activepath(mpp, MPATH_PRIN_RKEY_SA, resp, noisy);
+	if (pp)
+		ret = prin_do_scsi_ioctl(pp->dev, MPATH_PRIN_RKEY_SA, resp,
+					 noisy);
+	else
+		ret = mpath_prin_activepath(mpp, MPATH_PRIN_RKEY_SA, resp,
+					    noisy);
 
 	if (ret != MPATH_PR_SUCCESS )
 	{
@@ -784,8 +788,11 @@ int update_map_pr(struct multipath *mpp)
 	if (isFound)
 	{
 		mpp->prflag = PRFLAG_SET;
-		condlog(was_set ? 3 : 2, "%s: prflag flag set.", mpp->alias );
-	}
+		condlog(was_set ? 3 : 2, "%s: key found. prflag set.",
+			mpp->alias);
+	} else
+		condlog(was_set ? 1 : 3, "%s: key not found. prflag unset.",
+			mpp->alias);
 
 out:
 	free(resp);
diff --git a/libmpathpersist/mpath_persist_int.h b/libmpathpersist/mpath_persist_int.h
index 7819823c..7b32c1e2 100644
--- a/libmpathpersist/mpath_persist_int.h
+++ b/libmpathpersist/mpath_persist_int.h
@@ -20,6 +20,6 @@ int prin_do_scsi_ioctl(char * dev, int rq_servact, struct prin_resp * resp, int
 int prout_do_scsi_ioctl( char * dev, int rq_servact, int rq_scope,
 			 unsigned int rq_type, struct prout_param_descriptor *paramp, int noisy);
 void dumpHex(const char* , int len, int no_ascii);
-int update_map_pr(struct multipath *mpp);
+int update_map_pr(struct multipath *mpp, struct path *pp);
 
 #endif /* MPATH_PERSIST_INT_H_INCLUDED */
diff --git a/multipathd/main.c b/multipathd/main.c
index 46eef222..ace278f1 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -727,7 +727,7 @@ fail:
 	sync_map_state(mpp, false);
 
 	if (mpp->prflag != PRFLAG_SET)
-		update_map_pr(mpp);
+		update_map_pr(mpp, NULL);
 	if (mpp->prflag == PRFLAG_SET)
 		pr_register_active_paths(mpp);
 
@@ -1403,7 +1403,7 @@ rescan:
 
 	if (retries >= 0) {
 		if (start_waiter)
-			update_map_pr(mpp);
+			update_map_pr(mpp, NULL);
 		if (mpp->prflag == PRFLAG_SET && prflag != PRFLAG_SET)
 				pr_register_active_paths(mpp);
 		condlog(2, "%s [%s]: path added to devmap %s",
@@ -3312,7 +3312,7 @@ configure (struct vectors * vecs, enum force_reload_types reload_type)
 	vector_foreach_slot(mpvec, mpp, i){
 		if (remember_wwid(mpp->wwid) == 1)
 			trigger_paths_udev_change(mpp, true);
-		update_map_pr(mpp);
+		update_map_pr(mpp, NULL);
 		if (mpp->prflag == PRFLAG_SET)
 			pr_register_active_paths(mpp);
 	}
@@ -4230,70 +4230,24 @@ main (int argc, char *argv[])
 
 static void mpath_pr_event_handle(struct path *pp)
 {
-	struct multipath * mpp;
-	unsigned int i;
-	int ret, isFound;
+	struct multipath *mpp = pp->mpp;
+	int ret;
 	struct prout_param_descriptor *param;
-	struct prin_resp *resp;
 
-	mpp = pp->mpp;
 	if (pp->bus != SYSFS_BUS_SCSI) {
 		mpp->prflag = PRFLAG_UNSET;
 		return;
 	}
 
-	if (!get_be64(mpp->reservation_key)) {
-		mpp->prflag = PRFLAG_UNSET;
+	if (update_map_pr(mpp, pp) != MPATH_PR_SUCCESS)
 		return;
-	}
-
-	resp = mpath_alloc_prin_response(MPATH_PRIN_RKEY_SA);
-	if (!resp){
-		condlog(0,"%s Alloc failed for prin response", pp->dev);
-		goto out;
-	}
-
-	mpp->prflag = PRFLAG_UNSET;
-	ret = prin_do_scsi_ioctl(pp->dev, MPATH_PRIN_RKEY_SA, resp, 0);
-	if (ret != MPATH_PR_SUCCESS )
-	{
-		condlog(0,"%s : pr in read keys service action failed. Error=%d", pp->dev, ret);
-		goto out;
-	}
-
-	condlog(3, " event pr=%d addlen=%d",resp->prin_descriptor.prin_readkeys.prgeneration,
-			resp->prin_descriptor.prin_readkeys.additional_length );
-
-	if (resp->prin_descriptor.prin_readkeys.additional_length == 0 )
-	{
-		condlog(1, "%s: No key found. Device may not be registered.", pp->dev);
-		goto out;
-	}
-	condlog(2, "Multipath  reservation_key: 0x%" PRIx64 " ",
-		get_be64(mpp->reservation_key));
 
-	isFound =0;
-	for (i = 0; i < resp->prin_descriptor.prin_readkeys.additional_length/8; i++ )
-	{
-		condlog(2, "PR IN READKEYS[%d]  reservation key:",i);
-		dumpHex((char *)&resp->prin_descriptor.prin_readkeys.key_list[i*8], 8 , -1);
-		if (!memcmp(&mpp->reservation_key, &resp->prin_descriptor.prin_readkeys.key_list[i*8], 8))
-		{
-			condlog(2, "%s: pr key found in prin readkeys response", mpp->alias);
-			isFound =1;
-			break;
-		}
-	}
-	if (!isFound)
-	{
-		condlog(0, "%s: Either device not registered or ", pp->dev);
-		condlog(0, "host is not authorised for registration. Skip path");
-		goto out;
-	}
+	if (mpp->prflag != PRFLAG_SET)
+		return;
 
 	param = (struct prout_param_descriptor *)calloc(1, sizeof(struct prout_param_descriptor));
 	if (!param)
-		goto out;
+		return;
 
 	param->sa_flags = mpp->sa_flags;
 	memcpy(param->sa_key, &mpp->reservation_key, 8);
@@ -4306,10 +4260,6 @@ static void mpath_pr_event_handle(struct path *pp)
 	{
 		condlog(0,"%s: Reservation registration failed. Error: %d", pp->dev, ret);
 	}
-	mpp->prflag = PRFLAG_SET;
 
 	free(param);
-out:
-	if (resp)
-		free(resp);
 }
-- 
2.48.1

