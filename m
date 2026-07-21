Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F4A7415F14
	for <dm-devel@lists.linux.dev>; Tue, 21 Jul 2026 19:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661863; cv=none; b=oVTotDSTIP7V0PpDzEetO2rnHR8fcoO4IeE3VaXJji7tJEYPbOXLOtR+f6xf/GFzOz/yqnhrz8lhJq/SslfySan15XITPA053VMtKuJryo2lXusbkjSBCoGLP58OBZ9uyv1TW31+SLNEURegPtZUP9Uemm1KBhnwIWAlKtdTky4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661863; c=relaxed/simple;
	bh=fPUPZ59tUYxFBRZLM4PkN5hSge1QJVQmtltCZ3l+HzU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=hPhphLu1+ada4c6gSEDD9PgcTV31kScjDjUG4cCRi5pMJ9ArvYJdEd55dxbQhu0z0K/mBbMd3prkT/ov728C94HP9/g05Ak72oWauuGdEGdP0auSBbfo9pYHw5HP0OGz4csiQiXUGlNgVEmpHWrFWLCF9lgjBYQYyVXWNZhRUZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dygS277s; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dygS277s"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784661860;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=uZoyhCUopAga6ig/pLBpWr1LAZK8R4UxY1pEnjgwBe0=;
	b=dygS277sBijKaOyrHcH3km/0c37wOg+zHNCkch6CggkKIcVuIPvC1NSJOh1LHld7LMitJ2
	MSC2BsD8mwQ2wr9fXFzFIVIo3UbJe8OBToS3n3BmJYESwjNzb7NljpJneUvxPN2kLWEJ4S
	CD8hdOD0cjAyYkxk6NNkH9HuVyMjLqU=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-434-SyNoZVHCNxuwAuccf06g6w-1; Tue,
 21 Jul 2026 15:24:17 -0400
X-MC-Unique: SyNoZVHCNxuwAuccf06g6w-1
X-Mimecast-MFC-AGG-ID: SyNoZVHCNxuwAuccf06g6w_1784661856
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B031B180ABF2;
	Tue, 21 Jul 2026 19:24:15 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 49C12180057E;
	Tue, 21 Jul 2026 19:24:15 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 66LJODKZ2497882
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 21 Jul 2026 15:24:14 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 66LJODkv2497881;
	Tue, 21 Jul 2026 15:24:13 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>, Cykang <cykang4830@gmail.com>
Subject: [PATCH v2] libmpathpersist: fix self-preemption when key has no active reservation
Date: Tue, 21 Jul 2026 15:24:13 -0400
Message-ID: <20260721192413.2497873-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: I1mKQZ3E_A7X5D5IK3gzAm9-YtcJ78w8K38oMXFNKyQ_1784661856
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

From: Cykang <cykang4830@gmail.com>

According to the SCSI-3 Persistent Reservations specification, when a
self-preemption is performed with a key that does not currently hold
an active reservation, the operation should be treated as an unregister
and should not fail.

The current code in do_mpath_persistent_reserve_out() does not check
whether the preempting key has a reservation before invoking the
self-preemption path. It unconditionally calls preempt_self() and
re-registers the key on the local paths, even when the key has no
reservation. This violates the SCSI-3 PR spec and can lead to
incorrect reservation states.

This patch moves the self-preemption check inside the conditional
block so that it only executes when the key matches, but does not
bypass the general preemption path for keys without a reservation.
With this change, the code will fall through to the common PR_OUT
handling (e.g., MPATH_PROUT_RES_SA or CLEAR_SA) when the key is not
reserved, allowing the storage target to properly process the
operation as an unregister.

Signed-off-by: Cykang <cykang4830@gmail.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathpersist/mpath_persist_int.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index 3091c5c2..97fc71a7 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -841,6 +841,7 @@ int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
 	bool unregistering, preempting_reservation = false;
 	bool updated_prkey = false;
 	bool failed_paths = false;
+	bool self_preempt_unreg = false;
 
 	ret = mpath_get_map(curmp, fd, &mpp);
 	if (ret != MPATH_PR_SUCCESS)
@@ -953,7 +954,10 @@ int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
 		break;
 	case MPATH_PROUT_PREE_SA:
 	case MPATH_PROUT_PREE_AB_SA:
-		if (reservation_key_matches(mpp, paramp->sa_key, NULL) == YNU_YES) {
+		ret = reservation_key_matches(mpp, paramp->sa_key, NULL);
+		if (ret == YNU_UNDEF)
+			return MPATH_PR_OTHER;
+		if (ret == YNU_YES) {
 			preempting_reservation = true;
 			if (memcmp(paramp->sa_key, &zerokey, 8) == 0) {
 				/* all registrants case */
@@ -961,13 +965,20 @@ int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
 						  rq_type, noisy);
 				break;
 			}
+			/* if we are preempting ourself */
+			if (memcmp(paramp->sa_key, paramp->key, 8) == 0) {
+				ret = preempt_self(mpp, rq_servact, rq_scope,
+						   rq_type, noisy, PREE_WORK_NONE);
+				break;
+			}
+		} else if (memcmp(paramp->sa_key, paramp->key, 8) == 0) {
+			/*
+			 * We are self-preempting, but we don't hold the
+			 * reservation. This will unregister the device
+			 */
+			self_preempt_unreg = true;
 		}
-		/* if we are preempting ourself */
-		if (memcmp(paramp->sa_key, paramp->key, 8) == 0) {
-			ret = preempt_self(mpp, rq_servact, rq_scope, rq_type,
-					   noisy, PREE_WORK_NONE);
-			break;
-		}
+
 		/* fallthrough */
 	case MPATH_PROUT_RES_SA:
 	case MPATH_PROUT_CLEAR_SA: {
@@ -1018,6 +1029,8 @@ int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
 	case MPATH_PROUT_PREE_AB_SA:
 		if (preempting_reservation)
 			update_prhold(mpp->alias, true);
+		else if (self_preempt_unreg)
+			update_prflag(mpp, 0);
 	}
 	return ret;
 }
-- 
2.53.0

