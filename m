From: Guan Junxiong <guanjunxiong@huawei.com>
Subject: [PATCH RFC 1/3] multipath-tools: move get_next_string to
	util
Date: Fri, 21 Jul 2017 13:07:30 +0800
Message-ID: <1500613652-9084-2-git-send-email-guanjunxiong@huawei.com>
References: <1500613652-9084-1-git-send-email-guanjunxiong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1500613652-9084-1-git-send-email-guanjunxiong@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, christophe.varoqui@opensvc.com, hare@suse.de, mwilck@suse.com, bmarzins@redhat.com, xose.vazquez@gmail.com
Cc: zouming.zouming@huawei.com, chengjike.cheng@huawei.com, guanjunxiong@huawei.com, philip.yang@huawei.com, shenhong09@huawei.com, hege09@huawei.com
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
index b90cd8b0..a4369173 100644
--- a/libmultipath/util.c
+++ b/libmultipath/util.c
@@ -63,6 +63,15 @@ filepresent (char * run) {
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
index b087e32e..f7a33521 100644
--- a/libmultipath/util.h
+++ b/libmultipath/util.h
@@ -6,6 +6,7 @@
 size_t strchop(char *);
 int basenamecpy (const char * src, char * dst, int);
 int filepresent (char * run);
+char *get_next_string(char **temp, char *split_char);
 int get_word (char * sentence, char ** word);
 size_t strlcpy(char *dst, const char *src, size_t size);
 size_t strlcat(char *dst, const char *src, size_t size);
-- 
2.11.1
