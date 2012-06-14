From: bmarzins@sourceware.org
Subject: multipath-tools ./multipath.conf.defaults libm ...
Date: 14 Jun 2012 21:56:49 -0000
Message-ID: <20120614215649.24442.qmail@sourceware.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-cvs@sourceware.org, dm-devel@redhat.com
List-Id: dm-devel.ids

CVSROOT:	/cvs/dm
Module name:	multipath-tools
Branch: 	RHEL5_FC6
Changes by:	bmarzins@sourceware.org	2012-06-14 21:56:47

Modified files:
	.              : multipath.conf.defaults 
	libmultipath   : alias.c alias.h config.h hwtable.c propsel.c 
	multipath      : main.c multipath.8 
	multipathd     : main.c 

Log message:
	Fixes for RHBZs #747180, 771571, 783522, 769990, 788965
	
	None of these are applicable upstream
	
	747180: added -r to man page
	771571: fixed return value for -h
	783522: made multipathd flush logs on shutdown
	769990: added -B option to make bindings file read-only
	788965: added support for the Fujitsu ETERNUS

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.defaults.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5.4.30&r2=1.5.4.31
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/alias.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.4.2.2&r2=1.4.2.3
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/alias.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.2&r2=1.2.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/config.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.18.2.16&r2=1.18.2.17
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/hwtable.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.20.2.37&r2=1.20.2.38
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/propsel.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.11.2.6&r2=1.11.2.7
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath/main.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.44.2.11&r2=1.44.2.12
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath/multipath.8.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.9.2.1&r2=1.9.2.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/main.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.69.2.40&r2=1.69.2.41

--- multipath-tools/multipath.conf.defaults	2011/10/10 04:15:41	1.5.4.30
+++ multipath-tools/multipath.conf.defaults	2012/06/14 21:56:47	1.5.4.31
@@ -180,7 +180,21 @@
 #		rr_min_io		1000
 #		path_checker		readsector0
 #	}
-#       device {
+#	device {
+#		vendor			"FUJITSU"
+#		product			"ETERNUS_DX(L|400|8000)"
+#		getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
+#		prio_callout            "/sbin/mpath_prio_alua /dev/%n"
+#		features		"1 queue_if_no_path"
+#		hardware_handler	"0"
+#		path_grouping_policy	group_by_prio
+#		failback		immediate
+#		rr_weight		uniform
+#		no_path_retry		10
+#		rr_min_io		1000
+#		path_checker		tur
+#	}
+#	device {
 #		vendor			"(HITACHI|HP)"
 #		product			"OPEN-.*"
 #		getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
--- multipath-tools/libmultipath/alias.c	2007/06/11 23:24:09	1.4.2.2
+++ multipath-tools/libmultipath/alias.c	2012/06/14 21:56:47	1.4.2.3
@@ -307,7 +307,7 @@
 }		
 
 char *
-get_user_friendly_alias(char *wwid, char *file)
+get_user_friendly_alias(char *wwid, char *file, int bindings_read_only)
 {
 	char *alias;
 	int fd, scan_fd, id;
@@ -348,7 +348,7 @@
 		return NULL;
 	}
 
-	if (!alias && can_write)
+	if (!alias && can_write && !bindings_read_only)
 		alias = allocate_binding(fd, wwid, id);
 
 	fclose(f);
--- multipath-tools/libmultipath/alias.h	2006/06/06 18:32:43	1.2
+++ multipath-tools/libmultipath/alias.h	2012/06/14 21:56:47	1.2.2.1
@@ -8,5 +8,5 @@
 "# alias wwid\n" \
 "#\n"
 
-char *get_user_friendly_alias(char *wwid, char *file);
+char *get_user_friendly_alias(char *wwid, char *file, int bindings_readonly);
 char *get_user_friendly_wwid(char *alias, char *file);
--- multipath-tools/libmultipath/config.h	2011/10/27 21:36:20	1.18.2.16
+++ multipath-tools/libmultipath/config.h	2012/06/14 21:56:47	1.18.2.17
@@ -73,6 +73,7 @@
 	int rr_weight;
 	int no_path_retry;
 	int user_friendly_names;
+	int bindings_read_only;
 	int pg_timeout;
 	int max_fds;
 	int force_reload;
--- multipath-tools/libmultipath/hwtable.c	2012/01/16 22:22:05	1.20.2.37
+++ multipath-tools/libmultipath/hwtable.c	2012/06/14 21:56:47	1.20.2.38
@@ -360,6 +360,21 @@
 		.minio         = DEFAULT_MINIO,
 		.checker_name  = READSECTOR0,
 	},
+	{
+		.vendor        = "FUJITSU",
+		.product       = "ETERNUS_DX(L|400|8000)",
+		.getuid        = DEFAULT_GETUID,
+		.getprio       = "/sbin/mpath_prio_alua /dev/%n",
+		.features      = "1 queue_if_no_path",
+		.hwhandler     = DEFAULT_HWHANDLER,
+		.selector      = DEFAULT_SELECTOR,
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = 10,
+		.minio         = DEFAULT_MINIO,
+		.checker_name  = TUR,
+	},
 	/*
 	 * Hitachi controller family
 	 *
--- multipath-tools/libmultipath/propsel.c	2011/02/18 18:27:00	1.11.2.6
+++ multipath-tools/libmultipath/propsel.c	2012/06/14 21:56:47	1.11.2.7
@@ -165,7 +165,8 @@
 		mp->alias = NULL;
 		if (conf->user_friendly_names)
 			mp->alias = get_user_friendly_alias(mp->wwid,
-					conf->bindings_file);
+					conf->bindings_file,
+					conf->bindings_read_only);
 		if (mp->alias == NULL){
 			char *alias;
 			if ((alias = MALLOC(WWID_SIZE)) != NULL){
--- multipath-tools/multipath/main.c	2011/10/24 13:44:25	1.44.2.11
+++ multipath-tools/multipath/main.c	2012/06/14 21:56:47	1.44.2.12
@@ -1,7 +1,7 @@
 /*
  * Soft:        multipath device mapper target autoconfig
  *
- * Version:     $Id: main.c,v 1.44.2.11 2011/10/24 13:44:25 bmarzins Exp $
+ * Version:     $Id: main.c,v 1.44.2.12 2012/06/14 21:56:47 bmarzins Exp $
  *
  * Author:      Christophe Varoqui
  *
@@ -106,7 +106,6 @@
 		"\t\t\tor major:minor or a device map name)\n" \
 		);
 
-	exit(1);
 }
 
 static int
@@ -343,20 +342,25 @@
 	if (load_config(DEFAULT_CONFIGFILE))
 		exit(1);
 
-	while ((arg = getopt(argc, argv, ":dhl::FfM:v:p:b:rq")) != EOF ) {
+	while ((arg = getopt(argc, argv, ":dchl::FfM:v:p:b:Brq")) != EOF ) {
 		switch(arg) {
 		case 1: printf("optarg : %s\n",optarg);
 			break;
 		case 'v':
 			if (sizeof(optarg) > sizeof(char *) ||
-			    !isdigit(optarg[0]))
+			    !isdigit(optarg[0])) {
 				usage (argv[0]);
+				exit(1);
+			}
 
 			conf->verbosity = atoi(optarg);
 			break;
 		case 'q':
 			conf->allow_queueing = 1;
 			break;
+		case 'B':
+			conf->bindings_read_only = 1;
+			break;
 		case 'b':
 			if (conf->bindings_file)
 				FREE(conf->bindings_file);	
@@ -389,6 +393,7 @@
 			if (conf->pgpolicy_flag == -1) {
 				printf("'%s' is not a valid policy\n", optarg);
 				usage(argv[0]);
+				exit(1);
 			}                
 			break;
 		case 'r':
@@ -396,14 +401,18 @@
 			break;
 		case 'h':
 			usage(argv[0]);
+			exit(0);
 		case ':':
 			fprintf(stderr, "Missing option arguement\n");
 			usage(argv[0]);        
+			exit(1);
 		case '?':
 			fprintf(stderr, "Unknown switch: %s\n", optarg);
 			usage(argv[0]);
+			exit(1);
 		default:
 			usage(argv[0]);
+			exit(1);
 		}
 	}        
 	if (optind < argc) {
--- multipath-tools/multipath/multipath.8	2009/11/24 22:12:35	1.9.2.1
+++ multipath-tools/multipath/multipath.8	2012/06/14 21:56:47	1.9.2.2
@@ -6,7 +6,7 @@
 .RB [\| \-v\ \c
 .IR verbosity \|]
 .RB [\| \-d \|]
-.RB [\| \-h | \-l | \-ll | \-f | \-F \|]
+.RB [\| \-h | \-l | \-ll | \-f | \-F | \-B \|]
 .RB [\| \-p\ \c
 .BR failover | multibus | group_by_serial | group_by_prio | group_by_node_name \|]
 .RB [\| device \|]
@@ -47,6 +47,12 @@
 .B \-F
 flush all unused multipath device maps
 .TP
+.B \-r
+force maps to reload
+.TP
+.B \-B
+treat the bindings file as read only
+.TP
 .BI \-p " policy"
 force maps to specified policy:
 .RS 1.2i
--- multipath-tools/multipathd/main.c	2012/03/22 18:02:34	1.69.2.40
+++ multipath-tools/multipathd/main.c	2012/06/14 21:56:47	1.69.2.41
@@ -1708,7 +1708,7 @@
 	condlog(2, "read " DEFAULT_CONFIGFILE);
 
 	if (load_config(DEFAULT_CONFIGFILE))
-		exit(1);
+		goto err;
 
 	setlogmask(LOG_UPTO(conf->verbosity + 3));
 
@@ -1731,27 +1731,27 @@
 	}
 
 	if (pidfile_create(DEFAULT_PIDFILE, getpid())) {
-		if (logsink)
-			log_thread_stop();
-
-		exit(1);
+		condlog(0, "can not create pid file");
+		goto err;
 	}
 	signal_init();
 	setscheduler();
 	set_oom_adj(-16);
 	vecs = gvecs = init_vecs();
 
-	if (!vecs)
-		exit(1);
+	if (!vecs) {
+		condlog(0, "can not allocate path vector");
+		goto err;
+	}
 
 	if (sysfs_get_mnt_path(sysfs_path, FILE_NAME_SIZE)) {
 		condlog(0, "can not find sysfs mount point");
-		exit(1);
+		goto err;
 	}
 #ifdef CLONE_NEWNS
 	if (new_ns && prepare_namespace() < 0) {
 		condlog(0, "cannot prepare namespace");
-		exit(1);
+		goto err;
 	}
 #endif
 
@@ -1760,7 +1760,7 @@
 	 */
 	if (configure(vecs, 1)) {
 		condlog(0, "failure during configuration");
-		exit(1);
+		goto err;
 	}
 
 	/*
@@ -1807,7 +1807,7 @@
 	if (ret) {
 		condlog(0, "error while waiting for event threads: %s",
 			strerror(errno));
-		exit(1);
+		goto err;
 	}
 	unlock(vecs->lock);
 	pthread_mutex_destroy(vecs->lock);
@@ -1837,6 +1837,10 @@
 #endif
 
 	exit(0);
+err:
+	if(logsink)
+		log_thread_stop();
+	exit(1);
 }
 
 static int
@@ -1895,7 +1899,7 @@
 	if (!conf)
 		exit(1);
 
-	while ((arg = getopt(argc, argv, ":dv:k::")) != EOF ) {
+	while ((arg = getopt(argc, argv, ":dv:k::B")) != EOF ) {
 	switch(arg) {
 		case 'd':
 			logsink = 0;
@@ -1908,6 +1912,9 @@
 
 			conf->verbosity = atoi(optarg);
 			break;
+		case 'B':
+			conf->bindings_read_only = 1;
+			break;
 		case 'k':
 			err = uxclnt(optarg);
 			exit(err);
