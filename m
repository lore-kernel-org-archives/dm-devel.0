From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] Only return the requested path checker
Date: Thu, 8 May 2008 12:26:10 -0500
Message-ID: <20080508172610.GL3145@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Fba/0zbH8Xs+Fj9o"
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@free.fr>, dm-devel@redhat.com
List-Id: dm-devel.ids


--Fba/0zbH8Xs+Fj9o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

checker_lookup() silently returns the default checker if the requested
one can't be loaded. Even worse, it the default checker can't be loaded,
it gets stuck in an infinite loop.

It seems to me that if the requested checker can't be loaded, we should
just throw an error. That's what this patch does.

-Ben

--Fba/0zbH8Xs+Fj9o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="no_recursive_lookup.patch"

Index: multipath-tools-temp/libmultipath/checkers.c
===================================================================
--- multipath-tools-temp.orig/libmultipath/checkers.c
+++ multipath-tools-temp/libmultipath/checkers.c
@@ -47,10 +47,7 @@ struct checker * checker_lookup (char * 
 		if (!strncmp(name, c->name, CHECKER_NAME_LEN))
 			return c;
 	}
-	c = add_checker(name);
-	if (c)
-		return c;
-	return checker_default();
+	return add_checker(name);
 }
 
 struct checker * add_checker (char * name)
@@ -179,6 +176,8 @@ struct checker * checker_default (void)
 
 void checker_get (struct checker * dst, struct checker * src)
 {
+	if (!src)
+		dst->check == NULL;
 	dst->fd = src->fd;
 	dst->sync = src->sync;
 	strncpy(dst->name, src->name, CHECKER_NAME_LEN);
Index: multipath-tools-temp/libmultipath/config.c
===================================================================
--- multipath-tools-temp.orig/libmultipath/config.c
+++ multipath-tools-temp/libmultipath/config.c
@@ -457,6 +457,8 @@ load_config (char * file)
 
 	if (!conf->checker)
 		conf->checker = checker_lookup(DEFAULT_CHECKER);
+	if (!conf->checker)
+		goto out;
 
 	return 0;
 out:
Index: multipath-tools-temp/libmultipath/dict.c
===================================================================
--- multipath-tools-temp.orig/libmultipath/dict.c
+++ multipath-tools-temp/libmultipath/dict.c
@@ -129,6 +129,8 @@ def_path_checker_handler(vector strvec)
 	
 	conf->checker = checker_lookup(buff);
 	FREE(buff);
+	if (!conf->checker)
+		return 1;
 
 	return 0;
 }
@@ -562,6 +564,8 @@ hw_path_checker_handler(vector strvec)
 	
 	hwe->checker = checker_lookup(buff);
 	FREE(buff);
+	if (!hwe->checker)
+		return 1;
 
 	return 0;
 }
Index: multipath-tools-temp/libmultipath/hwtable.c
===================================================================
--- multipath-tools-temp.orig/libmultipath/hwtable.c
+++ multipath-tools-temp/libmultipath/hwtable.c
@@ -733,6 +733,8 @@ setup_default_hwtable (vector hw)
 
 	while (hwe->vendor) {
 		hwe->checker = checker_lookup(hwe->checker_name);
+		if (!hwe->checker)
+			r++;
 		hwe->prio = prio_lookup(hwe->prio_name);
 		r += store_hwe(hw, hwe);
 		hwe++;

--Fba/0zbH8Xs+Fj9o
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--Fba/0zbH8Xs+Fj9o--
