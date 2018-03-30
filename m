From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 1/6] multipathd: remove incorrect
	pthread_testcancel
Date: Thu, 29 Mar 2018 22:36:58 -0500
Message-ID: <1522381023-15262-2-git-send-email-bmarzins@redhat.com>
References: <1522381023-15262-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1522381023-15262-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

As Martin Wilck pointed out, a thread that's trying to stop the waiter
thread should not cancel itself before it gets a chance to do so

Cc: Martin Wilck <mwilck@suse.com>
Fixes: c7625f92 "multipathd: fix waiter thread cancelling"
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/waiter.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/multipathd/waiter.c b/multipathd/waiter.c
index 595c69a..0ef8b25 100644
--- a/multipathd/waiter.c
+++ b/multipathd/waiter.c
@@ -68,7 +68,6 @@ void stop_waiter_thread (struct multipath *mpp, struct vectors *vecs)
 	mpp->waiter = (pthread_t)0;
 	pthread_cleanup_push(cleanup_lock, &waiter_lock);
 	lock(&waiter_lock);
-	pthread_testcancel();
 	pthread_kill(thread, SIGUSR2);
 	pthread_cancel(thread);
 	lock_cleanup_pop(&waiter_lock);
-- 
2.7.4
