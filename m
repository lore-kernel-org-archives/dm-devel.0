Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 416541397
	for <dm-devel@lists.linux.dev>; Fri, 26 Sep 2025 17:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758907742; cv=none; b=Vnjex/XNzAk7Q1+nxMc0WYqOeonpr/isoehF8V9+Q4g6yLMorVd78JHmwhlkyrUVrmmcMwOxxFCmTE4v3OdhFlH/FkT28Ieh9nUUcb3NqNj7kxP8Z/B6EunULWAHUWiyTcBi4MLcNzD3h4mdHytwM53Qf3fKOqLBBu+ZdJ2JjYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758907742; c=relaxed/simple;
	bh=H2mbf5+mxttwkz65sZIRK2BO615ABfQJ+loiASq4jZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=K9YaA1JnaEq0zr8FzQX6jmx4PtJQ4SgNYR+IkAeQzKAxwg9QGG/jCEcKmdqR9btJ3cCst50+Bcq4kO8L07UmBC6iSC4630q0jRyT9Qm+8ElYYXg4q32lvGGnHh2FDj2jAv6laiv971JPbAf6dOVZ8yzNPAcJnY3jM6hPij/KqIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E6WSxo2E; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E6WSxo2E"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758907739;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qAReKhdWPuhenGpd9uAgiaROZHOaL/ySj2jy949VSpw=;
	b=E6WSxo2EQ33dSDelg0RdejRznnFoaMZiFq2GHFMeJbsPcpCOTl1OXrzIFo44eHAA+CMfEB
	bVUJKO04Ye6j5aAsVx1BCXP1EU1v6ONY67spzuL1TAUoXu5Ew7CzAFEwh8YyRQsfhONJIT
	lf8b1PTYmkveGXpqArPYVvVRZrDJCuI=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-5-vb3hGyt_MyGs9Zzj8haLHg-1; Fri,
 26 Sep 2025 13:28:57 -0400
X-MC-Unique: vb3hGyt_MyGs9Zzj8haLHg-1
X-Mimecast-MFC-AGG-ID: vb3hGyt_MyGs9Zzj8haLHg_1758907737
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CF6AD1956053;
	Fri, 26 Sep 2025 17:28:56 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 91B3E19560A2;
	Fri, 26 Sep 2025 17:28:56 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 58QHStG71548380
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 26 Sep 2025 13:28:55 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 58QHStAA1548379;
	Fri, 26 Sep 2025 13:28:55 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 4/4] libmpathpersist: Fix unregistering while holding the reservation
Date: Fri, 26 Sep 2025 13:28:54 -0400
Message-ID: <20250926172854.1548351-5-bmarzins@redhat.com>
In-Reply-To: <20250926172854.1548351-1-bmarzins@redhat.com>
References: <20250926172854.1548351-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: FFceCJKkm0_3KTd6OyzUFSXuDePv27g2G4z45h7DD7g_1758907737
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

There were two problems with how libmpathpersist handled unregistering
a key while holding the reseravation (which should also release the
reservation).
1. If the path holding the reservation is not unregistered first, there
   will be unregistered paths, while a reservation is still held, which
   would cause IO to those paths to fail, when it shouldn't.
2. If the path that holds the reservation is down, libmpathpersist was
   not clearing the reservation, since the there were no registered keys
   it could use for the PREEMPT command workaround

To fix these, libmpathpersist now releases the reservation first when
trying to unregister a key that is holding the reservation.
mpath_prout_rel() has a new option so that if it needs to self preempt
to clear the reservation, it won't re-register the paths when called
as part of unregistering a key. Also, instead of checking if the device
is currently holding a reservation using mpp->reservation_key in
check_holding_reservation() (which will already be set to 0 when called
as part of unregistering a key), pass in the key to check.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathpersist/mpath_persist.h     |   3 +
 libmpathpersist/mpath_persist_int.c | 108 ++++++++++++++++++++--------
 2 files changed, 80 insertions(+), 31 deletions(-)

diff --git a/libmpathpersist/mpath_persist.h b/libmpathpersist/mpath_persist.h
index 32aa7ffe..449e2825 100644
--- a/libmpathpersist/mpath_persist.h
+++ b/libmpathpersist/mpath_persist.h
@@ -65,6 +65,9 @@ extern "C" {
 #define MPATH_PR_RETRYABLE_ERROR	16  /* error that might be succeed
 					       down another path. Internal
 					       only. */
+#define MPATH_PR_SUCCESS_UNREGISTER	17  /* Success, and additionally, all
+					       paths were unregistered.
+					       Internal only. */
 
 /* PR MASK */
 #define MPATH_F_APTPL_MASK		0x01	/* APTPL MASK*/
diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index 9c71011f..47ed0966 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -564,18 +564,23 @@ static int mpath_prout_reg(struct multipath *mpp,int rq_servact, int rq_scope,
 	return status;
 }
 
+enum preempt_work {
+	PREE_WORK_NONE,
+	PREE_WORK_REL,
+	PREE_WORK_REL_UNREG,
+};
 /*
  * Called to make a multipath device preempt its own reservation (and
- * optionally release the reservation). Doing this causes the reservation
- * keys to be removed from all the device paths except that path used to issue
- * the preempt, so they need to be restored. To avoid the chance that IO
- * goes to these paths when they don't have a registered key, the device
- * is suspended before issuing the preemption, and the keys are reregistered
- * before resuming it.
+ * optional extra work). Doing this causes the reservation keys to be removed
+ * from all the device paths except that path used to issue the preempt, so
+ * they may need to be restored. To avoid the chance that IO goes to these
+ * paths when they don't have a registered key and a reservation exists, the
+ * device is suspended before issuing the preemption, and the keys are
+ * reregistered (or the reservation is released) before resuming it.
  */
 static int do_preempt_self(struct multipath *mpp, struct be64 sa_key,
 			   int rq_servact, int rq_scope, unsigned int rq_type,
-			   int noisy, bool do_release)
+			   int noisy, enum preempt_work work)
 {
 	int status, rel_status = MPATH_PR_SUCCESS;
 	struct path *pp = NULL;
@@ -596,7 +601,7 @@ static int do_preempt_self(struct multipath *mpp, struct be64 sa_key,
 		goto fail_resume;
 	}
 
-	if (do_release) {
+	if (work != PREE_WORK_NONE) {
 		memset(&paramp, 0, sizeof(paramp));
 		memcpy(paramp.key, &mpp->reservation_key, 8);
 		rel_status = prout_do_scsi_ioctl(pp->dev, MPATH_PROUT_REL_SA,
@@ -604,15 +609,26 @@ static int do_preempt_self(struct multipath *mpp, struct be64 sa_key,
 		if (rel_status != MPATH_PR_SUCCESS)
 			condlog(0, "%s: release on alternate path failed.",
 				mpp->wwid);
+		else if (work == PREE_WORK_REL_UNREG) {
+			/* unregister the last path */
+			rel_status = prout_do_scsi_ioctl(pp->dev,
+							 MPATH_PROUT_REG_IGN_SA,
+							 rq_scope, rq_type,
+							 &paramp, noisy);
+			if (rel_status != MPATH_PR_SUCCESS)
+				condlog(0, "%s: final self preempt unregister failed,",
+					mpp->wwid);
+		}
+	}
+	if (work != PREE_WORK_REL_UNREG) {
+		memset(&paramp, 0, sizeof(paramp));
+		memcpy(paramp.sa_key, &mpp->reservation_key, 8);
+		status = mpath_prout_reg(mpp, MPATH_PROUT_REG_IGN_SA, rq_scope,
+					 rq_type, &paramp, noisy);
+		if (status != MPATH_PR_SUCCESS)
+			condlog(0, "%s: self preempt failed to reregister paths.",
+				mpp->wwid);
 	}
-
-	memset(&paramp, 0, sizeof(paramp));
-	memcpy(paramp.sa_key, &mpp->reservation_key, 8);
-	status = mpath_prout_reg(mpp, MPATH_PROUT_REG_IGN_SA, rq_scope,
-				 rq_type, &paramp, noisy);
-	if (status != MPATH_PR_SUCCESS)
-		condlog(0, "%s: self preempt failed to reregister paths.",
-			mpp->wwid);
 
 fail_resume:
 	if (!dm_simplecmd_noflush(DM_DEVICE_RESUME, mpp->alias, udev_flags)) {
@@ -625,10 +641,10 @@ fail_resume:
 }
 
 static int preempt_self(struct multipath *mpp, int rq_servact, int rq_scope,
-			unsigned int rq_type, int noisy, bool do_release)
+			unsigned int rq_type, int noisy, enum preempt_work work)
 {
 	return do_preempt_self(mpp, mpp->reservation_key, rq_servact, rq_scope,
-			       rq_type, noisy, do_release);
+			       rq_type, noisy, work);
 }
 
 static int preempt_all(struct multipath *mpp, int rq_servact, int rq_scope,
@@ -636,7 +652,7 @@ static int preempt_all(struct multipath *mpp, int rq_servact, int rq_scope,
 {
 	struct be64 zerokey = {0};
 	return do_preempt_self(mpp, zerokey, rq_servact, rq_scope, rq_type,
-			       noisy, false);
+			       noisy, PREE_WORK_NONE);
 }
 
 static int reservation_key_matches(struct multipath *mpp, uint8_t *key,
@@ -661,18 +677,21 @@ static int reservation_key_matches(struct multipath *mpp, uint8_t *key,
 	return YNU_NO;
 }
 
-static bool check_holding_reservation(struct multipath *mpp, unsigned int *type)
+static bool check_holding_reservation(struct multipath *mpp, uint8_t *curr_key,
+				      unsigned int *type)
 {
-	if (get_be64(mpp->reservation_key) &&
+	uint64_t zerokey = 0;
+	if (memcmp(curr_key, &zerokey, 8) != 0 &&
 	    get_prhold(mpp->alias) == PR_SET &&
-	    reservation_key_matches(mpp, (uint8_t *)&mpp->reservation_key, type) == YNU_YES)
+	    reservation_key_matches(mpp, curr_key, type) == YNU_YES)
 		return true;
 	return false;
 }
 
-static int mpath_prout_rel(struct multipath *mpp,int rq_servact, int rq_scope,
+static int mpath_prout_rel(struct multipath *mpp, int rq_servact, int rq_scope,
 			   unsigned int rq_type,
-			   struct prout_param_descriptor * paramp, int noisy)
+			   struct prout_param_descriptor *paramp, int noisy,
+			   bool unregister)
 {
 	int i, j;
 	struct pathgroup *pgp = NULL;
@@ -762,7 +781,8 @@ static int mpath_prout_rel(struct multipath *mpp,int rq_servact, int rq_scope,
 		return status;
 	}
 
-	if (!check_holding_reservation(mpp, &res_type)) {
+	if (!check_holding_reservation(mpp, (uint8_t *)&mpp->reservation_key,
+				       &res_type)) {
 		condlog(2, "%s: Releasing key not holding reservation.", mpp->wwid);
 		return MPATH_PR_SUCCESS;
 	}
@@ -785,7 +805,13 @@ static int mpath_prout_rel(struct multipath *mpp,int rq_servact, int rq_scope,
 	 * 4. Reregistering keys on all the paths
 	 * 5. Resuming the device
 	 */
-	return preempt_self(mpp, MPATH_PROUT_PREE_SA, rq_scope, rq_type, noisy, true);
+	status = preempt_self(mpp, MPATH_PROUT_PREE_SA, rq_scope, rq_type,
+			      noisy,
+			      unregister ? PREE_WORK_REL_UNREG : PREE_WORK_REL);
+	if (status == MPATH_PR_SUCCESS && unregister)
+		return MPATH_PR_SUCCESS_UNREGISTER;
+	return status;
+
 }
 
 /*
@@ -828,7 +854,7 @@ int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
 	select_reservation_key(conf, mpp);
 	put_multipath_config(conf);
 
-	memcpy(&oldkey, &mpp->reservation_key, 8);
+	oldkey = mpp->reservation_key;
 	unregistering = (memcmp(&zerokey, paramp->sa_key, 8) == 0);
 	if (mpp->prkey_source == PRKEY_SOURCE_FILE &&
 	    (rq_servact == MPATH_PROUT_REG_IGN_SA ||
@@ -905,7 +931,27 @@ int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
 	{
 	case MPATH_PROUT_REG_SA:
 	case MPATH_PROUT_REG_IGN_SA:
-		ret= mpath_prout_reg(mpp, rq_servact, rq_scope, rq_type, paramp, noisy);
+		if (unregistering && check_holding_reservation(mpp, (uint8_t *)&oldkey, &rq_type)) {
+			struct be64 newkey = mpp->reservation_key;
+			/* temporarily restore reservation key */
+			mpp->reservation_key = oldkey;
+			ret = mpath_prout_rel(mpp, MPATH_PROUT_REL_SA, rq_scope,
+					      rq_type, paramp, noisy, true);
+			mpp->reservation_key = newkey;
+			if (ret == MPATH_PR_SUCCESS)
+				/*
+				 * Since unregistering it true, paramp->sa_key
+				 * must be zero here. So this command will
+				 * unregister the key.
+				 */
+				ret = mpath_prout_reg(mpp, rq_servact, rq_scope,
+						      rq_type, paramp, noisy);
+			else if (ret == MPATH_PR_SUCCESS_UNREGISTER)
+				/* We already unregistered the key */
+				ret = MPATH_PR_SUCCESS;
+		} else
+			ret = mpath_prout_reg(mpp, rq_servact, rq_scope,
+					      rq_type, paramp, noisy);
 		break;
 	case MPATH_PROUT_PREE_SA:
 	case MPATH_PROUT_PREE_AB_SA:
@@ -921,7 +967,7 @@ int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
 		/* if we are preempting ourself */
 		if (memcmp(paramp->sa_key, paramp->key, 8) == 0) {
 			ret = preempt_self(mpp, rq_servact, rq_scope, rq_type,
-					   noisy, false);
+					   noisy, PREE_WORK_NONE);
 			break;
 		}
 		/* fallthrough */
@@ -932,14 +978,14 @@ int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
 					 paramp, noisy, NULL, &failed_paths);
 		if (rq_servact == MPATH_PROUT_RES_SA &&
 		    ret != MPATH_PR_SUCCESS && failed_paths &&
-		    check_holding_reservation(mpp, &res_type) &&
+		    check_holding_reservation(mpp, paramp->key, &res_type) &&
 		    res_type == rq_type)
 			/* The reserve failed, but multipathd says we hold it */
 			ret = MPATH_PR_SUCCESS;
 		break;
 	}
 	case MPATH_PROUT_REL_SA:
-		ret = mpath_prout_rel(mpp, rq_servact, rq_scope, rq_type, paramp, noisy);
+		ret = mpath_prout_rel(mpp, rq_servact, rq_scope, rq_type, paramp, noisy, false);
 		break;
 	default:
 		return MPATH_PR_OTHER;
-- 
2.50.1

