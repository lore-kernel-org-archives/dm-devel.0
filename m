From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: compiling Multipath-tools on RHE4 .
Date: Tue, 22 Mar 2005 22:50:24 +0000
Message-ID: <20050322225024.GQ19749@agk.surrey.redhat.com>
References: <1111522135.29700.8.camel@localhost>
	<1111531414.7024.17.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="ew6BAiZeqk4r7MaW"
Content-Disposition: inline
In-Reply-To: <1111531414.7024.17.camel@zezette>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Patches I needed to build 4.2 attached.
Pick the right one for your architecture.


Patch0: old_dev_t_long.patch
Patch1: old_dev_t_int.patch
Patch2: old_dev_t_short.patch


%ifarch ppc64 x86_64
%patch0 -p1
%endif
 
%ifarch ppc ia64
%patch1 -p1
%endif
 
%ifarch i386 s390 s390x
%patch2 -p1
%endif


Alasdair
-- 
agk@redhat.com

--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="makefile.patch"

diff -ru multipath-tools-0.4.2-new1/kpartx/Makefile multipath-tools-0.4.2/kpartx/Makefile
--- multipath-tools-0.4.2-new1/kpartx/Makefile	2005-01-23 22:48:05.000000000 +0000
+++ multipath-tools-0.4.2/kpartx/Makefile	2005-03-02 19:24:56.000000000 +0000
@@ -29,7 +29,6 @@
 glibc: prepare $(OBJS)
 	$(CC) $(OBJS) -o $(EXEC) $(LDFLAGS)
 	$(STRIP) $(EXEC)
-	$(GZIP) $(EXEC).8 > $(EXEC).8.gz
 	
 klibc: prepare $(KLIBC) $(OBJS)
 	$(LD) -o $(EXEC) $(CRT0) $(OBJS) $(KLIBC) $(LIBGCC)
@@ -51,7 +50,7 @@
 	install -d $(DESTDIR)$(bindir)
 	install -m 755 $(EXEC) $(DESTDIR)$(bindir)
 	install -d $(DESTDIR)$(mandir)
-	install -m 644 $(EXEC).8.gz $(DESTDIR)$(mandir)
+	install -m 644 $(EXEC).8 $(DESTDIR)$(mandir)
 
 uninstall:
 	rm -f $(DESTDIR)$(bindir)/$(EXEC)
diff -ru multipath-tools-0.4.2-new1/Makefile multipath-tools-0.4.2/Makefile
--- multipath-tools-0.4.2-new1/Makefile	2005-03-02 18:39:00.000000000 +0000
+++ multipath-tools-0.4.2/Makefile	2005-03-02 19:18:01.000000000 +0000
@@ -12,11 +12,11 @@
 		    devmap_name multipath multipathd kpartx
 else
 	BUILDDIRS = libmultipath libcheckers path_priority \
-		    devmap_name multipath multipathd kpartx
+		    multipath multipathd kpartx
 endif
 
 VERSION = $(shell basename ${PWD} | cut -d'-' -f3)
-INSTALLDIRS = devmap_name multipath multipathd kpartx path_priority
+INSTALLDIRS = multipath multipathd kpartx path_priority
 
 all: recurse
 
diff -ru multipath-tools-0.4.2-new1/multipath/Makefile multipath-tools-0.4.2/multipath/Makefile
--- multipath-tools-0.4.2-new1/multipath/Makefile	2005-01-23 22:48:05.000000000 +0000
+++ multipath-tools-0.4.2/multipath/Makefile	2005-03-02 19:24:06.000000000 +0000
@@ -31,7 +31,6 @@
 glibc: prepare $(OBJS)
 	$(CC) $(OBJS) -o $(EXEC) $(LDFLAGS)
 	$(STRIP) $(EXEC)
-	$(GZIP) $(EXEC).8 > $(EXEC).8.gz
 	
 klibc: prepare $(KLIBC) $(OBJS)
 	$(LD) -o $(EXEC) $(CRT0) $(OBJS) $(KLIBC) $(LIBGCC)
@@ -58,16 +57,10 @@
 install:
 	install -d $(DESTDIR)$(bindir)
 	install -m 755 $(EXEC) $(DESTDIR)$(bindir)/
-	install -d $(DESTDIR)/etc/dev.d/block/
-	install -m 755 multipath.dev $(DESTDIR)/etc/dev.d/block/
-	install -d $(DESTDIR)/etc/udev/rules.d
-	install -m 755 multipath.rules $(DESTDIR)/etc/udev/rules.d/
 	install -d $(DESTDIR)$(mandir)
-	install -m 644 $(EXEC).8.gz $(DESTDIR)$(mandir)
+	install -m 644 $(EXEC).8 $(DESTDIR)$(mandir)
 
 uninstall:
-	rm $(DESTDIR)/etc/dev.d/block/multipath.dev
-	rm $(DESTDIR)/etc/udev/rules.d/multipath.rules
 	rm $(DESTDIR)$(bindir)/$(EXEC)
 	rm $(DESTDIR)$(mandir)/$(EXEC).8.gz
 
diff -ru multipath-tools-0.4.2-new1/multipathd/Makefile multipath-tools-0.4.2/multipathd/Makefile
--- multipath-tools-0.4.2-new1/multipathd/Makefile	2005-01-23 22:48:05.000000000 +0000
+++ multipath-tools-0.4.2/multipathd/Makefile	2005-03-02 19:24:29.000000000 +0000
@@ -42,7 +42,6 @@
 $(EXEC): $(OBJS)
 	$(CC) $(OBJS) -o $(EXEC) $(LDFLAGS)
 	strip $(EXEC)
-	$(GZIP) $(EXEC).8 > $(EXEC).8.gz
 
 $(CHECKERSLIB)-glibc.a:
 	$(MAKE) -C $(checkersdir) BUILD=glibc glibc
@@ -56,7 +55,7 @@
 	install -d $(DESTDIR)$(rcdir)
 	install -m 755 multipathd.init $(DESTDIR)$(rcdir)/$(EXEC)
 	install -d $(DESTDIR)$(mandir)
-	install -m 644 $(EXEC).8.gz $(DESTDIR)$(mandir)
+	install -m 644 $(EXEC).8 $(DESTDIR)$(mandir)
 
 uninstall:
 	rm -f $(DESTDIR)$(bindir)/$(EXEC)

--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="old_dev_t_int.patch"

--- multipath-tools-0.4.2/kpartx/loop.h	2005-01-23 22:48:06.000000000 +0000
+++ multipath-tools-0.4.2-new/kpartx/loop.h	2005-03-02 18:16:06.000000000 +0000
@@ -79,9 +79,9 @@
 /* Backwards compatibility version */
 struct loop_info {
 	int		   lo_number;		/* ioctl r/o */
-	__kernel_old_dev_t lo_device; 		/* ioctl r/o */
+	unsigned int	   lo_device; 		/* ioctl r/o */
 	unsigned long	   lo_inode; 		/* ioctl r/o */
-	__kernel_old_dev_t lo_rdevice; 		/* ioctl r/o */
+	unsigned int	   lo_rdevice; 		/* ioctl r/o */
 	int		   lo_offset;
 	int		   lo_encrypt_type;
 	int		   lo_encrypt_key_size; 	/* ioctl w/o */

--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="old_dev_t_long.patch"

--- multipath-tools-0.4.2/kpartx/loop.h	2005-01-23 22:48:06.000000000 +0000
+++ multipath-tools-0.4.2-new/kpartx/loop.h	2005-03-02 18:16:06.000000000 +0000
@@ -79,9 +79,9 @@
 /* Backwards compatibility version */
 struct loop_info {
 	int		   lo_number;		/* ioctl r/o */
-	__kernel_old_dev_t lo_device; 		/* ioctl r/o */
+	unsigned long	   lo_device; 		/* ioctl r/o */
 	unsigned long	   lo_inode; 		/* ioctl r/o */
-	__kernel_old_dev_t lo_rdevice; 		/* ioctl r/o */
+	unsigned long	   lo_rdevice; 		/* ioctl r/o */
 	int		   lo_offset;
 	int		   lo_encrypt_type;
 	int		   lo_encrypt_key_size; 	/* ioctl w/o */

--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="old_dev_t_short.patch"

--- multipath-tools-0.4.2/kpartx/loop.h	2005-01-23 22:48:06.000000000 +0000
+++ multipath-tools-0.4.2-new/kpartx/loop.h	2005-03-02 18:16:06.000000000 +0000
@@ -79,9 +79,9 @@
 /* Backwards compatibility version */
 struct loop_info {
 	int		   lo_number;		/* ioctl r/o */
-	__kernel_old_dev_t lo_device; 		/* ioctl r/o */
+	unsigned short	   lo_device; 		/* ioctl r/o */
 	unsigned long	   lo_inode; 		/* ioctl r/o */
-	__kernel_old_dev_t lo_rdevice; 		/* ioctl r/o */
+	unsigned short	   lo_rdevice; 		/* ioctl r/o */
 	int		   lo_offset;
 	int		   lo_encrypt_type;
 	int		   lo_encrypt_key_size; 	/* ioctl w/o */

--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--ew6BAiZeqk4r7MaW--
