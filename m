From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: document uid_attribute for scsi
	and dasd devices
Date: Sat,  9 Jul 2016 00:01:48 +0200
Message-ID: <1468015308-4063-1-git-send-email-xose.vazquez@gmail.com>
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

Default for SCSI devices is ID_SERIAL, a standard udev variable.
Default for DASD devices is ID_UID, returned by dasdinfo from 390-tools package.

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 multipath/multipath.conf.5 | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 794275e..709ab3c 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -191,7 +191,9 @@ Default value is: \fBfailover\fR
 The udev attribute providing a unique path identifier.
 .RS
 .TP
-Default value is: \fBID_SERIAL\fR
+Default value is: \fBID_SERIAL\fR for SCSI devices
+.TP
+Default value is: \fBID_UID\fR for DASD devices
 .RE
 .TP
 .B getuid_callout
-- 
2.7.4
