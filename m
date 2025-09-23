Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 084DB30DEC7
	for <dm-devel@lists.linux.dev>; Tue, 23 Sep 2025 22:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758665579; cv=none; b=c9zCg3z+x8PoAo6YOac6dfFqXLvNOG9vgZL7BNTXKAH8UEOGKoGucpTpf1nb/c/YU7g3gZHziNA7xS2AjayrbUTO9eYDkdAsnwClx0DORMqUzKhxI2JXGwmd0j2AbIs8Z+EGWSLDMf4AGOcbsyX3HwNqvmXi+Ak6d5i6HuumWcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758665579; c=relaxed/simple;
	bh=tfppUVx5iMS9D8KzOHlq76rd0poCKu8+H/M1tV+94qs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=lM9N1f/+SMrgUCgvrnFjq8sTeJj2ez7ViGjoUwCT4K2rHX/dCM90UhiBU6oiXMRAHbNeOhbKc+zg8ADUVaL6mt4fDik5csLpEouMRf7aHdTQ2GDO/ZBf37v83mJ6N+/xqeLj3kEkNsGr4+tm87J4FZHYRGrJ+ph1mRR1+2gFtPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VpzVFs02; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VpzVFs02"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758665576;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4kri1IwvfkCAQRKLXbMNXM2xtI8AH/3kJzjh4FrgwMc=;
	b=VpzVFs02fN9f+kYeNNDl4gVOA5V3dad1FGLMyvHbVL5mUqmKYhBNC5p8LQmlWBWvzvTsy6
	n9+Ax5IjRR4g4KTEp6EB/v2krPkkytcbqBBP+a6m5XGDaE9QVkV8KD/f9e89lzOJhVCYDF
	wdaBhGoitO85fRukkhxxDc2QfOHYLhA=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-60-00BS43FvNPaF4IHPRUpkyQ-1; Tue,
 23 Sep 2025 18:12:55 -0400
X-MC-Unique: 00BS43FvNPaF4IHPRUpkyQ-1
X-Mimecast-MFC-AGG-ID: 00BS43FvNPaF4IHPRUpkyQ_1758665574
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8147A180047F;
	Tue, 23 Sep 2025 22:12:54 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3592A1955F22;
	Tue, 23 Sep 2025 22:12:54 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 58NMCquY1411712
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 23 Sep 2025 18:12:52 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 58NMCq001411711;
	Tue, 23 Sep 2025 18:12:52 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 3/4] libmpathpersist: use check_holding_reservation in mpath_prout_rel
Date: Tue, 23 Sep 2025 18:12:51 -0400
Message-ID: <20250923221252.1411687-4-bmarzins@redhat.com>
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
X-Mimecast-MFC-PROC-ID: AIaDO47PBZI07z4Gi7utO3QWolqDu1odQXDinQT88I8_1758665574
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Instead of open-coding mostly the same work, just make mpath_prout_rel()
call check_holding_reservation().

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathpersist/mpath_persist_int.c | 86 ++++++++++++-----------------
 1 file changed, 35 insertions(+), 51 deletions(-)

diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index 33c9e57a..9c71011f 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -639,12 +639,42 @@ static int preempt_all(struct multipath *mpp, int rq_servact, int rq_scope,
 			       noisy, false);
 }
 
+static int reservation_key_matches(struct multipath *mpp, uint8_t *key,
+				   unsigned int *type)
+{
+	struct prin_resp resp = {{{.prgeneration = 0}}};
+	int status;
+
+	status = mpath_prin_activepath(mpp, MPATH_PRIN_RRES_SA, &resp, 0);
+	if (status != MPATH_PR_SUCCESS) {
+		condlog(0, "%s: pr in read reservation command failed.", mpp->wwid);
+		return YNU_UNDEF;
+	}
+	if (!resp.prin_descriptor.prin_readresv.additional_length)
+		return YNU_NO;
+	if (memcmp(key, resp.prin_descriptor.prin_readresv.key, 8) == 0) {
+		if (type)
+			*type = resp.prin_descriptor.prin_readresv.scope_type &
+				MPATH_PR_TYPE_MASK;
+		return YNU_YES;
+	}
+	return YNU_NO;
+}
+
+static bool check_holding_reservation(struct multipath *mpp, unsigned int *type)
+{
+	if (get_be64(mpp->reservation_key) &&
+	    get_prhold(mpp->alias) == PR_SET &&
+	    reservation_key_matches(mpp, (uint8_t *)&mpp->reservation_key, type) == YNU_YES)
+		return true;
+	return false;
+}
+
 static int mpath_prout_rel(struct multipath *mpp,int rq_servact, int rq_scope,
 			   unsigned int rq_type,
 			   struct prout_param_descriptor * paramp, int noisy)
 {
 	int i, j;
-	int num = 0;
 	struct pathgroup *pgp = NULL;
 	struct path *pp = NULL;
 	int active_pathcount = 0;
@@ -652,9 +682,8 @@ static int mpath_prout_rel(struct multipath *mpp,int rq_servact, int rq_scope,
 	int rc;
 	int count = 0;
 	int status = MPATH_PR_SUCCESS;
-	struct prin_resp resp = {{{.prgeneration = 0}}};
 	bool all_threads_failed;
-	unsigned int scope_type;
+	unsigned int res_type;
 
 	if (!mpp)
 		return MPATH_PR_DMMP_ERROR;
@@ -733,27 +762,13 @@ static int mpath_prout_rel(struct multipath *mpp,int rq_servact, int rq_scope,
 		return status;
 	}
 
-	status = mpath_prin_activepath (mpp, MPATH_PRIN_RRES_SA, &resp, noisy);
-	if (status != MPATH_PR_SUCCESS){
-		condlog (0, "%s: pr in read reservation command failed.", mpp->wwid);
-		return MPATH_PR_OTHER;
-	}
-
-	num = resp.prin_descriptor.prin_readresv.additional_length / 8;
-	if (num == 0){
-		condlog (2, "%s: Path holding reservation is released.", mpp->wwid);
-		return MPATH_PR_SUCCESS;
-	}
-	if (!get_be64(mpp->reservation_key) ||
-	    memcmp(&mpp->reservation_key, resp.prin_descriptor.prin_readresv.key, 8)) {
+	if (!check_holding_reservation(mpp, &res_type)) {
 		condlog(2, "%s: Releasing key not holding reservation.", mpp->wwid);
 		return MPATH_PR_SUCCESS;
 	}
-
-	scope_type = resp.prin_descriptor.prin_readresv.scope_type;
-	if ((scope_type & MPATH_PR_TYPE_MASK) != rq_type) {
+	if (res_type != rq_type) {
 		condlog(2, "%s: --prout_type %u doesn't match reservation %u",
-			mpp->wwid, rq_type, scope_type & MPATH_PR_TYPE_MASK);
+			mpp->wwid, rq_type, res_type);
 		return MPATH_PR_RESERV_CONFLICT;
 	}
 
@@ -773,28 +788,6 @@ static int mpath_prout_rel(struct multipath *mpp,int rq_servact, int rq_scope,
 	return preempt_self(mpp, MPATH_PROUT_PREE_SA, rq_scope, rq_type, noisy, true);
 }
 
-static int reservation_key_matches(struct multipath *mpp, uint8_t *key,
-				   unsigned int *type)
-{
-	struct prin_resp resp = {{{.prgeneration = 0}}};
-	int status;
-
-	status = mpath_prin_activepath(mpp, MPATH_PRIN_RRES_SA, &resp, 0);
-	if (status != MPATH_PR_SUCCESS) {
-		condlog(0, "%s: pr in read reservation command failed.", mpp->wwid);
-		return YNU_UNDEF;
-	}
-	if (!resp.prin_descriptor.prin_readresv.additional_length)
-		return YNU_NO;
-	if (memcmp(key, resp.prin_descriptor.prin_readresv.key, 8) == 0) {
-		if (type)
-			*type = resp.prin_descriptor.prin_readresv.scope_type &
-				MPATH_PR_TYPE_MASK;
-		return YNU_YES;
-	}
-	return YNU_NO;
-}
-
 /*
  * for MPATH_PROUT_REG_IGN_SA, we use the ignored paramp->key to store the
  * currently registered key for use in preempt_missing_path(), but only if
@@ -813,15 +806,6 @@ static void set_ignored_key(struct multipath *mpp, uint8_t *curr_key,
 	memcpy(key, curr_key, 8);
 }
 
-static bool check_holding_reservation(struct multipath *mpp, unsigned int *type)
-{
-	if (get_be64(mpp->reservation_key) &&
-	    get_prhold(mpp->alias) == PR_SET &&
-	    reservation_key_matches(mpp, (uint8_t *)&mpp->reservation_key, type) == YNU_YES)
-		return true;
-	return false;
-}
-
 int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
 				    int rq_servact, int rq_scope, unsigned int rq_type,
 				    struct prout_param_descriptor *paramp, int noisy)
-- 
2.50.1

