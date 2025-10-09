Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA0E54654
	for <dm-devel@lists.linux.dev>; Thu,  9 Oct 2025 23:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760053160; cv=none; b=JkV2IFwWqMqJG/oL9JRbnH2HIXuquMoG6VlT4jkE0YbLi8JRDkOOgeWrVQ06qbySea+G8V72MweT/hRyKn8j3N1rMVPNK3EpSITKIagEUEFCYyzYKMtzEBX/Al4H+dP/20rjQFqKxlkPC9brpIXetBLogRIu1a6PsP7NAHP51Do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760053160; c=relaxed/simple;
	bh=eNdOwM942Qo2XzJ145yY3DkSpDuAXpN0bQRCSlw+E0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=Yn+vhwgKWz4/yUwwtOSnDVe66QlrEKvQXETkKpZb58y3sbFjwv38tS8cKcgXKVwsSBWTSCzJbAizVqV1pXiPV35620iMC+dW9WGfZdPaoVfqOcLHexGmjCkJel6Oz9gC7qluvWnagObbhUv3WedRpo2hRTtQOQFQBjwdB9x5VDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J1ql+wax; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J1ql+wax"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760053156;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=J0yZdVdBR4yalV51n6k+5rGJr4yRyh1vB2xnUhm74q0=;
	b=J1ql+waxtpXfptg8MUv2wmj3Kzqc5BwksoxsaD4M3ntTaNvKQ3l8gjetV3qlg2zlUcJXFA
	xqd37UB3Fk7JYYZdADDZwI1phD+0CQxR3DfB/CQgIjyovS+DQU9O+1AaNCf0ia1nVhnAer
	1CJvPPHfiVPKuhfrwuXbHEKa90f5gdo=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-549-Sf18aiuFPPyU78nnTsGr9w-1; Thu,
 09 Oct 2025 19:39:13 -0400
X-MC-Unique: Sf18aiuFPPyU78nnTsGr9w-1
X-Mimecast-MFC-AGG-ID: Sf18aiuFPPyU78nnTsGr9w_1760053152
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 702CE1956089;
	Thu,  9 Oct 2025 23:39:12 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 310AA1800578;
	Thu,  9 Oct 2025 23:39:12 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 599NdA682930705
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 9 Oct 2025 19:39:10 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 599NdArh2930704;
	Thu, 9 Oct 2025 19:39:10 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <mwilck@suse.com>
Subject: [PATCH] libmpathpersist: Cleanup logging messages
Date: Thu,  9 Oct 2025 19:39:10 -0400
Message-ID: <20251009233910.2930696-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 1fOXEG_1OtsqBJyKP2mXrq_lwnuWymAWJWXIaNvRpME_1760053152
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Adjust the logging messages and levels, and remove a unnecessary and
confusing message.

Suggested-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathpersist/mpath_persist_int.c | 16 +++++++++-------
 libmpathpersist/mpath_updatepr.c    |  9 +++++----
 2 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index 14de06b3..8b8a7812 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -211,7 +211,7 @@ mpath_prout_common(struct multipath *mpp, int rq_servact, int rq_scope,
 	vector_foreach_slot (mpp->pg, pgp, j) {
 		vector_foreach_slot (pgp->paths, pp, i) {
 			if (!((pp->state == PATH_UP) || (pp->state == PATH_GHOST))) {
-				condlog(1, "%s: %s path not up. Skip",
+				condlog(3, "%s: %s path not up. Skip",
 					mpp->wwid, pp->dev);
 				if (failed_paths)
 					*failed_paths = true;
@@ -244,6 +244,8 @@ mpath_prout_common(struct multipath *mpp, int rq_servact, int rq_scope,
 			if (ret == MPATH_PR_RESERV_CONFLICT &&
 			    (pp->dmstate == PSTATE_FAILED ||
 			     rq_servact == MPATH_PROUT_RES_SA)) {
+				condlog(4, "%s: ignoring path %s with conflict",
+					mpp->wwid, pp->dev);
 				conflict = true;
 				continue;
 			}
@@ -330,6 +332,8 @@ void preempt_missing_path(struct multipath *mpp, uint8_t *key, uint8_t *sa_key,
 	 * node. libmpathpersist has never worked if multiple nodes share
 	 * the same reservation key for a device
 	 */
+	condlog(3, "%s: preempting missing path while changing key",
+		mpp->wwid);
 	rq_type = resp.prin_descriptor.prin_readresv.scope_type & MPATH_PR_TYPE_MASK;
 	rq_scope = (resp.prin_descriptor.prin_readresv.scope_type &
 		    MPATH_PR_SCOPE_MASK) >>
@@ -446,7 +450,7 @@ static int mpath_prout_reg(struct multipath *mpp,int rq_servact, int rq_scope,
 	vector_foreach_slot (mpp->pg, pgp, j){
 		vector_foreach_slot (pgp->paths, pp, i){
 			if (!((pp->state == PATH_UP) || (pp->state == PATH_GHOST))){
-				condlog (1, "%s: %s path not up. Skip.", mpp->wwid, pp->dev);
+				condlog (3, "%s: %s path not up. Skip.", mpp->wwid, pp->dev);
 				continue;
 			}
 			if (all_tg_pt && pp->sg_id.host_no != -1) {
@@ -736,7 +740,7 @@ mpath_prout_rel(struct multipath *mpp, int rq_servact, int rq_scope,
 	vector_foreach_slot (mpp->pg, pgp, j){
 		vector_foreach_slot (pgp->paths, pp, i){
 			if (!((pp->state == PATH_UP) || (pp->state == PATH_GHOST))){
-				condlog (1, "%s: %s path not up.", mpp->wwid, pp->dev);
+				condlog (3, "%s: %s path not up.", mpp->wwid, pp->dev);
 				continue;
 			}
 
@@ -780,17 +784,15 @@ mpath_prout_rel(struct multipath *mpp, int rq_servact, int rq_scope,
 	}
 
 	if (!check_holding_reservation(mpp, (uint8_t *)&mpp->reservation_key,
-				       &res_type)) {
-		condlog(2, "%s: Releasing key not holding reservation.", mpp->wwid);
+				       &res_type))
 		return MPATH_PR_SUCCESS;
-	}
 	if (res_type != rq_type) {
 		condlog(2, "%s: --prout_type %u doesn't match reservation %u",
 			mpp->wwid, rq_type, res_type);
 		return MPATH_PR_RESERV_CONFLICT;
 	}
 
-	condlog (2, "%s: Path holding reservation is not available.", mpp->wwid);
+	condlog (3, "%s: Path holding reservation is not available.", mpp->wwid);
 	/*
 	 * Cannot free the reservation because the path that is holding it
 	 * is not usable. Workaround this by:
diff --git a/libmpathpersist/mpath_updatepr.c b/libmpathpersist/mpath_updatepr.c
index dd8dd48e..d189c184 100644
--- a/libmpathpersist/mpath_updatepr.c
+++ b/libmpathpersist/mpath_updatepr.c
@@ -38,14 +38,14 @@ static char *do_pr(char *alias, char *str)
 		return NULL;
 	}
 
-	condlog (2, "%s: pr message=%s", alias, str);
+	condlog (4, "%s: pr message=%s", alias, str);
 	if (send_packet(fd, str) != 0) {
 		condlog(2, "%s: message=%s send error=%d", alias, str, errno);
 		mpath_disconnect(fd);
 		return NULL;
 	}
 	if (recv_packet(fd, &reply, timeout) < 0)
-		condlog(2, "%s: message=%s recv error=%d", alias, str, errno);
+		condlog(0, "%s: message=%s recv error=%d", alias, str, errno);
 
 	mpath_disconnect(fd);
 	return reply;
@@ -64,11 +64,12 @@ static int do_update_pr(char *alias, char *cmd, char *key)
 
 	reply = do_pr(alias, str);
 	if (reply) {
-		condlog (2, "%s: message=%s reply=%s", alias, str, reply);
-		if (reply && strncmp(reply,"ok", 2) == 0)
+		if (strncmp(reply, "ok", 2) == 0)
 			ret = 0;
 		else
 			ret = -1;
+		condlog(ret ? 0 : 4, "%s: message=%s reply=%s", alias, str,
+			reply);
 	}
 
 	free(reply);
-- 
2.50.1

