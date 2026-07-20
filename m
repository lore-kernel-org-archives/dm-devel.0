Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F4132470E
	for <dm-devel@lists.linux.dev>; Mon, 20 Jul 2026 21:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784584329; cv=none; b=N3AyxykpScwCUtYLPaKYMEj/q4AeJBR90UTZ5LBC8pGJ4txpD1zhEQLcEG1f8keIOHp41q4Xety5zKezjYraV8y1wg2qqalKkBz+peQTwE7rVC9PKZrebbaEYWLCu41l2CMZeoOS1ju/ERmzxnBjAZrNMO2brqdxZeif0Ts6Ieo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784584329; c=relaxed/simple;
	bh=6I7lxGzLcjPnuV0sTZmnmmrx70mZsOfDoU+Uq7yYNx0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=PwEy0wCmVQRJtgG5BBfDU6PvIntnl+J1dRH7d7QpQDAlRUFcGZhTKyn1/H9sn9ms8NR8nKMqffRQZytR1x8RLLvDOAYJjd7XGixWaahkiS2CwSGHvJjYVfDmpDSmDdnJoR2/ONlQe4xM1f4t8P+GTb7if+HNM9SOTzg830App4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LM98XtNw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LM98XtNw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784584326;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=mH4y+y7LieqzWZOukXvc3LBne+MRgR2CzXt695TG3fc=;
	b=LM98XtNwQt/qBEZV2S/LCvQN+AcMGVskpskRERPWvq7KAnHKeC9m4K3kvUeJT1oRllrZpG
	TUF3F0BdwKf+2A//Ihalew6SHQMo1idEaOjJRmfMO36lZr5Ti5exmhAwE5NSZBLLHG9/BJ
	6XUbJUaWM5Nz+C8lHPfBk4Uv2ljrIiQ=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-623-msCJtpQVOzOot03wTlv5GA-1; Mon,
 20 Jul 2026 17:52:03 -0400
X-MC-Unique: msCJtpQVOzOot03wTlv5GA-1
X-Mimecast-MFC-AGG-ID: msCJtpQVOzOot03wTlv5GA_1784584322
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F3ED5180266A;
	Mon, 20 Jul 2026 21:52:01 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A9DF3195422F;
	Mon, 20 Jul 2026 21:52:01 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 66KLq0VN2464161
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 20 Jul 2026 17:52:00 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 66KLq05C2464160;
	Mon, 20 Jul 2026 17:52:00 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>, Cykang <cykang4830@gmail.com>
Subject: [PATCH] libmpathpersist: fix self-preemption when key has no active reservation
Date: Mon, 20 Jul 2026 17:52:00 -0400
Message-ID: <20260720215200.2464152-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 5_BZQLrSnTlIrPRpBoKotcE-1BHtosWF9X0rR2cALXw_1784584322
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
 libmpathpersist/mpath_persist_int.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index 3091c5c2..6ca3b97d 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -841,6 +841,7 @@ int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
 	bool unregistering, preempting_reservation = false;
 	bool updated_prkey = false;
 	bool failed_paths = false;
+	bool self_preempt_unreg = false;
 
 	ret = mpath_get_map(curmp, fd, &mpp);
 	if (ret != MPATH_PR_SUCCESS)
@@ -961,13 +962,20 @@ int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
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
@@ -1018,6 +1026,8 @@ int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
 	case MPATH_PROUT_PREE_AB_SA:
 		if (preempting_reservation)
 			update_prhold(mpp->alias, true);
+		else if (self_preempt_unreg)
+			update_prflag(mpp, 0);
 	}
 	return ret;
 }
-- 
2.46.1

