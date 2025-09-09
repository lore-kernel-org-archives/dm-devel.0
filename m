Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E4631B117
	for <dm-devel@lists.linux.dev>; Tue,  9 Sep 2025 00:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757376017; cv=none; b=dMRvtnt91Tw7kHiQsFGyJAwvezwiAKd4sZWHzy8UDcV3jZI09sAgR7BL0i2v+csjkS3003r3fPmGDlAoOfOZ+DO2tzVsm4yig6P4Q9+TIA6cvvEeAWO2PTIiM8+thyg34mHIQK1ux5BxAc/KbCemCRcFrFKA3JMSZ7TuAfGuWVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757376017; c=relaxed/simple;
	bh=z6RVPTP/Bfbq4DBdkpSbV+87n09I48M9ctIvbYTfc9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=IP75XkvynN4QOB3AKekvYly1x20kwwo4B1vTE4KzQIJuC5hZxjVXCPzbhSa40VOgkQeU18MEbDdifjpS1inFA8gRzI1XixEUP3rYpr77Cc96jiflP/U5uxCqY5g0z+3sOOg3nBCICOxbDYstUxsWnHJtDg7Lq0dyjlrJsScr+6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fxZhvI4j; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fxZhvI4j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757376014;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Bw7VRPvpw1wYLJt3pxeUnsda4AIk1EtAO7V2LYQCeQU=;
	b=fxZhvI4j+h/tucH9oqF63Zh8gJTfBeaO885uTATO2IV1YEFZFIu9YePnz3c9YHrgeaQnqh
	HsIMUTKXkD8C5vSNzulFsTouNFF/S1PQs/hMFun6aHbff4mZ3fPxTR4SzaT6LxOh5XhWWQ
	H6/SEzVSvpveb52hAfV0YTaxhWc7AsI=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-616-_7i3HAczP0COJaEleIJSrw-1; Mon,
 08 Sep 2025 20:00:10 -0400
X-MC-Unique: _7i3HAczP0COJaEleIJSrw-1
X-Mimecast-MFC-AGG-ID: _7i3HAczP0COJaEleIJSrw_1757376010
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F1DC0195608F;
	Tue,  9 Sep 2025 00:00:09 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B30193000198;
	Tue,  9 Sep 2025 00:00:09 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 5890081S751211
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 8 Sep 2025 20:00:08 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 5890084g751210;
	Mon, 8 Sep 2025 20:00:08 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 32/32] libmpathpersist: reregister keys when self preempting
Date: Mon,  8 Sep 2025 20:00:02 -0400
Message-ID: <20250909000002.751039-33-bmarzins@redhat.com>
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
X-Mimecast-MFC-PROC-ID: 8HN9vDbwvgpTrGnc2GPWnt2CNCCFnE74HBjDrQlfp-U_1757376010
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

When a SCSI device preempts its own reservation key, it will remove the
registered keys from all other devices with that reservation key, but
retain its registered key (and possibly acquire the reservation). If a
multipath device preempts its own reservation key, it will also remove
the registered keys from all its paths except the one issuing the
reservation. This means that IO to the device can fail if it goes to one
of these unregistered paths.

To avoid this, whenever a multipath device preempts itself, it must
first suspend, then do the preemption and reregister the removed keys,
and finally resume the device. This is already what libmpathpersist does
if a release fails because the path holding the reservation is currently
unavailable, with the addition of releasing the reservation after
preempting it. This commit refactors that code into a separate function,
makes the release optional, and calls the new function, preempt_self(),
whenever a device preempts itself.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathpersist/mpath_persist_int.c | 133 ++++++++++++++--------------
 1 file changed, 68 insertions(+), 65 deletions(-)

diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index 595e073a..9f301859 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -560,6 +560,65 @@ static int mpath_prout_reg(struct multipath *mpp,int rq_servact, int rq_scope,
 	return status;
 }
 
+/*
+ * Called to make a multipath device preempt its own reservation (and
+ * optionally release the reservation). Doing this causes the reservation
+ * keys to be removed from all the device paths except that path used to issue
+ * the preempt, so they need to be restored. To avoid the chance that IO
+ * goes to these paths when they don't have a registered key, the device
+ * is suspended before issuing the preemption, and the keys are reregistered
+ * before resuming it.
+ */
+static int preempt_self(struct multipath *mpp, int rq_servact, int rq_scope,
+			unsigned int rq_type, int noisy, bool do_release)
+{
+	int status, rel_status = MPATH_PR_SUCCESS;
+	struct path *pp = NULL;
+	struct prout_param_descriptor paramp = {.sa_flags = 0};
+	uint16_t udev_flags = (mpp->skip_kpartx) ? MPATH_UDEV_NO_KPARTX_FLAG : 0;
+
+	if (!dm_simplecmd_noflush(DM_DEVICE_SUSPEND, mpp->alias, 0)) {
+		condlog(0, "%s: self preempt failed to suspend device.", mpp->wwid);
+		return MPATH_PR_OTHER;
+	}
+
+	memcpy(paramp.key, &mpp->reservation_key, 8);
+	memcpy(paramp.sa_key, &mpp->reservation_key, 8);
+	status = mpath_prout_common(mpp, rq_servact, rq_scope, rq_type,
+				    &paramp, noisy, &pp);
+	if (status != MPATH_PR_SUCCESS) {
+		condlog(0, "%s: self preempt command failed.", mpp->wwid);
+		goto fail_resume;
+	}
+
+	if (do_release) {
+		memset(&paramp, 0, sizeof(paramp));
+		memcpy(paramp.key, &mpp->reservation_key, 8);
+		rel_status = prout_do_scsi_ioctl(pp->dev, MPATH_PROUT_REL_SA,
+						 rq_scope, rq_type, &paramp, noisy);
+		if (rel_status != MPATH_PR_SUCCESS)
+			condlog(0, "%s: release on alternate path failed.",
+				mpp->wwid);
+	}
+
+	memset(&paramp, 0, sizeof(paramp));
+	memcpy(paramp.sa_key, &mpp->reservation_key, 8);
+	status = mpath_prout_reg(mpp, MPATH_PROUT_REG_IGN_SA, rq_scope,
+				 rq_type, &paramp, noisy);
+	if (status != MPATH_PR_SUCCESS)
+		condlog(0, "%s: self preempt failed to reregister paths.",
+			mpp->wwid);
+
+fail_resume:
+	if (!dm_simplecmd_noflush(DM_DEVICE_RESUME, mpp->alias, udev_flags)) {
+		condlog(0, "%s: self preempt failed to resume device.", mpp->wwid);
+		if (status == MPATH_PR_SUCCESS)
+			status = MPATH_PR_OTHER;
+	}
+	/* return the first error we encountered */
+	return (rel_status != MPATH_PR_SUCCESS) ? rel_status : status;
+}
+
 static int mpath_prout_rel(struct multipath *mpp,int rq_servact, int rq_scope,
 			   unsigned int rq_type,
 			   struct prout_param_descriptor * paramp, int noisy)
@@ -574,8 +633,6 @@ static int mpath_prout_rel(struct multipath *mpp,int rq_servact, int rq_scope,
 	int count = 0;
 	int status = MPATH_PR_SUCCESS;
 	struct prin_resp resp = {{{.prgeneration = 0}}};
-	uint16_t udev_flags = (mpp->skip_kpartx) ? MPATH_UDEV_NO_KPARTX_FLAG : 0;
-	bool did_resume = false;
 	bool all_threads_failed;
 	unsigned int scope_type;
 
@@ -690,70 +747,10 @@ static int mpath_prout_rel(struct multipath *mpp,int rq_servact, int rq_scope,
 	 *    preempting one. Since the device is suspended, no IO can
 	 *    go to these unregistered paths and fail).
 	 * 3. Releasing the reservation on the path that now holds it.
-	 * 4. Resuming the device (since it no longer matters that most of
-	 *    that paths no longer have a registered key)
-	 * 5. Reregistering keys on all the paths
+	 * 4. Reregistering keys on all the paths
+	 * 5. Resuming the device
 	 */
-
-	if (!dm_simplecmd_noflush(DM_DEVICE_SUSPEND, mpp->alias, 0)) {
-		condlog(0, "%s: release: failed to suspend dm device.", mpp->wwid);
-		return MPATH_PR_OTHER;
-	}
-
-	memset(paramp, 0, sizeof(*paramp));
-	memcpy(paramp->key, &mpp->reservation_key, 8);
-	memcpy(paramp->sa_key, &mpp->reservation_key, 8);
-	status = mpath_prout_common(mpp, MPATH_PROUT_PREE_SA, rq_scope,
-				    rq_type, paramp, noisy, &pp);
-	if (status != MPATH_PR_SUCCESS) {
-		condlog(0, "%s: release: pr preempt command failed.", mpp->wwid);
-		goto fail_resume;
-	}
-
-	memset(paramp, 0, sizeof(*paramp));
-	memcpy(paramp->key, &mpp->reservation_key, 8);
-	status = prout_do_scsi_ioctl(pp->dev, MPATH_PROUT_REL_SA, rq_scope,
-				     rq_type, paramp, noisy);
-	if (status != MPATH_PR_SUCCESS) {
-		condlog(0, "%s: release on alternate path failed.", mpp->wwid);
-		goto out_reregister;
-	}
-
-	if (!dm_simplecmd_noflush(DM_DEVICE_RESUME, mpp->alias, udev_flags)) {
-		condlog(0, "%s release: failed to resume dm device.", mpp->wwid);
-		/*
-		 * leave status set to MPATH_PR_SUCCESS, we will have another
-		 * chance to resume the device.
-		 */
-		goto out_reregister;
-	}
-	did_resume = true;
-
-out_reregister:
-	memset(paramp, 0, sizeof(*paramp));
-	memcpy(paramp->sa_key, &mpp->reservation_key, 8);
-	rc = mpath_prout_reg(mpp, MPATH_PROUT_REG_IGN_SA, rq_scope, rq_type,
-			     paramp, noisy);
-	if (rc != MPATH_PR_SUCCESS)
-		condlog(0, "%s: release: failed to reregister paths.", mpp->wwid);
-
-	/*
-	 * If we failed releasing the reservation or resuming earlier
-	 * try resuming now. Otherwise, return with the reregistering status
-	 * This means we will report failure, even though the resevation
-	 * has been released, since the keys were not reregistered.
-	 */
-	if (did_resume)
-		return rc;
-	else if (status == MPATH_PR_SUCCESS)
-		status = rc;
-fail_resume:
-	if (!dm_simplecmd_noflush(DM_DEVICE_RESUME, mpp->alias, udev_flags)) {
-		condlog(0, "%s: release: failed to resume dm device.", mpp->wwid);
-		if (status == MPATH_PR_SUCCESS)
-			status = MPATH_PR_OTHER;
-	}
-	return (status == MPATH_PR_RETRYABLE_ERROR) ? MPATH_PR_OTHER : status;
+	return preempt_self(mpp, MPATH_PROUT_PREE_SA, rq_scope, rq_type, noisy, true);
 }
 
 static int reservation_key_matches(struct multipath *mpp, uint8_t *key, int noisy)
@@ -894,6 +891,12 @@ int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
 	case MPATH_PROUT_PREE_AB_SA:
 		if (reservation_key_matches(mpp, paramp->sa_key, noisy) == YNU_YES)
 			preempting_reservation = true;
+		/* if we are preempting ourself */
+		if (memcmp(paramp->sa_key, paramp->key, 8) == 0) {
+			ret = preempt_self(mpp, rq_servact, rq_scope, rq_type,
+					   noisy, false);
+			break;
+		}
 		/* fallthrough */
 	case MPATH_PROUT_RES_SA:
 	case MPATH_PROUT_CLEAR_SA:
-- 
2.50.1

