From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] dm-multipath: make directio checker use AIO.
Date: Mon, 9 Apr 2007 17:17:21 -0500
Message-ID: <20070409221720.GA29511@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="3MwIy2ne0vdjdPXF"
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids


--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

This is a cleaned up patch I got from IBM. The issue is that when a DASD is
quiesced, all IO to the disk hangs. Since DASDs use the directio checker
function, this causes the multipathd checker thread to freeze, as well as any
process that runs multipath -ll.  The attached patch makes the directio
checker use AIO, and checks a timer to determine whether the path is up or
down.  It also moves the fcntls that set the file descriptor to O_DIRECT, to
increase effiency.

It also adds a dependency on libaio, and obviously changes the behavior of
the directio checker.  I don't see a reason why people would still need the
original non-AIO version of this checker, but if people would prefer this to
be a new checker, I can do that, and send a new patch.

-Ben

--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="aio_dio_checker.patch"

--- multipath-tools/libcheckers/directio.c	2006-06-06 13:32:43.000000000 -0500
+++ multipath-tools-patched/libcheckers/directio.c	2007-04-09 09:20:52.000000000 -0500
@@ -13,6 +13,7 @@
 #include <linux/fs.h>
 #include <errno.h>
 
+#include "libaio.h"
 #include "checkers.h"
 
 #define MSG_DIRECTIO_UNKNOWN	"directio checker is not available"
@@ -20,20 +21,30 @@
 #define MSG_DIRECTIO_DOWN	"directio checker reports path is down"
 
 struct directio_context {
+	int running;
+	int reset_flags;
 	int blksize; 
 	unsigned char *buf;
 	unsigned char *ptr;
+	io_context_t ioctx;
+	struct iocb io;
 };
 
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
+	if (io_queue_init(1, &ct->ioctx) != 0) {
+		free(ct);
+		return 1;
+	}
 
 	if (ioctl(c->fd, BLKBSZGET, &ct->blksize) < 0) {
 		MSG(c, "cannot get blocksize, set default");
@@ -53,8 +64,23 @@ int directio_init (struct checker * c)
 	ct->ptr = (unsigned char *)(((unsigned long)ct->buf + pgsize - 1) &
 		  (~(pgsize - 1))); 
 
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
+	/* Sucessfully initialized, return the context. */
+	c->context = (void *) ct;
 	return 0;
 out:
+	if (ct->buf)
+		free(ct->buf);
+	io_queue_release(ct->ioctx);
 	free(ct);
 	return 1;
 }
@@ -62,53 +88,48 @@ out:
 void directio_free (struct checker * c)
 {
 	struct directio_context * ct = (struct directio_context *)c->context;
+	long flags;
 
 	if (!ct)
 		return;
+
+	if (ct->reset_flags) {
+		if (flags = fcntl(c->fd, F_GETFL) >= 0) {
+			flags &= ~O_DIRECT;
+			/* No point in checking for errors */
+			fcntl(c->fd, F_SETFL, flags);
+		}
+	}
+
 	if (ct->buf)
 		free(ct->buf);
+	io_queue_release(ct->ioctx);
 	free(ct);
 }
 
 static int
-direct_read (int fd, unsigned char * buff, int size)
+check_state(int fd, struct directio_context *ct)
 {
-	long flags;
-	int reset_flags = 0;
+	struct timespec timeout = { .tv_sec = 2 };
+	struct io_event event;
 	int res, retval;
 
-	flags = fcntl(fd,F_GETFL);
+	if (!ct->running) {
+		struct iocb *ios[1] = { &ct->io };
 
-	if (flags < 0) {
-		return PATH_UNCHECKED;
-	}
-
-	if (!(flags & O_DIRECT)) {
-		flags |= O_DIRECT;
-		if (fcntl(fd,F_SETFL,flags) < 0) {
+		memset(&ct->io, 0, sizeof(struct iocb));
+		io_prep_pread(&ct->io, fd, ct->ptr, ct->blksize, 0);
+		if (io_submit(ct->ioctx, 1, ios) != 1)
 			return PATH_UNCHECKED;
-		}
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
-	} else {
-		retval = PATH_UP;
-	}
-	
-	if (reset_flags) {
-		flags &= ~O_DIRECT;
-		/* No point in checking for errors */
-		fcntl(fd,F_SETFL,flags);
+	res = io_getevents(ct->ioctx, 1L, 1L, &event, &timeout);
+	if (res < 1L)
+		retval = PATH_DOWN;
+	else {
+		ct->running = 0;
+		retval = (event.res == ct->blksize) ? PATH_UP : PATH_DOWN;
 	}
 
 	return retval;
@@ -119,7 +140,10 @@ int directio (struct checker * c)
 	int ret;
 	struct directio_context * ct = (struct directio_context *)c->context;
 
-	ret = direct_read(c->fd, ct->ptr, ct->blksize);
+	if (!ct)
+		return PATH_UNCHECKED;
+
+	ret = check_state(c->fd, ct);
 
 	switch (ret)
 	{

--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--3MwIy2ne0vdjdPXF--
