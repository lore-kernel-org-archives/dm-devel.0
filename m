From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v2 10/12] multipath.conf: add missing options to
	man page
Date: Fri,  8 Mar 2019 17:12:03 -0600
Message-ID: <1552086725-18476-11-git-send-email-bmarzins@redhat.com>
References: <1552086725-18476-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1552086725-18476-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipath/multipath.conf.5 | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 0fe8461..1e0714f 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -1494,6 +1494,8 @@ section:
 .TP
 .B flush_on_last_del
 .TP
+.B user_friendly_names
+.TP
 .B retain_attached_hw_handler
 .TP
 .B detect_prio
@@ -1525,6 +1527,8 @@ section:
 .B max_sectors_kb
 .TP
 .B ghost_delay
+.TP
+.B all_tg_pt
 .RE
 .PD
 .LP
@@ -1604,7 +1608,11 @@ the values are taken from the \fIdevices\fR or \fIdefaults\fR sections:
 .TP
 .B skip_kpartx
 .TP
+.B max_sectors_kb
+.TP
 .B ghost_delay
+.TP
+.B all_tg_pt
 .RE
 .PD
 .LP
-- 
2.17.2
