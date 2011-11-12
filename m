From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath: Set the default max_fds to the system
	max
Date: Fri, 11 Nov 2011 23:10:21 -0600
Message-ID: <20111112051021.GE24133@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

Since many people don't realize that they need to set max_fds until they run
out of file descriptors, default to the system max.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/config.c |    2 +-
 libmultipath/dict.c   |    2 +-
 libmultipath/dict.h   |    1 +
 3 files changed, 3 insertions(+), 2 deletions(-)

Index: multipath-tools-111111/libmultipath/config.c
===================================================================
--- multipath-tools-111111.orig/libmultipath/config.c
+++ multipath-tools-111111/libmultipath/config.c
@@ -493,7 +493,7 @@ load_config (char * file)
 	conf->dev_type = DEV_NONE;
 	conf->minio = DEFAULT_MINIO;
 	conf->minio_rq = DEFAULT_MINIO_RQ;
-	conf->max_fds = 0;
+	get_sys_max_fds(&conf->max_fds);
 	conf->bindings_file = set_default(DEFAULT_BINDINGS_FILE);
 	conf->bindings_read_only = 0;
 	conf->multipath_dir = set_default(DEFAULT_MULTIPATHDIR);
Index: multipath-tools-111111/libmultipath/dict.c
===================================================================
--- multipath-tools-111111.orig/libmultipath/dict.c
+++ multipath-tools-111111/libmultipath/dict.c
@@ -255,7 +255,7 @@ def_minio_rq_handler(vector strvec)
 	return 0;
 }
 
-static int
+int
 get_sys_max_fds(int *max_fds)
 {
 	FILE *file;
Index: multipath-tools-111111/libmultipath/dict.h
===================================================================
--- multipath-tools-111111.orig/libmultipath/dict.h
+++ multipath-tools-111111/libmultipath/dict.h
@@ -6,5 +6,6 @@
 #endif
 
 void init_keywords(void);
+int get_sys_max_fds(int *);
 
 #endif /* _DICT_H */
