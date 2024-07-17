Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53955180A9E
	for <dm-devel@lists.linux.dev>; Wed, 17 Jul 2024 18:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721239875; cv=none; b=FWRRIy+CMjieGXiY7y5pcW+w4nAOhAhnu2SfurTOq5W5yn1kjO+dT5I3LgaRVM1KuaBM7QkwO9efhBb4uwDe9+rW0lYDs6ysvIDhmq/BoZH85AI/3SEQTjZl5LqzpBD+9K/bW7VQKFiNj2mpjW06wLOvc+XbNRbrNkG9Q+KiXOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721239875; c=relaxed/simple;
	bh=10Lc3T9xDNIHk89BsJ6urvIogyQdCNAt6Tul9nmHLlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pkQG6pxgSJkuqGL0MkHSfooBEuEiCUvHa9m3Vb/3sJ1zyWWi/cDyz7tG2KZa2xYGzAW+PNxqc7Bdps/zrsaZ7dgvdQWcE55u861P9Eq+A380+mCRxs6SPB+Ud4JTziI8qVVpQc5diXtaRqLEHAzoyhO9YKd5/A3A9AOhXc4Dmls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TMDOpiDB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TMDOpiDB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721239873;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u5c7fVNR8onkmcmBl8P0wSYKM7bsAs+xAKx3SL3GDVE=;
	b=TMDOpiDBtFijPNLxGGnQANEltcD/zqcRyeRo/Vp5rdys4VZb25kpvFUu+0/BP8m3gH78VH
	AViqMx/k86W0catKT5L5EBq21EOen28ovNiFibWbQtYAKuSJt/N5Z1nyervwQcYuHwyVwr
	qwVtp0x7f9KMNjo+uw1d3V2d/WWgFf0=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-678-rB6eh1MAPF-gN63cvBslQg-1; Wed,
 17 Jul 2024 14:11:12 -0400
X-MC-Unique: rB6eh1MAPF-gN63cvBslQg-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EF8771956095;
	Wed, 17 Jul 2024 18:11:10 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8FABA19560B2;
	Wed, 17 Jul 2024 18:11:10 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46HIB9XV2173608
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 17 Jul 2024 14:11:09 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46HIB9WX2173607;
	Wed, 17 Jul 2024 14:11:09 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 13/20] multipathd: always resync map in reload_and_sync_map
Date: Wed, 17 Jul 2024 14:10:59 -0400
Message-ID: <20240717181106.2173527-14-bmarzins@redhat.com>
In-Reply-To: <20240717181106.2173527-1-bmarzins@redhat.com>
References: <20240717181106.2173527-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

reload_and_sync_map() needs to always resync the map after calling
reload_map(), because the mpp state may no longer match the kernel
state if reload_map() fails.

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 6d1a5382..0d2a6780 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2188,13 +2188,15 @@ static int reload_map(struct vectors *vecs, struct multipath *mpp,
 
 int reload_and_sync_map(struct multipath *mpp, struct vectors *vecs)
 {
+	int ret = 0;
+
 	if (reload_map(vecs, mpp, 1))
-		return 1;
+		ret = 1;
 	if (setup_multipath(vecs, mpp) != 0)
 		return 2;
 	sync_map_state(mpp);
 
-	return 0;
+	return ret;
 }
 
 static int check_path_reinstate_state(struct path * pp) {
-- 
2.45.0

