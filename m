Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDCB818411D
	for <dm-devel@lists.linux.dev>; Wed, 17 Jul 2024 18:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721239878; cv=none; b=m32LN3hKSkFMv9gf+ZLIMF5LK1wu9+IsgVLSu8i/e4U04NOwp4eZm7tfB0Zes5U3GnmD0HW4AhZMAf/qsgY2HVl7yk1VRLZ4yJc1+7bPQyI8VWMStGcyf15cJ5mR3H+WlsXXuhHLr5U9VFowscRyDB2oj/I5N6oY197wwifs/vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721239878; c=relaxed/simple;
	bh=NNOq3gcsc6zNjTSwEMTwjwhxo/Msu5+ynxkhtGB+Whk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A1MnEdDVqH06XF9NG8QCrfEOp3ALPoLomRUhz1iK0UPgmxvKg/6UQuwYOhodO1FIR35LDCiTJqVfrLD+FHJo3m46SsP7Og/ZR/J+bpDjj2QvV51wcycz/0T8yOS7zX7FUAmQpahxvGMaFa3qT2cgtrxxx6VH8GjLDNw1uV3HG6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FaH6GeT6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FaH6GeT6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721239875;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M2lRXqADz2y9512f7J/tigDfMxzm8DUV3G9Ms/1NL4A=;
	b=FaH6GeT6C03iPeJ95QJfFkVRvYqw/w83jn14Ap65rTEIXQlzXf84pd6HOKawKaZHDbfF9x
	F6mT7tAquZ+o/AsoU2/eGWaicXL+Ayyhf/D/pkQfpENMVzsF4vfxwTXfRAjr3cXO+bsOec
	5ZC253Oa5iwxxVtPJLTyYQ8p7KT+OYo=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-654-at7Kxsh1N3ePW7dmKViu5w-1; Wed,
 17 Jul 2024 14:11:12 -0400
X-MC-Unique: at7Kxsh1N3ePW7dmKViu5w-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BEE101955D45;
	Wed, 17 Jul 2024 18:11:09 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 42ADA1956046;
	Wed, 17 Jul 2024 18:11:09 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46HIB7g72173576
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 17 Jul 2024 14:11:08 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46HIB7em2173575;
	Wed, 17 Jul 2024 14:11:07 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 05/20] multipathd: handle uninitialized paths in new function
Date: Wed, 17 Jul 2024 14:10:51 -0400
Message-ID: <20240717181106.2173527-6-bmarzins@redhat.com>
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

Pull the code to handle uninitialized paths out of check_path() and into
a new function called handle_uninitialized_paths(). This should cause
no functional changes. Also make check_path() static.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 168 ++++++++++++++++++++++++++++------------------
 1 file changed, 101 insertions(+), 67 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 37e6bd18..2331f18e 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2343,10 +2343,9 @@ check_path_state(struct path *pp)
 }
 
 /*
- * Returns '1' if the path has been checked, '-1' if it was blacklisted
- * and '0' otherwise
+ * Returns '1' if the path has been checked and '0' otherwise
  */
-int
+static int
 check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
 {
 	int newstate;
@@ -2354,16 +2353,13 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
 	int chkr_new_path_up = 0;
 	int disable_reinstate = 0;
 	int oldchkrstate = pp->chkrstate;
-	int retrigger_tries;
 	unsigned int checkint, max_checkint;
 	struct config *conf;
 	int marginal_pathgroups, marginal_changed = 0;
 	int ret;
 	bool need_reload;
 
-	if (((pp->initialized == INIT_OK || pp->initialized == INIT_PARTIAL ||
-	      pp->initialized == INIT_REQUESTED_UDEV) && !pp->mpp) ||
-	    pp->initialized == INIT_REMOVED)
+	if (pp->initialized == INIT_REMOVED)
 		return 0;
 
 	if (pp->tick)
@@ -2372,7 +2368,6 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
 		return 0; /* don't check this path yet */
 
 	conf = get_multipath_config();
-	retrigger_tries = conf->retrigger_tries;
 	checkint = conf->checkint;
 	max_checkint = conf->max_checkint;
 	marginal_pathgroups = conf->marginal_pathgroups;
@@ -2383,38 +2378,6 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
 		pp->checkint = checkint;
 	};
 
-	if (!pp->mpp && pp->initialized == INIT_MISSING_UDEV) {
-		if (pp->retriggers < retrigger_tries) {
-			static const char change[] = "change";
-			ssize_t ret;
-
-			condlog(2, "%s: triggering change event to reinitialize",
-				pp->dev);
-			pp->initialized = INIT_REQUESTED_UDEV;
-			pp->retriggers++;
-			ret = sysfs_attr_set_value(pp->udev, "uevent", change,
-						   sizeof(change) - 1);
-			if (ret != sizeof(change) - 1)
-				log_sysfs_attr_set_value(1, ret,
-							 "%s: failed to trigger change event",
-							 pp->dev);
-			return 0;
-		} else {
-			condlog(1, "%s: not initialized after %d udev retriggers",
-				pp->dev, retrigger_tries);
-			/*
-			 * Make sure that the "add missing path" code path
-			 * below may reinstate the path later, if it ever
-			 * comes up again.
-			 * The WWID needs not be cleared; if it was set, the
-			 * state hadn't been INIT_MISSING_UDEV in the first
-			 * place.
-			 */
-			pp->initialized = INIT_FAILED;
-			return 0;
-		}
-	}
-
 	/*
 	 * provision a next check soonest,
 	 * in case we exit abnormally from here
@@ -2435,32 +2398,6 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
 		pp->checkint = checkint;
 		return 1;
 	}
-	if (!pp->mpp) {
-		if (!strlen(pp->wwid) &&
-		    (pp->initialized == INIT_FAILED ||
-		     pp->initialized == INIT_NEW) &&
-		    (newstate == PATH_UP || newstate == PATH_GHOST)) {
-			condlog(2, "%s: add missing path", pp->dev);
-			conf = get_multipath_config();
-			pthread_cleanup_push(put_multipath_config, conf);
-			ret = pathinfo(pp, conf, DI_ALL | DI_BLACKLIST);
-			pthread_cleanup_pop(1);
-			/* INIT_OK implies ret == PATHINFO_OK */
-			if (pp->initialized == INIT_OK) {
-				ev_add_path(pp, vecs, 1);
-				pp->tick = 1;
-			} else {
-				if (ret == PATHINFO_SKIPPED)
-					return -1;
-				/*
-				 * We failed multiple times to initialize this
-				 * path properly. Don't re-check too often.
-				 */
-				pp->checkint = max_checkint;
-			}
-		}
-		return 0;
-	}
 	/*
 	 * Async IO in flight. Keep the previous path state
 	 * and reschedule as soon as possible
@@ -2679,6 +2616,99 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
 	return 1;
 }
 
+/*
+ * Returns -1 if the path was blacklisted, and 0 otherwise
+ */
+static int
+handle_uninitialized_path(struct vectors * vecs, struct path * pp,
+			  unsigned int ticks)
+{
+	int newstate;
+	int retrigger_tries;
+	unsigned int checkint, max_checkint;
+	struct config *conf;
+	int ret;
+
+	if (pp->initialized != INIT_NEW && pp->initialized != INIT_FAILED &&
+	    pp->initialized != INIT_MISSING_UDEV)
+		return 0;
+
+	if (pp->tick)
+		pp->tick -= (pp->tick > ticks) ? ticks : pp->tick;
+	if (pp->tick)
+		return 0; /* don't check this path yet */
+
+	conf = get_multipath_config();
+	retrigger_tries = conf->retrigger_tries;
+	checkint = conf->checkint;
+	max_checkint = conf->max_checkint;
+	put_multipath_config(conf);
+
+	if (pp->initialized == INIT_MISSING_UDEV) {
+		if (pp->retriggers < retrigger_tries) {
+			static const char change[] = "change";
+			ssize_t ret;
+
+			condlog(2, "%s: triggering change event to reinitialize",
+				pp->dev);
+			pp->initialized = INIT_REQUESTED_UDEV;
+			pp->retriggers++;
+			ret = sysfs_attr_set_value(pp->udev, "uevent", change,
+						   sizeof(change) - 1);
+			if (ret != sizeof(change) - 1)
+				log_sysfs_attr_set_value(1, ret,
+							 "%s: failed to trigger change event",
+							 pp->dev);
+			return 0;
+		} else {
+			condlog(1, "%s: not initialized after %d udev retriggers",
+				pp->dev, retrigger_tries);
+			/*
+			 * Make sure that the "add missing path" code path
+			 * below may reinstate the path later, if it ever
+			 * comes up again.
+			 * The WWID needs not be cleared; if it was set, the
+			 * state hadn't been INIT_MISSING_UDEV in the first
+			 * place.
+			 */
+			pp->initialized = INIT_FAILED;
+			return 0;
+		}
+	}
+
+	/*
+	 * provision a next check soonest,
+	 * in case we exit abnormally from here
+	 */
+	pp->tick = checkint;
+
+	newstate = check_path_state(pp);
+
+	if (!strlen(pp->wwid) &&
+	    (pp->initialized == INIT_FAILED || pp->initialized == INIT_NEW) &&
+	    (newstate == PATH_UP || newstate == PATH_GHOST)) {
+		condlog(2, "%s: add missing path", pp->dev);
+		conf = get_multipath_config();
+		pthread_cleanup_push(put_multipath_config, conf);
+		ret = pathinfo(pp, conf, DI_ALL | DI_BLACKLIST);
+		pthread_cleanup_pop(1);
+		/* INIT_OK implies ret == PATHINFO_OK */
+		if (pp->initialized == INIT_OK) {
+			ev_add_path(pp, vecs, 1);
+			pp->tick = 1;
+		} else {
+			if (ret == PATHINFO_SKIPPED)
+				return -1;
+			/*
+			 * We failed multiple times to initialize this
+			 * path properly. Don't re-check too often.
+			 */
+			pp->checkint = max_checkint;
+		}
+	}
+	return 0;
+}
+
 enum checker_state {
 	CHECKER_STARTING,
 	CHECKER_RUNNING,
@@ -2751,7 +2781,11 @@ checkerloop (void *ap)
 				if (pp->is_checked)
 					continue;
 				pp->is_checked = true;
-				rc = check_path(vecs, pp, ticks);
+				if (pp->mpp)
+					rc = check_path(vecs, pp, ticks);
+				else
+					rc = handle_uninitialized_path(vecs, pp,
+								       ticks);
 				if (rc < 0) {
 					condlog(1, "%s: check_path() failed, removing",
 						pp->dev);
-- 
2.45.0

