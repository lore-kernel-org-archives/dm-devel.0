From: Guan Junxiong <guanjunxiong@huawei.com>
Subject: [PATCH V2 2/4] multipath-tools: move get_next_string to
	util
Date: Thu, 21 Sep 2017 21:23:17 +0800
Message-ID: <1506000199-9644-3-git-send-email-guanjunxiong@huawei.com>
References: <1506000199-9644-1-git-send-email-guanjunxiong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1506000199-9644-1-git-send-email-guanjunxiong@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@opensvc.com, dm-devel@redhat.com, hare@suse.de
Cc: xose.vazquez@gmail.com, guanjunxiong@huawei.com, chengjike.cheng@huawei.com, shenhong09@huawei.com, niuhaoxin@huawei.com, mwilck@suse.com
List-Id: dm-devel.ids

The helper get_next_string is useful and generic. So move from
exclusive weightedpath module to util module. It will be used
in the next second patch.

Signed-off-by: Junxiong Guan <guanjunxiong@huawei.com>
---
 libmultipath/prioritizers/weightedpath.c | 10 +---------
 libmultipath/util.c                      |  9 +++++++++
 libmultipath/util.h                      |  1 +
 3 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/libmultipath/prioritizers/weightedpath.c b/libmultipath/prioritizers/weightedpath.c
index 34a43a81..e0f3efbb 100644
--- a/libmultipath/prioritizers/weightedpath.c
+++ b/libmultipath/prioritizers/weightedpath.c
@@ -34,15 +34,7 @@
 #include <regex.h>
 #include "structs_vec.h"
 #include "print.h"
-
-char *get_next_string(char **temp, char *split_char)
-{
-	char *token = NULL;
-	token = strsep(temp, split_char);
-	while (token != NULL && !strcmp(token, ""))
-		token = strsep(temp, split_char);
-	return token;
-}
+#include "util.h"
 
 #define CHECK_LEN \
 do { \
diff --git a/libmultipath/util.c b/libmultipath/util.c
index 0800da52..0b43d29d 100644
--- a/libmultipath/util.c
+++ b/libmultipath/util.c
@@ -65,6 +65,15 @@ filepresent (char * run) {
 	return 0;
 }
 
+char *get_next_string(char **temp, char *split_char)
+{
+	char *token = NULL;
+	token = strsep(temp, split_char);
+	while (token != NULL && !strcmp(token, ""))
+		token = strsep(temp, split_char);
+	return token;
+}
+
 int
 get_word (char * sentence, char ** word)
 {
diff --git a/libmultipath/util.h b/libmultipath/util.h
index 3dc048e2..51a6d542 100644
--- a/libmultipath/util.h
+++ b/libmultipath/util.h
@@ -7,6 +7,7 @@
 size_t strchop(char *);
 int basenamecpy (const char * src, char * dst, int);
 int filepresent (char * run);
+char *get_next_string(char **temp, char *split_char);
 int get_word (char * sentence, char ** word);
 size_t strlcpy(char *dst, const char *src, size_t size);
 size_t strlcat(char *dst, const char *src, size_t size);
-- 
2.11.1
