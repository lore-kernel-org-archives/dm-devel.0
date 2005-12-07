From: Hannes Reinecke <hare@suse.de>
Subject: [kpartx] Use lseek64 instead of self-defined syscall
Date: Wed, 07 Dec 2005 15:46:55 +0100
Message-ID: <4396F5DF.9090105@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000408000601040002060309"
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
To: christophe varoqui <christophe.varoqui@free.fr>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------000408000601040002060309
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Christophe,

this patch enables kpartx to use lseek64 instead of a self-defined syscal=
l.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de

--------------000408000601040002060309
Content-Type: text/x-patch;
 name="kpartx-use-lseek64.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="kpartx-use-lseek64.patch"

[kpartx] use lseek64 instead of self-defined syscall.

---
commit 400137e766f9585ae5d9038ce769810757e3b344
tree 0a9974d358e0f6443e23794b1f37b0609987f249
parent d43d7b77542d8459c30f82062f5c76954f124062
author Hannes Reinecke,SUSE LINUX GmbH; Maxfeldstrasse 5; D-90409 Nuernberg; Zi. 2.2-20,+49-911-740 53-688,,serv=wotan,mail=imap-dhs,type=real <hare@lammermuir.suse.de> Wed, 07 Dec 2005 15:44:56 +0100
committer Hannes Reinecke,SUSE LINUX GmbH; Maxfeldstrasse 5; D-90409 Nuernberg; Zi. 2.2-20,+49-911-740 53-688,,serv=wotan,mail=imap-dhs,type=real <hare@lammermuir.suse.de> Wed, 07 Dec 2005 15:44:56 +0100

 kpartx/Makefile |    2 +-
 kpartx/kpartx.c |   19 +++----------------
 2 files changed, 4 insertions(+), 17 deletions(-)

diff --git a/kpartx/Makefile b/kpartx/Makefile
--- a/kpartx/Makefile
+++ b/kpartx/Makefile
@@ -6,7 +6,7 @@ BUILD=glibc
 
 include ../Makefile.inc
 
-CFLAGS = -pipe -g -Wall -Wunused -Wstrict-prototypes -I.
+CFLAGS = -pipe -g -Wall -Wunused -Wstrict-prototypes -I. -D_LARGEFILE64_SOURCE
 
 ifeq ($(strip $(BUILD)),klibc)
 	OBJS = bsd.o dos.o kpartx.o solaris.o unixware.o gpt.o crc32.o \
diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -465,27 +465,14 @@ xmalloc (size_t size) {
 /*
  * sseek: seek to specified sector
  */
-#if !defined (__alpha__) && !defined (__ia64__) && !defined (__x86_64__) \
-	&& !defined (__s390x__)
-#include <linux/unistd.h>       /* _syscall */
-static
-_syscall5(int,  _llseek,  uint,  fd, ulong, hi, ulong, lo,
-	  long long *, res, uint, wh);
-#endif
 
 static int
 sseek(int fd, unsigned int secnr) {
-	long long in, out;
-	in = ((long long) secnr << 9);
+	off64_t in, out;
+	in = ((off64_t) secnr << 9);
 	out = 1;
 
-#if !defined (__alpha__) && !defined (__ia64__) && !defined (__x86_64__) \
-	&& !defined (__s390x__)
-	if (_llseek (fd, in>>32, in & 0xffffffff, &out, SEEK_SET) != 0
-	    || out != in)
-#else
-	if ((out = lseek(fd, in, SEEK_SET)) != in)
-#endif
+	if ((out = lseek64(fd, in, SEEK_SET)) != in)
 	{
 		fprintf(stderr, "llseek error\n");
 		return -1;

--------------000408000601040002060309
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------000408000601040002060309--
