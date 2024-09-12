Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 717E51C1AD6
	for <dm-devel@lists.linux.dev>; Thu, 12 Sep 2024 21:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726177796; cv=none; b=t8ivIQ408Z15nyaiOJET2RXdY5mxu2ZGNwj5R8i4fL8c9z2ovvNilBLxW3C1PM87ABOYwR4ep7C/lxiujoagWe4rUajSFXvq4fBMjIOjYaM7OxoqaVqT7SVwJvJRGuoVG+jvUU9Mn9KHN8+x0DyPFPXd+97Hj2Hc4P8N+u9yCrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726177796; c=relaxed/simple;
	bh=OB3JZ1UIfv1ZzdmlPUpOVfCAjrP9Oe7Bq5b99mSvztw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U3D90knvt/R5nrrC19T0LTVYqxTyZKlQz2gxqIk47O6wwq0+36YAQE3PD9aM28e35on5+YRIGQEqDHfW8FWlYpOKUygqxVwx01OL+6HWo73TqTXpz+OHvZ98rzev8brd5rGYml43leW2e/5Ng5fY4if1tyH3papoU7lQMknrjUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h26G/AvE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h26G/AvE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726177793;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zoXQhxfJi57TpV1HibV10MGdfraWJnozoF5K1JuvKGc=;
	b=h26G/AvEPiL3tV7DuWjL6Goluo6EDiIjeLzY3dGRiO+alZFG3DYEX1hV5kzcXgpAybo1OH
	zxesh0+0jc5ZV6UZ24ymHoXiEzrXJSqV+F19rZl3GZESLsnTrlxOU0PqeZFuSPCz4OMb1/
	vdUwag/T1JWFV3G3ZA/kRZHTiv5k/WY=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-63-WxqNb94YPd2oxII5ay1fNg-1; Thu,
 12 Sep 2024 17:49:52 -0400
X-MC-Unique: WxqNb94YPd2oxII5ay1fNg-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 602F919560B1;
	Thu, 12 Sep 2024 21:49:51 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DA6333001D17;
	Thu, 12 Sep 2024 21:49:50 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 48CLnng8783874
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 12 Sep 2024 17:49:49 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 48CLnnO6783873;
	Thu, 12 Sep 2024 17:49:49 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 06/22] libmultipath: split get_state into two functions
Date: Thu, 12 Sep 2024 17:49:31 -0400
Message-ID: <20240912214947.783819-7-bmarzins@redhat.com>
In-Reply-To: <20240912214947.783819-1-bmarzins@redhat.com>
References: <20240912214947.783819-1-bmarzins@redhat.com>
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

get_state() is now split into start_checker(), which runs the checker
but doesn't wait for async checkers, and get_state(), which returns the
state from the checker, after waiting for async checkers if necessary.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/discovery.c          | 22 ++++++++++++++++------
 libmultipath/discovery.h          |  4 +++-
 libmultipath/libmultipath.version |  1 +
 multipathd/main.c                 |  4 +++-
 4 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 5648be60..e0f46ff2 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1974,30 +1974,29 @@ cciss_ioctl_pathinfo(struct path *pp)
 }
 
 int
-get_state (struct path * pp, struct config *conf, int daemon, int oldstate)
+start_checker (struct path * pp, struct config *conf, int daemon, int oldstate)
 {
 	struct checker * c = &pp->checker;
-	int state;
 
 	if (!checker_selected(c)) {
 		if (daemon) {
 			if (pathinfo(pp, conf, DI_SYSFS) != PATHINFO_OK) {
 				condlog(3, "%s: couldn't get sysfs pathinfo",
 					pp->dev);
-				return PATH_UNCHECKED;
+				return -1;
 			}
 		}
 		select_detect_checker(conf, pp);
 		select_checker(conf, pp);
 		if (!checker_selected(c)) {
 			condlog(3, "%s: No checker selected", pp->dev);
-			return PATH_UNCHECKED;
+			return -1;
 		}
 		checker_set_fd(c, pp->fd);
 		if (checker_init(c, pp->mpp?&pp->mpp->mpcontext:NULL)) {
 			checker_clear(c);
 			condlog(3, "%s: checker init failed", pp->dev);
-			return PATH_UNCHECKED;
+			return -1;
 		}
 	}
 	if (pp->mpp && !c->mpcontext)
@@ -2008,6 +2007,15 @@ get_state (struct path * pp, struct config *conf, int daemon, int oldstate)
 	else
 		checker_set_sync(c);
 	checker_check(c, oldstate);
+	return 0;
+}
+
+int
+get_state (struct path * pp)
+{
+	struct checker * c = &pp->checker;
+	int state;
+
 	state = checker_get_state(c);
 	condlog(3, "%s: %s state = %s", pp->dev,
 		checker_name(c), checker_state_name(state));
@@ -2455,7 +2463,9 @@ int pathinfo(struct path *pp, struct config *conf, int mask)
 
 	if (mask & DI_CHECKER) {
 		if (path_state == PATH_UP) {
-			int newstate = get_state(pp, conf, 0, path_state);
+			int newstate = PATH_UNCHECKED;
+			if (start_checker(pp, conf, 0, path_state) == 0)
+				newstate = get_state(pp);
 			if (newstate != PATH_PENDING ||
 			    pp->state == PATH_UNCHECKED ||
 			    pp->state == PATH_WILD)
diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
index c93abf1c..f3e0c618 100644
--- a/libmultipath/discovery.h
+++ b/libmultipath/discovery.h
@@ -34,7 +34,9 @@ int path_discovery (vector pathvec, int flag);
 int path_get_tpgs(struct path *pp); /* This function never returns TPGS_UNDEF */
 int do_tur (char *);
 int path_offline (struct path *);
-int get_state (struct path * pp, struct config * conf, int daemon, int state);
+int start_checker(struct path * pp, struct config * conf, int daemon,
+		  int state);
+int get_state(struct path * pp);
 int get_vpd_sgio (int fd, int pg, int vend_id, char * str, int maxlen);
 int pathinfo (struct path * pp, struct config * conf, int mask);
 int alloc_path_with_pathinfo (struct config *conf, struct udev_device *udevice,
diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index 21d48da6..bb34d9e8 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -160,6 +160,7 @@ global:
 	remove_wwid;
 	replace_wwids;
 	reset_checker_classes;
+	start_checker;
 	select_all_tg_pt;
 	select_action;
 	select_find_multipaths_timeout;
diff --git a/multipathd/main.c b/multipathd/main.c
index 1b7fd04f..4f752adb 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2324,7 +2324,9 @@ check_path_state(struct path *pp)
 	if (newstate == PATH_UP) {
 		conf = get_multipath_config();
 		pthread_cleanup_push(put_multipath_config, conf);
-		newstate = get_state(pp, conf, 1, newstate);
+		newstate = PATH_UNCHECKED;
+		if (start_checker(pp, conf, 1, newstate) == 0)
+			newstate = get_state(pp);
 		pthread_cleanup_pop(1);
 	} else {
 		checker_clear_message(&pp->checker);
-- 
2.45.0

