Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88BF9238C1A
	for <dm-devel@lists.linux.dev>; Wed, 21 Jan 2026 21:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769029401; cv=none; b=cHpXtk8DtliyoPJs817uzMhOqsW8sxhyGF24zD1sM9CslOsI/FnyMzdCIupQRsor0xyEBKGKw1X6J6F7pddG8EeVXaR8YozXsX/yNRw45t80kxTFS/ZoGnM3xbzWrE4lXgm9UvS4mwbwEwbpQHue/wQZyJQHH+aO/ulrssF7eK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769029401; c=relaxed/simple;
	bh=Vhe3Vbv1b51Ws/SbClE1aSifaKT1bR7cdliQ0154OVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=sdnLBVMt4u8SLkGRY4Z7F/nxN0m/psluzu4XyxShOLGFdxd6oOyuTDuj7h5l1OPGSSbBd1zE/bLYO7UFqj2tDhFsKPYd/xR9Zj01ZXFt0UuNAoh2cxA18+fMJgtuFh523qtGf0fE2sl5IRhoAjuwo3xX7dViQCInTndUjfMH5pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HTCFhffq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HTCFhffq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769029398;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IBAgXeZH+kqBAfDL6WhRS2wAPfHgPPpaNs+l3VceABw=;
	b=HTCFhffqq53+edWV/z5+qSli8nGvPeqXIV2axQhgAck/5jOIUzL8hu1pwvP+ZfJpOwYeV7
	Nwp6fxKS2mssGRC0Cc1XXR++IKkEqk3RinsCudys7n0hWh/RJ1rqYIYNNCHJ87j9aXStFR
	9oYyRATvFUF9I0JcGUzQQu9OYPG7u/o=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-448-mE8FCyofOaCPv10xgqOB9Q-1; Wed,
 21 Jan 2026 16:03:16 -0500
X-MC-Unique: mE8FCyofOaCPv10xgqOB9Q-1
X-Mimecast-MFC-AGG-ID: mE8FCyofOaCPv10xgqOB9Q_1769029395
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 67ED719560B5;
	Wed, 21 Jan 2026 21:03:15 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DD72819560A2;
	Wed, 21 Jan 2026 21:03:14 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 60LL3Dq33942744
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 21 Jan 2026 16:03:13 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 60LL3DN63942743;
	Wed, 21 Jan 2026 16:03:13 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 1/4] multipathd: don't add removed/partial paths to new maps
Date: Wed, 21 Jan 2026 16:03:10 -0500
Message-ID: <20260121210313.3942727-2-bmarzins@redhat.com>
In-Reply-To: <20260121210313.3942727-1-bmarzins@redhat.com>
References: <20260121210313.3942727-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: eMkHOCuB4gEnwcoC0SwErXOdHQNdU565gNvdMYMdnIc_1769029395
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

During configure(), when the old multipath devices are added in
map_discovery(), it's possible that they have paths in the INIT_PARTIAL
or INIT_REMOVED state. These paths were not found during
path_discovery(). Don't add them to the new multipath maps.
coalesce_maps() will make sure that they point to the old maps, so they
will get cleaned up when those maps are removed.

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/configure.c   | 12 +++++++++++-
 libmultipath/structs_vec.c |  3 ++-
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 0bcec089..a713ddc4 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -1113,7 +1113,17 @@ int coalesce_paths (struct vectors *vecs, vector mpvec, char *refwwid,
 			continue;
 		}
 
-		/* 4. path is out of scope */
+		/*
+		 * 4. The path wasn't found in path_discovery. It only exists
+		 *    in an old map.
+		 */
+		if (pp1->initialized == INIT_PARTIAL ||
+		    pp1->initialized == INIT_REMOVED) {
+			orphan_path(pp1, "path not found");
+			continue;
+		}
+
+		/* 5. path is out of scope */
 		if (refwwid && strncmp(pp1->wwid, refwwid, WWID_SIZE - 1))
 			continue;
 
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 9384de01..3e63e9c3 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -315,7 +315,8 @@ int adopt_paths(vector pathvec, struct multipath *mpp,
 					pp->dev, mpp->alias);
 				continue;
 			}
-			if (pp->initialized == INIT_REMOVED)
+			if (pp->initialized == INIT_REMOVED ||
+			    pp->initialized == INIT_PARTIAL)
 				continue;
 			if (mpp->queue_mode == QUEUE_MODE_RQ &&
 			    pp->bus == SYSFS_BUS_NVME &&
-- 
2.50.1

