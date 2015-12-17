From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v2 0/6] Make blkdev_issue_discard() submit
 aligned discard requests
Date: Thu, 17 Dec 2015 12:38:55 +0100
Message-ID: <56729ECF.50906@sandisk.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
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
To: Jens Axboe <axboe@fb.com>
Cc: Jan Kara <jack@suse.cz>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, Dmitry Monakhov <dmonakhov@openvz.org>, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

Users of blkdev_issue_discard(), e.g. blk_ioctl_discard(), expect that 
this function generates discard request(s) that satisfy block driver 
alignment requirements. Hence modify blk_bio_discard_split() such that 
the submitted discard requests are aligned.

Changes compared to v1:
- Moved the code to split discard requests from blkdev_issue_discard()
   into blk_bio_discard_split().

The patches in this series are:
0001-block-Introduce-blk_round_sect_down.patch
0002-block-Introduce-bio_add_zero_pages.patch
0003-block-Optimize-__blkdev_issue_zeroout.patch
0004-block-Make-blkdev_issue_discard-submit-aligned-disca.patch
0005-brd-Split-bio-if-needed.patch
0006-brd-Accept-non-aligned-discard-requests-with-size-ze.patch
