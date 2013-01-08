From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 30/42] Fix race condition in stop_waiter_thread()
Date: Tue,  8 Jan 2013 14:54:08 +0100
Message-ID: <1357653259-62650-31-git-send-email-hare@suse.de>
References: <1357653259-62650-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1357653259-62650-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

The signal handler might run before we had a chance to
set the 'waiter' context to '0', so better do it previously.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/waiter.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/libmultipath/waiter.c b/libmultipath/waiter.c
index 076539c..da71543 100644
--- a/libmultipath/waiter.c
+++ b/libmultipath/waiter.c
@@ -45,6 +45,8 @@ void free_waiter (void *data)
 
 void stop_waiter_thread (struct multipath *mpp, struct vectors *vecs)
 {
+	pthread_t thread;
+
 	if (mpp->waiter == (pthread_t)0) {
 		condlog(3, "%s: event checker thread already stopped",
 			mpp->alias);
@@ -52,8 +54,9 @@ void stop_waiter_thread (struct multipath *mpp, struct vectors *vecs)
 	}
 	condlog(2, "%s: stop event checker thread (%lu)", mpp->alias,
 		mpp->waiter);
-	pthread_cancel(mpp->waiter);
+	thread = mpp->waiter;
 	mpp->waiter = (pthread_t)0;
+	pthread_cancel(thread);
 }
 
 /*
-- 
1.7.4.2
