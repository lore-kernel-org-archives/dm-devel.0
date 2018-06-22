From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 1/6] libmpathpersist: remove duplicate test in
	readfullstatus
Date: Sat, 23 Jun 2018 01:15:11 +0200
Message-ID: <20180622231516.18806-1-mwilck@suse.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Eli Qiao <taget@linux.vnet.ibm.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathpersist/mpath_pr_ioctl.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/libmpathpersist/mpath_pr_ioctl.c b/libmpathpersist/mpath_pr_ioctl.c
index 6dd74031..dcdb530d 100644
--- a/libmpathpersist/mpath_pr_ioctl.c
+++ b/libmpathpersist/mpath_pr_ioctl.c
@@ -216,12 +216,6 @@ void mpath_format_readfullstatus(struct prin_resp *pr_buff, int len, int noisy)
 	mpath_reverse_uint32_byteorder(&pr_buff->prin_descriptor.prin_readfd.prgeneration);
 	mpath_reverse_uint32_byteorder(&pr_buff->prin_descriptor.prin_readfd.number_of_descriptor);
 
-	if (0 == pr_buff->prin_descriptor.prin_readfd.number_of_descriptor)
-	{
-		return ;
-	}
-
-
 	if (pr_buff->prin_descriptor.prin_readfd.number_of_descriptor == 0)
 	{
 		condlog(3, "No registration or resrvation found.");
-- 
2.17.1
