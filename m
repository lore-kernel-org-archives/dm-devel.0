Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05E16C19F2B
	for <dm-devel@archiver.kernel.org>; Sat, 30 Jul 2022 05:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659158014;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=5Z7z3sZoe+pSotCpRUBZE0ZUzRM3489+QQZSFWKTo8Q=;
	b=cTVfipVyQV0IJawpIfTe72TDzVgNp4jFYeGk+2vqZZ/s0+CdCVLuFJIERZdPAKYIbql3KN
	xkXhLVx6BtQpwsIONTsW9Lq+sKtGuTXwLHB0aqNbwyQ16n01/qkxikbRJ/1nBrNlNzgm2/
	lrJZ+AxPE1HZYEKFAE7kHfTU8kPI4Cg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-144-aJjZuQiJOZuXsw7zyi_-Mw-1; Sat, 30 Jul 2022 01:13:31 -0400
X-MC-Unique: aJjZuQiJOZuXsw7zyi_-Mw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 313BA811E75;
	Sat, 30 Jul 2022 05:13:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2213218EB7;
	Sat, 30 Jul 2022 05:13:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B5D4E19256E4;
	Sat, 30 Jul 2022 05:13:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3405C194FFF9
 for <dm-devel@listman.corp.redhat.com>; Sat, 30 Jul 2022 05:13:08 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0F7A1403163; Sat, 30 Jul 2022 05:13:08 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EBE17492C3B;
 Sat, 30 Jul 2022 05:13:07 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 26U5D6IX024131;
 Sat, 30 Jul 2022 00:13:06 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 26U5D51i024130;
 Sat, 30 Jul 2022 00:13:05 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Sat, 30 Jul 2022 00:12:57 -0500
Message-Id: <1659157980-24079-4-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1659157980-24079-1-git-send-email-bmarzins@redhat.com>
References: <1659157980-24079-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: [dm-devel] [PATCH 3/6] multipathd: Occasionally allow waiters to
 interrupt checking paths
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: Wu Guanghao <wuguanghao3@huawei.com>,
 device-mapper development <dm-devel@redhat.com>,
 Martin Wilck <Martin.Wilck@suse.com>
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

If there are a very large number of paths that all get checked at the
same time, it is possible for the path checkers to starve out other
vecs->lock users, like uevent processing. To avoid this, if the path
checkers are taking a long time, checkerloop now occasionally unlocks
and allows other vecs->lock waiters to run.

In order to make sure that path checking is always making real progress,
checkerloop() only checks if it should unlock every 128 path checks. To
check, it sees if there are waiters and more than a second has passed
since it acquired the vecs->lock. If both of these are true, it drops
the lock and calls nanosleep() to schedule.

When checkerloop() reacquires the lock, it may no longer be at the
correct place in the vector. While paths can be deleted from any point
of the pathvec, they can only be added at the end. This means that the
next path to check must be between its previous location and the start
of the vector. To help determine the correct starting place,
checkerloop() assigns a check_id, starting from 1, to paths as it checks
them. The paths save this id. Newly added paths start with a special id
of 0. As paths are deleted, later paths, with higher ids, are shifted
towards the start of the vector. checkerloop() just needs to check
backwards from the array index where it was at when in dropped the lock
until it finds the first path with a check_id greater than zero and
smaller than the last one it gave out. This will be the last path it
checked. For this to work, the check_ids must always increase as you go
through the pathvec array.  To guarantee this, checkloop() cannot drop
the lock unless it can guarantee that no matter what happens before it
regains the lock, it will have enough ids to not roll over before it
hits the end of the pathvec (check_id must be less than INT_MAX).

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/structs.h |  1 +
 multipathd/main.c      | 79 +++++++++++++++++++++++++++++++++---------
 2 files changed, 63 insertions(+), 17 deletions(-)

diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index a6a09441..47358091 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -351,6 +351,7 @@ struct path {
 	int fast_io_fail;
 	unsigned int dev_loss;
 	int eh_deadline;
+	unsigned int check_id;
 	/* configlet pointers */
 	vector hwe;
 	struct gen_path generic_path;
diff --git a/multipathd/main.c b/multipathd/main.c
index 71079113..73c95806 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2555,7 +2555,6 @@ checkerloop (void *ap)
 	struct vectors *vecs;
 	struct path *pp;
 	int count = 0;
-	unsigned int i;
 	struct timespec last_time;
 	struct config *conf;
 	int foreign_tick = 0;
@@ -2581,8 +2580,9 @@ checkerloop (void *ap)
 
 	while (1) {
 		struct timespec diff_time, start_time, end_time;
-		int num_paths = 0, strict_timing, rc = 0;
-		unsigned int ticks = 0;
+		int num_paths = 0, strict_timing, rc = 0, i = 0;
+		unsigned int ticks = 0, check_id = 0;
+		bool more_paths = true;
 
 		if (set_config_state(DAEMON_RUNNING) != DAEMON_RUNNING)
 			/* daemon shutdown */
@@ -2604,21 +2604,66 @@ checkerloop (void *ap)
 			sd_notify(0, "WATCHDOG=1");
 #endif
 
-		pthread_cleanup_push(cleanup_lock, &vecs->lock);
-		lock(&vecs->lock);
-		pthread_testcancel();
-		vector_foreach_slot (vecs->pathvec, pp, i) {
-			rc = check_path(vecs, pp, ticks);
-			if (rc < 0) {
-				condlog(1, "%s: check_path() failed, removing",
-					pp->dev);
-				vector_del_slot(vecs->pathvec, i);
-				free_path(pp);
-				i--;
-			} else
-				num_paths += rc;
+		while (more_paths) {
+			unsigned int paths_checked = 0;
+			struct timespec chk_start_time;
+
+			pthread_cleanup_push(cleanup_lock, &vecs->lock);
+			lock(&vecs->lock);
+			pthread_testcancel();
+			get_monotonic_time(&chk_start_time);
+			/*
+			 * Paths could have been removed since we dropped
+			 * the lock. Find the path to continue checking at.
+			 * Paths added since we last checked will always have
+			 * pp->check_id == 0 Otherwise, pp->check_id will
+			 * always be increasing, and always greater than a
+			 * path's array index. Thus, checking backwards, the
+			 * first non-new path with pp->check_id <= check_id
+			 * must be the last path we checked. Start on the path
+			 * after that.
+			 */
+			if (check_id > 0) {
+				while ((pp = VECTOR_SLOT(vecs->pathvec, i))) {
+					if (pp->check_id > 0 &&
+					    pp->check_id <= check_id) {
+						check_id = pp->check_id;
+						break;
+					}
+					i--;
+				}
+				i++;
+			}
+			vector_foreach_slot_after (vecs->pathvec, pp, i) {
+				pp->check_id = ++check_id;
+				rc = check_path(vecs, pp, ticks);
+				if (rc < 0) {
+					condlog(1, "%s: check_path() failed, removing",
+						pp->dev);
+					vector_del_slot(vecs->pathvec, i);
+					free_path(pp);
+					i--;
+				} else
+					num_paths += rc;
+				if (++paths_checked % 128 == 0 &&
+				    check_id < INT_MAX &&
+				    lock_has_waiters(&vecs->lock)) {
+					get_monotonic_time(&end_time);
+					timespecsub(&end_time, &chk_start_time,
+						    &diff_time);
+					if (diff_time.tv_sec > 0)
+						goto unlock;
+				}
+			}
+			more_paths = false;
+unlock:
+			lock_cleanup_pop(vecs->lock);
+			if (more_paths) {
+				/* Yield to waiters */
+				struct timespec wait = { .tv_nsec = 10000, };
+				nanosleep(&wait, NULL);
+			}
 		}
-		lock_cleanup_pop(vecs->lock);
 
 		pthread_cleanup_push(cleanup_lock, &vecs->lock);
 		lock(&vecs->lock);
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

