Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9B31364AE
	for <dm-devel@lists.linux.dev>; Wed,  9 Oct 2024 01:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728436535; cv=none; b=VUMlOWBJR4p93FAmX31XAH4PbS2++Ua3E2EJBa1YqT4cU4r2UUPy7DuN+6TktmSl0O+ZatDQNGQLKSFL+BMFozm9PG7witkeOHwK7OmBOtP0nCpCcZGTtTtHIcVvI4qNJNY88gDhrx2FezDcQOUiFV7pDsGRPh0A9Pr0wwVU/tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728436535; c=relaxed/simple;
	bh=zaNexoUneOEQPf+9ysIfEbZaWN6PLoQIcIse4OA0nXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z0fOpffyQ7tWrx2gjpjt6MIgmlmdiZu1YckdbgPc0AJXzdp+tGEhWMV/ymdV1DuZg+zF+mEFejvx0tH2B24i9G/nq6yfmchlBqgJrC2nHpaTXuX/9wAcwjfnSBGXn43A3FgBP9fWGzzZOxtVU0Yzu0ah3azjEfC0E8UxjtQyFf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C7JplKWk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C7JplKWk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728436532;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kR0kv7vtx28nx1HwYUaVB0jOK/P9d+OGolWX1vzDtWg=;
	b=C7JplKWkDPBYHAVOE4BdwKwWP7o99qt36WhDkQmkGqe/AO5fO4A7JkNUiIIdLSDz37Wb4H
	sQDbHc11DH7KKQf4rJtCOwQAOWrp66/vwzsdT1CZncqUijNdb9GTYMfgGUpuX3aR4P7995
	OEhSHLo/zeBafN86d4xE+JRRGzbR+6I=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-84-jEgZAmSWPKaC2ed01ArGMw-1; Tue,
 08 Oct 2024 21:15:29 -0400
X-MC-Unique: jEgZAmSWPKaC2ed01ArGMw-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6B6B319560BD;
	Wed,  9 Oct 2024 01:15:28 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 272EF19560A3;
	Wed,  9 Oct 2024 01:15:28 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4991FQWa2381680
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 8 Oct 2024 21:15:26 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4991FQNf2381679;
	Tue, 8 Oct 2024 21:15:26 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v4 18/22] multipathd: fix deferred_failback_tick for reload removes
Date: Tue,  8 Oct 2024 21:15:19 -0400
Message-ID: <20241009011523.2381575-19-bmarzins@redhat.com>
In-Reply-To: <20241009011523.2381575-1-bmarzins@redhat.com>
References: <20241009011523.2381575-1-bmarzins@redhat.com>
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

If reload_and_sync_map() removes the multipath device,
deferred_failback_tick() needs to decrement the counter so that it
doesn't skip the following device.

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index ec172021..846be5a9 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2098,9 +2098,12 @@ deferred_failback_tick (struct vectors *vecs)
 
 			if (!mpp->failback_tick &&
 			    need_switch_pathgroup(mpp, &need_reload)) {
-				if (need_reload)
-					reload_and_sync_map(mpp, vecs);
-				else
+				if (need_reload) {
+					if (reload_and_sync_map(mpp, vecs) == 2) {
+						/* multipath device removed */
+						i--;
+					}
+				} else
 					switch_pathgroup(mpp);
 			}
 		}
-- 
2.45.0

