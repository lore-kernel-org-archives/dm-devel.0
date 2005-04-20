From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: release 0.4.4 ?
Date: Wed, 20 Apr 2005 16:26:37 +0200
Message-ID: <20050420142637.GA29071@marowsky-bree.de>
References: <1113731446.24817.4.camel@zezette>
	<1113953571.24817.97.camel@zezette>
	<20050420133116.GW29071@marowsky-bree.de>
	<1114006824.24817.108.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="HWvPVVuAAfuRc6SZ"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1114006824.24817.108.camel@zezette>
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


--HWvPVVuAAfuRc6SZ
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2005-04-20T16:20:23, christophe varoqui <christophe.varoqui@free.fr> w=
rote:

> > -pre16 /sbin/multipath doesn't create _any_ mapping for me.
> Not funny.

Not very ;-)

> I guess I'll setup the OSDL environment now, for testing and debugging.
> Hope to be able to diagnose in a few hours.

Well, I forgot to attach a patch last time. Here we go. Also initializes
pp_emc so that the sense buffer doesn't contain crap.


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business


--HWvPVVuAAfuRc6SZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="multipath-tools-fixes.patch"

diff -ru multipath-tools-0.4.4-pre16.old/libmultipath/cache.h multipath-tools-0.4.4-pre16/libmultipath/cache.h
--- multipath-tools-0.4.4-pre16.old/libmultipath/cache.h	2005-04-20 01:09:06.000000000 +0200
+++ multipath-tools-0.4.4-pre16/libmultipath/cache.h	2005-04-20 16:05:04.859208723 +0200
@@ -1,5 +1,5 @@
-#define CACHE_FILE	"/var/cache/multipath/.multipath.cache"
-#define CACHE_TMPFILE	"/var/cache/multipath/.multipath.cache.tmp"
+#define CACHE_FILE	"/dev/.multipath.cache"
+#define CACHE_TMPFILE	"/dev/.multipath.cache.tmp"
 #define CACHE_EXPIRE	5
 #define MAX_WAIT	5
 
Only in multipath-tools-0.4.4-pre16/libmultipath: cache.h~
diff -ru multipath-tools-0.4.4-pre16.old/libmultipath/hwtable.c multipath-tools-0.4.4-pre16/libmultipath/hwtable.c
--- multipath-tools-0.4.4-pre16.old/libmultipath/hwtable.c	2005-04-18 21:27:41.000000000 +0200
+++ multipath-tools-0.4.4-pre16/libmultipath/hwtable.c	2005-04-20 16:04:13.538010731 +0200
@@ -36,11 +36,11 @@
 	r += store_hwe_ext(hw, "DGC", "*", GROUP_BY_PRIO, DEFAULT_GETUID,
 		   "/sbin/pp_emc /dev/%n", "1 emc", "0", "emc_clariion");
 	r += store_hwe_ext(hw, "IBM", "3542", GROUP_BY_SERIAL, DEFAULT_GETUID,
-		   NULL, "0", "0", "tur");
+		   "/bin/false", "0", "0", "tur");
 	r += store_hwe_ext(hw, "SGI", "TP9400", MULTIBUS, DEFAULT_GETUID,
-		   NULL, "0", "0", "tur");
+		   "/bin/false", "0", "0", "tur");
 	r += store_hwe_ext(hw, "SGI", "TP9500", FAILOVER, DEFAULT_GETUID,
-		   NULL, "0", "0", "tur");
+		   "/bin/false", "0", "0", "tur");
 
 	return r;
 }
diff -ru multipath-tools-0.4.4-pre16.old/multipath/Makefile multipath-tools-0.4.4-pre16/multipath/Makefile
--- multipath-tools-0.4.4-pre16.old/multipath/Makefile	2005-04-20 01:08:37.000000000 +0200
+++ multipath-tools-0.4.4-pre16/multipath/Makefile	2005-04-20 16:04:42.961537675 +0200
@@ -43,7 +43,6 @@
 install:
 	install -d $(DESTDIR)$(bindir)
 	install -m 755 $(EXEC) $(DESTDIR)$(bindir)/
-	install -d $(DESTDIR)/var/cache/multipath/
 	install -d $(DESTDIR)/etc/dev.d/block/
 	install -m 755 multipath.dev $(DESTDIR)/etc/dev.d/block/
 	install -d $(DESTDIR)/etc/udev/rules.d
diff -ru multipath-tools-0.4.4-pre16.old/libcheckers/emc_clariion.c multipath-tools-0.4.4-pre16/libcheckers/emc_clariion.c
--- multipath-tools-0.4.4-pre16.old/libcheckers/emc_clariion.c	2005-04-11 16:54:47.000000000 +0200
+++ multipath-tools-0.4.4-pre16/libcheckers/emc_clariion.c	2005-04-20 16:23:12.376089751 +0200
@@ -25,8 +25,8 @@
 
 int emc_clariion(int fd, char *msg, void **context)
 {
-	unsigned char sense_buffer[256];
-	unsigned char sb[128];
+	unsigned char sense_buffer[256] = { 0, };
+	unsigned char sb[128] = { 0, };
 	unsigned char inqCmdBlk[INQUIRY_CMDLEN] = {INQUIRY_CMD, 1, 0xC0, 0,
 						sizeof(sb), 0};
 	struct sg_io_hdr io_hdr;

--HWvPVVuAAfuRc6SZ
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--HWvPVVuAAfuRc6SZ--
