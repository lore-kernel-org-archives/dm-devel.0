From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: update bl info for nvme in
	multipath.conf.5
Date: Wed, 16 Nov 2016 17:20:21 +0100
Message-ID: <20161116162021.3525-1-xose.vazquez@gmail.com>
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

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 multipath/multipath.conf.5 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index f8e413c..fb2bc5b 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -873,7 +873,7 @@ The following keywords are recognized:
 Regular expression of the device nodes to be excluded.
 .RS
 .TP
-Default value is: \fB^(ram|raw|loop|fd|md|dm-|sr|scd|st|dcssblk)[0-9]\fR, \fB^(td|hd|vd)[a-z]\fR and \fB^nvme\fR
+Default value is: \fB^(ram|raw|loop|fd|md|dm-|sr|scd|st|dcssblk|nvme)[0-9]\fR and \fB^(td|hd|vd)[a-z]\fR
 .RE
 .TP
 .B wwid
-- 
2.10.2
