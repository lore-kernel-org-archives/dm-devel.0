From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 3/4] dm linear: add WRITE SAME support
Date: Thu, 20 Dec 2012 00:57:12 -0500
Message-ID: <1355983033-17863-3-git-send-email-snitzer@redhat.com>
References: <20121220054725.GA17619@redhat.com>
	<1355983033-17863-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1355983033-17863-1-git-send-email-snitzer@redhat.com>
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
Cc: martin.petersen@oracle.com
List-Id: dm-devel.ids

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-linear.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index 2f57bd8..f982e9c 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -55,6 +55,7 @@ static int linear_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 	ti->num_flush_requests = 1;
 	ti->num_discard_requests = 1;
+	ti->num_write_same_requests = 1;
 	ti->private = lc;
 	return 0;
 
-- 
1.7.1
