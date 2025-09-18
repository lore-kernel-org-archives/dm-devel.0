Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3E19CA52
	for <dm-devel@lists.linux.dev>; Thu, 18 Sep 2025 13:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758203343; cv=none; b=I+XR2KmPPMa7vqFp4ZXGF5TsCwVZ0TjjcWKq2GhOE4vhB8Fv5ngoprD0ory+B4knV0j1J+So3d/6jChMps8u2wtKaLTa81Gk+iqbqVpQ6UHSgmajUGM9X05RUgNCaHWAEuYIUzsE6URA+rvpVt0RFWEyZj4hpJNy5TrmDCA/e5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758203343; c=relaxed/simple;
	bh=FAth7ZYw0bF0MS2aisxKvKibyCQoWr5Qe2Ky9Q5qySw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=RV1AHmITPUk527A8JzTI68L+kpq3vj2hyk6fedc+0i4CrGR7iURvez0t0OwaLV6mgxOjWqLj5N8xNvm2ccqOXkHdlaCiTB2NOPuKtUa9zCBLB8LUt9/Z2E4OcHukM8MtWHoTNeo/4Ka2DlPEqP47MKtZG6B8x1JeamP+t0QsBRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=X4+KXyp7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X4+KXyp7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758203339;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QZ0NSgnWvyoB3fm+mi5BZQR6S6ktKbEEGKzPWcq34Oo=;
	b=X4+KXyp7zXmJES9yfmQ8ZEH0Xb/pSkY8aviIhRehsO7j1EVGjnsXp6uEheqRea/lFCdRPQ
	r8D1Q17lyrikDtOkm0V0qaG6vE/cCfSer6gBfM+mbC140Lo/cKgZI0XrTENdv6SPjCcNJh
	OlWnJo5o4NZPbBYuUjTAqeS4fGiR6yg=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-287-VEbkz268PtSNe4EfVQZOLQ-1; Thu,
 18 Sep 2025 09:48:58 -0400
X-MC-Unique: VEbkz268PtSNe4EfVQZOLQ-1
X-Mimecast-MFC-AGG-ID: VEbkz268PtSNe4EfVQZOLQ_1758203338
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C7F7219560B0
	for <dm-devel@lists.linux.dev>; Thu, 18 Sep 2025 13:48:57 +0000 (UTC)
Received: from o.redhat.com (unknown [10.45.225.144])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 71B531955F2D;
	Thu, 18 Sep 2025 13:48:56 +0000 (UTC)
From: Heinz Mauelshagen <heinzm@redhat.com>
To: dm-devel@lists.linux.dev
Cc: mpatocka@redhat.com,
	Heinz Mauelshagen <heinzm@redhat.com>
Subject: [PATCH] dm raid: use proper md_ro_state enumerators
Date: Thu, 18 Sep 2025 15:48:40 +0200
Message-ID: <e14e3358a3b0acc015c01c61e6471e622a2dbe8f.1758201368.git.heinzm@redhat.com>
In-Reply-To: <cover.1758201368.git.heinzm@redhat.com>
References: <cover.1758201368.git.heinzm@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: h6JU1sjzJgmukhY-j5OaI0pfq-dsvvuu_809Pqf2B_I_1758203338
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

The dm-raid code was using hardcoded integer values to represent the read-only/read-write state
of RAID arrays instead of the proper enumeration constants defined in the md_ro_state enumerator type.

Changes:

- Replace hardcoded integers with the appropriate md_ro_state enumerator values

- Add the missing MD_RDONLY setting in the post_suspend function

This improves code clarity and maintainability by using the defined enumeration constants
rather than magic numbers, ensuring the code properly conforms to the established API interface.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 79ea85d18e24..6cdfd7ca998c 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3247,7 +3247,7 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	rs_reset_inconclusive_reshape(rs);
 
 	/* Start raid set read-only and assumed clean to change in raid_resume() */
-	rs->md.ro = 1;
+	rs->md.ro = MD_RDONLY;
 	rs->md.in_sync = 1;
 
 	/* Has to be held on running the array */
@@ -3385,7 +3385,7 @@ static enum sync_state decipher_sync_action(struct mddev *mddev, unsigned long r
 	/* The MD sync thread can be done with io or be interrupted but still be running */
 	if (!test_bit(MD_RECOVERY_DONE, &recovery) &&
 	    (test_bit(MD_RECOVERY_RUNNING, &recovery) ||
-	     (!mddev->ro && test_bit(MD_RECOVERY_NEEDED, &recovery)))) {
+	     (md_is_rdwr(mddev) && test_bit(MD_RECOVERY_NEEDED, &recovery)))) {
 		if (test_bit(MD_RECOVERY_RESHAPE, &recovery))
 			return st_reshape;
 
@@ -3775,11 +3775,11 @@ static int raid_message(struct dm_target *ti, unsigned int argc, char **argv,
 		} else
 			return -EINVAL;
 	}
-	if (mddev->ro == 2) {
+	if (mddev->ro == MD_AUTO_READ) {
 		/* A write to sync_action is enough to justify
 		 * canceling read-auto mode
 		 */
-		mddev->ro = 0;
+		mddev->ro = MD_RDWR;
 		if (!mddev->suspended)
 			md_wakeup_thread(mddev->sync_thread);
 	}
@@ -3858,6 +3858,7 @@ static void raid_postsuspend(struct dm_target *ti)
 		 */
 		md_stop_writes(&rs->md);
 		mddev_suspend(&rs->md, false);
+		rs->md.ro = MD_RDONLY;
 	}
 }
 
@@ -3968,7 +3969,7 @@ static void rs_update_sbs(struct raid_set *rs)
 	int ro = mddev->ro;
 
 	set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
-	mddev->ro = 0;
+	mddev->ro = MD_RDWR;
 	md_update_sb(mddev, 1);
 	mddev->ro = ro;
 }
@@ -4125,7 +4126,7 @@ static void raid_resume(struct dm_target *ti)
 		WARN_ON_ONCE(rcu_dereference_protected(mddev->sync_thread,
 						       lockdep_is_held(&mddev->reconfig_mutex)));
 		clear_bit(RT_FLAG_RS_FROZEN, &rs->runtime_flags);
-		mddev->ro = 0;
+		mddev->ro = MD_RDWR;
 		mddev->in_sync = 0;
 		md_unfrozen_sync_thread(mddev);
 		mddev_unlock_and_resume(mddev);
-- 
2.51.0

