From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: why does __split_and_process_bio use
	bio_clone_bioset?
Date: Thu, 14 Jun 2018 16:08:09 -0400
Message-ID: <20180614200808.GA46373@redhat.com>
References: <20180614081947.GA23375@infradead.org>
	<20180614181245.GA1161@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180614181245.GA1161@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@infradead.org>, NeilBrown <neilb@suse.com>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, Ming Lei <ming.lei@redhat.com>
List-Id: dm-devel.ids

On Thu, Jun 14 2018 at  2:12P -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Thu, Jun 14 2018 at  4:19am -0400,
> Christoph Hellwig <hch@infradead.org> wrote:
> 
> > Hi Neil,
> > 
> > In commit 18a25da8 ("dm: ensure bio submission follows a depth-first
> > tree walk") you've added a call to bio_clone_bioset to
> > __split_and_process_bio.  Unlike all other bio splitting code this
> > actually allocates a new bio_vec array instead of just splitting the bio
> > and the iterator.  I can't actually find a good reason for that either
> > in a cursory review of the code, the commit or the comments.
> >
> > Do you remember why this can't just use bio_clone_fast?
> 
> Your question caused me to revisit this code and it is suspect for a
> couple reasons:
> 
> 1) I'm also not seeing why we need bio_clone_bioset()

The patch below seems to work fine (given quick testing).. It also has a
side-effect of not breaking integrity support (which commit 18a25da8
appears to do because it isn't accounting for any of the integrity stuff
bio_split, or dm.c:clone_bio, does).

FYI, my other concerns in my my previous reply were unfounded and due to
misreading the existing code.

Neil, please still feel free to have a look at this to see if you can
recall why you used bio_clone_bioset().

If in the end you agree that the following patch is fine please let me
know and I'll get a proper fix staged.

Thanks,
Mike

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 20a8d63..dfb4783 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1582,10 +1582,9 @@ static blk_qc_t __split_and_process_bio(struct mapped_device *md,
 				 * the usage of io->orig_bio in dm_remap_zone_report()
 				 * won't be affected by this reassignment.
 				 */
-				struct bio *b = bio_clone_bioset(bio, GFP_NOIO,
-								 &md->queue->bio_split);
+				struct bio *b = bio_split(bio, bio_sectors(bio) - ci.sector_count,
+							  GFP_NOIO, &md->queue->bio_split);
 				ci.io->orig_bio = b;
-				bio_advance(bio, (bio_sectors(bio) - ci.sector_count) << 9);
 				bio_chain(b, bio);
 				ret = generic_make_request(bio);
 				break;
