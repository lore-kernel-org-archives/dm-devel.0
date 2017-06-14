From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] block: missing break in process_queued_bios()
Date: Wed, 14 Jun 2017 12:04:37 +0300
Message-ID: <20170614090437.GA31017@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair Kergon <agk@redhat.com>, Christoph Hellwig <hch@lst.de>
Cc: linux-raid@vger.kernel.org, kernel-janitors@vger.kernel.org, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

This used to be a fall through case, but we shifted code around and I
think we want a break here now.

Fixes: 4e4cbee93d56 ("block: switch bios to blk_status_t")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index a7d2e0840cc5..0e8ab5bb3575 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -625,6 +625,7 @@ static void process_queued_bios(struct work_struct *work)
 		case DM_MAPIO_KILL:
 			bio->bi_status = BLK_STS_IOERR;
 			bio_endio(bio);
+			break;
 		case DM_MAPIO_REQUEUE:
 			bio->bi_status = BLK_STS_DM_REQUEUE;
 			bio_endio(bio);
