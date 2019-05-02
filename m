From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: document missing multipathd
	option at man page
Date: Thu,  2 May 2019 21:26:19 +0200
Message-ID: <20190502192619.31264-1-xose.vazquez@gmail.com>
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
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, DM-DEVEL ML <dm-devel@redhat.com>
List-Id: dm-devel.ids

 -w was added in 2858c60a34527401381ea6b13cf316c3e5064383

Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 multipathd/multipathd.8 | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/multipathd/multipathd.8 b/multipathd/multipathd.8
index 94c3f97..edac7a9 100644
--- a/multipathd/multipathd.8
+++ b/multipathd/multipathd.8
@@ -25,6 +25,7 @@ multipathd \- Multipath daemon.
 .RB [\| \-v\ \c
 .IR verbosity \|]
 .RB [\| \-B \|]
+.RB [\| \-w \|]
 .
 .
 .\" ----------------------------------------------------------------------------
@@ -77,6 +78,12 @@ be viewed by entering '\fIhelp\fR'. When you are finished entering commands, pre
 multipathd. See
 .BR multipath.conf(5).
 .
+.TP
+.B \-w
+Since kernel 4.14 a new device-mapper event polling interface is used for updating
+multipath devices on dmevents. Use this flag to force it to use the old event
+waiting method, based on creating a seperate thread for each device.
+.
 .
 .
 .\" ----------------------------------------------------------------------------
-- 
2.21.0
