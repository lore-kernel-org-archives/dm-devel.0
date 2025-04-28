Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35145209F38
	for <dm-devel@lists.linux.dev>; Mon, 28 Apr 2025 21:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745876723; cv=none; b=FGPLGROQkWLojtvq0STvFh2JZadHI6BH36Es+p+W6EPBslIA2jCigOL2U1GrekA3YP59h8ChlJXuLZDYCDUMctCNzeKhKv0mizXVTcKrEoRyQyMgPvFkAIefmTVT0m1IJnsxbHvC1y710ESAQ5aRhg4elZCMyhJNQ+OVsMmiYDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745876723; c=relaxed/simple;
	bh=+TXMsM7l5ktm77QS2Y7+oQHZhrxxgIlmf1yLNiItrrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=VGObNowDX4AiDphRp4nyyccMfww4lXbgNaLYtK6IuSfzJmXKO8Z6CamhfzbqCN24GYOaUsGYXvchZWQ4MyMd13NqOmKiV1g9J6lHN2qfj/vwY0k8Hk8UANN2ut4454joyN+VJ9RJ7+QwyWDlZN4R7SmPKXVqfI6aQb9/FxZEhs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J810v9Xl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J810v9Xl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745876719;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L42EASBtZvIQU11BxB89wvKrwMP6Fcr/+QTUy+dCPkI=;
	b=J810v9XlDQKohKVoTiakTmgC3B4i+sv7tj+VrtPNcvr4kTlImX+c5dA5OPnT5k3rZaljG+
	FCUOJBcr2nKehzP6u7NEvp7FZsLizXHWlAllWLplqHiTgwVy12KFZArmwHTPt+w3vpb7lu
	SvYJE+B/DH5JDWfW9ykySx8kfonbPCs=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-686-RdjLHa_ZP8SQTgqFlEnoBw-1; Mon,
 28 Apr 2025 17:45:17 -0400
X-MC-Unique: RdjLHa_ZP8SQTgqFlEnoBw-1
X-Mimecast-MFC-AGG-ID: RdjLHa_ZP8SQTgqFlEnoBw_1745876716
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D2BA21800873;
	Mon, 28 Apr 2025 21:45:16 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 89C71180045C;
	Mon, 28 Apr 2025 21:45:16 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 53SLjFPB1905342
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 28 Apr 2025 17:45:15 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 53SLjFiK1905341;
	Mon, 28 Apr 2025 17:45:15 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 1/2] libmutipath: handle blacklisted paths on map_discovery
Date: Mon, 28 Apr 2025 17:45:13 -0400
Message-ID: <20250428214514.1905327-2-bmarzins@redhat.com>
In-Reply-To: <20250428214514.1905327-1-bmarzins@redhat.com>
References: <20250428214514.1905327-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: YIhNm3ryNYPmxHcHlkdfVraKeJDfrx5YGHqv-hkvri0_1745876716
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

If the multipath configuration is changed to blacklist existing devices,
and multipathd is reloaded but the blacklisted multipaths device can't
be removed, multipathd was marking the paths as INIT_PARTIAL, causing
them to stay in the multipath device, at least until the
partial_retrigger_delay timeout elapsed. Instead, mark them as
INIT_REMOVED and set mpp->need_reload, so the device is reloaded and the
paths are removed. To make sure the blacklisted paths are deleted when
the multipath device is removed in coalesce_maps(), set their pp->mpp
to point to map before removing it.

Fixes d9c61332 ("multipathd: trigger uevents for blacklisted paths in reconfigure")

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/structs_vec.c | 15 +++++++++++----
 multipathd/main.c          | 12 ++++++++++++
 2 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 663c9053..9232b54b 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -205,10 +205,17 @@ static void update_pathvec_from_dm(vector pathvec, struct multipath *mpp,
 						must_reload = true;
 						continue;
 					}
-					condlog(2, "%s: adding new path %s",
-						mpp->alias, pp->dev);
-					pp->initialized = INIT_PARTIAL;
-					pp->partial_retrigger_delay = 180;
+					if (rc == PATHINFO_SKIPPED) {
+						condlog(1, "%s: blacklisted path in %s",
+							pp->dev, mpp->alias);
+						set_path_removed(pp);
+						must_reload = true;
+					} else {
+						condlog(2, "%s: adding new path %s",
+							mpp->alias, pp->dev);
+						pp->initialized = INIT_PARTIAL;
+						pp->partial_retrigger_delay = 180;
+					}
 					store_path(pathvec, pp);
 					pp->tick = 1;
 				}
diff --git a/multipathd/main.c b/multipathd/main.c
index 99d603f9..bdd97178 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -804,6 +804,18 @@ coalesce_maps(struct vectors *vecs, vector nmpv)
 	vector_foreach_slot (ompv, ompp, i) {
 		condlog(3, "%s: coalesce map", ompp->alias);
 		if (!find_mp_by_wwid(nmpv, ompp->wwid)) {
+			struct pathgroup *pgp;
+			struct path *pp;
+			int j, k;
+
+			/*
+			 * set pp->mpp for all the old map's paths,
+			 * so that they can be properly removed
+			 */
+			vector_foreach_slot (ompp->pg, pgp, j)
+				vector_foreach_slot(pgp->paths, pp, k)
+					if (!pp->mpp)
+						pp->mpp = ompp;
 			/*
 			 * remove all current maps not allowed by the
 			 * current configuration
-- 
2.48.1

