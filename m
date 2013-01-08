From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 35/42] multipath.conf.5: Clarify dev_loss_tmo
	settings
Date: Tue,  8 Jan 2013 14:54:13 +0100
Message-ID: <1357653259-62650-36-git-send-email-hare@suse.de>
References: <1357653259-62650-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1357653259-62650-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

We need to document that dev_loss_tmo is in fact modified
by no_path_retry.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipath/multipath.conf.5 |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 9d6266c..247cdc0 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -334,9 +334,14 @@ will disable the timeout.
 .TP
 .B dev_loss_tmo
 Specify the number of seconds the scsi layer will wait after a problem has
+<<<<<<< HEAD
 been detected on a FC remote port before removing it from the system. This
 can be set to "infinity" which sets it to the max value of 2147483647
-seconds, or 68 years.
+seconds, or 68 years. It will be automatically adjusted to the overall
+retry interval
+\fIno_path_retry\fR * \fIpolling_interval\fR
+if a number of retries is given with \fIno_path_retry\fR and the
+overall retry interval is longer than the specified \fIdev_loss_tmo\fR value.
 .TP
 .B queue_without_daemon
 If set to
-- 
1.7.4.2
