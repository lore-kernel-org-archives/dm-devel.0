From: Phileas Fogg <phileas-fogg@mail.ru>
Subject: [PATCH] Fix gzip path in Makefile.inc
Date: Thu, 21 Feb 2013 23:47:22 +0100
Message-ID: <5126A3FA.8070807@mail.ru>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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


Hi,

i would like to submit a patch which fixes the path to gzip in Makefile.inc
Makefile.inc uses the absolute path /bin/gzip which isn't valid on all Linux 
distros. E.g. on Arch Linux which i'm cuurrently using the gzip tool is 
installed in /usr/bin/gzip. The patch fixes the build problem on Linux distros 
which do not have gzip in /bin directory.

 From fe391d79dd3361ba2714ac016b755fea0c9217eb Mon Sep 17 00:00:00 2001
From: glevand <geoffrey.levand@mail.ru>
Date: Thu, 21 Feb 2013 23:42:39 +0100
Subject: [PATCH] fix gzip path

---
  Makefile.inc | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile.inc b/Makefile.inc
index b0c68f4..92d2289 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -35,7 +35,7 @@ libdir	    = $(prefix)/$(LIB)/multipath
  unitdir     = $(prefix)/lib/systemd/system
  mpathpersistdir = $(TOPDIR)/libmpathpersist

-GZIP        = /bin/gzip -9 -c
+GZIP        = gzip -9 -c
  INSTALL_PROGRAM = install

  ifndef RPM_OPT_FLAGS
-- 
1.8.1.3
