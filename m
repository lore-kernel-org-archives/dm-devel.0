From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: correct a syntax error in
	multipath.conf.5
Date: Tue, 14 Jun 2016 19:52:50 +0200
Message-ID: <1465926770-28323-1-git-send-email-xose.vazquez@gmail.com>
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

$ groff -z -b -wall ./multipath/multipath.conf.5
./multipath/multipath.conf.5:519: warning: macro `timeout' not defined (possibly missing space after `ti')

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 multipath/multipath.conf.5 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 2ff88c4..d24f6fe 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -516,7 +516,7 @@ Default is
 CLI receive timeout in milliseconds. For larger systems CLI commands
 might timeout before the multipathd lock is released and the CLI command
 can be processed. This will result in errors like
-'timeout receiving packet' to be returned from CLI commands.
+"timeout receiving packet" to be returned from CLI commands.
 In these cases it is recommended to increase the CLI timeout to avoid
 those issues. The default is
 .I 1000
-- 
2.5.5
