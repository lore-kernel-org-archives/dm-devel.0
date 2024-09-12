Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B8E81C2459
	for <dm-devel@lists.linux.dev>; Thu, 12 Sep 2024 21:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726177798; cv=none; b=g7NuEDodL+9rDSG6y2AI0ZgtuVjAhj5aJZ7EHpAZDyCZl3OMh92eeWCa64FY1ZlCtdWbJr/XztwZIxYcVxV8GlLADTnm+ai1SfCJLsKBnN9dsnC4t7WGqPJJLhUUa0Mg7ii7aKjLJfFte+Lbu87tEhkPBl5plGojQ5iKQyv8Q+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726177798; c=relaxed/simple;
	bh=h3NYc3UzQyQmr2Vi6El2z8J1VZnPwk1MfO9FJlQ1yng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eUh35TbEshTxiuJ+TrVvovcvfixstutRo26VScJMNGfZhPMKD6PrOsOt7DgI66Lj/B0nLBVpbIPY07PJEUfsRZYI1QLNY5IpJ1eywzmXNFTIyU7RqW+9V628mDUldw0DENF5Ua0Gb3OfoIYXtCUsv4CA0K+oOXjhKX2wCutYDBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Xz9qaQVj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Xz9qaQVj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726177795;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lAB0LNz55BTC8G2muV+3xQy7AhiRXSObsBJz/xVAg9s=;
	b=Xz9qaQVjj5acTSOhx9LHOECWn1YTHK3tYlHmCNskj8FFFfYRNtvhf0uwrMBy6f66hBAfKU
	+kpnygW1evhnyExlTzKABh52wdhkk0fd2GkvtfEN7dhGMXgp918Z0bNImfoq8uXsRjkQmt
	PcXDIGGxNsLOlgOKDCFzH/bePAc1AE8=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-546-SGnZg2kpMe6CdwJpn4H3fA-1; Thu,
 12 Sep 2024 17:49:54 -0400
X-MC-Unique: SGnZg2kpMe6CdwJpn4H3fA-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4C45F19560BD;
	Thu, 12 Sep 2024 21:49:53 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C2E1319560AA;
	Thu, 12 Sep 2024 21:49:52 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 48CLnpED783922
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 12 Sep 2024 17:49:51 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 48CLnpiM783921;
	Thu, 12 Sep 2024 17:49:51 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 18/22] multipathd: fix deferred_failback_tick for reload removes
Date: Thu, 12 Sep 2024 17:49:43 -0400
Message-ID: <20240912214947.783819-19-bmarzins@redhat.com>
In-Reply-To: <20240912214947.783819-1-bmarzins@redhat.com>
References: <20240912214947.783819-1-bmarzins@redhat.com>
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

If reload_and_sync_map() removes the multipath device,
deferred_failback_tick() needs to decrement the counter so that it
doesn't skip the following device.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 18632c7d..5e68e470 100644
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

