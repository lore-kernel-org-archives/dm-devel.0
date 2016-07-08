From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 02/14] multipath-tools: add alias_prefix to
	multipath.conf.5
Date: Fri,  8 Jul 2016 19:49:47 +0200
Message-ID: <1468000199-15566-3-git-send-email-xose.vazquez@gmail.com>
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

It was missing in defaults section.

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 multipath/multipath.conf.5 | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index c7a2f1b..6f6ef64 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -316,6 +316,13 @@ Please use \fItur\fR instead.
 Default value is: \fBtur\fR
 .RE
 .TP
+.B alias_prefix
+The \fIuser_friendly_names\fR prefix.
+.RS
+.TP
+Default value is: \fBmpath\fR
+.RE
+.TP
 .B failback
 Tell multipathd how to manage path group failback.
 .RS
-- 
2.7.4
