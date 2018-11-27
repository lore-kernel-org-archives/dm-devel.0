From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V12 16/20] block: enable multipage bvecs
Date: Tue, 27 Nov 2018 10:25:19 +0800
Message-ID: <20181127022517.GC25199@ming.t460p>
References: <20181126021720.19471-1-ming.lei@redhat.com>
 <20181126021720.19471-17-ming.lei@redhat.com>
 <20181126125842.GE6383@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181126125842.GE6383@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Theodore Ts'o <tytso@mit.edu>, Omar Sandoval <osandov@fb.com>, Sagi Grimberg <sagi@grimberg.me>, Dave Chinner <dchinner@redhat.com>, Kent Overstreet <kent.overstreet@gmail.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>, linux-ext4@vger.kernel.org, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, Boaz Harrosh <ooo@electrozaur.com>, Bob
List-Id: dm-devel.ids

On Mon, Nov 26, 2018 at 01:58:42PM +0100, Christoph Hellwig wrote:
> > +		phys_addr_t vec_end_addr = page_to_phys(bv->bv_page) +
> > +			bv->bv_offset + bv->bv_len;
> 
> The name is a little confusing, as the real end addr would be -1.  Maybe
> throw the -1 in here, and adjust for it in the contigous check below?

Yeah, it makes sense.

thanks,
Ming
