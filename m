Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C2E170A27
	for <dm-devel@lists.linux.dev>; Tue, 15 Oct 2024 03:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728962926; cv=none; b=Q2IhU8UQ2FUCqwn8BSa2DpDFp+vF3isOW8zUxfWsT7krkPaCoNd9yRBdtcvIKM72P50oyCToSoDsUSSaiyGe/NvHfYO8woHFDZSr/s5OrbMl3cMZvIkqSpbwXj0jsqpb5BDQywCY8ohgqzUi6qqmOYBYK3/syn3ywk6ciNiMIwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728962926; c=relaxed/simple;
	bh=M9eNzj/l2YhC0Ow+8Y85N5SSEpFfJWxEJcScAAC0SPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ONd0Qp57/iDIdIH+q+xq85NTEr8yAHIGhP3FBHHQxxb/SQ/rV7pmIvwnKmWaw3HDssYIWETZGL0Q92sfRa9hUTaPJJ6wRkkpPNMdtD1hWxsZLZCVzkpSbay4u9HYA7SaIyF5R4YkZo9TfO09IhzS55v5LmO6JgvhyapZF8RDI3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ODdaI6o7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ODdaI6o7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728962922;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/xSNWjnq4MvF1/6rUIiggT/NFv8MV1T6dyoFZEajvUg=;
	b=ODdaI6o7/G5Q/4cLPQe6lt6JbuoERhetDYL4j2blO5OWdophfRQgGm8AI1u1Nijg82Lm7T
	aTbsy6/5gR4HQWFu5fXPYbZ6mj9EkEYrIm2tPmiFHh0DgDYbAcHcnMrwoCQt+eEdb8K7R1
	bi1KyTt+rlsy/yqIvF35ttKbZ8ASoM0=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-530-AxgDOgmYOjSlWDPoDbIlGg-1; Mon,
 14 Oct 2024 23:28:39 -0400
X-MC-Unique: AxgDOgmYOjSlWDPoDbIlGg-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3F2EB1956096;
	Tue, 15 Oct 2024 03:28:38 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F3E4B19560AE;
	Tue, 15 Oct 2024 03:28:37 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 49F3SawE2693311
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 14 Oct 2024 23:28:36 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 49F3SaHp2693310;
	Mon, 14 Oct 2024 23:28:36 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v5 08/23] multipathd: split check_path_state into two functions
Date: Mon, 14 Oct 2024 23:28:20 -0400
Message-ID: <20241015032835.2693247-9-bmarzins@redhat.com>
In-Reply-To: <20241015032835.2693247-1-bmarzins@redhat.com>
References: <20241015032835.2693247-1-bmarzins@redhat.com>
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
get_new_state() which gets the new state from either pp->sysfs_state
or get_state().

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 33a57041..16c0531e 100644
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
+get_new_state(struct path *pp)
+{
+	int newstate = pp->sysfs_state;
+	struct config *conf;
+
+	if (newstate == PATH_UP)
+		newstate = get_state(pp);
 	/*
 	 * Wait for uevent for removed paths;
 	 * some LLDDs like zfcp keep paths unavailable
@@ -2413,7 +2419,8 @@ do_check_path (struct vectors * vecs, struct path * pp)
 		pp->checkint = checkint;
 	};
 
-	newstate = check_path_state(pp);
+	start_path_check(pp);
+	newstate = get_new_state(pp);
 	if (newstate == PATH_WILD || newstate == PATH_UNCHECKED)
 		return CHECK_PATH_SKIPPED;
 	/*
@@ -2752,7 +2759,8 @@ handle_uninitialized_path(struct vectors * vecs, struct path * pp,
 		}
 	}
 
-	newstate = check_path_state(pp);
+	start_path_check(pp);
+	newstate = get_new_state(pp);
 
 	if (!strlen(pp->wwid) &&
 	    (pp->initialized == INIT_FAILED || pp->initialized == INIT_NEW) &&
-- 
2.45.0

