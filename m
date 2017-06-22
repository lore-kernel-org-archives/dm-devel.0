From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v4 06/11] multipath.conf.5: document
	no_path_retry vs. queue_if_no_path
Date: Thu, 22 Jun 2017 16:59:08 +0200
Message-ID: <20170622145913.23714-7-mwilck@suse.com>
References: <20170622145913.23714-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170622145913.23714-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Clarify the documentation about option precedence.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Acked-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 multipath/multipath.conf.5 | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 0049cba7..d5d9438a 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -385,7 +385,9 @@ Possible values for the feature list are:
 .\" XXX
 .I queue_if_no_path
 (Superseded by \fIno_path_retry\fR) (Since ??? kernel) Queue I/O if no path is active.
-Identical to the \fIno_path_retry\fR with \fIqueue\fR value. See KNOWN ISSUES.
+Identical to the \fIno_path_retry\fR with \fIqueue\fR value. If both this
+feature and \fIno_path_retry\fR are set, the latter value takes
+precedence. See KNOWN ISSUES.
 .TP
 .I no_partitions
 Disable automatic partitions generation via kpartx.
-- 
2.13.1
