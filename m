From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH V11 02/19] block: introduce multi-page bvec helpers
Date: Wed, 21 Nov 2018 17:08:11 +0100
Message-ID: <20181121160811.GA4977@lst.de>
References: <20181121032327.8434-1-ming.lei@redhat.com> <20181121032327.8434-3-ming.lei@redhat.com> <20181121131928.GA1640@lst.de> <20181121150610.GA19111@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181121150610.GA19111@ming.t460p>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Theodore Ts'o <tytso@mit.edu>, Omar Sandoval <osandov@fb.com>, Sagi Grimberg <sagi@grimberg.me>, Dave Chinner <dchinner@redhat.com>, Kent Overstreet <kent.overstreet@gmail.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>, linux-ext4@vger.kernel.org, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, Boaz Harrosh <oo>
List-Id: dm-devel.ids

On Wed, Nov 21, 2018 at 11:06:11PM +0800, Ming Lei wrote:
> bvec_iter_* is used for single-page bvec in current linus tree, and there are
> lots of users now:
> 
> [linux]$ git grep -n "bvec_iter_*" ./ | wc
>     191     995   13242
> 
> If we have to switch it first, it can be a big change, just wondering if Jens
> is happy with that?

Your above grep statement seems to catch every use of struct bvec_iter,
due to the *.

Most uses of bvec_iter_ are either in the block headers, or are
ceph wrappers that match the above and can easily be redefined.
