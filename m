Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E8DC1F947
	for <dm-devel@lists.linux.dev>; Wed,  9 Oct 2024 01:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728436533; cv=none; b=ftsX6xQ++L4xTQgaA78/F11UrWQq+l9ICNUKKX8sgs2nbYyr+Lc27GIG8fyElh/p/8U4JXD3pVPWN66hiU86O2p9M1z81miJp8q0Ax7XR5qf6p4IzQUZZ2+meHkDgL+YbnUnucLZZcdZ6T44Ig6Snh6l/rk+78MyeNCtFmTbwbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728436533; c=relaxed/simple;
	bh=Ama3sgic4Q55+LMItVyZvetCA/GkdYvfV2UOI8OnrTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LxXg2eKJSmvKkSmwui82iMikyRxUSoD04WTwTx7mlTM5CLdolpwnL4mmb3cGBAlwZHB7oR3fOFtyRX2xdrQUU/6hXvMZlSqZYbbN3PjqCAL7VbIhEyTc7AjuNPfURm1v0drygtob/NTK8sCmZeoAZPWvpGChiWqpO4zXXGEhF4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fh37IySO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fh37IySO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728436530;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Md4emmpgtWKs6xlxe1zNgmqs5la/lqParoon+C+2nh0=;
	b=fh37IySOcbLm4gYkL/FLZJX955V1Ac9u2IKoqQQRByJYVc/vsg6wI/61AINtcFTfb1d0bO
	Ugf2rNDHcLj0uElUzLvAqU6eTc//dUEwOCaVYFdNvlfTekvZVAio2dB4syqoCCnb6z14KC
	cjj5bxjjgugIfXJFmD8UY+RpyM4jX0Q=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-207-sabcGwbOPtGAm2sU9nvLHA-1; Tue,
 08 Oct 2024 21:15:29 -0400
X-MC-Unique: sabcGwbOPtGAm2sU9nvLHA-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 247731955F2B;
	Wed,  9 Oct 2024 01:15:28 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CC3E71956056;
	Wed,  9 Oct 2024 01:15:27 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4991FQCr2381672
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 8 Oct 2024 21:15:26 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4991FQZF2381671;
	Tue, 8 Oct 2024 21:15:26 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v4 16/22] multipathd: only refresh prios on PATH_UP and PATH_GHOST
Date: Tue,  8 Oct 2024 21:15:17 -0400
Message-ID: <20241009011523.2381575-17-bmarzins@redhat.com>
In-Reply-To: <20241009011523.2381575-1-bmarzins@redhat.com>
References: <20241009011523.2381575-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

The way that multipathd was handling priority refreshes had some issues.
Some of the multipath prioritizers can hang when run on a failed path.
Multipathd was only skipping paths in PATH_DOWN, but there are other
states where the prioritizer is also likely to hang, such as
PATH_TIMEOUT, PATH_SHAKY, and to a lesser extent, PATH_DELAYED.

Also, before the recent patch splitting the priority updating from the
path checking, multipathd wasn't consistent with which states would
cause
paths to get their priorities updated. If a path changed its state to
anything other than PATH_UP or PATH_GHOST, it wouldn't get its priority
updated.  But if a path kept the same state its priority would get
updated as long at the state wasn't PATH_DOWN.

For safety's sake, a path's priority should only get refreshed when its
in the PATH_UP or PATH_GHOST state. This shouldn't cause problems. Only
paths that are in the PATH_UP or PATH_GHOST state are usable by the
kenel and contibute to the pathgroup's priority.

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index ea4adac8..d479d0c0 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2162,7 +2162,7 @@ static bool update_prio(struct multipath *mpp, bool refresh_all)
 
 	vector_foreach_slot (mpp->pg, pgp, i) {
 		vector_foreach_slot (pgp->paths, pp, j) {
-			if (pp->state == PATH_DOWN)
+			if (pp->state != PATH_UP && pp->state != PATH_GHOST)
 				continue;
 			/*
 			 * refresh_all will be set if the mpp has any path
@@ -2191,7 +2191,7 @@ static bool update_prio(struct multipath *mpp, bool refresh_all)
 	 */
 	vector_foreach_slot (mpp->pg, pgp, i) {
 		vector_foreach_slot (pgp->paths, pp, j) {
-			if (pp->state == PATH_DOWN)
+			if (pp->state != PATH_UP && pp->state != PATH_GHOST)
 				continue;
 			if (pp->is_checked == CHECK_PATH_CHECKED)
 				continue;
-- 
2.45.0

