Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 060E21AD9C2
	for <dm-devel@lists.linux.dev>; Wed, 28 Aug 2024 22:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724883487; cv=none; b=DYrCNyqy8JI3Ec+ZBPZsVT1v3Iehm7kiRDdIBB8kaZ0bY6oAjV62yd/S/8cEQ88TUOUD/atZC7yf59oR9GTj6UtcX52Wxw1pOcL5FThtcYmMWmqDtPHp9+ZsVTqIOUoyoqEAoxQpB1pKLb6Xy1CeO7QIUXQxHVWJGBH9SFUvsHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724883487; c=relaxed/simple;
	bh=lz0UweZZiYQRxUOq5HY7SaJDfkmkHWRoBEbqeH8SlmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e2+goe7PgJYw0KiXaIRlTjGia4bycos47Vo0KvXkdq0XA01SvPQoff1uThCz4WDcZv6N8miJ+fjI8GqN4Kvosi4nv4ce2ZGwJCyjcHkKxIuClZY+NtJ9kLT0mdLBka7rA++KAavNN2uausHTQihs0nESnT4rwxw+vsaxTVIMYVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YdZVyACO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YdZVyACO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724883484;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WHZj3IHMsVxAvpPtQShDmowj4mFCbP/QNBhRJAvPVls=;
	b=YdZVyACO7o4qmLcZjZG9l0trohDHwL7y2aNr2Fxw7WdEe+70o7FUAA8khlnDcLeg31eoVS
	77y8H04l4SuBRvWvRhJ71wqJ3ooyWLt/lU5zofrkLFF0CvmcVA8zH+6bjzvrzbtAz88+Hh
	UGLyf3aM16AMc1Ga1Q6gi620kd/Wcpk=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-458-qMAjCmDbO4K0Bv6KLPUyuQ-1; Wed,
 28 Aug 2024 18:18:01 -0400
X-MC-Unique: qMAjCmDbO4K0Bv6KLPUyuQ-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 77E171955D56;
	Wed, 28 Aug 2024 22:18:00 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ED3081955DD8;
	Wed, 28 Aug 2024 22:17:59 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 47SMHw2G4060596
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 28 Aug 2024 18:17:58 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 47SMHwY74060595;
	Wed, 28 Aug 2024 18:17:58 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 06/15] libmultipath: split get_state into two functions
Date: Wed, 28 Aug 2024 18:17:48 -0400
Message-ID: <20240828221757.4060548-7-bmarzins@redhat.com>
In-Reply-To: <20240828221757.4060548-1-bmarzins@redhat.com>
References: <20240828221757.4060548-1-bmarzins@redhat.com>
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

get_state() is now split into start_checker(), which runs the checker
but doesn't wait for async checkers, and get_state(), which returns the
state from the checker, after waiting for async checkers if necessary.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/discovery.c | 22 ++++++++++++++++------
 libmultipath/discovery.h |  4 +++-
 libmultipath/propsel.c   |  1 +
 multipathd/main.c        |  4 +++-
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
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index a3fce203..ad771d35 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -700,6 +700,7 @@ out:
 	condlog(3, "%s: path_checker = %s %s", pp->dev,
 		checker_name(c), origin);
 	c->timeout = pp->checker_timeout;
+	c->path_state = PATH_UNCHECKED;
 	return 0;
 }
 
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

