Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2165E313263
	for <dm-devel@lists.linux.dev>; Tue,  9 Sep 2025 00:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757376015; cv=none; b=MvhQMcJgk01QbsiIQXmIOr+Vu90d5xjkPu1nR7BDtcN+LkHMcpSAUphyaph5lnFesqKqFI/We4yz+9mxTF8PIgOZCv/GXM4G0LcUQauZxUIIog6oTzFsiaM3FXuThg1XLYtBHyLkqitnuEphOZ+Y+r/7bYSFfcTDAA/dZebFZ3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757376015; c=relaxed/simple;
	bh=6jlLMxsaF5kmKOS3Q7fr7Kc85/rzl3YazcSXGRk0h7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=A28ey8F6DHXRUq9V5PRdyuddAsh7LArVTcpjAUrv8Vz5x+/X2smytRVBE5a1Tj4N1Ca+E+5+PnYwfZlluFkG0ZwuArPPW9o3/e4uZe9dZj6hN0ugHJXn48HI/HZ4QGDtT3jI2uM2aoyHXPtOOjiCEt8XSgRVJ75A5WYAWaC3Wek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IP6y0gLz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IP6y0gLz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757376012;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cCsFQyv5XKM/bFItepHJy+oPzUBLxvZea8hmNjQjSxk=;
	b=IP6y0gLzpQLnguAcAEhg9Fqf5Jyzouy2/Z7+K4FlEk2jPiPhBsMZ4C3pjF2a7ocVCL1+Tt
	bKIVn7vPMHmeEbkv0BMhRkI6lNPqTnVFXNBiTUH+M9816klauQCSrtgpmFQPNix/3rzTsO
	xnKkWuC6+G87wAEC2B2N8c+bNTDsVh8=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-608-k0bThCx1MxGTC0R-53wJ2Q-1; Mon,
 08 Sep 2025 20:00:10 -0400
X-MC-Unique: k0bThCx1MxGTC0R-53wJ2Q-1
X-Mimecast-MFC-AGG-ID: k0bThCx1MxGTC0R-53wJ2Q_1757376009
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 872CF19560AF;
	Tue,  9 Sep 2025 00:00:09 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 479AB3000198;
	Tue,  9 Sep 2025 00:00:09 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 589007aG751199
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 8 Sep 2025 20:00:08 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 589007pp751198;
	Mon, 8 Sep 2025 20:00:07 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 29/32] libmpathpersist: Don't always fail registrations for retryable errors
Date: Mon,  8 Sep 2025 19:59:59 -0400
Message-ID: <20250909000002.751039-30-bmarzins@redhat.com>
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
X-Mimecast-MFC-PROC-ID: v2BHup39zei9MtxG0jSYdmf4OYEMg7WStDTNJuXpt7o_1757376009
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

When libmpathpersist registers a key, it's possible that a path fails
between when it checks the path's status, and when it tries to do the
registrations on the path. In this case, the registration will fail with
a retryable error. If the registration was allowed to succeed,
multipathd would update the now failed path's key when it came back
online, and everything would work correctly. However it is possible for
a registration to fail with a retryable error on a path that is still
usable.

Libmpathpersist needs to avoid the case where it does not update the
key of a usable path. Otherwise the path might be able to write to
storage it shouldn't be allowed to. Or it could fail writing to storage
that it should be allowed to write to. So if a registration would
succeed except for retryable errors, libmpathpersist now rechecks all
those paths to see if they are still usable. If they are, then it fails
the registration as before. If they are not, then the registration
succeeds.

Also, rename can_retry to had_success, since it is used for checking
more than retries now.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 libmpathpersist/mpath_persist_int.c | 72 ++++++++++++++++++++++++++---
 1 file changed, 65 insertions(+), 7 deletions(-)

diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index f7a75889..979b0d6c 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -327,6 +327,48 @@ void preempt_missing_path(struct multipath *mpp, uint8_t *key, uint8_t *sa_key,
 		condlog(0, "%s: register: pr preempt command failed.", mpp->wwid);
 }
 
+/*
+ * If libmpathpersist fails at updating the key on a path with a retryable
+ * error, it has probably failed. But there is a chance that the path is
+ * still usable. To make sure a path isn't active without a key, when it
+ * should have one, or with a key, when it shouldn't have one, check if
+ * the path is still usable. If it is, we must fail the registration.
+ */
+static int
+check_failed_paths(struct multipath *mpp, struct threadinfo *thread, int count)
+{
+	int i, j, k;
+	int ret;
+	struct pathgroup *pgp;
+	struct path *pp;
+	struct config *conf;
+
+	for (i = 0; i < count; i++) {
+		if (thread[i].param.status != MPATH_PR_RETRYABLE_ERROR)
+			continue;
+		vector_foreach_slot (mpp->pg, pgp, j) {
+			vector_foreach_slot (pgp->paths, pp, k) {
+				if (strncmp(pp->dev, thread[i].param.dev,
+					    FILE_NAME_SIZE) == 0)
+					goto match;
+			}
+		}
+		/* no match. This shouldn't ever happen. */
+		condlog(0, "%s: Error: can't find path %s", mpp->wwid,
+			thread[i].param.dev);
+		continue;
+	match:
+		conf = get_multipath_config();
+		ret = pathinfo(pp, conf, DI_CHECKER);
+		put_multipath_config(conf);
+		/* If pathinfo fails, or if the path is active, return error */
+		if (ret != PATHINFO_OK || pp->state == PATH_UP ||
+		    pp->state == PATH_GHOST)
+			return MPATH_PR_OTHER;
+	}
+	return MPATH_PR_SUCCESS;
+}
+
 static int mpath_prout_reg(struct multipath *mpp,int rq_servact, int rq_scope,
 			   unsigned int rq_type,
 			   struct prout_param_descriptor * paramp, int noisy)
@@ -335,8 +377,9 @@ static int mpath_prout_reg(struct multipath *mpp,int rq_servact, int rq_scope,
 	int i, j, k;
 	struct pathgroup *pgp = NULL;
 	struct path *pp = NULL;
-	bool can_retry = false;
+	bool had_success = false;
 	bool need_retry = false;
+	bool retryable_error = false;
 	int active_pathcount=0;
 	int rc;
 	int count=0;
@@ -440,16 +483,21 @@ static int mpath_prout_reg(struct multipath *mpp,int rq_servact, int rq_scope,
 		 */
 		if (thread[i].param.status == MPATH_PR_RESERV_CONFLICT)
 			need_retry = true;
+		else if (thread[i].param.status == MPATH_PR_RETRYABLE_ERROR)
+			retryable_error = true;
 		else if (thread[i].param.status == MPATH_PR_SUCCESS)
-			can_retry = true;
+			had_success = true;
 		else if (status == MPATH_PR_SUCCESS)
 			status = thread[i].param.status;
 	}
-	if (need_retry && can_retry && rq_servact == MPATH_PROUT_REG_SA &&
+	if (need_retry && had_success && rq_servact == MPATH_PROUT_REG_SA &&
 	    status == MPATH_PR_SUCCESS) {
 		condlog(3, "%s: ERROR: initiating pr out retry", mpp->wwid);
+		retryable_error = false;
 		for (i = 0; i < count; i++) {
-			if (thread[i].param.status != MPATH_PR_RESERV_CONFLICT) {
+			/* retry retryable errors and conflicts */
+			if (thread[i].param.status != MPATH_PR_RESERV_CONFLICT &&
+			    thread[i].param.status != MPATH_PR_RETRYABLE_ERROR) {
 				thread[i].param.status = MPATH_PR_SKIP;
 				continue;
 			}
@@ -476,7 +524,10 @@ static int mpath_prout_reg(struct multipath *mpp,int rq_servact, int rq_scope,
 					condlog(3, "%s: failed to join thread while retrying %d",
 						mpp->wwid, i);
 				}
-				if (status == MPATH_PR_SUCCESS)
+				if (thread[i].param.status ==
+				    MPATH_PR_RETRYABLE_ERROR)
+					retryable_error = true;
+				else if (status == MPATH_PR_SUCCESS)
 					status = thread[i].param.status;
 			}
 		}
@@ -485,10 +536,17 @@ static int mpath_prout_reg(struct multipath *mpp,int rq_servact, int rq_scope,
 
 	pthread_attr_destroy(&attr);
 	if (need_retry)
-		status = MPATH_PR_RESERV_CONFLICT;
+		return MPATH_PR_RESERV_CONFLICT;
+	if (status != MPATH_PR_SUCCESS)
+		return status;
+	/* If you had retryable errors on all paths, fail the registration */
+	if (!had_success)
+		return MPATH_PR_OTHER;
+	if (retryable_error)
+		status = check_failed_paths(mpp, thread, count);
 	if (status == MPATH_PR_SUCCESS)
 		preempt_missing_path(mpp, paramp->key, paramp->sa_key, noisy);
-	return (status == MPATH_PR_RETRYABLE_ERROR) ? MPATH_PR_OTHER : status;
+	return status;
 }
 
 static int mpath_prout_rel(struct multipath *mpp,int rq_servact, int rq_scope,
-- 
2.50.1

