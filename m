From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 01/11] Remove trailing spaces from sysfs
	attributes
Date: Fri, 13 Dec 2013 13:14:04 +0100
Message-ID: <1386936854-8399-2-git-send-email-hare@suse.de>
References: <1386936854-8399-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1386936854-8399-1-git-send-email-hare@suse.de>
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
List-Id: dm-devel.ids

Some sysfs attributes may contain trailing spaces, which only
serve to confuse matters. So strip them before continuing.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/discovery.c | 2 +-
 libmultipath/util.c      | 3 ++-
 libmultipath/util.h      | 2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index d5557d9..d519c02 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -164,7 +164,7 @@ sysfs_get_##fname (struct udev_device * udev, char * buff, size_t len)	\
 		return -EINVAL;						\
 	}								\
 	ret = strlcpy(buff, attr, len);					\
-	return ret;							\
+	return strchop(buff);						\
 }
 
 declare_sysfs_get_str(devtype);
diff --git a/libmultipath/util.c b/libmultipath/util.c
index a9f5939..e6fd11d 100644
--- a/libmultipath/util.c
+++ b/libmultipath/util.c
@@ -10,13 +10,14 @@
 #include "vector.h"
 #include "structs.h"
 
-void
+size_t
 strchop(char *str)
 {
 	int i;
 
 	for (i=strlen(str)-1; i >=0 && isspace(str[i]); --i) ;
 	str[++i] = '\0';
+	return strlen(str);
 }
 
 int
diff --git a/libmultipath/util.h b/libmultipath/util.h
index 44184a1..7b67dff 100644
--- a/libmultipath/util.h
+++ b/libmultipath/util.h
@@ -1,7 +1,7 @@
 #ifndef _UTIL_H
 #define _UTIL_H
 
-void strchop(char *);
+size_t strchop(char *);
 int basenamecpy (const char * src, char * dst, int);
 int filepresent (char * run);
 int get_word (char * sentence, char ** word);
-- 
1.8.1.4
