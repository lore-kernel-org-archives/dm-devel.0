Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9722F635
	for <dm-devel@lists.linux.dev>; Sat, 26 Jul 2025 03:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753502347; cv=none; b=a5kF8kHri7DSAVN3Zo1jn7ljxtc2BgRmj0865HhxKNNV9oyVmsCcre5d5xNNaCOMeYAnM9V1mwdt6eKLNV1Vxbfa7uDEVLIhUlCbx+HbC3J6JDb/20IfdfXDcpA9bs5dGvQwrzfX2g2Ns9Sem5+4d83d/9rpmisLwr9/8/mzghQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753502347; c=relaxed/simple;
	bh=l8ZoxmXcsSzNPOS4H7iA6Ajaqf7ca0Q4/mOxvxy23VM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=bkSjHlRZpVEvhr3WCQcpWPyeO1rJAoNlIFjRcf6vGm3iwAtZ6wKwmUThngzsynAMI3ZgajUsdKygsI4fGdBy5vwmp6AFrfqsBM8aEQocVsHcX3N4HBmjHT/iLBUb/h+OD4BNH1nz5viy7TuDbYMbLAPKcOGpbRF+tHphaq38a/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SqWZOLjC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SqWZOLjC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753502344;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GorHHnBoslYpDU1EUtcjvtxLU+P3LcnXxxEjp9u9Ang=;
	b=SqWZOLjCT8FTBHSdEaecxMYM0EzSo91NLDK7N7gq1gG02SyqqYovDfLVccZIMOFDbinQmS
	PpWYO6vtRkMsxMEUf8mv9BqaxubNstCcvH3dus7n3yN2mWeTXN6uiVnvSn8rev/3UpPAfP
	OM62n623XNwXp9EcNRDoFI34BCiIgO0=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-201-b4uGhBUAOxWAANFO8inoIg-1; Fri,
 25 Jul 2025 23:59:00 -0400
X-MC-Unique: b4uGhBUAOxWAANFO8inoIg-1
X-Mimecast-MFC-AGG-ID: b4uGhBUAOxWAANFO8inoIg_1753502339
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C4D04180034C;
	Sat, 26 Jul 2025 03:58:59 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8641D1966665;
	Sat, 26 Jul 2025 03:58:59 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 56Q3ww4r363357
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 25 Jul 2025 23:58:58 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 56Q3wwv6363356;
	Fri, 25 Jul 2025 23:58:58 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 11/14] libmpathpersist: Restore old reservation key on failure
Date: Fri, 25 Jul 2025 23:58:52 -0400
Message-ID: <20250726035855.363290-12-bmarzins@redhat.com>
In-Reply-To: <20250726035855.363290-1-bmarzins@redhat.com>
References: <20250726035855.363290-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6j4bKDZqlbv3CXVedE2ZVK8H3yOH0ghsDXRlft-zQG8_1753502339
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

If we updated the key and then failed, restore the old key.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathpersist/mpath_persist_int.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index f901b955..ca3dab5c 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -729,8 +729,10 @@ int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
 	struct multipath *mpp;
 	int ret;
 	uint64_t zerokey = 0;
+	struct be64 oldkey = {0};
 	struct config *conf;
 	bool unregistering, preempting_reservation = false;
+	bool updated_prkey = false;
 
 	ret = mpath_get_map(curmp, pathvec, fd, &mpp);
 	if (ret != MPATH_PR_SUCCESS)
@@ -753,6 +755,8 @@ int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
 	      (!get_be64(mpp->reservation_key) ||
 	       memcmp(paramp->key, &zerokey, 8) == 0 ||
 	       memcmp(paramp->key, &mpp->reservation_key, 8) == 0)))) {
+		updated_prkey = true;
+		memcpy(&oldkey, &mpp->reservation_key, 8);
 		memcpy(&mpp->reservation_key, paramp->sa_key, 8);
 		if (update_prkey_flags(mpp->alias, get_be64(mpp->reservation_key),
 				       paramp->sa_flags)) {
@@ -818,8 +822,12 @@ int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
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
2.48.1

