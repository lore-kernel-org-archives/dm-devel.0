Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A40424266AF
	for <dm-devel@lists.linux.dev>; Wed, 21 Jan 2026 21:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769029403; cv=none; b=WwXG+nPYv6CGuGWeaQ9x0qmR/d+Y0Z35h1ehw1lGaRwenYrwxmr1SNta7hYLFlmt4iYrTe3EIRsbDGKQB1aKNmuU0OAF9aPV7Y7Cr2qRi6ayr2SsglukwR87QixDNEHZId0bANezfY+Sqy49X8ui+MejSsSAt0DsVIs0w0eV/cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769029403; c=relaxed/simple;
	bh=1CIP8MmBR9opxQtbKWQfjUKVH57T3TUXIUG0zXtd3xM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=LZdti0zH9AfhFIqr2IoNFsU2Ag0+nK/CNisRHwoGFqQox2iGn0ii+v0MvhPiW2bMYHBICsE6s+DFVXVbdIknyy28fVc+wEyNf2GkAujGKJe9WxOtZf3eanI5e3F3ukZbeaDAhOyfK5E5ZisrUXFnB7UQsr8GaFkb7dwuItvVAXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=K1uj6yTq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K1uj6yTq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769029400;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G2DRYkMV5w2DeR8GNQYglhQAIFQ8jlyRx7bWqJIn19A=;
	b=K1uj6yTqJB34OsilkuS83PqK+zrr9elPAymbIY/Ddn6VfYzs3/eyEkr9fMFBpEfqnjBXJx
	XN73ycLON3OBIcy73bWatZ08T/q3+ImhKbQ0REQFXdlgkCPmGLCLP0orVkXcK1hsEM+mqy
	5sbGro29YbpTusBsDJ13OJpxVKMkZ8Q=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-696-wbfscs7tP06ucTRStwA-4w-1; Wed,
 21 Jan 2026 16:03:16 -0500
X-MC-Unique: wbfscs7tP06ucTRStwA-4w-1
X-Mimecast-MFC-AGG-ID: wbfscs7tP06ucTRStwA-4w_1769029395
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8A35D1956046;
	Wed, 21 Jan 2026 21:03:15 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 565101800993;
	Wed, 21 Jan 2026 21:03:15 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 60LL3El43942757
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 21 Jan 2026 16:03:14 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 60LL3Exb3942756;
	Wed, 21 Jan 2026 16:03:14 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 4/4] multipathd: print path offline message even without a checker
Date: Wed, 21 Jan 2026 16:03:13 -0500
Message-ID: <20260121210313.3942727-5-bmarzins@redhat.com>
In-Reply-To: <20260121210313.3942727-1-bmarzins@redhat.com>
References: <20260121210313.3942727-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: mFbrCSoRtiFzVeNpT8Zuj6FERqKI4qJDnfdp-ChE9Xo_1769029395
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

If a path has a checker selected and is offline, multipathd will print a
"path offline" message. However if the checker isn't selected, for
instance because multipathd was started or reconfigured while the path
was offline, multipathd was not printing the "path offline" message.
Fix that.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 90472d69..05dd65e6 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -96,12 +96,11 @@ mpath_pr_event_handle(struct path *pp, unsigned int nr_keys_needed,
 
 #define LOG_MSG(lvl, pp)					\
 do {								\
-	if (pp->mpp && checker_selected(&pp->checker) &&	\
-	    lvl <= libmp_verbosity) {					\
-		if (pp->sysfs_state == PATH_DOWN)		\
+	if (pp->mpp && lvl <= libmp_verbosity) {		\
+		if (pp->sysfs_state != PATH_UP)			\
 			condlog(lvl, "%s: %s - path offline",	\
 				pp->mpp->alias, pp->dev);	\
-		else  {						\
+		else if (checker_selected(&pp->checker)) {	\
 			const char *__m =			\
 				checker_message(&pp->checker);	\
 								\
-- 
2.50.1

