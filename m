From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V10 13/19] iomap & xfs: only account for new added page
Date: Mon, 19 Nov 2018 16:39:22 +0800
Message-ID: <20181119083921.GJ16736@ming.t460p>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-14-ming.lei@redhat.com>
 <20181116134936.GJ3165@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181116134936.GJ3165@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Dave Chinner <dchinner@redhat.com>, Kent Overstreet <kent.overstreet@gmail.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, linux-erofs@lists.ozlabs.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>, Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, Boaz Harrosh <ooo@electrozaur.com>, Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat
List-Id: dm-devel.ids

On Fri, Nov 16, 2018 at 02:49:36PM +0100, Christoph Hellwig wrote:
> I'd much rather have __bio_try_merge_page only do merges in
> the same page, and have a new __bio_try_merge_segment that does
> multi-page merges.  This will keep the accounting a lot simpler.

Looks this way is clever, will do it in next version.

Thanks,
Ming
