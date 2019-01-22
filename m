From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V14 00/18] block: support multi-page bvec
Date: Tue, 22 Jan 2019 10:01:30 +0800
Message-ID: <20190122020128.GB2490@ming.t460p>
References: <20190121081805.32727-1-ming.lei@redhat.com>
	<61dfaa1e-e7bf-75f1-410b-ed32f97d0782@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <cluster-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <61dfaa1e-e7bf-75f1-410b-ed32f97d0782@grimberg.me>
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
Cc: Mike Snitzer <snitzer@redhat.com>, linux-mm@kvack.org, dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>, "Darrick J . Wong" <darrick.wong@oracle.com>, Omar Sandoval <osandov@fb.com>, cluster-devel@redhat.com, linux-ext4@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>, Boaz Harrosh <ooo@electrozaur.com>, Gao Xiang <gaoxiang25@huawei.com>, Coly Li <colyli@suse.de>, linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
List-Id: dm-devel.ids

On Mon, Jan 21, 2019 at 01:43:21AM -0800, Sagi Grimberg wrote:
> 
> > V14:
> > 	- drop patch(patch 4 in V13) for renaming bvec helpers, as suggested by Jens
> > 	- use mp_bvec_* as multi-page bvec helper name
> > 	- fix one build issue, which is caused by missing one converion of
> > 	bio_for_each_segment_all in fs/gfs2
> > 	- fix one 32bit ARCH specific issue caused by segment boundary mask
> > 	overflow
> 
> Hey Ming,
> 
> So is nvme-tcp also affected here? The only point where I see nvme-tcp
> can be affected is when initializing a bvec iter using bio_segments() as
> everywhere else we use iters which should transparently work..
> 
> I see that loop was converted, does it mean that nvme-tcp needs to
> call something like?
> --
> 	bio_for_each_mp_bvec(bv, bio, iter)
> 		nr_bvecs++;

bio_for_each_segment()/bio_segments() still works, just not as efficient
as bio_for_each_mp_bvec() given each multi-page bvec(very similar with scatterlist)
is returned in each loop.

I don't look at nvme-tcp code yet. But if nvme-tcp supports this way,
it can benefit from bio_for_each_mp_bvec().

Thanks,
Ming
