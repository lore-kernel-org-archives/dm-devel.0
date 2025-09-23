Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AB3D30CDBA
	for <dm-devel@lists.linux.dev>; Tue, 23 Sep 2025 22:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758665585; cv=none; b=Tnl85bFzzEi+5GBY3Eb8UsaxCbRW6r4VvSNL+beVpwAg9BuJYikwiOGmO3SugLDNBB8sjnCLOFWonYQtntcrAUg7ULPPADNVKgX/Eq1/lxYnL9iezGHH3xrcOOA7GjVo/m5xtrsL2LIeN713OOGA4EtIhd7AM1bmfLO0Ag+8tMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758665585; c=relaxed/simple;
	bh=88DjeYYimU2IcJK+SGNrQrZ7Pxb/JFFZHUrQnhydS7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=av0i6wkckA+vCdJlo7j9Sx6m//S2mb85/jcNGWeY4l0auzIF39MB6/PzGFPz5SmeXT3b7OWZRbvHQp9+2VZ69XGBwXCwo1CWa42awp0T4l0i9cQW7FDDQn7l40LnjcujmiYg6bCWboZnqjVcoalh6Xl1Xx+yz6p3WKiVdAJvqFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cA9j2nN6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cA9j2nN6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758665581;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2ABUCFPEuazzp7dCYIPD9OKHtA0CgTkelJyCKRcJRl0=;
	b=cA9j2nN67mtiuIjrhjvUDcYrM1I17tks1w0n6tIf8/TZ5wFTOZ/EE7/kQr21urJ4ZBaPy7
	SMLxvI1UftfUJd3IH4xu5vFS+T83ACnsTI+PfP1Nqmi0D7PN7quGF0rS+eEvtoWhEDekRm
	+1qvDQlsP+1EZrq61i4/nfuoqnlc150=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-202-fj0iUMg9Mwuh-1y5-TaADA-1; Tue,
 23 Sep 2025 18:12:56 -0400
X-MC-Unique: fj0iUMg9Mwuh-1y5-TaADA-1
X-Mimecast-MFC-AGG-ID: fj0iUMg9Mwuh-1y5-TaADA_1758665575
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6ECA118004D4;
	Tue, 23 Sep 2025 22:12:54 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EBB3C19560B8;
	Tue, 23 Sep 2025 22:12:53 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 58NMCqT01411704
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 23 Sep 2025 18:12:52 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 58NMCqtf1411703;
	Tue, 23 Sep 2025 18:12:52 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 1/4] libmpathpersist: Fix REGISTER AND IGNORE while holding a reservation
Date: Tue, 23 Sep 2025 18:12:49 -0400
Message-ID: <20250923221252.1411687-2-bmarzins@redhat.com>
In-Reply-To: <20250923221252.1411687-1-bmarzins@redhat.com>
References: <20250923221252.1411687-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: LwRHsD_wsBEnVSKaZNnT5Nby9m3vqHz8QB3J75lycdk_1758665575
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

