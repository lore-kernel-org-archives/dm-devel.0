From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 02/12] libmultipath: fix basenamecpy
Date: Wed, 14 Mar 2018 12:46:35 -0500
Message-ID: <1521049605-22050-3-git-send-email-bmarzins@redhat.com>
References: <1521049605-22050-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1521049605-22050-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Martin Wilck <mwilck@suse.com>, christophe.varoqui@free.fr
List-Id: dm-devel.ids

basenamecpy was returning the wrong answer in multiple cases, as
shown by the unit tests for it. Now it will properly find the
basename (as defined by GNU basename, which works well for all of
multipath's uses) and return a copy, if the basename can fit in
provided buffer.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/util.c | 25 ++++++++-----------------
 libmultipath/util.h |  2 +-
 2 files changed, 9 insertions(+), 18 deletions(-)

diff --git a/libmultipath/util.c b/libmultipath/util.c
index d3dd3eb..7251ad0 100644
--- a/libmultipath/util.c
+++ b/libmultipath/util.c
@@ -30,30 +30,21 @@ strchop(char *str)
 }
 
 int
-basenamecpy (const char * str1, char * str2, int str2len)
+basenamecpy (const char *src, char *dst, size_t size)
 {
-	const char *p;
+	const char *p, *e;
 
-	if (!str1 || !strlen(str1))
+	if (!src || !dst || !strlen(src))
 		return 0;
 
-	if (strlen(str1) >= str2len)
-		return 0;
+	p = basename(src);
 
-	if (!str2)
+	for (e = p + strlen(p) - 1; e >= p && isspace(*e); --e) ;
+	if (e < p || e - p > size - 2)
 		return 0;
 
-	p = str1 + (strlen(str1) - 1);
-
-	while (*--p != '/' && p != str1)
-		continue;
-
-	if (p != str1)
-		p++;
-
-	strncpy(str2, p, str2len);
-	str2[str2len - 1] = '\0';
-	return strchop(str2);
+	strlcpy(dst, p, e - p + 2);
+	return strlen(dst);
 }
 
 int
diff --git a/libmultipath/util.h b/libmultipath/util.h
index 51a6d54..a3ab894 100644
--- a/libmultipath/util.h
+++ b/libmultipath/util.h
@@ -5,7 +5,7 @@
 #include <inttypes.h>
 
 size_t strchop(char *);
-int basenamecpy (const char * src, char * dst, int);
+int basenamecpy (const char *src, char *dst, size_t size);
 int filepresent (char * run);
 char *get_next_string(char **temp, char *split_char);
 int get_word (char * sentence, char ** word);
-- 
2.7.4
