From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: fix help for hds prio
Date: Mon, 21 May 2018 22:03:55 +0200
Message-ID: <20180521200355.27364-1-xose.vazquez@gmail.com>
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
Cc: DM-DEV ML <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEV ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 multipath/multipath.conf.5 | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index f689795..af5e109 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -8,7 +8,7 @@
 .\"
 .\" ----------------------------------------------------------------------------
 .
-.TH MULTIPATH.CONF 5 2017-08-18 Linux
+.TH MULTIPATH.CONF 5 2018-05-21 Linux
 .
 .
 .\" ----------------------------------------------------------------------------
@@ -309,7 +309,7 @@ Active/Standby mode exclusively.
 .TP
 .I hds
 (Hardware-dependent)
-Generate the path priority for Hitachi AMS 2000 and HUS 100 families of arrays.
+Generate the path priority for Hitachi AMS families of arrays other than AMS 2000.
 .TP
 .I random
 Generate a random priority between 1 and 10.
-- 
2.17.0
