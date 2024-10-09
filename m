Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A37772D7BF
	for <dm-devel@lists.linux.dev>; Wed,  9 Oct 2024 01:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728436535; cv=none; b=TQnrr/xl2fEzQdZPzMmazhpX6PS7UUGsb+wGX3Gev12qxQbDkfwpOpSOTMu2rU9vejOp48NnduDOTQ3s8GHukoI1eSiBVrsuLNu/tOkIBQMLbThCYHF3KcT596gcyvjEXnvTeg6u8NSZAYo/jNXvdbU+U9TlK5pxR4YbXFdXFQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728436535; c=relaxed/simple;
	bh=fogHgKkf06/XAZau6gZhQRwgh5+C538jFtU/BkSksRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PleahiEYzmgmgBzWkomNN+Z/JOd7Ed3UMggagkIwMl5Qk9lARNb1ZUre4pZiYEHqa1hQlb/Wq/UPGdCJo1qsStA7nFN0EQzN4WTbleY5QwGjzhn5kIY1y+se0tKaPtQeGag2oFXBDrIY4VMlLkwyPdHPIaChAhrt1idS+I2tWAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KdCNCvwN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KdCNCvwN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728436532;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0u3XKLQL68D5VjpSMku/sQH35STdRSYAt+YMguSAzLM=;
	b=KdCNCvwN9PPBHa4tJkg6/iD5RvYkuxcGr577IEPzh6Zj7pBKfBfbBdTK4dBPcz5eba77Je
	oTAd4SzWqKvm4Uqp6U80u/abZDlU5sedAEdub5gXJcc907GHrWSPdrowGm/O1hUZBA6Yhg
	GRk617irK63cTbNPYIM1Usq0J4+EUkI=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-267-NxG4E3MxN9C0YR4GXnxrTw-1; Tue,
 08 Oct 2024 21:15:29 -0400
X-MC-Unique: NxG4E3MxN9C0YR4GXnxrTw-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 542DA1955EA8;
	Wed,  9 Oct 2024 01:15:28 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DD3C519560AA;
	Wed,  9 Oct 2024 01:15:27 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4991FQhQ2381676
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 8 Oct 2024 21:15:26 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4991FQ572381675;
	Tue, 8 Oct 2024 21:15:26 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v4 17/22] multipathd: remove pointless check
Date: Tue,  8 Oct 2024 21:15:18 -0400
Message-ID: <20241009011523.2381575-18-bmarzins@redhat.com>
In-Reply-To: <20241009011523.2381575-1-bmarzins@redhat.com>
References: <20241009011523.2381575-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
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

