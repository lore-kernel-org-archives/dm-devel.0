From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] multipath-tools: Fix Makefile for libmultipath
Date: Mon, 13 Mar 2006 13:22:51 +0100
Message-ID: <4415641B.3030706@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050804050304050901050108"
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------050804050304050901050108
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Christophe,

libmultipath/Makefile resets CFLAGS, so we can't pass anything from the
top-level makefile.
The attached patch corrects this.

Please apply.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de

--------------050804050304050901050108
Content-Type: text/x-patch;
 name="multipath-tools-Makefile-cleanup.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="multipath-tools-Makefile-cleanup.patch"

diff --git a/libmultipath/Makefile b/libmultipath/Makefile
index 8a14b04..e5d5b10 100644
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -6,7 +6,7 @@ BUILD = glibc
 
 include ../Makefile.inc
 
-CFLAGS = -I$(checkersdir)
+CFLAGS += -I$(checkersdir)
 
 OBJS = memory.o parser.o vector.o devmapper.o callout.o \
        hwtable.o blacklist.o util.o dmparser.o config.o \

--------------050804050304050901050108
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------050804050304050901050108--
