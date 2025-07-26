Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E85781F150A
	for <dm-devel@lists.linux.dev>; Sat, 26 Jul 2025 03:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753502350; cv=none; b=H55InrVANCEHREZm5zxNPi6sTrrGaGDNB41MRWesp9M8A9D793cWhwXqiaikhBKZEyLDdntGSDgcsYdnvCVJWObVgpXHY6lGafdIJHs0evG10qlGAwBSmaxBG+4jfE7m0hTmuTO+nyGW6VOdrD136stuyIEs2tKy6VgLhoJ4w0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753502350; c=relaxed/simple;
	bh=MB5fSTKCppRp4ye7k8yNk0jW05+ildYQqVAebsmZQjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=IuSWR9tlOCAEmJ9qAwRjKjT3gfSlfZF+0EBMIo0jV8Y6DL7XQn5Rl/lL3mKA4CthHBoOIyGAmON/UeNh7NQTkdAHQLcOmhmtx1qgQRVIz2/P0RWg5xwxwYtG7opPltYns/uVdyoHrPXd0k9rIp89ld4aUi6iBMhzHd/fNN4ZJaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D5NexbWM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D5NexbWM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753502344;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2USVvVMkgbKcFuf5ESHV2SyKbdbVD+N1Wl6REDypTWQ=;
	b=D5NexbWMi1ig8P1qOfvS93sn9WxrpO0vF4RLc+/WPD+QlVJjFDuSU+JdncNDOxjae7YeGj
	HwABb2Ohg//qftATycecti4Cvr5ZrEIEzO5p2Iq7HO/CAIDeGXche6ZYKTIxVTnAdiADlO
	qH4lSVQrcesfGpZjpQmsTLuft5GF/Lk=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-322-YO9pR4aFMnSEyE4JBDZb3A-1; Fri,
 25 Jul 2025 23:59:00 -0400
X-MC-Unique: YO9pR4aFMnSEyE4JBDZb3A-1
X-Mimecast-MFC-AGG-ID: YO9pR4aFMnSEyE4JBDZb3A_1753502339
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3FFE0195608F;
	Sat, 26 Jul 2025 03:58:59 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EED731966665;
	Sat, 26 Jul 2025 03:58:58 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 56Q3wvcw363341
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 25 Jul 2025 23:58:57 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 56Q3wvqB363340;
	Fri, 25 Jul 2025 23:58:57 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 07/14] libmpathpersist: Fix-up reservation_key checking
Date: Fri, 25 Jul 2025 23:58:48 -0400
Message-ID: <20250726035855.363290-8-bmarzins@redhat.com>
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
X-Mimecast-MFC-PROC-ID: HIAJE8fXVw3FQzY7l2hMaqPHioJvOnOGNzXIIshNwAk_1753502339
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

The reservation key checking in do_mpath_persistent_reserve_out() was
slightly wrong. It allowed invalid keys for preempting. It now correctly
checks the reservation key for the preempt commands.

It also was a little overly strict in some places. Formerly, it only
allowed registering from any key to the configured key or registering
from the configured key to any key (as long as you use the prkeys file).
Now it also allows unregistering from any key and registering an
unregistered device to any key (as long as you use the prkeys file).

Also, clarify the code by replacing prkey with a bool tracking if you
are registering or unregistering.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathpersist/mpath_persist_int.c | 52 ++++++++++++++++++++---------
 1 file changed, 36 insertions(+), 16 deletions(-)

diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index c6b2e788..71933fe5 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -709,9 +709,9 @@ int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
 {
 	struct multipath *mpp;
 	int ret;
-	uint64_t prkey;
+	uint64_t zerokey = 0;
 	struct config *conf;
-	bool preempting_reservation = false;
+	bool unregistering, preempting_reservation = false;
 
 	ret = mpath_get_map(curmp, pathvec, fd, &mpp);
 	if (ret != MPATH_PR_SUCCESS)
@@ -727,11 +727,12 @@ int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
 	if (rq_servact == MPATH_PROUT_REG_IGN_SA)
 		set_ignored_key(mpp, paramp->key);
 
-	memcpy(&prkey, paramp->sa_key, 8);
-	if (mpp->prkey_source == PRKEY_SOURCE_FILE && prkey &&
+	unregistering = (memcmp(&zerokey, paramp->sa_key, 8) == 0);
+	if (mpp->prkey_source == PRKEY_SOURCE_FILE && !unregistering &&
 	    (rq_servact == MPATH_PROUT_REG_IGN_SA ||
 	     (rq_servact == MPATH_PROUT_REG_SA &&
 	      (!get_be64(mpp->reservation_key) ||
+	       memcmp(paramp->key, &zerokey, 8) == 0 ||
 	       memcmp(paramp->key, &mpp->reservation_key, 8) == 0)))) {
 		memcpy(&mpp->reservation_key, paramp->sa_key, 8);
 		if (update_prkey_flags(mpp->alias, get_be64(mpp->reservation_key),
@@ -742,19 +743,38 @@ int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
 		}
 	}
 
-	if (!get_be64(mpp->reservation_key) &&
-	    (prkey || rq_servact != MPATH_PROUT_REG_IGN_SA)) {
-		condlog(0, "%s: no configured reservation key", mpp->alias);
-		return MPATH_PR_SYNTAX_ERROR;
+	/*
+	 * If you are registering a non-zero key, mpp->reservation_key
+	 * must be set and must equal paramp->sa_key.
+	 * If you're not registering a key, mpp->reservation_key must be
+	 * set, and must equal paramp->key
+	 */
+	if ((rq_servact == MPATH_PROUT_REG_IGN_SA ||
+	     rq_servact == MPATH_PROUT_REG_SA)) {
+		if (!unregistering && !get_be64(mpp->reservation_key)) {
+			condlog(0, "%s: no configured reservation key",
+				mpp->alias);
+			return MPATH_PR_SYNTAX_ERROR;
+		}
+		if (!unregistering &&
+		    memcmp(paramp->sa_key, &mpp->reservation_key, 8)) {
+			condlog(0, "%s: configured reservation key doesn't match: 0x%" PRIx64,
+				mpp->alias, get_be64(mpp->reservation_key));
+			return MPATH_PR_SYNTAX_ERROR;
+		}
+	} else {
+		if (!get_be64(mpp->reservation_key)) {
+			condlog(0, "%s: no configured reservation key",
+				mpp->alias);
+			return MPATH_PR_SYNTAX_ERROR;
+		}
+		if (memcmp(paramp->key, &mpp->reservation_key, 8)) {
+			condlog(0, "%s: configured reservation key doesn't match: 0x%" PRIx64,
+				mpp->alias, get_be64(mpp->reservation_key));
+			return MPATH_PR_SYNTAX_ERROR;
+		}
 	}
 
-	if (memcmp(paramp->key, &mpp->reservation_key, 8) &&
-	    memcmp(paramp->sa_key, &mpp->reservation_key, 8) &&
-	    (prkey || rq_servact != MPATH_PROUT_REG_IGN_SA)) {
-		condlog(0, "%s: configured reservation key doesn't match: 0x%" PRIx64,
-			mpp->alias, get_be64(mpp->reservation_key));
-		return MPATH_PR_SYNTAX_ERROR;
-	}
 
 	switch(rq_servact)
 	{
@@ -785,7 +805,7 @@ int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
 	switch (rq_servact) {
 	case MPATH_PROUT_REG_SA:
 	case MPATH_PROUT_REG_IGN_SA:
-		if (prkey == 0) {
+		if (unregistering) {
 			update_prflag(mpp->alias, 0);
 			update_prkey(mpp->alias, 0);
 		} else
-- 
2.48.1

