From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH V10 19/19] block: kill BLK_MQ_F_SG_MERGE
Date: Fri, 16 Nov 2018 14:59:37 +0100
Message-ID: <20181116135937.GP3165@lst.de>
References: <20181115085306.9910-1-ming.lei@redhat.com> <20181115085306.9910-20-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181115085306.9910-20-ming.lei@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Dave Chinner <dchinner@redhat.com>, Kent Overstreet <kent.overstreet@gmail.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, linux-erofs@lists.ozlabs.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>, Christoph Hellwig <hch@lst.de>, Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, Boaz Harrosh <ooo@electrozaur.com>, Bob Peterson <rpeterso@r>
List-Id: dm-devel.ids

On Thu, Nov 15, 2018 at 04:53:06PM +0800, Ming Lei wrote:
> QUEUE_FLAG_NO_SG_MERGE has been killed, so kill BLK_MQ_F_SG_MERGE too.

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
