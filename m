From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: tarballs are not generated
	anymore
Date: Thu,  2 Jun 2016 14:47:09 +0200
Message-ID: <1464871629-5370-1-git-send-email-xose.vazquez@gmail.com>
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

Add info how to get a specific release from git.

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 README | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/README b/README
index a81666c..25a194e 100644
--- a/README
+++ b/README
@@ -1,5 +1,6 @@
 multipath-tools for Linux <http://christophe.varoqui.free.fr/>
 
+
 This package provides the following binaries to drive the
 Device Mapper multipathing driver:
 
@@ -8,7 +9,15 @@ multipathd - Multipath daemon.
 mpathpersist - Manages SCSI persistent reservations on dm multipath devices.
 kpartx - Create device maps from partition tables.
 
-To get latest code: git clone http://git.opensvc.com/multipath-tools/.git
+
+tarballs are not generated anymore, to get a specific release do:
+git clone http://git.opensvc.com/multipath-tools/.git
+cd multipath-tools
+git tag
+git archive --format=tar.gz --prefix=multipath-tools-X.Y.Z/ X.Y.Z > ../multipath-tools-X.Y.Z.tar.gz
+
+
+To get latest devel code: git clone http://git.opensvc.com/multipath-tools/.git
 
 Mailing list: http://www.redhat.com/mailman/listinfo/dm-devel
 Gitweb: http://git.opensvc.com/?p=multipath-tools/.git
-- 
2.5.5
