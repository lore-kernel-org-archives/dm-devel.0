From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 3/4] multipath-tools: remove ChangeLog README
	from kpartx dir
Date: Wed, 27 Apr 2016 17:14:33 +0200
Message-ID: <1461770074-13428-3-git-send-email-xose.vazquez@gmail.com>
References: <1461770074-13428-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1461770074-13428-1-git-send-email-xose.vazquez@gmail.com>
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

Right now this information is irrelevant.

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 kpartx/ChangeLog | 9 ---------
 kpartx/README    | 9 ---------
 2 files changed, 18 deletions(-)
 delete mode 100644 kpartx/ChangeLog
 delete mode 100644 kpartx/README

diff --git a/kpartx/ChangeLog b/kpartx/ChangeLog
deleted file mode 100644
index cd0c6c1..0000000
--- a/kpartx/ChangeLog
+++ /dev/null
@@ -1,9 +0,0 @@
-002:
-* convert to kpartx name everywhere
-* remove all HDGEO ioctl code
-* now work with files by mapping loops on the fly
-* merged and massage lopart.[ch] from lomount.[ch]
-  (due credit to original author here : hpa ?)
-* added a fn find_loop_by_file in lopart.[ch]
-001:
-* Initial release
diff --git a/kpartx/README b/kpartx/README
deleted file mode 100644
index e0680b1..0000000
--- a/kpartx/README
+++ /dev/null
@@ -1,9 +0,0 @@
-This version of partx is intented to be build 
-static against klibc.
-
-It creates partitions as device maps.
-
-With due respect to the original authors,
-
-have fun,
-cvaroqui
-- 
2.5.5
