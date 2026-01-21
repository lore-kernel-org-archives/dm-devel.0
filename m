Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D44B82D8376
	for <dm-devel@lists.linux.dev>; Wed, 21 Jan 2026 04:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768969408; cv=none; b=pDGAbk62Me/OkD9A6h36EpOWhGuW869uzHz7ClwgpjjoS4vtEotyIM4yGsXLxknyCrtno8u4rH1DU2pP4zh4aFsWm8s33Jq4HYpFDBePkCjpglTO6/pMlOth588nDXMj4S2vqtlABc5UMDX2v8++u7XuaPv/GvvGpZaCf15dRog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768969408; c=relaxed/simple;
	bh=WiSPI7Gl7QAL71HxF2kr/1Kyy8a66q0hsNW99cMRJnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=gHK+bp9apmAJe+2+i912F+/bhp4Fd27ZFHXIhw90By5vOHhUU2H4sx9x+LsrHLJo1XcL+/4UcacB5TnIw5vGeWgI5t7RkTygCxk2Bx9YRNbP+FZ6DOihrq+JVfDLxl+1k2zivkyIJIfPTbPJJDQmfts2CGgO1iH3HX2VR1KjIzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bDrX0daA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bDrX0daA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768969399;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZuluPeW05KnaFxV9vbw0pYEopw6XpyqePjAkoM2vHZA=;
	b=bDrX0daA44sQ+LpoX5/kwWiUOciZ5Kr6bqJLSxqfPo8uQh/YgF/0sGxZ2k4mcycSgB+SA3
	1CO6zDpAmj7jkfgRp4LaOgsuOyqEfcIKlbWwYPO+Rr4ad11KrS6TlZUkfzLVahP6dd3cfT
	+fdrl9N2GxJDZDK8edYAxwkwo2crYSU=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-62-kWQe6m2ZPZaOMI8fCtWozQ-1; Tue,
 20 Jan 2026 23:23:18 -0500
X-MC-Unique: kWQe6m2ZPZaOMI8fCtWozQ-1
X-Mimecast-MFC-AGG-ID: kWQe6m2ZPZaOMI8fCtWozQ_1768969397
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1D59E180057E;
	Wed, 21 Jan 2026 04:23:17 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C57CF19560A2;
	Wed, 21 Jan 2026 04:23:16 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 60L4NFL23914724
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 20 Jan 2026 23:23:15 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 60L4NFMT3914723;
	Tue, 20 Jan 2026 23:23:15 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 1/4] multipathd: don't add removed/partial paths to new maps
Date: Tue, 20 Jan 2026 23:23:12 -0500
Message-ID: <20260121042315.3914707-2-bmarzins@redhat.com>
In-Reply-To: <20260121042315.3914707-1-bmarzins@redhat.com>
References: <20260121042315.3914707-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: AljNouxGPcfV-7JH-E0_QW85hs9cGe-LOFe6YI9MKTc_1768969397
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

During configure(), when the old multipath devices are added in
map_discovery(), it's possible that they have paths in the INIT_PARTIAL
or INIT_REMOVED state. These paths were not found during
path_discovery(). Don't add them to the new multipath maps.
coalesce_maps() will make sure that they point to the old maps, so they
will get cleaned up when those maps are removed.

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

