From: Nikolay Borisov <nborisov@suse.com>
Subject: Re: [PATCH V11 17/19] block: document usage of bio iterator helpers
Date: Wed, 21 Nov 2018 09:45:25 +0200
Message-ID: <1f93e845-09e8-2c6c-3643-654b8c490597@suse.com>
References: <20181121032327.8434-1-ming.lei@redhat.com>
 <20181121032327.8434-18-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20181121032327.8434-18-ming.lei@redhat.com>
Content-Language: en-US
Sender: linux-btrfs-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Theodore Ts'o <tytso@mit.edu>, Omar Sandoval <osandov@fb.com>, Sagi Grimberg <sagi@grimberg.me>, Dave Chinner <dchinner@redhat.com>, Kent Overstreet <kent.overstreet@gmail.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>, Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, Boaz Harrosh <ooo@electrozaur.com>Bo
List-Id: dm-devel.ids



On 21.11.18 г. 5:23 ч., Ming Lei wrote:
> Now multi-page bvec is supported, some helpers may return page by
> page, meantime some may return segment by segment, this patch
> documents the usage.
> 
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  Documentation/block/biovecs.txt | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/Documentation/block/biovecs.txt b/Documentation/block/biovecs.txt
> index 25689584e6e0..bb008f7afb05 100644
> --- a/Documentation/block/biovecs.txt
> +++ b/Documentation/block/biovecs.txt
> @@ -117,3 +117,27 @@ Other implications:
>     size limitations and the limitations of the underlying devices. Thus
>     there's no need to define ->merge_bvec_fn() callbacks for individual block
>     drivers.
> +
> +Usage of helpers:
> +=================
> +
> +* The following helpers whose names have the suffix of "_all" can only be used
> +on non-BIO_CLONED bio. They are usually used by filesystem code. Drivers
> +shouldn't use them because the bio may have been split before it reached the
> +driver.
> +
> +	bio_for_each_segment_all()
> +	bio_first_bvec_all()
> +	bio_first_page_all()
> +	bio_last_bvec_all()
> +
> +* The following helpers iterate over single-page bvecs. The passed 'struct
> +bio_vec' will contain a single-page IO vector during the iteration
> +
> +	bio_for_each_segment()
> +	bio_for_each_segment_all()
> +
> +* The following helpers iterate over single-page bvecs. The passed 'struct
> +bio_vec' will contain a single-page IO vector during the iteration
> +
> +	bio_for_each_bvec()

Just put this helper right below the above 2, no need to repeat the
explanation. Also I'd suggest introducing another catch-all sentence
"All other helpers are assumed to iterate multipage bio vecs" and
perhaps give an example with 1-2 helpers.

> 
