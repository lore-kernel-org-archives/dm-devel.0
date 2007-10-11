From: bmarzins@sourceware.org
Subject: multipath-tools ./multipath.conf.annotated ./m ...
Date: 11 Oct 2007 20:17:18 -0000
Message-ID: <20071011201718.2650.qmail@sourceware.org>
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
To: dm-cvs@sourceware.org, dm-devel@redhat.com
List-Id: dm-devel.ids

CVSROOT:	/cvs/dm
Module name:	multipath-tools
Branch: 	RHEL4_FC5
Changes by:	bmarzins@sourceware.org	2007-10-11 20:17:17

Modified files:
	.              : multipath.conf.annotated 
	                 multipath.conf.defaults 
	libmultipath   : dict.c parser.c 

Log message:
	Fixes for bz303291 and bz320151.  multipath now ignores nonascii characters
	in /etc/multipath.conf.  There is also now a new multipath.conf option,
	bindings_file, which specifies the location of the user_friendly_names
	bindings file.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.annotated.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.16&r2=1.16.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.defaults.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.5.2.6&r2=1.5.2.7
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/dict.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.16.2.1&r2=1.16.2.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/parser.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.17&r2=1.17.2.1

--- multipath-tools/multipath.conf.annotated	2006/04/19 18:58:28	1.16
+++ multipath-tools/multipath.conf.annotated	2007/10/11 20:17:17	1.16.2.1
@@ -122,8 +122,8 @@
 #	#
 #	# name    : user_friendly_names
 #	# scope   : multipath
-#	# desc    : If set to "yes", using the bindings file
-#	#           /var/lib/multipath/bindings to assign a persistent and
+#	# desc    : If set to "yes", using the bindings file, by default
+#	#           /var/lib/multipath/bindings, to assign a persistent and
 #	#           unique alias to the multipath, in the form of mpath<n>.
 #	#           If set to "no" use the WWID as the alias. In either case
 #	#           this be will be overriden by any specific aliases in this
@@ -132,6 +132,15 @@
 #	# default : no
 #	user_friendly_names no
 #
+#	#
+#	# name    : bindings_file
+#	# scope   : multipath
+#	# desc    : The location of the bindings file that is used with
+#	#           the user_friendly_names option.
+#	# values  : <full_pathname>
+#	# default : "/var/lib/multipath/bindings"
+#	bindings_file "/etc/multipath_bindings"
+#
 #}
 #	
 ##
--- multipath-tools/multipath.conf.defaults	2007/09/11 18:06:01	1.5.2.6
+++ multipath-tools/multipath.conf.defaults	2007/10/11 20:17:17	1.5.2.7
@@ -14,6 +14,7 @@
 #	failback		immediate
 #	no_path_retry		fail
 #	user_friendly_names	no
+#	bindings_file		/var/lib/multipath/bindings
 #}
 #
 #blacklist {
--- multipath-tools/libmultipath/dict.c	2006/12/01 23:45:18	1.16.2.1
+++ multipath-tools/libmultipath/dict.c	2007/10/11 20:17:17	1.16.2.2
@@ -242,6 +242,17 @@
 	return 0;
 }
 
+static int
+bindings_file_handler(vector strvec)
+{
+	conf->bindings_file = set_value(strvec);
+
+	if (!conf->bindings_file)
+		return 1;
+
+	return 0;
+}
+
 /*
  * blacklist block handlers
  */
@@ -799,6 +810,7 @@
 	install_keyword("no_path_retry", &def_no_path_retry_handler);
 	install_keyword("pg_timeout", &default_pg_timeout_handler);
 	install_keyword("user_friendly_names", &names_handler);
+	install_keyword("bindings_file", &bindings_file_handler);
 
 	/*
 	 * deprecated synonyms
--- multipath-tools/libmultipath/parser.c	2005/10/12 21:57:26	1.17
+++ multipath-tools/libmultipath/parser.c	2007/10/11 20:17:17	1.17.2.1
@@ -2,7 +2,7 @@
  * Part:        Configuration file parser/reader. Place into the dynamic
  *              data structure representation the conf file
  *  
- * Version:     $Id: parser.c,v 1.17 2005/10/12 21:57:26 bmarzins Exp $
+ * Version:     $Id: parser.c,v 1.17.2.1 2007/10/11 20:17:17 bmarzins Exp $
  * 
  * Author:      Alexandre Cassen, <acassen@linux-vs.org>
  *              
@@ -119,7 +119,7 @@
 	cp = string;
 
 	/* Skip white spaces */
-	while (isspace((int) *cp) && *cp != '\0')
+	while ((isspace((int) *cp) || !isascii((int) *cp)) && *cp != '\0')
 		cp++;
 
 	/* Return if there is only white spaces */
@@ -171,7 +171,8 @@
 		}
 		vector_set_slot(strvec, token);
 
-		while (isspace((int) *cp) && *cp != '\0')
+		while ((isspace((int) *cp) || !isascii((int) *cp))
+		       && *cp != '\0')
 			cp++;
 		if (*cp == '\0' || *cp == '!' || *cp == '#')
 			return strvec;
