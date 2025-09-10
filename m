Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22C425D1F7
	for <dm-devel@lists.linux.dev>; Wed, 10 Sep 2025 22:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757545100; cv=none; b=lzckhbGlhShOKkx/pg4TVSIhXbivgvxCLEwXUyXnqq7G8LLIGThvi4ngUSjnXwVHUtaG5loMBSb0wc6BoY1DKGknekmgWaRhfGl5RL26f0SObm9hT0O+uwtqjqp1f7x6QmQQg03HnLdTWMdND1ruIhrH3vpAJKaMutOt1GQ1ULg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757545100; c=relaxed/simple;
	bh=0xDZMvtAEz7XwYgDWRn0CuJ70lzFpuDa4zdPwJkCDp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=PXUleyLkdK4iAtBYfLkG749u0rGT7oIadQbTMjXMx7bc5nrd9uVZMywMdgQb7dCf8wlmf2hb9J9v4ONOwHvfXjs8wY/AVhs4vlyAwYRJQTR82dk+0RqmhOGPl4uz/KF6bIicxzltSRoTQIvGRFc7y0EWBncw0MxL23qdnxTmXVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MxmP/cOe; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MxmP/cOe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757545097;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EZz/u/NDwbxWs+qK2RPILWtr8lkBwJFE2owHV8+yMxU=;
	b=MxmP/cOe153McIM8UFRaAMWkOoA+2dm8FJES6U3nsfBpMEzBul2/pThWj4Htiz+zGGJGjn
	/42AYdB/bgu0Y6URe35dvMC/J0lV6NIsoBCiKmXD1zQPnKEVDoLvcQNtZD+QnX90HPbTFO
	KQ+Sq0Yprd0VV5czwCh2oiQNhkE9ZFc=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-219-XVAt8YhuMw2VOfJ6neWU7g-1; Wed,
 10 Sep 2025 18:58:15 -0400
X-MC-Unique: XVAt8YhuMw2VOfJ6neWU7g-1
X-Mimecast-MFC-AGG-ID: XVAt8YhuMw2VOfJ6neWU7g_1757545095
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D905618004D8;
	Wed, 10 Sep 2025 22:58:14 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5FCB81800447;
	Wed, 10 Sep 2025 22:58:14 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 58AMwCL4829862
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 10 Sep 2025 18:58:13 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 58AMwCsi829861;
	Wed, 10 Sep 2025 18:58:12 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 1/2] libmpathpersist: handle updating key race condition
Date: Wed, 10 Sep 2025 18:58:11 -0400
Message-ID: <20250910225812.829847-2-bmarzins@redhat.com>
In-Reply-To: <20250910225812.829847-1-bmarzins@redhat.com>
References: <20250910225812.829847-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 8FYas8CYGRW6vIhhXK6GNIddExIsiqYvOasgGS_rpv8_1757545095
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

If a multipath device's registered key is changed, mpathpersist needs
to update the key in multipathd before it registers the new key on the
paths. This means that there is a time when multipathd thinks the paths
should be using the new key, but none of them are. If a path is
restored after mpathpersist checks which paths are usable to set the
key on, but before it sets the key on any path, multipathd will see
that the new key is not registered on any paths, and think that the
key has been preempted or cleared. This will leave the path without
a key, and possibly make multipathd think the device does not hold
the reservation, even if it does.

To avoid this, multipathd will now remember the old key when registering
a new one. Once the registration is finished, and (un)setprstatus is
called, multipathd will forget the old key. Until then, multipathd will
check for either key when it looks to see if there is an existing key.
If the registration fails and the key get reverted, multipathd will
also forget the old key.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/prkey.c   | 16 ++++++++++++++--
 libmultipath/structs.h |  1 +
 multipathd/main.c      | 12 +++++++++++-
 3 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/libmultipath/prkey.c b/libmultipath/prkey.c
index c66d293b..4fbde5ad 100644
--- a/libmultipath/prkey.c
+++ b/libmultipath/prkey.c
@@ -222,10 +222,22 @@ int set_prkey(struct config *conf, struct multipath *mpp, uint64_t prkey,
 	}
 	else
 		ret = do_prkey(fd, mpp->wwid, NULL, PRKEY_WRITE);
-	if (ret == 0)
+	if (ret == 0) {
+		/*
+		 * If you are reverting back to the old key, because you
+		 * did not successfully set a new key, don't remember the
+		 * key you never successfully set.
+		 */
+		if (get_be64(mpp->old_pr_key) == prkey)
+			memset(&mpp->old_pr_key, 0, 8);
+		else
+			memcpy(&mpp->old_pr_key, &mpp->reservation_key, 8);
 		select_reservation_key(conf, mpp);
-	if (get_be64(mpp->reservation_key) != prkey)
+	}
+	if (get_be64(mpp->reservation_key) != prkey) {
+		memset(&mpp->old_pr_key, 0, 8);
 		ret = 1;
+	}
 out_file:
 	close(fd);
 out:
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index a206a7d1..9247e74f 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -520,6 +520,7 @@ struct multipath {
 	/* persistent management data*/
 	int prkey_source;
 	struct be64 reservation_key;
+	struct be64 old_pr_key;
 	uint8_t sa_flags;
 	int prflag;
 	int prhold;
diff --git a/multipathd/main.c b/multipathd/main.c
index 86d9a098..39d4f8cd 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -4249,6 +4249,7 @@ void set_pr(struct multipath *mpp)
 {
 	mpp->ever_registered_pr = true;
 	mpp->prflag = PR_SET;
+	memset(&mpp->old_pr_key, 0, 8);
 }
 
 void unset_pr(struct multipath *mpp)
@@ -4256,6 +4257,7 @@ void unset_pr(struct multipath *mpp)
 	mpp->prflag = PR_UNSET;
 	mpp->prhold = PR_UNSET;
 	mpp->sa_flags = 0;
+	memset(&mpp->old_pr_key, 0, 8);
 }
 
 /*
@@ -4308,7 +4310,15 @@ static int update_map_pr(struct multipath *mpp, struct path *pp)
 			dumpHex((char *)keyp, 8, 1);
 		}
 
-		if (!memcmp(&mpp->reservation_key, keyp, 8))
+		/*
+		 * If you are in the middle of updating a key (old_pr_key
+		 * is set) check for either the new key or the old key,
+		 * since you might be checking before any paths have
+		 * updated their keys.
+		 */
+		if (!memcmp(&mpp->reservation_key, keyp, 8) ||
+		    (get_be64(mpp->old_pr_key) &&
+		     !memcmp(&mpp->old_pr_key, keyp, 8)))
 			isFound = 1;
 	}
 
-- 
2.50.1

