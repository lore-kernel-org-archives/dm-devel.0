Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE984190674
	for <dm-devel@lists.linux.dev>; Thu,  5 Dec 2024 03:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733371007; cv=none; b=DRXObqJFR5S4orGNOmFCD5bjPuvMgbyrId8ZUpPO0jDjKdLI2wVMXpCbemFSCJvWIUdmg6B6yzYUgNYQGTDDRBlf2CEgcw/P2DcQfG7e5Sn/BxJmIZdkiMhw5MYxo6MP+9NvG1Y/Cs5KYNzD3aUSQSvJbZn7C0uewvYVhYECcvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733371007; c=relaxed/simple;
	bh=kS8DVlkG8URKmHv/+e1FANSbJjp59DcxBmZ6PRtQr64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=HN8juWg8Sn3Du1jchflMdrBmr5IjsscvtOVlq2H+s3YERCaSM4Fm8xbk5hSLB7kRxmJbeC1CkOhCtYMkAcHLACSjxVdz3jNam9FvLWc7B07Z+rXT6vZY2FVsrrzS3PVOArldKG2srlyp1Z9FqG+yt9Bbjg0GiVIWkIN89/sQGsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZR0DrlET; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZR0DrlET"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733371004;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yAbPJ5h1F18WL/OuebGEH+j4sFp7tDdXze/pOTJRjlA=;
	b=ZR0DrlETC4d6PNYeenEsaYYaayOaL0eYJ0G/D8F6BE9hOekCkyx/coTwaSYg8u7FQIoLn3
	rORd1PfyMuq+UhlPbm8TmENqb6wn1owVW5YKf4O3RxjRTKPGdwaJSzD1hTj6wfGX6ZE/WN
	QBZ+tcw1g1/gbpvJyQoPIi4gIC5iOiQ=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-573--RCUngyINqmrHAOe3p7jvQ-1; Wed,
 04 Dec 2024 22:56:41 -0500
X-MC-Unique: -RCUngyINqmrHAOe3p7jvQ-1
X-Mimecast-MFC-AGG-ID: -RCUngyINqmrHAOe3p7jvQ
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 95EFD19560B6;
	Thu,  5 Dec 2024 03:56:40 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 44F9919560AD;
	Thu,  5 Dec 2024 03:56:40 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4B53ucqU1218973
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 4 Dec 2024 22:56:38 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4B53uc701218972;
	Wed, 4 Dec 2024 22:56:38 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH 2/3] multipathd: reload maps in checkerloop() if necessary.
Date: Wed,  4 Dec 2024 22:56:37 -0500
Message-ID: <20241205035638.1218953-3-bmarzins@redhat.com>
In-Reply-To: <20241205035638.1218953-1-bmarzins@redhat.com>
References: <20241205035638.1218953-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: TTBAHhykMmtyoGAxSW9wwJ0k_HM3qDs_DswTh3FlC6E_1733371000
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

update_pathvec_from_dm() may set mpp->need_reload if it finds
inconsistent settings. In this case, the map should be reloaded, but so
far we don't do this reliably. Add a call to reload_and_sync_map()
when updating the maps at the end of a loop in checkerloop().

Suggested-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index fcab1ed3..c1ae44f2 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -3038,7 +3038,10 @@ checkerloop (void *ap)
 							     start_time.tv_sec);
 			if (checker_state == CHECKER_FINISHED) {
 				vector_foreach_slot(vecs->mpvec, mpp, i) {
-					if (update_mpp_prio(vecs, mpp) == 2) {
+					if (update_mpp_prio(vecs, mpp) == 2 ||
+					    (mpp->need_reload &&
+					     mpp->synced_count > 0 &&
+					     reload_and_sync_map(mpp, vecs) == 2)) {
 						/* multipath device deleted */
 						i--;
 					}
-- 
2.46.2

