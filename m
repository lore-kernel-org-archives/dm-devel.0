From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: fix a format warning in
	multipathd.8
Date: Fri, 26 May 2017 18:19:20 +0200
Message-ID: <20170526161920.8407-1-xose.vazquez@gmail.com>
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

warning: macro `list' not defined

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 multipathd/multipathd.8 | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/multipathd/multipathd.8 b/multipathd/multipathd.8
index 4c765af..2615728 100644
--- a/multipathd/multipathd.8
+++ b/multipathd/multipathd.8
@@ -121,8 +121,7 @@ Show the current multipath topology. Same as '\fImultipath \-ll\fR'.
 .TP
 .B list|show map|multipath $map topology
 Show topology of a single multipath device specified by $map, for example
-36005076303ffc56200000000000010aa. This map could be obtained from
-'\fIlist maps\fR'.
+36005076303ffc56200000000000010aa. This map could be obtained from '\fIlist maps\fR'.
 .
 .TP
 .B list|show wildcards
-- 
2.13.0
