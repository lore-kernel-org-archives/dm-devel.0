From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH V11 02/19] block: introduce multi-page bvec helpers
Date: Wed, 21 Nov 2018 14:19:28 +0100
Message-ID: <20181121131928.GA1640@lst.de>
References: <20181121032327.8434-1-ming.lei@redhat.com> <20181121032327.8434-3-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181121032327.8434-3-ming.lei@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Theodore Ts'o <tytso@mit.edu>, Omar Sandoval <osandov@fb.com>, Sagi Grimberg <sagi@grimberg.me>, Dave Chinner <dchinner@redhat.com>, Kent Overstreet <kent.overstreet@gmail.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>, Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, Boaz Harrosh <oo>
List-Id: dm-devel.ids

On Wed, Nov 21, 2018 at 11:23:10AM +0800, Ming Lei wrote:
> This patch introduces helpers of 'segment_iter_*' for multipage
> bvec support.
> 
> The introduced helpers treate one bvec as real multi-page segment,
> which may include more than one pages.

Unless I'm missing something these bvec vs segment names are exactly
inverted vs how we use it elsewhere.

In the iterators we use segment for single-page bvec, and bvec for multi
page ones, and here it is inverse.  Please switch it around.
