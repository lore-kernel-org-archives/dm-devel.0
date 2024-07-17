Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDFB21822E1
	for <dm-devel@lists.linux.dev>; Wed, 17 Jul 2024 18:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721239877; cv=none; b=FUMCbI8g8RGuQiFd901rx57q9OJVepG5zdWEMoxSsGd6x/g/1q3zbuZ5TL6Dow7DZFv+7vSJRSJeWWIwO6pVgcmgOl6gwc0QLhse9UVQZCLesHIPAcpJVy9Qt+ptA2/Ap+T7xwxE8px3OcLi4Hgkl5bH1lzak+ZE+vSSFJcJ4QU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721239877; c=relaxed/simple;
	bh=7/sKx7s1JrUyqU9PdccNe0yRxCgbCzT/VuMbe4sdiHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sCY0rT+6zqtzGejiWO3BX+4BSXQU57aQNcz1qxXxOf1sTbgsyvD9o7W1wvMUn0RW7YiOGQS2ZNujxE6TWdV7vqEYvuGXkXhDibx651CSDEKcm0mnrAD5eoJTsqmj+D11TiYUY2zq+O5KWr+C44a8l1hbiskywiRAabNkid7RFUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cCZkZj3p; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cCZkZj3p"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721239873;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ni238ux9tshvYi/hZiHKFQs+wdfve54sBELVGEW6cMY=;
	b=cCZkZj3pDemwZAV0Tcj6BTNd8Y3hw5ahdjhMKeWH6Kvj1+u4xDbvwSk6dZ42GOSoG8aviD
	Ff9kpPIpwsK3TqeCtMqEIncdKEIXxDcTA0/w5PndyiHUUXb+HWA6zylkjbDMIX90TkkbCK
	2jvbDsAc8f6xE87ann4SujfP2gWTJzI=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-1-gS6k8BSxOvmzLCHxrdxl2Q-1; Wed,
 17 Jul 2024 14:11:10 -0400
X-MC-Unique: gS6k8BSxOvmzLCHxrdxl2Q-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 78BF51955F3D;
	Wed, 17 Jul 2024 18:11:09 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 157293000187;
	Wed, 17 Jul 2024 18:11:08 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46HIB72m2173572
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 17 Jul 2024 14:11:07 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46HIB7372173571;
	Wed, 17 Jul 2024 14:11:07 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 04/20] multipathd: refactor path state getting code into a helper
Date: Wed, 17 Jul 2024 14:10:50 -0400
Message-ID: <20240717181106.2173527-5-bmarzins@redhat.com>
In-Reply-To: <20240717181106.2173527-1-bmarzins@redhat.com>
References: <20240717181106.2173527-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Pull the code that gets the new path state out into a helper function
named check_path_state(), in preparation for splittig check_path()
into two functions.

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 64 ++++++++++++++++++++++++++++-------------------
 1 file changed, 38 insertions(+), 26 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index eaef505a..37e6bd18 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2305,6 +2305,43 @@ should_skip_path(struct path *pp){
 	return 0;
 }
 
+static int
+check_path_state(struct path *pp)
+{
+	int newstate;
+	struct config *conf;
+
+	newstate = path_offline(pp);
+	if (newstate == PATH_UP) {
+		conf = get_multipath_config();
+		pthread_cleanup_push(put_multipath_config, conf);
+		newstate = get_state(pp, conf, 1, newstate);
+		pthread_cleanup_pop(1);
+	} else {
+		checker_clear_message(&pp->checker);
+		condlog(3, "%s: state %s, checker not called",
+			pp->dev, checker_state_name(newstate));
+	}
+	/*
+	 * Wait for uevent for removed paths;
+	 * some LLDDs like zfcp keep paths unavailable
+	 * without sending uevents.
+	 */
+	if (newstate == PATH_REMOVED)
+		newstate = PATH_DOWN;
+
+	if (newstate == PATH_WILD || newstate == PATH_UNCHECKED) {
+		condlog(2, "%s: unusable path (%s) - checker failed",
+			pp->dev, checker_state_name(newstate));
+		LOG_MSG(2, pp);
+		conf = get_multipath_config();
+		pthread_cleanup_push(put_multipath_config, conf);
+		pathinfo(pp, conf, 0);
+		pthread_cleanup_pop(1);
+	}
+	return newstate;
+}
+
 /*
  * Returns '1' if the path has been checked, '-1' if it was blacklisted
  * and '0' otherwise
@@ -2384,33 +2421,8 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
 	 */
 	pp->tick = checkint;
 
-	newstate = path_offline(pp);
-	if (newstate == PATH_UP) {
-		conf = get_multipath_config();
-		pthread_cleanup_push(put_multipath_config, conf);
-		newstate = get_state(pp, conf, 1, newstate);
-		pthread_cleanup_pop(1);
-	} else {
-		checker_clear_message(&pp->checker);
-		condlog(3, "%s: state %s, checker not called",
-			pp->dev, checker_state_name(newstate));
-	}
-	/*
-	 * Wait for uevent for removed paths;
-	 * some LLDDs like zfcp keep paths unavailable
-	 * without sending uevents.
-	 */
-	if (newstate == PATH_REMOVED)
-		newstate = PATH_DOWN;
-
+	newstate = check_path_state(pp);
 	if (newstate == PATH_WILD || newstate == PATH_UNCHECKED) {
-		condlog(2, "%s: unusable path (%s) - checker failed",
-			pp->dev, checker_state_name(newstate));
-		LOG_MSG(2, pp);
-		conf = get_multipath_config();
-		pthread_cleanup_push(put_multipath_config, conf);
-		pathinfo(pp, conf, 0);
-		pthread_cleanup_pop(1);
 		return 1;
 	} else if ((newstate != PATH_UP && newstate != PATH_GHOST &&
 		    newstate != PATH_PENDING) && (pp->state == PATH_DELAYED)) {
-- 
2.45.0

