From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/4] block: Generically handle report zones
	buffer
Date: Thu, 24 Oct 2019 00:13:37 -0700
Message-ID: <20191024071337.GC19572@infradead.org>
References: <20191024065006.8684-1-damien.lemoal@wdc.com>
	<20191024065006.8684-5-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191024065006.8684-5-damien.lemoal@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, "Martin K . Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-scsi@vger.kernel.org
List-Id: dm-devel.ids

On Thu, Oct 24, 2019 at 03:50:06PM +0900, Damien Le Moal wrote:
> Instead of relying on a zoned block device driver to allocate a buffer
> for every execution of a report zones command execution, rely on the
> block layer use of the device zone report queue limits to allocate a
> buffer and keep it around when the device report_zones method is
> executed in a loop, e.g.  as in blk_revalidate_disk_zones().
> 
> This simplifies the code in the scsi sd_zbc driver as well as simplify
> the addition of zone supports for upcoming new zoned device drivers.

I wonder if we could just do away with the separate buffer entirely.
As the SCSI zone size (and also ATA even if we don't directly talk
to that) are intentionally the same size as the blk_zone (and the
same true is for the only upcoming standard I know of) we can just
rewrite each entry in-place(-ish) by reusing the same allocation.
Depending on the detailed formate we have to copy a field our two
onto the stack first, but it both avoids the extra allocation, and
the whole queue limits infrastructure in the previous patch and
should simply the code a lot.
