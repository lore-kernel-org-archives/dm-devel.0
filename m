Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 229BC1397
	for <dm-devel@lists.linux.dev>; Fri, 26 Sep 2025 17:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758907745; cv=none; b=oqEhVLp13MgEiJVPuNhDbfKhjpx+Hd9qpV6sOEVfBGjEIRJgTLDlvATcK0ELcCANNtt5Si5dEEZV5gxnka7C2xrqRoYtG+HFh8/8WBTepaAgcE7lq+zTm5tO+CvPJB1otZUMSxPn3D2vkrAWlfesS9Yy3ZB8yaDeB3DxhEbF0Qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758907745; c=relaxed/simple;
	bh=tfppUVx5iMS9D8KzOHlq76rd0poCKu8+H/M1tV+94qs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=aSCopq46/Su1nMSUPfYFRwA+EvvHKh8AiV1CaMTP1q230sk1uINd+JDwVR8WS1kAIOplwCWLQlcCa/6txrwXyFAzs8lrwry+eaZ6KtMRJX3oe4cJ23tYhJkN0opnQxoXBcbu8kGvXnH6hNdgs8EX7aedstRR/XWjCqZKvMlz37k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dc0aUxDd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dc0aUxDd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758907743;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4kri1IwvfkCAQRKLXbMNXM2xtI8AH/3kJzjh4FrgwMc=;
	b=dc0aUxDdVNjMs5dj8Wiilo1dar6WPg2/LX3Ux9g5TBUsTUqupofIDLXm3zatWWCyDzaMaT
	vLgT0aBxH3EhZCpxmZct+Y6MmOguYcy5XirobmVtVDcCo3LBmoGGHnnzpHh2elQwCcDn3O
	PuvILiAYkfjcw4T9/oqXHbkbd2hm8P8=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-651-A2T1bvy2P3KIKYEo5ZPvOw-1; Fri,
 26 Sep 2025 13:28:57 -0400
X-MC-Unique: A2T1bvy2P3KIKYEo5ZPvOw-1
X-Mimecast-MFC-AGG-ID: A2T1bvy2P3KIKYEo5ZPvOw_1758907737
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DBE751800359;
	Fri, 26 Sep 2025 17:28:56 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 929111800282;
	Fri, 26 Sep 2025 17:28:56 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 58QHStgM1548376
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 26 Sep 2025 13:28:55 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 58QHSteW1548375;
	Fri, 26 Sep 2025 13:28:55 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 3/4] libmpathpersist: use check_holding_reservation in mpath_prout_rel
Date: Fri, 26 Sep 2025 13:28:53 -0400
Message-ID: <20250926172854.1548351-4-bmarzins@redhat.com>
In-Reply-To: <20250926172854.1548351-1-bmarzins@redhat.com>
References: <20250926172854.1548351-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: SlMkjfuH3U0MnfzPyTvLe39MZhpw4vqqZgYShGeHxCE_1758907737
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

