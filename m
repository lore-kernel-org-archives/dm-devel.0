From: Martin Michlmayr <tbm@cyrius.com>
Subject: Re: Bug#403426: kernel corrupts LUKS partition header on
	arm
Date: Fri, 29 Dec 2006 17:38:28 +0100
Message-ID: <20061229163828.GA24234@deprecation.cyrius.com>
References: <20061217022906.2434.60658.reportbug@LKG8A754B.example.org>
	<20061220161529.GA10820@deprecation.cyrius.com>
	<87lkkrgej4.wl%clemens@endorphin.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <87lkkrgej4.wl%clemens@endorphin.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Clemens Fruhwirth <clemens@endorphin.org>
Cc: 403426@bugs.debian.org, dm-devel@redhat.com, Brian Brunswick <bdb-reportbug@forbidden.co.uk>
List-Id: dm-devel.ids

* Clemens Fruhwirth <clemens@endorphin.org> [2006-12-29 11:52]:
> I just added the r!=bsize case to error checking and an error message
> as well.
...
> The changes are also in subversion.

This particular change didn't make any difference.  I still get the
header conversion message when I only apply the patch from utils.c.


#! /bin/sh /usr/share/dpatch/dpatch-run
## 02_fix_arm.dpatch by Clemens Fruhwirth <clemens@endorphin.org>
##
## DP: Add error checking to read_blockwise for short reads.
## DP: Commit a patch that fixes http://bugs.debian.org/403075

@DPATCH@
Index: lib/utils.c
===================================================================
--- cryptsetup-1.0.4~/lib/utils.c	(revision 1)
+++ cryptsetup-1.0.4/lib/utils.c	(working copy)
@@ -151,8 +151,10 @@
 static int sector_size(int fd) 
 {
 	int bsize;
-	ioctl(fd,BLKSSZGET, &bsize);
-	return bsize;
+	if (ioctl(fd,BLKSSZGET, &bsize) < 0)
+		return -EINVAL;
+	else
+		return bsize;
 }
 
 int sector_size_for_device(const char *device)
@@ -171,8 +173,11 @@
 	char *padbuf; char *padbuf_base;
 	char *buf = (char *)orig_buf;
 	int r;
-	int hangover; int solid; int bsize = sector_size(fd);
+	int hangover; int solid; int bsize;
 
+	if ((bsize = sector_size(fd)) < 0)
+		return bsize;
+
 	hangover = count % bsize;
 	solid = count - hangover;
 
@@ -209,15 +214,20 @@
 	char *buf = (char *)orig_buf;
 	int r;
 	int step;
-	int bsize = sector_size(fd);
+	int bsize;
 
+	if ((bsize = sector_size(fd)) < 0)
+		return bsize;
+
 	padbuf = aligned_malloc(&padbuf_base, bsize, bsize);
 	if(padbuf == NULL) return -ENOMEM;
 
 	while(count) {
 		r = read(fd,padbuf,bsize);
-		if(r < 0) goto out;
-		
+		if(r < 0 || r != bsize) {
+			fprintf(stderr, "read failed in read_blockwise.\n");
+			goto out;
+		}
 		step = count<bsize?count:bsize;
 		memcpy(buf,padbuf,step);
 		buf += step;
@@ -242,6 +252,9 @@
 	int frontHang = offset % bsize;
 	int r;
 
+	if (bsize < 0)
+		return bsize;
+
 	lseek(fd, offset - frontHang, SEEK_SET);
 	if(offset % bsize) {
 		int innerCount = count<bsize?count:bsize;

-- 
Martin Michlmayr
http://www.cyrius.com/
