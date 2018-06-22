From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 2/6] libmpathpersist: fix typo in
	mpath_format_readfullstatus
Date: Sat, 23 Jun 2018 01:15:12 +0200
Message-ID: <20180622231516.18806-2-mwilck@suse.com>
References: <20180622231516.18806-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180622231516.18806-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Eli Qiao <taget@linux.vnet.ibm.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathpersist/mpath_pr_ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmpathpersist/mpath_pr_ioctl.c b/libmpathpersist/mpath_pr_ioctl.c
index dcdb530d..bcbb9691 100644
--- a/libmpathpersist/mpath_pr_ioctl.c
+++ b/libmpathpersist/mpath_pr_ioctl.c
@@ -218,7 +218,7 @@ void mpath_format_readfullstatus(struct prin_resp *pr_buff, int len, int noisy)
 
 	if (pr_buff->prin_descriptor.prin_readfd.number_of_descriptor == 0)
 	{
-		condlog(3, "No registration or resrvation found.");
+		condlog(3, "No registration or reservation found.");
 		return;
 	}
 
-- 
2.17.1
