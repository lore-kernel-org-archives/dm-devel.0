Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10B5E1F5842
	for <dm-devel@lists.linux.dev>; Sat, 26 Jul 2025 03:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753502348; cv=none; b=PZxVenVCxyXil0TWQNjAdH08fC66aehIedqhLrZs+3JwYTZ0PnjpZIaMeNrhQmnBAoE0VdHCAQFn82pFgk2wBABBhYdLc58U14xodks+ebIgfcE87PzW/GhjNSGSypA87TdGrMsSAAyq1zaBKZ5p/lqhL18S7WiRJ4+C3O+qwLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753502348; c=relaxed/simple;
	bh=aTryiAziBcI2qvH11O3xNYhnX6L6xK2zim4e8EhOz3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=jYXZraTGD+i4EHiBcR5LOSLotcSCvTPHMUqPETC5SLG1lRY1pNQ77y/QxZr0sccbw0j+JvtlG1AYrF+20tTPra0S2keFuXRbf9XSzOZ05imjA1BNQ5ZUP2pgNOh6KqErHmBAQZwrwmqZedNZYrtRwKlhdS8QsU7wMoSjIBONGbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=i0t1bQrO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i0t1bQrO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753502346;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3Ac6MVsB5pWv8peS0TK8Y54DFzum/R0/VtPdEOW4BKw=;
	b=i0t1bQrOP9WmopL0zG4pKIF6QYRyyJVntbdjaGlh/OQUzTDSTwyrU2UfR1i0FUfqc/5CC2
	0AB65LwLmQVCK4JH3anquRZBk5Ri9R6ZzcgVORB7KBdd0Ij/Fj2mU4XIh2I/tQa6u5fWpG
	XhHp2+WGoRtzG6tKqNIpT7ClnWEiB64=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-350-qkXWxz-tOXmBA4OA1T6deQ-1; Fri,
 25 Jul 2025 23:59:01 -0400
X-MC-Unique: qkXWxz-tOXmBA4OA1T6deQ-1
X-Mimecast-MFC-AGG-ID: qkXWxz-tOXmBA4OA1T6deQ_1753502340
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 496D018007E1;
	Sat, 26 Jul 2025 03:59:00 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 170B71800D8A;
	Sat, 26 Jul 2025 03:59:00 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 56Q3wwlE363369
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 25 Jul 2025 23:58:59 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 56Q3wwMa363368;
	Fri, 25 Jul 2025 23:58:58 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 14/14] libmpathpersist: Don't always fail registrations for retryable errors
Date: Fri, 25 Jul 2025 23:58:55 -0400
Message-ID: <20250726035855.363290-15-bmarzins@redhat.com>
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
X-Mimecast-MFC-PROC-ID: ah3u95EcRl8umKqK_rmWXi5YA351fvboK49u4EGbw-8_1753502340
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
---
 libmpathpersist/mpath_persist_int.c | 70 ++++++++++++++++++++++++++---
 1 file changed, 63 insertions(+), 7 deletions(-)

diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index d3c1a789..d5e441ef 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -325,6 +325,48 @@ void preempt_missing_path(struct multipath *mpp, uint8_t *key, uint8_t *sa_key,
 			mpp->wwid);
 }
 
+/*
+ * If libmpathpersist fails at updating the key on a path with a retryable
+ * error, it has probably failed. But there is a chance that the path is
+ * still usable. To make sure a path isn't active without a key, when it
+ * should have one, or with a key, when it shouldn't have one, check if
+ * the path is still usable. If it is, we must fail the registration.
+ */
+static int check_failed_paths(struct multipath *mpp,
+			      struct threadinfo *thread, int count)
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
+match:
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
@@ -333,8 +375,9 @@ static int mpath_prout_reg(struct multipath *mpp,int rq_servact, int rq_scope,
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
@@ -438,16 +481,20 @@ static int mpath_prout_reg(struct multipath *mpp,int rq_servact, int rq_scope,
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
+			if (thread[i].param.status != MPATH_PR_RESERV_CONFLICT && thread[i].param.status != MPATH_PR_RETRYABLE_ERROR) {
 				thread[i].param.status = MPATH_PR_SKIP;
 				continue;
 			}
@@ -474,7 +521,9 @@ static int mpath_prout_reg(struct multipath *mpp,int rq_servact, int rq_scope,
 					condlog(3, "%s: failed to join thread while retrying %d",
 						mpp->wwid, i);
 				}
-				if (status == MPATH_PR_SUCCESS)
+				if (thread[i].param.status == MPATH_PR_RETRYABLE_ERROR)
+					retryable_error = true;
+				else if (status == MPATH_PR_SUCCESS)
 					status = thread[i].param.status;
 			}
 		}
@@ -483,10 +532,17 @@ static int mpath_prout_reg(struct multipath *mpp,int rq_servact, int rq_scope,
 
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
2.48.1

