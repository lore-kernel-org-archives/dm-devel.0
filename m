From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH] dm-thinp: report correct optimal I/O size
Date: Wed, 27 Apr 2011 18:25:25 +0100
Message-ID: <1303925125.7049.9.camel@ubuntu>
References: <20110427134150.GA15413@infradead.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110427134150.GA15413@infradead.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@infradead.org>
Cc: device-mapper development <dm-devel@redhat.com>, ejt@redhat.com
List-Id: dm-devel.ids



On Wed, 2011-04-27 at 09:41 -0400, Christoph Hellwig wrote:
> tc->block_shift is the shift to get from a sector to the block_size,
> and it doesn't make any sense to apply that to the block size.
> Without this I get overflows of the optimal I/O size queue limit
> when using large block sizes in dm-thinp. 

NACK.

From looking at dm-raid and dm-stripe it appears that the
blk_limits_io_opt function is expecting the size to be in bytes, not
sectors.

static void raid_io_hints(struct dm_target *ti, struct queue_limits *limits)
{
        struct raid_set *rs = ti->private;
        unsigned chunk_size = rs->md.chunk_sectors << 9;
        raid5_conf_t *conf = rs->md.private;

        blk_limits_io_min(limits, chunk_size);
        blk_limits_io_opt(limits, chunk_size * (conf->raid_disks - conf->max_degraded));
}

static void stripe_io_hints(struct dm_target *ti,
                            struct queue_limits *limits)
{
        struct stripe_c *sc = ti->private;
        unsigned chunk_size = (sc->chunk_mask + 1) << 9;

        blk_limits_io_min(limits, chunk_size);
        blk_limits_io_opt(limits, chunk_size * sc->stripes);
}


tc->block_size is in sectors (you are passing sectors on the target
line?).

What's probably happening here is we should be doing:

blk_limits_io_opt(limits, min(<some theoretical max>, tc->block_size << SECTOR_SHIFT));


- Joe
