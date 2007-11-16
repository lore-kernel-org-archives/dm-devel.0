From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: [RFC] How to fix system stall on root volume multipath
Date: Fri, 16 Nov 2007 09:41:12 +0100
Message-ID: <1195202472.27535.27.camel@localhost.localdomain>
References: <20071109.181719.115904569.k-ueda@ct.jp.nec.com>
	<20071110033113.GA22843@agk.fab.redhat.com>
	<20071112.112454.71086888.k-ueda@ct.jp.nec.com>
	<1194915684.6724.66.camel@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-KeMftvnilzp2scIttsE6"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1194915684.6724.66.camel@localhost.localdomain>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids


--=-KeMftvnilzp2scIttsE6
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


> > Ben, Christophe,
> > Is that code still problem for current multipathd?
> > And what do you think about my proposal?
> > 
> I'm not found of yet-another user-visible ramfs for multipathd use,
> that's why I started with the private namespace tricks. The problems are
> still there, and will stay till we stop using pthreads.
> 
> That may happen someday, as one of the main reason for pthread was the
> (blocking ioctl) libdevmapper event collection. And this is being
> superseded by path status uevents.
> 
> But not soon enough, and the private namespace stuff suffers from lack
> of friendliness anyway : we can't expect users to grasp easily that
> changing their prioritizer in /sbin won't be seen by the multipath
> daemon till restart, for example.
> 
> So I propose to start playing with your prioritizers-as-lib idea to see
> if it's practical.
> 
> I prepared the following patch to that effect. It is not complete
> (actually segfaults, no useful prioritizer ported) but can start fixing
> bugs and go where ever your personnal interest leads.
> 
I'm sorry I forgot to post the git-cached part of the changeset, i.e.
libprio/ files.

There it goes.


--=-KeMftvnilzp2scIttsE6
Content-Disposition: attachment; filename=libprio.patch
Content-Type: text/x-patch; name=libprio.patch; charset=utf-8
Content-Transfer-Encoding: 7bit

diff --git a/Makefile.inc b/Makefile.inc
index 7e2d4e6..1b07ab0 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -24,6 +24,7 @@ exec_prefix = $(prefix)
 bindir      = $(exec_prefix)/sbin
 libudevdir  = ${prefix}/lib/udev
 checkersdir = $(TOPDIR)/libcheckers
+libpriodir  = $(TOPDIR)/libprio
 multipathdir = $(TOPDIR)/libmultipath
 mandir      = $(prefix)/usr/share/man/man8
 man5dir     = $(prefix)/usr/share/man/man5
@@ -33,6 +34,7 @@ GZIP        = /bin/gzip -9 -c
 
 CHECKERSLIB = $(checkersdir)/libcheckers
 MULTIPATHLIB = $(multipathdir)/libmultipath
+LIBPRIO = $(libpriodir)/libprio
 
 INSTALL_PROGRAM = install -s
 
diff --git a/libmultipath/Makefile b/libmultipath/Makefile
index 511f5ad..04761e4 100644
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -6,7 +6,7 @@ BUILD = glibc
 
 include ../Makefile.inc
 
-CFLAGS += -I$(checkersdir)
+CFLAGS += -I$(checkersdir) -I$(libpriodir)
 
 OBJS = memory.o parser.o vector.o devmapper.o callout.o \
        hwtable.o blacklist.o util.o dmparser.o config.o \
diff --git a/libmultipath/config.c b/libmultipath/config.c
index a39af8a..fcca5d8 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -135,9 +135,6 @@ free_hwe (struct hwentry * hwe)
 	if (hwe->getuid)
 		FREE(hwe->getuid);
 
-	if (hwe->getprio)
-		FREE(hwe->getprio);
-
 	if (hwe->features)
 		FREE(hwe->features);
 
@@ -265,9 +262,6 @@ store_hwe (vector hwtable, struct hwentry * dhwe)
 	if (dhwe->getuid && !(hwe->getuid = set_param_str(dhwe->getuid)))
 		goto out;
 
-	if (dhwe->getprio && !(hwe->getprio = set_param_str(dhwe->getprio)))
-		goto out;
-				
 	if (dhwe->features && !(hwe->features = set_param_str(dhwe->features)))
 		goto out;
 	
@@ -283,6 +277,7 @@ store_hwe (vector hwtable, struct hwentry * dhwe)
 	hwe->no_path_retry = dhwe->no_path_retry;
 	hwe->minio = dhwe->minio;
 	hwe->checker = dhwe->checker;
+	hwe->prio = dhwe->prio;
 
 	if (dhwe->bl_product && !(hwe->bl_product = set_param_str(dhwe->bl_product)))
 		goto out;
@@ -321,9 +316,6 @@ free_config (struct config * conf)
 	if (conf->getuid)
 		FREE(conf->getuid);
 
-	if (conf->getprio)
-		FREE(conf->getprio);
-
 	if (conf->features)
 		FREE(conf->features);
 
diff --git a/libmultipath/config.h b/libmultipath/config.h
index a25b3ad..7f7b2a9 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -16,11 +16,11 @@ struct hwentry {
 	char * product;
 	char * revision;
 	char * getuid;
-	char * getprio;
 	char * features;
 	char * hwhandler;
 	char * selector;
 	char * checker_name;
+	char * prio_name;
 
 	int pgpolicy;
 	int pgfailback;
@@ -28,6 +28,7 @@ struct hwentry {
 	int no_path_retry;
 	int minio;
 	int pg_timeout;
+	struct prio * prio;
 	struct checker * checker;
 	char * bl_product;
 };
@@ -53,6 +54,7 @@ struct config {
 	int pgpolicy_flag;
 	int with_sysfs;
 	int pgpolicy;
+	struct prio * prio;
 	struct checker * checker;
 	enum devtypes dev_type;
 	int minio;
@@ -70,7 +72,6 @@ struct config {
 	char * udev_dir;
 	char * selector;
 	char * getuid;
-	char * getprio;
 	char * features;
 	char * hwhandler;
 	char * bindings_file;
diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index df7d971..97a3dd7 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -4,7 +4,6 @@
 #define DEFAULT_FEATURES	"0"
 #define DEFAULT_HWHANDLER	"0"
 #define DEFAULT_MINIO		1000
-#define DEFAULT_GETPRIO		NULL
 #define DEFAULT_PGPOLICY       FAILOVER
 #define DEFAULT_FAILBACK       -FAILBACK_MANUAL
 #define DEFAULT_RR_WEIGHT      RR_WEIGHT_NONE
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 4572a7d..bf08a44 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -5,6 +5,7 @@
  * Copyright (c) 2005 Kiyoshi Ueda, NEC
  */
 #include <checkers.h>
+#include <libprio.h>
 
 #include "vector.h"
 #include "hwtable.h"
@@ -82,19 +83,16 @@ def_getuid_callout_handler(vector strvec)
 }
 
 static int
-def_prio_callout_handler(vector strvec)
+def_prio_handler(vector strvec)
 {
-	conf->getprio = set_value(strvec);
+	char * buff;
 
-	if (!conf->getprio)
+	buff = set_value(strvec);
+	if (!buff)
 		return 1;
-	
-	if (strlen(conf->getprio) == 4 &&
-	    !strcmp(conf->getprio, "none")) {
-		FREE(conf->getprio);
-		conf->getprio = NULL;
-	}
-		
+
+	conf->prio = prio_lookup(buff);
+	FREE(buff);
 	return 0;
 }
 
@@ -571,23 +569,20 @@ hw_handler_handler(vector strvec)
 }
 
 static int
-prio_callout_handler(vector strvec)
+prio_handler(vector strvec)
 {
 	struct hwentry * hwe = VECTOR_LAST_SLOT(conf->hwtable);
+	char * buff;
 	
 	if (!hwe)
 		return 1;
 
-	hwe->getprio = set_value(strvec);
-
-	if (!hwe->getprio)
+	buff = set_value(strvec);
+	if (!buff)
 		return 1;
-
-	if (strlen(hwe->getprio) == 4 && !strcmp(hwe->getprio, "none")) {
-		FREE(hwe->getprio);
-		hwe->getprio = NULL;
-	}
-
+	
+	hwe->prio = prio_lookup(buff);
+	FREE(buff);
 	return 0;
 }
 
@@ -1115,23 +1110,18 @@ snprint_hw_getuid_callout (char * buff, int len, void * data)
 }
 
 static int
-snprint_hw_prio_callout (char * buff, int len, void * data)
+snprint_hw_prio (char * buff, int len, void * data)
 {
 	struct hwentry * hwe = (struct hwentry *)data;
 
-	if (!conf->getprio && !hwe->getprio)
+	if (!hwe->prio)
 		return 0;
-	if (!conf->getprio && hwe->getprio)
-		return snprintf(buff, len, "%s", hwe->getprio);
-	if (conf->getprio && !hwe->getprio)
-		return snprintf(buff, len, "none");
-
-	/* conf->getprio && hwe->getprio */
-	if (strlen(hwe->getprio) == strlen(conf->getprio) &&
-	    !strcmp(hwe->getprio, conf->getprio))
+	if (!prio_selected(hwe->prio))
 		return 0;
-
-	return snprintf(buff, len, "%s", hwe->getprio);
+	if (hwe->prio == conf->prio)
+		return 0;
+	
+	return snprintf(buff, len, "%s", prio_name(hwe->prio));
 }
 
 static int
@@ -1364,12 +1354,12 @@ snprint_def_getuid_callout (char * buff, int len, void * data)
 }
 
 static int
-snprint_def_getprio_callout (char * buff, int len, void * data)
+snprint_def_prio (char * buff, int len, void * data)
 {
-	if (!conf->getprio)
+	if (!conf->prio)
 		return 0;
 
-	return snprintf(buff, len, "%s", conf->getprio);
+	return snprintf(buff, len, "%s", prio_name(conf->prio));
 }
 
 static int
@@ -1523,7 +1513,7 @@ init_keywords(void)
 	install_keyword("selector", &def_selector_handler, &snprint_def_selector);
 	install_keyword("path_grouping_policy", &def_pgpolicy_handler, &snprint_def_path_grouping_policy);
 	install_keyword("getuid_callout", &def_getuid_callout_handler, &snprint_def_getuid_callout);
-	install_keyword("prio_callout", &def_prio_callout_handler, &snprint_def_getprio_callout);
+	install_keyword("prio", &def_prio_handler, &snprint_def_prio);
 	install_keyword("features", &def_features_handler, &snprint_def_features);
 	install_keyword("path_checker", &def_path_checker_handler, &snprint_def_path_checker);
 	install_keyword("failback", &default_failback_handler, &snprint_def_failback);
@@ -1535,7 +1525,7 @@ init_keywords(void)
 	__deprecated install_keyword("default_selector", &def_selector_handler, NULL);
 	__deprecated install_keyword("default_path_grouping_policy", &def_pgpolicy_handler, NULL);
 	__deprecated install_keyword("default_getuid_callout", &def_getuid_callout_handler, NULL);
-	__deprecated install_keyword("default_prio_callout", &def_prio_callout_handler, NULL);
+	__deprecated install_keyword("default_prio", &def_prio_handler, NULL);
 	__deprecated install_keyword("default_features", &def_features_handler, NULL);
 	__deprecated install_keyword("default_path_checker", &def_path_checker_handler, NULL);
 
@@ -1579,7 +1569,7 @@ init_keywords(void)
 	install_keyword("path_checker", &hw_path_checker_handler, &snprint_hw_path_checker);
 	install_keyword("features", &hw_features_handler, &snprint_hw_features);
 	install_keyword("hardware_handler", &hw_handler_handler, &snprint_hw_hardware_handler);
-	install_keyword("prio_callout", &prio_callout_handler, &snprint_hw_prio_callout);
+	install_keyword("prio", &prio_handler, &snprint_hw_prio);
 	install_keyword("failback", &hw_failback_handler, &snprint_hw_failback);
 	install_keyword("rr_weight", &hw_weight_handler, &snprint_hw_rr_weight);
 	install_keyword("no_path_retry", &hw_no_path_retry_handler, &snprint_hw_no_path_retry);
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index c842eb0..eb096ef 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -12,6 +12,7 @@
 #include <errno.h>
 
 #include <checkers.h>
+#include <libprio.h>
 
 #include "vector.h"
 #include "memory.h"
@@ -626,27 +627,16 @@ get_state (struct path * pp)
 static int
 get_prio (struct path * pp)
 {
-	char buff[CALLOUT_MAX_SIZE];
-	char prio[16];
-
-	if (!pp->getprio_selected) {
-		select_getprio(pp);
-		pp->getprio_selected = 1;
-	}
-	if (!pp->getprio) {
-		pp->priority = PRIO_DEFAULT;
-	} else if (apply_format(pp->getprio, &buff[0], pp)) {
-		condlog(0, "error formatting prio callout command");
-		pp->priority = PRIO_UNDEF;
-		return 1;
-	} else if (execute_program(buff, prio, 16)) {
-		condlog(0, "error calling out %s", buff);
+	if (!prio_selected(pp->prio))
+		select_prio(pp);
+	pp->priority = prio_getprio(pp->prio, pp);
+	if (pp->priority < 0) {
+		condlog(0, "%s: %s prio error", pp->dev, prio_name(pp->prio));
 		pp->priority = PRIO_UNDEF;
 		return 1;
-	} else
-		pp->priority = atoi(prio);
-
-	condlog(3, "%s: prio = %u", pp->dev, pp->priority);
+	}
+	condlog(3, "%s: %s prio = %u",
+		pp->dev, prio_name(pp->prio), pp->priority);
 	return 0;
 }
 
diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 43c1310..80b8dd2 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -1,6 +1,7 @@
 #include <stdio.h>
 
 #include <checkers.h>
+#include <libprio.h>
 
 #include "vector.h"
 #include "defaults.h"
@@ -27,7 +28,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "APPLE*",
 		.product       = "Xserve RAID ",
 		.getuid        = DEFAULT_GETUID,
-		.getprio       = NULL,
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -37,6 +37,7 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = DEFAULT_MINIO,
 		.checker_name  = DEFAULT_CHECKER,
+		.prio_name     = DEFAULT_PRIO,
 	},
 	/*
 	 * StorageWorks controller family
@@ -48,7 +49,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "3PARdata",
 		.product       = "VV",
 		.getuid        = DEFAULT_GETUID,
-		.getprio       = NULL,
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -58,12 +58,12 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = DEFAULT_MINIO,
 		.checker_name  = DEFAULT_CHECKER,
+		.prio_name     = DEFAULT_PRIO,
 	},
 	{
 		.vendor        = "DEC",
 		.product       = "HSG80",
 		.getuid        = DEFAULT_GETUID,
-		.getprio       = "/sbin/mpath_prio_hp_sw /dev/%n",
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = "1 hp-sw",
 		.selector      = DEFAULT_SELECTOR,
@@ -73,12 +73,12 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = DEFAULT_MINIO,
 		.checker_name  = HP_SW,
+		.prio_name     = PRIO_HP_SW,
 	},
 	{
 		.vendor        = "HP",
 		.product       = "A6189A",
 		.getuid        = DEFAULT_GETUID,
-		.getprio       = NULL,
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -87,14 +87,14 @@ static struct hwentry default_hw[] = {
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = DEFAULT_MINIO,
-		.checker_name  = READSECTOR0,
+		.checker_name  = DIRECTIO,
+		.prio_name     = DEFAULT_PRIO,
 	},
 	{
 		/* MSA 1000/MSA1500 EVA 3000/5000 with old firmware */
 		.vendor        = "(COMPAQ|HP)",
 		.product       = "(MSA|HSV)1.0.*",
 		.getuid        = DEFAULT_GETUID,
-		.getprio       = "/sbin/mpath_prio_hp_sw /dev/%n",
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = "1 hp-sw",
 		.selector      = DEFAULT_SELECTOR,
@@ -104,13 +104,13 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = DEFAULT_MINIO,
 		.checker_name  = HP_SW,
+		.prio_name     = PRIO_HP_SW,
 	},
 	{
 		/* MSA 1000/1500 with new firmware */
 		.vendor        = "HP",
 		.product       = "MSA VOLUME",
 		.getuid        = DEFAULT_GETUID,
-		.getprio       = "/sbin/mpath_prio_alua /dev/%n",
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -120,12 +120,12 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = DEFAULT_MINIO,
 		.checker_name  = TUR,
+		.prio_name     = PRIO_ALUA,
 	},
 	{
 		.vendor        = "HP",
 		.product       = "MSA2000s*",
 		.getuid        = "/sbin/cciss_id %n",
-		.getprio       = NULL,
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -135,13 +135,13 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = 12,
 		.minio         = DEFAULT_MINIO,
 		.checker_name  = TUR,
+		.prio_name     = DEFAULT_PRIO,
 	},
 	{
 		/* EVA 3000/5000 with new firmware */
 		.vendor        = "(COMPAQ|HP)",
 		.product       = "(MSA|HSV)1.1.*",
 		.getuid        = DEFAULT_GETUID,
-		.getprio       = "/sbin/mpath_prio_alua /dev/%n",
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -151,13 +151,13 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = DEFAULT_MINIO,
 		.checker_name  = TUR,
+		.prio_name     = PRIO_ALUA,
 	},
 	{
 		/* EVA 4000/6000/8000 */
 		.vendor        = "HP",
 		.product       = "HSV2.*",
 		.getuid        = DEFAULT_GETUID,
-		.getprio       = "/sbin/mpath_prio_alua /dev/%n",
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -167,13 +167,13 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = DEFAULT_MINIO,
 		.checker_name  = TUR,
+		.prio_name     = PRIO_ALUA,
 	},
 	{
 		/* HP Smart Array */
 		.vendor        = "HP",
 		.product       = "LOGICAL VOLUME.*",
 		.getuid        = "/lib/udev/scsi_id -n -g -u -s /block/%n",
-		.getprio       = NULL,
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -183,6 +183,7 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = DEFAULT_MINIO,
 		.checker_name  = TUR,
+		.prio_name     = DEFAULT_PRIO,
 	},
 	/*
 	 * DDN controller family
@@ -194,7 +195,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "DDN",
 		.product       = "SAN DataDirector",
 		.getuid        = DEFAULT_GETUID,
-		.getprio       = NULL,
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -204,6 +204,7 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = DEFAULT_MINIO,
 		.checker_name  = DIRECTIO,
+		.prio_name     = DEFAULT_PRIO,
 	},
 	/*
 	 * EMC / Clariion controller family
@@ -215,7 +216,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "EMC",
 		.product       = "SYMMETRIX",
 		.getuid        = "/lib/udev/scsi_id -g -u -ppre-spc3-83 -s /block/%n",
-		.getprio       = NULL,
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -224,14 +224,14 @@ static struct hwentry default_hw[] = {
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = DEFAULT_MINIO,
-		.checker_name  = READSECTOR0,
+		.checker_name  = DIRECTIO,
+		.prio_name     = DEFAULT_PRIO,
 	},
 	{
 		.vendor        = "DGC",
 		.product       = ".*",
 		.bl_product    = "LUNZ",
 		.getuid        = DEFAULT_GETUID,
-		.getprio       = "/sbin/mpath_prio_emc /dev/%n",
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = "1 emc",
 		.selector      = DEFAULT_SELECTOR,
@@ -241,6 +241,7 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = (300 / DEFAULT_CHECKINT),
 		.minio         = DEFAULT_MINIO,
 		.checker_name  = EMC_CLARIION,
+		.prio_name     = PRIO_EMC,
 	},
 	/*
 	 * Fujitsu controller family
@@ -252,7 +253,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "FSC",
 		.product       = "CentricStor",
 		.getuid        = DEFAULT_GETUID,
-		.getprio       = NULL,
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -261,7 +261,8 @@ static struct hwentry default_hw[] = {
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = DEFAULT_MINIO,
-		.checker_name  = READSECTOR0,
+		.checker_name  = DIRECTIO,
+		.prio_name     = DEFAULT_PRIO,
 	},
 	/*
 	 * Hitachi controller family
@@ -273,7 +274,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "(HITACHI|HP)",
 		.product       = "OPEN-.*",
 		.getuid        = DEFAULT_GETUID,
-		.getprio       = NULL,
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -283,12 +283,12 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = DEFAULT_MINIO,
 		.checker_name  = TUR,
+		.prio_name     = DEFAULT_PRIO,
 	},
 	{
 		.vendor        = "HITACHI",
 		.product       = "DF.*",
 		.getuid        = DEFAULT_GETUID,
-		.getprio       = "/sbin/mpath_prio_hds_modular /dev/%n",
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -298,6 +298,7 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = DEFAULT_MINIO,
 		.checker_name  = TUR,
+		.prio_name     = PRIO_HDS,
 	},
 	/*
 	 * IBM controller family
@@ -309,7 +310,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "IBM",
 		.product       = "ProFibre 4000R",
 		.getuid        = DEFAULT_GETUID,
-		.getprio       = NULL,
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -318,14 +318,14 @@ static struct hwentry default_hw[] = {
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = DEFAULT_MINIO,
-		.checker_name  = READSECTOR0,
+		.checker_name  = DIRECTIO,
+		.prio_name     = DEFAULT_PRIO,
 	},
 	{
 		/* IBM DS4100 / FAStT100 */
 		.vendor        = "IBM",
 		.product       = "1742",
 		.getuid        = DEFAULT_GETUID,
-		.getprio       = "/sbin/mpath_prio_rdac /dev/%n",
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -335,13 +335,13 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = DEFAULT_MINIO,
 		.checker_name  = TUR,
+		.prio_name     = PRIO_RDAC,
 	},
 	{
 		/* IBM Netfinity Fibre Channel RAID Controller Unit */
 		.vendor        = "IBM",
 		.product       = "3526",
 		.getuid        = DEFAULT_GETUID,
-		.getprio       = "/sbin/mpath_prio_rdac /dev/%n",
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -351,13 +351,13 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = DEFAULT_MINIO,
 		.checker_name  = TUR,
+		.prio_name     = PRIO_RDAC,
 	},
 	{
 		/* IBM DS4200 / FAStT200 */
 		.vendor        = "IBM",
 		.product       = "3542",
 		.getuid        = DEFAULT_GETUID,
-		.getprio       = NULL,
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -367,13 +367,13 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = DEFAULT_MINIO,
 		.checker_name  = TUR,
+		.prio_name     = DEFAULT_PRIO,
 	},
 	{
 		/* IBM ESS F20 aka Shark */
 		.vendor        = "IBM",
 		.product       = "2105(800|F20)",
 		.getuid        = DEFAULT_GETUID,
-		.getprio       = NULL,
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -383,13 +383,13 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = DEFAULT_MINIO,
 		.checker_name  = TUR,
+		.prio_name     = DEFAULT_PRIO,
 	},
 	{
 		/* IBM DS6000 */
 		.vendor        = "IBM",
 		.product       = "1750500",
 		.getuid        = DEFAULT_GETUID,
-		.getprio       = "/sbin/mpath_prio_alua /dev/%n",
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -399,13 +399,13 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = DEFAULT_MINIO,
 		.checker_name  = TUR,
+		.prio_name     = PRIO_ALUA,
 	},
 	{
 		/* IBM DS8000 */
 		.vendor        = "IBM",
 		.product       = "2107900",
 		.getuid        = DEFAULT_GETUID,
-		.getprio       = NULL,
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -415,13 +415,13 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = DEFAULT_MINIO,
 		.checker_name  = TUR,
+		.prio_name     = DEFAULT_PRIO,
 	},
 	{
 		/* IBM SAN Volume Controller */
 		.vendor        = "IBM",
 		.product       = "2145",
 		.getuid        = DEFAULT_GETUID,
-		.getprio       = "/sbin/mpath_prio_alua /dev/%n",
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -431,6 +431,7 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = DEFAULT_MINIO,
 		.checker_name  = TUR,
+		.prio_name     = PRIO_ALUA,
 	},
 	{
 		/* IBM S/390 ECKD DASD */
@@ -438,7 +439,6 @@ static struct hwentry default_hw[] = {
 		.product       = "S/390 DASD ECKD",
 		.bl_product       = "S/390.*",
 		.getuid        = "/sbin/dasdinfo -u -b %n",
-		.getprio       = NULL,
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -448,6 +448,7 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = DEFAULT_MINIO,
 		.checker_name  = DIRECTIO,
+		.prio_name     = DEFAULT_PRIO,
 	},
  	/*
 	 * NETAPP controller family
@@ -459,7 +460,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "NETAPP",
 		.product       = "LUN.*",
 		.getuid        = DEFAULT_GETUID,
-		.getprio       = "/sbin/mpath_prio_netapp /dev/%n",
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -468,7 +468,8 @@ static struct hwentry default_hw[] = {
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = 128,
-		.checker_name  = READSECTOR0,
+		.checker_name  = DIRECTIO,
+		.prio_name     = PRIO_NETAPP,
 	},
  	/*
 	 * IBM NSeries (NETAPP) controller family
@@ -480,7 +481,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "IBM",
 		.product       = "Nseries.*",
 		.getuid        = DEFAULT_GETUID,
-		.getprio       = "/sbin/mpath_prio_netapp /dev/%n",
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -489,7 +489,8 @@ static struct hwentry default_hw[] = {
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = 128,
-		.checker_name  = READSECTOR0,
+		.checker_name  = DIRECTIO,
+		.prio_name     = PRIO_NETAPP,
 	},
 	/*
 	 * Pillar Data controller family
@@ -501,7 +502,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "Pillar",
 		.product       = "Axiom.*",
 		.getuid        = DEFAULT_GETUID,
-		.getprio       = "/sbin/mpath_prio_alua %n",
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -511,6 +511,7 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = DEFAULT_MINIO,
 		.checker_name  = TUR,
+		.prio_name     = PRIO_ALUA,
 	},
 	/*
 	 * SGI arrays
@@ -522,7 +523,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "SGI",
 		.product       = "TP9[13]00",
 		.getuid        = DEFAULT_GETUID,
-		.getprio       = NULL,
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -531,13 +531,13 @@ static struct hwentry default_hw[] = {
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = DEFAULT_MINIO,
-		.checker_name  = READSECTOR0,
+		.checker_name  = DIRECTIO,
+		.prio_name     = DEFAULT_PRIO,
 	},
 	{
 		.vendor        = "SGI",
 		.product       = "TP9[45]00",
 		.getuid        = DEFAULT_GETUID,
-		.getprio       = "/sbin/mpath_prio_rdac /dev/%n",
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -547,12 +547,12 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.minio         = DEFAULT_MINIO,
 		.checker_name  = RDAC,
+		.prio_name     = PRIO_RDAC,
 	},
 	{
 		.vendor        = "SGI",
 		.product       = "IS.*",
 		.getuid        = DEFAULT_GETUID,
-		.getprio       = "/sbin/mpath_prio_rdac /dev/%n",
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -562,6 +562,7 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.minio         = DEFAULT_MINIO,
 		.checker_name  = RDAC,
+		.prio_name     = PRIO_RDAC,
 	},
 	/*
 	 * STK arrays
@@ -573,7 +574,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "STK",
 		.product       = "OPENstorage D280",
 		.getuid        = DEFAULT_GETUID,
-		.getprio       = "/sbin/mpath_prio_rdac /dev/%n",
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -583,6 +583,7 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = DEFAULT_MINIO,
 		.checker_name  = TUR,
+		.prio_name     = PRIO_RDAC,
 	},
 	/*
 	 * SUN arrays
@@ -594,7 +595,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "SUN",
 		.product       = "(StorEdge 3510|T4)",
 		.getuid        = DEFAULT_GETUID,
-		.getprio       = NULL,
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -603,7 +603,8 @@ static struct hwentry default_hw[] = {
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = DEFAULT_MINIO,
-		.checker_name  = READSECTOR0,
+		.checker_name  = DIRECTIO,
+		.prio_name     = DEFAULT_PRIO,
 	},
  	/*
 	 * Pivot3 RAIGE
@@ -615,7 +616,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "PIVOT3",
 		.product       = "RAIGE VOLUME",
 		.getuid        = "/sbin/scsi_id -p 0x80 -g -u -s /block/%n",
-		.getprio       = NULL,
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -625,6 +625,7 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = 100,
 		.checker_name  = TUR,
+		.prio_name     = DEFAULT_PRIO,
 	},
 	/*
 	 * EOL
@@ -633,7 +634,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = NULL,
 		.product       = NULL,
 		.getuid        = NULL,
-		.getprio       = NULL,
 		.features      = NULL,
 		.hwhandler     = NULL,
 		.selector      = NULL,
@@ -643,6 +643,7 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = 0,
 		.minio         = 0,
 		.checker_name  = NULL,
+		.prio_name     = NULL,
 	},
 };
 
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 45a3728..bb2b2b7 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -6,6 +6,7 @@
 #include <stdio.h>
 
 #include <checkers.h>
+#include <libprio.h>
 
 #include "memory.h"
 #include "vector.h"
@@ -257,22 +258,23 @@ select_getuid (struct path * pp)
 }
 
 extern int
-select_getprio (struct path * pp)
+select_prio (struct path * pp)
 {
-	if (pp->hwe && pp->hwe->getprio) {
-		pp->getprio = pp->hwe->getprio;
-		condlog(3, "%s: getprio = %s (controller setting)",
-			pp->dev, pp->getprio);
+	if (pp->hwe && pp->hwe->prio) {
+		pp->prio = pp->hwe->prio;
+		condlog(3, "%s: prio = %s (controller setting)",
+			pp->dev, prio_name(pp->prio));
 		return 0;
 	}
-	if (conf->getprio) {
-		pp->getprio = conf->getprio;
-		condlog(3, "%s: getprio = %s (config file default)",
-			pp->dev, pp->getprio);
+	if (conf->prio) {
+		pp->prio = conf->prio;
+		condlog(3, "%s: prio = %s (config file default)",
+			pp->dev, prio_name(pp->prio));
 		return 0;
 	}
-	pp->getprio = DEFAULT_GETPRIO;
-	condlog(3, "%s: getprio = NULL (internal default)", pp->dev);
+	pp->prio = prio_default();
+	condlog(3, "%s: prio = %s (internal default)",
+		pp->dev, prio_name(pp->prio));
 	return 0;
 }
 
diff --git a/libmultipath/propsel.h b/libmultipath/propsel.h
index afd1f88..62802f8 100644
--- a/libmultipath/propsel.h
+++ b/libmultipath/propsel.h
@@ -7,7 +7,7 @@ int select_features (struct multipath * mp);
 int select_hwhandler (struct multipath * mp);
 int select_checker(struct path *pp);
 int select_getuid (struct path * pp);
-int select_getprio (struct path * pp);
+int select_prio (struct path * pp);
 int select_no_path_retry(struct multipath *mp);
 int select_pg_timeout(struct multipath *mp);
 int select_minio(struct multipath *mp);
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index f821f87..90605c6 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -121,8 +121,7 @@ struct path {
 	int priority;
 	int pgindex;
 	char * getuid;
-	char * getprio;
-	int getprio_selected;
+	struct prio * prio;
 	struct checker checker;
 	struct multipath * mpp;
 	int fd;
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 1cc6028..a5dc573 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -3,6 +3,7 @@
 #include <unistd.h>
 
 #include <checkers.h>
+#include <libprio.h>
 
 #include "vector.h"
 #include "defaults.h"
@@ -81,8 +82,7 @@ orphan_path (struct path * pp)
 	pp->mpp = NULL;
 	pp->dmstate = PSTATE_UNDEF;
 	pp->getuid = NULL;
-	pp->getprio = NULL;
-	pp->getprio_selected = 0;
+	prio_put(pp->prio);
 	checker_put(&pp->checker);
 	if (pp->fd >= 0)
 		close(pp->fd);
diff --git a/multipath.conf.annotated b/multipath.conf.annotated
index e6cfe9a..f617876 100644
--- a/multipath.conf.annotated
+++ b/multipath.conf.annotated
@@ -52,14 +52,14 @@
 #	getuid_callout	"/lib/udev/scsi_id -g -u -s /block/%n"
 #
 #	#
-#	# name    : prio_callout
+#	# name    : prio
 #	# scope   : multipath
-#	# desc    : the default program and args to callout to obtain a path 
+#	# desc    : the default function to call to obtain a path 
 #	#           priority value. The ALUA bits in SPC-3 provide an
-#	#           exploitable prio value for example. "none" is a valid value
+#	#           exploitable prio value for example.
 #	# default : (null)
 #	#
-#	#prio_callout	"/bin/true"
+#	#prio	"alua"
 #
 #	#
 #	# name    : path_checker
@@ -296,15 +296,14 @@
 #		getuid_callout          "/lib/udev/scsi_id -g -u -s /block/%n"
 #
 #		#
-#		# name    : prio_callout
+#		# name    : prio
 #		# scope   : multipath
-#		# desc    : the program and args to callout to obtain a path 
+#		# desc    : the function to call to obtain a path 
 #		#           weight. Weights are summed for each path group to
 #		#	    determine the next PG to use case of failure.
-#		#	    "none" is a valid value.
 #		# default : no callout, all paths equals
 #		#
-#		prio_callout          "/sbin/mpath_prio_balance_units %d"
+#		prio          "hp_sw"
 #
 #		#
 #		# name    : path_checker
diff --git a/multipath.conf.synthetic b/multipath.conf.synthetic
index 633d625..0c05b4c 100644
--- a/multipath.conf.synthetic
+++ b/multipath.conf.synthetic
@@ -8,7 +8,7 @@
 #	selector		"round-robin 0"
 #	path_grouping_policy	multibus
 #	getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
-#	prio_callout		/bin/true
+#	prio			const
 #	path_checker		directio
 #	rr_min_io		100
 #	rr_weight		priorities
diff --git a/multipathd/Makefile b/multipathd/Makefile
index b430b94..b82f159 100644
--- a/multipathd/Makefile
+++ b/multipathd/Makefile
@@ -21,6 +21,7 @@ LDFLAGS = -lpthread -ldevmapper -lreadline -lncurses -laio
 #
 OBJS = main.o pidfile.o uxlsnr.o uxclnt.o cli.o cli_handlers.o \
        $(MULTIPATHLIB)-glibc.a $(CHECKERSLIB)-glibc.a \
+       $(LIBPRIO)-glibc.a
 
 
 #
@@ -37,6 +38,9 @@ $(EXEC): clean $(OBJS)
 	$(CC) $(OBJS) -o $(EXEC) $(LDFLAGS)
 	$(GZIP) $(EXEC).8 > $(EXEC).8.gz
 
+$(LIBPRIO)-glibc.a:
+	$(MAKE) -C $(libpriodir) BUILD=glibc glibc
+
 $(CHECKERSLIB)-glibc.a:
 	$(MAKE) -C $(checkersdir) BUILD=glibc glibc
 

--=-KeMftvnilzp2scIttsE6
Content-Disposition: attachment; filename=libprio-cached.patch
Content-Type: text/x-patch; name=libprio-cached.patch; charset=utf-8
Content-Transfer-Encoding: 7bit

diff --git a/libprio/Makefile b/libprio/Makefile
new file mode 100644
index 0000000..d0a1be6
--- /dev/null
+++ b/libprio/Makefile
@@ -0,0 +1,27 @@
+# Makefile
+#
+# Copyright (C) 2007 Christophe Varoqui, <christophe.varoqui@free.fr>
+#
+BUILD = glibc
+
+include ../Makefile.inc
+
+OBJS = libprio.o random.o const.o hp_sw.o emc.o rdac.o alua.o netapp.o hds.o
+
+all: $(BUILD)
+
+prepare:
+	@file *-$(BUILD).a >/dev/null 2>&1 || rm -f core *.o *.gz
+
+klibc: prepare $(OBJS)
+	ar rs libprio-klibc.a *.o
+
+glibc: prepare $(OBJS)
+	ar rs libprio-glibc.a *.o
+
+install:
+
+uninstall:
+
+clean:
+	rm -f core *.a *.o *.gz
diff --git a/libprio/alua.c b/libprio/alua.c
new file mode 100644
index 0000000..43cca40
--- /dev/null
+++ b/libprio/alua.c
@@ -0,0 +1,8 @@
+#include <stdio.h>
+
+#include "libprio.h"
+
+int prio_alua(struct path * pp)
+{
+	return 1;
+}
diff --git a/libprio/alua.h b/libprio/alua.h
new file mode 100644
index 0000000..3e74bbf
--- /dev/null
+++ b/libprio/alua.h
@@ -0,0 +1,7 @@
+#ifndef _ALUA_H
+#define _ALUA_H
+
+#define PRIO_ALUA "alua"
+int prio_alua(struct path * pp);
+
+#endif
diff --git a/libprio/const.c b/libprio/const.c
new file mode 100644
index 0000000..5e2ef23
--- /dev/null
+++ b/libprio/const.c
@@ -0,0 +1,8 @@
+#include <stdio.h>
+
+#include "libprio.h"
+
+int prio_const(struct path * pp)
+{
+	return 1;
+}
diff --git a/libprio/const.h b/libprio/const.h
new file mode 100644
index 0000000..220db54
--- /dev/null
+++ b/libprio/const.h
@@ -0,0 +1,7 @@
+#ifndef _CONST_H
+#define _CONST_H
+
+#define PRIO_CONST "const"
+int prio_const(struct path * pp);
+
+#endif
diff --git a/libprio/emc.c b/libprio/emc.c
new file mode 100644
index 0000000..39ff1fe
--- /dev/null
+++ b/libprio/emc.c
@@ -0,0 +1,8 @@
+#include <stdio.h>
+
+#include "libprio.h"
+
+int prio_emc(struct path * pp)
+{
+	return 1;
+}
diff --git a/libprio/emc.h b/libprio/emc.h
new file mode 100644
index 0000000..0ab0bc5
--- /dev/null
+++ b/libprio/emc.h
@@ -0,0 +1,7 @@
+#ifndef _EMC_H
+#define _EMC_H
+
+#define PRIO_EMC "emc"
+int prio_emc(struct path * pp);
+
+#endif
diff --git a/libprio/hds.c b/libprio/hds.c
new file mode 100644
index 0000000..0dd3601
--- /dev/null
+++ b/libprio/hds.c
@@ -0,0 +1,8 @@
+#include <stdio.h>
+
+#include "libprio.h"
+
+int prio_hds(struct path * pp)
+{
+	return 1;
+}
diff --git a/libprio/hds.h b/libprio/hds.h
new file mode 100644
index 0000000..084d77c
--- /dev/null
+++ b/libprio/hds.h
@@ -0,0 +1,7 @@
+#ifndef _HDS_H
+#define _HDS_H
+
+#define PRIO_HDS "hds"
+int prio_hds(struct path * pp);
+
+#endif
diff --git a/libprio/hp_sw.c b/libprio/hp_sw.c
new file mode 100644
index 0000000..908dccc
--- /dev/null
+++ b/libprio/hp_sw.c
@@ -0,0 +1,8 @@
+#include <stdio.h>
+
+#include "libprio.h"
+
+int prio_hp_sw(struct path * pp)
+{
+	return 1;
+}
diff --git a/libprio/hp_sw.h b/libprio/hp_sw.h
new file mode 100644
index 0000000..2fea486
--- /dev/null
+++ b/libprio/hp_sw.h
@@ -0,0 +1,7 @@
+#ifndef _HP_SW_H
+#define _HP_SW_H
+
+#define PRIO_HP_SW "hp_sw"
+int prio_hp_sw(struct path * pp);
+
+#endif
diff --git a/libprio/libprio.c b/libprio/libprio.c
new file mode 100644
index 0000000..1fce0f1
--- /dev/null
+++ b/libprio/libprio.c
@@ -0,0 +1,57 @@
+#include <stdio.h>
+#include <string.h>
+
+#include "libprio.h"
+
+static struct prio prioritizers[] = {
+	{
+		.name    = PRIO_CONST,
+		.getprio = prio_const
+	},
+	{
+		.name    = PRIO_RANDOM,
+		.getprio = prio_random
+	},
+	{
+		.name    = "",
+		.getprio = NULL
+	},
+};
+
+struct prio * prio_lookup (char * name)
+{
+	struct prio * p = &prioritizers[0];
+	
+	while (p->getprio) {
+		if (!strncmp(name, p->name, PRIO_NAME_LEN))
+			return p;
+		p++;
+	}
+	return NULL;
+}
+
+int prio_getprio (struct prio * p, struct path * pp)
+{
+	return p->getprio(pp);
+}
+
+int prio_selected (struct prio * p)
+{
+	return (p->getprio) ? 1 : 0;
+}
+
+void prio_put (struct prio * p)
+{
+	memset(p->name, 0, PRIO_NAME_LEN);
+	p->getprio = NULL;
+}
+
+char * prio_name (struct prio * p)
+{
+	return p->name;
+}
+
+struct prio * prio_default (void)
+{
+	return prio_lookup(DEFAULT_PRIO);
+}
diff --git a/libprio/libprio.h b/libprio/libprio.h
new file mode 100644
index 0000000..6b9db6e
--- /dev/null
+++ b/libprio/libprio.h
@@ -0,0 +1,40 @@
+#ifndef _LIBPRIO_H
+#define _LIBPRIO_H
+
+/*
+ * knowing about path struct gives flexibility to prioritizers
+ */
+#include "../libcheckers/checkers.h"
+#include "../libmultipath/vector.h"
+#include "../libmultipath/structs.h"
+
+#include "const.h"
+#include "random.h"
+#include "hp_sw.h"
+#include "alua.h"
+#include "emc.h"
+#include "netapp.h"
+#include "hds.h"
+#include "rdac.h"
+
+#define DEFAULT_PRIO PRIO_CONST
+
+/*
+ * strings lengths
+ */
+#define PRIO_NAME_LEN 16
+#define PRIO_DEV_LEN 256
+
+struct prio {
+	char name[PRIO_NAME_LEN];
+	int (*getprio)(struct path *);
+};
+
+struct prio * prio_lookup (char *);
+int prio_getprio (struct prio * p, struct path * pp);
+int prio_selected (struct prio *);
+void prio_put (struct prio *);
+char * prio_name (struct prio *);
+struct prio * prio_default (void);
+
+#endif /* _LIBPRIO_H */
diff --git a/libprio/netapp.c b/libprio/netapp.c
new file mode 100644
index 0000000..e6f3224
--- /dev/null
+++ b/libprio/netapp.c
@@ -0,0 +1,8 @@
+#include <stdio.h>
+
+#include "libprio.h"
+
+int prio_netapp(struct path * pp)
+{
+	return 1;
+}
diff --git a/libprio/netapp.h b/libprio/netapp.h
new file mode 100644
index 0000000..ec38821
--- /dev/null
+++ b/libprio/netapp.h
@@ -0,0 +1,7 @@
+#ifndef _NETAPP_H
+#define _NETAPP_H
+
+#define PRIO_NETAPP "netapp"
+int prio_netapp(struct path * pp);
+
+#endif
diff --git a/libprio/random.c b/libprio/random.c
new file mode 100644
index 0000000..0ad9e26
--- /dev/null
+++ b/libprio/random.c
@@ -0,0 +1,16 @@
+#include <stdio.h>
+#include <stdlib.h>
+#include <sys/time.h>
+#include <time.h>
+
+#include "libprio.h"
+
+int prio_random(struct path * pp)
+{
+	struct timeval tv;
+	
+	gettimeofday(&tv, NULL);
+	srand((unsigned int)tv.tv_usec);
+	printf("%i\n", 1+(int) (10.0*rand()/(RAND_MAX+1.0)));
+	return 0;
+}
diff --git a/libprio/random.h b/libprio/random.h
new file mode 100644
index 0000000..b9dae69
--- /dev/null
+++ b/libprio/random.h
@@ -0,0 +1,7 @@
+#ifndef _RANDOM_H
+#define _RANDOM_H
+
+#define PRIO_RANDOM "random"
+int prio_random(struct path * pp);
+
+#endif
diff --git a/libprio/rdac.c b/libprio/rdac.c
new file mode 100644
index 0000000..4d70b89
--- /dev/null
+++ b/libprio/rdac.c
@@ -0,0 +1,8 @@
+#include <stdio.h>
+
+#include "libprio.h"
+
+int prio_rdac(struct path * pp)
+{
+	return 1;
+}
diff --git a/libprio/rdac.h b/libprio/rdac.h
new file mode 100644
index 0000000..a5b7f8e
--- /dev/null
+++ b/libprio/rdac.h
@@ -0,0 +1,7 @@
+#ifndef _RDAC_H
+#define _RDAC_H
+
+#define PRIO_RDAC "rdac"
+int prio_rdac(struct path * pp);
+
+#endif

--=-KeMftvnilzp2scIttsE6
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--=-KeMftvnilzp2scIttsE6--
