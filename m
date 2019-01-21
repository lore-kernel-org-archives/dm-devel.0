From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V14 00/18] block: support multi-page bvec
Date: Mon, 21 Jan 2019 16:37:12 +0800
Message-ID: <20190121083711.GA29495@ming.t460p>
References: <20190121081805.32727-1-ming.lei@redhat.com>
	<20190121082246.GA18305@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20190121082246.GA18305@lst.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@lst.de>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-mm@kvack.org, dm-devel@redhat.com, Omar Sandoval <osandov@fb.com>, Sagi Grimberg <sagi@grimberg.me>, "Darrick J . Wong" <darrick.wong@oracle.com>, cluster-devel@redhat.com, linux-ext4@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>, Boaz Harrosh <ooo@electrozaur.com>, Gao Xiang <gaoxiang25@huawei.com>, Coly Li <colyli@suse.de>, linux-raid@vger.kernel.org, Bob Peterson <rpeterso@redhat.com>, linux-bcache@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Dave Chinner <dchinner@redhat.com>, David Sterba <dsterba@suse.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
List-Id: dm-devel.ids

On Mon, Jan 21, 2019 at 09:22:46AM +0100, Christoph Hellwig wrote:
> On Mon, Jan 21, 2019 at 04:17:47PM +0800, Ming Lei wrote:
> > V14:
> > 	- drop patch(patch 4 in V13) for renaming bvec helpers, as suggested by Jens
> > 	- use mp_bvec_* as multi-page bvec helper name
> 
> WTF?  Where is this coming from?  mp is just a nightmare of a name,
> and I also didn't see any comments like that.

You should see the recent discussion in which Jens doesn't agree on
renaming bvec helper name, so the previous patch of 'block: rename bvec helpers'
has to be dropped, and we have to find a new name for multi-page bvec
helpers.

Jens mentioned we can do the rename in next release after the whole
patchset is merged first, then I think mp_bvec_* should be fine since
its life time is short.

Or do you other suggestion?

Thanks,
Ming
