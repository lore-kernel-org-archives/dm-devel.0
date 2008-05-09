From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] Try 2: Better path checker handling
Date: Fri, 9 May 2008 17:45:13 -0500
Message-ID: <20080509224512.GN3145@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="96YOpH+ONegL0A3E"
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


--96YOpH+ONegL0A3E
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The problem with my last patch, aside from a typeo, is this; While the
patch kept you from silently using the default checker instead of the
desired one, if you failed to load a checker (say while setting up the
default hardware configuration), multipath would fail out, even if your
devices never would need that checker.

Another problem that the original patch didn't fix was that
multipath.conf should be order independent, and with the existing
checker code, it isn't.  The multipath_dir had to be set before
you could set a checker, otherwise the checker load failed (since the
multipath_dir wasn't specified).

This new patch delays loading the checker libraries until a device
actually needs them. It replaces the previous patch and applies directly
on top of the upstream code.

-Ben

--96YOpH+ONegL0A3E
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="move_checker_load.patch"

Index: multipath-tools-test/libmultipath/checkers.c
===================================================================
--- multipath-tools-test.orig/libmultipath/checkers.c
+++ multipath-tools-test/libmultipath/checkers.c
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
@@ -172,13 +169,14 @@ char * checker_message (struct checker *
 	return c->message;
 }
 
-struct checker * checker_default (void)
+void checker_get (struct checker * dst, char * name)
 {
-	return checker_lookup(DEFAULT_CHECKER);
-}
+	struct checker * src = checker_lookup(name);
 
-void checker_get (struct checker * dst, struct checker * src)
-{
+	if (!src) {
+		dst->check = NULL;
+		return;
+	}
 	dst->fd = src->fd;
 	dst->sync = src->sync;
 	strncpy(dst->name, src->name, CHECKER_NAME_LEN);
Index: multipath-tools-test/libmultipath/config.c
===================================================================
--- multipath-tools-test.orig/libmultipath/config.c
+++ multipath-tools-test/libmultipath/config.c
@@ -270,13 +270,15 @@ store_hwe (vector hwtable, struct hwentr
 
 	if (dhwe->selector && !(hwe->selector = set_param_str(dhwe->selector)))
 		goto out;
+
+	if (dhwe->checker_name && !(hwe->checker_name = set_param_str(dhwe->checker_name)))
+		goto out;
 				
 	hwe->pgpolicy = dhwe->pgpolicy;
 	hwe->pgfailback = dhwe->pgfailback;
 	hwe->rr_weight = dhwe->rr_weight;
 	hwe->no_path_retry = dhwe->no_path_retry;
 	hwe->minio = dhwe->minio;
-	hwe->checker = dhwe->checker;
 	hwe->prio = dhwe->prio;
 
 	if (dhwe->bl_product && !(hwe->bl_product = set_param_str(dhwe->bl_product)))
@@ -455,8 +457,8 @@ load_config (char * file)
 	if (!conf->prio)
 		conf->prio = prio_default();
 
-	if (!conf->checker)
-		conf->checker = checker_lookup(DEFAULT_CHECKER);
+	if (!conf->checker_name)
+		conf->checker_name = set_default(DEFAULT_CHECKER);
 
 	return 0;
 out:
Index: multipath-tools-test/libmultipath/dict.c
===================================================================
--- multipath-tools-test.orig/libmultipath/dict.c
+++ multipath-tools-test/libmultipath/dict.c
@@ -120,16 +120,11 @@ def_features_handler(vector strvec)
 static int
 def_path_checker_handler(vector strvec)
 {
-	char * buff;
-
-	buff = set_value(strvec);
+	conf->checker_name = set_value(strvec);
 
-	if (!buff)
+	if (!conf->checker_name)
 		return 1;
 	
-	conf->checker = checker_lookup(buff);
-	FREE(buff);
-
 	return 0;
 }
 
@@ -549,20 +544,16 @@ hw_selector_handler(vector strvec)
 static int
 hw_path_checker_handler(vector strvec)
 {
-	char * buff;
 	struct hwentry * hwe = VECTOR_LAST_SLOT(conf->hwtable);
 
 	if (!hwe)
 		return 1;
 
-	buff = set_value(strvec);
+	hwe->checker_name = set_value(strvec);
 
-	if (!buff)
+	if (!hwe->checker_name)
 		return 1;
 	
-	hwe->checker = checker_lookup(buff);
-	FREE(buff);
-
 	return 0;
 }
 
@@ -1312,14 +1303,12 @@ snprint_hw_path_checker (char * buff, in
 {
 	struct hwentry * hwe = (struct hwentry *)data;
 
-	if (!hwe->checker)
-		return 0;
-	if (!checker_selected(hwe->checker))
+	if (!hwe->checker_name)
 		return 0;
-	if (hwe->checker == conf->checker)
+	if (!strcmp(hwe->checker_name, conf->checker_name))
 		return 0;
 	
-	return snprintf(buff, len, "%s", checker_name(hwe->checker));
+	return snprintf(buff, len, "%s", hwe->checker_name);
 }
 
 static int
@@ -1417,12 +1406,12 @@ snprint_def_features (char * buff, int l
 static int
 snprint_def_path_checker (char * buff, int len, void * data)
 {
-	if (!conf->checker)
+	if (!conf->checker_name)
 		return 0;
-	if (conf->checker == checker_default())
+	if (conf->checker_name == DEFAULT_CHECKER)
 		return 0;
 	
-	return snprintf(buff, len, "%s", checker_name(conf->checker));
+	return snprintf(buff, len, "%s", conf->checker_name);
 }
 
 static int
Index: multipath-tools-test/libmultipath/hwtable.c
===================================================================
--- multipath-tools-test.orig/libmultipath/hwtable.c
+++ multipath-tools-test/libmultipath/hwtable.c
@@ -732,7 +732,6 @@ setup_default_hwtable (vector hw)
 	struct hwentry * hwe = default_hw;
 
 	while (hwe->vendor) {
-		hwe->checker = checker_lookup(hwe->checker_name);
 		hwe->prio = prio_lookup(hwe->prio_name);
 		r += store_hwe(hw, hwe);
 		hwe++;
Index: multipath-tools-test/libmultipath/checkers.h
===================================================================
--- multipath-tools-test.orig/libmultipath/checkers.h
+++ multipath-tools-test/libmultipath/checkers.h
@@ -117,12 +117,10 @@ void checker_set_async (struct checker *
 void checker_set_fd (struct checker *, int);
 void checker_enable (struct checker *);
 void checker_disable (struct checker *);
-struct checker * checker_lookup (char *);
 int checker_check (struct checker *);
 int checker_selected (struct checker *);
 char * checker_name (struct checker *);
 char * checker_message (struct checker *);
-struct checker * checker_default (void);
-void checker_get (struct checker *, struct checker *);
+void checker_get (struct checker *, char *);
 
 #endif /* _CHECKERS_H */
Index: multipath-tools-test/libmultipath/config.h
===================================================================
--- multipath-tools-test.orig/libmultipath/config.h
+++ multipath-tools-test/libmultipath/config.h
@@ -29,7 +29,6 @@ struct hwentry {
 	int minio;
 	int pg_timeout;
 	struct prio * prio;
-	struct checker * checker;
 	char * bl_product;
 };
 
@@ -55,7 +54,6 @@ struct config {
 	int with_sysfs;
 	int pgpolicy;
 	struct prio * prio;
-	struct checker * checker;
 	enum devtypes dev_type;
 	int minio;
 	int checkint;
@@ -77,6 +75,7 @@ struct config {
 	char * features;
 	char * hwhandler;
 	char * bindings_file;
+	char * checker_name;
 
 	vector keywords;
 	vector mptable;
Index: multipath-tools-test/libmultipath/propsel.c
===================================================================
--- multipath-tools-test.orig/libmultipath/propsel.c
+++ multipath-tools-test/libmultipath/propsel.c
@@ -217,19 +217,19 @@ select_checker(struct path *pp)
 {
 	struct checker * c = &pp->checker;
 
-	if (pp->hwe && pp->hwe->checker) {
-		checker_get(c, pp->hwe->checker);
+	if (pp->hwe && pp->hwe->checker_name) {
+		checker_get(c, pp->hwe->checker_name);
 		condlog(3, "%s: path checker = %s (controller setting)",
 			pp->dev, checker_name(c));
 		return 0;
 	}
-	if (conf->checker) {
-		checker_get(c, conf->checker);
+	if (conf->checker_name) {
+		checker_get(c, conf->checker_name);
 		condlog(3, "%s: path checker = %s (config file default)",
 			pp->dev, checker_name(c));
 		return 0;
 	}
-	checker_get(c, checker_default());
+	checker_get(c, DEFAULT_CHECKER);
 	condlog(3, "%s: path checker = %s (internal default)",
 		pp->dev, checker_name(c));
 	return 0;

--96YOpH+ONegL0A3E
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--96YOpH+ONegL0A3E--
