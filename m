Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEA3C184120
	for <dm-devel@lists.linux.dev>; Wed, 17 Jul 2024 18:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721239878; cv=none; b=gfc3PWEwG3h8WsULq1nPHdeygnUC6qM+xxULPn0P7szAgzEzxHqdWkXuwTqD2gRsox1/1O7H5Hniw0xOuJHY6V1N0XxN78dWVeN+03TOVors6OB2KD1tKl7snYAbFjTsefRHjG6NxglY9iKF9VT5O8ruCXg8tuYBXn0OKjjpg0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721239878; c=relaxed/simple;
	bh=QHmuzgGtkePuUugHyyBeCbvWhC8AGk0byHyG6Vtx6mU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PWlgmgqkKXNDxjYCNYlYNDcosFUEDA7Z4Nh6xXFTXhVQDX6KHH32WoY2Wh0WmrhBDe0uZ73l6/b7KkUsJ7Ez+DWMxfW8gOcU3ybJh9IYs088uyfqeQ2dATmtgLuEKqiwzmbS1T14Mj7OKHXXqVZlCg/9HpFKKcZ9y+p9iCBjyU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RVgz5gSb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RVgz5gSb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721239876;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K64AKtG8KeMB6LYvyPJyDGCUEcRShhSyxoMzu9mWZzo=;
	b=RVgz5gSb+wxbOKqpQgkEc3q+PQZ41/gJjU1z6/s2pK9NAkMWz59Bm3HdwS0ktHG90jwifC
	M+YHGPUhl25PSNjTTwAIfCPJ7hDz6TTzgAyufJUA0KVbPSHE6NmimqimKxXsio6McMy1Kx
	fQnDYYLNfPcjlf7qIF+Wy0OLZBecHkc=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-646-JQkvQZddPnSBt9bspp5BEw-1; Wed,
 17 Jul 2024 14:11:11 -0400
X-MC-Unique: JQkvQZddPnSBt9bspp5BEw-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5942919560B1;
	Wed, 17 Jul 2024 18:11:10 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0962C1955D42;
	Wed, 17 Jul 2024 18:11:09 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46HIB8Jw2173592
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 17 Jul 2024 14:11:08 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46HIB87J2173591;
	Wed, 17 Jul 2024 14:11:08 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 09/20] multipathd: reorder path state checks
Date: Wed, 17 Jul 2024 14:10:55 -0400
Message-ID: <20240717181106.2173527-10-bmarzins@redhat.com>
In-Reply-To: <20240717181106.2173527-1-bmarzins@redhat.com>
References: <20240717181106.2173527-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Reorder the path state checks in check_path(), so that it first does
all the checks which can result in returning with the path unchecked or
removed from the multipath device.

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 733952cf..08b424d6 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2385,19 +2385,8 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
 	pp->tick = checkint;
 
 	newstate = check_path_state(pp);
-	if (newstate == PATH_WILD || newstate == PATH_UNCHECKED) {
+	if (newstate == PATH_WILD || newstate == PATH_UNCHECKED)
 		return 0;
-	} else if ((newstate != PATH_UP && newstate != PATH_GHOST &&
-		    newstate != PATH_PENDING) && (pp->state == PATH_DELAYED)) {
-		/* If path state become failed again cancel path delay state */
-		pp->state = newstate;
-		/*
-		 * path state bad again should change the check interval time
-		 * to the shortest delay
-		 */
-		pp->checkint = checkint;
-		return 1;
-	}
 	/*
 	 * Async IO in flight. Keep the previous path state
 	 * and reschedule as soon as possible
@@ -2436,6 +2425,17 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
 		return 0;
 	}
 
+	if ((newstate != PATH_UP && newstate != PATH_GHOST &&
+	     newstate != PATH_PENDING) && (pp->state == PATH_DELAYED)) {
+		/* If path state become failed again cancel path delay state */
+		pp->state = newstate;
+		/*
+		 * path state bad again should change the check interval time
+		 * to the shortest delay
+		 */
+		pp->checkint = checkint;
+		return 1;
+	}
 	if ((newstate == PATH_UP || newstate == PATH_GHOST) &&
 	    (san_path_check_enabled(pp->mpp) ||
 	     marginal_path_check_enabled(pp->mpp))) {
-- 
2.45.0

