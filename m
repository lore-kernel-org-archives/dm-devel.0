From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 10/42] Introduce MP_FAST_IO_FAIL_UNSET
Date: Tue,  8 Jan 2013 14:53:48 +0100
Message-ID: <1357653259-62650-11-git-send-email-hare@suse.de>
References: <1357653259-62650-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1357653259-62650-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

For completeness; all other special values are encoded with
defines, so 'unset' should be, too.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/config.h    |    1 +
 libmultipath/dict.c      |    8 ++++----
 libmultipath/discovery.c |    6 +++---
 libmultipath/propsel.c   |    6 +++---
 libmultipath/structs.c   |    1 +
 5 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/libmultipath/config.h b/libmultipath/config.h
index 16f530f..51fc492 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -11,6 +11,7 @@
  * In kernel, fast_io_fail == 0 means immediate failure on rport delete.
  * OTOH '0' means not-configured in various places in multipath-tools.
  */
+#define MP_FAST_IO_FAIL_UNSET (0)
 #define MP_FAST_IO_FAIL_OFF (-1)
 #define MP_FAST_IO_FAIL_ZERO (-2)
 
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index fe1362e..ab9fdeb 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -47,7 +47,7 @@ def_fast_io_fail_handler(vector strvec)
 		conf->fast_io_fail = MP_FAST_IO_FAIL_OFF;
 	else if (sscanf(buff, "%d", &conf->fast_io_fail) != 1 ||
 		 conf->fast_io_fail < MP_FAST_IO_FAIL_ZERO)
-		conf->fast_io_fail = 0;
+		conf->fast_io_fail = MP_FAST_IO_FAIL_UNSET;
 	else if (conf->fast_io_fail == 0)
 		conf->fast_io_fail = MP_FAST_IO_FAIL_ZERO;
 
@@ -882,7 +882,7 @@ hw_fast_io_fail_handler(vector strvec)
 		hwe->fast_io_fail = MP_FAST_IO_FAIL_OFF;
 	else if (sscanf(buff, "%d", &hwe->fast_io_fail) != 1 ||
 		 hwe->fast_io_fail < MP_FAST_IO_FAIL_ZERO)
-		hwe->fast_io_fail = 0;
+		hwe->fast_io_fail = MP_FAST_IO_FAIL_UNSET;
 	else if (hwe->fast_io_fail == 0)
 		hwe->fast_io_fail = MP_FAST_IO_FAIL_ZERO;
 
@@ -1973,7 +1973,7 @@ static int
 snprint_hw_fast_io_fail(char * buff, int len, void * data)
 {
 	struct hwentry * hwe = (struct hwentry *)data;
-	if (!hwe->fast_io_fail)
+	if (hwe->fast_io_fail == MP_FAST_IO_FAIL_UNSET)
 		return 0;
 	if (hwe->fast_io_fail == conf->fast_io_fail)
 		return 0;
@@ -2282,7 +2282,7 @@ snprint_def_polling_interval (char * buff, int len, void * data)
 static int
 snprint_def_fast_io_fail(char * buff, int len, void * data)
 {
-	if (!conf->fast_io_fail)
+	if (conf->fast_io_fail == MP_FAST_IO_FAIL_UNSET)
 		return 0;
 	if (conf->fast_io_fail == MP_FAST_IO_FAIL_OFF)
 		return snprintf(buff, len, "off");
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 6f5470f..e328332 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -283,7 +283,7 @@ sysfs_set_rport_tmo(struct multipath *mpp, struct path *pp)
 	snprintf(value, 11, "%u", mpp->dev_loss);
 	if (mpp->dev_loss &&
 	    sysfs_attr_set_value(rport_dev, "dev_loss_tmo", value, 11) <= 0) {
-		if ((!mpp->fast_io_fail ||
+		if ((mpp->fast_io_fail == MP_FAST_IO_FAIL_UNSET ||
 		     mpp->fast_io_fail == MP_FAST_IO_FAIL_OFF)
 		    && mpp->dev_loss > 600) {
 			condlog(3, "%s: limiting dev_loss_tmo to 600, since "
@@ -296,7 +296,7 @@ sysfs_set_rport_tmo(struct multipath *mpp, struct path *pp)
 			goto out;
 		}
 	}
-	if (mpp->fast_io_fail){
+	if (mpp->fast_io_fail != MP_FAST_IO_FAIL_UNSET){
 		if (mpp->fast_io_fail == MP_FAST_IO_FAIL_OFF)
 			sprintf(value, "off");
 		else if (mpp->fast_io_fail == MP_FAST_IO_FAIL_ZERO)
@@ -340,7 +340,7 @@ sysfs_set_scsi_tmo (struct multipath *mpp)
 			mpp->alias, mpp->fast_io_fail);
 		mpp->fast_io_fail = MP_FAST_IO_FAIL_OFF;
 	}
-	if (!mpp->dev_loss && !mpp->fast_io_fail)
+	if (!mpp->dev_loss && mpp->fast_io_fail == MP_FAST_IO_FAIL_UNSET)
 		return 0;
 
 	vector_foreach_slot(mpp->paths, pp, i) {
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 17bd893..756aced 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -558,7 +558,7 @@ select_pg_timeout(struct multipath *mp)
 extern int
 select_fast_io_fail(struct multipath *mp)
 {
-	if (mp->hwe && mp->hwe->fast_io_fail) {
+	if (mp->hwe && mp->hwe->fast_io_fail != MP_FAST_IO_FAIL_UNSET) {
 		mp->fast_io_fail = mp->hwe->fast_io_fail;
 		if (mp->fast_io_fail == MP_FAST_IO_FAIL_OFF)
 			condlog(3, "%s: fast_io_fail_tmo = off (controller default)", mp->alias);
@@ -567,7 +567,7 @@ select_fast_io_fail(struct multipath *mp)
 				mp->fast_io_fail == MP_FAST_IO_FAIL_ZERO ? 0 : mp->fast_io_fail);
 		return 0;
 	}
-	if (conf->fast_io_fail) {
+	if (conf->fast_io_fail != MP_FAST_IO_FAIL_UNSET) {
 		mp->fast_io_fail = conf->fast_io_fail;
 		if (mp->fast_io_fail == MP_FAST_IO_FAIL_OFF)
 			condlog(3, "%s: fast_io_fail_tmo = off (config file default)", mp->alias);
@@ -576,7 +576,7 @@ select_fast_io_fail(struct multipath *mp)
 				mp->fast_io_fail == MP_FAST_IO_FAIL_ZERO ? 0 : mp->fast_io_fail);
 		return 0;
 	}
-	mp->fast_io_fail = 0;
+	mp->fast_io_fail = MP_FAST_IO_FAIL_UNSET;
 	return 0;
 }
 
diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index ab57559..88e8706 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -131,6 +131,7 @@ alloc_multipath (void)
 		mpp->bestpg = 1;
 		mpp->mpcontext = NULL;
 		mpp->no_path_retry = NO_PATH_RETRY_UNDEF;
+		mpp->fast_io_fail = MP_FAST_IO_FAIL_UNSET;
 	}
 	return mpp;
 }
-- 
1.7.4.2
