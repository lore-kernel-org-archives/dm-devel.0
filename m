Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C7830C626
	for <dm-devel@lists.linux.dev>; Fri, 26 Sep 2025 17:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758907744; cv=none; b=fZugTeEg4+GUoIKhU4lpKp/GQ37rd7adj87Dn88GqTM5LoTw+IdldPg2CB+71IINeBqtoONd13BfM9sVBkHV7u/PEifKfKvZm59PaFxNrqbl6Uwj7Y7vdytMeQAuOeNbsDOMaWlP0iOYpwQ4cRo7F4Q7Vc7VKWMml/zzso5cmu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758907744; c=relaxed/simple;
	bh=88DjeYYimU2IcJK+SGNrQrZ7Pxb/JFFZHUrQnhydS7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=eFXQ4Ln4F32YyqFOoeniJvO3tB3AEVqvyXpIqfmrdFJFFHgkkszB1TkxHc+pHTSk2A78dyzgxtEp1NZ8ChlPQ5qhz55s3Yj/QSqba1Smulj/MChHMZcZNajIe92nvn5+BawEv1WIsEos9bwj0A3qplwZuhFHD5oF4HKhc+kAGFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dbolzSKL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dbolzSKL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758907740;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2ABUCFPEuazzp7dCYIPD9OKHtA0CgTkelJyCKRcJRl0=;
	b=dbolzSKLuCTSZmnzQMaSzgZgtGEBzOWPlNJlywPtCwLdS9NqO1DOgAxwjGvHrV/Wsdjn+3
	kaMfXozOe/qk0IWdFFoA5AI/xX301/2TbymVSnN+NkBdBVaWT47Q7y2n+WdE41SDngap5d
	8RNtV57pKU04yebaf7ks/2dO9zEtvlc=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-651-BPt58UPoNq2fyCAxA4_-7Q-1; Fri,
 26 Sep 2025 13:28:57 -0400
X-MC-Unique: BPt58UPoNq2fyCAxA4_-7Q-1
X-Mimecast-MFC-AGG-ID: BPt58UPoNq2fyCAxA4_-7Q_1758907736
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8013B1800451;
	Fri, 26 Sep 2025 17:28:56 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 416EE30001BD;
	Fri, 26 Sep 2025 17:28:56 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 58QHSsuT1548368
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 26 Sep 2025 13:28:54 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 58QHSsf81548367;
	Fri, 26 Sep 2025 13:28:54 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 1/4] libmpathpersist: Fix REGISTER AND IGNORE while holding a reservation
Date: Fri, 26 Sep 2025 13:28:51 -0400
Message-ID: <20250926172854.1548351-2-bmarzins@redhat.com>
In-Reply-To: <20250926172854.1548351-1-bmarzins@redhat.com>
References: <20250926172854.1548351-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _az3TSePHS8oWu6kUjmKwDpmexOz4JVnKlOsCbhFbLg_1758907736
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

If a device that is holding a reservation changes its registered key,
but the path holding the reservation is unavailable, libmpathpersist
must preempt the old key to update the reservation. If the key is
changed using REGISTER AND IGNORE, set_ignored_key() determines the old
key to preempt. Unfortunately, commit 165427dda broke it, by comparing
the wrong key against the actual reservation key. Then commit cf0eea85
broke it more, by using mpp->reservation_key after it had been updated,
so it was no longer the old key. Fix this by correctly comparing the old
key against the actual reservation key.

Fixes: 165427dda ("libmpathpersist: Add safety check for preempting on key change")
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathpersist/mpath_persist_int.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index ab3d70cd..476c3433 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -791,16 +791,17 @@ static int reservation_key_matches(struct multipath *mpp, uint8_t *key, int nois
  * currently registered key for use in preempt_missing_path(), but only if
  * the key is holding the reservation.
  */
-static void set_ignored_key(struct multipath *mpp, uint8_t *key)
+static void set_ignored_key(struct multipath *mpp, uint8_t *curr_key,
+			    uint8_t *key)
 {
 	memset(key, 0, 8);
-	if (!get_be64(mpp->reservation_key))
+	if (memcmp(curr_key, key, 8) == 0)
 		return;
 	if (get_prhold(mpp->alias) == PR_UNSET)
 		return;
-	if (reservation_key_matches(mpp, key, 0) == YNU_NO)
+	if (reservation_key_matches(mpp, curr_key, 0) == YNU_NO)
 		return;
-	memcpy(key, &mpp->reservation_key, 8);
+	memcpy(key, curr_key, 8);
 }
 
 int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
@@ -824,6 +825,7 @@ int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
 	select_reservation_key(conf, mpp);
 	put_multipath_config(conf);
 
+	memcpy(&oldkey, &mpp->reservation_key, 8);
 	unregistering = (memcmp(&zerokey, paramp->sa_key, 8) == 0);
 	if (mpp->prkey_source == PRKEY_SOURCE_FILE &&
 	    (rq_servact == MPATH_PROUT_REG_IGN_SA ||
@@ -832,7 +834,6 @@ int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
 	       memcmp(paramp->key, &zerokey, 8) == 0 ||
 	       memcmp(paramp->key, &mpp->reservation_key, 8) == 0)))) {
 		updated_prkey = true;
-		memcpy(&oldkey, &mpp->reservation_key, 8);
 		memcpy(&mpp->reservation_key, paramp->sa_key, 8);
 		if (update_prkey_flags(mpp->alias, get_be64(mpp->reservation_key),
 				       paramp->sa_flags)) {
@@ -895,7 +896,7 @@ int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
 	put_multipath_config(conf);
 
 	if (rq_servact == MPATH_PROUT_REG_IGN_SA)
-		set_ignored_key(mpp, paramp->key);
+		set_ignored_key(mpp, (uint8_t *)&oldkey, paramp->key);
 
 	switch(rq_servact)
 	{
-- 
2.50.1

