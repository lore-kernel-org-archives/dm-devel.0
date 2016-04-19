From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: update docs
Date: Tue, 19 Apr 2016 17:35:06 +0200
Message-ID: <1461080106-18818-1-git-send-email-xose.vazquez@gmail.com>
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

removes TODO, adds meaningful information to README
and replaces dead urls in ChangeLog.

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 ChangeLog |  4 ++--
 README    | 15 ++++++++++++++-
 TODO      |  1 -
 3 files changed, 16 insertions(+), 4 deletions(-)
 delete mode 100644 TODO

diff --git a/ChangeLog b/ChangeLog
index 73026b3..4b547bb 100644
--- a/ChangeLog
+++ b/ChangeLog
@@ -1,6 +1,6 @@
 Change logs are at :
 
 - pre-0.4.5
-  http://christophe.varoqui.free.fr/wiki/wakka.php?wiki=ChangeLog
+  http://web.archive.org/web/20070309224034/http://christophe.varoqui.free.fr/wiki/wakka.php?wiki=ChangeLog
 - post-0.4.5
-  http://www.kernel.org/git/gitweb.cgi?p=linux/storage/multipath-tools/.git;a=log
+  http://git.opensvc.com/?p=multipath-tools/.git;a=log
diff --git a/README b/README
index b0b9dfa..1914e38 100644
--- a/README
+++ b/README
@@ -1 +1,14 @@
-Things to read
+multipath-tools for Linux <http://christophe.varoqui.free.fr/>
+
+This package provides the following binaries to drive the
+Device Mapper multipathing driver:
+
+multipath - Device mapper target autoconfig.
+multipathd - Multipath daemon.
+mpathpersist - Manages SCSI persistent reservations on dm multipath devices.
+kpartxrtx - Create device maps from partition tables.
+
+To get latest code: git clone http://git.opensvc.com/multipath-tools/.git
+
+Mailing list: http://www.redhat.com/mailman/listinfo/dm-devel
+Gitweb: http://git.opensvc.com/?p=multipath-tools/.git
diff --git a/TODO b/TODO
deleted file mode 100644
index 690ea03..0000000
--- a/TODO
+++ /dev/null
@@ -1 +0,0 @@
-Things to do
-- 
2.5.5
