From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: fix format in multipath.conf.5
Date: Sat,  5 Aug 2017 01:44:29 +0200
Message-ID: <20170804234429.10634-1-xose.vazquez@gmail.com>
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

multipath/multipath.conf.5:408: warning: can't find font `,'

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 multipath/multipath.conf.5 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 3b4e518..d9ac279 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -405,7 +405,7 @@ precedence. See KNOWN ISSUES.
 .\" XXX
 .I queue_mode <mode>
 (Since kernel 4.8) Select the the queueing mode per multipath device.
-<mode> can be \fIbio\fR, \fIrq\fR or \fImq\f, which corresponds to
+<mode> can be \fIbio\fR, \fIrq\fR or \fImq\fR, which corresponds to
 bio-based, request-based, and block-multiqueue (blk-mq) request-based,
 respectively.
 
-- 
2.13.4
