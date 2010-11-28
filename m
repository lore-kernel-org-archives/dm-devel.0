From: Tim Harder <radhermit@gentoo.org>
Subject: [PATCH] libmultipath: fix snprintf buffer overflows
Date: Sun, 28 Nov 2010 13:12:30 -0800
Message-ID: <20101128211230.GB7136@freyja.radhermit.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="cNdxnHkX5QqsyA0e"
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi,

I've attached a patch against the latest git version of multipath-tools
to fix a couple snprintf buffer overflows. 

Thanks,
Tim

--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment;
	filename="0001-libmultipath-fix-snprintf-buffer-overflows.patch"

From 2d51194853342ba24f3b76e9343b8467a8e55400 Mon Sep 17 00:00:00 2001
From: Tim Harder <radhermit@gentoo.org>
Date: Sun, 28 Nov 2010 12:37:08 -0800
Subject: [PATCH] libmultipath: fix snprintf buffer overflows

---
 libmultipath/prioritizers/datacore.c |    2 +-
 libmultipath/prioritizers/hds.c      |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/prioritizers/datacore.c b/libmultipath/prioritizers/datacore.c
index 6b7b202..2c16c6c 100644
--- a/libmultipath/prioritizers/datacore.c
+++ b/libmultipath/prioritizers/datacore.c
@@ -94,7 +94,7 @@ int datacore_prio (const char *dev, int sg_fd, char * args)
 	if ((io_hdr.info & SG_INFO_OK_MASK) != SG_INFO_OK)
 		return 0;
 
-	snprintf(vendor, 9, "%.8s\n", inqBuffp + 8);
+	snprintf(vendor, 8, "%.8s\n", inqBuffp + 8);
 	snprintf(product, 17, "%.16s", inqBuffp + 16);
 	snprintf(luname, 21, "%.19s", inqBuffp + 36);
 	snprintf(wwpn, 17, "%.16s", inqBuffp + 96);
diff --git a/libmultipath/prioritizers/hds.c b/libmultipath/prioritizers/hds.c
index 7b354b2..4789340 100644
--- a/libmultipath/prioritizers/hds.c
+++ b/libmultipath/prioritizers/hds.c
@@ -123,7 +123,7 @@ int hds_modular_prio (const char *dev, int fd)
 		return -1;
 	}
 
-	snprintf (vendor, 9, "%.8s", inqBuffp + 8);
+	snprintf (vendor, 8, "%.8s", inqBuffp + 8);
 	snprintf (product, 17, "%.16s", inqBuffp + 16);
 	snprintf (serial, 5, "%.4s", inqBuffp + 40);
 	snprintf (ldev, 5, "%.4s", inqBuffp + 44);
-- 
1.7.3.2


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--cNdxnHkX5QqsyA0e--
