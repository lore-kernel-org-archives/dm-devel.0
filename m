From: meyering@sourceware.org
Subject: device-mapper ./WHATS_NEW include/log.h lib/li ...
Date: 28 Jul 2007 10:23:04 -0000
Message-ID: <20070728102304.10269.qmail@sourceware.org>
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
Module name:	device-mapper
Changes by:	meyering@sourceware.org	2007-07-28 10:23:02

Modified files:
	.              : WHATS_NEW 
	include        : log.h 
	lib            : libdm-common.c libdm-file.c 
	lib/fs         : libdevmapper.c 
	lib/ioctl      : libdm-iface.c 

Log message:
	Introduce log_sys_* macros from LVM2.
	Convert existing "<string>: <function> failed: <strerror>" type messages
	to use this macro.  Patch by Jun'ichi Nomura.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.193&r2=1.194
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/include/log.h.diff?cvsroot=dm&r1=1.9&r2=1.10
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-common.c.diff?cvsroot=dm&r1=1.44&r2=1.45
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-file.c.diff?cvsroot=dm&r1=1.5&r2=1.6
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/fs/libdevmapper.c.diff?cvsroot=dm&r1=1.14&r2=1.15
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/ioctl/libdm-iface.c.diff?cvsroot=dm&r1=1.43&r2=1.44

--- device-mapper/WHATS_NEW	2007/07/24 14:16:48	1.193
+++ device-mapper/WHATS_NEW	2007/07/28 10:23:01	1.194
@@ -1,5 +1,6 @@
 Version 1.02.22 - 
 ================================
+  Introduce and use log_sys_* macros from LVM2
   dm_fclose: new function
   libdevmapper, dmeventd: be paranoid about detecting write failure
 
--- device-mapper/include/log.h	2007/06/28 17:27:01	1.9
+++ device-mapper/include/log.h	2007/07/28 10:23:01	1.10
@@ -38,6 +38,14 @@
 #define log_very_verbose(x...) plog(_LOG_INFO, x)
 #define log_debug(x...) plog(_LOG_DEBUG, x)
 
+/* System call equivalents */
+#define log_sys_error(x, y) \
+		log_error("%s: %s failed: %s", y, x, strerror(errno))
+#define log_sys_very_verbose(x, y) \
+		log_info("%s: %s failed: %s", y, x, strerror(errno))
+#define log_sys_debug(x, y) \
+		log_debug("%s: %s failed: %s", y, x, strerror(errno))
+
 #define stack log_debug("<backtrace>")  /* Backtrace on error */
 
 #define return_0	do { stack; return 0; } while (0)
--- device-mapper/lib/libdm-common.c	2007/06/28 17:27:02	1.44
+++ device-mapper/lib/libdm-common.c	2007/07/28 10:23:01	1.45
@@ -242,7 +242,7 @@
 	log_debug("Setting SELinux context for %s to %s.", path, scontext);
 
 	if ((lsetfilecon(path, scontext) < 0) && (errno != ENOTSUP)) {
-		log_error("%s: lsetfilecon failed: %s", path, strerror(errno));
+		log_sys_error("lsetfilecon", path);
 		freecon(scontext);
 		return 0;
 	}
@@ -288,7 +288,7 @@
 	umask(old_mask);
 
 	if (chown(path, uid, gid) < 0) {
-		log_error("%s: chown failed: %s", path, strerror(errno));
+		log_sys_error("chown", path);
 		return 0;
 	}
 
--- device-mapper/lib/libdm-file.c	2007/07/24 14:15:45	1.5
+++ device-mapper/lib/libdm-file.c	2007/07/28 10:23:01	1.6
@@ -33,8 +33,7 @@
 		if (*orig) {
 			rc = mkdir(orig, 0777);
 			if (rc < 0 && errno != EEXIST) {
-				log_error("%s: mkdir failed: %s", orig,
-					  strerror(errno));
+				log_sys_error("mkdir", orig);
 				goto out;
 			}
 		}
@@ -44,8 +43,7 @@
 	/* Create final directory */
 	rc = mkdir(dir, 0777);
 	if (rc < 0 && errno != EEXIST) {
-		log_error("%s: mkdir failed: %s", orig,
-			  strerror(errno));
+		log_sys_error("mkdir", orig);
 		goto out;
 	}
 
--- device-mapper/lib/fs/libdevmapper.c	2007/07/24 14:16:48	1.14
+++ device-mapper/lib/fs/libdevmapper.c	2007/07/28 10:23:01	1.15
@@ -149,11 +149,11 @@
 		if (fputc(c, fp) == (int)c)
 			ret = 1;
 		else
-			log_error("%s: fputc failed: %s", path, strerror(errno));
+			log_sys_error("fputc", path);
 		if (fclose(fp))
-			log_error("%s: write failed: %s", path, strerror(errno));
+			log_sys_error("write", path);
 	} else
-		log_error("%s: fopen failed: %s", path, strerror(errno));
+		log_sys_error("fopen", path);
 
 	free(path);
 
@@ -174,10 +174,10 @@
 			if (errno == EEXIST && !stat(path, &st) &&
 			    S_ISDIR(st.st_mode)) 
 				ret = 1;
-			log_error("%s: mkdir failed: %s", path, strerror(errno));
+			log_sys_error("mkdir", path);
 		}
 	} else if ((ret = rmdir(path)) < 0)
-		log_error("%s: rmdir failed: %s", path, strerror(errno));
+		log_sys_error("rmdir", path);
 
 	free(path);
 
@@ -216,10 +216,10 @@
 		if (fscanf(fp, "%d", &info->suspended) == 1)
 			ret = 1;
 		else
-			log_error("%s fscanf failed: %s", path, strerror(errno));
+			log_sys_error("fscanf", path);
 		fclose(fp);
 	} else
-		log_error("%s: fopen failed: %s", path, strerror(errno));
+		log_sys_error("fopen", path);
 
 	free(path);
 
@@ -288,7 +288,7 @@
 
 	if ((fd = open(path, O_RDWR)) != -1) {
 		if (!(ret = write_data(fd, dmt)))
-			log_error("%s: write failed: %s", path, strerror(errno));
+			log_sys_error("write", path);
 		close(fd);
 	}
 
@@ -315,7 +315,7 @@
 		return 0;
 
 	if (!(fp = fopen(path, "r"))) {
-		log_error("%s: fopen failed: %s", path, strerror(errno));
+		log_sys_error("fopen", path);
 		free(path);
 		return 0;
 	}
@@ -338,7 +338,7 @@
 	char fstype[30];
 
 	if (!(fp = fopen("/proc/mounts", "r"))) {
-		log_error("/proc/mounts: fopen failed: %s", strerror(errno));
+		log_sys_error("fopen", "/proc/mounts");
 		return NULL;
 	}
 
--- device-mapper/lib/ioctl/libdm-iface.c	2007/06/28 17:27:02	1.43
+++ device-mapper/lib/ioctl/libdm-iface.c	2007/07/28 10:23:02	1.44
@@ -140,7 +140,7 @@
 	uint32_t num;
 
 	if (!(fl = fopen(file, "r"))) {
-		log_error("%s: fopen failed: %s", file, strerror(errno));
+		log_sys_error("fopen", file);
 		return 0;
 	}
 
@@ -150,7 +150,7 @@
 				if (number) {
 					*number = num;
 					if (fclose(fl))
-						log_error("%s: fclose failed: %s", file, strerror(errno));
+						log_sys_error("fclose", file);
 					return 1;
 				}
 				dm_bit_set(_dm_bitset, num);
@@ -160,7 +160,7 @@
 		} while (c != EOF && c != '\n');
 	}
 	if (fclose(fl))
-		log_error("%s: fclose failed: %s", file, strerror(errno));
+		log_sys_error("fclose", file);
 
 	if (number) {
 		log_error("%s: No entry for %s found", file, name);
@@ -190,8 +190,7 @@
 
 	if (stat(control, &buf) < 0) {
 		if (errno != ENOENT)
-			log_error("%s: stat failed: %s", control,
-				  strerror(errno));
+			log_sys_error("stat", control);
 		return 0;
 	}
 
@@ -199,8 +198,7 @@
 		log_verbose("%s: Wrong inode type", control);
 		if (!unlink(control))
 			return 0;
-		log_error("%s: unlink failed: %s", control,
-			  strerror(errno));
+		log_sys_error("unlink", control);
 		return -1;
 	}
 
@@ -211,8 +209,7 @@
 			    major, minor);
 		if (!unlink(control))
 			return 0;
-		log_error("%s: unlink failed: %s", control,
-			  strerror(errno));
+		log_sys_error("unlink", control);
 		return -1;
 	}
 
@@ -238,7 +235,7 @@
 
 	if (mknod(control, S_IFCHR | S_IRUSR | S_IWUSR,
 		  MKDEV(major, minor)) < 0)  {
-		log_error("%s: mknod failed: %s", control, strerror(errno));
+		log_sys_error("mknod", control);
 		return 0;
 	}
 
@@ -301,7 +298,7 @@
 		goto error;
 
 	if ((_control_fd = open(control, O_RDWR)) < 0) {
-		log_error("%s: open failed: %s", control, strerror(errno));
+		log_sys_error("open", control);
 		goto error;
 	}
 
@@ -597,7 +594,7 @@
 	log_warn("Please upgrade your kernel device-mapper driver.");
 
 	if (!(d = opendir(dev_dir))) {
-		log_error("%s: opendir failed: %s", dev_dir, strerror(errno));
+		log_sys_error("opendir", dev_dir);
 		return 0;
 	}
 
@@ -616,7 +613,7 @@
 						      (void *) old_names);
 		snprintf(path, sizeof(path), "%s/%s", dev_dir, name);
 		if (stat(path, &buf)) {
-			log_error("%s: stat failed: %s", path, strerror(errno));
+			log_sys_error("stat", path);
 			continue;
 		}
 		if (!S_ISBLK(buf.st_mode))
@@ -637,7 +634,7 @@
 	}
 
 	if (closedir(d))
-		log_error("%s: closedir failed: %s", dev_dir, strerror(errno));
+		log_sys_error("closedir", dev_dir);
 
 	return r;
 }
@@ -1324,7 +1321,7 @@
 
 	dir = dm_dir();
 	if (!(d = opendir(dir))) {
-		log_error("opendir %s: %s", dir, strerror(errno));
+		log_sys_error("opendir", dir);
 		return 0;
 	}
 
@@ -1338,7 +1335,7 @@
 	}
 
 	if (closedir(d))
-		log_error("closedir %s: %s", dir, strerror(errno));
+		log_sys_error("closedir", dir);
 
 	return r;
 }
