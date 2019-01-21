From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH V14 00/18] block: support multi-page bvec
Date: Mon, 21 Jan 2019 09:22:46 +0100
Message-ID: <20190121082246.GA18305@lst.de>
References: <20190121081805.32727-1-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190121081805.32727-1-ming.lei@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Theodore Ts'o <tytso@mit.edu>, Omar Sandoval <osandov@fb.com>, Sagi Grimberg <sagi@grimberg.me>, Dave Chinner <dchinner@redhat.com>, Kent Overstreet <kent.overstreet@gmail.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>, Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, Boaz Harrosh <ooo@electrozaur.com>, Bob
List-Id: dm-devel.ids

On Mon, Jan 21, 2019 at 04:17:47PM +0800, Ming Lei wrote:
> V14:
> 	- drop patch(patch 4 in V13) for renaming bvec helpers, as suggested by Jens
> 	- use mp_bvec_* as multi-page bvec helper name

WTF?  Where is this coming from?  mp is just a nightmare of a name,
and I also didn't see any comments like that.
