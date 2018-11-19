From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V10 08/19] btrfs: move bio_pages_all() to btrfs
Date: Mon, 19 Nov 2018 16:15:09 +0800
Message-ID: <20181119081507.GA16736@ming.t460p>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-9-ming.lei@redhat.com>
 <20181116002356.GC23828@vader>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181116002356.GC23828@vader>
Sender: linux-kernel-owner@vger.kernel.org
To: Omar Sandoval <osandov@osandov.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Dave Chinner <dchinner@redhat.com>, Kent Overstreet <kent.overstreet@gmail.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, linux-erofs@lists.ozlabs.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>, Christoph Hellwig <hch@lst.de>, Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, Boaz Harrosh <ooo@electrozaur.com>, Bob Peterson <rpeterso@r>
List-Id: dm-devel.ids

On Thu, Nov 15, 2018 at 04:23:56PM -0800, Omar Sandoval wrote:
> On Thu, Nov 15, 2018 at 04:52:55PM +0800, Ming Lei wrote:
> > BTRFS is the only user of this helper, so move this helper into
> > BTRFS, and implement it via bio_for_each_segment_all(), since
> > bio->bi_vcnt may not equal to number of pages after multipage bvec
> > is enabled.
> 
> Shouldn't you also get rid of bio_pages_all() in this patch?

Good catch!

thanks,
Ming
