Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABC70171092
	for <dm-devel@lists.linux.dev>; Tue, 15 Oct 2024 03:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728962924; cv=none; b=g8uJW3svMFeRWJRjE6+FyKFHNUxakvMU/8Z9j0IdahNiF2IhVHUXZWNnTo5gZrueuIUDsctUBKkQAO6Yp8WXbXQxs4pINUweL4O91sBd09gjgK+QYMSTbGPvF3nh28fZ/IQ6g5PpNXu18xWec07tS+gdMOlOaLFnpodBulOSDVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728962924; c=relaxed/simple;
	bh=fogHgKkf06/XAZau6gZhQRwgh5+C538jFtU/BkSksRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vC+mEwnmSfLVrQbtMNMFk3qxFf2OPfc0nUsqRwMx2NS7jAzynoI9gpyPLIVv9I2sZcF91CEiDkQfczb1i21Wf+uAMAfUfli4qZV8n+62eEWkmm7x3LIrgmzy2Fpsr8M+cIRYZyDLpcnDSkTONqliquEQ7YPkA+r/w2LgrAhzS58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=F/KzRx84; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F/KzRx84"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728962921;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0u3XKLQL68D5VjpSMku/sQH35STdRSYAt+YMguSAzLM=;
	b=F/KzRx84DsR42Hch25bw/vJUUFSwpeSGGvDAoPkHeHbt7IxmWRPlEF/1KHjM1bHxtjBZlO
	/+YyUmz1bwYI9328BlZWj2OnvJqUknTtRImsF9dekTbsfw9++Fsgp3XoL0aTdfrJx/Htyp
	KiE0jilHM34PFlsKrMUwNJ51cCxH7vE=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-495-eWd8tcHaODySHtEkXJC4RA-1; Mon,
 14 Oct 2024 23:28:40 -0400
X-MC-Unique: eWd8tcHaODySHtEkXJC4RA-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B120919560B4;
	Tue, 15 Oct 2024 03:28:39 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 71F571956089;
	Tue, 15 Oct 2024 03:28:39 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 49F3ScOa2693347
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 14 Oct 2024 23:28:38 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 49F3ScOZ2693346;
	Mon, 14 Oct 2024 23:28:38 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v5 17/23] multipathd: remove pointless check
Date: Mon, 14 Oct 2024 23:28:29 -0400
Message-ID: <20241015032835.2693247-18-bmarzins@redhat.com>
In-Reply-To: <20241015032835.2693247-1-bmarzins@redhat.com>
References: <20241015032835.2693247-1-bmarzins@redhat.com>
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

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index d479d0c0..ec172021 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2550,19 +2550,19 @@ update_path_state (struct vectors * vecs, struct path * pp)
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

