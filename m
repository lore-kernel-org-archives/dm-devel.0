From: mwilck@suse.com
Subject: [PATCH 02/35] multipath-tools tests/directio: fix
	missing initializers
Date: Thu,  9 Jul 2020 12:15:47 +0200
Message-ID: <20200709101620.6786-3-mwilck@suse.com>
References: <20200709101620.6786-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200709101620.6786-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

clang-3.9 doesn't like the {0} initializers for complex data structures.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/directio.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/tests/directio.c b/tests/directio.c
index 66aaf0e..9895409 100644
--- a/tests/directio.c
+++ b/tests/directio.c
@@ -31,7 +31,7 @@ int test_fd = 111;
 int ioctx_count = 0;
 struct io_event mock_events[AIO_GROUP_SIZE]; /* same as the checker max */
 int ev_off = 0;
-struct timespec zero_timeout = {0};
+struct timespec zero_timeout = { .tv_sec = 0 };
 struct timespec full_timeout = { .tv_sec = -1 };
 
 int __real_ioctl(int fd, unsigned long request, void *argp);
@@ -287,7 +287,7 @@ static void test_reset(void **state)
 /* tests initializing, then resetting, and then initializing again */
 static void test_init_reset_init(void **state)
 {
-	struct checker c = {0};
+	struct checker c = {.cls = NULL};
 	struct aio_group *aio_grp, *tmp_grp;
 
 	assert_true(list_empty(&aio_grp_list));
@@ -315,7 +315,7 @@ static void test_init_reset_init(void **state)
 static void test_init_free(void **state)
 {
 	int i, count = 0;
-	struct checker c[4096] = {0};
+	struct checker c[4096] = {{.cls = NULL}};
 	struct aio_group *aio_grp = NULL;
 
 	assert_true(list_empty(&aio_grp_list));
@@ -361,7 +361,7 @@ static void test_init_free(void **state)
 static void test_multi_init_free(void **state)
 {
 	int i, count;
-	struct checker c[4096] = {0};
+	struct checker c[4096] = {{.cls = NULL}};
 	struct aio_group *aio_grp;
 
 	assert_true(list_empty(&aio_grp_list));
@@ -401,7 +401,7 @@ static void test_multi_init_free(void **state)
 /* simple single checker sync test */
 static void test_check_state_simple(void **state)
 {
-	struct checker c = {0};
+	struct checker c = {.cls = NULL};
 	struct async_req *req;
 	int res = 0;
 
@@ -417,7 +417,7 @@ static void test_check_state_simple(void **state)
 /* test sync timeout */
 static void test_check_state_timeout(void **state)
 {
-	struct checker c = {0};
+	struct checker c = {.cls = NULL};
 	struct aio_group *aio_grp;
 
 	assert_true(list_empty(&aio_grp_list));
@@ -440,7 +440,7 @@ static void test_check_state_timeout(void **state)
 /* test async timeout */
 static void test_check_state_async_timeout(void **state)
 {
-	struct checker c = {0};
+	struct checker c = {.cls = NULL};
 	struct aio_group *aio_grp;
 
 	assert_true(list_empty(&aio_grp_list));
@@ -467,7 +467,7 @@ static void test_check_state_async_timeout(void **state)
 /* test freeing checkers with outstanding requests */
 static void test_free_with_pending(void **state)
 {
-        struct checker c[2] = {0};
+        struct checker c[2] = {{.cls = NULL}};
         struct aio_group *aio_grp;
 	struct async_req *req;
 	int res = 0;
@@ -500,7 +500,7 @@ static void test_free_with_pending(void **state)
 /* test removing orpahed aio_group on free */
 static void test_orphaned_aio_group(void **state)
 {
-	struct checker c[AIO_GROUP_SIZE] = {0};
+	struct checker c[AIO_GROUP_SIZE] = {{.cls = NULL}};
 	struct aio_group *aio_grp, *tmp_grp;
 	int i;
 
@@ -533,7 +533,7 @@ static void test_orphaned_aio_group(void **state)
  * checker */
 static void test_timeout_cancel_failed(void **state)
 {
-	struct checker c[2] = {0};
+	struct checker c[2] = {{.cls = NULL}};
 	struct aio_group *aio_grp;
 	struct async_req *reqs[2];
 	int res[] = {0,0};
@@ -568,7 +568,7 @@ static void test_timeout_cancel_failed(void **state)
  * checker */
 static void test_async_timeout_cancel_failed(void **state)
 {
-	struct checker c[2] = {0};
+	struct checker c[2] = {{.cls = NULL}};
 	struct async_req *reqs[2];
 	int res[] = {0,0};
 	int i;
@@ -610,7 +610,7 @@ static void test_async_timeout_cancel_failed(void **state)
 /* test orphaning a request, and having another checker clean it up */
 static void test_orphan_checker_cleanup(void **state)
 {
-	struct checker c[2] = {0};
+	struct checker c[2] = {{.cls = NULL}};
 	struct async_req *reqs[2];
 	int res[] = {0,0};
 	struct aio_group *aio_grp;
@@ -667,7 +667,7 @@ static void test_orphan_reset_cleanup(void **state)
 static void test_check_state_blksize(void **state)
 {
 	int i;
-	struct checker c[3] = {0};
+	struct checker c[3] = {{.cls = NULL}};
 	int blksize[] = {4096, 1024, 512};
 	struct async_req *reqs[3];
 	int res[] = {0,1,0};
@@ -698,7 +698,7 @@ static void test_check_state_blksize(void **state)
 static void test_check_state_async(void **state)
 {
 	int i;
-	struct checker c[257] = {0};
+	struct checker c[257] = {{.cls = NULL}};
 	struct async_req *reqs[257];
 	int res[257] = {0};
 
-- 
2.26.2
