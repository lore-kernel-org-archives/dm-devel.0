Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E9931578B
	for <dm-devel@lists.linux.dev>; Tue,  9 Sep 2025 00:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757376016; cv=none; b=Ki8oqGj+Dh7O9lTWHnhFbOhvSOYvUkHe6t6IfODfJlhO+vzhZv8NbJZzf9XsjMD7/de2VPAHwm31nBxvbL0/RqBB9Y+dGdNbBE5zix6bvTE1+FshhBBvMUT68ZF9OTB8TDUWNCz/Wwdn8LEJ2O3L0/dgohcW4OWagSgiZjyMkXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757376016; c=relaxed/simple;
	bh=5/NmuR4VI6Q+pEa/aUvcEUaDy5B2rvdczvSFVydvorg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=BVVzKcsbvTjThNBHpoJdlN1SDJbmKx92dNRy5EweqfqUoC8ERWbyLssCefWUIhmNmRWsTeeumBxzL0vJjgv780zKu8RuhP4cD5BJ5EVt1YEpSr4kw+JWMLwlhP35HYera9Uz+iAOaVPd1ZwxcpaR1KkcGqMaZ/4oc1Zd7QJgFuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=imzdF3fZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="imzdF3fZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757376013;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kmOQu/5+3rV6QAtLun29ik01d5We3m7cCdQEddMZhJc=;
	b=imzdF3fZqBBoRhFHpvzF4tybMzmh1WjGhQ9liEqj+dwjrZWvC0G3HOGgRjmEJcvsxFjZk1
	LLSg361tAVDqvSfJaifTvMWaBkERj1Eovf9rbY3K/Tra80GghqYzV8fufvCTwEEn6hSQNJ
	t2GQDvmSQ9GUd0dz0tl8bBqS/s5dq8M=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-657-IfHjgP5KNWKKahTeYKVf1Q-1; Mon,
 08 Sep 2025 20:00:10 -0400
X-MC-Unique: IfHjgP5KNWKKahTeYKVf1Q-1
X-Mimecast-MFC-AGG-ID: IfHjgP5KNWKKahTeYKVf1Q_1757376009
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0739E195608B;
	Tue,  9 Sep 2025 00:00:09 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B2D3A30001A4;
	Tue,  9 Sep 2025 00:00:08 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 589007bL751187
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 8 Sep 2025 20:00:07 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 589007MC751186;
	Mon, 8 Sep 2025 20:00:07 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 26/32] libmpathpersist: Restore old reservation key on failure
Date: Mon,  8 Sep 2025 19:59:56 -0400
Message-ID: <20250909000002.751039-27-bmarzins@redhat.com>
In-Reply-To: <20250909000002.751039-1-bmarzins@redhat.com>
References: <20250909000002.751039-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 7pS5epfxuGe5bj_f-JhV7a-wid9GNNyvaLKz7ff7fZM_1757376009
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

If we updated the key and then failed, restore the old key.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 libmpathpersist/mpath_persist_int.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index 3819c0d7..c575e3b5 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -731,8 +731,10 @@ int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
 	struct multipath *mpp;
 	int ret;
 	uint64_t zerokey = 0;
+	struct be64 oldkey = {0};
 	struct config *conf;
 	bool unregistering, preempting_reservation = false;
+	bool updated_prkey = false;
 
 	ret = mpath_get_map(curmp, pathvec, fd, &mpp);
 	if (ret != MPATH_PR_SUCCESS)
@@ -760,6 +762,8 @@ int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
 	      (!get_be64(mpp->reservation_key) ||
 	       memcmp(paramp->key, &zerokey, 8) == 0 ||
 	       memcmp(paramp->key, &mpp->reservation_key, 8) == 0)))) {
+		updated_prkey = true;
+		memcpy(&oldkey, &mpp->reservation_key, 8);
 		memcpy(&mpp->reservation_key, paramp->sa_key, 8);
 		if (update_prkey_flags(mpp->alias, get_be64(mpp->reservation_key),
 				       paramp->sa_flags)) {
@@ -826,8 +830,12 @@ int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
 		return MPATH_PR_OTHER;
 	}
 
-	if (ret != MPATH_PR_SUCCESS)
+	if (ret != MPATH_PR_SUCCESS) {
+		if (updated_prkey)
+			update_prkey_flags(mpp->alias, get_be64(oldkey),
+					   mpp->sa_flags);
 		return ret;
+	}
 
 	switch (rq_servact) {
 	case MPATH_PROUT_REG_SA:
-- 
2.50.1

