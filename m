From: heinzm@sourceware.org
Subject: dmraid include/dmraid/lib_context.h lib/activa ...
Date: 18 Mar 2010 13:10:45 -0000
Message-ID: <20100318131045.3057.qmail@sourceware.org>
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
Changes by:	heinzm@sourceware.org	2010-03-18 13:10:43

Modified files:
	include/dmraid : lib_context.h 
	lib/activate   : activate.c 
	lib/format/ataraid: isw.c jm.c 
	lib/register   : dmreg.c 
	tools          : commands.c 

Log message:
	Support --ignoremonitoring option to prohibit any dmeventd action, eg. allowing to disable monitoring in early boot with dynamic dmraid binary

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/include/dmraid/lib_context.h.diff?cvsroot=dm&r1=1.4&r2=1.5
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/activate/activate.c.diff?cvsroot=dm&r1=1.6&r2=1.7
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/isw.c.diff?cvsroot=dm&r1=1.7&r2=1.8
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/jm.c.diff?cvsroot=dm&r1=1.5&r2=1.6
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/register/dmreg.c.diff?cvsroot=dm&r1=1.2&r2=1.3
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/tools/commands.c.diff?cvsroot=dm&r1=1.6&r2=1.7

--- dmraid/include/dmraid/lib_context.h	2009/09/16 11:45:12	1.4
+++ dmraid/include/dmraid/lib_context.h	2010/03/18 13:10:42	1.5
@@ -46,7 +46,8 @@
 	LC_CREATE,
 	LC_REBUILD_SET,
 	LC_REBUILD_DISK,
-	LC_HOT_SPARE_SET,	/* Add new options below this one ! */
+	LC_HOT_SPARE_SET,
+	LC_IGNOREMONITORING,	/* Add new options below this one ! */
 	LC_OPTIONS_SIZE,	/* Must be the last enumerator. */
 };
 
@@ -65,8 +66,9 @@
 #define	OPT_VERBOSE(lc)		(lc_opt(lc, LC_VERBOSE))
 #define	OPT_PARTCHAR(lc)	(lc_opt(lc, LC_PARTCHAR))
 #define	OPT_CREATE(lc)		(lc_opt(lc, LC_CREATE))
-#define OPT_HOT_SPARE_SET(lc)	(lc_opt(lc, LC_HOT_SPARE_SET))
 #define OPT_REBUILD_DISK(lc)	(lc_opt(lc, LC_REBUILD_DISK))
+#define OPT_HOT_SPARE_SET(lc)	(lc_opt(lc, LC_HOT_SPARE_SET))
+#define OPT_IGNOREMONITORING(lc) (lc_opt(lc, LC_IGNOREMONITORING))
 
 /* Return option value. */
 #define	OPT_STR(lc, o)		(lc->options[o].arg.str)
@@ -170,6 +172,9 @@
 
 #endif
 	RMPARTITIONS = 0x40000000,
+#ifndef DMRAID_MINI
+	IGNOREMONITORING = 0x80000000,
+#endif
 };
 
 /* Arguments allowed ? */
--- dmraid/lib/activate/activate.c	2009/12/07 16:05:46	1.6
+++ dmraid/lib/activate/activate.c	2010/03/18 13:10:42	1.7
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2004-2008  Heinz Mauelshagen, Red Hat GmbH.
+ * Copyright (C) 2004-2010  Heinz Mauelshagen, Red Hat GmbH.
  *                          All rights reserved.
  *
  * Copyright (C) 2007,2009   Intel Corporation. All rights reserved.
@@ -845,23 +845,17 @@
 enum dm_what { DM_ACTIVATE, DM_REGISTER };
 
 /* Register devices of the RAID set with the dmeventd. */
-#define	ALL_EVENTS 0xffffffff
+#ifdef	DMRAID_AUTOREGISTER
 static int
 dm_register_for_event(char *dev_name, char *lib_name)
 {
-#ifdef	DMRAID_AUTOREGISTER
-	dm_register_device(dev_name, lib_name);
-#endif
-	return 1;
+	return !dm_register_device(dev_name, lib_name);
 }
 
 static int
 dm_unregister_for_event(char *dev_name, char *lib_name)
 {
-#ifdef	DMRAID_AUTOREGISTER
-	dm_unregister_device(dev_name, lib_name);
-#endif
-	return 1;
+	return !dm_unregister_device(dev_name, lib_name);
 }
 
 #define LIB_NAME_LENGTH 255
@@ -870,35 +864,34 @@
 {
 	int ret = 0;
 	char lib_name[LIB_NAME_LENGTH];
+        struct dmraid_format *fmt;
 
 	if (OPT_TEST(lc))
 		return 1;
 
-        struct dmraid_format *fmt = get_format(rs);
-
-        if (fmt->name != NULL) {
-                strncpy(lib_name, "libdmraid-events-",LIB_NAME_LENGTH);
-                strncat(lib_name, fmt->name, LIB_NAME_LENGTH-strlen(fmt->name)-3);
-                strncat(lib_name, ".so", 3);
-
-                ret = f(rs->name, lib_name);
+	fmt = get_format(rs);
+	if (fmt->name) {
+		snprintf(lib_name, sizeof(lib_name), "libdmraid-events-%s.so",
+			 fmt->name);
+		ret = f(rs->name, lib_name);
         }
 
-	return ret ? 1 : 0;
+	return ret;
 }
 
 static int
-register_devices(struct lib_context *lc, struct raid_set *rs)
+register_device(struct lib_context *lc, struct raid_set *rs)
 {
 	return do_device(lc, rs, dm_register_for_event);
 }
 
 /* Unregister devices of the RAID set with the dmeventd. */
 static int
-unregister_devices(struct lib_context *lc, struct raid_set *rs)
+unregister_device(struct lib_context *lc, struct raid_set *rs)
 {
 	return do_device(lc, rs, dm_unregister_for_event);
 }
+#endif /* #ifdef	DMRAID_AUTOREGISTER */
 
 /* Reload a single set. */
 static int
@@ -940,14 +933,6 @@
 {
 	struct raid_set *r;
 
-	/* FIXME: Does it matter if the set is (in)active? */
-#if 0
-	if (!OPT_TEST(lc) && what == DM_ACTIVATE && dm_status(lc, rs)) {
-		log_print(lc, "RAID set \"%s\" already active", rs->name);
-		return 1;
-	}
-#endif
-
 	/* Recursively walk down the chain of stacked RAID sets */
 	list_for_each_entry(r, &rs->sets, list) {
 		/* Activate set below this one */
@@ -969,12 +954,16 @@
 	if (T_GROUP(rs))
 		return 1;
 
-	if (what == DM_REGISTER &&
-	    fmt->metadata_handler)
-		return register_devices(lc, rs);
+	if (what == DM_REGISTER)
+#ifdef	DMRAID_AUTOREGISTER
+		return (!OPT_IGNOREMONITORING(lc) && fmt->metadata_handler) ?
+		       register_device(lc, rs) : 1;
+#else
+		return 1;
+#endif
 
 	/* Call type handler */
-	if ((ret = (handler(rs))->f(lc, &table, rs))) {
+	if ((ret = handler(rs)->f(lc, &table, rs))) {
 		if (OPT_TEST(lc))
 			display_table(lc, rs->name, table);
 		else if ((ret = dm_create(lc, rs, table, rs->name)))
@@ -1057,9 +1046,14 @@
 	int ret = 1, status;
 	struct dmraid_format *fmt = get_format(rs);
 
-	if (what == DM_REGISTER &&
-	    fmt->metadata_handler)
-		return unregister_devices(lc, rs);
+	if (what == DM_REGISTER) {
+#ifdef	DMRAID_AUTOREGISTER
+		return (!OPT_IGNOREMONITORING(lc) && fmt->metadata_handler) ?
+			unregister_device(lc, rs) : 1;
+#else
+		return 1;
+#endif
+	}
 
 	status = dm_status(lc, rs);
 	if (OPT_TEST(lc))
--- dmraid/lib/format/ataraid/isw.c	2010/03/12 11:33:01	1.7
+++ dmraid/lib/format/ataraid/isw.c	2010/03/18 13:10:42	1.8
@@ -193,7 +193,7 @@
 	n = snprintf(str, len, f->fmt, isw->family_num, f->what, num);
 
 	/* As '->volume' could contain anything, we sanitise the name. */
-	if (n > 0)
+	if (str && n > 0)
 		mk_alphanum(lc, str, n);
 
 	return n;
--- dmraid/lib/format/ataraid/jm.c	2009/09/17 09:21:07	1.5
+++ dmraid/lib/format/ataraid/jm.c	2010/03/18 13:10:42	1.6
@@ -32,6 +32,7 @@
 
 	/* Sanitize name, make sure it's null terminated */
 	strncpy(buf, name, JM_NAME_LEN);
+	i = strlen(buf);
 	while (i && isspace(buf[i])) {
 		name[i]='\0';
 		buf[i]='\0';
--- dmraid/lib/register/dmreg.c	2010/03/02 15:27:38	1.2
+++ dmraid/lib/register/dmreg.c	2010/03/18 13:10:43	1.3
@@ -441,7 +441,7 @@
 
 	errors = _dm_raid_state(dev_name);
 	if (errors < 0)
-		return 1;
+		return 0;
 
 	if (errors) {
 		printf("ERROR: device \"%s\" \n"
--- dmraid/tools/commands.c	2010/01/12 12:21:10	1.6
+++ dmraid/tools/commands.c	2010/03/18 13:10:43	1.7
@@ -32,7 +32,7 @@
  */
 static char const *short_opts = "a:hipP:"
 #ifndef	DMRAID_MINI
-	"bc::dDEf:glxM:"
+	"bc::dDEf:gIlxM:"
 #ifdef	DMRAID_NATIVE_LOG
 	"n"
 #endif
@@ -74,6 +74,7 @@
 	{"create", required_argument, NULL, 'C'},
 	{"spare", optional_argument, NULL, 'S'},
 	{"rm_partitions", no_argument, NULL, 'Z'},
+	{"ignoremonitoring", no_argument, NULL, 'I'},
 	{NULL, no_argument, NULL, 0}
 };
 #endif /* #ifdef HAVE_GETOPTLONG */
@@ -229,8 +230,8 @@
 #ifdef	DMRAID_MINI
 	log_print(lc, "%s: Device-Mapper Software RAID tool "
 		  "[Early Boot Version]\n", c);
-	log_print(lc, "%s\t{-a|--activate} {y|n|yes|no} [-i|--ignorelocking]\n"
-		  "\t[-f|--format FORMAT[,FORMAT...]]\n"
+	log_print(lc, "%s\t{-a|--activate} {y|n|yes|no} [-i|--ignorelocking]\n" 
+		  "\t[-f|--format fORMAT[,FORMAT...]]\n"
 		  "\t[-P|--partchar CHAR]\n"
 		  "\t[-p|--no_partitions]\n"
 		  "\t[-Z|--rm_partitions]\n"
@@ -244,6 +245,7 @@
 	log_print(lc,
 		  "%s\t{-a|--activate} {y|n|yes|no} *\n"
 		  "\t[-f|--format FORMAT[,FORMAT...]]\n"
+		  "\t[-I|--ignoremonitoring]\n"
 		  "\t[-P|--partchar CHAR]\n" "\t[-p|--no_partitions]\n"
 		  "\t[--separator SEPARATOR]\n" "\t[-t|--test]\n"
 		  "\t[-Z|--rm_partitions] [RAID-set...]\n", c);
@@ -301,7 +303,7 @@
 	 ACTIVATE | DEACTIVATE | FORMAT | HELP | IGNORELOCKING | NOPARTITIONS |
 	 SEPARATOR | RMPARTITIONS
 #ifndef DMRAID_MINI
-	 | DBG | TEST | VERBOSE
+	 | DBG | TEST | VERBOSE | IGNOREMONITORING
 #endif
 	 , ARGS,
 	 check_activate,
@@ -311,15 +313,15 @@
 	/* Format option. */
 	{'f',
 	 FORMAT,
-	 ACTIVATE | DEACTIVATE
+	 ACTIVATE | DEACTIVATE | IGNORELOCKING
 #ifndef DMRAID_MINI
 #  ifdef DMRAID_NATIVE_LOG
 	 | NATIVE_LOG
 #  endif
 	 | RAID_DEVICES | RAID_SETS,
 	 ACTIVE | INACTIVE | COLUMN | DBG | DUMP | DMERASE | GROUP | HELP |
-	 IGNORELOCKING | NOPARTITIONS | SEPARATOR | TEST | VERBOSE |
-	 RMPARTITIONS
+	 NOPARTITIONS | SEPARATOR | TEST | VERBOSE | RMPARTITIONS |
+	 IGNOREMONITORING
 #else
 	 , UNDEF
 #endif
@@ -338,7 +340,7 @@
 	 ACTIVATE | DEACTIVATE,
 	 FORMAT | HELP | IGNORELOCKING | SEPARATOR | RMPARTITIONS
 #ifndef DMRAID_MINI
-	 | DBG | TEST | VERBOSE
+	 | DBG | TEST | VERBOSE | IGNOREMONITORING
 #endif
 	 , ARGS,
 	 check_part_separator,
@@ -351,7 +353,7 @@
 	 ACTIVATE | DEACTIVATE,
 	 FORMAT | HELP | IGNORELOCKING | SEPARATOR | RMPARTITIONS
 #ifndef DMRAID_MINI
-	 | DBG | TEST | VERBOSE
+	 | DBG | TEST | VERBOSE | IGNOREMONITORING
 #endif
 	 , ARGS,
 	 NULL,
@@ -608,6 +610,18 @@
 	 NULL,
 	 0,
 	 },
+#ifndef DMRAID_MINI
+	/* ignoremonitoring option. */
+	{'I',
+	 IGNOREMONITORING,
+	 ACTIVATE | DEACTIVATE,
+	 DBG | FORMAT | HELP | IGNORELOCKING | NOPARTITIONS | VERBOSE |
+	 SEPARATOR,
+	 ARGS,
+	 _lc_inc_opt,
+	 LC_IGNOREMONITORING,
+	 },
+#endif
 };
 
 /*
