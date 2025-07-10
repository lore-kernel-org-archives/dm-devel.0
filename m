Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF43B2FC3CC
	for <dm-devel@lists.linux.dev>; Thu, 10 Jul 2025 18:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752171075; cv=none; b=n71x+DMOGna7XIE//74Apa75rGGadOYe1y3x6WllQrXMJME9jBy0cfTyxq0peTvL5TY2l0GiFB4b77osE9XF+5+VP31fmZRw6GfnlUrjsl6bpghtQqpsFs2aiIcdKCDrws0mBqI+FXivjlpS0pNDprVUZBkuKincszXuU5J3hiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752171075; c=relaxed/simple;
	bh=l+O0jnePTR/KnF1YsTMt5ywvSjIg8gFDWe0B5T7MvQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=PiK2CTuaHuPRHkllrIW3c3oapwAC6I5Fj1S7w5fv/YXPBXbus6UE3XyrG0RkXx8h/a8qeI29i4DCnHUn3uD3PdRYYjGuy3XPhEjs5IWBhs00PI1Xl43dvvOSzW+hDh69PZtuSkIo4ugHigCTKOcWw19ZjyzgrJDohzkjeFmaZDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HQfuhTn5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HQfuhTn5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752171072;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1IN6vfBR+OqZMvClrs3RObDHwQ+tEHWMHitKOyF329w=;
	b=HQfuhTn5PmX4DtTdpciZIMyrNXMQqpuXbcgnJZrGXbGOkSJ+eca6dEFAOQagqrXpX0AUOF
	mEhT+X0qGSRkairSaP404Ox4BdsGaCimsVWRpbSKnSyeLoycwB+4ORqaEvPnIu2nLMpaxf
	KEU8yayj5H3hAdlVL7y6csvCLdzB7jc=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-538-IlmHS2i6PSafcGPoehCKwQ-1; Thu,
 10 Jul 2025 14:11:06 -0400
X-MC-Unique: IlmHS2i6PSafcGPoehCKwQ-1
X-Mimecast-MFC-AGG-ID: IlmHS2i6PSafcGPoehCKwQ_1752171065
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ED4EA18011EF;
	Thu, 10 Jul 2025 18:11:03 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A24CE19560A3;
	Thu, 10 Jul 2025 18:11:03 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 56AIB20o3997811
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 10 Jul 2025 14:11:02 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 56AIB2sb3997810;
	Thu, 10 Jul 2025 14:11:02 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 07/15] multipathd: Don't call update_map_pr unnecessarily
Date: Thu, 10 Jul 2025 14:10:52 -0400
Message-ID: <20250710181100.3997759-8-bmarzins@redhat.com>
In-Reply-To: <20250710181100.3997759-1-bmarzins@redhat.com>
References: <20250710181100.3997759-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: rMnZG2hcUMuWXdy5AFoA8higTKuKJsgZwKw_FDl4eHg_1752171065
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

None of the calls to update_map_pr() outside of mpath_pr_event_handle()
add any benefit. When update_map_pr() is called without a path, it tries
to read the pr keys list on each usable path until it succeeds, and then
checks the keys to see if they include the configured key.

In all cases where update_map_pr() is called outside of
mpath_pr_event_handle(), after it is called, pr_register_active_paths()
is called if a matching key was found. pr_register_active_paths() calls
mpath_pr_event_handle() on each usable path, which calls update_map_pr()
with a path, so it only checks that path. If a matching key is found, it
registers a key on the current path. The result is that after
pr_register_active_paths() is called, update_map_pr() will be called for
each usable path, just like update_map_pr() did. So calling
update_map_pr() first doesn't change the results for multipathd, it just
adds duplicate work, so remove those calls.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index ace278f1..02cfe8d1 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -637,6 +637,8 @@ pr_register_active_paths(struct multipath *mpp)
 
 	vector_foreach_slot (mpp->pg, pgp, i) {
 		vector_foreach_slot (pgp->paths, pp, j) {
+			if (mpp->prflag == PRFLAG_UNSET)
+				return;
 			if ((pp->state == PATH_UP) || (pp->state == PATH_GHOST))
 				mpath_pr_event_handle(pp);
 		}
@@ -726,10 +728,7 @@ fail:
 
 	sync_map_state(mpp, false);
 
-	if (mpp->prflag != PRFLAG_SET)
-		update_map_pr(mpp, NULL);
-	if (mpp->prflag == PRFLAG_SET)
-		pr_register_active_paths(mpp);
+	pr_register_active_paths(mpp);
 
 	if (VECTOR_SIZE(offline_paths) != 0)
 		handle_orphaned_offline_paths(offline_paths);
@@ -1402,10 +1401,9 @@ rescan:
 	sync_map_state(mpp, false);
 
 	if (retries >= 0) {
-		if (start_waiter)
-			update_map_pr(mpp, NULL);
-		if (mpp->prflag == PRFLAG_SET && prflag != PRFLAG_SET)
-				pr_register_active_paths(mpp);
+		if ((mpp->prflag == PRFLAG_SET && prflag != PRFLAG_SET) ||
+		    start_waiter)
+			pr_register_active_paths(mpp);
 		condlog(2, "%s [%s]: path added to devmap %s",
 			pp->dev, pp->dev_t, mpp->alias);
 		return 0;
@@ -3312,9 +3310,7 @@ configure (struct vectors * vecs, enum force_reload_types reload_type)
 	vector_foreach_slot(mpvec, mpp, i){
 		if (remember_wwid(mpp->wwid) == 1)
 			trigger_paths_udev_change(mpp, true);
-		update_map_pr(mpp, NULL);
-		if (mpp->prflag == PRFLAG_SET)
-			pr_register_active_paths(mpp);
+		pr_register_active_paths(mpp);
 	}
 
 	/*
-- 
2.48.1

