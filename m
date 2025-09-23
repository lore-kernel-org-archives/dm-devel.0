Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0845A30CDBA
	for <dm-devel@lists.linux.dev>; Tue, 23 Sep 2025 22:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758665579; cv=none; b=bKaa+Ncj4Sqx/q4LnGrZh6sgfXHZnM+rXoZ2RsFp+Uvcl+lEevXbcq+Yk8PxjxPvpGfaKEj4vVJ75WWmZKiskQd1SbFymKPKlUMexrnkz6IgDST5nDI6RcO9lXJgVdlUg/njTobOC7JDBM280NgE4jOI7j9ercVlcG43nh0YR0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758665579; c=relaxed/simple;
	bh=OgDg3YylEsZlaTREiDuP8HUcH9H2Hsjlm5Du8aIZCa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=CkGIeDb4luUD9wGAMbHoTbyjSWdVt6yJHlRmyfULWTGGp7+cs7yBjU09SdSw/iWV/V6MGBi8Xwx1DLcLc0xLbHaDaL1Ma+v9neqA9UsGhIl3gtuzGjcTlsYnqbIoiBaFLIDxnQr85jzfPVqfwzzyYyj2UFJ7EF5oy9qJ7lbe6f0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AwTzy2j2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AwTzy2j2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758665577;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PBfYlHhXAd0WvOiRjJClbbF8mI/nUB4jTuWRJ45V0ek=;
	b=AwTzy2j2W+SCOPtFavlgddpZBm1Zrj+ZdTwxv7RfAmpezULo/THXhM+EfLn2jOOIh2IQ9a
	yLaydz1HXfe9SgpIjwIYNRKFAFPWqzG3UKpQfgAvcUgjAXt680sNuJuwTvYFYPk9oCsoLm
	bHS3QKJdbaAaHMpN1HcfnW0hxPAkNqw=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-60-0_ydgkX4PpelaejrB1VR-Q-1; Tue,
 23 Sep 2025 18:12:55 -0400
X-MC-Unique: 0_ydgkX4PpelaejrB1VR-Q-1
X-Mimecast-MFC-AGG-ID: 0_ydgkX4PpelaejrB1VR-Q_1758665574
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7AE7419560B4;
	Tue, 23 Sep 2025 22:12:54 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 143EF1955F19;
	Tue, 23 Sep 2025 22:12:53 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 58NMCqLY1411708
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 23 Sep 2025 18:12:52 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 58NMCqxE1411707;
	Tue, 23 Sep 2025 18:12:52 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 2/4] libmpathpersist: Handle RESERVE with reservation held by failed path
Date: Tue, 23 Sep 2025 18:12:50 -0400
Message-ID: <20250923221252.1411687-3-bmarzins@redhat.com>
In-Reply-To: <20250923221252.1411687-1-bmarzins@redhat.com>
References: <20250923221252.1411687-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: sZKDHCa9UEPGTJVsZBnzm9erH4xhu1JZyi-r-uRwZh4_1758665574
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Issuing a RESERVE on a device that already holds the reservation should
succeed, as long as the type is the same. But if the path that holds the
reservation is unavailable, mpathpersist fails, since it gets a
reservation conflict on all available paths. To deal with this, if the
multipath device has failed paths, and the key holding the reservation
matches the multipath device's key, and multipathd says that it is
holding the reservation, assume the reservation is held by a failed path
and claim the RESERVE succeeded, even though none of the actual scsi
commands did

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathpersist/mpath_persist_int.c | 47 +++++++++++++++++++++++------
 1 file changed, 37 insertions(+), 10 deletions(-)

diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index 476c3433..33c9e57a 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -200,7 +200,7 @@ static void *mpath_prout_pthread_fn(void *p)
 static int
 mpath_prout_common(struct multipath *mpp, int rq_servact, int rq_scope,
 		   unsigned int rq_type, struct prout_param_descriptor *paramp,
-		   int noisy, struct path **pptr)
+		   int noisy, struct path **pptr, bool *failed_paths)
 {
 	int i, j, ret;
 	struct pathgroup *pgp = NULL;
@@ -213,6 +213,8 @@ mpath_prout_common(struct multipath *mpp, int rq_servact, int rq_scope,
 			if (!((pp->state == PATH_UP) || (pp->state == PATH_GHOST))) {
 				condlog(1, "%s: %s path not up. Skip",
 					mpp->wwid, pp->dev);
+				if (failed_paths)
+					*failed_paths = true;
 				continue;
 			}
 
@@ -247,6 +249,8 @@ mpath_prout_common(struct multipath *mpp, int rq_servact, int rq_scope,
 			}
 			if (ret != MPATH_PR_RETRYABLE_ERROR)
 				return ret;
+			if (failed_paths)
+				*failed_paths = true;
 		}
 	}
 	if (found)
@@ -333,7 +337,7 @@ void preempt_missing_path(struct multipath *mpp, uint8_t *key, uint8_t *sa_key,
 	memcpy(paramp.key, sa_key, 8);
 	memcpy(paramp.sa_key, key, 8);
 	status = mpath_prout_common(mpp, MPATH_PROUT_PREE_SA, rq_scope,
-				    rq_type, &paramp, noisy, NULL);
+				    rq_type, &paramp, noisy, NULL, NULL);
 	if (status != MPATH_PR_SUCCESS)
 		condlog(0, "%s: register: pr preempt command failed.", mpp->wwid);
 }
@@ -586,7 +590,7 @@ static int do_preempt_self(struct multipath *mpp, struct be64 sa_key,
 	memcpy(paramp.key, &mpp->reservation_key, 8);
 	memcpy(paramp.sa_key, &sa_key, 8);
 	status = mpath_prout_common(mpp, rq_servact, rq_scope, rq_type,
-				    &paramp, noisy, &pp);
+				    &paramp, noisy, &pp, NULL);
 	if (status != MPATH_PR_SUCCESS) {
 		condlog(0, "%s: self preempt command failed.", mpp->wwid);
 		goto fail_resume;
@@ -769,20 +773,25 @@ static int mpath_prout_rel(struct multipath *mpp,int rq_servact, int rq_scope,
 	return preempt_self(mpp, MPATH_PROUT_PREE_SA, rq_scope, rq_type, noisy, true);
 }
 
-static int reservation_key_matches(struct multipath *mpp, uint8_t *key, int noisy)
+static int reservation_key_matches(struct multipath *mpp, uint8_t *key,
+				   unsigned int *type)
 {
 	struct prin_resp resp = {{{.prgeneration = 0}}};
 	int status;
 
-	status = mpath_prin_activepath(mpp, MPATH_PRIN_RRES_SA, &resp, noisy);
+	status = mpath_prin_activepath(mpp, MPATH_PRIN_RRES_SA, &resp, 0);
 	if (status != MPATH_PR_SUCCESS) {
 		condlog(0, "%s: pr in read reservation command failed.", mpp->wwid);
 		return YNU_UNDEF;
 	}
 	if (!resp.prin_descriptor.prin_readresv.additional_length)
 		return YNU_NO;
-	if (memcmp(key, resp.prin_descriptor.prin_readresv.key, 8) == 0)
+	if (memcmp(key, resp.prin_descriptor.prin_readresv.key, 8) == 0) {
+		if (type)
+			*type = resp.prin_descriptor.prin_readresv.scope_type &
+				MPATH_PR_TYPE_MASK;
 		return YNU_YES;
+	}
 	return YNU_NO;
 }
 
@@ -799,11 +808,20 @@ static void set_ignored_key(struct multipath *mpp, uint8_t *curr_key,
 		return;
 	if (get_prhold(mpp->alias) == PR_UNSET)
 		return;
-	if (reservation_key_matches(mpp, curr_key, 0) == YNU_NO)
+	if (reservation_key_matches(mpp, curr_key, NULL) == YNU_NO)
 		return;
 	memcpy(key, curr_key, 8);
 }
 
+static bool check_holding_reservation(struct multipath *mpp, unsigned int *type)
+{
+	if (get_be64(mpp->reservation_key) &&
+	    get_prhold(mpp->alias) == PR_SET &&
+	    reservation_key_matches(mpp, (uint8_t *)&mpp->reservation_key, type) == YNU_YES)
+		return true;
+	return false;
+}
+
 int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
 				    int rq_servact, int rq_scope, unsigned int rq_type,
 				    struct prout_param_descriptor *paramp, int noisy)
@@ -815,6 +833,7 @@ int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
 	struct config *conf;
 	bool unregistering, preempting_reservation = false;
 	bool updated_prkey = false;
+	bool failed_paths = false;
 
 	ret = mpath_get_map(curmp, fd, &mpp);
 	if (ret != MPATH_PR_SUCCESS)
@@ -906,7 +925,7 @@ int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
 		break;
 	case MPATH_PROUT_PREE_SA:
 	case MPATH_PROUT_PREE_AB_SA:
-		if (reservation_key_matches(mpp, paramp->sa_key, noisy) == YNU_YES) {
+		if (reservation_key_matches(mpp, paramp->sa_key, NULL) == YNU_YES) {
 			preempting_reservation = true;
 			if (memcmp(paramp->sa_key, &zerokey, 8) == 0) {
 				/* all registrants case */
@@ -923,10 +942,18 @@ int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
 		}
 		/* fallthrough */
 	case MPATH_PROUT_RES_SA:
-	case MPATH_PROUT_CLEAR_SA:
+	case MPATH_PROUT_CLEAR_SA: {
+		unsigned int res_type;
 		ret = mpath_prout_common(mpp, rq_servact, rq_scope, rq_type,
-					 paramp, noisy, NULL);
+					 paramp, noisy, NULL, &failed_paths);
+		if (rq_servact == MPATH_PROUT_RES_SA &&
+		    ret != MPATH_PR_SUCCESS && failed_paths &&
+		    check_holding_reservation(mpp, &res_type) &&
+		    res_type == rq_type)
+			/* The reserve failed, but multipathd says we hold it */
+			ret = MPATH_PR_SUCCESS;
 		break;
+	}
 	case MPATH_PROUT_REL_SA:
 		ret = mpath_prout_rel(mpp, rq_servact, rq_scope, rq_type, paramp, noisy);
 		break;
-- 
2.50.1

