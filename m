From: lixiaokeng <lixiaokeng@huawei.com>
Subject: [PATCH V4 06/14] kpartx: use xmalloc to instead of
 malloc in main func
Date: Thu, 10 Sep 2020 18:50:36 +0800
Message-ID: <c1d5a372-e54f-4955-222b-d70782a7c127@huawei.com>
References: <f8c2133b-6c02-4cc4-59cd-162828154689@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <f8c2133b-6c02-4cc4-59cd-162828154689@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Language: en-GB
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>, dm-devel
	mailing list <dm-devel@redhat.com>
Cc: linfeilong <linfeilong@huawei.com>, "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>
List-Id: dm-devel.ids

In main func of kpartx.c, we should check return value of
malloc before using it. So we use xmalloc to instead of
malloc.

Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
---
 kpartx/kpartx.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
index 98f6176e..4a0aae93 100644
--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -209,6 +209,23 @@ check_uuid(char *uuid, char *part_uuid, char **err_msg) {
 	return 0;
 }

+static void *
+xmalloc (size_t size) {
+	void *t;
+
+	if (size == 0)
+		return NULL;
+
+	t = malloc (size);
+
+	if (t == NULL) {
+		fprintf(stderr, "Out of memory\n");
+		exit(1);
+	}
+
+	return t;
+}
+
 int
 main(int argc, char **argv){
 	int i, j, m, n, op, off, arg, c, d, ro=0;
@@ -383,7 +400,7 @@ main(int argc, char **argv){
 		mapname = device + off;

 	if (delim == NULL) {
-		delim = malloc(DELIM_SIZE);
+		delim = xmalloc(DELIM_SIZE);
 		memset(delim, 0, DELIM_SIZE);
 		set_delimiter(mapname, delim);
 	}
@@ -670,23 +687,6 @@ end:
 	return r;
 }

-void *
-xmalloc (size_t size) {
-	void *t;
-
-	if (size == 0)
-		return NULL;
-
-	t = malloc (size);
-
-	if (t == NULL) {
-		fprintf(stderr, "Out of memory\n");
-		exit(1);
-	}
-
-	return t;
-}
-
 /*
  * sseek: seek to specified sector
  */
-- 
