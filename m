Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E5451CAB5
	for <dm-devel@lists.linux.dev>; Sat, 13 Jul 2024 06:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720850719; cv=none; b=IhSwLP0sZS6RVFL1DtJuuHLukh77cTtO9X4qoETuJW9STCskyz5UK9UeYWS+TR5u/YRFyp0Ut3edxsE6s4uuu+dDhgALkDn6fTR8CDH4dWyFL+cmnLaC3yu72ae7jdVx4zvkSiolVpn4llifEA1Mwo8PdezBrXHw1KlhVdesSmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720850719; c=relaxed/simple;
	bh=fbI6sjpGkTM11rk+zUuSzJzQ+Q3hSa93apw7IUIy7Ws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CFOcf3WOreeLxrmH3frVMTtpUkJG7YB1PfGEdpZZo6rxFTOmooa01nKjEsan7d6KThKwkv2aRewO5JsQc8f7PsTAR+Ho+XYkj5c3v9wCWNcy/l/JLdt0ag1lqwnJkcIervNNcZndUK0BBeZVLxc14lxrVu3/EfBXiL9kvXN+MSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YoXe3WGw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YoXe3WGw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720850717;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IYS8ABrPVJcB9kFJ6ULZ6jDfUjeLtLp9B6n4NNk3LKQ=;
	b=YoXe3WGwRMQcKsDWVCxvQ5+0vQBlXIQQSoNz67T6mAE6oH0Csg3oKziT2PLe3DeYn0WxWK
	96yX94tjGMtGN8D0bbCfvUAnkuQHCT14LEgTInAzxyLS6imdomlpsRJd50mnnaLxQhqb8N
	mHps1okuqsy9VtnebdNzXspsVnxpbf0=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-625-cz1_bALHMEmIJ4aTtzLx9A-1; Sat,
 13 Jul 2024 02:05:11 -0400
X-MC-Unique: cz1_bALHMEmIJ4aTtzLx9A-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F029E196CDF1;
	Sat, 13 Jul 2024 06:05:09 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 525F71955F3B;
	Sat, 13 Jul 2024 06:05:09 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46D657H62015510
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 13 Jul 2024 02:05:08 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46D657TI2015509;
	Sat, 13 Jul 2024 02:05:07 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 04/22] multipathd: refactor path state getting code into a helper
Date: Sat, 13 Jul 2024 02:04:48 -0400
Message-ID: <20240713060506.2015463-5-bmarzins@redhat.com>
In-Reply-To: <20240713060506.2015463-1-bmarzins@redhat.com>
References: <20240713060506.2015463-1-bmarzins@redhat.com>
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

Pull the code that gets the new path state out into a helper function
named check_path_state(), in preparation for splittig check_path()
into two functions.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 64 ++++++++++++++++++++++++++++-------------------
 1 file changed, 38 insertions(+), 26 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 0b0ebc8a..9b1b5226 100644
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

