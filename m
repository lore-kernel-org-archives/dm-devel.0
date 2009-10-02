From: Philipp Reisner <philipp.reisner@linbit.com>
Subject: [PATCH 6/8] dst/connector: Disallow unpliviged users to configure dst
Date: Fri,  2 Oct 2009 14:40:09 +0200
Message-ID: <1254487211-11810-7-git-send-email-philipp.reisner@linbit.com>
References: <1254487211-11810-1-git-send-email-philipp.reisner@linbit.com>
 <1254487211-11810-2-git-send-email-philipp.reisner@linbit.com>
 <1254487211-11810-3-git-send-email-philipp.reisner@linbit.com>
 <1254487211-11810-4-git-send-email-philipp.reisner@linbit.com>
 <1254487211-11810-5-git-send-email-philipp.reisner@linbit.com>
 <1254487211-11810-6-git-send-email-philipp.reisner@linbit.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1254487211-11810-6-git-send-email-philipp.reisner@linbit.com>
Sender: netdev-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Greg KH <greg@kroah.com>
Cc: dm-devel@redhat.com, Evgeniy Polyakov <zbr@ioremap.net>, linux-fbdev-devel@lists.sourceforge.net, Philipp Reisner <philipp.reisner@linbit.com>
List-Id: dm-devel.ids

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
---
 drivers/staging/dst/dcore.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/dst/dcore.c b/drivers/staging/dst/dcore.c
index 3943c91..ee16010 100644
--- a/drivers/staging/dst/dcore.c
+++ b/drivers/staging/dst/dcore.c
@@ -855,6 +855,11 @@ static void cn_dst_callback(struct cn_msg *msg, struct netlink_skb_parms *nsp)
 	struct dst_node *n = NULL, *tmp;
 	unsigned int hash;
 
+	if (!cap_raised(nsp->eff_cap, CAP_SYS_ADMIN)) {
+		err = -EPERM;
+		goto out;
+	}
+
 	if (msg->len < sizeof(struct dst_ctl)) {
 		err = -EBADMSG;
 		goto out;
-- 
1.6.0.4

