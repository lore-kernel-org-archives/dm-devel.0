Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0134D1C2438
	for <dm-devel@lists.linux.dev>; Thu, 12 Sep 2024 21:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726177797; cv=none; b=mst8QoPSOiSkppvcx9OCvFe/JNia4quEusNqboN7+mue+1NianF+siw0tqlXo0hk3DlE/sYLLtDNzVntgjZraeHGxFbeu50u/7f3cjJHt344lV1Q5WJj9OIGTatv3HonhW3y321p6kYa30cGjIKEJ5LMzU6pqKt097zqav+6BqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726177797; c=relaxed/simple;
	bh=dPBoCE9Y1WkTRtwROuGHR5WYobw0rp2ipdm5vOdNYHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WxNmIU641jc1NArSP8Z/qnVfbpcJ1CcBRNxKqeiaCDnF4OJMpvpjUka19YGOlXZde9jGEZbEJVjZYBLdWJLLplELXL4dyvq+Q7+u2ptUpyxkwFSRDjkdTADRCB1V/JBjNmgAt6wImBTAnMw7yg06fggOMtZ13gmUfL3YYVzTHV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OqQZCL52; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OqQZCL52"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726177795;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z2lGrlk8MmpgF5r8gHSgrFn3/iqj504DYuv9zSd6KeU=;
	b=OqQZCL52jMSPtX1OmNOciuYl4PS6r0UrhtTIhaMxgjcd3LAGKW+NPmwFhOu9L7cAV4h82d
	0J1bw7VobxXdnjNRBpTC5Ul1/ljLmwBntLGXZqIQQtv+CuHW14IUsantpeY5vSPpSqqlf1
	FV+h6r5CuAJWX8sGnLG0i1scaXZB2II=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-28-2V1EklQhPD2z48CaD_5e_w-1; Thu,
 12 Sep 2024 17:49:53 -0400
X-MC-Unique: 2V1EklQhPD2z48CaD_5e_w-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DE5DB1956088;
	Thu, 12 Sep 2024 21:49:52 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7E9C31956052;
	Thu, 12 Sep 2024 21:49:52 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 48CLnpKA783918
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 12 Sep 2024 17:49:51 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 48CLnp8C783917;
	Thu, 12 Sep 2024 17:49:51 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 17/22] multipathd: remove pointless check
Date: Thu, 12 Sep 2024 17:49:42 -0400
Message-ID: <20240912214947.783819-18-bmarzins@redhat.com>
In-Reply-To: <20240912214947.783819-1-bmarzins@redhat.com>
References: <20240912214947.783819-1-bmarzins@redhat.com>
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

Since we just returned if newstate wasn't PATH_UP or PATH_GHOST, it
must obviously be PATH_UP or PATH_GHOST at this point in the code. We
don't even wrap all the code for dealing with a path that just came up
in this if-block, It's only the persistent resrvation code.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 91806e9d..18632c7d 100644
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

