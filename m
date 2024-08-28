Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E213F1ABEC4
	for <dm-devel@lists.linux.dev>; Wed, 28 Aug 2024 22:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724883488; cv=none; b=iNK4pQwpGlmTCeqxDq05t/bK3GKQ/4/EpZeNdDOddoXYxQJLuMjV2nrvkScw6p4h4MtinuVWx8h4gN5xq4+viYFVuloMAWXWt9Z/k4wFnnGZtn57M281DoRtstNF+4969jyX3dC1v1yc3mfS9aPxqjivKuLKag5q2Nd8b1bVDfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724883488; c=relaxed/simple;
	bh=FSFxIQmxMVDek0Kir2bS5cIDqEmG36GzPM1EMqATk1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hPhvWZwmtpXWlLDDVwmEvJVEmhxHj/k5SfB8oaX1ExCdWLSqkGlTCR9QiPq1/580Qjjgx+tELAh9qn6M7e/NW6jnlEHrhJklFNonDGZ2xdSe4luMrzIq2f4tzm/TTcjsOVvLX7EsEtRSQVxUrf3DLw7+6ThJfS1qDAUlu3kvZGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PxuCgEyS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PxuCgEyS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724883485;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gt87kqx4x7o4ex8XeeEQV3UVFF8xDrcO99vUmQlCTCg=;
	b=PxuCgEySyAyljKIL+eacfk6nwgkfPWk8Y47j2u8dgDqaeopwXnyN0M53kd2csiAMBwbR/G
	UywW69WKaloDecSeS5PA8FHmaMriNjERD4tpqDkGNs21lbm3VWN9CT7F53qB6G9kilqxbF
	DAEwg8ka+yGxa3iJY4yHNSbYhv/Cm34=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-294-EUGuGEt1OnGzh89M65DB6w-1; Wed,
 28 Aug 2024 18:18:02 -0400
X-MC-Unique: EUGuGEt1OnGzh89M65DB6w-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9B8171955BEF;
	Wed, 28 Aug 2024 22:18:01 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1F4A11955F1B;
	Wed, 28 Aug 2024 22:18:01 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 47SMHx884060628
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 28 Aug 2024 18:17:59 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 47SMHx9S4060627;
	Wed, 28 Aug 2024 18:17:59 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 14/15] multipathd: remove pointless check
Date: Wed, 28 Aug 2024 18:17:56 -0400
Message-ID: <20240828221757.4060548-15-bmarzins@redhat.com>
In-Reply-To: <20240828221757.4060548-1-bmarzins@redhat.com>
References: <20240828221757.4060548-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Since we just returned if newstate wasn't PATH_UP or PATH_GHOST, it
must obviously be PATH_UP or PATH_GHOST at this point in the code. We
don't even wrap all the code for dealing with a path that just came up
in this if-block, It's only the persistent resrvation code.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 1511f701..f9b0ebaf 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2545,19 +2545,19 @@ update_path_state (struct vectors * vecs, struct path * pp)
 			return CHECK_PATH_CHECKED;
 		}
 
-		if (newstate == PATH_UP || newstate == PATH_GHOST) {
-			if (pp->mpp->prflag != PRFLAG_UNSET) {
-				int prflag = pp->mpp->prflag;
-				/*
-				 * Check Persistent Reservation.
-				 */
-				condlog(2, "%s: checking persistent "
-					"reservation registration", pp->dev);
-				mpath_pr_event_handle(pp);
-				if (pp->mpp->prflag == PRFLAG_SET &&
-				    prflag != PRFLAG_SET)
-					pr_register_active_paths(pp->mpp);
-			}
+		/* newstate == PATH_UP || newstate == PATH_GHOST */
+
+		if (pp->mpp->prflag != PRFLAG_UNSET) {
+			int prflag = pp->mpp->prflag;
+			/*
+			 * Check Persistent Reservation.
+			 */
+			condlog(2, "%s: checking persistent "
+				"reservation registration", pp->dev);
+			mpath_pr_event_handle(pp);
+			if (pp->mpp->prflag == PRFLAG_SET &&
+			    prflag != PRFLAG_SET)
+				pr_register_active_paths(pp->mpp);
 		}
 
 		/*
-- 
2.45.0

