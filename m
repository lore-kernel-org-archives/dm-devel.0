From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 36/42] Clarify dev_loss_tmo capping in
	multipath.conf.5
Date: Tue,  8 Jan 2013 14:54:14 +0100
Message-ID: <1357653259-62650-37-git-send-email-hare@suse.de>
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

The linux kernel will not allow any dev_loss_tmo setting larger
than 300 if fast_io_fail is not set. So we should document this
in the manpage.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipath/multipath.conf.5 |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 247cdc0..35021f6 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -342,6 +342,8 @@ retry interval
 \fIno_path_retry\fR * \fIpolling_interval\fR
 if a number of retries is given with \fIno_path_retry\fR and the
 overall retry interval is longer than the specified \fIdev_loss_tmo\fR value.
+The linux kernel will cap this value to \fI300\fR if \fBfast_io_fail_tmo\fR
+is not set.
 .TP
 .B queue_without_daemon
 If set to
-- 
1.7.4.2
