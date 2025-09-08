Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90E2313263
	for <dm-devel@lists.linux.dev>; Tue,  9 Sep 2025 00:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757376019; cv=none; b=JJiR92Ou8GNaQ+w5TnQ0o+XI0J61VbKxCrxByQ9JFJPnjzzQ3hfoVi0RJ7RuAZnQprxztqSjWCEOQDZjfpSEKcOonAlXwvpKeiOl1FSpDYEfJnyYGinPAh4HQ7aNWtDGKserKUjPEVzrVBs5/dJXr6E4QxIjr8TxWlZ+EkyOmlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757376019; c=relaxed/simple;
	bh=msn9QBcQB0aYItZ4Uo1II/iAi1abie4VUB1N+3iMMBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=RJ49f5mCAZ+6MN3ACyVfTf2iB3ZdIo9V5JrqDg/kczvcw9dkjE/I6zjmfiDCtuzifzaCB6ReuZjrRAJGbX39Jg+Jz+R9gjWttfFKwNtKnDMTzFXvY4ehwvnVrELVJssZwPW+NnWsDNiyJ7awKjFdxWc9+nsqNzpO1Oru/J1d0Xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e5brosOf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e5brosOf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757376014;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h/7jAf13Uv5M5Q4wieP9JfEnWkvbH3kjIle0/K1SoRs=;
	b=e5brosOfcIpgJYVfboe6c5ZnWtzX0Ov+IEQiv0v2gzuBmoyxA0cq/5H6zDR107KDKPYuzj
	ku4kRjMiizS7IGPkVgSsY7Ol75at2LEJhEsc8/3ZCsqlWGqza6tAHse0J4XeT1A6oDNMG5
	GQylvjCzdNKjdbL0bbrSkEyBfSH6wu8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-442-8iKRC22cPDi0oGffl25S0Q-1; Mon,
 08 Sep 2025 20:00:07 -0400
X-MC-Unique: 8iKRC22cPDi0oGffl25S0Q-1
X-Mimecast-MFC-AGG-ID: 8iKRC22cPDi0oGffl25S0Q_1757376006
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7396B1800562;
	Tue,  9 Sep 2025 00:00:06 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 31F673000709;
	Tue,  9 Sep 2025 00:00:06 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 589004kq751116
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 8 Sep 2025 20:00:05 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 5890049X751115;
	Mon, 8 Sep 2025 20:00:04 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 09/32] libmpathpersist: redesign failed release workaround
Date: Mon,  8 Sep 2025 19:59:39 -0400
Message-ID: <20250909000002.751039-10-bmarzins@redhat.com>
In-Reply-To: <20250909000002.751039-1-bmarzins@redhat.com>
References: <20250909000002.751039-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: hAQyRsyh8wY0gwh7dLNuaK2h0Tx9-sjy6eSXiTeq2FA_1757376006
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
 libmpathpersist/mpath_persist_int.c | 182 +++++++++++++---------------
 libmultipath/libmultipath.version   |   1 +
 2 files changed, 83 insertions(+), 100 deletions(-)

diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index 36eb6f35..8ade2e13 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -363,9 +363,10 @@ static int mpath_prout_reg(struct multipath *mpp,int rq_servact, int rq_scope,
 	return (status == MPATH_PR_RETRYABLE_ERROR) ? MPATH_PR_OTHER : status;
 }
 
-static int mpath_prout_common(struct multipath *mpp,int rq_servact, int rq_scope,
-			      unsigned int rq_type,
-			      struct prout_param_descriptor* paramp, int noisy)
+static int
+mpath_prout_common(struct multipath *mpp, int rq_servact, int rq_scope,
+		   unsigned int rq_type, struct prout_param_descriptor *paramp,
+		   int noisy, struct path **pptr)
 {
 	int i,j, ret;
 	struct pathgroup *pgp = NULL;
@@ -384,6 +385,8 @@ static int mpath_prout_common(struct multipath *mpp,int rq_servact, int rq_scope
 			found = true;
 			ret = prout_do_scsi_ioctl(pp->dev, rq_servact, rq_scope,
 						  rq_type, paramp, noisy);
+			if (ret == MPATH_PR_SUCCESS && pptr)
+				*pptr = pp;
 			if (ret != MPATH_PR_RETRYABLE_ERROR)
 				return ret;
 		}
@@ -404,14 +407,12 @@ static int mpath_prout_rel(struct multipath *mpp,int rq_servact, int rq_scope,
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
+	struct prin_resp resp = {{{.prgeneration = 0}}};
+	uint16_t udev_flags = (mpp->skip_kpartx) ? MPATH_UDEV_NO_KPARTX_FLAG : 0;
+	bool did_resume = false;
 
 	if (!mpp)
 		return MPATH_PR_DMMP_ERROR;
@@ -501,104 +502,78 @@ static int mpath_prout_rel(struct multipath *mpp,int rq_servact, int rq_scope,
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
+	status = mpath_prout_common(mpp, MPATH_PROUT_PREE_SA, rq_scope,
+				    rq_type, paramp, noisy, &pp);
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
 
@@ -619,6 +594,12 @@ int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
 	mpp->mpe = find_mpe(conf->mptable, mpp->wwid);
 	select_reservation_key(conf, mpp);
 	select_all_tg_pt(conf, mpp);
+	/*
+	 * If a device preempts itself, it will need to suspend and resume.
+	 * Set mpp->skip_kpartx to make sure we set the flags to skip kpartx
+	 * if necessary, when doing this.
+	 */
+	select_skip_kpartx(conf, mpp);
 	put_multipath_config(conf);
 
 	memcpy(&prkey, paramp->sa_key, 8);
@@ -660,7 +641,8 @@ int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
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
2.50.1

