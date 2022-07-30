Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFF60C19F2B
	for <dm-devel@archiver.kernel.org>; Sat, 30 Jul 2022 05:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659158018;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=A/WKfi+hWze1nGZ7jsm5h3jxt03ZC8ZEmE8RCMfQWO0=;
	b=JOwGLQ8OLBiPtxVZIYctyueIhyQz2u0MfSfEW1ktjDjpkuX0lyf0VNpXLgkOYZYHl/EBzq
	6hCsKVdzO38Sj7z/4wHgHcFOIBtVESZ8gTy6Nbb3cospyQjQkUrDEkPY3tTA1j2Ew2R+aB
	pqToVlYKtyAj+9cPvFwPwxa7Y0rh4o0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-320-jVeBeiLrOj-PvWU3fsZcnA-1; Sat, 30 Jul 2022 01:13:35 -0400
X-MC-Unique: jVeBeiLrOj-PvWU3fsZcnA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0B5103804524;
	Sat, 30 Jul 2022 05:13:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EF5EC1121319;
	Sat, 30 Jul 2022 05:13:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id ED40A19256F4;
	Sat, 30 Jul 2022 05:13:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B6B6E19256EF
 for <dm-devel@listman.corp.redhat.com>; Sat, 30 Jul 2022 05:13:09 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 693AE40C1288; Sat, 30 Jul 2022 05:13:09 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5A898403D0E0;
 Sat, 30 Jul 2022 05:13:09 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 26U5D7ss024137;
 Sat, 30 Jul 2022 00:13:08 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 26U5D7Lk024136;
 Sat, 30 Jul 2022 00:13:07 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Sat, 30 Jul 2022 00:12:58 -0500
Message-Id: <1659157980-24079-5-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1659157980-24079-1-git-send-email-bmarzins@redhat.com>
References: <1659157980-24079-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: [dm-devel] [PATCH 4/6] multipathd: allow uxlsnr clients to
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The uxlsnr clients never block waiting on the vecs->lock. Instead they
register to get woken up and call trylock() when the lock is dropped.
Add code to track when they are registered to get woken up. The
checkerloop now checks if there are waiting uxlsnr clients as well.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c   |  3 ++-
 multipathd/uxlsnr.c | 20 +++++++++++++++-----
 multipathd/uxlsnr.h |  1 +
 3 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 73c95806..78374377 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2647,7 +2647,8 @@ checkerloop (void *ap)
 					num_paths += rc;
 				if (++paths_checked % 128 == 0 &&
 				    check_id < INT_MAX &&
-				    lock_has_waiters(&vecs->lock)) {
+				    (lock_has_waiters(&vecs->lock) ||
+				     waiting_clients())) {
 					get_monotonic_time(&end_time);
 					timespecsub(&end_time, &chk_start_time,
 						    &diff_time);
diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index 645e356c..04bcd020 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -91,6 +91,7 @@ static LIST_HEAD(clients);
 static struct pollfd *polls;
 static int notify_fd = -1;
 static int idle_fd = -1;
+static bool clients_need_lock = false;
 
 static bool _socket_client_is_root(int fd)
 {
@@ -309,15 +310,22 @@ static struct timespec *get_soonest_timeout(struct timespec *ts)
 	return ts;
 }
 
-static bool need_vecs_lock(void)
+bool waiting_clients(void)
+{
+	return clients_need_lock;
+}
+
+static void check_for_locked_work(struct client *skip)
 {
 	struct client *c;
 
 	list_for_each_entry(c, &clients, node) {
-		if (c->state == CLT_LOCKED_WORK)
-			return true;
+		if (c != skip && c->state == CLT_LOCKED_WORK) {
+			clients_need_lock = true;
+			return;
+		}
 	}
-	return false;
+	clients_need_lock = false;
 }
 
 static int parse_cmd(struct client *c)
@@ -494,6 +502,7 @@ static int client_state_machine(struct client *c, struct vectors *vecs,
 			/* don't use cleanup_lock(), lest we wakeup ourselves */
 			pthread_cleanup_push_cast(__unlock, &vecs->lock);
 			c->error = execute_handler(c, vecs);
+			check_for_locked_work(c);
 			pthread_cleanup_pop(1);
 			condlog(4, "%s: cli[%d] grabbed lock", __func__, c->fd);
 			free_keys(c->cmdvec);
@@ -661,7 +670,8 @@ void *uxsock_listen(long ux_sock, void *trigger_data)
 			polls[POLLFD_NOTIFY].events = POLLIN;
 
 		polls[POLLFD_IDLE].fd = idle_fd;
-		if (need_vecs_lock())
+		check_for_locked_work(NULL);
+		if (clients_need_lock)
 			polls[POLLFD_IDLE].events = POLLIN;
 		else
 			polls[POLLFD_IDLE].events = 0;
diff --git a/multipathd/uxlsnr.h b/multipathd/uxlsnr.h
index 60c3a2c7..3e45930b 100644
--- a/multipathd/uxlsnr.h
+++ b/multipathd/uxlsnr.h
@@ -3,6 +3,7 @@
 
 #include <stdbool.h>
 
+bool waiting_clients(void);
 void uxsock_cleanup(void *arg);
 void *uxsock_listen(long ux_sock,
 		    void * trigger_data);
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

