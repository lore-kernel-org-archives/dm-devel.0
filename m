From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [dm-devel] [PATCH 4/9] block: Remove partition
 support for zoned block devices
Date: Thu, 7 Nov 2019 22:30:41 -0800
Message-ID: <20191108063041.GB12413@infradead.org>
References: <20191108015702.233102-1-damien.lemoal@wdc.com>
 <20191108015702.233102-5-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <20191108015702.233102-5-damien.lemoal@wdc.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, "Martin K . Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>
List-Id: dm-devel.ids

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

Note that this has a conflict with my series that cleans up the area
around rescan_partitions, but that series will only get simpler after
this patch is merged.
