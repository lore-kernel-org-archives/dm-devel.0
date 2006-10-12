From: bmarzins@sourceware.org
Subject: multipath-tools kpartx/Makefile libmultipath/d ...
Date: 12 Oct 2006 16:16:11 -0000
Message-ID: <20061012161611.30781.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2006-10-12 16:16:10

Modified files:
	kpartx         : Makefile 
	libmultipath   : discovery.c discovery.h hwtable.c 
	multipath      : Makefile 
	multipathd     : main.c 
Added files:
	multipath      : mpath_faker.c 

Log message:
	This makes multipath and gnbd work together.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/kpartx/Makefile.diff?cvsroot=dm&r1=1.7&r2=1.8
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/discovery.c.diff?cvsroot=dm&r1=1.31&r2=1.32
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/discovery.h.diff?cvsroot=dm&r1=1.13&r2=1.14
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/hwtable.c.diff?cvsroot=dm&r1=1.19&r2=1.20
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath/mpath_faker.c.diff?cvsroot=dm&r1=1.7&r2=1.8
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath/Makefile.diff?cvsroot=dm&r1=1.15&r2=1.16
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/main.c.diff?cvsroot=dm&r1=1.68&r2=1.69

--- multipath-tools/kpartx/Makefile	2006/06/06 20:38:51	1.7
+++ multipath-tools/kpartx/Makefile	2006/10/12 16:16:09	1.8
@@ -46,4 +46,4 @@
 	rm -f $(DESTDIR)$(mandir)/$(EXEC).8
 
 clean:
-	rm -f core *.o $(EXEC) *.gz
+	rm -f core *.o $(EXEC) $(EXEC).static *.gz
--- multipath-tools/libmultipath/discovery.c	2006/10/06 18:35:13	1.31
+++ multipath-tools/libmultipath/discovery.c	2006/10/12 16:16:09	1.32
@@ -52,6 +52,49 @@
 	return NULL;
 }
 
+/* 
+ * This is used to make sure that zero size gnbd devices don't get added.
+ * returns
+ *  1: ok
+ *  0: not ok
+ * -1: error
+ */
+int device_ok_to_add(char *devname)
+{
+	char path[FILE_NAME_SIZE];
+	unsigned int val;
+	struct sysfs_attribute *sysattr;
+
+	if (sscanf(devname, "gnbd%u", &val) != 1)
+		return 1;
+	if (safe_sprintf(path, "%s/class/gnbd/%s/sectors", sysfs_path,
+				devname)) {
+		condlog(0, "path too small for %s sectors", devname);
+		return -1;
+	}
+	if ((sysattr = sysfs_open_attribute(path)) == NULL) {
+		condlog(0, "cannot open sysfs attribute %s : %s",
+				path, strerror(errno));
+		return -1;
+	}
+	if (sysfs_read_attribute(sysattr) < 0) {
+		condlog(0, "cannnot read %s : %s", path,
+				strerror(errno));
+		sysfs_close_attribute(sysattr);
+		return -1;
+	}
+	if (sscanf(sysattr->value, "%u\n", &val) != 1) {
+		condlog(0, "invalid gnbd value for %s : %s", path,
+				sysattr->value);
+		sysfs_close_attribute(sysattr);
+		return -1;
+	}
+	sysfs_close_attribute(sysattr);
+	if (!val)
+		return 0;
+	return 1;
+}
+
 static int
 path_discover (vector pathvec, struct config * conf, char * devname, int flag)
 {
@@ -72,33 +115,13 @@
 			
 	if (!filepresent(path)){
 		unsigned int val;
-		struct sysfs_attribute *sysattr;
+		int ret;
 		if (sscanf(devname, "gnbd%u", &val) != 1)
-			return 0;
-		if (safe_sprintf(path, "%s/class/gnbd/%s/sectors", sysfs_path,
-				 devname)) {
-			condlog(0, "path too small for %s sectors", devname);
-			return 1;
-		}
-		if ((sysattr = sysfs_open_attribute(path)) == NULL) {
-			condlog(0, "cannot open sysfs attribute %s : %s",
-				path, strerror(errno));
-			return 1;
-		}
-		if (sysfs_read_attribute(sysattr) < 0) {
-			condlog(0, "cannnot read %s : %s", path,
-				strerror(errno));
-			sysfs_close_attribute(sysattr);
 			return 1;
-		}
-		if (sscanf(sysattr->value, "%u\n", &val) != 1) {
-			condlog(0, "invalid gnbd value for %s : %s", path,
-				sysattr->value);
-			sysfs_close_attribute(sysattr);
+		ret = device_ok_to_add(devname);
+		if (ret == -1)
 			return 1;
-		}
-		sysfs_close_attribute(sysattr);
-		if (!val)
+		if (ret == 0)
 			return 0;
 	}
 
@@ -403,6 +426,7 @@
 	if (sscanf(pp->dev, "gnbd%u", &unused) == 1){
 		strcpy(pp->vendor_id,  "GNBD");
 		strcpy(pp->product_id, "GNBD");
+		pp->hwe = find_hwe(conf->hwtable, pp->vendor_id, pp->product_id);
 		return 0;
 	}
 	/*
--- multipath-tools/libmultipath/discovery.h	2006/07/13 19:49:23	1.13
+++ multipath-tools/libmultipath/discovery.h	2006/10/12 16:16:09	1.14
@@ -24,6 +24,7 @@
 #define SCSI_COMMAND_TERMINATED 0x22
 #define SG_ERR_DRIVER_SENSE     0x08
 
+int device_ok_to_add(char *devname);
 int sysfs_get_vendor (char * sysfs_path, char * dev, char * buff, int len);
 int sysfs_get_model (char * sysfs_path, char * dev, char * buff, int len);
 int sysfs_get_rev (char * sysfs_path, char * dev, char * buff, int len);
--- multipath-tools/libmultipath/hwtable.c	2006/09/15 18:08:03	1.19
+++ multipath-tools/libmultipath/hwtable.c	2006/10/12 16:16:09	1.20
@@ -519,7 +519,7 @@
 	{
 		.vendor        = "GNBD",
 		.product       = "GNBD",
-		.getuid        = "/sbin/gnbd_import -U /block/%n",
+		.getuid        = "/sbin/gnbd_import -q -U /block/%n",
 		.getprio       = NULL,
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
diff -u -r1.7 -r1.8
--- multipath-tools/multipath/Makefile	2006/10/06 16:38:01	1.15
+++ multipath-tools/multipath/Makefile	2006/10/12 16:16:09	1.16
@@ -22,6 +22,7 @@
 glibc: clean $(OBJS)
 	$(CC) $(OBJS) -o $(EXEC) $(LDFLAGS)
 	$(CC) $(OBJS) -o $(EXEC).static -static $(LDFLAGS) -lselinux -lsepol
+	$(CC) mpath_faker.c -o mpath_ctl $(CFLAGS) -static
 
 klibc: $(OBJS)
 	$(CC) -static -o $(EXEC) $(CRT0) $(OBJS) $(KLIBC) $(LIBGCC)
@@ -35,7 +36,7 @@
 
 install:
 	install -d $(DESTDIR)$(bindir)
-	install -m 755 $(EXEC) $(EXEC).static mpath_get_name kpartx_get_name $(DESTDIR)$(bindir)/
+	install -m 755 $(EXEC) $(EXEC).static mpath_ctl mpath_wait $(DESTDIR)$(bindir)/
 	install -d $(DESTDIR)/etc/udev/rules.d
 	install -m 644 multipath.rules $(DESTDIR)/etc/udev/rules.d/40-multipath.rules
 	install -d $(DESTDIR)$(mandir)
@@ -49,8 +50,9 @@
 	rm $(DESTDIR)$(bindir)/$(EXEC)
 	rm $(DESTDIR)$(bindir)/$(EXEC).static
 	rm $(DESTDIR)$(bindir)/mpath_wait
+	rm $(DESTDIR)$(bindir)/mpath_ctl
 	rm $(DESTDIR)$(mandir)/$(EXEC).8
 
 clean:
 	$(MAKE) -C $(multipathdir) clean
-	rm -f core *.o $(EXEC) $(EXEC).static *.gz
+	rm -f core *.o $(EXEC) $(EXEC).static mpath_ctl *.gz
--- multipath-tools/multipathd/main.c	2006/08/02 21:37:23	1.68
+++ multipath-tools/multipathd/main.c	2006/10/12 16:16:09	1.69
@@ -348,6 +348,14 @@
 	struct multipath * mpp;
 	struct path * pp;
 	char empty_buff[WWID_SIZE] = {0};
+	int ret;
+
+	ret = device_ok_to_add(devname);
+	if (ret < 0)
+		return 1;
+	if (ret == 0)
+		/* Is 2 the best return code? */
+		return 2;
 
 	pp = find_path_by_dev(vecs->pathvec, devname);
 
@@ -1016,6 +1024,18 @@
 	return NULL;
 }
 
+static void
+orphan_unused_paths (struct vectors *vecs)
+{
+	int i;
+	struct path *pp;
+
+	vector_foreach_slot(vecs->pathvec, pp, i) {
+		if (pp->mpp == NULL)
+			orphan_path(pp);
+	}
+}
+
 int
 configure (struct vectors * vecs, int start_waiters)
 {
@@ -1082,6 +1102,7 @@
 	vector_free(vecs->mpvec);
 	vecs->mpvec = mpvec;
 
+	orphan_unused_paths(vecs);
 	/*
 	 * start dm event waiter threads for these new maps
 	 */
