From: mwilck@suse.com
Subject: [PATCH 10/35] libmultipath: util: constify function
	arguments
Date: Thu,  9 Jul 2020 12:15:55 +0200
Message-ID: <20200709101620.6786-11-mwilck@suse.com>
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

Use "const" for function arguments where possible.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/dmparser.c |  2 +-
 libmultipath/util.c     | 12 ++++++------
 libmultipath/util.h     | 10 +++++-----
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
index b856a07..27581cd 100644
--- a/libmultipath/dmparser.c
+++ b/libmultipath/dmparser.c
@@ -18,7 +18,7 @@
 #define WORD_SIZE 64
 
 static int
-merge_words(char **dst, char *word)
+merge_words(char **dst, const char *word)
 {
 	char * p = *dst;
 	int len, dstlen;
diff --git a/libmultipath/util.c b/libmultipath/util.c
index 46cacd4..957fb97 100644
--- a/libmultipath/util.c
+++ b/libmultipath/util.c
@@ -53,7 +53,7 @@ basenamecpy (const char *src, char *dst, size_t size)
 }
 
 int
-filepresent (char * run) {
+filepresent (const char *run) {
 	struct stat buf;
 
 	if(!stat(run, &buf))
@@ -61,7 +61,7 @@ filepresent (char * run) {
 	return 0;
 }
 
-char *get_next_string(char **temp, char *split_char)
+char *get_next_string(char **temp, const char *split_char)
 {
 	char *token = NULL;
 	token = strsep(temp, split_char);
@@ -71,9 +71,9 @@ char *get_next_string(char **temp, char *split_char)
 }
 
 int
-get_word (char * sentence, char ** word)
+get_word (const char *sentence, char **word)
 {
-	char * p;
+	const char *p;
 	int len;
 	int skip = 0;
 
@@ -316,7 +316,7 @@ int get_linux_version_code(void)
 	return _linux_version_code;
 }
 
-int parse_prkey(char *ptr, uint64_t *prkey)
+int parse_prkey(const char *ptr, uint64_t *prkey)
 {
 	if (!ptr)
 		return 1;
@@ -333,7 +333,7 @@ int parse_prkey(char *ptr, uint64_t *prkey)
 	return 0;
 }
 
-int parse_prkey_flags(char *ptr, uint64_t *prkey, uint8_t *flags)
+int parse_prkey_flags(const char *ptr, uint64_t *prkey, uint8_t *flags)
 {
 	char *flagstr;
 
diff --git a/libmultipath/util.h b/libmultipath/util.h
index ec6de6d..ae18d8b 100644
--- a/libmultipath/util.h
+++ b/libmultipath/util.h
@@ -12,9 +12,9 @@
 
 size_t strchop(char *);
 int basenamecpy (const char *src, char *dst, size_t size);
-int filepresent (char * run);
-char *get_next_string(char **temp, char *split_char);
-int get_word (char * sentence, char ** word);
+int filepresent (const char *run);
+char *get_next_string(char **temp, const char *split_char);
+int get_word (const char * sentence, char ** word);
 size_t strlcpy(char *dst, const char *src, size_t size);
 size_t strlcat(char *dst, const char *src, size_t size);
 int devt2devname (char *, int, const char *);
@@ -23,8 +23,8 @@ char *convert_dev(char *dev, int is_path_device);
 void setup_thread_attr(pthread_attr_t *attr, size_t stacksize, int detached);
 int systemd_service_enabled(const char *dev);
 int get_linux_version_code(void);
-int parse_prkey(char *ptr, uint64_t *prkey);
-int parse_prkey_flags(char *ptr, uint64_t *prkey, uint8_t *flags);
+int parse_prkey(const char *ptr, uint64_t *prkey);
+int parse_prkey_flags(const char *ptr, uint64_t *prkey, uint8_t *flags);
 int safe_write(int fd, const void *buf, size_t count);
 void set_max_fds(rlim_t max_fds);
 
-- 
2.26.2
