From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 03/15] libmultipath/checkers/tur: Declare local
 functions static
Date: Tue, 4 Oct 2016 10:37:50 -0700
Message-ID: <66fed9ae-df6e-0ed1-43a4-21ac9d494d8d@sandisk.com>
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

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 libmultipath/checkers/tur.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index ad66918..94e4190 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -68,7 +68,7 @@ int libcheck_init (struct checker * c)
 	return 0;
 }
 
-void cleanup_context(struct tur_checker_context *ct)
+static void cleanup_context(struct tur_checker_context *ct)
 {
 	pthread_mutex_destroy(&ct->lock);
 	pthread_cond_destroy(&ct->active);
@@ -104,7 +104,7 @@ void libcheck_repair (struct checker * c)
 
 #define TUR_MSG(msg, fmt, args...) snprintf(msg, CHECKER_MSG_LEN, fmt, ##args);
 
-int
+static int
 tur_check(int fd, unsigned int timeout, char *msg)
 {
 	struct sg_io_hdr io_hdr;
@@ -191,7 +191,7 @@ retry:
 #define tur_thread_cleanup_push(ct) pthread_cleanup_push(cleanup_func, ct)
 #define tur_thread_cleanup_pop(ct) pthread_cleanup_pop(1)
 
-void cleanup_func(void *data)
+static void cleanup_func(void *data)
 {
 	int holders;
 	struct tur_checker_context *ct = data;
@@ -204,7 +204,7 @@ void cleanup_func(void *data)
 		cleanup_context(ct);
 }
 
-void *tur_thread(void *ctx)
+static void *tur_thread(void *ctx)
 {
 	struct tur_checker_context *ct = ctx;
 	int state;
@@ -235,7 +235,7 @@ void *tur_thread(void *ctx)
 }
 
 
-void tur_timeout(struct timespec *tsp)
+static void tur_timeout(struct timespec *tsp)
 {
 	struct timeval now;
 
@@ -245,7 +245,7 @@ void tur_timeout(struct timespec *tsp)
 	tsp->tv_nsec += 1000000; /* 1 millisecond */
 }
 
-void tur_set_async_timeout(struct checker *c)
+static void tur_set_async_timeout(struct checker *c)
 {
 	struct tur_checker_context *ct = c->context;
 	struct timeval now;
@@ -254,7 +254,7 @@ void tur_set_async_timeout(struct checker *c)
 	ct->time = now.tv_sec + c->timeout;
 }
 
-int tur_check_async_timeout(struct checker *c)
+static int tur_check_async_timeout(struct checker *c)
 {
 	struct tur_checker_context *ct = c->context;
 	struct timeval now;
-- 
2.10.0
