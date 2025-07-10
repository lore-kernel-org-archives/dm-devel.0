Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9056B2FCE2F
	for <dm-devel@lists.linux.dev>; Thu, 10 Jul 2025 18:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752171071; cv=none; b=CeEoFP23cy6OOlGlSGev7f5B35XQXoktmy9cNzzKnOAV0Ojo5OBAWKhgvMVWA78HieKpfxB6WCGXg/8ueSTroa/QDkXY6xYDu+Ria1qTflFTZfGovTNm1Ntstov70vpWRwr/pPK0qOF3T0AQuM+hSEwcMmO4uXgXMfEq+2jo2mU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752171071; c=relaxed/simple;
	bh=iXV6OCXcWQLlji42ofaeo9fzIyTBtsP8H+Tc9YOBBfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=petFH2jVhGLwTcI63pfwowNTl4XC2/u5cCEpeJDHBYVx6InQ7pTUILBZADgAXGijzqiDRZhoN+KZWMw+pL8N0pJNz2jKL8C872itfX3p4CZiw1vXKqtrNAiNte/WpkPlt2UbRIWEcr8ohqV1xp7LYJ1WnlkY0W29Z30ryZgU5L4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fVB2nsHG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fVB2nsHG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752171068;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d9iVDYQOIWIdR70/cK2wCGC0k/AZrxvxa+KzgjnlhLU=;
	b=fVB2nsHGxSW2r5TennGgLOzSmHEqbu1R04Nu9kQyrUjxSi4Z8xGwitAqDL3HNwwtUW7m8r
	iXG2VvB0+NfLjrYMrqomVonf+pmiVl0G5oPfpF75R1ttTwYKdg1idifFIl0d2rnhmJazeL
	IHtLOJDQNpb7Bcd1m0rQjOrnlzweaVU=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-534-HOp9ZVUXPEm06YwfirSW6A-1; Thu,
 10 Jul 2025 14:11:05 -0400
X-MC-Unique: HOp9ZVUXPEm06YwfirSW6A-1
X-Mimecast-MFC-AGG-ID: HOp9ZVUXPEm06YwfirSW6A_1752171064
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 63F3919560A2;
	Thu, 10 Jul 2025 18:11:04 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 226FA1977000;
	Thu, 10 Jul 2025 18:11:04 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 56AIB2vh3997819
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 10 Jul 2025 14:11:02 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 56AIB2wG3997818;
	Thu, 10 Jul 2025 14:11:02 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 09/15] limpathpersist: redesign failed release workaround
Date: Thu, 10 Jul 2025 14:10:54 -0400
Message-ID: <20250710181100.3997759-10-bmarzins@redhat.com>
In-Reply-To: <20250710181100.3997759-1-bmarzins@redhat.com>
References: <20250710181100.3997759-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: kagH2MqJfipPR2ikOk4KKiYZPGzR3ytxIcf-WQoZDRE_1752171064
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

The workaround for releasing a reservation held by a failed path
(clearing all persistent reservation data and then reregistering all the
keys) has several problems. It requires devices that support the READ
FULL STATUS command and are capable of specifying TransportIDs with
REGISTRATION commands (SIP_C), neither of which are mandatory to support
SCSI Persistent Reservations. Non SIP_C devices will be left with no
registered keys. Also, not all cleared keys are registered, just the
ones going to the Target Port receiving the REGISTRATION command. To
reregister all the keys, the code would have to also use the "All Target
Ports" flag to register keys on different Target Ports, but this could
end up registering keys on paths they aren't supposed to be on (for
instance if one of the registered keys was only there because the path
was down and it couldn't be released).

The redesign avoids these issues by only using mandatory Persistent
Reservation commands, without extra optional parameters or flags, and
only effects the keys of the multipath device it is being issued on.
The new workaround is:
1. Suspend the multipath device to prevent I/O
2. Preempt the key to move the reservation to an available path. This
   also removes the registered keys from every path except the path
   issuing the PREEMPT command. Since the device is suspended, not I/O
   can go to these unregisted paths and fail.
3. Release the reservation on the path that now holds it.
4. Resume the device (since it no longer matters that most of the paths
   no longer have a registered key)
5. Reregister the keys on all the paths.

If steps 3 or 4 fail, the code will attempt to reregister the keys, and
then attempt (or possibly re-attempt) the resume.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathpersist/mpath_persist_int.c | 173 ++++++++++++----------------
 libmultipath/libmultipath.version   |   1 +
 2 files changed, 76 insertions(+), 98 deletions(-)

diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index 13829742..7fb08b2e 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -366,7 +366,8 @@ static int mpath_prout_reg(struct multipath *mpp,int rq_servact, int rq_scope,
 
 static int mpath_prout_common(struct multipath *mpp,int rq_servact, int rq_scope,
 			      unsigned int rq_type,
-			      struct prout_param_descriptor* paramp, int noisy)
+			      struct prout_param_descriptor* paramp, int noisy,
+			      struct path **pptr)
 {
 	int i,j, ret;
 	struct pathgroup *pgp = NULL;
@@ -385,6 +386,8 @@ static int mpath_prout_common(struct multipath *mpp,int rq_servact, int rq_scope
 			found = true;
 			ret = prout_do_scsi_ioctl(pp->dev, rq_servact, rq_scope,
 						  rq_type, paramp, noisy);
+			if (ret == MPATH_PR_SUCCESS && pptr)
+				*pptr = pp;
 			if (ret != MPATH_PR_RETRYABLE_ERROR)
 				return ret;
 		}
@@ -405,14 +408,12 @@ static int mpath_prout_rel(struct multipath *mpp,int rq_servact, int rq_scope,
 	struct path *pp = NULL;
 	int active_pathcount = 0;
 	pthread_attr_t attr;
-	int rc, found = 0;
+	int rc;
 	int count = 0;
 	int status = MPATH_PR_SUCCESS;
-	struct prin_resp resp;
-	struct prout_param_descriptor *pamp = NULL;
-	struct prin_resp *pr_buff;
-	int length;
-	struct transportid *pptr = NULL;
+	struct prin_resp resp = {0};
+	uint16_t udev_flags = (mpp->skip_kpartx) ? MPATH_UDEV_NO_KPARTX_FLAG : 0;
+	bool did_resume = false;
 
 	if (!mpp)
 		return MPATH_PR_DMMP_ERROR;
@@ -502,104 +503,78 @@ static int mpath_prout_rel(struct multipath *mpp,int rq_servact, int rq_scope,
 	}
 
 	condlog (2, "%s: Path holding reservation is not available.", mpp->wwid);
-
-	pr_buff =  mpath_alloc_prin_response(MPATH_PRIN_RFSTAT_SA);
-	if (!pr_buff){
-		condlog (0, "%s: failed to  alloc pr in response buffer.", mpp->wwid);
+	/*
+	 * Cannot free the reservation because the path that is holding it
+	 * is not usable. Workaround this by:
+	 * 1. Suspending the device
+	 * 2. Preempting the reservation to move it to a usable path
+	 *    (this removes the registered keys on all paths except the
+	 *    preempting one. Since the device is suspended, no IO can
+	 *    go to these unregistered paths and fail).
+	 * 3. Releasing the reservation on the path that now holds it.
+	 * 4. Resuming the device (since it no longer matters that most of
+	 *    that paths no longer have a registered key)
+	 * 5. Reregistering keys on all the paths
+	 */
+
+	if (!dm_simplecmd_noflush(DM_DEVICE_SUSPEND, mpp->alias, 0)) {
+		condlog(0, "%s: release: failed to suspend dm device.", mpp->wwid);
 		return MPATH_PR_OTHER;
 	}
 
-	status = mpath_prin_activepath (mpp, MPATH_PRIN_RFSTAT_SA, pr_buff, noisy);
-
-	if (status != MPATH_PR_SUCCESS){
-		condlog (0,  "%s: pr in read full status command failed.",  mpp->wwid);
-		goto out;
-	}
-
-	num = pr_buff->prin_descriptor.prin_readfd.number_of_descriptor;
-	if (0 == num){
-		goto out;
-	}
-	length = sizeof (struct prout_param_descriptor) + (sizeof (struct transportid *));
-
-	pamp = (struct prout_param_descriptor *)malloc (length);
-	if (!pamp){
-		condlog (0, "%s: failed to alloc pr out parameter.", mpp->wwid);
-		goto out;
-	}
-
-	memset(pamp, 0, length);
-
-	pamp->trnptid_list[0] = (struct transportid *) malloc (sizeof (struct transportid));
-	if (!pamp->trnptid_list[0]){
-		condlog (0, "%s: failed to alloc pr out transportid.", mpp->wwid);
-		goto out1;
-	}
-	pptr = pamp->trnptid_list[0];
-
-	if (get_be64(mpp->reservation_key)){
-		memcpy (pamp->key, &mpp->reservation_key, 8);
-		condlog (3, "%s: reservation key set.", mpp->wwid);
+	memset(paramp, 0, sizeof(*paramp));
+	memcpy(paramp->key, &mpp->reservation_key, 8);
+	memcpy(paramp->sa_key, &mpp->reservation_key, 8);
+	status = mpath_prout_common(mpp, MPATH_PROUT_PREE_SA, rq_scope, rq_type,
+				    paramp, noisy, &pp);
+	if (status != MPATH_PR_SUCCESS) {
+		condlog(0, "%s: release: pr preempt command failed.", mpp->wwid);
+		goto fail_resume;
 	}
 
-	status = mpath_prout_common (mpp, MPATH_PROUT_CLEAR_SA,
-				     rq_scope, rq_type, pamp, noisy);
-
-	if (status) {
-		condlog(0, "%s: failed to send CLEAR_SA", mpp->wwid);
-		goto out2;
+	memset(paramp, 0, sizeof(*paramp));
+	memcpy(paramp->key, &mpp->reservation_key, 8);
+	status = prout_do_scsi_ioctl(pp->dev, MPATH_PROUT_REL_SA, rq_scope,
+				     rq_type, paramp, noisy);
+	if (status != MPATH_PR_SUCCESS) {
+		condlog(0, "%s: release on alternate path failed.", mpp->wwid);
+		goto out_reregister;
 	}
 
-	pamp->num_transportid = 1;
-
-	for (i = 0; i < num; i++){
-		if (get_be64(mpp->reservation_key) &&
-			memcmp(pr_buff->prin_descriptor.prin_readfd.descriptors[i]->key,
-			       &mpp->reservation_key, 8)){
-			/*register with transport id*/
-			memset(pamp, 0, length);
-			pamp->trnptid_list[0] = pptr;
-			memset (pamp->trnptid_list[0], 0, sizeof (struct transportid));
-			memcpy (pamp->sa_key,
-					pr_buff->prin_descriptor.prin_readfd.descriptors[i]->key, 8);
-			pamp->sa_flags = MPATH_F_SPEC_I_PT_MASK;
-			pamp->num_transportid = 1;
-
-			memcpy (pamp->trnptid_list[0],
-					&pr_buff->prin_descriptor.prin_readfd.descriptors[i]->trnptid,
-					sizeof (struct transportid));
-			status = mpath_prout_common (mpp, MPATH_PROUT_REG_SA, 0, rq_type,
-					pamp, noisy);
-
-			pamp->sa_flags = 0;
-			memcpy (pamp->key, pr_buff->prin_descriptor.prin_readfd.descriptors[i]->key, 8);
-			memset (pamp->sa_key, 0, 8);
-			pamp->num_transportid = 0;
-			status = mpath_prout_common (mpp, MPATH_PROUT_REG_SA, 0, rq_type,
-					pamp, noisy);
-		}
-		else
-		{
-			if (get_be64(mpp->reservation_key))
-				found = 1;
-		}
-
-
-	}
-
-	if (found){
-		memset (pamp, 0, length);
-		memcpy (pamp->sa_key, &mpp->reservation_key, 8);
-		memset (pamp->key, 0, 8);
-		status = mpath_prout_reg(mpp, MPATH_PROUT_REG_SA, rq_scope, rq_type, pamp, noisy);
+	if (!dm_simplecmd_noflush(DM_DEVICE_RESUME, mpp->alias, udev_flags)) {
+		condlog(0, "%s release: failed to resume dm device.", mpp->wwid);
+		/*
+		 * leave status set to MPATH_PR_SUCCESS, we will have another
+		 * chance to resume the device.
+		 */
+		goto out_reregister;
+	}
+	did_resume = true;
+
+out_reregister:
+	memset(paramp, 0, sizeof(*paramp));
+	memcpy(paramp->sa_key, &mpp->reservation_key, 8);
+	rc = mpath_prout_reg(mpp, MPATH_PROUT_REG_IGN_SA, rq_scope, rq_type,
+			     paramp, noisy);
+	if (rc != MPATH_PR_SUCCESS)
+		condlog(0, "%s: release: failed to reregister paths.", mpp->wwid);
+
+	/*
+	 * If we failed releasing the reservation or resuming earlier
+	 * try resuming now. Otherwise, return with the reregistering status
+	 * This means we will report failure, even though the resevation
+	 * has been released, since the keys were not reregistered.
+	 */
+	if (did_resume)
+		return rc;
+	else if (status == MPATH_PR_SUCCESS)
+		status = rc;
+fail_resume:
+	if (!dm_simplecmd_noflush(DM_DEVICE_RESUME, mpp->alias, udev_flags)) {
+		condlog(0, "%s: release: failed to resume dm device.", mpp->wwid);
+		if (status == MPATH_PR_SUCCESS)
+			status = MPATH_PR_OTHER;
 	}
-
-out2:
-	free(pptr);
-out1:
-	free (pamp);
-out:
-	free (pr_buff);
 	return (status == MPATH_PR_RETRYABLE_ERROR) ? MPATH_PR_OTHER : status;
 }
 
@@ -620,6 +595,7 @@ int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
 	mpp->mpe = find_mpe(conf->mptable, mpp->wwid);
 	select_reservation_key(conf, mpp);
 	select_all_tg_pt(conf, mpp);
+	select_skip_kpartx(conf, mpp);
 	put_multipath_config(conf);
 
 	memcpy(&prkey, paramp->sa_key, 8);
@@ -661,7 +637,8 @@ int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
 	case MPATH_PROUT_PREE_SA :
 	case MPATH_PROUT_PREE_AB_SA :
 	case MPATH_PROUT_CLEAR_SA:
-		ret = mpath_prout_common(mpp, rq_servact, rq_scope, rq_type, paramp, noisy);
+		ret = mpath_prout_common(mpp, rq_servact, rq_scope, rq_type,
+					 paramp, noisy, NULL);
 		break;
 	case MPATH_PROUT_REL_SA:
 		ret = mpath_prout_rel(mpp, rq_servact, rq_scope, rq_type, paramp, noisy);
diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index a6718355..2f47b3ad 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -249,4 +249,5 @@ local:
 LIBMULTIPATH_29.1.0 {
 global:
 	can_recheck_wwid;
+	select_skip_kpartx;
 } LIBMULTIPATH_29.0.0;
-- 
2.48.1

