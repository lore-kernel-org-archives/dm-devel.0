From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 15/15] multipath-tools: document the relation
	between queue_if_no_path and no_path_retry
Date: Wed, 10 Aug 2016 18:20:38 +0200
Message-ID: <1470846038-6590-15-git-send-email-xose.vazquez@gmail.com>
References: <1470846038-6590-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1470846038-6590-1-git-send-email-xose.vazquez@gmail.com>
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

Also mark queue_if_no_path as deprecated.

Cc: Hannes Reinecke <hare@suse.de>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 multipath/multipath.conf.5 | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 8dc5d08..3b66ddb 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -336,8 +336,8 @@ Possible values for the feature list are:
 .RS
 .TP 12
 .I queue_if_no_path
-Queue IO if no path is active; identical to the \fIno_path_retry\fR keyword.
-See KNOWN ISSUES.
+(Superseded by \fIno_path_retry\fR) Queue IO if no path is active. Identical to the \fIno_path_retry\fR with
+\fIqueue\fR value. See KNOWN ISSUES.
 .TP
 .I no_partitions
 Disable automatic partitions generation via kpartx.
-- 
2.7.4
