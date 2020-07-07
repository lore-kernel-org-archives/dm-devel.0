From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: add info to man page for the
	historical-service-time path selector
Date: Tue,  7 Jul 2020 23:17:58 +0200
Message-ID: <20200707211758.12528-1-xose.vazquez@gmail.com>
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
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Khazhismel Kumykov <khazhy@google.com>, DM-DEVEL ML <dm-devel@redhat.com>, Gabriel Krisman Bertazi <krisman@collabora.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Cc: Khazhismel Kumykov <khazhy@google.com>
Cc: Gabriel Krisman Bertazi <krisman@collabora.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 multipath/multipath.conf.5 | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 05a5e8ff..6e637769 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -205,6 +205,10 @@ of outstanding I/O to the path.
 (Since 2.6.31 kernel) Choose the path for the next bunch of I/O based on the amount
 of outstanding I/O to the path and its relative throughput.
 .TP
+.I "historical-service-time 0"
+(Since 5.8 kernel) Choose the path for the next bunch of I/O based on the shortest
+time by comparing estimated service time (based on historical service time).
+.TP
 The default is: \fBservice-time 0\fR
 .RE
 .
-- 
2.26.2
