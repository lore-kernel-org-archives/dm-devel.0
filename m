From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 3/4] multipathd: decrease log level of waiter
	thread start/stop msgs
Date: Wed,  4 Apr 2018 18:21:59 +0200
Message-ID: <20180404162200.6518-4-mwilck@suse.com>
References: <20180404162200.6518-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180404162200.6518-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

These rather unimportant messages account for a large portion
of multipathd's log messages with the default verbosity level (2).

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/waiter.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/multipathd/waiter.c b/multipathd/waiter.c
index 595c69a..6c896f7 100644
--- a/multipathd/waiter.c
+++ b/multipathd/waiter.c
@@ -62,7 +62,7 @@ void stop_waiter_thread (struct multipath *mpp, struct vectors *vecs)
 	if (pthread_equal(mpp->waiter, pthread_self()))
 		return;
 
-	condlog(2, "%s: stop event checker thread (%lu)", mpp->alias,
+	condlog(3, "%s: stop event checker thread (%lu)", mpp->alias,
 		mpp->waiter);
 	thread = mpp->waiter;
 	mpp->waiter = (pthread_t)0;
@@ -219,7 +219,7 @@ int start_waiter_thread (struct multipath *mpp, struct vectors *vecs)
 		goto out1;
 	}
 	mpp->waiter = wp->thread;
-	condlog(2, "%s: event checker started", wp->mapname);
+	condlog(3, "%s: event checker started", wp->mapname);
 
 	return 0;
 out1:
-- 
2.16.1
