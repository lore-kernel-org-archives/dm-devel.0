From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH] dm-kcopyd/dm-snap: Don't read the origin on
 full chunk write
Date: Mon, 20 Jun 2011 11:03:13 +0100
Message-ID: <20110620100312.GB5388@ubuntu>
References: <Pine.LNX.4.64.1106170829390.24411@hs20-bc2-1.build.redhat.com>
	<20110620080952.GA3266@ubuntu> <4DFF1829.7050909@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4DFF1829.7050909@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <mbroz@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Mon, Jun 20, 2011 at 11:51:37AM +0200, Milan Broz wrote:
> On 06/20/2011 10:09 AM, Joe Thornber wrote:
> For the nack - I do not get it.
> Joe, please can you explain the reasons?

You know the size of the bio when you submit it.  So you're saying to
kcopyd, do this copy, except if it's a particular size, then don't,
just issue the io.  I don't see from Mikulas' description why kcopyd
needs to be involved in this.

For instance here's how multisnap handles it:

        if (io_covers_block(pool, bio)) {
                /* no copy needed, since all data is going to change */
                m->bio = bio;
                m->bi_end_io = bio->bi_end_io;
                m->bi_private = bio->bi_private;
                bio->bi_end_io = overwrite_complete;
                bio->bi_private = m;
                remap_and_issue(pool, bio, data_dest);

        } else {
                /* use kcopyd */
                struct dm_io_region from, to;

                from.bdev = pool->pool_dev;
                from.sector = data_origin * pool->sectors_per_block;
                from.count = pool->sectors_per_block;

                to.bdev = pool->pool_dev;
                to.sector = data_dest * pool->sectors_per_block;
                to.count = pool->sectors_per_block;

                r = dm_kcopyd_copy(pool->copier, &from, 1, &to,
                                   0, copy_complete, m);
                if (r < 0) {
                        mempool_free(m, pool->mapping_pool);
                        printk(KERN_ALERT "dm_kcopyd_copy() failed");
                        cell_error(cell);
                }
        }

I don't see why we want to wait for a context switch to kcopyd in
order to issue an io.

If this is about avoiding having to hook the bio endio function then
why use kcopyd rather than dm-io? (I'm not advocating this, just
asking the question).

- Joe
