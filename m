From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: document uid_attribute for NVME
	devices
Date: Thu, 11 May 2017 19:29:35 +0200
Message-ID: <20170511172935.3341-1-xose.vazquez@gmail.com>
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
 multipath/multipath.conf.5 | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 5939688..f04ff19 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -7,7 +7,7 @@
 .\"
 .\" ----------------------------------------------------------------------------
 .
-.TH MULTIPATH.CONF 5 2016-11-27 "Linux"
+.TH MULTIPATH.CONF 5 2017-05-11 "Linux"
 .
 .
 .\" ----------------------------------------------------------------------------
@@ -232,6 +232,8 @@ The udev attribute providing a unique path identifier.
 The default is: for SCSI devices \fBID_SERIAL\fR
 .TP
 The default is: for DASD devices \fBID_UID\fR
+.TP
+The default is: for NVME devices \fBID_WWN\fR
 .RE
 .
 .
-- 
2.13.0
