From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: amend text from
	multipath/multipath.conf.5
Date: Tue, 28 Mar 2017 23:37:12 +0200
Message-ID: <20170328213712.5137-1-xose.vazquez@gmail.com>
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
 multipath/multipath.conf.5 | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 24decf7..5939688 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -213,9 +213,9 @@ type of path devices. If this field is configured and matched with type
 of device, it would override any other methods providing for device
 unique identifier in config file, and it would activate merging uevents
 according to the identifier to promote effiecncy in processing uevents.
-Tt has no default value, if you want to identify path by udev attribute
-and to activate merging uevents for SCSI and DAS device, you can set
-it's value as:
+It has no default value, if you want to identify path by udev attribute
+and to activate merging uevents for SCSI and DASD devices, you can set
+its value as:
 .RS
 .TP
 \fBuid_attrs "sd:ID_SERIAL dasd:ID_UID"\fR
-- 
2.12.1
