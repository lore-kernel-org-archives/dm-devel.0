From: bmarzins@sourceware.org
Subject: multipath-tools/libcheckers directio.c
Date: 12 Jun 2007 21:07:46 -0000
Message-ID: <20070612210746.7502.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2007-06-12 21:07:46

Modified files:
	libcheckers    : directio.c 

Log message:
	Fix for bz#214838. multipath now uses libaio to do the directio checks.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libcheckers/directio.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.3&r2=1.3.2.1

--- multipath-tools/libcheckers/directio.c	2006/06/06 18:32:43	1.3
+++ multipath-tools/libcheckers/directio.c	2007/06/12 21:07:46	1.3.2.1
@@ -12,28 +12,44 @@
 #include <sys/ioctl.h>
 #include <linux/fs.h>
 #include <errno.h>
+#include <linux/kdev_t.h>
+#include <asm/unistd.h>
 
+#include "libaio.h"
 #include "checkers.h"
+#include "../libmultipath/debug.h"
 
 #define MSG_DIRECTIO_UNKNOWN	"directio checker is not available"
 #define MSG_DIRECTIO_UP		"directio checker reports path is up"
 #define MSG_DIRECTIO_DOWN	"directio checker reports path is down"
 
 struct directio_context {
-	int blksize; 
-	unsigned char *buf;
-	unsigned char *ptr;
+	int		running;
+	int		reset_flags;
+	int		blksize;
+	unsigned char *	buf;
+	unsigned char * ptr;
+	io_context_t	ioctx;
+	struct iocb	io;
 };
 
+
 int directio_init (struct checker * c)
 {
 	unsigned long pgsize = getpagesize();
 	struct directio_context * ct;
+	long flags;
 
 	ct = malloc(sizeof(struct directio_context));
 	if (!ct)
 		return 1;
-	c->context = (void *)ct;
+	memset(ct, 0, sizeof(struct directio_context));
+
+	if (syscall(__NR_io_setup, 1, &ct->ioctx) != 0) {
+		condlog(1, "io_setup failed");
+		free(ct);
+		return 1;
+	}
 
 	if (ioctl(c->fd, BLKBSZGET, &ct->blksize) < 0) {
 		MSG(c, "cannot get blocksize, set default");
@@ -50,11 +66,28 @@
 	ct->buf = (unsigned char *)malloc(ct->blksize + pgsize);
 	if (!ct->buf)
 		goto out;
-	ct->ptr = (unsigned char *)(((unsigned long)ct->buf + pgsize - 1) &
-		  (~(pgsize - 1))); 
 
+	flags = fcntl(c->fd, F_GETFL);
+	if (flags < 0)
+		goto out;
+	if (!(flags & O_DIRECT)) {
+		flags |= O_DIRECT;
+		if (fcntl(c->fd, F_SETFL, flags) < 0)
+			goto out;
+		ct->reset_flags = 1;
+	}
+
+	ct->ptr = (unsigned char *) (((unsigned long)ct->buf + pgsize - 1) &
+		  (~(pgsize - 1)));
+
+	/* Sucessfully initialized, return the context. */
+	c->context = (void *) ct;
 	return 0;
+
 out:
+	if (ct->buf)
+		free(ct->buf);
+	syscall(__NR_io_destroy, ct->ioctx);
 	free(ct);
 	return 1;
 }
@@ -62,56 +95,63 @@
 void directio_free (struct checker * c)
 {
 	struct directio_context * ct = (struct directio_context *)c->context;
+	long flags;
 
 	if (!ct)
 		return;
+
+	if (ct->reset_flags) {
+		if ((flags = fcntl(c->fd, F_GETFL)) >= 0) {
+			flags &= ~O_DIRECT;
+			/* No point in checking for errors */
+			fcntl(c->fd, F_SETFL, flags);
+		}
+	}
+
 	if (ct->buf)
 		free(ct->buf);
+	syscall(__NR_io_destroy, ct->ioctx);
 	free(ct);
 }
 
 static int
-direct_read (int fd, unsigned char * buff, int size)
+check_state(int fd, struct directio_context *ct)
 {
-	long flags;
-	int reset_flags = 0;
-	int res, retval;
-
-	flags = fcntl(fd,F_GETFL);
-
-	if (flags < 0) {
-		return PATH_UNCHECKED;
-	}
-
-	if (!(flags & O_DIRECT)) {
-		flags |= O_DIRECT;
-		if (fcntl(fd,F_SETFL,flags) < 0) {
+	struct timespec	timeout = { .tv_sec = 2 };
+	struct io_event event;
+	struct stat	sb;
+	int		rc = PATH_UNCHECKED;
+	long		r;
+
+	if (fstat(fd, &sb) == 0) {
+		condlog(4, "directio: called for %x", (unsigned) sb.st_rdev);
+	}
+
+	if (!ct->running) {
+		struct iocb *ios[1] = { &ct->io };
+
+		condlog(3, "directio: starting new request");
+		memset(&ct->io, 0, sizeof(struct iocb));
+		io_prep_pread(&ct->io, fd, ct->ptr, ct->blksize, 0);
+		if (syscall(__NR_io_submit, ct->ioctx, 1, ios) != 1) {
+			condlog(3, "directio: io_submit error %i", errno);
 			return PATH_UNCHECKED;
 		}
-		reset_flags = 1;
 	}
+	ct->running = 1;
 
-	while ( (res = read(fd,buff,size)) < 0 && errno == EINTR );
-	if (res < 0) {
-		if (errno == EINVAL) {
-			/* O_DIRECT is not available */
-			retval = PATH_UNCHECKED;
-		} else if (errno == ENOMEM) {
-			retval = PATH_UP;
-		} else {
-			retval = PATH_DOWN;
-		}
+	r = syscall(__NR_io_getevents, ct->ioctx, 1L, 1L, &event, &timeout);
+	if (r < 1L) {
+		condlog(3, "directio: timeout r=%li errno=%i", r, errno);
+		rc = PATH_DOWN;
 	} else {
-		retval = PATH_UP;
-	}
-	
-	if (reset_flags) {
-		flags &= ~O_DIRECT;
-		/* No point in checking for errors */
-		fcntl(fd,F_SETFL,flags);
+		condlog(3, "directio: io finished %lu/%lu", event.res,
+			event.res2);
+		ct->running = 0;
+		rc = (event.res == ct->blksize) ? PATH_UP : PATH_DOWN;
 	}
 
-	return retval;
+	return rc;
 }
 
 int directio (struct checker * c)
@@ -119,7 +159,10 @@
 	int ret;
 	struct directio_context * ct = (struct directio_context *)c->context;
 
-	ret = direct_read(c->fd, ct->ptr, ct->blksize);
+	if (!ct)
+		return PATH_UNCHECKED;
+
+	ret = check_state(c->fd, ct);
 
 	switch (ret)
 	{
