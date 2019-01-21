From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH V14 00/18] block: support multi-page bvec
Date: Mon, 21 Jan 2019 01:43:21 -0800
Message-ID: <61dfaa1e-e7bf-75f1-410b-ed32f97d0782@grimberg.me>
References: <20190121081805.32727-1-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190121081805.32727-1-ming.lei@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Theodore Ts'o <tytso@mit.edu>, Omar Sandoval <osandov@fb.com>, Dave Chinner <dchinner@redhat.com>, Kent Overstreet <kent.overstreet@gmail.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>, Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, Boaz Harrosh <ooo@electrozaur.com>, Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com
List-Id: dm-devel.ids


> V14:
> 	- drop patch(patch 4 in V13) for renaming bvec helpers, as suggested by Jens
> 	- use mp_bvec_* as multi-page bvec helper name
> 	- fix one build issue, which is caused by missing one converion of
> 	bio_for_each_segment_all in fs/gfs2
> 	- fix one 32bit ARCH specific issue caused by segment boundary mask
> 	overflow

Hey Ming,

So is nvme-tcp also affected here? The only point where I see nvme-tcp
can be affected is when initializing a bvec iter using bio_segments() as
everywhere else we use iters which should transparently work..

I see that loop was converted, does it mean that nvme-tcp needs to
call something like?
--
	bio_for_each_mp_bvec(bv, bio, iter)
		nr_bvecs++;
--
