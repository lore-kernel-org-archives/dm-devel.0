From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 1/4] multipath-tools: move AUTHOR to README
Date: Wed, 27 Apr 2016 17:14:31 +0200
Message-ID: <1461770074-13428-1-git-send-email-xose.vazquez@gmail.com>
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

move AUTHOR content to README and delete it

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 AUTHOR | 1 -
 README | 2 ++
 2 files changed, 2 insertions(+), 1 deletion(-)
 delete mode 100644 AUTHOR

diff --git a/AUTHOR b/AUTHOR
deleted file mode 100644
index e55a659..0000000
--- a/AUTHOR
+++ /dev/null
@@ -1 +0,0 @@
-Christophe Varoqui, <christophe.varoqui@opensvc.com>
diff --git a/README b/README
index 1914e38..89d5e19 100644
--- a/README
+++ b/README
@@ -12,3 +12,5 @@ To get latest code: git clone http://git.opensvc.com/multipath-tools/.git
 
 Mailing list: http://www.redhat.com/mailman/listinfo/dm-devel
 Gitweb: http://git.opensvc.com/?p=multipath-tools/.git
+
+Current maintainer is Christophe Varoqui <christophe.varoqui@opensvc.com>
-- 
2.5.5
