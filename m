From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH V11 14/19] block: handle non-cluster bio out of
 blk_bio_segment_split
Date: Thu, 22 Nov 2018 11:47:29 +0100
Message-ID: <20181122104729.GA29938@lst.de>
References: <20181121032327.8434-1-ming.lei@redhat.com> <20181121032327.8434-15-ming.lei@redhat.com> <20181121143355.GB2594@lst.de> <20181121153726.GC19111@ming.t460p> <20181121174621.GA6961@lst.de> <20181122093259.GA27007@ming.t460p> <20181122100427.GA28871@lst.de> <20181122103208.GD27273@ming.t460p> <20181122104150.GA29808@lst.de> <20181122104604.GE27273@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181122104604.GE27273@ming.t460p>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Theodore Ts'o <tytso@mit.edu>, Omar Sandoval <osandov@fb.com>, Sagi Grimberg <sagi@grimberg.me>, Dave Chinner <dchinner@redhat.com>, Kent Overstreet <kent.overstreet@gmail.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>, linux-ext4@vger.kernel.org, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, Boaz Harrosh <oo>
List-Id: dm-devel.ids

On Thu, Nov 22, 2018 at 06:46:05PM +0800, Ming Lei wrote:
> Then your patch should work by just replacing virt boundary with segment
> boudary limit. I will do that change in V12 if you don't object.

Please do, thanks a lot.
