From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/5] libmultipath: remove 'remove_trailing_chars'
Date: Tue, 17 Dec 2013 08:04:06 +0100
Message-ID: <1387263848-73945-4-git-send-email-hare@suse.de>
References: <1387263848-73945-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1387263848-73945-1-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Unused; superseded by strchop().

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/util.c | 9 ---------
 libmultipath/util.h | 1 -
 2 files changed, 10 deletions(-)

diff --git a/libmultipath/util.c b/libmultipath/util.c
index 2b41e7a..93ab08b 100644
--- a/libmultipath/util.c
+++ b/libmultipath/util.c
@@ -142,15 +142,6 @@ size_t strlcat(char *dst, const char *src, size_t size)
 	return bytes;
 }
 
-void remove_trailing_chars(char *path, char c)
-{
-	size_t len;
-
-	len = strlen(path);
-	while (len > 0 && path[len-1] == c)
-		path[--len] = '\0';
-}
-
 extern int
 devt2devname (char *devname, int devname_len, char *devt)
 {
diff --git a/libmultipath/util.h b/libmultipath/util.h
index 4eafe6e..257912c 100644
--- a/libmultipath/util.h
+++ b/libmultipath/util.h
@@ -7,7 +7,6 @@ int filepresent (char * run);
 int get_word (char * sentence, char ** word);
 size_t strlcpy(char *dst, const char *src, size_t size);
 size_t strlcat(char *dst, const char *src, size_t size);
-void remove_trailing_chars(char *path, char c);
 int devt2devname (char *, int, char *);
 dev_t parse_devt(const char *dev_t);
 char *convert_dev(char *dev, int is_path_device);
-- 
1.7.12.4
