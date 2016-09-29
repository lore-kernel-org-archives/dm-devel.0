From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 1/2] libmultipath/checkers/{rbd,
 tur}: Fix pthread_cond_signal() calls
Date: Thu, 29 Sep 2016 14:28:27 -0700
Message-ID: <55a58c33-1edb-548d-f68b-d25cea442650@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Mike Christie <mchristi@redhat.com>
List-Id: dm-devel.ids

Calling pthread_cond_signal() without holding the associated
mutex sporadically results in a lost wakeup. Hence call
pthread_cond_signal() while holding the mutex used by
pthread_cond_wait().

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Mike Christie <mchristi@redhat.com>
---
 libmultipath/checkers/rbd.c | 2 +-
 libmultipath/checkers/tur.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/checkers/rbd.c b/libmultipath/checkers/rbd.c
index 874bcfa..41259c3 100644
--- a/libmultipath/checkers/rbd.c
+++ b/libmultipath/checkers/rbd.c
@@ -527,8 +527,8 @@ static void *rbd_thread(void *ctx)
 	/* checker done */
 	pthread_mutex_lock(&ct->lock);
 	ct->state = state;
-	pthread_mutex_unlock(&ct->lock);
 	pthread_cond_signal(&ct->active);
+	pthread_mutex_unlock(&ct->lock);
 
 	condlog(3, "rbd%d thead finished, state %s", ct->rbd_bus_id,
 		checker_state_name(state));
diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index 8c1f633..94e4190 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -225,8 +225,8 @@ static void *tur_thread(void *ctx)
 	/* TUR checker done */
 	pthread_mutex_lock(&ct->lock);
 	ct->state = state;
-	pthread_mutex_unlock(&ct->lock);
 	pthread_cond_signal(&ct->active);
+	pthread_mutex_unlock(&ct->lock);
 
 	condlog(3, "%d:%d: tur checker finished, state %s",
 		TUR_DEVT(ct), checker_state_name(state));
-- 
2.10.0
