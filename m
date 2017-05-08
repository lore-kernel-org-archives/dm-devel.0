From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v3 04/10] dm: Fix REQ_OP_ZONE_RESET bio handling
Date: Mon, 8 May 2017 16:40:46 -0700
Message-ID: <20170508234052.32375-5-bart.vanassche@sandisk.com>
References: <20170508234052.32375-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170508234052.32375-1-bart.vanassche@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Damien Le Moal <damien.lemoal@wdc.com>, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

From: Damien Le Moal <damien.lemoal@wdc.com>

The REQ_OP_ZONE_RESET bio has no payload and zero sectors. Its position
is the only information used to indicate the zone to reset on the
device. Due to its zero length, this bio is not cloned and sent to the
target through the non-flush case in __split_and_process_bio().
Add an additional case in that function to call
__split_and_process_non_flush() without checking the clone info size.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 drivers/md/dm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 6ef9500..51425c7 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1374,6 +1374,10 @@ static void __split_and_process_bio(struct mapped_device *md,
 		ci.sector_count = 0;
 		error = __send_empty_flush(&ci);
 		/* dec_pending submits any data associated with flush */
+	} else if (bio_op(bio) == REQ_OP_ZONE_RESET) {
+		ci.bio = bio;
+		ci.sector_count = 0;
+		error = __split_and_process_non_flush(&ci);
 	} else {
 		ci.bio = bio;
 		ci.sector_count = bio_sectors(bio);
-- 
2.9.3
