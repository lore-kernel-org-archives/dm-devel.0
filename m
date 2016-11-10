From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: document exclusive_pref_bit for
	sysfs
Date: Thu, 10 Nov 2016 18:24:36 +0100
Message-ID: <20161110172436.1873-1-xose.vazquez@gmail.com>
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
 multipath/multipath.conf.5 | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index a1f25d5..f8e413c 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -7,7 +7,7 @@
 .\"
 .\" ----------------------------------------------------------------------------
 .
-.TH MULTIPATH.CONF 5 2016-10-18 "Linux"
+.TH MULTIPATH.CONF 5 2016-11-10 "Linux"
 .
 .
 .\" ----------------------------------------------------------------------------
@@ -321,6 +321,10 @@ these values can be looked up through sysfs or by running \fImultipathd show pat
 If \fIexclusive_pref_bit\fR is set, paths with the \fIpreferred path\fR bit
 set will always be in their own path group.
 .TP
+.I sysfs
+If \fIexclusive_pref_bit\fR is set, paths with the \fIpreferred path\fR bit
+set will always be in their own path group.
+.TP
 .I datacore
 .\" XXX
 \fIpreferredsds\fR ???.
-- 
2.10.2
