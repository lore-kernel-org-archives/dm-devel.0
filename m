From: heinzm@sourceware.org
Subject: dmraid ./dmraid.spec lib/format/ataraid/pdc.h  ...
Date: 12 Jan 2010 12:16:00 -0000
Message-ID: <20100112121600.29462.qmail@sourceware.org>
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
Module name:	dmraid
Changes by:	heinzm@sourceware.org	2010-01-12 12:15:59

Modified files:
	.              : dmraid.spec 
	lib/format/ataraid: pdc.h 
	lib/metadata   : metadata.c 
	logwatch       : dmeventd 
	tools          : commands.c commands.h dmraid.c 

Log message:
	Move pattern file to /var/cache/ and update changelog

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/dmraid.spec.diff?cvsroot=dm&r1=1.9&r2=1.10
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/pdc.h.diff?cvsroot=dm&r1=1.5&r2=1.6
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/metadata/metadata.c.diff?cvsroot=dm&r1=1.8&r2=1.9
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/logwatch/dmeventd.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/tools/commands.c.diff?cvsroot=dm&r1=1.4&r2=1.5
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/tools/commands.h.diff?cvsroot=dm&r1=1.3&r2=1.4
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/tools/dmraid.c.diff?cvsroot=dm&r1=1.2&r2=1.3

--- dmraid/dmraid.spec	2009/11/02 13:20:40	1.9
+++ dmraid/dmraid.spec	2010/01/12 12:15:58	1.10
@@ -7,7 +7,7 @@
 Summary: dmraid (Device-mapper RAID tool and library)
 Name: dmraid
 Version: 1.0.0.rc16
-Release: 2%{?dist}
+Release: 3%{?dist}
 License: GPLv2+
 Group: System Environment/Base
 URL: http://people.redhat.com/heinzm/sw/dmraid
@@ -77,7 +77,7 @@
 
 %install
 rm -rf $RPM_BUILD_ROOT
-install -m 755 -d $RPM_BUILD_ROOT{%{_libdir},/sbin,%{_sbindir},%{_bindir},%{_libdir},%{_includedir}/dmraid/,/var/lock/dmraid,/etc/cron.d/,/etc/logwatch/conf/services/,/etc/logwatch/scripts/services/}
+install -m 755 -d $RPM_BUILD_ROOT{%{_libdir},/sbin,%{_sbindir},%{_bindir},%{_libdir},%{_includedir}/dmraid/,/var/lock/dmraid,/etc/cron.d/,/etc/logwatch/conf/services/,/etc/logwatch/scripts/services/,/var/cache/logwatch/dmeventd/}
 make DESTDIR=$RPM_BUILD_ROOT install
 ln -s dmraid $RPM_BUILD_ROOT/sbin/dmraid.static
 
@@ -99,7 +99,7 @@
 install -m 644 logwatch/dmeventd.conf $RPM_BUILD_ROOT/etc/logwatch/conf/services/dmeventd.conf
 install -m 755 logwatch/dmeventd $RPM_BUILD_ROOT/etc/logwatch/scripts/services/dmeventd
 install -m 644 logwatch/dmeventd_cronjob.txt $RPM_BUILD_ROOT/etc/cron.d/dmeventd-logwatch
-install -m 0700 /dev/null $RPM_BUILD_ROOT/etc/logwatch/scripts/services/dmeventd_syslogpattern.txt
+install -m 0700 /dev/null $RPM_BUILD_ROOT/var/cache/logwatch/dmeventd/syslogpattern.txt
 
 rm -f $RPM_BUILD_ROOT/%{_libdir}/libdmraid.a
 
@@ -136,9 +136,13 @@
 %defattr(-,root,root)
 %config(noreplace) /etc/logwatch/*
 %config(noreplace) /etc/cron.d/dmeventd-logwatch
-%ghost /etc/logwatch/scripts/services/dmeventd_syslogpattern.txt
+%dir /var/cache/logwatch/dmeventd
+%ghost /var/cache/logwatch/dmeventd/syslogpattern.txt
 
 %changelog
+* Tue Jan 12 2010  Heinz Mauelshagen <heinzm@redhat.com> - 1.0.0.rc16-3
+- Add logwatch files and move pattern file to /var/cache
+
 * Mon Nov 2 2009  Heinz Mauelshagen <heinzm@redhat.com> - 1.0.0.rc16-2
 - Fix manual path in specfile
 - fix manual pages for dmraid.static and dm_dso_reg_tool
--- dmraid/lib/format/ataraid/pdc.h	2009/11/18 10:04:09	1.5
+++ dmraid/lib/format/ataraid/pdc.h	2010/01/12 12:15:59	1.6
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ * Copyright (C) 2004-2010  Heinz Mauelshagen, Red Hat GmbH.
  *                          All rights reserved.
  *
  * See file LICENSE at the top of this source tree for license information.
--- dmraid/lib/metadata/metadata.c	2009/11/04 13:06:36	1.8
+++ dmraid/lib/metadata/metadata.c	2010/01/12 12:15:59	1.9
@@ -82,8 +82,8 @@
 	enum args args;		/* Arguments allowed ? */
 
 	/* Function to call on hit or NULL */
-	int (*f_set) (struct lib_context * lc, int arg);
-	int arg;		/* Argument for above function call */
+	int (*f_set) (struct lib_context * lc, struct actions *action);
+	int arg;		/* Argument for above function call. */
 };
 
 /*************************************/
--- dmraid/logwatch/dmeventd	2010/01/11 15:18:12	1.1
+++ dmraid/logwatch/dmeventd	2010/01/12 12:15:59	1.2
@@ -36,8 +36,7 @@
 # Set the location of the folder to store last time stamp
 # (This is used to record the last log sent out so repeats 
 #  are not mailed in error.)
-$syslogpattern_file =
-        "/etc/logwatch/scripts/services/dmeventd_syslogpattern.txt";
+$syslogpattern_file = "/var/cache/logwatch/dmeventd/syslogpattern.txt";
 
 if (-e $syslogpattern_file) {
 	open(FD, "+<", $syslogpattern_file) or die $!;        
--- dmraid/tools/commands.c	2009/09/16 11:45:18	1.4
+++ dmraid/tools/commands.c	2010/01/12 12:15:59	1.5
@@ -108,7 +108,7 @@
 
 /* Check activate/deactivate option arguments. */
 static int
-check_activate(struct lib_context *lc, int arg)
+check_activate(struct lib_context *lc, struct actions *a)
 {
 	struct optarg_def def[] = {
 		{ "yes", ACTIVATE},
@@ -122,7 +122,7 @@
 #ifndef	DMRAID_MINI
 /* Check active/inactive option arguments. */
 static int
-check_active(struct lib_context *lc, int arg)
+check_active(struct lib_context *lc, struct actions *a)
 {
 	struct optarg_def def[] = {
 		{ "active",   ACTIVE},
@@ -134,9 +134,8 @@
 	return check_optarg(lc, 's', def);
 }
 
-/* Check and store option arguments. */
-static int
-check_identifiers(struct lib_context *lc, int o)
+/* lc_inc_opt wrapper to allow for (struct actions) call interface. */
+static int _lc_inc_opt(struct lib_context *lc, struct actions *a)
 {
 	if (optarg) {
 		const char delim = *OPT_STR_SEPARATOR(lc);
@@ -144,17 +143,40 @@
 
 		p = remove_white_space(lc, p, strlen(p));
 		p = collapse_delimiter(lc, p, strlen(p), delim);
-		if (!lc_strcat_opt(lc, o, p, delim))
+
+		/* Hack to handle eg. "-cc". */
+		while (*p == a->option) {
+			lc_inc_opt(lc, a->arg);
+			p++;
+		}
+	}
+
+	lc_inc_opt(lc, a->arg);
+	return 1;
+}
+
+/* Check and store option arguments. */
+static int
+check_identifiers(struct lib_context *lc, struct actions *a)
+{
+	if (optarg) {
+		char *p = optarg;
+
+		_lc_inc_opt(lc, a);
+		p += lc_opt(lc, a->arg) - 1;
+		if (*p && !lc_strcat_opt(lc, a->arg, p, *OPT_STR_SEPARATOR(lc)))
 			return 0;
+
+		return 1;
 	}
 
-	lc_inc_opt(lc, o);
+	lc_inc_opt(lc, a->arg);
 	return 1;
 }
 
 /* Check and store option argument/output field separator. */
 static int
-check_separator(struct lib_context *lc, int arg)
+check_separator(struct lib_context *lc, struct actions *a)
 {
 	if (strlen(optarg) != 1)
 		LOG_ERR(lc, 0, "invalid separator \"%s\"", optarg);
@@ -164,7 +186,7 @@
 
 /* Check create option arguments. */
 static int
-check_create_argument(struct lib_context *lc, int arg)
+check_create_argument(struct lib_context *lc, struct actions *a)
 {
 	size_t len;
 
@@ -175,31 +197,32 @@
 	if (*optarg == '-')
 		LOG_ERR(lc, 0, "the raid set name is missing");
 
-	lc_inc_opt(lc, arg);
+	lc_inc_opt(lc, a->arg);
 	return 1;
 }
 
 /* 'Check' spare option argument. */
 static int
-check_spare_argument(struct lib_context *lc, int arg)
+check_spare_argument(struct lib_context *lc, struct actions *a)
 {
-	lc_inc_opt(lc, arg);
+	lc_inc_opt(lc, a->arg);
 	return 1;
 }
 #endif
 
 /* Check and store option for partition separator. */
 static int
-check_part_separator(struct lib_context *lc, int arg)
+check_part_separator(struct lib_context *lc, struct actions *a)
 {
 	/* We're not actually checking that it's only one character... if
 	   somebody wants to use more, it shouldn't hurt anything. */
 	return lc_stralloc_opt(lc, LC_PARTCHAR, optarg) ? 1 : 0;
 }
 
+
 /* Display help information */
 static int
-help(struct lib_context *lc, int arg)
+help(struct lib_context *lc, struct actions *a)
 {
 	char *c = lc->cmd;
 
@@ -342,7 +365,7 @@
 	 UNDEF,
 	 COLUMN | DBG | HELP | IGNORELOCKING | SEPARATOR | VERBOSE,
 	 ARGS,
-	 lc_inc_opt,
+	 _lc_inc_opt,
 	 LC_DEVICES,
 	 },
 
@@ -363,7 +386,7 @@
 	 ALL_FLAGS,
 	 ALL_FLAGS,
 	 ARGS,
-	 lc_inc_opt,
+	 _lc_inc_opt,
 	 LC_DEBUG,
 	 },
 
@@ -373,7 +396,7 @@
 	 RAID_DEVICES,
 	 COLUMN | DBG | FORMAT | HELP | IGNORELOCKING | SEPARATOR | VERBOSE,
 	 ARGS,
-	 lc_inc_opt,
+	 _lc_inc_opt,
 	 LC_DUMP,
 	 },
 
@@ -394,7 +417,7 @@
 	 ACTIVE | INACTIVE | DBG | COLUMN | FORMAT | HELP | IGNORELOCKING
 	 | SEPARATOR | VERBOSE,
 	 ARGS,
-	 lc_inc_opt,
+	 _lc_inc_opt,
 	 LC_GROUP,
 	 },
 
@@ -415,7 +438,7 @@
 	 UNDEF,
 	 ALL_FLAGS,
 	 ARGS,
-	 lc_inc_opt,
+	 _lc_inc_opt,
 	 LC_IGNORELOCKING,
 	 },
 
@@ -529,7 +552,7 @@
 	 ACTIVATE | DEACTIVATE | DBG | FORMAT | HELP | IGNORELOCKING |
 	 NOPARTITIONS | VERBOSE,
 	 ARGS,
-	 lc_inc_opt,
+	 _lc_inc_opt,
 	 LC_TEST,
 	 },
 
@@ -539,7 +562,7 @@
 	 ALL_FLAGS,
 	 ALL_FLAGS,
 	 ARGS,
-	 lc_inc_opt,
+	 _lc_inc_opt,
 	 LC_VERBOSE,
 	 },
 #endif /* #ifndef DMRAID_MINI */
@@ -602,7 +625,7 @@
 			a->allowed |= a->needed;
 
 			if (a->f_set)	/* Optionally call function. */
-				return a->f_set(lc, a->arg);
+				return a->f_set(lc, a);
 
 			break;
 		}
--- dmraid/tools/commands.h	2008/06/20 21:52:19	1.3
+++ dmraid/tools/commands.h	2010/01/12 12:15:59	1.4
@@ -33,8 +33,8 @@
 	enum args args;		/* Arguments allowed ? */
 
 	/* Function to call on hit or NULL */
-	int (*f_set) (struct lib_context * lc, int arg);
-	int arg;		/* Argument for above function call */
+	int (*f_set) (struct lib_context * lc, struct actions *action);
+	int arg;		/* Argument for above function call. */
 };
 
 int handle_args(struct lib_context *lc, int argc, char ***argv);
--- dmraid/tools/dmraid.c	2008/06/20 21:52:19	1.2
+++ dmraid/tools/dmraid.c	2010/01/12 12:15:59	1.3
@@ -33,7 +33,8 @@
 		 * If both are ok -> perform the required action.
 		 */
 		ret = handle_args(lc, argc, &argv) &&
-			init_locking(lc) && perform(lc, argv);
+		      init_locking(lc) &&
+		      perform(lc, argv);
 
 		/* Cleanup the library context. */
 		libdmraid_exit(lc);
