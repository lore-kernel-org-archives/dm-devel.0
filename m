From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH] libmultipath/checkers/tur: Fix a recently
	introduced deadlock
Date: Mon, 10 Oct 2016 16:12:28 -0700
Message-ID: <424be81f-7f4b-db0f-a09d-cd4f14a8407a@sandisk.com>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Avoid that the tur_devt() call from libcheck_check() hangs.

Fixes: commit 873be9fef222 ("libmultipath/checkers/tur: Serialize tur_checker_context.devt accesses")
Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 libmultipath/checkers/tur.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index a7a70f6..81206e4 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -64,6 +64,7 @@ static const char *tur_devt(char *devt_buf, int size,
 int libcheck_init (struct checker * c)
 {
 	struct tur_checker_context *ct;
+	pthread_mutexattr_t attr;
 
 	ct = malloc(sizeof(struct tur_checker_context));
 	if (!ct)
@@ -74,7 +75,10 @@ int libcheck_init (struct checker * c)
 	ct->fd = -1;
 	ct->holders = 1;
 	pthread_cond_init_mono(&ct->active);
-	pthread_mutex_init(&ct->lock, NULL);
+	pthread_mutexattr_init(&attr);
+	pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
+	pthread_mutex_init(&ct->lock, &attr);
+	pthread_mutexattr_destroy(&attr);
 	pthread_spin_init(&ct->hldr_lock, PTHREAD_PROCESS_PRIVATE);
 	c->context = ct;
 
-- 
2.10.0
