From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 3/3] multipathd: stop waiter in __setup_multipath
Date: Fri, 16 Mar 2018 16:31:07 -0500
Message-ID: <1521235867-29476-4-git-send-email-bmarzins@redhat.com>
References: <1521235867-29476-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1521235867-29476-1-git-send-email-bmarzins@redhat.com>
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

__setup_multipath can remove a multipath device from multipathd, and it
can be called by either by the waiter thread or another thread.
Previously, it dealt with this by never stopping the waiter thread.  It
simply relied on the waiter thread to notice and stop itself.  Now, when
called by another thread, it explicitly stops the waiter thread.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c   | 2 +-
 multipathd/waiter.c | 5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 70aff5d..3ae0442 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -398,7 +398,7 @@ int __setup_multipath(struct vectors *vecs, struct multipath *mpp,
 
 	return 0;
 out:
-	remove_map(mpp, vecs, PURGE_VEC);
+	remove_map_and_stop_waiter(mpp, vecs, PURGE_VEC);
 	return 1;
 }
 
diff --git a/multipathd/waiter.c b/multipathd/waiter.c
index c70ad21..595c69a 100644
--- a/multipathd/waiter.c
+++ b/multipathd/waiter.c
@@ -57,6 +57,11 @@ void stop_waiter_thread (struct multipath *mpp, struct vectors *vecs)
 			mpp->alias);
 		return;
 	}
+	/* Don't cancel yourself. __setup_multipath is called by
+	   by the waiter thread, and may remove a multipath device */
+	if (pthread_equal(mpp->waiter, pthread_self()))
+		return;
+
 	condlog(2, "%s: stop event checker thread (%lu)", mpp->alias,
 		mpp->waiter);
 	thread = mpp->waiter;
-- 
2.7.4
