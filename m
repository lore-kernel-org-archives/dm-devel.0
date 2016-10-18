From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: integrate Changelog file in
	README and update it
Date: Wed, 19 Oct 2016 01:34:22 +0200
Message-ID: <20161018233422.5001-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
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
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

and httpS for everyone.

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 ChangeLog |  6 ------
 README    | 38 ++++++++++++++++++++++++++++----------
 2 files changed, 28 insertions(+), 16 deletions(-)
 delete mode 100644 ChangeLog

diff --git a/ChangeLog b/ChangeLog
deleted file mode 100644
index 4b547bb..0000000
--- a/ChangeLog
+++ /dev/null
@@ -1,6 +0,0 @@
-Change logs are at :
-
-- pre-0.4.5
-  http://web.archive.org/web/20070309224034/http://christophe.varoqui.free.fr/wiki/wakka.php?wiki=ChangeLog
-- post-0.4.5
-  http://git.opensvc.com/?p=multipath-tools/.git;a=log
diff --git a/README b/README
index 77b79b8..a18b325 100644
--- a/README
+++ b/README
@@ -1,8 +1,8 @@
-multipath-tools for Linux <http://christophe.varoqui.free.fr/>
+	multipath-tools for Linux <http://christophe.varoqui.free.fr/>
 
 
-This package provides the following binaries to drive the
-Device Mapper multipathing driver:
+This package provides the following binaries to drive the Device Mapper
+multipathing driver:
 
 multipath - Device mapper target autoconfig.
 multipathd - Multipath daemon.
@@ -10,20 +10,38 @@ mpathpersist - Manages SCSI persistent reservations on dm multipath devices.
 kpartx - Create device maps from partition tables.
 
 
-tarballs are not generated anymore, to get a specific release do:
-git clone http://git.opensvc.com/multipath-tools/.git
+Releases
+========
+Tarballs are not generated anymore, to get a specific release do:
+git clone https://git.opensvc.com/multipath-tools/.git
 cd multipath-tools
 git tag
 git archive --format=tar.gz --prefix=multipath-tools-X.Y.Z/ X.Y.Z > ../multipath-tools-X.Y.Z.tar.gz
 
 Alternatively it may be obtained from gitweb, go to:
-http://git.opensvc.com/?p=multipath-tools/.git;a=tags
+https://git.opensvc.com/?p=multipath-tools/.git;a=tags
 select a release-tag and then click on "snapshot".
 
 
-To get latest devel code: git clone http://git.opensvc.com/multipath-tools/.git
+Source code
+===========
+To get latest devel code: git clone https://git.opensvc.com/multipath-tools/.git
+Gitweb: https://git.opensvc.com/?p=multipath-tools/.git
 
-Mailing list: http://www.redhat.com/mailman/listinfo/dm-devel
-Gitweb: http://git.opensvc.com/?p=multipath-tools/.git
 
-Current maintainer is Christophe Varoqui <christophe.varoqui@opensvc.com>
+Mailing list (subscribers-only)
+============
+To subscribe and archives: https://www.redhat.com/mailman/listinfo/dm-devel
+Searchable: https://marc.info/?l=dm-devel
+
+
+Changelog
+=========
+pre-0.4.5: https://web.archive.org/web/20070309224034/http://christophe.varoqui.free.fr/wiki/wakka.php?wiki=ChangeLog
+post-0.4.5: https://git.opensvc.com/?p=multipath-tools/.git;a=log
+
+
+Maintainer
+==========
+Christophe Varoqui <christophe.varoqui@opensvc.com>
+Device-mapper development mailing list <dm-devel@redhat.com>
-- 
2.10.1
