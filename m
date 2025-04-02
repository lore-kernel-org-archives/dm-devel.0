Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE93F1F7904
	for <dm-devel@lists.linux.dev>; Wed,  2 Apr 2025 23:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743635612; cv=none; b=t7N6MARoJeV+ncGDjFhYh1W97cJpcFln7LggxeG68NXPnWR2LmcElUkqk21QCDbPcgiaBULBUnBm0Va8imwjHXDsKtVAIVE/KuAbDYjY/ydxky6+NMq8AEBfUpfmhuxscCSZ/HsYsqnxNkafZRcRbMrubJwZsXGpmw5/44GMlWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743635612; c=relaxed/simple;
	bh=CuN6+D5ZqtTmGk17pE7Z+aCbNysBVqnqk7UyBPXzhgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=OwgiPDrhWyT5wlmjrUHWYz4IUQM4iIacUPrISjAu+DqZi8bPv6pRlq5G2SjXgcgH0WzalsKVAky8h2FHKAffpGuy40ECXKfciIwlVzFMljMJJZgPO+oW6udvc2CfcWak3geKqwyw2nI/6+W6SZsaTkEKu7piiIe4zegZe9N2Rgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JXXEmDad; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JXXEmDad"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743635609;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z1u71JUgkCrZaaxyjgoiV8hcOXhStEfcLPqU6XJO4OM=;
	b=JXXEmDadU9tI2XBPS6C7zet6LepPoUteK/gtgGRR/s9X3ASWg/y9Uxc0HChaRJHGg2ngBt
	rzj0l27wH97vqHAoFhoHixagabC/KoanCs5xNhOPmsd0tlvilBEJyRs8N2Bkjldop5Ncnr
	QUIuE53VS9nYORhG/Chu1/i78SP17FE=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-413-pQXXEI4bM3KGCkes7GlKKw-1; Wed,
 02 Apr 2025 19:13:26 -0400
X-MC-Unique: pQXXEI4bM3KGCkes7GlKKw-1
X-Mimecast-MFC-AGG-ID: pQXXEI4bM3KGCkes7GlKKw_1743635605
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E7A9C1800259;
	Wed,  2 Apr 2025 23:13:24 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 64777192C7C3;
	Wed,  2 Apr 2025 23:13:24 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 532NDNGC3044081
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 2 Apr 2025 19:13:23 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 532NDNec3044080;
	Wed, 2 Apr 2025 19:13:23 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 1/4] multipathd: monitor new multipath dev even if we can't update it
Date: Wed,  2 Apr 2025 19:13:19 -0400
Message-ID: <20250402231322.3044064-2-bmarzins@redhat.com>
In-Reply-To: <20250402231322.3044064-1-bmarzins@redhat.com>
References: <20250402231322.3044064-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: kgPH0-Lwy6AB09YdNu_ZcjcJwmRoN1OBrFEqGsIYFgI_1743635605
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

If a multipath device was created by the multipath command, multipathd
might not agree with how the device was created. ev_add_map() can reload
the device with a different table by calling add_map_without_path() ->
update_map(). If this reloading of the map failed, multipathd was simply
ignoring the multipath device, even though it still existed.

One way that reloading can fail is if a path that multipathd already has
initialized goes offline. If a multipath device is created by the
multipath command while the path is offline, it will not use the offline
path, since multipath won't be able to get the necessary pathinfo.
However, multipathd will already have the pathinfo for the path, and may
not even know that it's offline, since the path is an orphan. When it
tries to reload the device, it will include the offline path, and the
reload will fail.

Instead of ignoring the device if it can't reload it, multipathd should
just montior it as it is. When the path device is no longer offline, it
can be added back to the multipath device by calling
"multipathd reconfigure" or "multipathd add path <path>".

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck  <mwilck@suse.com>
---
 multipathd/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index e63b6aa7..7aaae773 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -679,7 +679,7 @@ retry:
 	}
 
 fail:
-	if (new_map && (retries < 0 || wait_for_events(mpp, vecs))) {
+	if (new_map && wait_for_events(mpp, vecs)) {
 		condlog(0, "%s: failed to create new map", mpp->alias);
 		remove_map(mpp, vecs->pathvec, vecs->mpvec);
 		return 1;
-- 
2.48.1

