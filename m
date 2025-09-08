Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A00B676
	for <dm-devel@lists.linux.dev>; Tue,  9 Sep 2025 00:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757376018; cv=none; b=WKkr5RqjDT+9Z6XRQopnMxEb6TTpSy7aB/TyUxu/IglyGiTR3Uga0pcjaCeFanHp9009/kXVZoS0NHgrxV4QRXiOoeT2sHOlwgijGwwQsYdgeOoTEtIgMZompDs+UiTv2aLH24pGeC+oCAd6OxF3gdJC79ToKbch9K2r772Ts78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757376018; c=relaxed/simple;
	bh=24vdR+YFMUOTgxyBoSvlsBPjqa6+NEBiBhfeTKec2Q8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=seefoMqUuMehqeeLxR+aGafLZe4eFsHBe+iNeLPMgNWMNicljEQcCV/oCVi4j/FjaTpKBE+z1bKjW/cVTrTzC6p7A0OS64Ogif4xNBzIXkbQQWK7hmjtl+egcXhBCLTNjJrEhD0+oaXJLV0pGv61qw2811Z3pOTkYodWMSXhCr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZEtc2mJg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZEtc2mJg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757376015;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LA8g1ZPMB4uHwJGg1TbiqLRiRMrTskB8wy/cQBljCig=;
	b=ZEtc2mJgvXtlfcTr5VlkNtphL5I0XClU80kj+/qZLKaIyzkqHVTlEAGojJBwGtapE2qoLW
	sUBPmF6FbgOwlsZH8AtSyikjIylPI9xZs9pD3bPXLt6w5XFgbnznhlgeDmN7vNUKJKMvrT
	CFDh4H++n8qR0vj42oEFDLQiKpl/BZ4=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-102-EpeLyTwwO2GgGuuIDUdpjg-1; Mon,
 08 Sep 2025 20:00:11 -0400
X-MC-Unique: EpeLyTwwO2GgGuuIDUdpjg-1
X-Mimecast-MFC-AGG-ID: EpeLyTwwO2GgGuuIDUdpjg_1757376008
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8A1511800289;
	Tue,  9 Sep 2025 00:00:08 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4ABA81800446;
	Tue,  9 Sep 2025 00:00:08 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 589007qs751175
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 8 Sep 2025 20:00:07 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 5890074H751174;
	Mon, 8 Sep 2025 20:00:07 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 23/32] libmpathpersist: change how reservation conflicts are handled
Date: Mon,  8 Sep 2025 19:59:53 -0400
Message-ID: <20250909000002.751039-24-bmarzins@redhat.com>
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
X-Mimecast-MFC-PROC-ID: Ctgt8-jaMqpiKR8e1s7jTMRSqb4oNIKMqJ0qSG-lz8c_1757376008
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

If registering a key on a path fails with a reservation conflict in
mpath_prout_reg(), libmpathpersist currently tries to roll back the
registration. This code doesn't always make much sense. First, it
updates the configured key, but doesn't fix it if it does a rollback.
Second, it always rolls the key back to 0x0, unregistering paths that
may have been previously registered. These rollback only happen on the
paths where the registration succeeded, meaning that they were in the
expected state when the command was run. The paths where the command
failed, that were in an unexpected state, remain in that state.

The code no longer attempts to rollback registrations that failed
with a reservation conflict. Instead, it checks that at least one
path was in the expected state and was successfully registered. If
so, then it assumes that the registration command was a resonable one
and retries it on the paths that failed with a reservation conflict.
But instead of using MPATH_PROUT_REG_SA, it uses MPATH_PROUT_REG_IGN_SA
so that it will ignore the current key. This will keep it from
failing with a reservation conflict because the path doesn't have the
expected key registered on it. If path reservations failed for reasons
other than a reservation conflict, the command still returns failure.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 libmpathpersist/mpath_persist_int.c | 71 ++++++++++++++++++-----------
 1 file changed, 45 insertions(+), 26 deletions(-)

diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index db9b99be..eef31174 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -346,13 +346,13 @@ static int mpath_prout_reg(struct multipath *mpp,int rq_servact, int rq_scope,
 	int i, j, k;
 	struct pathgroup *pgp = NULL;
 	struct path *pp = NULL;
-	int rollback = 0;
+	bool can_retry = false;
+	bool need_retry = false;
 	int active_pathcount=0;
 	int rc;
 	int count=0;
 	int status = MPATH_PR_SUCCESS;
 	int all_tg_pt;
-	uint64_t sa_key = 0;
 
 	if (!mpp)
 		return MPATH_PR_DMMP_ERROR;
@@ -441,43 +441,62 @@ static int mpath_prout_reg(struct multipath *mpp,int rq_servact, int rq_scope,
 				condlog (0, "%s: Thread[%d] failed to join thread %d", mpp->wwid, i, rc);
 			}
 		}
-		if (!rollback && (thread[i].param.status == MPATH_PR_RESERV_CONFLICT)){
-			rollback = 1;
-			sa_key = get_unaligned_be64(&paramp->sa_key[0]);
-			status = MPATH_PR_RESERV_CONFLICT ;
-		}
-		if (!rollback && (status == MPATH_PR_SUCCESS)){
+		/*
+		 * We only retry if there is at least one registration that
+		 * returned a reservation conflict (which we need to retry)
+		 * and at least one registration the return success, so we
+		 * know that the command worked on some of the paths. If
+		 * the registation fails on all paths, then it wasn't a
+		 * valid request, so there's no need to retry.
+		 */
+		if (thread[i].param.status == MPATH_PR_RESERV_CONFLICT)
+			need_retry = true;
+		else if (thread[i].param.status == MPATH_PR_SUCCESS)
+			can_retry = true;
+		else if (status == MPATH_PR_SUCCESS)
 			status = thread[i].param.status;
-		}
 	}
-	if (rollback && ((rq_servact == MPATH_PROUT_REG_SA) && sa_key != 0 )){
-		condlog (3, "%s: ERROR: initiating pr out rollback", mpp->wwid);
-		memcpy(&paramp->key, &paramp->sa_key, 8);
-		memset(&paramp->sa_key, 0, 8);
-		for( i=0 ; i < count ; i++){
-			if(thread[i].param.status == MPATH_PR_SUCCESS) {
-				rc = pthread_create(&thread[i].id, &attr, mpath_prout_pthread_fn,
-						(void *)(&thread[i].param));
-				if (rc){
-					condlog (0, "%s: failed to create thread for rollback. %d",  mpp->wwid, rc);
-					thread[i].param.status = MPATH_PR_THREAD_ERROR;
-				}
-			} else
+	if (need_retry && can_retry && rq_servact == MPATH_PROUT_REG_SA &&
+	    status == MPATH_PR_SUCCESS) {
+		condlog(3, "%s: ERROR: initiating pr out retry", mpp->wwid);
+		for (i = 0; i < count; i++) {
+			if (thread[i].param.status != MPATH_PR_RESERV_CONFLICT) {
 				thread[i].param.status = MPATH_PR_SKIP;
+				continue;
+			}
+			/*
+			 * retry using MPATH_PROUT_REG_IGN_SA to avoid
+			 * conflicts. We already know that some paths
+			 * succeeded using MPATH_PROUT_REG_SA.
+			 */
+			thread[i].param.rq_servact = MPATH_PROUT_REG_IGN_SA;
+			rc = pthread_create(&thread[i].id, &attr,
+					    mpath_prout_pthread_fn,
+					    (void *)(&thread[i].param));
+			if (rc) {
+				condlog(0, "%s: failed to create thread for retry. %d",
+					mpp->wwid, rc);
+				thread[i].param.status = MPATH_PR_THREAD_ERROR;
+			}
 		}
-		for(i=0; i < count ; i++){
+		for (i = 0; i < count; i++) {
 			if (thread[i].param.status != MPATH_PR_SKIP &&
 			    thread[i].param.status != MPATH_PR_THREAD_ERROR) {
 				rc = pthread_join(thread[i].id, NULL);
-				if (rc){
-					condlog (3, "%s: failed to join thread while rolling back %d",
-						 mpp->wwid, i);
+				if (rc) {
+					condlog(3, "%s: failed to join thread while retrying %d",
+						mpp->wwid, i);
 				}
+				if (status == MPATH_PR_SUCCESS)
+					status = thread[i].param.status;
 			}
 		}
+		need_retry = false;
 	}
 
 	pthread_attr_destroy(&attr);
+	if (need_retry)
+		status = MPATH_PR_RESERV_CONFLICT;
 	if (status == MPATH_PR_SUCCESS)
 		preempt_missing_path(mpp, paramp->key, paramp->sa_key, noisy);
 	return (status == MPATH_PR_RETRYABLE_ERROR) ? MPATH_PR_OTHER : status;
-- 
2.50.1

