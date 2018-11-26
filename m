From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH] libmpathpersist: fix off-by-one error in PRIN
	length check
Date: Mon, 26 Nov 2018 17:29:33 +0100
Message-ID: <20181126162933.27883-1-mwilck@suse.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

The length check added by bf25392f4e98 was off by one, so
that a warning was printed even for correct responses
for PERSISTENT_RESERVE_IN READ_FULL_STATUS service actions.
Non-fatal, but should be fixed nonetheless.

Fixes: bf25392f4e98 "libmpathpersist: fix stack overflow in
   mpath_format_readfullstatus()"
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathpersist/mpath_pr_ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmpathpersist/mpath_pr_ioctl.c b/libmpathpersist/mpath_pr_ioctl.c
index a222b1e1..c4f4ccda 100644
--- a/libmpathpersist/mpath_pr_ioctl.c
+++ b/libmpathpersist/mpath_pr_ioctl.c
@@ -241,7 +241,7 @@ void mpath_format_readfullstatus(struct prin_resp *pr_buff, int len, int noisy)
 		fdesc.rtpi = get_unaligned_be16(&p[18]);
 
 		tid_len_len = get_unaligned_be32(&p[20]);
-		if (tid_len_len + 24 + k >= additional_length) {
+		if (tid_len_len + 24 + k > additional_length) {
 			condlog(0,
 				"%s: corrupt PRIN response: status descriptor end %d exceeds length %d",
 				__func__, tid_len_len + k + 24,
-- 
2.19.1
