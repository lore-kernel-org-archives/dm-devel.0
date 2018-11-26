From: Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH V12 15/20] block: allow bio_for_each_segment_all() to
 iterate over multi-page bvec
Date: Mon, 26 Nov 2018 14:42:39 -0800
Message-ID: <20181126224239.GL30411@vader>
References: <20181126021720.19471-1-ming.lei@redhat.com>
 <20181126021720.19471-16-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181126021720.19471-16-ming.lei@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Theodore Ts'o <tytso@mit.edu>, Omar Sandoval <osandov@fb.com>, Sagi Grimberg <sagi@grimberg.me>, Dave Chinner <dchinner@redhat.com>, Kent Overstreet <kent.overstreet@gmail.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>, Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, Boaz Harrosh <oo>
List-Id: dm-devel.ids

On Mon, Nov 26, 2018 at 10:17:15AM +0800, Ming Lei wrote:
> This patch introduces one extra iterator variable to bio_for_each_segment_all(),
> then we can allow bio_for_each_segment_all() to iterate over multi-page bvec.
> 
> Given it is just one mechannical & simple change on all bio_for_each_segment_all()
> users, this patch does tree-wide change in one single patch, so that we can
> avoid to use a temporary helper for this conversion.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  block/bio.c                       | 27 ++++++++++++++++++---------
>  block/bounce.c                    |  6 ++++--
>  drivers/md/bcache/btree.c         |  3 ++-
>  drivers/md/dm-crypt.c             |  3 ++-
>  drivers/md/raid1.c                |  3 ++-
>  drivers/staging/erofs/data.c      |  3 ++-
>  drivers/staging/erofs/unzip_vle.c |  3 ++-
>  fs/block_dev.c                    |  6 ++++--
>  fs/btrfs/compression.c            |  3 ++-
>  fs/btrfs/disk-io.c                |  3 ++-
>  fs/btrfs/extent_io.c              |  9 ++++++---
>  fs/btrfs/inode.c                  |  6 ++++--
>  fs/btrfs/raid56.c                 |  3 ++-
>  fs/crypto/bio.c                   |  3 ++-
>  fs/direct-io.c                    |  4 +++-
>  fs/exofs/ore.c                    |  3 ++-
>  fs/exofs/ore_raid.c               |  3 ++-
>  fs/ext4/page-io.c                 |  3 ++-
>  fs/ext4/readpage.c                |  3 ++-
>  fs/f2fs/data.c                    |  9 ++++++---
>  fs/gfs2/lops.c                    |  6 ++++--
>  fs/gfs2/meta_io.c                 |  3 ++-
>  fs/iomap.c                        |  6 ++++--
>  fs/mpage.c                        |  3 ++-
>  fs/xfs/xfs_aops.c                 |  5 +++--
>  include/linux/bio.h               | 11 +++++++++--
>  include/linux/bvec.h              | 30 ++++++++++++++++++++++++++++++
>  27 files changed, 125 insertions(+), 45 deletions(-)
