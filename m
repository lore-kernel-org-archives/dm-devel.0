Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B9E933065D
	for <dm-devel@lists.linux.dev>; Wed, 28 Jan 2026 21:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769636820; cv=none; b=QijOpCT4G72yBvGeLHa5T+QfP+AOgeBFjKvL2MpPTHn7R7wuUVTxVNwQys8C+3SDSUGRYce4YomUwFsjfYGb5tTj3oNMFjkdaboXqgBVAPig3pbnQjTAyyUHykcajpbsiORa4Q8lWkYP3wGtObc0mydkAcIHAxUyNssaz5uYDYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769636820; c=relaxed/simple;
	bh=XdJrIcRGW8U94h8l6N8ES8c/pnXbGmId4Owl+rsD8ng=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=Bao9N8wFSs/rzU1YD0CYZdObyftaZ0rXSYhPG2NNVKdbxlZrhWokoT2YxMZZ/qrAqTFNY95TJOEx1ep368WKhukzv5oLNak9gUWTuaAO9qoF64nE6yJ+YnQ5XqKbzffbq8sQIHsGE6TxpXy0wDZsQu4o2DbmhppatXmsKcgSPuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ct/EvGhO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ct/EvGhO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769636818;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=mISeoFMOyQy5PsOqg5Aw2+jx5MelbOZVJsexfurrZG4=;
	b=Ct/EvGhOlKKFqR+qcxCY9UfhHayOhSTcAhPWlSNYkGTkqz5Kx/cT2HzdM8Sp3ddFeEqLIL
	FahyEWalqMrpq5f21mBSLBwtcfFvO3T7pbWAWOp4M/cM5OVYyewrjhuLmOPwtF7dowBxQV
	SyoFvlWMw6Cm2vj63o49hycdphjYSf8=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-634-AxLGQOtXNgmT2-mP85-llA-1; Wed,
 28 Jan 2026 16:46:54 -0500
X-MC-Unique: AxLGQOtXNgmT2-mP85-llA-1
X-Mimecast-MFC-AGG-ID: AxLGQOtXNgmT2-mP85-llA_1769636813
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 87B081800447;
	Wed, 28 Jan 2026 21:46:53 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 08466180086E;
	Wed, 28 Jan 2026 21:46:52 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 60SLkpsO499147
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 28 Jan 2026 16:46:51 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 60SLkpdM499146;
	Wed, 28 Jan 2026 16:46:51 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>,
        Brian Bunker <brian@purestorage.com>
Subject: [PATCH] multipathd: fix possible null deference in purge_disconnected code
Date: Wed, 28 Jan 2026 16:46:51 -0500
Message-ID: <20260128214651.499138-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: t1_-L034G_PoHO07f8izP0xJ9xYTuHcKPKn1noi99rA_1769636813
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

purge_disconnected only works on paths that are part of a multipath
device. However, get_new_state() is also run on uninitialized paths that
are not part of any multipath device, and the purge_disconnected code in
it was dereferencing pp->mpp, without checking if it was NULL. Fix that.

Fixes: 690550a1 ("multipathd: implement purge functionality for disconnected paths")
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 05dd65e6..d87c7b12 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2518,7 +2518,8 @@ get_new_state(struct path *pp)
 	 * checker to trigger special handling before becoming PATH_DOWN.
 	 */
 	if (newstate == PATH_DISCONNECTED) {
-		if (pp->mpp->purge_disconnected == PURGE_DISCONNECTED_ON &&
+		if (pp->mpp &&
+		    pp->mpp->purge_disconnected == PURGE_DISCONNECTED_ON &&
 		    pp->disconnected == NOT_DISCONNECTED) {
 			condlog(2, "%s: mark (%s) path for purge", pp->dev,
 				checker_state_name(newstate));
-- 
2.50.1

