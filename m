From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH V10 08/19] btrfs: move bio_pages_all() to btrfs
Date: Mon, 19 Nov 2018 09:24:14 +0100
Message-ID: <20181119082414.GA10678@lst.de>
References: <20181115085306.9910-1-ming.lei@redhat.com> <20181115085306.9910-9-ming.lei@redhat.com> <20181116133845.GG3165@lst.de> <20181119081922.GB16736@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181119081922.GB16736@ming.t460p>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Dave Chinner <dchinner@redhat.com>, Kent Overstreet <kent.overstreet@gmail.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, linux-erofs@lists.ozlabs.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>, Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, Boaz Harrosh <ooo@electrozaur.com>, Bob Peterson <rpeterso@r>
List-Id: dm-devel.ids

On Mon, Nov 19, 2018 at 04:19:24PM +0800, Ming Lei wrote:
> On Fri, Nov 16, 2018 at 02:38:45PM +0100, Christoph Hellwig wrote:
> > On Thu, Nov 15, 2018 at 04:52:55PM +0800, Ming Lei wrote:
> > > BTRFS is the only user of this helper, so move this helper into
> > > BTRFS, and implement it via bio_for_each_segment_all(), since
> > > bio->bi_vcnt may not equal to number of pages after multipage bvec
> > > is enabled.
> > 
> > btrfs only uses the value to check if it is larger than 1.  No amount
> > of multipage bio merging should ever make bi_vcnt go from 0 to 1 or
> > vice versa.
> 
> Could you explain a bit why?
> 
> Suppose 2 physically continuous pages are added to this bio, .bi_vcnt
> can be 1 in case of multi-page bvec, but it is 2 in case of single-page
> bvec.

True, I did think of 0 vs 1.

The magic here in btrfs still doesn't make much sense.  The comments
down in btrfs_check_repairable talk about sectors, so it might be a
leftover from the blocksize == PAGE_SIZE days (assuming those patches
actually got merged).  I'd like to have the btrfs folks chime in,
but in the end we should probably check if the bio was larger than
a single sector here.
