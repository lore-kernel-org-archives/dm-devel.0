From: bmarzins@sourceware.org
Subject: multipath-tools libmultipath/config.c libmulti ...
Date: 15 Dec 2007 00:27:41 -0000
Message-ID: <20071215002741.21134.qmail@sourceware.org>
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
Branch: 	RHEL5_FC6
Changes by:	bmarzins@sourceware.org	2007-12-15 00:27:40

Modified files:
	libmultipath   : config.c config.h dict.c 
	multipathd     : Makefile main.c 
Added files:
	multipathd     : clone_platform.h copy.c copy.h 

Log message:
	Add private namespace and callout cache support back to multipath.  This seems
	less invasive than the libprio work in upstream, which will go into the next
	major release. Fixes bz #355961

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/config.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.19.2.3&r2=1.19.2.4
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/config.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.18.2.1&r2=1.18.2.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/dict.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.17.2.2&r2=1.17.2.3
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/clone_platform.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=NONE&r2=1.4.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/copy.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=NONE&r2=1.5.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/copy.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=NONE&r2=1.4.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/Makefile.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.14&r2=1.14.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/main.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.69.2.2&r2=1.69.2.3

--- multipath-tools/libmultipath/config.c	2007/11/10 00:01:59	1.19.2.3
+++ multipath-tools/libmultipath/config.c	2007/12/15 00:27:39	1.19.2.4
@@ -20,6 +20,57 @@
 #include "blacklist.h"
 #include "defaults.h"
 
+/*
+ * helper function to draw a list of callout binaries found in the config file
+ */
+extern int
+push_callout(char * callout)
+{
+#if DAEMON
+	int i;
+	char *bin;
+	char *p;
+
+	/*
+	 * purge command line arguments
+	 */
+	p = callout;
+
+	while (*p != ' ' && *p != '\0')
+		p++;
+
+	if (!conf->binvec)
+		conf->binvec = vector_alloc();
+
+
+	if (!conf->binvec)
+		return 1;
+
+	/*
+	 * if this callout is already stored in binvec, don't store it twice
+	 */
+	vector_foreach_slot (conf->binvec, bin, i)
+		if (memcmp(bin, callout, p - callout) == 0)
+			return 0;
+
+	/*
+	 * else, store it
+	 */
+	bin = MALLOC((p - callout) + 1);
+
+	if (!bin)
+		return 1;
+
+	strncpy(bin, callout, p - callout);
+
+	if (!vector_alloc_slot(conf->binvec))
+		return 1;
+
+	vector_set_slot(conf->binvec, bin);
+#endif
+	return 0;
+}
+
 static struct hwentry *
 find_hwe_strmatch (vector hwtable, char * vendor, char * product)
 {
@@ -255,10 +306,12 @@
 	if (!dhwe->product || !(hwe->product = set_param_str(dhwe->product)))
 		goto out;
 	
-	if (dhwe->getuid && !(hwe->getuid = set_param_str(dhwe->getuid)))
+	if (dhwe->getuid && (!(hwe->getuid = set_param_str(dhwe->getuid)) ||
+	                     push_callout(dhwe->getuid)))
 		goto out;
 
-	if (dhwe->getprio && !(hwe->getprio = set_param_str(dhwe->getprio)))
+	if (dhwe->getprio && (!(hwe->getprio = set_param_str(dhwe->getprio)) ||
+	                      push_callout(dhwe->getprio)))
 		goto out;
 				
 	if (dhwe->features && !(hwe->features = set_param_str(dhwe->features)))
@@ -337,6 +390,7 @@
 	free_mptable(conf->mptable);
 	free_hwtable(conf->hwtable);
 	free_keywords(conf->keywords);
+	free_strvec(conf->binvec);
 	FREE(conf);
 }
 
@@ -435,8 +489,11 @@
 	if (conf->udev_dir == NULL)
 		conf->udev_dir = set_default(DEFAULT_UDEVDIR);
 
-	if (conf->getuid == NULL)
+	if (conf->getuid == NULL){
 		conf->getuid = set_default(DEFAULT_GETUID);
+		if (push_callout(conf->getuid))
+			goto out;
+	}
 
 	if (conf->features == NULL)
 		conf->features = set_default(DEFAULT_FEATURES);
--- multipath-tools/libmultipath/config.h	2007/01/10 20:08:08	1.18.2.1
+++ multipath-tools/libmultipath/config.h	2007/12/15 00:27:39	1.18.2.2
@@ -76,6 +76,7 @@
 	vector keywords;
 	vector mptable;
 	vector hwtable;
+	vector binvec;
 
 	vector blist_devnode;
 	vector blist_wwid;
@@ -87,6 +88,8 @@
 
 struct config * conf;
 
+extern int push_callout(char * callout);
+
 struct hwentry * find_hwe (vector hwtable, char * vendor, char * product);
 struct mpentry * find_mpe (char * wwid);
 char * get_mpe_wwid (char * alias);
--- multipath-tools/libmultipath/dict.c	2007/11/10 00:01:59	1.17.2.2
+++ multipath-tools/libmultipath/dict.c	2007/12/15 00:27:39	1.17.2.3
@@ -78,7 +78,7 @@
 	if (!conf->getuid)
 		return 1;
 	
-	return 0;
+	return push_callout(conf->getuid);
 }
 
 static int
@@ -93,9 +93,10 @@
 	    !strcmp(conf->getprio, "none")) {
 		FREE(conf->getprio);
 		conf->getprio = NULL;
+		return 0;
 	}
 		
-	return 0;
+	return push_callout(conf->getprio);
 }
 
 static int
@@ -510,7 +511,7 @@
 	if (!hwe->getuid)
 		return 1;
 
-	return 0;
+	return push_callout(hwe->getuid);
 }
 
 static int
@@ -597,9 +598,10 @@
 	if (strlen(hwe->getprio) == 4 && !strcmp(hwe->getprio, "none")) {
 		FREE(hwe->getprio);
 		hwe->getprio = NULL;
+		return 0;
 	}
 
-	return 0;
+	return push_callout(hwe->getprio);
 }
 
 static int
--- multipath-tools/multipathd/Makefile	2006/06/06 18:32:44	1.14
+++ multipath-tools/multipathd/Makefile	2007/12/15 00:27:39	1.14.2.1
@@ -19,7 +19,7 @@
 #
 # object files
 #
-OBJS = main.o pidfile.o uxlsnr.o uxclnt.o cli.o cli_handlers.o \
+OBJS = main.o pidfile.o uxlsnr.o uxclnt.o cli.o copy.o cli_handlers.o \
        $(MULTIPATHLIB)-glibc.a $(CHECKERSLIB)-glibc.a \
 
 
--- multipath-tools/multipathd/main.c	2007/06/15 19:03:02	1.69.2.2
+++ multipath-tools/multipathd/main.c	2007/12/15 00:27:40	1.69.2.3
@@ -10,6 +10,7 @@
 #include <wait.h>
 #include <sys/mman.h>
 #include <sys/types.h>
+#include <sys/mount.h>
 #include <fcntl.h>
 #include <errno.h>
 
@@ -57,10 +58,14 @@
 #include "cli_handlers.h"
 #include "lock.h"
 #include "waiter.h"
+#include "clone_platform.h"
+#include "copy.h"
 
 #define FILE_NAME_SIZE 256
 #define CMDSIZE 160
 
+#define CALLOUT_DIR "/var/cache/multipathd"
+
 #define LOG_MSG(a,b) \
 	if (strlen(b)) condlog(a, "%s: %s", pp->dev, b);
 
@@ -746,6 +751,9 @@
 	if (status != 0)
 		fprintf(stderr, "bad exit status. see daemon.log\n");
 
+	condlog(3, "umount ramfs");
+	umount(CALLOUT_DIR);
+
 	condlog(3, "unlink pidfile");
 	unlink(DEFAULT_PIDFILE);
 
@@ -1179,6 +1187,108 @@
 	return NULL;
 }
 
+
+#ifdef CLONE_NEWNS
+static int
+prepare_namespace(void)
+{
+	mode_t mode = S_IRWXU;
+	struct stat * buf;
+	char ramfs_args[64];
+	int i;
+	int fd;
+	char * bin;
+	size_t size = 10;
+	struct stat statbuf;
+
+	if (!conf->binvec)
+		return 0;
+	buf = (struct stat *)MALLOC(sizeof(struct stat));
+
+	/*
+	 * create a temp mount point for ramfs
+	 */
+	if (stat(CALLOUT_DIR, buf) < 0) {
+		if (mkdir(CALLOUT_DIR, mode) < 0) {
+			condlog(0, "cannot create " CALLOUT_DIR);
+			FREE(buf);
+			return -1;
+		}
+		condlog(4, "created " CALLOUT_DIR);
+	}
+	FREE(buf);
+
+	/*
+	 * compute the optimal ramdisk size
+	 */
+	vector_foreach_slot (conf->binvec, bin,i) {
+		if ((fd = open(bin, O_RDONLY)) < 0) {
+			condlog(0, "cannot open %s : %s\n", bin,
+				strerror(errno));
+			continue;
+		}
+		if (fstat(fd, &statbuf) < 0) {
+			condlog(0, "cannot stat %s", bin);
+			return -1;
+		}
+		size += statbuf.st_size;
+		close(fd);
+	}
+	condlog(3, "ramfs maxsize is %u", (unsigned int) size);
+
+	/*
+	 * mount the ramfs
+	 */
+	if (safe_sprintf(ramfs_args, "maxsize=%u", (unsigned int) size)) {
+		condlog(0, "ramfs_args too small\n");
+		return -1;
+	}
+	if (mount(NULL, CALLOUT_DIR, "ramfs", MS_SYNCHRONOUS, ramfs_args) < 0) {
+		condlog(0, "cannot mount ramfs on " CALLOUT_DIR);
+		return -1;
+	}
+	condlog(4, "mount ramfs on " CALLOUT_DIR);
+
+	/*
+	 * populate the ramfs with callout binaries
+	 */
+	vector_foreach_slot (conf->binvec, bin,i) {
+		if (copytodir(bin, CALLOUT_DIR) < 0) {
+			condlog(0, "cannot copy %s in ramfs : %s", bin,
+				strerror(errno));
+			continue;
+		}
+		condlog(4, "cp %s in ramfs", bin);
+	}
+	free_strvec(conf->binvec);
+	conf->binvec = NULL;
+
+	/*
+	 * bind the ramfs to :
+	 * /sbin : default home of multipath ...
+	 * /bin  : default home of scsi_id ...
+	 * /tmp  : home of scsi_id temp files
+	 */
+	if (mount(CALLOUT_DIR, "/sbin", NULL, MS_BIND, NULL) < 0) {
+		condlog(0, "cannot bind ramfs on /sbin");
+		return -1;
+	}
+	condlog(4, "bind ramfs on /sbin");
+	if (mount(CALLOUT_DIR, "/bin", NULL, MS_BIND, NULL) < 0) {
+		condlog(0, "cannot bind ramfs on /bin");
+		return -1;
+	}
+	condlog(4, "bind ramfs on /bin");
+	if (mount(CALLOUT_DIR, "/tmp", NULL, MS_BIND, NULL) < 0) {
+		condlog(0, "cannot bind ramfs on /tmp");
+		return -1;
+	}
+	condlog(4, "bind ramfs on /tmp");
+
+	return 0;
+}
+#endif
+
 static void *
 signal_set(int signo, void (*func) (int))
 {
@@ -1263,13 +1373,46 @@
 	fclose(fp);
 }
 	
+static void
+setup_daemon(void)
+{
+	int in_fd, out_fd;
+
+	in_fd = open("/dev/null", O_RDONLY);
+	if (in_fd < 0){
+		fprintf(stderr, "cannot open /dev/null for input : %s\n",
+			strerror(errno));
+		_exit(0);
+	}
+	out_fd = open("/dev/console", O_WRONLY);
+	if (out_fd < 0){
+		fprintf(stderr, "cannot open /dev/console for output : %s\n",
+			strerror(errno));
+		_exit(0);
+	}
+
+	close(STDIN_FILENO);
+	dup(in_fd);
+	close(STDOUT_FILENO);
+	dup(out_fd);
+	close(STDERR_FILENO);
+	dup(out_fd);
+
+	close(in_fd);
+	close(out_fd);
+	chdir("/");
+	umask(0);
+}
+
 static int
 child (void * param)
 {
 	pthread_t check_thr, uevent_thr, uxlsnr_thr;
 	pthread_attr_t attr;
 	struct vectors * vecs;
+	unsigned long new_ns = (unsigned long)param;
 
+	setup_daemon();
 	mlockall(MCL_CURRENT | MCL_FUTURE);
 
 	if (logsink)
@@ -1309,6 +1452,12 @@
 		condlog(0, "can not find sysfs mount point");
 		exit(1);
 	}
+#ifdef CLONE_NEWNS
+	if (new_ns && prepare_namespace() < 0) {
+		condlog(0, "cannot prepare namespace");
+		exit(1);
+	}
+#endif
 
 	/*
 	 * fetch and configure both paths and multipaths
@@ -1376,7 +1525,9 @@
 daemonize(void)
 {
 	int pid;
-	int in_fd, out_fd;
+#ifdef CLONE_NEWNS
+	void *child_stack;
+#endif
 
 	if( (pid = fork()) < 0){
 		fprintf(stderr, "Failed first fork : %s\n", strerror(errno));
@@ -1387,36 +1538,37 @@
 
 	setsid();
 
-	if ( (pid = fork()) < 0)
-		fprintf(stderr, "Failed second fork : %s\n", strerror(errno));
-	else if (pid != 0)
-		_exit(0);
+#ifdef CLONE_NEWNS
 
-	in_fd = open("/dev/null", O_RDONLY);
-	if (in_fd < 0){
-		fprintf(stderr, "cannot open /dev/null for input : %s\n",
+	child_stack = (void *)malloc(CHILD_STACK_SIZE);
+	if (!child_stack) {
+		fprintf(stderr, "Failed to allocate child stack : %s\n",
 			strerror(errno));
-		_exit(0);
+		_exit(1);
 	}
-	out_fd = open("/dev/console", O_WRONLY);
-	if (out_fd < 0){
-		fprintf(stderr, "cannot open /dev/console for output : %s\n",
-			strerror(errno));
-		_exit(0);
+#  if defined(__hppa__) || defined(__powerpc64__)
+	pid = clone(child, child_stack, CLONE_NEWNS, (void *)1);
+#  elif defined(__ia64__)
+	pid = clone2(child, child_stack, CHILD_STACK_SIZE, CLONE_NEWNS,
+	             (void *)1, NULL, NULL, NULL);
+#  else
+	pid = clone(child, child_stack + CHILD_STACK_SIZE, CLONE_NEWNS,
+	            (void *)1);
+#  endif
+	if (pid < 0) {
+		fprintf(stderr, "Clone failed : %s\n", strerror(errno));
+		_exit(1);
+	}
+	_exit(0);
+#else
+	if ( (pid = fork()) < 0){
+		fprintf(stderr, "Failed second fork : %s\n", strerror(errno));
+		_exit(1);
 	}
-
-	close(STDIN_FILENO);
-	dup(in_fd);
-	close(STDOUT_FILENO);
-	dup(out_fd);
-	close(STDERR_FILENO);
-	dup(out_fd);
-
-	close(in_fd);
-	close(out_fd);
-	chdir("/");
-	umask(0);
-	return 0;
+	if (pid != 0)
+		_exit(0);
+	return child((void *)0);
+#endif
 }
 
 int
@@ -1466,18 +1618,14 @@
 	}
 
 	if (!logsink)
-		err = 0;
-	else
+		return child((void *)0);
+	else{
 		err = daemonize();
+	}
 	
 	if (err < 0)
-		/* error */
-		exit(1);
-	else if (err > 0)
-		/* parent dies */
-		exit(0);
-	else
-		/* child lives */
-		return (child(NULL));
+		return 1;
+	/* parent dies */
+	return 0;
 }
 
