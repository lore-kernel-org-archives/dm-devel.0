Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41D9E1ABEC4
	for <dm-devel@lists.linux.dev>; Wed, 28 Aug 2024 22:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724883486; cv=none; b=jZHplbfbxp7NDOQCu/eCsx1KroXEGOOWKW2nTeo+WpBWEruAsXhU7pZ6lODm5io6k1Ew/s4baeUAwLUrtY0qz7VdumCXgFtoZrzC9VXaOqeadCUB84Cy1WlWmmMYr2hRsTye7OBwso8WaegTZ5B6xoZXquvW2ZhPcxLqlFlyYG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724883486; c=relaxed/simple;
	bh=t1CVHnz7nyLxj9DvG5v0AAcEtuQaZ5kvEsS7/zxCsS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rd/CfCFp/ltoT6lngFdZgiVVP2cb54+8JkGL/+UkmgKeKMzN64SiHqCKbureQ67ejVJraFXLPE+gPJ1qSyDqa/vED8SVK3zvK9iW7r2sSbp9+pRszHzkRPfoGtP/+nFE6zocmatzYn5Z/3B5Rj7CRy/u2kyvXuvxbSFKjghmpzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LpDU7NvU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LpDU7NvU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724883483;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DBExaL7P/fCEEJ4uOwXRzQCyxrL+2tQoJftird3oOpo=;
	b=LpDU7NvU8oiuB/8PR/HJT77pTQ6K+a2/qi/Wd3Nb4YOUwfaGWys7cK6+MP/Rmkigl0C/cq
	CJaZEEoiEQhT0T/dfxMHzBULSE240dgiou3yw4/KG0ESyYRMSthL/nx62hg1/8AKk45Ul1
	suDjkhUTRl5DMW0nQH7py0XuDx9cQaU=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-504-tNoDkbLHMkKG1ZLtyNLCwA-1; Wed,
 28 Aug 2024 18:18:01 -0400
X-MC-Unique: tNoDkbLHMkKG1ZLtyNLCwA-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A35D61955D57;
	Wed, 28 Aug 2024 22:18:00 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3962019560A3;
	Wed, 28 Aug 2024 22:18:00 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 47SMHwli4060604
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 28 Aug 2024 18:17:58 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 47SMHwpm4060603;
	Wed, 28 Aug 2024 18:17:58 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 08/15] multipathd: split check_path_state into two functions
Date: Wed, 28 Aug 2024 18:17:50 -0400
Message-ID: <20240828221757.4060548-9-bmarzins@redhat.com>
In-Reply-To: <20240828221757.4060548-1-bmarzins@redhat.com>
References: <20240828221757.4060548-1-bmarzins@redhat.com>
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

check_path_state() is now split into start_path_check(), which calls
path_sysfs_state() and if the path is up also calls start_checker(), and
check_path_state() which gets the new state from either pp->sysfs_state
or get_state().

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 33a57041..d157e3c2 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2314,25 +2314,31 @@ should_skip_path(struct path *pp){
 	return 0;
 }
 
-static int
-check_path_state(struct path *pp)
+static void
+start_path_check(struct path *pp)
 {
-	int newstate;
 	struct config *conf;
 
-	newstate = path_sysfs_state(pp);
-	if (newstate == PATH_UP) {
+	if (path_sysfs_state(pp) ==  PATH_UP) {
 		conf = get_multipath_config();
 		pthread_cleanup_push(put_multipath_config, conf);
-		newstate = PATH_UNCHECKED;
-		if (start_checker(pp, conf, 1, newstate) == 0)
-			newstate = get_state(pp);
+		start_checker(pp, conf, 1, PATH_UNCHECKED);
 		pthread_cleanup_pop(1);
 	} else {
 		checker_clear_message(&pp->checker);
 		condlog(3, "%s: state %s, checker not called",
-			pp->dev, checker_state_name(newstate));
+			pp->dev, checker_state_name(pp->sysfs_state));
 	}
+}
+
+static int
+check_path_state(struct path *pp)
+{
+	int newstate = pp->sysfs_state;
+	struct config *conf;
+
+	if (newstate == PATH_UP)
+		newstate = get_state(pp);
 	/*
 	 * Wait for uevent for removed paths;
 	 * some LLDDs like zfcp keep paths unavailable
@@ -2413,6 +2419,7 @@ do_check_path (struct vectors * vecs, struct path * pp)
 		pp->checkint = checkint;
 	};
 
+	start_path_check(pp);
 	newstate = check_path_state(pp);
 	if (newstate == PATH_WILD || newstate == PATH_UNCHECKED)
 		return CHECK_PATH_SKIPPED;
@@ -2752,6 +2759,7 @@ handle_uninitialized_path(struct vectors * vecs, struct path * pp,
 		}
 	}
 
+	start_path_check(pp);
 	newstate = check_path_state(pp);
 
 	if (!strlen(pp->wwid) &&
-- 
2.45.0

