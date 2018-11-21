From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 05/19] libmultipath: decrease verbosity of TUR
	checker messages
Date: Wed, 21 Nov 2018 11:18:25 +0100
Message-ID: <20181121101839.30784-6-mwilck@suse.com>
References: <20181121101839.30784-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181121101839.30784-1-mwilck@suse.com>
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

The thread startup/stop messages aren't very interesting.
Decrease their verbosity level to v4.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/checkers/tur.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index 63b19624..6b08dbbb 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -261,7 +261,7 @@ static void *tur_thread(void *ctx)
 	tur_thread_cleanup_push(ct);
 	rcu_register_thread();
 
-	condlog(3, "%d:%d : tur checker starting up", major(ct->devt),
+	condlog(4, "%d:%d : tur checker starting up", major(ct->devt),
 		minor(ct->devt));
 
 	tur_deep_sleep(ct);
@@ -275,7 +275,7 @@ static void *tur_thread(void *ctx)
 	pthread_cond_signal(&ct->active);
 	pthread_mutex_unlock(&ct->lock);
 
-	condlog(3, "%d:%d : tur checker finished, state %s", major(ct->devt),
+	condlog(4, "%d:%d : tur checker finished, state %s", major(ct->devt),
 		minor(ct->devt), checker_state_name(state));
 
 	running = uatomic_xchg(&ct->running, 0);
@@ -415,7 +415,7 @@ int libcheck_check(struct checker * c)
 		}
 		pthread_mutex_unlock(&ct->lock);
 		if (tur_status == PATH_PENDING) {
-			condlog(3, "%d:%d : tur checker still running",
+			condlog(4, "%d:%d : tur checker still running",
 				major(ct->devt), minor(ct->devt));
 		} else {
 			int running = uatomic_xchg(&ct->running, 0);
-- 
2.19.1
