From: Qu Wenruo <wqu@suse.com>
Subject: [PATCH] dm log writes: Fix the wrong comment on the
	logged sequence
Date: Tue, 18 Jun 2019 13:39:38 +0800
Message-ID: <20190618053938.13529-1-wqu@suse.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

dm-log-writes records the sequence of completion, not submission, thus
for the following sequence (W=write, C=complete):

  Wa,Wb,Wc,Cc,Ca,FLUSH,FUAd,Cb,CFLUSH,CFUAd

The logged results in log device should be:
  c,a,b,flush,fua

Fix the comment to give a better example.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 drivers/md/dm-log-writes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-log-writes.c b/drivers/md/dm-log-writes.c
index 9ea2b0291f20..af94bbe77ce2 100644
--- a/drivers/md/dm-log-writes.c
+++ b/drivers/md/dm-log-writes.c
@@ -40,7 +40,7 @@
  *
  * Would result in the log looking like this:
  *
- * c,a,flush,fuad,b,<other writes>,<next flush>
+ * c,a,b,flush,fuad,<other writes>,<next flush>
  *
  * This is meant to help expose problems where file systems do not properly wait
  * on data being written before invoking a FLUSH.  FUA bypasses cache so once it
-- 
2.22.0
