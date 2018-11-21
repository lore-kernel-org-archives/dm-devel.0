From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V11 03/19] block: introduce
	bio_for_each_bvec()
Date: Wed, 21 Nov 2018 23:31:36 +0800
Message-ID: <20181121153135.GB19111@ming.t460p>
References: <20181121032327.8434-1-ming.lei@redhat.com>
	<20181121032327.8434-4-ming.lei@redhat.com>
	<20181121133244.GB1640@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <cluster-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20181121133244.GB1640@lst.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/cluster-devel>
List-Post: <mailto:cluster-devel@redhat.com>
List-Help: <mailto:cluster-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=subscribe>
Sender: cluster-devel-bounces@redhat.com
Errors-To: cluster-devel-bounces@redhat.com
To: Christoph Hellwig <hch@lst.de>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-mm@kvack.org, dm-devel@redhat.com, Omar Sandoval <osandov@fb.com>, Sagi Grimberg <sagi@grimberg.me>, "Darrick J . Wong" <darrick.wong@oracle.com>, cluster-devel@redhat.com, linux-ext4@vger.kernel.org, Shaohua Li <shli@kernel.org>, Kent Overstreet <kent.overstreet@gmail.com>, Boaz Harrosh <ooo@electrozaur.com>, Gao Xiang <gaoxiang25@huawei.com>, Coly Li <colyli@suse.de>, linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
List-Id: dm-devel.ids

On Wed, Nov 21, 2018 at 02:32:44PM +0100, Christoph Hellwig wrote:
> > +#define bio_iter_mp_iovec(bio, iter)				\
> > +	segment_iter_bvec((bio)->bi_io_vec, (iter))
> 
> Besides the mp naming we'd like to get rid off there also is just
> a single user of this macro, please just expand it there.

OK.

> 
> > +#define segment_iter_bvec(bvec, iter)				\
> > +((struct bio_vec) {							\
> > +	.bv_page	= segment_iter_page((bvec), (iter)),	\
> > +	.bv_len		= segment_iter_len((bvec), (iter)),	\
> > +	.bv_offset	= segment_iter_offset((bvec), (iter)),	\
> > +})
> 
> And for this one please keep the segment vs bvec versions of these
> macros close together in the file please, right now it follow the
> bvec_iter_bvec variant closely.

OK.

> 
> > +static inline void __bio_advance_iter(struct bio *bio, struct bvec_iter *iter,
> > +				      unsigned bytes, unsigned max_seg_len)
> >  {
> >  	iter->bi_sector += bytes >> 9;
> >  
> >  	if (bio_no_advance_iter(bio))
> >  		iter->bi_size -= bytes;
> >  	else
> > -		bvec_iter_advance(bio->bi_io_vec, iter, bytes);
> > +		__bvec_iter_advance(bio->bi_io_vec, iter, bytes, max_seg_len);
> >  		/* TODO: It is reasonable to complete bio with error here. */
> >  }
> >  
> > +static inline void bio_advance_iter(struct bio *bio, struct bvec_iter *iter,
> > +				    unsigned bytes)
> > +{
> > +	__bio_advance_iter(bio, iter, bytes, PAGE_SIZE);
> > +}
> 
> Btw, I think the remaining users of bio_advance_iter() in bio.h
> should probably switch to using __bio_advance_iter to make them a little
> more clear to read.

Good point.

> 
> > +/* returns one real segment(multi-page bvec) each time */
> 
> space before the brace, please.

OK.

> 
> > +#define BVEC_MAX_LEN  ((unsigned int)-1)
> 
> >  	while (bytes) {
> > +		unsigned segment_len = segment_iter_len(bv, *iter);
> >  
> > -		iter->bi_bvec_done += len;
> > +		if (max_seg_len < BVEC_MAX_LEN)
> > +			segment_len = min_t(unsigned, segment_len,
> > +					    max_seg_len -
> > +					    bvec_iter_offset(bv, *iter));
> > +
> > +		segment_len = min(bytes, segment_len);
> 
> Please stick to passing the magic zero here as can often generate more
> efficient code.

But zero may decrease the code readability. Actually the passed
'max_seg_len' is just a constant, and complier should have generated
same efficient code for any constant, either 0 or other.

> 
> Talking about efficent code - I wonder how much code size we'd save
> by moving this function out of line..

That is good point, see the following diff:

[mingl@hp kernel]$ diff -u inline.size non_inline.size
--- inline.size	2018-11-21 23:24:52.305312076 +0800
+++ non_inline.size	2018-11-21 23:24:59.908393010 +0800
@@ -1,2 +1,2 @@
    text	   data	    bss	    dec	    hex	filename
-13429213	6893922	4292692	24615827	1779b93	vmlinux.inline
+13429153	6893346	4292692	24615191	1779917	vmlinux.non_inline

vmlinux(non_inline) is built by just moving/exporting __bvec_iter_advance()
into block/bio.c.

The difference is about 276bytes.

> 
> But while looking over this I wonder why we even need the max_seg_len
> here.  The only thing __bvec_iter_advance does it to move bi_bvec_done
> and bi_idx forward, with corresponding decrements of bi_size.  As far
> as I can tell the only thing that max_seg_len does is that we need
> to more iterations of the while loop to archive the same thing.
> 
> And actual bvec used by the caller will be obtained using
> bvec_iter_bvec or segment_iter_bvec depending on if they want multi-page
> or single-page variants.

Right, we let __bvec_iter_advance() serve for both multi-page and single-page
case, then we have to tell it via one way or another, now we use the constant
of 'max_seg_len'.

Or you suggest to implement two versions of __bvec_iter_advance()?

Thanks,
Ming
