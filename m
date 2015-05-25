From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4 08/11] block: kill merge_bvec_fn() completely
Date: Mon, 25 May 2015 17:08:27 +0200
Message-ID: <20150525150827.GA27012@lst.de>
References: <1432318723-18829-1-git-send-email-mlin@kernel.org> <1432318723-18829-9-git-send-email-mlin@kernel.org> <20150525140413.GA26065@lst.de> <CAOi1vP8vNEXw2e1eWa4LqKD14SA7XtSQ_C8+4d_sz20t4nfEng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOi1vP8vNEXw2e1eWa4LqKD14SA7XtSQ_C8+4d_sz20t4nfEng@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ilya Dryomov <idryomov@gmail.com>
Cc: Ming Lin <mlin@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kent Overstreet <kent.overstreet@gmail.com>, Jens Axboe <axboe@kernel.dk>, Dongsu Park <dpark@posteo.net>, Lars Ellenberg <drbd-dev@lists.linbit.com>, drbd-user@lists.linbit.com, Jiri Kosina <jkosina@suse.cz>, Yehuda Sadeh <yehuda@inktank.com>, Sage Weil <sage@inktank.com>, Alex Elder <elder@kernel.org>, Ceph Development <ceph-devel@vger.kernel.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Alex Elder <elder@linaro.org>
List-Id: dm-devel.ids

On Mon, May 25, 2015 at 06:02:30PM +0300, Ilya Dryomov wrote:
> I'm not Alex, but yeah, we have all the clone/split machinery and so we
> can handle a spanning case just fine.  I think rbd_merge_bvec() exists
> to make sure we don't have to do that unless it's really necessary -
> like when a single page gets submitted at an inconvenient offset.
> 
> I have a patch that adds a blk_queue_chunk_sectors(object_size) call to
> rbd_init_disk() but I haven't had a chance to play with it yet.  In any
> case, we should be fine with getting rid of rbd_merge_bvec().  If this
> ends up a per-driver patchset, I can make rbd_merge_bvec() ->
> blk_queue_chunk_sectors() a single patch and push it through
> ceph-client.git.

Hmm, looks like the new blk_queue_split_bio ignore the chunk_sectors
value, another thing that needs updating.  I forgot how many weird
merging hacks we had to add for nvme..

While I'd like to see per-driver patches we'd still need to merge
them together through the block tree.  Note that with this series
there won't be any benefit of using blk_queue_chunk_sectors over just
doing the split in rbd.  Maybe we can even remove it again and do
that work in the drivers in the future.
