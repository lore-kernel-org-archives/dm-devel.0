From: Jan Blunck <jblunck@suse.de>
Subject: [patch 10/11] dm: use is_power_of_2()
Date: Fri, 10 Aug 2007 22:02:14 +0200
Message-ID: <11201.475284952$1186776774@news.gmane.org>
References: <20070810200204.455820246@suse.de>>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=dm/dm-use-is_power_of_2.diff
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Use is_power_of_2().

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 drivers/md/dm-stripe.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -96,12 +96,13 @@ static int stripe_ctr(struct dm_target *
 		return -EINVAL;
 	}
 
-	/*
-	 * chunk_size is a power of two
-	 */
-	if (!chunk_size || (chunk_size & (chunk_size - 1)) ||
-	    (chunk_size < (PAGE_SIZE >> 9))) {
-		ti->error = "Invalid chunk size";
+	if (!is_power_of_2(chunk_size)) {
+		ti->error = "Chunk size is not a power of 2";
+		return -EINVAL;
+	}
+
+	if (chunk_size < (PAGE_SIZE >> 9)) {
+		ti->error = "Chunk size is smaller than page size";
 		return -EINVAL;
 	}
 

-- 
