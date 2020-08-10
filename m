From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Subject: [dm- devel][PATCH] checker: add input check of state in
 checker_state_name func
Date: Mon, 10 Aug 2020 09:14:39 +0800
Message-ID: <9c67963b-477f-b3f5-8c8c-048de9357ff9@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, Martin Wilck <mwilck@suse.com>, christophe.varoqui@opensvc.com, zkabelac@redhat.com
Cc: linfeilong <linfeilong@huawei.com>, Yanxiaodan <yanxiaodan@huawei.com>, dm-devel@redhat.com, lixiaokeng <lixiaokeng@huawei.com>, liuzhiqiang26@huawei.com
List-Id: dm-devel.ids


In checker_state_name func, we donot check whether input i
is valid. It may cause array access violation problem.

Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
---
 libmultipath/checkers.c | 26 +++++++++++++++-----------
 libmultipath/checkers.h |  3 ++-
 2 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
index c3cf53db..c91e1686 100644
--- a/libmultipath/checkers.c
+++ b/libmultipath/checkers.c
@@ -22,23 +22,27 @@ struct checker_class {
 	short msgtable_size;
 };

-char *checker_state_names[] = {
-	"wild",
-	"unchecked",
-	"down",
-	"up",
-	"shaky",
-	"ghost",
-	"pending",
-	"timeout",
-	"removed",
-	"delayed",
+static const char *checker_state_names[PATH_MAX_STATE] = {
+	[PATH_WILD] = "wild",
+	[PATH_UNCHECKED] = "unchecked",
+	[PATH_DOWN] = "down",
+	[PATH_UP] = "up",
+	[PATH_SHAKY] = "shaky",
+	[PATH_GHOST] = "ghost",
+	[PATH_PENDING] = "pending",
+	[PATH_TIMEOUT] = "timeout",
+	[PATH_REMOVED] = "removed",
+	[PATH_DELAYED] = "delayed",
 };

 static LIST_HEAD(checkers);

 const char *checker_state_name(int i)
 {
+	if (i < 0 || i >= PATH_MAX_STATE) {
+		condlog (2, "invalid state index = %d", i);
+		return INVALID;
+	}
 	return checker_state_names[i];
 }

diff --git a/libmultipath/checkers.h b/libmultipath/checkers.h
index 5237e7ec..93052b72 100644
--- a/libmultipath/checkers.h
+++ b/libmultipath/checkers.h
@@ -67,7 +67,7 @@
  *   During this time, it is marked as "delayed"
  */
 enum path_check_state {
-	PATH_WILD,
+	PATH_WILD = 0,
 	PATH_UNCHECKED,
 	PATH_DOWN,
 	PATH_UP,
@@ -88,6 +88,7 @@ enum path_check_state {
 #define READSECTOR0  "readsector0"
 #define CCISS_TUR    "cciss_tur"
 #define NONE         "none"
+#define INVALID      "invalid"

 #define ASYNC_TIMEOUT_SEC	30

-- 
2.24.0.windows.2
