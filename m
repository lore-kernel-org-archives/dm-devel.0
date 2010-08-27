From: bmarzins@sourceware.org
Subject: multipath-tools/libmultipath dict.c parser.c p ...
Date: 27 Aug 2010 21:02:08 -0000
Message-ID: <20100827210208.16197.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2010-08-27 21:02:08

Modified files:
	libmultipath   : dict.c parser.c parser.h 

Log message:
	Fix for bz #560892.  multipath now prints some warnings if it notices problems
	with /etc/multipath.conf.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/dict.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.17.2.12&r2=1.17.2.13
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/parser.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.18.2.1&r2=1.18.2.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/parser.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.18&r2=1.18.2.1

--- multipath-tools/libmultipath/dict.c	2010/01/27 16:46:48	1.17.2.12
+++ multipath-tools/libmultipath/dict.c	2010/08/27 21:02:07	1.17.2.13
@@ -2048,17 +2048,17 @@
 	__deprecated install_keyword("default_path_checker", &def_path_checker_handler, NULL);
 
 	install_keyword_root("blacklist", &blacklist_handler);
-	install_keyword("devnode", &ble_devnode_handler, &snprint_ble_simple);
-	install_keyword("wwid", &ble_wwid_handler, &snprint_ble_simple);
-	install_keyword("device", &ble_device_handler, NULL);
+	install_keyword_multi("devnode", &ble_devnode_handler, &snprint_ble_simple);
+	install_keyword_multi("wwid", &ble_wwid_handler, &snprint_ble_simple);
+	install_keyword_multi("device", &ble_device_handler, NULL);
 	install_sublevel();
 	install_keyword("vendor", &ble_vendor_handler, &snprint_bled_vendor);
 	install_keyword("product", &ble_product_handler, &snprint_bled_product);
 	install_sublevel_end();
 	install_keyword_root("blacklist_exceptions", &blacklist_exceptions_handler);
-	install_keyword("devnode", &ble_except_devnode_handler, &snprint_ble_simple);
-	install_keyword("wwid", &ble_except_wwid_handler, &snprint_ble_simple);
-	install_keyword("device", &ble_except_device_handler, NULL);
+	install_keyword_multi("devnode", &ble_except_devnode_handler, &snprint_ble_simple);
+	install_keyword_multi("wwid", &ble_except_wwid_handler, &snprint_ble_simple);
+	install_keyword_multi("device", &ble_except_device_handler, NULL);
 	install_sublevel();
 	install_keyword("vendor", &ble_except_vendor_handler, &snprint_bled_vendor);
 	install_keyword("product", &ble_except_product_handler, &snprint_bled_product);
@@ -2076,7 +2076,7 @@
 #endif
 
 	install_keyword_root("devices", &devices_handler);
-	install_keyword("device", &device_handler, NULL);
+	install_keyword_multi("device", &device_handler, NULL);
 	install_sublevel();
 	install_keyword("vendor", &vendor_handler, &snprint_hw_vendor);
 	install_keyword("product", &product_handler, &snprint_hw_product);
@@ -2097,7 +2097,7 @@
 	install_sublevel_end();
 
 	install_keyword_root("multipaths", &multipaths_handler);
-	install_keyword("multipath", &multipath_handler, NULL);
+	install_keyword_multi("multipath", &multipath_handler, NULL);
 	install_sublevel();
 	install_keyword("wwid", &wwid_handler, &snprint_mp_wwid);
 	install_keyword("alias", &alias_handler, &snprint_mp_alias);
--- multipath-tools/libmultipath/parser.c	2007/12/07 23:57:03	1.18.2.1
+++ multipath-tools/libmultipath/parser.c	2010/08/27 21:02:08	1.18.2.2
@@ -2,7 +2,7 @@
  * Part:        Configuration file parser/reader. Place into the dynamic
  *              data structure representation the conf file
  *  
- * Version:     $Id: parser.c,v 1.18.2.1 2007/12/07 23:57:03 bmarzins Exp $
+ * Version:     $Id: parser.c,v 1.18.2.2 2010/08/27 21:02:08 bmarzins Exp $
  * 
  * Author:      Alexandre Cassen, <acassen@linux-vs.org>
  *              
@@ -21,11 +21,13 @@
 
 #include "parser.h"
 #include "memory.h"
+#include "debug.h"
 
 /* local vars */
 static int sublevel = 0;
 vector keywords = NULL;
 vector *keywords_addr = NULL;
+static int line_nr;
 
 void set_current_keywords (vector *k)
 {
@@ -35,7 +37,7 @@
 
 int
 keyword_alloc(vector keywords, char *string, int (*handler) (vector),
-		int (*print) (char *, int, void *))
+		int (*print) (char *, int, void *), int unique)
 {
 	struct keyword *keyword;
 
@@ -51,6 +53,7 @@
 	keyword->string = string;
 	keyword->handler = handler;
 	keyword->print = print;
+	keyword->unique = unique;
 
 	vector_set_slot(keywords, keyword);
 
@@ -60,7 +63,7 @@
 int
 install_keyword_root(char *string, int (*handler) (vector))
 {
-	int r = keyword_alloc(keywords, string, handler, NULL);
+	int r = keyword_alloc(keywords, string, handler, NULL, 1);
 	if (!r)
 		*keywords_addr = keywords;
 	return r;
@@ -79,8 +82,8 @@
 }
 
 int
-install_keyword(char *string, int (*handler) (vector),
-		int (*print) (char *, int, void *))
+_install_keyword(char *string, int (*handler) (vector),
+		int (*print) (char *, int, void *), int unique)
 {
 	int i = 0;
 	struct keyword *keyword;
@@ -101,7 +104,7 @@
 		return 1;
 
 	/* add new sub keyword */
-	return keyword_alloc(keyword->sub, string, handler, print);
+	return keyword_alloc(keyword->sub, string, handler, print, unique);
 }
 
 void
@@ -406,6 +409,39 @@
 
 /* non-recursive configuration stream handler */
 static int kw_level = 0;
+
+int warn_on_duplicates(vector uniques, char *str)
+{
+	char *tmp;
+	int i;
+
+	vector_foreach_slot(uniques, tmp, i) {
+		if (!strcmp(str, tmp)) {
+			condlog(1, "multipath.conf line %d, duplicate keyword: %s", line_nr, str);
+			return 0;
+		}
+	}
+	tmp = strdup(str);
+	if (!tmp)
+		return 1;
+	if (!vector_alloc_slot(uniques)) {
+		free(tmp);
+		return 1;
+	}
+	vector_set_slot(uniques, tmp);
+	return 0;
+}
+
+void free_uniques(vector uniques)
+{
+	char *tmp;
+	int i;
+
+	vector_foreach_slot(uniques, tmp, i)
+		free(tmp);
+	vector_free(uniques);
+}
+
 int
 process_stream(vector keywords)
 {
@@ -415,13 +451,21 @@
 	char *str;
 	char *buf;
 	vector strvec;
+	vector uniques;
+
+	uniques = vector_alloc();
+	if (!uniques)
+		return 1;
 
 	buf = MALLOC(MAXBUF);
 
-	if (!buf)
+	if (!buf) {
+		vector_free(uniques);
 		return 1;
+	}
 
 	while (read_line(buf, MAXBUF)) {
+		line_nr++;
 		strvec = alloc_strvec(buf);
 		memset(buf,0, MAXBUF);
 
@@ -439,6 +483,12 @@
 			keyword = VECTOR_SLOT(keywords, i);
 
 			if (!strcmp(keyword->string, str)) {
+				if (keyword->unique &&
+				    warn_on_duplicates(uniques, str)) {
+						r = 1;
+						free_strvec(strvec);
+						goto out;
+				}
 				if (keyword->handler)
 					r += (*keyword->handler) (strvec);
 
@@ -450,11 +500,16 @@
 				break;
 			}
 		}
+		if (i >= VECTOR_SIZE(keywords))
+			condlog(1, "mulipath.conf line %d, invalid keyword: %s",
+				line_nr, str);
 		
 		free_strvec(strvec);
 	}
 
+out:
 	FREE(buf);
+	free_uniques(uniques);
 	return r;
 }
 
@@ -483,6 +538,7 @@
 */
 
 	/* Stream handling */
+	line_nr = 0;
 	r = process_stream(keywords);
 	fclose(stream);
 	//free_keywords(keywords);
--- multipath-tools/libmultipath/parser.h	2006/06/06 18:32:43	1.18
+++ multipath-tools/libmultipath/parser.h	2010/08/27 21:02:08	1.18.2.1
@@ -5,7 +5,7 @@
  * 
  * Part:        cfreader.c include file.
  *  
- * Version:     $Id: parser.h,v 1.18 2006/06/06 18:32:43 bmarzins Exp $
+ * Version:     $Id: parser.h,v 1.18.2.1 2010/08/27 21:02:08 bmarzins Exp $
  *
  * Author:      Alexandre Cassen, <acassen@linux-vs.org>
  *
@@ -44,6 +44,7 @@
 	int (*handler) (vector);
 	int (*print) (char *, int, void *);
 	vector sub;
+	int unique;
 };
 
 /* global var exported */
@@ -60,12 +61,14 @@
 
 /* Prototypes */
 extern int keyword_alloc(vector keywords, char *string, int (*handler) (vector),
-			 int (*print) (char *, int, void *));
+			 int (*print) (char *, int, void *), int unique);
 extern int install_keyword_root(char *string, int (*handler) (vector));
 extern void install_sublevel(void);
 extern void install_sublevel_end(void);
-extern int install_keyword(char *string, int (*handler) (vector),
-			   int (*print) (char *, int, void *));
+extern int _install_keyword(char *string, int (*handler) (vector),
+			    int (*print) (char *, int, void *), int unique);
+#define install_keyword(str, vec, pri) _install_keyword(str, vec, pri, 1)
+#define install_keyword_multi(str, vec, pri) _install_keyword(str, vec, pri, 0)
 extern void dump_keywords(vector keydump, int level);
 extern void free_keywords(vector keywords);
 extern vector alloc_strvec(char *string);
