From: "Chauhan, Vijay" <Vijay.Chauhan@netapp.com>
Subject: [PATCH 2/3][RESEND]multipath-tools: Changes in
	multipath-tools to handles pr management of data path life
	cycle and state changes.
Date: Fri, 20 Jan 2012 00:51:18 +0530
Message-ID: <EE2129A8E578DC4E94D643D6C1C1C67D07D9B40C@BTCMVEXC2-PRD.hq.netapp.com>
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
To: dm-devel@redhat.com, christophe.varoqui@free.fr, Mike Snitzer <snitzer@redhat.com>, Fil <lists@internyc.net>
Cc: "Dachepalli, Sudhir" <Sudhir.Dachepalli@netapp.com>, "Stankey,
	Robert" <Robert.Stankey@netapp.com>, "Moger,
	Babu" <Babu.Moger@netapp.com>, "Chauhan, Vijay" <Vijay.Chauhan@netapp.com>
List-Id: dm-devel.ids

This patch includes changes in multipathd and multipath library files for handling pr management of 
data path life cycle and state changes. These includes new path discovery and path reinstated.

Signed-off-by: Vijay Chauhan <Vijay.chauhan@netapp.com>
Reviewed-by: Bob Stankey <Robert.stankey@netapp.com> 
Reviewed-by: Babu Moger <Babu.moger@netapp.com>
Reviewed-by: Yanling Q <Yanling.Q@netapp.com>

---
diff -uprN multipath-tools-14jan-upstream-patchedall-1st/libmultipath/config.c multipath-tools/libmultipath/config.c
--- multipath-tools-14jan-upstream-patchedall-1st/libmultipath/config.c	2012-01-12 11:53:01.000000000 -0500
+++ multipath-tools/libmultipath/config.c	2012-01-12 12:05:02.000000000 -0500
@@ -459,6 +459,8 @@ free_config (struct config * conf)
 
 	if (conf->checker_name)
 		FREE(conf->checker_name);
+	if (conf->reservation_key)
+		FREE(conf->reservation_key);
 
 	free_blacklist(conf->blist_devnode);
 	free_blacklist(conf->blist_wwid);
diff -uprN multipath-tools-14jan-upstream-patchedall-1st/libmultipath/config.h multipath-tools/libmultipath/config.h
--- multipath-tools-14jan-upstream-patchedall-1st/libmultipath/config.h	2012-01-12 11:53:01.000000000 -0500
+++ multipath-tools/libmultipath/config.h	2012-01-12 12:05:36.000000000 -0500
@@ -49,6 +49,7 @@ struct mpentry {
 
 	char * prio_name;
 	char * prio_args;
+	unsigned char * reservation_key;
 	int pgpolicy;
 	int pgfailback;
 	int rr_weight;
@@ -113,6 +114,7 @@ struct config {
 	char * prio_args;
 	char * checker_name;
 	char * alias_prefix;
+	unsigned char * reservation_key;
 
 	vector keywords;
 	vector mptable;
diff -uprN multipath-tools-14jan-upstream-patchedall-1st/libmultipath/configure.c multipath-tools/libmultipath/configure.c
--- multipath-tools-14jan-upstream-patchedall-1st/libmultipath/configure.c	2012-01-12 11:53:01.000000000 -0500
+++ multipath-tools/libmultipath/configure.c	2012-01-12 12:06:09.000000000 -0500
@@ -73,6 +73,7 @@ setup_map (struct multipath * mpp, char 
 	select_gid(mpp);
 	select_fast_io_fail(mpp);
 	select_dev_loss(mpp);
+	select_reservation_key(mpp);
 
 	sysfs_set_scsi_tmo(mpp);
 	/*
diff -uprN multipath-tools-14jan-upstream-patchedall-1st/libmultipath/dict.c multipath-tools/libmultipath/dict.c
--- multipath-tools-14jan-upstream-patchedall-1st/libmultipath/dict.c	2012-01-12 11:53:01.000000000 -0500
+++ multipath-tools/libmultipath/dict.c	2012-01-12 12:13:27.000000000 -0500
@@ -20,6 +20,7 @@
 #include "defaults.h"
 #include "prio.h"
 #include "errno.h"
+#include <inttypes.h>
 
 /*
  * default block handlers
@@ -544,6 +545,53 @@ def_log_checker_err_handler(vector strve
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
@@ -1564,6 +1612,56 @@ mp_prio_args_handler (vector strvec)
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
+
 /*
  * config file keywords printing
  */
@@ -1787,6 +1885,14 @@ snprint_mp_prio_args(char * buff, int le
 }
 
 static int
+snprint_mp_reservation_key (char * buff, int len, void * data)
+{
+	struct mpentry * mpe = (struct mpentry *)data;
+	return snprintf(buff, len, "%s" , mpe->reservation_key);
+}
+
+
+static int
 snprint_hw_fast_io_fail(char * buff, int len, void * data)
 {
 	struct hwentry * hwe = (struct hwentry *)data;
@@ -2394,6 +2500,12 @@ snprint_def_bindings_file (char * buff, 
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
@@ -2456,6 +2568,7 @@ init_keywords(void)
 	install_keyword("dev_loss_tmo", &def_dev_loss_handler, &snprint_def_dev_loss);
 	install_keyword("bindings_file", &bindings_file_handler, &snprint_def_bindings_file);
 	install_keyword("log_checker_err", &def_log_checker_err_handler, &snprint_def_log_checker_err);
+	install_keyword("reservation_key", &def_reservation_key_handler, &snprint_def_reservation_key);
 	__deprecated install_keyword("default_selector", &def_selector_handler, NULL);
 	__deprecated install_keyword("default_path_grouping_policy", &def_pgpolicy_handler, NULL);
 	__deprecated install_keyword("default_getuid_callout", &def_getuid_callout_handler, NULL);
@@ -2538,5 +2651,6 @@ init_keywords(void)
 	install_keyword("mode", &mp_mode_handler, &snprint_mp_mode);
 	install_keyword("uid", &mp_uid_handler, &snprint_mp_uid);
 	install_keyword("gid", &mp_gid_handler, &snprint_mp_gid);
+	install_keyword("reservation_key", &mp_reservation_key_handler, &snprint_mp_reservation_key);
 	install_sublevel_end();
 }
diff -uprN multipath-tools-14jan-upstream-patchedall-1st/libmultipath/discovery.c multipath-tools/libmultipath/discovery.c
--- multipath-tools-14jan-upstream-patchedall-1st/libmultipath/discovery.c	2012-01-12 11:53:01.000000000 -0500
+++ multipath-tools/libmultipath/discovery.c	2012-01-12 12:14:04.000000000 -0500
@@ -914,7 +914,7 @@ pathinfo (struct path *pp, vector hwtabl
 	 * fetch info not available through sysfs
 	 */
 	if (pp->fd < 0)
-		pp->fd = opennode(pp->dev, O_RDONLY);
+		pp->fd = opennode(pp->dev, O_RDWR);
 
 	if (pp->fd < 0) {
 		condlog(4, "Couldn't open node for %s: %s",
diff -uprN multipath-tools-14jan-upstream-patchedall-1st/libmultipath/propsel.c multipath-tools/libmultipath/propsel.c
--- multipath-tools-14jan-upstream-patchedall-1st/libmultipath/propsel.c	2012-01-12 11:53:01.000000000 -0500
+++ multipath-tools/libmultipath/propsel.c	2012-01-12 12:15:30.000000000 -0500
@@ -17,6 +17,7 @@
 #include "devmapper.h"
 #include "prio.h"
 #include "discovery.h"
+#include <inttypes.h>
 
 pgpolicyfn *pgpolicies[] = {
 	NULL,
@@ -613,3 +614,48 @@ select_flush_on_last_del(struct multipat
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
+	mp->reservation_key = NULL;
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
+		condlog(3, "%s: reservation_key = 0x%" PRIx64 " "
+				"(multipath setting)",  mp->alias, prkey);
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
+		condlog(3, "%s: reservation_key  = 0x%" PRIx64
+				" (config file default)", mp->alias, prkey);
+
+		mp->reservation_key = conf->reservation_key;
+		return 0;
+	}
+
+	return 0;
+}
+
diff -uprN multipath-tools-14jan-upstream-patchedall-1st/libmultipath/propsel.h multipath-tools/libmultipath/propsel.h
--- multipath-tools-14jan-upstream-patchedall-1st/libmultipath/propsel.h	2012-01-12 11:53:01.000000000 -0500
+++ multipath-tools/libmultipath/propsel.h	2012-01-12 12:15:48.000000000 -0500
@@ -17,3 +17,4 @@ int select_uid(struct multipath *mp);
 int select_gid(struct multipath *mp);
 int select_fast_io_fail(struct multipath *mp);
 int select_dev_loss(struct multipath *mp);
+int select_reservation_key(struct multipath *mp);
diff -uprN multipath-tools-14jan-upstream-patchedall-1st/libmultipath/structs.h multipath-tools/libmultipath/structs.h
--- multipath-tools-14jan-upstream-patchedall-1st/libmultipath/structs.h	2012-01-12 11:53:01.000000000 -0500
+++ multipath-tools/libmultipath/structs.h	2012-01-12 12:16:26.000000000 -0500
@@ -216,6 +216,10 @@ struct multipath {
 
 	/* checkers shared data */
 	void * mpcontext;
+	
+	/* persistent management data*/
+	unsigned char * reservation_key;
+	unsigned char prflag;
 };
 
 struct pathgroup {
diff -uprN multipath-tools-14jan-upstream-patchedall-1st/Makefile multipath-tools/Makefile
--- multipath-tools-14jan-upstream-patchedall-1st/Makefile	2012-01-12 11:53:01.000000000 -0500
+++ multipath-tools/Makefile	2012-01-12 12:17:39.000000000 -0500
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
diff -uprN multipath-tools-14jan-upstream-patchedall-1st/Makefile.inc multipath-tools/Makefile.inc
--- multipath-tools-14jan-upstream-patchedall-1st/Makefile.inc	2012-01-12 11:53:01.000000000 -0500
+++ multipath-tools/Makefile.inc	2012-01-12 12:18:26.000000000 -0500
@@ -28,10 +28,12 @@ libudevdir  = ${prefix}/lib/udev
 multipathdir = $(TOPDIR)/libmultipath
 mandir      = $(prefix)/usr/share/man/man8
 man5dir     = $(prefix)/usr/share/man/man5
+man3dir      = $(prefix)/usr/share/man/man3
 rcdir	    = $(prefix)/etc/init.d
 syslibdir   = $(prefix)/$(LIB)
 libdir	    = $(prefix)/$(LIB)/multipath
 unitdir     = $(prefix)/lib/systemd/system
+mpathpersistdir = $(TOPDIR)/libmpathpersist
 
 GZIP        = /bin/gzip -9 -c
 INSTALL_PROGRAM = install
diff -uprN multipath-tools-14jan-upstream-patchedall-1st/mpathpersist/main.c multipath-tools/mpathpersist/main.c
--- multipath-tools-14jan-upstream-patchedall-1st/mpathpersist/main.c	1969-12-31 19:00:00.000000000 -0500
+++ multipath-tools/mpathpersist/main.c	2012-01-12 12:20:55.000000000 -0500
@@ -0,0 +1,808 @@
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <sys/types.h>
+#include <fcntl.h>
+#include <checkers.h>
+#include <vector.h>
+#include <structs.h>
+#include <getopt.h>
+#include <mpath_persist.h>
+#include "main.h"
+#include <pthread.h>
+#include <ctype.h>
+#include <string.h>
+
+static const char * pr_type_strs[] = {
+	"obsolete [0]",
+	"Write Exclusive",
+	"obsolete [2]",
+	"Exclusive Access",
+	"obsolete [4]",
+	"Write Exclusive, registrants only",
+	"Exclusive Access, registrants only",
+	"Write Exclusive, all registrants",
+	"Exclusive Access, all registrants",
+	"obsolete [9]", "obsolete [0xa]", "obsolete [0xb]", "obsolete [0xc]",
+	"obsolete [0xd]", "obsolete [0xe]", "obsolete [0xf]",
+};
+
+int get_transportids_length(unsigned char * transportid_arr, int max_transportid, int num_transportids);
+void mpath_print_buf_readcap(struct prin_resp *pr_buff); 
+void mpath_print_buf_readfullstat(struct prin_resp *pr_buff);
+void mpath_print_buf_readresv(struct prin_resp *pr_buff);
+void mpath_print_buf_readkeys(struct prin_resp *pr_buff);
+void dumpHex(const char* str, int len, int no_ascii);
+void * mpath_alloc_prin_response(int prin_sa);	
+void mpath_print_transport_id(struct prin_fulldescr *fdesc);
+int construct_transportid(const char * inp, struct transportid transid[], int num_transportids);
+
+int logsink;
+
+int main (int argc, char * argv[])
+{
+	int fd, c, res;
+	const char *device_name = NULL;
+	int num_prin_sa = 0;
+	int num_prout_sa = 0;
+	int num_prout_param = 0;
+	int prin_flag = 0;
+	int prout_flag = 0;
+	int ret = 0;
+	int hex = 0;
+	uint64_t param_sark = 0;
+	unsigned int prout_type = 0;
+	int param_alltgpt = 0;
+	int param_aptpl = 0;
+	uint64_t param_rk = 0;
+	unsigned int param_rtp = 0;
+	int num_transportids = 0;
+	struct transportid transportids[MPATH_MX_TIDS];
+	int prout = 1;
+	int prin = 1;
+	int prin_sa = -1;
+	int prout_sa = -1;
+	int verbose = 0;
+	int loglevel = 0;
+	int noisy = 0;
+	int num_transport =0;
+	void *resp = NULL;
+	struct transportid * tmp; 
+
+	if (optind == argc)
+	{
+
+		fprintf (stderr, "No parameter used\n");
+		usage ();
+		exit (1);
+	}
+
+	if (getuid () != 0)
+	{
+		fprintf (stderr, "need to be root\n");
+		exit (1);
+	}
+
+
+	mpath_lib_init();
+	memset(transportids,0,MPATH_MX_TIDS);
+
+	while (1)
+	{
+		int option_index = 0;
+
+		c = getopt_long (argc, argv, "v:Cd:hHioZK:S:PAT:skrGILcRX:",
+				long_options, &option_index);
+		if (c == -1)
+			break;
+
+		switch (c)
+		{
+			case 'v':
+				if (1 != sscanf (optarg, "%d", &loglevel))
+				{
+					fprintf (stderr, "bad argument to '--verbose'\n");
+					return MPATH_PR_SYNTAX_ERROR;
+				}
+				break;
+
+			case 'C':
+				prout_sa = MPATH_PROUT_CLEAR_SA;
+				++num_prout_sa;
+				break;
+
+			case 'd':
+				device_name = optarg;
+				break;
+
+			case 'h':
+				usage ();
+				return 0;
+
+			case 'H':
+				hex=1;
+				break;
+
+			case 'i':
+				prin_flag = 1;
+				break;
+
+			case 'o':
+				prout_flag = 1;
+				break;
+
+			case 'Z':
+				param_aptpl = 1;
+				++num_prout_param;
+				break;
+			case 'K':
+				if (1 != sscanf (optarg, "%" SCNx64 "", &param_rk))
+				{
+					fprintf (stderr, "bad argument to '--param-rk'\n");
+					return MPATH_PR_SYNTAX_ERROR;
+				}
+				++num_prout_param;
+				break;
+
+			case 'S':
+				if (1 != sscanf (optarg, "%" SCNx64 "", &param_sark))
+				{
+					fprintf (stderr, "bad argument to '--param-sark'\n");
+					return MPATH_PR_SYNTAX_ERROR;
+				}
+				++num_prout_param;
+				break;
+
+			case 'P':
+				prout_sa = MPATH_PROUT_PREE_SA;
+				++num_prout_sa;
+				break;
+
+			case 'A':
+				prout_sa = MPATH_PROUT_PREE_AB_SA;
+				++num_prout_sa;
+				break;
+
+			case 'T':
+				if (1 != sscanf (optarg, "%x", &prout_type))
+				{
+					fprintf (stderr, "bad argument to '--prout-type'\n");
+					return MPATH_PR_SYNTAX_ERROR;
+				}
+				++num_prout_param;
+				break;
+
+			case 's':
+				prin_sa = MPATH_PRIN_RFSTAT_SA;
+				++num_prin_sa;
+				break;
+
+			case 'k':
+				prin_sa = MPATH_PRIN_RKEY_SA;
+				++num_prin_sa;
+				break;
+
+			case 'r':
+				prin_sa = MPATH_PRIN_RRES_SA;
+				++num_prin_sa;
+				break;
+
+			case 'G':
+				prout_sa = MPATH_PROUT_REG_SA;
+				++num_prout_sa;
+				break;
+
+			case 'I':
+				prout_sa = MPATH_PROUT_REG_IGN_SA;
+				++num_prout_sa;
+				break;
+
+			case 'L':
+				prout_sa = MPATH_PROUT_REL_SA;
+				++num_prout_sa;
+				break;
+
+			case 'c':
+				prin_sa = MPATH_PRIN_RCAP_SA;
+				++num_prin_sa;
+				break;
+
+			case 'R':
+				prout_sa = MPATH_PROUT_RES_SA;
+				++num_prout_sa;
+				break;
+
+			case 'X':
+				if (0 != construct_transportid(optarg, transportids, num_transport)) {
+					fprintf(stderr, "bad argument to '--transport-id'\n");
+					return MPATH_PR_SYNTAX_ERROR;
+				}
+
+				++num_transport;
+				break;
+
+			default:
+				fprintf(stderr, "unrecognised switch " "code 0x%x ??\n", c);	
+				usage ();
+				ret = MPATH_PR_SYNTAX_ERROR;
+				goto out;
+		}
+	}
+
+	if (optind < argc)
+	{
+
+		if (NULL == device_name)
+		{
+			device_name = argv[optind];
+			++optind;
+		}
+		if (optind < argc)
+		{
+			for (; optind < argc; ++optind)
+				fprintf (stderr, "Unexpected extra argument: %s\n", argv[optind]);
+			usage ();
+			ret = MPATH_PR_SYNTAX_ERROR;
+			goto out;
+		}
+	}
+
+	/* set verbosity */
+	noisy = (loglevel >= 3) ? 1: 0;
+	verbose	= (loglevel >= 3)? 3: loglevel;
+
+	if ((prout_flag + prin_flag) == 0)
+	{
+		fprintf (stderr, "choose either '--in' or '--out' \n");
+		usage ();
+		ret = MPATH_PR_SYNTAX_ERROR;
+		goto out;
+	}
+	if ((prout_flag + prin_flag) > 1)
+	{
+		fprintf (stderr, "choose either '--in' or '--out' \n");
+		usage ();
+		ret = MPATH_PR_SYNTAX_ERROR;
+		goto out;
+	}
+	else if (prout_flag)
+	{				/* syntax check on PROUT arguments */
+		prin = 0;
+		if ((1 != num_prout_sa) || (0 != num_prin_sa))
+		{
+			fprintf (stderr, " For Persistent Reserve Out only one "
+					"appropriate\n service action must be "
+					"chosen \n");
+			ret = MPATH_PR_SYNTAX_ERROR;
+			goto out;
+		}
+	}
+	else if (prin_flag)
+	{				/* syntax check on PRIN arguments */
+		prout = 0;
+		if (num_prout_sa > 0)
+		{
+			fprintf (stderr, " When a service action for Persistent "
+					"Reserve Out is chosen the\n"
+					" '--out' option must be given \n");
+			ret = MPATH_PR_SYNTAX_ERROR;
+			goto out;
+		}
+		if (0 == num_prin_sa)
+		{
+			fprintf (stderr,
+					" No service action given for Persistent Reserve IN\n");
+			usage();
+			ret = MPATH_PR_SYNTAX_ERROR;
+		}
+		else if (num_prin_sa > 1)
+		{
+			fprintf (stderr, " Too many service actions given; choose "
+					"one only\n");
+			usage();
+			ret = MPATH_PR_SYNTAX_ERROR;
+		}
+	}
+	else
+	{
+		usage ();
+		ret = MPATH_PR_SYNTAX_ERROR;
+		goto out;
+	}
+
+	if ((param_rtp) && (MPATH_PROUT_REG_MOV_SA != prout_sa))
+	{
+		fprintf (stderr, " --relative-target-port"
+				" only useful with --register-move\n");
+		usage ();
+		ret = MPATH_PR_SYNTAX_ERROR;
+		goto out;
+	}
+
+	if (((MPATH_PROUT_RES_SA == prout_sa) ||
+				(MPATH_PROUT_REL_SA == prout_sa) ||
+				(MPATH_PROUT_PREE_SA == prout_sa) ||
+				(MPATH_PROUT_PREE_AB_SA == prout_sa)) &&
+			(0 == prout_type)) {
+		fprintf(stderr, "Warning: --prout-type probably needs to be "
+				"given\n");
+	}
+	if ((verbose > 2) && num_transportids)
+	{
+		fprintf (stderr, "number of tranport-ids decoded from "
+				"command line : %d\n", num_transportids);
+	}
+
+	if (device_name == NULL)
+	{
+		fprintf (stderr, "No device name given \n");
+		usage ();
+		ret = MPATH_PR_SYNTAX_ERROR;
+		goto out;
+	}
+
+	/* open device */
+	if ((fd = open (device_name, O_WRONLY)) < 0)
+	{
+		fprintf (stderr, "%s: error opening file (rw) fd=%d\n",
+				device_name, fd);
+		ret = MPATH_PR_FILE_ERROR;
+		goto out;
+	}
+
+
+	if (prin)
+	{
+		resp = mpath_alloc_prin_response(prin_sa);
+		if (!resp)
+		{
+			fprintf (stderr, "failed to allocate PRIN response buffer\n");
+			ret = MPATH_PR_OTHER;
+			goto out;
+		}
+
+		ret = mpath_persistent_reserve_in (fd, prin_sa, resp, noisy, verbose);
+		if (ret != MPATH_PR_SUCCESS )
+		{
+			fprintf (stderr, "Persistent Reserve IN command failed\n");
+			goto out;	
+		}
+
+		switch(prin_sa)
+		{			
+			case MPATH_PRIN_RKEY_SA: 
+				mpath_print_buf_readkeys(resp);		
+				break;
+			case MPATH_PRIN_RRES_SA: 
+				mpath_print_buf_readresv(resp);
+				break;
+			case MPATH_PRIN_RCAP_SA:
+				mpath_print_buf_readcap(resp);		
+				break;
+			case MPATH_PRIN_RFSTAT_SA:
+				mpath_print_buf_readfullstat(resp);		
+				break;
+		}
+		free(resp);
+	}
+	else if (prout)
+	{
+		int j; 
+		int t_arr_len=0;
+		struct prout_param_descriptor *paramp;
+		t_arr_len = MPATH_MX_TID_LEN * num_transport;
+
+		paramp= malloc(sizeof(struct prout_param_descriptor) + (sizeof(struct transportid *)*(MPATH_MX_TIDS )));
+		
+		memset(paramp, 0, sizeof(struct prout_param_descriptor) + (sizeof(struct transportid *)*(MPATH_MX_TIDS)));
+
+		for (j = 7; j >= 0; --j) {
+			paramp->key[j] = (param_rk & 0xff);
+			param_rk >>= 8;
+		}
+
+		for (j = 7; j >= 0; --j) {
+			paramp->sa_key[j] = (param_sark & 0xff);
+			param_sark >>= 8;
+		}
+
+		if (param_alltgpt)
+			paramp->sa_flags |= 0x4;
+		if (param_aptpl)
+			paramp->sa_flags |= 0x1;
+
+		if (num_transport) 
+		{
+			paramp->sa_flags |= MPATH_F_SPEC_I_PT_MASK;
+			paramp->num_transportid = num_transport;
+			for (j = 0 ; j < num_transport; j++)
+			{
+				paramp->trnptid_list[j] = (struct transportid *)malloc(sizeof(struct transportid));
+				memcpy(paramp->trnptid_list[j], &transportids[j],sizeof(struct transportid));
+			}
+		}
+
+		/* PROUT commands other than 'register and move' */
+		ret = mpath_persistent_reserve_out (fd, prout_sa, 0, prout_type,
+				paramp, noisy, verbose);
+		for (j = 0 ; j < num_transport; j++)
+		{
+			tmp = paramp->trnptid_list[j];
+			free(tmp);
+		}
+		free(paramp);
+	}
+
+	if (ret != MPATH_PR_SUCCESS)
+	{
+		switch(ret)
+		{
+			case MPATH_PR_SENSE_UNIT_ATTENTION:
+				printf("persistent reserve out: scsi status: Unit Attention\n");
+				break;
+			case MPATH_PR_RESERV_CONFLICT:
+				printf("persistent reserve out: scsi status: Reservation Conflict\n");
+				break;
+		}
+		printf("PR out: command failed\n");
+	}
+
+	res = close (fd);
+	if (res < 0)
+	{
+		mpath_lib_exit();
+		return MPATH_PR_FILE_ERROR;
+	}
+
+out :
+	mpath_lib_exit();
+
+	return (ret >= 0) ? ret : MPATH_PR_OTHER;
+}
+
+int
+get_transportids_length(unsigned char * transportid_arr, int max_transportid, int num_transportids)
+{
+	int compact_len = 0;
+	unsigned char * ucp = transportid_arr;
+	int k, off, protocol_id, len;
+	for (k = 0, off = 0; ((k < num_transportids) && (k < max_transportid));
+			++k, off += MPATH_MX_TID_LEN) {
+		protocol_id = ucp[off] & 0xf;
+		if (5 == protocol_id) {
+			len = (ucp[off + 2] << 8) + ucp[off + 3] + 4;
+			if (len < 24)
+				len = 24;
+			if (off > compact_len)
+				memmove(ucp + compact_len, ucp + off, len);
+			compact_len += len;
+
+		} else {
+			if (off > compact_len)
+				memmove(ucp + compact_len, ucp + off, 24);
+			compact_len += 24;
+		}
+	}
+
+	return compact_len;
+}
+
+void mpath_print_buf_readkeys( struct prin_resp *pr_buff)
+{
+	int i,j,k, num;
+	unsigned char *keyp;
+	uint64_t prkey;
+	printf("  PR generation=0x%x, ", pr_buff->prin_descriptor.prin_readkeys.prgeneration);
+
+	num = pr_buff->prin_descriptor.prin_readkeys.additional_length / 8;
+	if (0 == num) {
+		printf("	0 registered reservation key.\n");
+		return;
+	}
+	else if (1 == num)
+		printf("	1 registered reservation key follows:\n");
+	else
+		printf("	%d registered reservation keys follow:\n", num);
+
+
+	keyp = (unsigned char *)&pr_buff->prin_descriptor.prin_readkeys.key_list[0];
+	for (i = 0; i < num ; i++)
+	{
+		prkey = 0;
+		for (j = 0; j < 8; ++j) {
+
+			if (j > 0)
+				prkey <<= 8;
+			prkey |= keyp[j];
+		}
+		printf("    0x%" PRIx64 "\n", prkey);
+		k=8*i+j;
+		keyp = (unsigned char *)&pr_buff->prin_descriptor.prin_readkeys.key_list[k];
+	}
+}
+
+void mpath_print_buf_readresv( struct prin_resp *pr_buff)
+{
+	int j, num, scope=0, type=0;
+	unsigned char *keyp;
+	uint64_t prkey;	
+
+	num = pr_buff->prin_descriptor.prin_readresv.additional_length / 8;
+	if (0 == num)
+	{
+		printf("  PR generation=0x%x, there is NO reservation held \n", pr_buff->prin_descriptor.prin_readresv.prgeneration);
+		return ;
+	}
+	else
+		printf("  PR generation=0x%x, Reservation follows:\n", pr_buff->prin_descriptor.prin_readresv.prgeneration);
+	keyp = (unsigned  char *)&pr_buff->prin_descriptor.prin_readkeys.key_list[0]; 
+	prkey = 0;
+	for (j = 0; j < 8; ++j) {
+		if (j > 0)
+			prkey <<= 8;
+		prkey |= keyp[j];
+	}
+
+	printf("   Key = 0x%" PRIx64 "\n", prkey);
+
+	scope = (pr_buff->prin_descriptor.prin_readresv.scope_type >> 4) &  0x0f;
+	type = pr_buff->prin_descriptor.prin_readresv.scope_type & 0x0f;
+
+	if (scope == 0)	
+		printf("  scope = LU_SCOPE, type = %s", pr_type_strs[type]);
+	else
+		printf("  scope = %d, type = %s", scope, pr_type_strs[type]);
+
+	printf("\n");
+
+}
+
+void mpath_print_buf_readcap( struct prin_resp *pr_buff)
+{
+	if ( pr_buff->prin_descriptor.prin_readcap.length <= 2 ) {
+		fprintf(stderr, "Unexpected response for PRIN Report "
+				"Capabilities\n");
+		return; //MALFORMED;
+	}
+
+	printf("Report capabilities response:\n");
+
+	printf("  Compatible Reservation Handling(CRH): %d\n", !!(pr_buff->prin_descriptor.prin_readcap.flags[0] & 0x10));
+	printf("  Specify Initiator Ports Capable(SIP_C): %d\n",!!(pr_buff->prin_descriptor.prin_readcap.flags[0] & 0x8));
+	printf("  All Target Ports Capable(ATP_C): %d\n",!!(pr_buff->prin_descriptor.prin_readcap.flags[0] & 0x4 ));
+	printf("  Persist Through Power Loss Capable(PTPL_C): %d\n",!!(pr_buff->prin_descriptor.prin_readcap.flags[0]));
+	printf("  Type Mask Valid(TMV): %d\n", !!(pr_buff->prin_descriptor.prin_readcap.flags[1] & 0x80));
+	printf("  Allow Commands: %d\n", !!(( pr_buff->prin_descriptor.prin_readcap.flags[1] >> 4) & 0x7));
+	printf("  Persist Through Power Loss Active(PTPL_A): %d\n",
+			!!(pr_buff->prin_descriptor.prin_readcap.flags[1] & 0x1));
+
+	if(pr_buff->prin_descriptor.prin_readcap.flags[1] & 0x80)
+	{
+		printf("    Support indicated in Type mask:\n");
+
+		printf("      %s: %d\n", pr_type_strs[7], pr_buff->prin_descriptor.prin_readcap.pr_type_mask & 0x80);
+		printf("      %s: %d\n", pr_type_strs[6], pr_buff->prin_descriptor.prin_readcap.pr_type_mask & 0x40);
+		printf("      %s: %d\n", pr_type_strs[5], pr_buff->prin_descriptor.prin_readcap.pr_type_mask & 0x20);
+		printf("      %s: %d\n", pr_type_strs[3], pr_buff->prin_descriptor.prin_readcap.pr_type_mask & 0x8);
+		printf("      %s: %d\n", pr_type_strs[1], pr_buff->prin_descriptor.prin_readcap.pr_type_mask & 0x2);
+		printf("      %s: %d\n", pr_type_strs[8], pr_buff->prin_descriptor.prin_readcap.pr_type_mask & 0x100);
+	}
+}
+
+void mpath_print_buf_readfullstat( struct prin_resp *pr_buff)
+{
+
+	int i,j, num;
+	uint64_t  prkey;
+	uint16_t  rel_pt_addr;
+	unsigned char * keyp;
+
+	num = pr_buff->prin_descriptor.prin_readfd.number_of_descriptor;	
+	if (0 == num)
+	{
+		printf("  PR generation=0x%x \n", pr_buff->prin_descriptor.prin_readfd.prgeneration);
+		return ;
+	}
+	else
+		printf("  PR generation=0x%x \n", pr_buff->prin_descriptor.prin_readfd.prgeneration);
+
+	for (i = 0 ; i < num; i++)
+	{
+		keyp = (unsigned  char *)&pr_buff->prin_descriptor.prin_readfd.descriptors[i]->key;
+
+		prkey = 0;
+		for (j = 0; j < 8; ++j) {
+			if (j > 0)
+				prkey <<= 8;
+			prkey |= *keyp;
+			++keyp;
+		}
+		printf("   Key = 0x%" PRIx64 "\n", prkey);
+
+		if (pr_buff->prin_descriptor.prin_readfd.descriptors[i]->flag & 0x02)	
+			printf("      All target ports bit set\n");
+		else {
+			printf("      All target ports bit clear\n");
+
+			rel_pt_addr = pr_buff->prin_descriptor.prin_readfd.descriptors[i]->rtpi;
+			printf("      Relative port address: 0x%x\n",
+					rel_pt_addr);
+		}
+
+		if (pr_buff->prin_descriptor.prin_readfd.descriptors[i]->flag & 0x1) {
+			printf("      << Reservation holder >>\n");
+			j = ((pr_buff->prin_descriptor.prin_readfd.descriptors[i]->scope_type>> 4) & 0xf);
+			if (0 == j)
+				printf("      scope: LU_SCOPE, ");
+			else
+				printf("      scope: %d ", j);
+			j = (pr_buff->prin_descriptor.prin_readfd.descriptors[i]->scope_type & 0xf);
+			printf(" type: %s\n", pr_type_strs[j]);
+		} else
+			printf("      not reservation holder\n");
+		mpath_print_transport_id(pr_buff->prin_descriptor.prin_readfd.descriptors[i]);
+	}
+}
+
+static void usage()
+{
+	fprintf(stderr,
+			"Usage: mpathpersist [OPTIONS] [DEVICE]\n"
+			" Options:\n"
+			"    --verbose|-v level         verbosity level\n"
+			"                   0           Critical messages\n"
+			"                   1           Error messages\n"
+			"                   2           Warning messages\n"
+			"                   3           Informational messages\n"
+			"                   4           Informational messages with trace enabled\n"
+			"    --clear|-C                 PR Out: Clear\n"
+			"    --device=DEVICE|-d DEVICE  query or change DEVICE\n"
+			"    --help|-h                  output this usage message\n"
+			"    --hex|-H                   output response in hex\n"
+			"    --in|-i                    request PR In command \n"
+			"    --out|-o                   request PR Out command\n"
+			"    --param-aptpl|-Z           PR Out parameter 'APTPL'\n"
+			"    --read-keys|-k             PR In: Read Keys\n"
+			"    --param-sark=SARK|-S SARK  PR Out parameter service "
+			"action\n"
+			"                               reservation key (SARK is in "
+			"hex)\n"
+			"    --preempt|-P               PR Out: Preempt\n"
+			"    --preempt-abort|-A         PR Out: Preempt and Abort\n"
+			"    --prout-type=TYPE|-T TYPE  PR Out command type\n"
+			"    --read-status|-s           PR In: Read Full Status\n"
+			"    --read-keys|-k             PR In: Read Keys\n"
+			"    --read-reservation|-r      PR In: Read Reservation\n"
+			"    --register|-G              PR Out: Register\n"
+			"    --register-ignore|-I       PR Out: Register and Ignore\n"
+			"    --release|-L               PR Out: Release\n"
+			"    --report-capabilities|-c   PR In: Report Capabilities\n"
+			"    --reserve|-R               PR Out: Reserve\n"
+			"    --transport-id=TIDS|-X TIDS  TransportIDs can be mentioned \n"
+			"                               in several forms\n"
+			" Examples:\n"
+			"     mpathpersist --out --register --param-sark=123abc --prout-type=5 /dev/mapper/mpath9\n"
+			"     mpathpersist -i -k /dev/mapper/mpath9\n"	);
+}
+
+void
+mpath_print_transport_id(struct prin_fulldescr *fdesc)
+{
+	switch (fdesc->trnptid.protocol_id) {
+		case MPATH_PROTOCOL_ID_FC:
+			printf("   FCP-2 ");
+			if (0 != fdesc->trnptid.format_code)
+				printf(" [Unexpected format code: %d]\n", 
+						fdesc->trnptid.format_code);
+			dumpHex((const char *)fdesc->trnptid.n_port_name, 8, 0);
+			break;
+		case MPATH_PROTOCOL_ID_ISCSI:
+			printf("   iSCSI ");
+			if (0 == fdesc->trnptid.format_code) {
+				printf("name: %.*s\n", (int)sizeof(fdesc->trnptid.iscsi_name),
+					fdesc->trnptid.iscsi_name);
+			}else if (1 == fdesc->trnptid.format_code){
+				printf("world wide unique port id: %.*s\n",
+						(int)sizeof(fdesc->trnptid.iscsi_name),
+						fdesc->trnptid.iscsi_name);
+			}else {
+				printf("  [Unexpected format code: %d]\n", fdesc->trnptid.format_code);
+				dumpHex((const char *)fdesc->trnptid.iscsi_name,
+					 (int)sizeof(fdesc->trnptid.iscsi_name), 0);
+			}
+			break;
+		case MPATH_PROTOCOL_ID_SAS:
+			printf("   SAS ");
+			 if (0 != fdesc->trnptid.format_code)
+                                printf(" [Unexpected format code: %d]\n",
+                                                fdesc->trnptid.format_code);
+                        dumpHex((const char *)fdesc->trnptid.sas_address, 8, 0);
+			break;
+		default:
+			return;
+	}
+}
+
+int
+construct_transportid(const char * lcp, struct transportid transid[], int num_transportids)
+{
+	unsigned char * tidp;
+	int k = 0;
+	int j, n, b, c, len, alen;
+	const char * ecp;
+	const char * isip;
+
+	if ((0 == memcmp("fcp,", lcp, 4)) ||
+			(0 == memcmp("FCP,", lcp, 4))) {
+		lcp += 4;
+		k = strspn(lcp, "0123456789aAbBcCdDeEfF");
+
+		len = strlen(lcp);
+		if (len != k) {
+			fprintf(stderr, "badly formed symbolic FCP TransportID: %s\n",
+					lcp);
+			return 1;
+		}
+		transid[num_transportids].format_code = MPATH_PROTOCOL_ID_FC;
+		transid[num_transportids].protocol_id = MPATH_WWUI_DEVICE_NAME;
+		for (k = 0, j = 0, b = 0; k < 16; ++k) {
+			c = lcp[k];
+			if (isdigit(c))
+				n = c - 0x30;
+			else if (isupper(c))
+				n = c - 0x37;
+			else
+				n = c - 0x57;
+			if (k & 1) {
+				transid[num_transportids].n_port_name[j] = b | n;
+				++j;
+			} else
+				b = n << 4;
+		}
+		goto my_cont_b;
+	}
+	if ((0 == memcmp("sas,", lcp, 4)) || (0 == memcmp("SAS,", lcp, 4))) {
+		lcp += 4;
+		k = strspn(lcp, "0123456789aAbBcCdDeEfF");
+		len =strlen(lcp);
+		if (len != k) {
+			fprintf(stderr, "badly formed symbolic SAS TransportID: %s\n",
+					lcp);
+			return 1;
+		}
+		transid[num_transportids].format_code = MPATH_PROTOCOL_ID_SAS;
+		transid[num_transportids].protocol_id = MPATH_WWUI_DEVICE_NAME;
+		memcpy(&transid[num_transportids].sas_address, lcp, 8);
+
+		goto my_cont_b;
+	}
+	if (0 == memcmp("iqn.", lcp, 4)) {
+		ecp = strpbrk(lcp, " \t");
+		isip = strstr(lcp, ",i,0x");
+		if (ecp && (isip > ecp))
+			isip = NULL;
+		len = ecp ? (ecp - lcp) : (int)strlen(lcp);
+		memset(&tidp, 0, 24);
+		transid[num_transportids].format_code = (isip ? MPATH_WWUI_PORT_IDENTIFIER:MPATH_WWUI_DEVICE_NAME);
+		transid[num_transportids].protocol_id = MPATH_PROTOCOL_ID_ISCSI;
+		alen = len + 1; /* at least one trailing null */
+		if (alen < 20)
+			alen = 20;
+		else if (0 != (alen % 4))
+			alen = ((alen / 4) + 1) * 4;
+		if (alen > 241) { /* sam5r02.pdf A.2 (Annex) */
+			fprintf(stderr, "iSCSI name too long, alen=%d\n", alen);
+			return 0;
+		}
+		transid[num_transportids].iscsi_name[1] = alen & 0xff;
+		memcpy(&transid[num_transportids].iscsi_name[2], lcp, len);
+		goto my_cont_b;
+	}
+my_cont_b:
+	if (k >= MPATH_MAX_PARAM_LEN) {
+		fprintf(stderr, "build_transportid: array length exceeded\n");
+		return 1;
+	}
+	return 0;
+}
+
diff -uprN multipath-tools-14jan-upstream-patchedall-1st/mpathpersist/main.h multipath-tools/mpathpersist/main.h
--- multipath-tools-14jan-upstream-patchedall-1st/mpathpersist/main.h	1969-12-31 19:00:00.000000000 -0500
+++ multipath-tools/mpathpersist/main.h	2012-01-12 12:20:55.000000000 -0500
@@ -0,0 +1,28 @@
+static struct option long_options[] = {
+	{"verbose", 1, 0, 'v'},
+	{"clear", 0, 0, 'C'},
+	{"device", 1, 0, 'd'},
+	{"help", 0, 0, 'h'},
+	{"hex", 0, 0, 'H'},
+	{"in", 0, 0, 'i'},
+	{"out", 0, 0, 'o'},
+	{"param-aptpl", 0, 0, 'Z'},
+	{"param-rk", 1, 0, 'K'},
+	{"param-sark", 1, 0, 'S'},
+	{"preempt", 0, 0, 'P'},
+	{"preempt-abort", 0, 0, 'A'},
+	{"prout-type", 1, 0, 'T'},
+	{"read-full-status", 0, 0, 's'},
+	{"read-keys", 0, 0, 'k'},
+	{"read-reservation", 0, 0, 'r'},
+	{"register", 0, 0, 'G'},
+	{"register-ignore", 0, 0, 'I'},
+	{"release", 0, 0, 'L'},
+	{"report-capabilities", 0, 0, 'c'},		
+	{"reserve", 0, 0, 'R'},
+	{"transport-id", 1, 0, 'X'},
+	{0, 0, 0, 0}
+};
+
+static void usage(void);
+
diff -uprN multipath-tools-14jan-upstream-patchedall-1st/mpathpersist/Makefile multipath-tools/mpathpersist/Makefile
--- multipath-tools-14jan-upstream-patchedall-1st/mpathpersist/Makefile	1969-12-31 19:00:00.000000000 -0500
+++ multipath-tools/mpathpersist/Makefile	2012-01-12 12:20:55.000000000 -0500
@@ -0,0 +1,30 @@
+# Makefile
+#
+include ../Makefile.inc
+
+OBJS = main.o 
+
+CFLAGS += -I$(multipathdir) -I$(mpathpersistdir) 
+LDFLAGS += -lpthread -ldevmapper -lsysfs -L$(mpathpersistdir) -lmpathpersist -L$(multipathdir) -lmultipath 
+
+EXEC = mpathpersist
+
+all: $(EXEC)
+
+$(EXEC): $(OBJS)
+	$(CC) -g $(OBJS) -o $(EXEC) $(LDFLAGS) $(CFLAGS)
+	$(GZIP) $(EXEC).8 > $(EXEC).8.gz
+	
+install:
+	install -d $(DESTDIR)$(bindir)
+	install -m 755 $(EXEC) $(DESTDIR)$(bindir)/
+	install -d $(DESTDIR)$(mandir)
+	install -m 644 $(EXEC).8.gz $(DESTDIR)$(mandir)
+	
+clean:
+	rm -f *.o $(EXEC)
+	rm -f mpathpersist.8.gz
+
+uninstall:
+	rm $(DESTDIR)$(bindir)/$(EXEC)
+	rm $(DESTDIR)$(mandir)/$(EXEC).8.gz
diff -uprN multipath-tools-14jan-upstream-patchedall-1st/mpathpersist/mpathpersist.8 multipath-tools/mpathpersist/mpathpersist.8
--- multipath-tools-14jan-upstream-patchedall-1st/mpathpersist/mpathpersist.8	1969-12-31 19:00:00.000000000 -0500
+++ multipath-tools/mpathpersist/mpathpersist.8	2012-01-12 12:20:55.000000000 -0500
@@ -0,0 +1,96 @@
+.\" DO NOT MODIFY THIS FILE!  It was generated by help2man 1.39.2.
+.TH MPATHPERSIST  "8" "April 2011" "mpathpersist" "User Commands"
+.SH NAME
+mpathpersist
+.SH SYNOPSIS
+.B mpathpersist
+[\fIOPTIONS\fR] [\fIDEVICE\fR]
+.SH DESCRIPTION
+.IP
+Options:
+.TP
+\fB\-\-verbose\fR|\-v level
+verbosity level
+.TP
+0
+Critical and error messages
+.TP
+1
+Warning messages
+.TP
+2
+Informational messages
+.TP
+3
+Informational messages with trace enabled
+.TP
+\fB\-\-clear\fR|\-C
+PR Out: Clear
+.TP
+\fB\-\-device\fR=\fIDEVICE\fR|\-d DEVICE
+query or change DEVICE
+.TP
+\fB\-\-help\fR|\-h
+output this usage message
+.TP
+\fB\-\-hex\fR|\-H
+output response in hex
+.TP
+\fB\-\-in\fR|\-i
+request PR In command
+.TP
+\fB\-\-out\fR|\-o
+request PR Out command
+.TP
+\fB\-\-param\-aptpl\fR|\-Z
+PR Out parameter 'APTPL'
+.TP
+\fB\-\-read\-keys\fR|\-k
+PR In: Read Keys
+.TP
+\fB\-\-param\-sark\fR=\fISARK\fR|\-S SARK
+PR Out parameter service action
+reservation key (SARK is in hex)
+.TP
+\fB\-\-preempt\fR|\-P
+PR Out: Preempt
+.TP
+\fB\-\-preempt\-abort\fR|\-A
+PR Out: Preempt and Abort
+.TP
+\fB\-\-prout\-type\fR=\fITYPE\fR|\-T TYPE
+PR Out command type
+.TP
+\fB\-\-read\-status\fR|\-s
+PR In: Read Full Status
+.TP
+\fB\-\-read\-keys\fR|\-k
+PR In: Read Keys
+.TP
+\fB\-\-read\-reservation\fR|\-r
+PR In: Read Reservation
+.TP
+\fB\-\-register\fR|\-G
+PR Out: Register
+.TP
+\fB\-\-register\-ignore\fR|\-I
+PR Out: Register and Ignore
+.TP
+\fB\-\-release\fR|\-L
+PR Out: Release
+.TP
+\fB\-\-report\-capabilities\fR|\-c
+PR In: Report Capabilities
+.TP
+\fB\-\-reserve\fR|\-R
+PR Out: Reserve
+.TP
+\fB\-\-transport\-id\fR=\fITIDS\fR|\-X TIDS
+TransportIDs can be mentioned
+in several forms
+.IP
+Examples:
+.IP
+mpathpersist \fB\-\-out\fR \fB\-\-register\fR \fB\-\-param\-sark\fR=\fI123abc\fR \fB\-\-prout\-type\fR=\fI5\fR /dev/mapper/mpath9
+mpathpersist \fB\-i\fR \fB\-k\fR /dev/mapper/mpath9
+.PP
diff -uprN multipath-tools-14jan-upstream-patchedall-1st/multipathd/cli.c multipath-tools/multipathd/cli.c
--- multipath-tools-14jan-upstream-patchedall-1st/multipathd/cli.c	2012-01-12 11:53:01.000000000 -0500
+++ multipath-tools/multipathd/cli.c	2012-01-12 12:23:15.000000000 -0500
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
diff -uprN multipath-tools-14jan-upstream-patchedall-1st/multipathd/cli.h multipath-tools/multipathd/cli.h
--- multipath-tools-14jan-upstream-patchedall-1st/multipathd/cli.h	2012-01-12 11:53:01.000000000 -0500
+++ multipath-tools/multipathd/cli.h	2012-01-12 12:24:09.000000000 -0500
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
+#define GETPRSTATUS	(1 << __GETPRSTATUS)
+#define SETPRSTATUS	(1 << __SETPRSTATUS)
+#define UNSETPRSTATUS	(1 << __UNSETPRSTATUS)
 
 #define INITIAL_REPLY_LEN 1000
 
diff -uprN multipath-tools-14jan-upstream-patchedall-1st/multipathd/cli_handlers.c multipath-tools/multipathd/cli_handlers.c
--- multipath-tools-14jan-upstream-patchedall-1st/multipathd/cli_handlers.c	2012-01-12 11:53:01.000000000 -0500
+++ multipath-tools/multipathd/cli_handlers.c	2012-01-17 06:35:04.000000000 -0500
@@ -883,3 +883,75 @@ cli_shutdown (void * v, char ** reply, i
 
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
+		condlog(2, "%s: prflag set", param);
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
+		condlog(2, "%s: prflag unset", param);
+	}
+
+	return 0;
+}
diff -uprN multipath-tools-14jan-upstream-patchedall-1st/multipathd/cli_handlers.h multipath-tools/multipathd/cli_handlers.h
--- multipath-tools-14jan-upstream-patchedall-1st/multipathd/cli_handlers.h	2012-01-12 11:53:01.000000000 -0500
+++ multipath-tools/multipathd/cli_handlers.h	2012-01-12 12:25:39.000000000 -0500
@@ -31,3 +31,7 @@ int cli_fail(void * v, char ** reply, in
 int cli_quit(void * v, char ** reply, int * len, void * data);
 int cli_shutdown(void * v, char ** reply, int * len, void * data);
 int cli_reassign (void * v, char ** reply, int * len, void * data);
+int cli_getprstatus(void * v, char ** reply, int * len, void * data);
+int cli_setprstatus(void * v, char ** reply, int * len, void * data);
+int cli_unsetprstatus(void * v, char ** reply, int * len, void * data);
+
diff -uprN multipath-tools-14jan-upstream-patchedall-1st/multipathd/main.c multipath-tools/multipathd/main.c
--- multipath-tools-14jan-upstream-patchedall-1st/multipathd/main.c	2012-01-12 11:53:01.000000000 -0500
+++ multipath-tools/multipathd/main.c	2012-01-12 12:32:40.000000000 -0500
@@ -16,6 +16,7 @@
 #include <sys/resource.h>
 #include <limits.h>
 #include <linux/oom.h>
+#include <mpath_persist.h>
 
 /*
  * libcheckers
@@ -71,6 +72,12 @@ do { \
 		condlog(a, "%s: %s - %s", pp->mpp->alias, pp->dev, b); \
 } while(0)
 
+struct mpath_event_param
+{
+	char * devname;
+	struct multipath *mpp;
+};
+
 pthread_cond_t exit_cond = PTHREAD_COND_INITIALIZER;
 pthread_mutex_t exit_mutex = PTHREAD_MUTEX_INITIALIZER;
 
@@ -468,6 +475,9 @@ rescan:
 			goto fail; /* leave path added to pathvec */
 	}
 
+	/* persistent reseravtion check*/
+	mpath_pr_event_handle(pp);	
+
 	/*
 	 * push the map to the device-mapper
 	 */
@@ -875,6 +885,9 @@ uxlsnrloop (void * ap)
 	set_handler_callback(RESTOREQ+MAPS, cli_restore_all_queueing);
 	set_handler_callback(QUIT, cli_quit);
 	set_handler_callback(SHUTDOWN, cli_shutdown);
+	set_handler_callback(GETPRSTATUS+MAP, cli_getprstatus);
+	set_handler_callback(SETPRSTATUS+MAP, cli_setprstatus);
+	set_handler_callback(UNSETPRSTATUS+MAP, cli_unsetprstatus);
 
 	umask(077);
 	uxsock_listen(&uxsock_trigger, ap);
@@ -1154,6 +1167,17 @@ check_path (struct vectors * vecs, struc
 			return;
 		}
 
+		if(newstate == PATH_UP || newstate == PATH_GHOST){
+			if ( pp->mpp && pp->mpp->prflag ){
+				/*
+				 * Check Persistent Reservation.
+				 */
+			condlog(2, "%s: checking persistent reservation "
+				"registration", pp->dev);
+			mpath_pr_event_handle(pp);
+			}
+		}
+
 		/*
 		 * reinstate this path
 		 */
@@ -1321,6 +1345,9 @@ configure (struct vectors * vecs, int st
 	dm_lib_release();
 
 	sync_maps_state(mpvec);
+	vector_foreach_slot(mpvec, mpp, i){
+		update_map_pr(mpp);
+	}
 
 	/*
 	 * purge dm of old maps
@@ -1818,3 +1845,116 @@ main (int argc, char *argv[])
 		return (child(NULL));
 }
 
+void *  mpath_pr_event_handler_fn (void * pathp )
+{
+	struct multipath * mpp;
+	int i,j, ret, isFound;
+	struct path * pp = (struct path *)pathp;
+	unsigned char *keyp;
+	uint64_t prkey;
+	struct prout_param_descriptor *param;
+	struct prin_resp *resp;
+
+	mpp = pp->mpp;
+
+	resp = mpath_alloc_prin_response(MPATH_PRIN_RKEY_SA);
+	if (!resp){
+		condlog(0,"%s Alloc failed for prin response \n", pp->dev);
+		return NULL;
+	}
+
+	ret = prin_do_scsi_ioctl(pp->dev, MPATH_PRIN_RKEY_SA, resp, 0);
+	if (ret != MPATH_PR_SUCCESS )
+	{
+		condlog(0,"%s : pr in read keys service action failed. Error=%d\n", pp->dev, ret);
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
+	prkey = 0;
+	keyp = (unsigned char *)mpp->reservation_key;
+	for (j = 0; j < 8; ++j) {
+		if (j > 0)
+			prkey <<= 8;
+		prkey |= *keyp;
+		++keyp;
+	}
+	condlog(2, "Multipath  reservation_key: 0x%" PRIx64 " ", prkey);
+
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
+	condlog(3, "device %s:%s \n", pp->dev, pp->mpp->wwid);
+
+	ret = prout_do_scsi_ioctl(pp->dev, MPATH_PROUT_REG_IGN_SA, 0, 0, param, 0);
+	if (ret != MPATH_PR_SUCCESS )
+	{
+		condlog(0,"%s: Reservation registration failed. Error: %d\n", pp->dev, ret);
+	}
+	mpp->prflag = 1;
+
+	free(param);
+out:
+	free(resp);
+	return NULL;
+}
+
+int mpath_pr_event_handle(struct path *pp)
+{
+	pthread_t thread;
+	int rc;
+	pthread_attr_t attr;
+	struct multipath * mpp;
+
+	mpp = pp->mpp;
+
+	if (!mpp->reservation_key)
+		return -1;
+
+	pthread_attr_init(&attr);
+	pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_JOINABLE);
+
+	rc = pthread_create(&thread, NULL , mpath_pr_event_handler_fn, pp);
+	if (rc) {
+		condlog(0, "%s: ERROR; return code from pthread_create() is %d\n", pp->dev, rc);
+		return -1;
+	}
+	pthread_attr_destroy(&attr);
+	rc = pthread_join(thread, NULL);
+	return 0;
+}
+
diff -uprN multipath-tools-14jan-upstream-patchedall-1st/multipathd/main.h multipath-tools/multipathd/main.h
--- multipath-tools-14jan-upstream-patchedall-1st/multipathd/main.h	2012-01-12 11:53:01.000000000 -0500
+++ multipath-tools/multipathd/main.h	2012-01-12 12:33:25.000000000 -0500
@@ -11,6 +11,9 @@ enum daemon_status {
     DAEMON_SHUTDOWN,
 };
 
+struct prout_param_descriptor;
+struct prin_resp;
+
 extern pid_t daemon_pid;
 
 int exit_daemon(int);
@@ -21,5 +24,16 @@ int ev_remove_path (char *, struct vecto
 int ev_add_map (char *, char *, struct vectors *);
 int ev_remove_map (char *, char *, int, struct vectors *);
 void sync_map_state (struct multipath *);
+void * mpath_alloc_prin_response(int prin_sa);
+int prin_do_scsi_ioctl(char *, int rq_servact, struct prin_resp * resp,
+       int noisy);
+void dumpHex(const char * , int len, int no_ascii);
+int prout_do_scsi_ioctl(char * , int rq_servact, int rq_scope,
+       unsigned int rq_type, struct prout_param_descriptor *param,
+       int noisy);
+int mpath_pr_event_handle(struct path *pp);
+void * mpath_pr_event_handler_fn (void * );
+int update_map_pr(struct multipath *mpp);
+void * mpath_pr_event_handler_fn (void * pathp );
 
 #endif /* MAIN_H */
diff -uprN multipath-tools-14jan-upstream-patchedall-1st/multipathd/Makefile multipath-tools/multipathd/Makefile
--- multipath-tools-14jan-upstream-patchedall-1st/multipathd/Makefile	2012-01-12 11:53:01.000000000 -0500
+++ multipath-tools/multipathd/Makefile	2012-01-12 12:34:04.000000000 -0500
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
--
