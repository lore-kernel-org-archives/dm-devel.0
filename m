From: "Chauhan, Vijay" <Vijay.Chauhan@netapp.com>
Subject: [RFC][PATCH 2/3] persistent management feature for
	multipath-tools
Date: Mon, 19 Dec 2011 22:04:59 +0530
Message-ID: <EE2129A8E578DC4E94D643D6C1C1C67D078966D1@BTCMVEXC2-PRD.hq.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, christophe.varoqui@free.fr
Cc: "Chauhan, Vijay" <Vijay.Chauhan@netapp.com>, "Dachepalli,
	Sudhir" <Sudhir.Dachepalli@netapp.com>, "Moger,
	Babu" <Babu.Moger@netapp.com>, "Stankey,
	Robert" <Robert.Stankey@netapp.com>
List-Id: dm-devel.ids

This patch includes changes in multipath tools files for supporting persistent management feature.

Signed-off-by: Vijay Chauhan <Vijay.chauhan@netapp.com>
Reviewed-by: Bob Stankey <Robert.stankey@netapp.com> 
Reviewed-by: Babu Moger <Babu.moger@netapp.com>
Reviewed-by: Yanling Q <Yanling.Q@netapp.com>

---
diff -uprN multipath-tools-orig/libmultipath/config.h multipath-tools/libmultipath/config.h
--- multipath-tools-orig/libmultipath/config.h	2011-12-19 23:59:58.000000000 +0530
+++ multipath-tools/libmultipath/config.h	2011-12-19 23:12:10.000000000 +0530
@@ -49,6 +49,7 @@ struct mpentry {
 
 	char * prio_name;
 	char * prio_args;
+	unsigned char * reservation_key;
 	int pgpolicy;
 	int pgfailback;
 	int rr_weight;
@@ -111,6 +112,7 @@ struct config {
 	char * prio_args;
 	char * checker_name;
 	char * alias_prefix;
+	unsigned char * reservation_key;
 
 	vector keywords;
 	vector mptable;
diff -uprN multipath-tools-orig/libmultipath/configure.c multipath-tools/libmultipath/configure.c
--- multipath-tools-orig/libmultipath/configure.c	2011-12-19 23:59:58.000000000 +0530
+++ multipath-tools/libmultipath/configure.c	2011-12-19 23:12:10.000000000 +0530
@@ -72,6 +72,7 @@ setup_map (struct multipath * mpp, char 
 	select_gid(mpp);
 	select_fast_io_fail(mpp);
 	select_dev_loss(mpp);
+	select_reservation_key(mpp);
 
 	sysfs_set_scsi_tmo(mpp);
 	/*
diff -uprN multipath-tools-orig/libmultipath/dict.c multipath-tools/libmultipath/dict.c
--- multipath-tools-orig/libmultipath/dict.c	2011-12-19 23:59:58.000000000 +0530
+++ multipath-tools/libmultipath/dict.c	2011-12-19 23:12:10.000000000 +0530
@@ -20,6 +20,7 @@
 #include "defaults.h"
 #include "prio.h"
 #include "errno.h"
+#include <inttypes.h>
 
 /*
  * default block handlers
@@ -525,6 +526,53 @@ def_flush_on_last_del_handler(vector str
 }
 
 static int
+def_reservation_key_handler(vector strvec)
+{
+	char *buff;
+	char *tbuff;
+	int j, k;
+	int len;
+	uint64_t prkey;
+
+	buff = set_value(strvec);
+	if (!buff)
+		return 1;
+
+	tbuff = buff;
+
+	if (!memcmp("0x",buff, 2))
+		buff = buff + 2;
+
+	len = strlen(buff);
+
+	k = strspn(buff, "0123456789aAbBcCdDeEfF");
+
+	if (len != k) {
+		FREE(tbuff);
+		return 1;
+	}
+
+	if (1 != sscanf (buff, "%" SCNx64 "", &prkey))
+	{
+		FREE(tbuff);
+		return 1;
+	}
+
+	if (!conf->reservation_key)
+		conf->reservation_key = (unsigned char *) malloc(8);
+
+	memset(conf->reservation_key, 0, 8);
+
+	for (j = 7; j >= 0; --j) {
+		conf->reservation_key[j] = (prkey & 0xff);
+		prkey >>= 8;
+	}
+
+	FREE(tbuff);
+	return 0;
+}
+
+static int
 names_handler(vector strvec)
 {
 	char * buff;
@@ -1545,6 +1593,55 @@ mp_prio_args_handler (vector strvec)
 	return 0;
 }
 
+static int
+mp_reservation_key_handler (vector strvec)
+{
+	char *buff;
+	char *tbuff;
+	struct mpentry *mpe = VECTOR_LAST_SLOT(conf->mptable);
+
+	int j, k, len;
+	uint64_t prkey;
+
+	if (!mpe)
+		return 1;
+
+	buff = set_value(strvec);
+	if (!buff)
+		return 1;
+
+	tbuff = buff;
+	if (!memcmp(buff, "0x", 2))
+		buff = buff + 2;
+
+	len = strlen(buff);
+
+	k = strspn(buff, "0123456789aAbBcCdDeEfF");
+	if (len != k) {
+		FREE(tbuff);
+		return 1;
+	}
+
+	if (1 != sscanf (buff, "%" SCNx64 "", &prkey))
+	{
+		FREE(tbuff);
+		return 1;
+	}
+
+	if (!mpe->reservation_key)
+		mpe->reservation_key = (unsigned char *) malloc(8);
+
+	memset(mpe->reservation_key, 0, 8);
+
+	for (j = 7; j >= 0; --j) {
+		mpe->reservation_key[j] = (prkey & 0xff);
+		prkey >>= 8;
+	}
+
+	FREE(tbuff);
+	return 0;
+}
+
 /*
  * config file keywords printing
  */
@@ -1768,6 +1865,25 @@ snprint_mp_prio_args(char * buff, int le
 }
 
 static int
+snprint_mp_reservation_key (char * buff, int len, void * data)
+{
+	int j;
+	uint64_t prkey;
+	unsigned char *keyp;
+
+	struct mpentry * mpe = (struct mpentry *)data;
+
+	for (j = 0; j < 8; ++j) {
+		if (j > 0)
+			prkey <<= 8;
+		prkey |= *keyp;
+		++keyp;
+	}
+	return snprintf(buff, len, "%s" , mpe->reservation_key);
+}
+
+
+static int
 snprint_hw_fast_io_fail(char * buff, int len, void * data)
 {
 	struct hwentry * hwe = (struct hwentry *)data;
@@ -2367,6 +2483,12 @@ snprint_def_bindings_file (char * buff, 
 }
 
 static int
+snprint_def_reservation_key(char * buff, int len, void * data)
+{
+	return snprintf(buff, len, "%s", conf->reservation_key);
+}
+
+static int
 snprint_ble_simple (char * buff, int len, void * data)
 {
 	struct blentry * ble = (struct blentry *)data;
@@ -2428,6 +2550,7 @@ init_keywords(void)
 	install_keyword("fast_io_fail_tmo", &def_fast_io_fail_handler, &snprint_def_fast_io_fail);
 	install_keyword("dev_loss_tmo", &def_dev_loss_handler, &snprint_def_dev_loss);
 	install_keyword("bindings_file", &bindings_file_handler, &snprint_def_bindings_file);
+	install_keyword("reservation_key", &def_reservation_key_handler, &snprint_def_reservation_key);
 	__deprecated install_keyword("default_selector", &def_selector_handler, NULL);
 	__deprecated install_keyword("default_path_grouping_policy", &def_pgpolicy_handler, NULL);
 	__deprecated install_keyword("default_getuid_callout", &def_getuid_callout_handler, NULL);
@@ -2510,5 +2633,6 @@ init_keywords(void)
 	install_keyword("mode", &mp_mode_handler, &snprint_mp_mode);
 	install_keyword("uid", &mp_uid_handler, &snprint_mp_uid);
 	install_keyword("gid", &mp_gid_handler, &snprint_mp_gid);
+	install_keyword("reservation_key", &mp_reservation_key_handler, &snprint_mp_reservation_key);
 	install_sublevel_end();
 }
diff -uprN multipath-tools-orig/libmultipath/discovery.c multipath-tools/libmultipath/discovery.c
--- multipath-tools-orig/libmultipath/discovery.c	2011-12-19 23:59:58.000000000 +0530
+++ multipath-tools/libmultipath/discovery.c	2011-12-19 23:12:10.000000000 +0530
@@ -902,7 +902,7 @@ pathinfo (struct path *pp, vector hwtabl
 	 * fetch info not available through sysfs
 	 */
 	if (pp->fd < 0)
-		pp->fd = opennode(pp->dev, O_RDONLY);
+		pp->fd = opennode(pp->dev, O_RDWR);
 
 	if (pp->fd < 0) {
 		condlog(4, "Couldn't open node for %s: %s",
diff -uprN multipath-tools-orig/libmultipath/propsel.c multipath-tools/libmultipath/propsel.c
--- multipath-tools-orig/libmultipath/propsel.c	2011-12-19 23:59:58.000000000 +0530
+++ multipath-tools/libmultipath/propsel.c	2011-12-19 23:12:10.000000000 +0530
@@ -4,6 +4,7 @@
  * Copyright (c) 2005 Kiyoshi Ueda, NEC
  */
 #include <stdio.h>
+#include <inttypes.h>
 
 #include "checkers.h"
 #include "memory.h"
@@ -613,3 +614,46 @@ select_flush_on_last_del(struct multipat
 	condlog(3, "flush_on_last_del = DISABLED (internal default)");
 	return 0;
 }
+
+extern int
+select_reservation_key (struct multipath * mp)
+{
+	int j;
+	unsigned char *keyp;
+	uint64_t prkey = 0;
+
+	if (mp->mpe && mp->mpe->reservation_key) {
+		keyp =  mp->mpe->reservation_key;
+		for (j = 0; j < 8; ++j) {
+			if (j > 0)
+				prkey <<= 8;
+			prkey |= *keyp;
+			++keyp;
+		}
+
+		condlog(3, "%s: reservation_key = 0x%" PRIx64 " (multipath setting)",
+				mp->alias, prkey);
+
+		mp->reservation_key = mp->mpe->reservation_key;
+		return 0;
+	}
+
+	if (conf->reservation_key) {
+		keyp = conf->reservation_key;
+		for (j = 0; j < 8; ++j) {
+			if (j > 0)
+				prkey <<= 8;
+			prkey |= *keyp;
+			++keyp;
+		}
+
+		condlog(3, "%s: reservation_key  = 0x%" PRIx64 " (config file default)",
+				mp->alias, prkey);
+
+		mp->reservation_key = conf->reservation_key;
+		return 0;
+	}
+
+	return 0;
+}
+
diff -uprN multipath-tools-orig/libmultipath/propsel.h multipath-tools/libmultipath/propsel.h
--- multipath-tools-orig/libmultipath/propsel.h	2011-12-19 23:59:58.000000000 +0530
+++ multipath-tools/libmultipath/propsel.h	2011-12-19 23:12:09.000000000 +0530
@@ -17,3 +17,5 @@ int select_uid(struct multipath *mp);
 int select_gid(struct multipath *mp);
 int select_fast_io_fail(struct multipath *mp);
 int select_dev_loss(struct multipath *mp);
+int select_reservation_key(struct multipath *mp);
+
diff -uprN multipath-tools-orig/libmultipath/structs.h multipath-tools/libmultipath/structs.h
--- multipath-tools-orig/libmultipath/structs.h	2011-12-19 23:59:58.000000000 +0530
+++ multipath-tools/libmultipath/structs.h	2011-12-19 23:12:10.000000000 +0530
@@ -211,6 +211,10 @@ struct multipath {
 
 	/* checkers shared data */
 	void * mpcontext;
+	/* persistent management data*/
+	unsigned char * reservation_key;
+	unsigned char prflag;
+
 };
 
 struct pathgroup {
diff -uprN multipath-tools-orig/Makefile multipath-tools/Makefile
--- multipath-tools-orig/Makefile	2011-12-19 23:59:55.000000000 +0530
+++ multipath-tools/Makefile	2011-12-19 23:12:06.000000000 +0530
@@ -23,8 +23,10 @@ BUILDDIRS = \
 	libmultipath \
 	libmultipath/prioritizers \
 	libmultipath/checkers \
+	libmpathpersist \
 	multipath \
 	multipathd \
+	mpathpersist \
 	kpartx
 
 ifeq   ($(MULTIPATH_VERSION),)
diff -uprN multipath-tools-orig/Makefile.inc multipath-tools/Makefile.inc
--- multipath-tools-orig/Makefile.inc	2011-12-19 23:59:55.000000000 +0530
+++ multipath-tools/Makefile.inc	2011-12-19 23:12:06.000000000 +0530
@@ -27,10 +27,12 @@ bindir      = $(exec_prefix)/sbin
 libudevdir  = ${prefix}/lib/udev
 multipathdir = $(TOPDIR)/libmultipath
 mandir      = $(prefix)/usr/share/man/man8
+man3dir      = $(prefix)/usr/share/man/man3
 man5dir     = $(prefix)/usr/share/man/man5
 rcdir	    = $(prefix)/etc/init.d
 syslibdir   = $(prefix)/$(LIB)
 libdir	    = $(prefix)/$(LIB)/multipath
+mpathpersistdir = $(TOPDIR)/libmpathpersist
 
 GZIP        = /bin/gzip -9 -c
 INSTALL_PROGRAM = install
diff -uprN multipath-tools-orig/multipathd/cli.c multipath-tools/multipathd/cli.c
--- multipath-tools-orig/multipathd/cli.c	2011-12-19 23:59:58.000000000 +0530
+++ multipath-tools/multipathd/cli.c	2011-12-19 23:12:09.000000000 +0530
@@ -184,6 +184,9 @@ load_keys (void)
 	r += add_key(keys, "quit", QUIT, 0);
 	r += add_key(keys, "exit", QUIT, 0);
 	r += add_key(keys, "shutdown", SHUTDOWN, 0);
+	r += add_key(keys, "getprstatus", GETPRSTATUS, 0);
+	r += add_key(keys, "setprstatus", SETPRSTATUS, 0);
+	r += add_key(keys, "unsetprstatus", UNSETPRSTATUS, 0);
 
 	if (r) {
 		free_keys(keys);
@@ -453,6 +456,9 @@ cli_init (void) {
 	add_handler(FAIL+PATH, NULL);
 	add_handler(QUIT, NULL);
 	add_handler(SHUTDOWN, NULL);
+	add_handler(GETPRSTATUS+MAP, NULL);
+	add_handler(SETPRSTATUS+MAP, NULL);
+	add_handler(UNSETPRSTATUS+MAP, NULL);
 
 	return 0;
 }
diff -uprN multipath-tools-orig/multipathd/cli.h multipath-tools/multipathd/cli.h
--- multipath-tools-orig/multipathd/cli.h	2011-12-19 23:59:58.000000000 +0530
+++ multipath-tools/multipathd/cli.h	2011-12-19 23:12:09.000000000 +0530
@@ -29,6 +29,9 @@ enum {
 	__WILDCARDS,
 	__QUIT,
 	__SHUTDOWN,
+	__GETPRSTATUS,
+	__SETPRSTATUS,
+	__UNSETPRSTATUS,
 };
 
 #define LIST		(1 << __LIST)
@@ -62,6 +65,9 @@ enum {
 #define WILDCARDS	(1 << __WILDCARDS)
 #define QUIT		(1 << __QUIT)
 #define SHUTDOWN	(1 << __SHUTDOWN)
+#define GETPRSTATUS    (1 << __GETPRSTATUS)
+#define SETPRSTATUS    (1 << __SETPRSTATUS)
+#define UNSETPRSTATUS  (1 << __UNSETPRSTATUS)
 
 #define INITIAL_REPLY_LEN 1000
 
diff -uprN multipath-tools-orig/multipathd/cli_handlers.c multipath-tools/multipathd/cli_handlers.c
--- multipath-tools-orig/multipathd/cli_handlers.c	2011-12-19 23:59:58.000000000 +0530
+++ multipath-tools/multipathd/cli_handlers.c	2011-12-20 00:11:45.000000000 +0530
@@ -883,3 +883,76 @@ cli_shutdown (void * v, char ** reply, i
 
 	return exit_daemon(0);
 }
+
+int
+cli_getprstatus (void * v, char ** reply, int * len, void * data)
+{
+	struct multipath * mpp;
+	struct vectors * vecs = (struct vectors *)data;
+	char * param = get_keyparam(v, MAP);
+
+	get_path_layout(vecs->pathvec, 0);
+	mpp = find_mp_by_str(vecs->mpvec, param);
+
+	if (!mpp)
+		return 1;
+
+	condlog(3, "%s: prflag = %u", param, (unsigned int)mpp->prflag);
+
+	*reply =(char *)malloc(2);
+	*len = 2;
+	memset(*reply,0,2);
+
+
+	sprintf(*reply,"%d",mpp->prflag);
+	*reply[1]='\0';
+
+
+	condlog(3, "%s: reply = %s", param, *reply);
+
+	return 0;
+}
+
+int
+cli_setprstatus(void * v, char ** reply, int * len, void * data)
+{
+	struct multipath * mpp;
+	struct vectors * vecs = (struct vectors *)data;
+	char * param = get_keyparam(v, MAP);
+
+	get_path_layout(vecs->pathvec, 0);
+	mpp = find_mp_by_str(vecs->mpvec, param);
+
+	if (!mpp)
+		return 1;
+
+	if (!mpp->prflag) {
+		mpp->prflag = 1;
+		condlog(2, "%s: prflag is set", param);
+	}
+
+
+	return 0;
+}
+
+int
+cli_unsetprstatus(void * v, char ** reply, int * len, void * data)
+{
+	struct multipath * mpp;
+	struct vectors * vecs = (struct vectors *)data;
+	char * param = get_keyparam(v, MAP);
+
+	get_path_layout(vecs->pathvec, 0);
+	mpp = find_mp_by_str(vecs->mpvec, param);
+
+	if (!mpp)
+		return 1;
+
+	if (mpp->prflag) {
+		mpp->prflag = 0;
+		condlog(2, "%s: prflag is unset", param);
+	}
+
+	return 0;
+}
+
diff -uprN multipath-tools-orig/multipathd/cli_handlers.h multipath-tools/multipathd/cli_handlers.h
--- multipath-tools-orig/multipathd/cli_handlers.h	2011-12-19 23:59:58.000000000 +0530
+++ multipath-tools/multipathd/cli_handlers.h	2011-12-20 00:11:45.000000000 +0530
@@ -31,3 +31,7 @@ int cli_fail(void * v, char ** reply, in
 int cli_quit(void * v, char ** reply, int * len, void * data);
 int cli_shutdown(void * v, char ** reply, int * len, void * data);
 int cli_reassign (void * v, char ** reply, int * len, void * data);
+int cli_getprstatus(void * v, char ** reply, int * len, void * data);
+int cli_setprstatus(void * v, char ** reply, int * len, void * data);
+int cli_unsetprstatus(void * v, char ** reply, int * len, void * data);
+
diff -uprN multipath-tools-orig/multipathd/main.c multipath-tools/multipathd/main.c
--- multipath-tools-orig/multipathd/main.c	2011-12-19 23:59:58.000000000 +0530
+++ multipath-tools/multipathd/main.c	2011-12-20 00:11:45.000000000 +0530
@@ -15,6 +15,7 @@
 #include <sys/time.h>
 #include <sys/resource.h>
 #include <limits.h>
+#include <mpath_persist.h>
 
 /*
  * libcheckers
@@ -65,6 +66,12 @@
 #define LOG_MSG(a,b) \
 	if (strlen(b)) condlog(a, "%s: %s - %s", pp->mpp->alias, pp->dev, b);
 
+struct mpath_event_param
+{
+	char * devname;
+	struct multipath *mpp;
+};
+
 pthread_cond_t exit_cond = PTHREAD_COND_INITIALIZER;
 pthread_mutex_t exit_mutex = PTHREAD_MUTEX_INITIALIZER;
 
@@ -460,6 +467,9 @@ rescan:
 			goto fail; /* leave path added to pathvec */
 	}
 
+	/* persistent reseravtion check*/
+	mpath_pr_event_handle(pp);
+
 	/*
 	 * push the map to the device-mapper
 	 */
@@ -861,6 +871,9 @@ uxlsnrloop (void * ap)
 	set_handler_callback(RESTOREQ+MAPS, cli_restore_all_queueing);
 	set_handler_callback(QUIT, cli_quit);
 	set_handler_callback(SHUTDOWN, cli_shutdown);
+	set_handler_callback(GETPRSTATUS+MAP, cli_getprstatus);
+	set_handler_callback(SETPRSTATUS+MAP, cli_setprstatus);
+	set_handler_callback(UNSETPRSTATUS+MAP, cli_unsetprstatus);
 
 	umask(077);
 	uxsock_listen(&uxsock_trigger, ap);
@@ -1139,6 +1152,16 @@ check_path (struct vectors * vecs, struc
 			return;
 		}
 
+		if(newstate == PATH_UP || newstate == PATH_GHOST){
+			if ( pp->mpp && pp->mpp->prflag ){
+				/*
+				 * Check Persistent Reservation.
+				 */
+				condlog(2, "%s: checking persistent reservation registration", pp->dev);
+				mpath_pr_event_handle(pp);
+			}
+		}
+
 		/*
 		 * reinstate this path
 		 */
@@ -1303,6 +1326,10 @@ configure (struct vectors * vecs, int st
 
 	sync_maps_state(mpvec);
 
+	vector_foreach_slot(mpvec, mpp, i){
+		update_map_pr(mpp);
+	}
+
 	/*
 	 * purge dm of old maps
 	 */
@@ -1789,3 +1816,127 @@ main (int argc, char *argv[])
 		return (child(NULL));
 }
 
+void *  mpath_pr_event_handler_fn (void * pathp )
+{
+	struct multipath * mpp;
+	int i,j, ret, isFound;
+	char dev[FILE_NAME_SIZE];
+	int fd;
+	struct path * pp = (struct path *)pathp;
+	unsigned char *keyp;
+	uint64_t prkey;
+	struct prout_param_descriptor *param;
+	struct prin_resp *resp;
+
+	mpp = pp->mpp;
+	resp = mpath_alloc_prin_response(MPATH_PRIN_RKEY_SA);
+	if (!resp){
+		condlog(0,"%s Alloc failed for prin response \n", pp->dev);
+		return NULL;
+	}
+
+	condlog(3, "device %s:%s \n", pp->dev, pp->mpp->wwid);
+	snprintf(dev, FILE_NAME_SIZE, "/dev/%s", pp->dev);
+
+	fd = open(dev, O_RDWR);
+	if(fd < 0){
+		condlog(0, "Unable to open device %s:%s \n", pp->mpp->wwid, dev);
+		free(resp);
+		return NULL;
+	}
+
+	ret = prin_do_scsi_ioctl(fd, MPATH_PRIN_RKEY_SA, resp, 0);
+	if (ret != MPATH_PR_SUCCESS )
+	{
+		condlog(0,"%s : PR IN Read keys Service Action Failed Error=%d\n", pp->dev, ret);
+		goto out;
+	}
+
+	condlog(3, " event pr=%d addlen=%d\n",resp->prin_descriptor.prin_readkeys.prgeneration,
+			resp->prin_descriptor.prin_readkeys.additional_length );
+
+	if (resp->prin_descriptor.prin_readkeys.additional_length == 0 )
+	{
+		condlog(1, "%s: No key found. Device may not be registered.", pp->dev);
+		ret = MPATH_PR_SUCCESS;
+		goto out;
+	}
+	if ( mpp->reservation_key )
+	{
+		prkey = 0;
+		keyp = (unsigned char *)mpp->reservation_key;
+		for (j = 0; j < 8; ++j) {
+			if (j > 0)
+				prkey <<= 8;
+			prkey |= *keyp;
+			++keyp;
+		}
+		condlog(2, "Multipath  reservation_key: 0x%" PRIx64 " ", prkey);
+	}
+	else
+	{
+		condlog(0, " reservation_key not set in multiapth.conf");
+		ret = MPATH_PR_DMMP_ERROR;
+		goto out;
+	}
+	isFound =0;
+	for (i = 0; i < resp->prin_descriptor.prin_readkeys.additional_length/8; i++ )
+	{
+		condlog(2, "PR IN READKEYS[%d]  reservation key:\n",i);
+		dumpHex((char *)&resp->prin_descriptor.prin_readkeys.key_list[i*8], 8 , -1);
+		if (!memcmp(mpp->reservation_key, &resp->prin_descriptor.prin_readkeys.key_list[i*8], 8))
+		{
+			condlog(2, "%s: pr key found in prin readkeys response", mpp->alias);
+			isFound =1;
+			break;
+		}
+	}
+	if (!isFound)
+	{
+		condlog(0, "%s: Either device not registered or ", pp->dev);
+		condlog(0, "host is not authorised for registration. Skip path\n");
+		ret = MPATH_PR_OTHER;
+		goto out;
+	}
+
+	param= malloc(sizeof(struct prout_param_descriptor));
+	memset(param, 0 , sizeof(struct prout_param_descriptor));
+
+	for (j = 7; j >= 0; --j) {
+		param->sa_key[j] = (prkey & 0xff);
+		prkey >>= 8;
+	}
+	param->num_transportid = 0;
+
+	ret = prout_do_scsi_ioctl(fd, MPATH_PROUT_REG_IGN_SA, 0, 0, param, 0);
+	if (ret != MPATH_PR_SUCCESS )
+	{
+		condlog(0,"%s: Reservation registration failed. Error: %d\n", pp->dev, ret);
+	}
+	mpp->prflag = 1;
+
+	free(param);
+out:
+	free(resp);
+	close(fd);
+	return NULL;
+}
+int mpath_pr_event_handle(struct path *pp)
+{
+	pthread_t thread;
+	int rc;
+	pthread_attr_t attr;
+
+	pthread_attr_init(&attr);
+	pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_JOINABLE);
+
+	rc = pthread_create(&thread, NULL , mpath_pr_event_handler_fn, pp);
+	if (rc) {
+		condlog(0, "%s: ERROR; return code from pthread_create() is %d\n", pp->dev, rc);
+		return 0;
+	}
+	pthread_attr_destroy(&attr);
+	rc = pthread_join(thread, NULL);
+	return 0;
+}
+
diff -uprN multipath-tools-orig/multipathd/main.h multipath-tools/multipathd/main.h
--- multipath-tools-orig/multipathd/main.h	2011-12-19 23:59:58.000000000 +0530
+++ multipath-tools/multipathd/main.h	2011-12-19 23:12:09.000000000 +0530
@@ -12,6 +12,8 @@ enum daemon_status {
 };
 
 extern pid_t daemon_pid;
+struct prout_param_descriptor;
+struct prin_resp;
 
 int exit_daemon(int);
 const char * daemon_status(void);
@@ -22,4 +24,16 @@ int ev_add_map (char *, char *, struct v
 int ev_remove_map (char *, char *, int, struct vectors *);
 void sync_map_state (struct multipath *);
 
+void * mpath_alloc_prin_response(int prin_sa);
+int prin_do_scsi_ioctl(int fd, int rq_servact, struct prin_resp * resp,
+	int noisy);
+void dumpHex(const char* , int len, int no_ascii);
+int prout_do_scsi_ioctl( int fd, int rq_servact, int rq_scope,
+	unsigned int rq_type, struct prout_param_descriptor *param,
+	int noisy);
+int mpath_pr_event_handle(struct path *pp);
+void * mpath_pr_event_handler_fn (void * );
+int update_map_pr(struct multipath *mpp);
+void * mpath_pr_event_handler_fn (void * pathp );
+
 #endif /* MAIN_H */
diff -uprN multipath-tools-orig/multipathd/Makefile multipath-tools/multipathd/Makefile
--- multipath-tools-orig/multipathd/Makefile	2011-12-19 23:59:58.000000000 +0530
+++ multipath-tools/multipathd/Makefile	2011-12-19 23:12:09.000000000 +0530
@@ -5,9 +5,9 @@ include ../Makefile.inc
 #
 # basic flags setting
 #
-CFLAGS += -I$(multipathdir)
+CFLAGS += -I$(multipathdir) -I$(mpathpersistdir)
 LDFLAGS += -lpthread -ldevmapper -lreadline -lncurses -ldl \
-	   -L$(multipathdir) -lmultipath
+	   -L$(multipathdir) -lmultipath -L$(mpathpersistdir) -lmpathpersist
 
 #
 # debuging stuff
