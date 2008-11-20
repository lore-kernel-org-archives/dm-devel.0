From: rrs@researchut.com
Subject: [PATCH] Read the verbosity level from multipath.conf
	configuration file
Date: Thu, 20 Nov 2008 18:11:15 +0530
Message-ID: <1227184875-20831-1-git-send-email-rsarraf@netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Ritesh Raj Sarraf <rrs@researchut.com>
List-Id: dm-devel.ids

From: Ritesh Raj Sarraf <rrs@researchut.com>

With this patch, multipathd can read the verbosity level from
the multipath.conf configuration file.
For example:
verbosity       5

Signed-off-by: Ritesh Raj Sarraf <rrs@researchut.com>
---
 libmultipath/config.c      |    2 +-
 libmultipath/defaults.h    |    1 +
 libmultipath/dict.c        |   20 ++++++++++++++++++++
 multipath/multipath.conf.5 |    5 +++++
 4 files changed, 27 insertions(+), 1 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index 6d731d2..b49cc90 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -420,7 +420,7 @@ load_config (char * file)
 	 * internal defaults
 	 */
 	if (!conf->verbosity)
-		conf->verbosity = 2;
+		conf->verbosity = DEFAULT_VERBOSITY;
 
 	conf->dev_type = DEV_NONE;
 	conf->minio = 1000;
diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index 87b155e..a943673 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -11,6 +11,7 @@
 #define DEFAULT_NO_PATH_RETRY  NO_PATH_RETRY_UNDEF
 #define DEFAULT_PGTIMEOUT      -PGTIMEOUT_NONE
 #define DEFAULT_USER_FRIENDLY_NAMES    0
+#define DEFAULT_VERBOSITY	2
 
 #define DEFAULT_CHECKINT	5
 #define MAX_CHECKINT(a)		(a << 2)
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 2429a93..9d26e9e 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -33,6 +33,17 @@ polling_interval_handler(vector strvec)
 }
 
 static int
+verbosity_handler(vector strvec)
+{
+	char * buff;
+
+	buff = VECTOR_SLOT(strvec, 1);
+	conf->verbosity = atoi(buff);
+
+	return 0;
+}
+
+static int
 udev_dir_handler(vector strvec)
 {
 	conf->udev_dir = set_value(strvec);
@@ -1316,6 +1327,14 @@ snprint_def_polling_interval (char * buff, int len, void * data)
 }
 
 static int
+snprint_def_verbosity (char * buff, int len, void * data)
+{
+	if (conf->checkint == DEFAULT_VERBOSITY)
+		return 0;
+	return snprintf(buff, len, "%i", conf->verbosity);
+}
+
+static int
 snprint_def_udev_dir (char * buff, int len, void * data)
 {
 	if (!conf->udev_dir)
@@ -1549,6 +1568,7 @@ void
 init_keywords(void)
 {
 	install_keyword_root("defaults", NULL);
+	install_keyword("verbosity", &verbosity_handler, &snprint_def_verbosity);
 	install_keyword("polling_interval", &polling_interval_handler, &snprint_def_polling_interval);
 	install_keyword("udev_dir", &udev_dir_handler, &snprint_def_udev_dir);
 	install_keyword("multipath_dir", &multipath_dir_handler, &snprint_def_multipath_dir);
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 39639dd..6c53d9d 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -74,6 +74,11 @@ interval between two path checks in seconds; default is
 directory where udev creates its device nodes; default is
 .I /dev
 .TP
+.B verbosity
+default verbosity. Higher values increase the verbosity level. Valid
+levels are between 0 and 6; default is 2.
+.I /dev
+.TP
 .B selector
 The default path selector algorithm to use; they are offered by the
 kernel multipath target. The only currently implemented is
-- 
1.5.6.5
