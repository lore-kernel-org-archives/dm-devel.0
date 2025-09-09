Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1589E31283F
	for <dm-devel@lists.linux.dev>; Tue,  9 Sep 2025 00:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757376017; cv=none; b=cPC6JgZU0icV+VcKj4XY9YjIePlxw+t/LYL+APvS3AwLnUN8gy/muW74SXMIUV6ToMmohuIpf18Ce/rya1iGWl7USu8DeQmqF64aDkDDjWPJxYdyywua8Gw88HqnZRwTafMipWKpx0jWNlUeLgU71qiPTzHWoOOmOZLNPQ2F14A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757376017; c=relaxed/simple;
	bh=tO2ZTi+LmsxNf33+MDgyFKfmbmLBi1+7eRm7gwooorI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=DmBcOOELSMmL5KxBPlixDvyMHZ00N+MsLJxBRE+APpErZNOP6pm+0vtr2KO3Gm0KBYQG/pO5iMTnLmBNgKnGXO0LAyYPzyl/W7yPbrJpl+URZ0XCd6PNd16EcyGmc28YI+QGmD3lgUH1zFwDzXnJS+Xcfm4e/a2/1FkTRslUG8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IAcstVuF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IAcstVuF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757376015;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ifIAbFJltC9hXos4x/znrMJKZF74vdgRAkLS9Dvbbu8=;
	b=IAcstVuFgzrpiDnbW2g86iAfg9nw3WdzxN6VCICFpEDiZ3TzRKlM4SlvnUd3n7f3FY7OUE
	H7/qqmHQ5ckIg3BF3jcHCiAflujwAtxCcB2UBwDObJ4hbVk+1GyhGoF8qy+FfosXXif2Mc
	i3++7xcxri7nt4gQKFqFQolGXPovKaQ=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-635-FtGsqyuDOQaQL8bf00c5jA-1; Mon,
 08 Sep 2025 20:00:10 -0400
X-MC-Unique: FtGsqyuDOQaQL8bf00c5jA-1
X-Mimecast-MFC-AGG-ID: FtGsqyuDOQaQL8bf00c5jA_1757376010
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 03C1B180034C;
	Tue,  9 Sep 2025 00:00:10 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AFAAA1800452;
	Tue,  9 Sep 2025 00:00:09 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 589008wE751207
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 8 Sep 2025 20:00:08 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 589008DU751206;
	Mon, 8 Sep 2025 20:00:08 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 31/32] libmpathpersist: Don't fail RESERVE commands unnecessarily
Date: Mon,  8 Sep 2025 20:00:01 -0400
Message-ID: <20250909000002.751039-32-bmarzins@redhat.com>
In-Reply-To: <20250909000002.751039-1-bmarzins@redhat.com>
References: <20250909000002.751039-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: sX4sefceXcpxQKvcQOtYi0ifGB0Y1tWCScxcYfXA92c_1757376010
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

If you issue a RESERVE to a regular SCSI device that already holds the
reservation, it succeeds (and does nothing). If you issue a RESERVE to a
multipath device that already holds the reservation, it can fail with
a reservation conflict error if you issue the RESERVE to a path that isn't
holding the reservation. Instead, it should try all paths and
succeed if the reservation command succeeds on any of them.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathpersist/mpath_persist_int.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index a28e55b3..595e073a 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -228,9 +228,20 @@ mpath_prout_common(struct multipath *mpp, int rq_servact, int rq_scope,
 			 * it may have just come back up, and multipathd
 			 * may not have had time to update the key. Allow
 			 * reservation conflicts.
+			 *
+			 * If you issue a RESERVE to a regular scsi device
+			 * that already holds the reservation, it succeeds
+			 * (and does nothing). A multipath device that
+			 * holds the reservation should not return a
+			 * reservation conflict on a RESERVE command, just
+			 * because it issued the RESERVE to a path that
+			 * isn't holding the reservation. It should instead
+			 * keep trying to see if it succeeds on another
+			 * path.
 			 */
 			if (ret == MPATH_PR_RESERV_CONFLICT &&
-			    pp->dmstate == PSTATE_FAILED) {
+			    (pp->dmstate == PSTATE_FAILED ||
+			     rq_servact == MPATH_PROUT_RES_SA)) {
 				conflict = true;
 				continue;
 			}
-- 
2.50.1

