From: mwilck@suse.com
Subject: [PATCH 12/35] libmultipath: strlcpy()/strlcat(): use
	restrict qualifier
Date: Thu,  9 Jul 2020 12:15:57 +0200
Message-ID: <20200709101620.6786-13-mwilck@suse.com>
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

Also remove the redundant local variables. It's not necessary to
make "restrict" work, but it makes the intention more clear.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/util.c | 28 ++++++++++++----------------
 libmultipath/util.h |  4 ++--
 2 files changed, 14 insertions(+), 18 deletions(-)

diff --git a/libmultipath/util.c b/libmultipath/util.c
index 957fb97..f965094 100644
--- a/libmultipath/util.c
+++ b/libmultipath/util.c
@@ -113,46 +113,42 @@ get_word (const char *sentence, char **word)
 	return skip + len;
 }
 
-size_t strlcpy(char *dst, const char *src, size_t size)
+size_t strlcpy(char * restrict dst, const char * restrict src, size_t size)
 {
 	size_t bytes = 0;
-	char *q = dst;
-	const char *p = src;
 	char ch;
 
-	while ((ch = *p++)) {
-		if (bytes+1 < size)
-			*q++ = ch;
+	while ((ch = *src++)) {
+		if (bytes + 1 < size)
+			*dst++ = ch;
 		bytes++;
 	}
 
 	/* If size == 0 there is no space for a final null... */
 	if (size)
-		*q = '\0';
+		*dst = '\0';
 	return bytes;
 }
 
-size_t strlcat(char *dst, const char *src, size_t size)
+size_t strlcat(char * restrict dst, const char * restrict src, size_t size)
 {
 	size_t bytes = 0;
-	char *q = dst;
-	const char *p = src;
 	char ch;
 
-	while (bytes < size && *q) {
-		q++;
+	while (bytes < size && *dst) {
+		dst++;
 		bytes++;
 	}
 	if (bytes == size)
 		return (bytes + strlen(src));
 
-	while ((ch = *p++)) {
-		if (bytes+1 < size)
-		*q++ = ch;
+	while ((ch = *src++)) {
+		if (bytes + 1 < size)
+			*dst++ = ch;
 		bytes++;
 	}
 
-	*q = '\0';
+	*dst = '\0';
 	return bytes;
 }
 
diff --git a/libmultipath/util.h b/libmultipath/util.h
index ae18d8b..7e29b26 100644
--- a/libmultipath/util.h
+++ b/libmultipath/util.h
@@ -15,8 +15,8 @@ int basenamecpy (const char *src, char *dst, size_t size);
 int filepresent (const char *run);
 char *get_next_string(char **temp, const char *split_char);
 int get_word (const char * sentence, char ** word);
-size_t strlcpy(char *dst, const char *src, size_t size);
-size_t strlcat(char *dst, const char *src, size_t size);
+size_t strlcpy(char * restrict dst, const char * restrict src, size_t size);
+size_t strlcat(char * restrict dst, const char * restrict src, size_t size);
 int devt2devname (char *, int, const char *);
 dev_t parse_devt(const char *dev_t);
 char *convert_dev(char *dev, int is_path_device);
-- 
2.26.2
