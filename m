Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C3913FE7
	for <dm-devel@lists.linux.dev>; Wed, 10 Sep 2025 22:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757545100; cv=none; b=FQ9PcytCSv5BEGKfoCH03qS5/65IPGsLkTOW4YpZFPKZYOyEaVbpt92IDpR8GzKbqMbdrptc16d89G+c9Elzz2hCx3OlN3AXy1gjeSZSDLPevu0zZFpRpYRftJILfKj7WTbWsARqBbcMY/flGVD2guesjUMn9Am/fIvN23yHj4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757545100; c=relaxed/simple;
	bh=YJyLXTKyA8TdPbarLrSA6auNX7+A8ObtIb8sABfiVo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=TyE8LBfE8nxQJo1h+7azzTWBHFNAKb+TTG/Ajw4E5pw6HHIcobWalMCv42W2e3kc5MapUDd67l3rD5EUouX1VkqXWyWrLInpqMB4sol7hLwrZkqR9vKrpTeeOWAAJGqoNpydw2Cl1jv84oMKRuW79k8hjKb3XpBG1XIuOf0G7BA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WufZw+4d; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WufZw+4d"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757545097;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vMS9X8T8/YOc5xYBFnDhcb1cFqxfJyr9GOn9MUcHOrs=;
	b=WufZw+4dFYgOWq2NtU/bQS41YCa1+L57mQVj5qdy5nlb3WccgtgMnc+CsN7Al04MUVxpE9
	WCqYq40G0AjXFdywLTqyywwuQmR/yEs9bGiJ/8ovp55HBdpdgFQ7aHuxuQVkvD8w+5oKTY
	f9nXhUjv7OxwEvCmuPg7mdYKTm8vKkQ=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-219-u6sLRWT6PAOoY2eTRju0Pg-1; Wed,
 10 Sep 2025 18:58:15 -0400
X-MC-Unique: u6sLRWT6PAOoY2eTRju0Pg-1
X-Mimecast-MFC-AGG-ID: u6sLRWT6PAOoY2eTRju0Pg_1757545095
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AF3051955F3D;
	Wed, 10 Sep 2025 22:58:14 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 586DB19560B8;
	Wed, 10 Sep 2025 22:58:14 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 58AMwDiQ829866
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 10 Sep 2025 18:58:13 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 58AMwDKI829865;
	Wed, 10 Sep 2025 18:58:13 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 2/2] libmpathpersist: handle preempting all registrants reservations
Date: Wed, 10 Sep 2025 18:58:12 -0400
Message-ID: <20250910225812.829847-3-bmarzins@redhat.com>
In-Reply-To: <20250910225812.829847-1-bmarzins@redhat.com>
References: <20250910225812.829847-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: bvcillFMKeRBEuAj0Fh8zkeh228ijiIz2qhYaH_Rgsw_1757545095
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

All Registrants reservations (types 7 and 8) are held by key 0x0. When
preempting one, all registrations are cleared, except for the one on the
path that issued the PREEMPT. libmpathpersist needs to handle this just
like the other cases of self-preemption, so that all the paths of the
preempting multipath device have their registrations restored while the
device is suspended.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathpersist/mpath_persist_int.c | 31 +++++++++++++++++++++++++----
 1 file changed, 27 insertions(+), 4 deletions(-)

diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index 9f301859..ab3d70cd 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -569,8 +569,9 @@ static int mpath_prout_reg(struct multipath *mpp,int rq_servact, int rq_scope,
  * is suspended before issuing the preemption, and the keys are reregistered
  * before resuming it.
  */
-static int preempt_self(struct multipath *mpp, int rq_servact, int rq_scope,
-			unsigned int rq_type, int noisy, bool do_release)
+static int do_preempt_self(struct multipath *mpp, struct be64 sa_key,
+			   int rq_servact, int rq_scope, unsigned int rq_type,
+			   int noisy, bool do_release)
 {
 	int status, rel_status = MPATH_PR_SUCCESS;
 	struct path *pp = NULL;
@@ -583,7 +584,7 @@ static int preempt_self(struct multipath *mpp, int rq_servact, int rq_scope,
 	}
 
 	memcpy(paramp.key, &mpp->reservation_key, 8);
-	memcpy(paramp.sa_key, &mpp->reservation_key, 8);
+	memcpy(paramp.sa_key, &sa_key, 8);
 	status = mpath_prout_common(mpp, rq_servact, rq_scope, rq_type,
 				    &paramp, noisy, &pp);
 	if (status != MPATH_PR_SUCCESS) {
@@ -619,6 +620,21 @@ fail_resume:
 	return (rel_status != MPATH_PR_SUCCESS) ? rel_status : status;
 }
 
+static int preempt_self(struct multipath *mpp, int rq_servact, int rq_scope,
+			unsigned int rq_type, int noisy, bool do_release)
+{
+	return do_preempt_self(mpp, mpp->reservation_key, rq_servact, rq_scope,
+			       rq_type, noisy, do_release);
+}
+
+static int preempt_all(struct multipath *mpp, int rq_servact, int rq_scope,
+		       unsigned int rq_type, int noisy)
+{
+	struct be64 zerokey = {0};
+	return do_preempt_self(mpp, zerokey, rq_servact, rq_scope, rq_type,
+			       noisy, false);
+}
+
 static int mpath_prout_rel(struct multipath *mpp,int rq_servact, int rq_scope,
 			   unsigned int rq_type,
 			   struct prout_param_descriptor * paramp, int noisy)
@@ -889,8 +905,15 @@ int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
 		break;
 	case MPATH_PROUT_PREE_SA:
 	case MPATH_PROUT_PREE_AB_SA:
-		if (reservation_key_matches(mpp, paramp->sa_key, noisy) == YNU_YES)
+		if (reservation_key_matches(mpp, paramp->sa_key, noisy) == YNU_YES) {
 			preempting_reservation = true;
+			if (memcmp(paramp->sa_key, &zerokey, 8) == 0) {
+				/* all registrants case */
+				ret = preempt_all(mpp, rq_servact, rq_scope,
+						  rq_type, noisy);
+				break;
+			}
+		}
 		/* if we are preempting ourself */
 		if (memcmp(paramp->sa_key, paramp->key, 8) == 0) {
 			ret = preempt_self(mpp, rq_servact, rq_scope, rq_type,
-- 
2.50.1

