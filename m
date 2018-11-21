From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V10 09/19] block: introduce bio_bvecs()
Date: Wed, 21 Nov 2018 08:59:03 +0800
Message-ID: <20181121005902.GA31748@ming.t460p>
References: <20181115085306.9910-1-ming.lei@redhat.com>
	<20181115085306.9910-10-ming.lei@redhat.com>
	<20181116134541.GH3165@lst.de>
	<002fe56b-25e4-573e-c09b-bb12c3e8d25a@grimberg.me>
	<20181120161651.GB2629@lst.de>
	<53526aae-fb9b-ee38-0a01-e5899e2d4e4d@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <cluster-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <53526aae-fb9b-ee38-0a01-e5899e2d4e4d@grimberg.me>
List-Unsubscribe: <https://www.redhat.com/mailman/options/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/cluster-devel>
List-Post: <mailto:cluster-devel@redhat.com>
List-Help: <mailto:cluster-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=subscribe>
Sender: cluster-devel-bounces@redhat.com
Errors-To: cluster-devel-bounces@redhat.com
To: Sagi Grimberg <sagi@grimberg.me>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-mm@kvack.org, dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>, "Darrick J . Wong" <darrick.wong@oracle.com>, cluster-devel@redhat.com, linux-ext4@vger.kernel.org, Shaohua Li <shli@kernel.org>, Kent Overstreet <kent.overstreet@gmail.com>, Boaz Harrosh <ooo@electrozaur.com>, Gao Xiang <gaoxiang25@huawei.com>, Coly Li <colyli@suse.de>, linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org
List-Id: dm-devel.ids

On Tue, Nov 20, 2018 at 12:11:35PM -0800, Sagi Grimberg wrote:
> 
> > > > The only user in your final tree seems to be the loop driver, and
> > > > even that one only uses the helper for read/write bios.
> > > > 
> > > > I think something like this would be much simpler in the end:
> > > 
> > > The recently submitted nvme-tcp host driver should also be a user
> > > of this. Does it make sense to keep it as a helper then?
> > 
> > I did take a brief look at the code, and I really don't understand
> > why the heck it even deals with bios to start with.  Like all the
> > other nvme transports it is a blk-mq driver and should iterate
> > over segments in a request and more or less ignore bios.  Something
> > is horribly wrong in the design.
> 
> Can you explain a little more? I'm more than happy to change that but
> I'm not completely clear how...
> 
> Before we begin a data transfer, we need to set our own iterator that
> will advance with the progression of the data transfer. We also need to
> keep in mind that all the data transfer (both send and recv) are
> completely non blocking (and zero-copy when we send).
> 
> That means that every data movement needs to be able to suspend
> and resume asynchronously. i.e. we cannot use the following pattern:
> rq_for_each_segment(bvec, rq, rq_iter) {
> 	iov_iter_bvec(&iov_iter, WRITE, &bvec, 1, bvec.bv_len);
> 	send(sock, iov_iter);
> }

Not sure I understand the 'blocking' problem in this case.

We can build a bvec table from this req, and send them all
in send(), can this way avoid your blocking issue? You may see this
example in branch 'rq->bio != rq->biotail' of lo_rw_aio().

If this way is what you need, I think you are right, even we may
introduce the following helpers:

	rq_for_each_bvec()
	rq_bvecs()

So looks nvme-tcp host driver might be the 2nd driver which benefits
from multi-page bvec directly.

The multi-page bvec V11 has passed my tests and addressed almost
all the comments during review on V10. I removed bio_vecs() in V11,
but it won't be big deal, we can introduce them anytime when there
is the requirement.

Thanks,
Ming
