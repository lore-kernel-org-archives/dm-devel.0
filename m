From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 10/15] libmultipath/checkers/tur: Move
 pthread_attr_destroy() call
Date: Tue, 4 Oct 2016 10:40:32 -0700
Message-ID: <69406132-f1a4-179f-1f3e-abbc4a66ec08@sandisk.com>
References: <157defac-6527-ab23-92f2-9c1926042885@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <157defac-6527-ab23-92f2-9c1926042885@sandisk.com>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Move the pthread_attr_destroy() call up such that this function
is also called if thread creation fails.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 libmultipath/checkers/tur.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index 3f97f2a..11f3c60 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -333,6 +333,7 @@ libcheck_check (struct checker * c)
 		tur_set_async_timeout(c);
 		setup_thread_attr(&attr, 32 * 1024, 1);
 		r = pthread_create(&ct->thread, &attr, tur_thread, ct);
+		pthread_attr_destroy(&attr);
 		if (r) {
 			pthread_spin_lock(&ct->hldr_lock);
 			ct->holders--;
@@ -343,7 +344,6 @@ libcheck_check (struct checker * c)
 				" sync mode", TUR_DEVT(ct));
 			return tur_check(c->fd, c->timeout, c->message);
 		}
-		pthread_attr_destroy(&attr);
 		tur_timeout(&tsp);
 		r = pthread_cond_timedwait(&ct->active, &ct->lock, &tsp);
 		tur_status = ct->state;
-- 
2.10.0
