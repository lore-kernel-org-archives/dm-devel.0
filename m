Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C362171E65
	for <dm-devel@lists.linux.dev>; Tue, 15 Oct 2024 03:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728962927; cv=none; b=QXN3Dwku//W2aMmQ2F1KdzwMdssHVSretrpS+XoaGZ0p5nya85/xNZ4gu/9TzlmdHzQA0zhli3A3M77Q1fxiMW6EpDrqW3DnCwOVgzMlH3w1stO9bBwu3bpzTjZH5+C8EtpzQdpLyMQayLLZ6O23a0pCYlq8WleRFYMb6AnUKBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728962927; c=relaxed/simple;
	bh=wQ1nePph6dUXU7bvFvowIYwNCYq8PFKyHFWr8UlTcHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GTFi61+OgS7un6kAxTQkGbexOGAHKvqI6OPa61DpWyXEdAa5d79qlgaLTE/DAnVmaB7NhHUngNZglQ+rcI47t1Uupn/DxV4WyqF43u5vpKkrhNzAHSLAt/sx7efyVO8j5QW5sbgqDJzh4u4m4R4Ev2spNsUaDTSeXWiHdxGxsv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g3I+eXCq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g3I+eXCq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728962923;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i/IF6FkL0st3WJlofb0F9sBmzyu28qPBTHH4HvimkHs=;
	b=g3I+eXCqxv80jWNurxX3Gr3oEYZOtmmQS0qQJPc/M9OTjXIo0ft+QWHnNHaAhXtp0F1Dfd
	KcGOssQp/gnKdctgeDcxCTI7jliMf94qoBJaolPjTArIwqNTmsYumbiN+mkZ0D5+oTdjak
	P5HCIuxjP8Y2fS4YvrfQBLaeKj15xS4=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-640-593OGlR_MZSdXvv0qEQmlw-1; Mon,
 14 Oct 2024 23:28:41 -0400
X-MC-Unique: 593OGlR_MZSdXvv0qEQmlw-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 45D0119560A5;
	Tue, 15 Oct 2024 03:28:40 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 102581955F43;
	Tue, 15 Oct 2024 03:28:39 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 49F3Scdw2693363
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 14 Oct 2024 23:28:38 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 49F3ScBj2693362;
	Mon, 14 Oct 2024 23:28:38 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v5 21/23] multipathd: wait for checkers to complete
Date: Mon, 14 Oct 2024 23:28:33 -0400
Message-ID: <20241015032835.2693247-22-bmarzins@redhat.com>
In-Reply-To: <20241015032835.2693247-1-bmarzins@redhat.com>
References: <20241015032835.2693247-1-bmarzins@redhat.com>
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

