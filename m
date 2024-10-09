Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A4542C697
	for <dm-devel@lists.linux.dev>; Wed,  9 Oct 2024 01:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728436535; cv=none; b=Qdh7LQFt0CAv6aXTtNYVPdTIwSAiqxk8gf4HV2jJmPow/uZUk1g89IqeMG3cCnG/t7wU1jDGKCQU7wHzMI3dHqucX+uQZUPLuMmjokZlQIM5B5cAC4TTTyazl8TCTDtdMUMWoK4GLd6vxpKJ6nx3VLhPKHz/VuB8Zgfqq2qmQvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728436535; c=relaxed/simple;
	bh=wQ1nePph6dUXU7bvFvowIYwNCYq8PFKyHFWr8UlTcHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GTPQx3n7RdOedvwWpR3GSqIQL1J1VIS8NcfDn/Ycd4l7QaN1myAphbkGiuuR+gyzkMxsTZAfcqFsv+3g/t4Pnt5eJXpB6mRQFPN4Wazkidn43ba1MwJDowY3b/W68knzdl0k2tn25Fnqadqo3fFlmusAbQwMho1+wfPC0SNaQnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P+c0VpLn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P+c0VpLn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728436532;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i/IF6FkL0st3WJlofb0F9sBmzyu28qPBTHH4HvimkHs=;
	b=P+c0VpLn59LZ19N03OeG7LJiQ7P5k/b3/8PUMkzo7ix9jLWLfMcswKu90mTd/d0JO35Luf
	6RqnCorWpBYWURhuGU7NmHY9kl8L0OHJWBzhup5u4+RjT1HdCToT+htOJ9U4PFfyAw3HoE
	4UBemxZmZl18ECyUH/fRGJXiuuid/q4=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-127-aHL2cbuhMHuoT4NOZJxuag-1; Tue,
 08 Oct 2024 21:15:29 -0400
X-MC-Unique: aHL2cbuhMHuoT4NOZJxuag-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BA7DF195609F;
	Wed,  9 Oct 2024 01:15:28 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 777BD1956088;
	Wed,  9 Oct 2024 01:15:28 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4991FRP12381692
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 8 Oct 2024 21:15:27 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4991FRJY2381691;
	Tue, 8 Oct 2024 21:15:27 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v4 21/22] multipathd: wait for checkers to complete
Date: Tue,  8 Oct 2024 21:15:22 -0400
Message-ID: <20241009011523.2381575-22-bmarzins@redhat.com>
In-Reply-To: <20241009011523.2381575-1-bmarzins@redhat.com>
References: <20241009011523.2381575-1-bmarzins@redhat.com>
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

Multipath again waits for running checkers to complete. In pathinfo(),
mutipath will just wait 1ms if the checker is running. In checkerloop(),
if there are running checkers, multipathd will drop the vecs lock and
wait for 5ms. The difference it wait times is because multipathd cannot
drop the vecs lock in pathinfo.

Reviewed-by: Martin Wilck <mwilck@suse.com>
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
index 846be5a9..e92f3ebd 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2850,6 +2850,7 @@ update_uninitialized_path(struct vectors * vecs, struct path * pp)
 enum checker_state {
 	CHECKER_STARTING,
 	CHECKER_CHECKING_PATHS,
+	CHECKER_WAITING_FOR_PATHS,
 	CHECKER_UPDATING_PATHS,
 	CHECKER_FINISHED,
 };
@@ -2861,6 +2862,7 @@ check_paths(struct vectors *vecs, unsigned int ticks)
 	struct timespec diff_time, start_time, end_time;
 	struct path *pp;
 	int i;
+	bool need_wait = false;
 
 	get_monotonic_time(&start_time);
 
@@ -2871,6 +2873,9 @@ check_paths(struct vectors *vecs, unsigned int ticks)
 			pp->is_checked = check_path(pp, ticks);
 		else
 			pp->is_checked = check_uninitialized_path(pp, ticks);
+		if (pp->is_checked == CHECK_PATH_STARTED &&
+		    checker_need_wait(&pp->checker))
+			need_wait = true;
 		if (++paths_checked % 128 == 0 &&
 		    (lock_has_waiters(&vecs->lock) || waiting_clients())) {
 			get_monotonic_time(&end_time);
@@ -2879,7 +2884,7 @@ check_paths(struct vectors *vecs, unsigned int ticks)
 				return CHECKER_CHECKING_PATHS;
 		}
 	}
-	return CHECKER_UPDATING_PATHS;
+	return need_wait ? CHECKER_WAITING_FOR_PATHS : CHECKER_UPDATING_PATHS;
 }
 
 static enum checker_state
@@ -3001,6 +3006,11 @@ checkerloop (void *ap)
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

