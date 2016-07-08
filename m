From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 03/14] multipath-tools: add partition_delimiter
	to multipath.conf.5
Date: Fri,  8 Jul 2016 19:49:48 +0200
Message-ID: <1468000199-15566-4-git-send-email-xose.vazquez@gmail.com>
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
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

It was missing in defaults section.

Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 multipath/multipath.conf.5 | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 6f6ef64..0f89a75 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -549,6 +549,16 @@ will be canceled.
 Default value is: \fBno\fR
 .RE
 .TP
+.B partition_delimiter
+If this value is not set, when multipath renames a device, it will act just
+like the kpartx default does, only adding a \fI"p"\fR to names ending in a
+number. If this parameter is set, multipath will act like kpartx does with
+the \fI-p\fR option is used, and always add delimiter.
+.RS
+.TP
+Default value is: \fB<unset>\fR
+.RE
+.TP
 .B config_dir
 If set to anything other than "", multipath will search this directory
 alphabetically for file ending in ".conf" and it will read configuration
-- 
2.7.4
