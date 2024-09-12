Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5C391BE857
	for <dm-devel@lists.linux.dev>; Thu, 12 Sep 2024 21:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726177798; cv=none; b=YXtr+YagVqw5MRiKdp6CrZxE/uLtk74bHrgt3bHVjzGKwzuZunqINYj5SED3ZiXiyEiMMRb7X03R6UVpnwUDOkPpAhNPevYErzrh5XazLRXApDUpHyWJ1Sz1EcPt2eJoZ5tZkOXuUY9KfvdyQDRQi+y7RmNSlyU7zmHS1zB1x8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726177798; c=relaxed/simple;
	bh=jArEZ4bLwr1/o+sSReaJG+ycv+PTVpV0TOh2GPnzgWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s9deWbiP+KHVydbsIhRlDEihxeKocqyJIm5t7yenZlKEy/10ly7u7t3B9rNxrj6eulJJYny7rD0K2bvrP8bxG8Xf/0qfKW3DtpIv5skNKtEvYyYxr5RRSAYtqmT2kaNGjcv6eW/qOzFpB4xEPBlapGsQ9p/au+quzBeSZr/RmwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gprXRjjm; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gprXRjjm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726177795;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xjdaIbqBcBF2AYepiLmnwdv/nVszpzcUlJviRtXWHDo=;
	b=gprXRjjmfwjGHT/YAAvGQHfXxx0vbnkAXeLzfKUvPZp4zsVPYAaEEfRTFA6GF1Wvf5D4JL
	BEme6ypuw4Lvrc+TiQWYng+dhOPelHPq5V5Hr7HzZ9IMQ20fgopXbRmp5RpwrwQEKXgc6m
	wLduchSdm11O64J1kh0hH97vNzSbWwI=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-267-1jVlPUdCOBqad0yHJyppmw-1; Thu,
 12 Sep 2024 17:49:54 -0400
X-MC-Unique: 1jVlPUdCOBqad0yHJyppmw-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D256419560B2;
	Thu, 12 Sep 2024 21:49:53 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 521B91956052;
	Thu, 12 Sep 2024 21:49:53 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 48CLnpUl783948
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 12 Sep 2024 17:49:51 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 48CLnptt783947;
	Thu, 12 Sep 2024 17:49:51 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 21/22] multipathd: wait for checkers to complete
Date: Thu, 12 Sep 2024 17:49:46 -0400
Message-ID: <20240912214947.783819-22-bmarzins@redhat.com>
In-Reply-To: <20240912214947.783819-1-bmarzins@redhat.com>
References: <20240912214947.783819-1-bmarzins@redhat.com>
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

Multipath again waits for running checkers to complete. In pathinfo(),
mutipath will just wait 1ms if the checker is running. In checkerloop(),
if there are running checkers, multipathd will drop the vecs lock and
wait for 5ms. The difference it wait times is because multipathd cannot
drop the vecs lock in pathinfo.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/discovery.c          |  9 ++++++++-
 libmultipath/libmultipath.version |  1 +
 multipathd/main.c                 | 12 +++++++++++-
 3 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 6ccdfa0b..1d48c30a 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -2467,8 +2467,15 @@ int pathinfo(struct path *pp, struct config *conf, int mask)
 	if (mask & DI_CHECKER) {
 		if (path_state == PATH_UP) {
 			int newstate = PATH_UNCHECKED;
-			if (start_checker(pp, conf, 0, path_state) == 0)
+			if (start_checker(pp, conf, 0, path_state) == 0) {
+				if (checker_need_wait(&pp->checker)) {
+					struct timespec wait = {
+						.tv_nsec = 1000 * 1000,
+					};
+					nanosleep(&wait, NULL);
+				}
 				newstate = get_state(pp);
+			}
 			if (newstate != PATH_PENDING ||
 			    pp->state == PATH_UNCHECKED ||
 			    pp->state == PATH_WILD)
diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index 6439d3a7..c2e5f552 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -62,6 +62,7 @@ global:
 	checker_enable;
 	checker_message;
 	checker_name;
+	checker_need_wait;
 	checker_state_name;
 	check_foreign;
 	cleanup_bindings;
diff --git a/multipathd/main.c b/multipathd/main.c
index 5e68e470..5bac76ae 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2848,6 +2848,7 @@ update_uninitialized_path(struct vectors * vecs, struct path * pp)
 enum checker_state {
 	CHECKER_STARTING,
 	CHECKER_CHECKING_PATHS,
+	CHECKER_WAITING_FOR_PATHS,
 	CHECKER_UPDATING_PATHS,
 	CHECKER_FINISHED,
 };
@@ -2859,6 +2860,7 @@ check_paths(struct vectors *vecs, unsigned int ticks)
 	struct timespec diff_time, start_time, end_time;
 	struct path *pp;
 	int i;
+	bool need_wait = false;
 
 	get_monotonic_time(&start_time);
 
@@ -2869,6 +2871,9 @@ check_paths(struct vectors *vecs, unsigned int ticks)
 			pp->is_checked = check_path(pp, ticks);
 		else
 			pp->is_checked = check_uninitialized_path(pp, ticks);
+		if (pp->is_checked == CHECK_PATH_STARTED &&
+		    checker_need_wait(&pp->checker))
+			need_wait = true;
 		if (++paths_checked % 128 == 0 &&
 		    (lock_has_waiters(&vecs->lock) || waiting_clients())) {
 			get_monotonic_time(&end_time);
@@ -2877,7 +2882,7 @@ check_paths(struct vectors *vecs, unsigned int ticks)
 				return CHECKER_CHECKING_PATHS;
 		}
 	}
-	return CHECKER_UPDATING_PATHS;
+	return need_wait ? CHECKER_WAITING_FOR_PATHS : CHECKER_UPDATING_PATHS;
 }
 
 static enum checker_state
@@ -2999,6 +3004,11 @@ checkerloop (void *ap)
 			if (checker_state != CHECKER_FINISHED) {
 				/* Yield to waiters */
 				struct timespec wait = { .tv_nsec = 10000, };
+				if (checker_state == CHECKER_WAITING_FOR_PATHS) {
+					/* wait 5ms */
+					wait.tv_nsec = 5 * 1000 * 1000;
+					checker_state = CHECKER_UPDATING_PATHS;
+				}
 				nanosleep(&wait, NULL);
 			}
 		}
-- 
2.45.0

