From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 10/14] multipath-tools: add default value for
	hardware_handler in multipath.conf.5
Date: Fri,  8 Jul 2016 19:49:55 +0200
Message-ID: <1468000199-15566-11-git-send-email-xose.vazquez@gmail.com>
References: <1468000199-15566-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1468000199-15566-1-git-send-email-xose.vazquez@gmail.com>
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

It's unset.

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 multipath/multipath.conf.5 | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 83dcdda..edcf4dc 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -837,6 +837,8 @@ Active/Standby mode exclusively.
 .I 1 alua
 (Hardware-dependent)
 Hardware handler for SCSI-3 ALUA compatible arrays.
+.TP
+Default value is: \fB<unset>\fR
 .RE
 .LP
 The following attributes are optional; if not set the default values
-- 
2.7.4
