From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 04/15] libmultipath/checkers/rbd: Declare local
 functions static
Date: Tue, 4 Oct 2016 10:38:15 -0700
Message-ID: <61fe6d2b-489d-ba8a-1dd2-8820c4ad102d@sandisk.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Mike Christie <mchristi@redhat.com>
List-Id: dm-devel.ids

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Mike Christie <mchristi@redhat.com>
---
 libmultipath/checkers/rbd.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/libmultipath/checkers/rbd.c b/libmultipath/checkers/rbd.c
index 1ee29c4..41259c3 100644
--- a/libmultipath/checkers/rbd.c
+++ b/libmultipath/checkers/rbd.c
@@ -220,7 +220,7 @@ free_ct:
 	return 1;
 }
 
-void cleanup_context(struct rbd_checker_context *ct)
+static void cleanup_context(struct rbd_checker_context *ct)
 {
 	pthread_mutex_destroy(&ct->lock);
 	pthread_cond_destroy(&ct->active);
@@ -317,7 +317,7 @@ free_bufs:
 	return ret;
 }
 
-int rbd_check(struct rbd_checker_context *ct, char *msg)
+static int rbd_check(struct rbd_checker_context *ct, char *msg)
 {
 	if (ct->blacklisted || rbd_is_blacklisted(ct, msg) == 1)
 		return PATH_DOWN;
@@ -333,7 +333,7 @@ int rbd_check(struct rbd_checker_context *ct, char *msg)
 	return PATH_UP;
 }
 
-int safe_write(int fd, const void *buf, size_t count)
+static int safe_write(int fd, const void *buf, size_t count)
 {
 	while (count > 0) {
 		ssize_t r = write(fd, buf, count);
@@ -493,7 +493,7 @@ static int rbd_repair(struct rbd_checker_context *ct, char *msg)
 #define rbd_thread_cleanup_push(ct) pthread_cleanup_push(cleanup_func, ct)
 #define rbd_thread_cleanup_pop(ct) pthread_cleanup_pop(1)
 
-void cleanup_func(void *data)
+static void cleanup_func(void *data)
 {
 	int holders;
 	struct rbd_checker_context *ct = data;
@@ -506,7 +506,7 @@ void cleanup_func(void *data)
 		cleanup_context(ct);
 }
 
-void *rbd_thread(void *ctx)
+static void *rbd_thread(void *ctx)
 {
 	struct rbd_checker_context *ct = ctx;
 	int state;
-- 
2.10.0
