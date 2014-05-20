From: naota@elisp.net
Subject: [PATCH] dm: check era->md is non-NULL before closing it
Date: Tue, 20 May 2014 12:53:56 +0900
Message-ID: <87d2f9ds17.fsf@elisp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: Joe Thornber <ejt@redhat.com>, dm-devel@redhat.com
Cc: Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

In era_ctr(), era->md remain NULL until it's set after metadata_open().
On the other hand, era_destroy() assume era->md is non-NULL and it is
called by era_ctr() before initializing the value.

This patch just checks if era->md is non-NULL.

Signed-off-by: Naohiro Aota <naota@elisp.net>
---
 drivers/md/dm-era-target.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-era-target.c b/drivers/md/dm-era-target.c
index 414dad4..ad913cd 100644
--- a/drivers/md/dm-era-target.c
+++ b/drivers/md/dm-era-target.c
@@ -1391,7 +1391,8 @@ static int era_is_congested(struct dm_target_callbacks *cb, int bdi_bits)
 
 static void era_destroy(struct era *era)
 {
-	metadata_close(era->md);
+	if (era->md)
+		metadata_close(era->md);
 
 	if (era->wq)
 		destroy_workqueue(era->wq);
-- 
1.9.2
