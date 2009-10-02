From: Philipp Reisner <philipp.reisner@linbit.com>
Subject: [PATCH 5/8] dm/connector: Only process connector packages from privileged processes
Date: Fri,  2 Oct 2009 14:40:08 +0200
Message-ID: <1254487211-11810-6-git-send-email-philipp.reisner@linbit.com>
References: <1254487211-11810-1-git-send-email-philipp.reisner@linbit.com>
 <1254487211-11810-2-git-send-email-philipp.reisner@linbit.com>
 <1254487211-11810-3-git-send-email-philipp.reisner@linbit.com>
 <1254487211-11810-4-git-send-email-philipp.reisner@linbit.com>
 <1254487211-11810-5-git-send-email-philipp.reisner@linbit.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1254487211-11810-5-git-send-email-philipp.reisner@linbit.com>
Sender: netdev-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Greg KH <greg@kroah.com>
Cc: dm-devel@redhat.com, Evgeniy Polyakov <zbr@ioremap.net>, linux-fbdev-devel@lists.sourceforge.net, Philipp Reisner <philipp.reisner@linbit.com>
List-Id: dm-devel.ids

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
---
 drivers/md/dm-log-userspace-transfer.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-log-userspace-transfer.c b/drivers/md/dm-log-userspace-transfer.c
index 1327e1a..54abf9e 100644
--- a/drivers/md/dm-log-userspace-transfer.c
+++ b/drivers/md/dm-log-userspace-transfer.c
@@ -133,6 +133,9 @@ static void cn_ulog_callback(struct cn_msg *msg, struct netlink_skb_parms *nsp)
 {
 	struct dm_ulog_request *tfr = (struct dm_ulog_request *)(msg + 1);
 
+	if (!cap_raised(nsp->eff_cap, CAP_SYS_ADMIN))
+		return;
+
 	spin_lock(&receiving_list_lock);
 	if (msg->len == 0)
 		fill_pkg(msg, NULL);
-- 
1.6.0.4

