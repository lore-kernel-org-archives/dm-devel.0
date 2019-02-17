From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V15 00/18] block: support multi-page bvec
Date: Sun, 17 Feb 2019 21:10:23 +0800
Message-ID: <20190217131022.GA7296@ming.t460p>
References: <20190215111324.30129-1-ming.lei@redhat.com>
 <20190215145126.GA16717@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190215145126.GA16717@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Theodore Ts'o <tytso@mit.edu>, Omar Sandoval <osandov@fb.com>, Sagi Grimberg <sagi@grimberg.me>, Dave Chinner <dchinner@redhat.com>, Kent Overstreet <kent.overstreet@gmail.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>, linux-ext4@vger.kernel.org, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, Boaz Harrosh <ooo@electrozaur.com>, Bob Peterson <rpeterso@redhat.com>, cluster-devel@
List-Id: dm-devel.ids

On Fri, Feb 15, 2019 at 03:51:26PM +0100, Christoph Hellwig wrote:
> I still don't understand why mp_bvec_last_segment isn't simply
> called bvec_last_segment as there is no conflict.  But I don't
> want to hold this series up on that as there only are two users
> left and we can always just fix it up later.

mp_bvec_last_segment() is one bvec helper, so better to keep its
name consistent with other bvec helpers.

Thanks,
Ming
