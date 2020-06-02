From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH] block: fix an integer overflow in logical block size
Date: Tue, 2 Jun 2020 14:39:21 -0700
Message-ID: <20200602213921.GA229073@gmail.com>
References: <alpine.LRH.2.02.2001150833180.31494@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.2001150833180.31494@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, dm-devel@redhat.com, linux-block@vger.kernel.org, Mike Snitzer <msnitzer@redhat.com>
List-Id: dm-devel.ids

On Wed, Jan 15, 2020 at 08:35:25AM -0500, Mikulas Patocka wrote:
> Logical block size has type unsigned short. That means that it can be at
> most 32768. However, there are architectures that can run with 64k pages
> (for example arm64) and on these architectures, it may be possible to
> create block devices with 64k block size.
> 
> For exmaple (run this on an architecture with 64k pages):
> # modprobe brd rd_size=1048576
> # dmsetup create cache --table "0 `blockdev --getsize /dev/ram0` writecache s /dev/ram0 /dev/ram1 65536 0"
> # mkfs.ext4 -b 65536 /dev/mapper/cache
> # mount -t ext4 /dev/mapper/cache /mnt/test
> 
> Mount will fail with this error because it tries to read the superblock using 2-sector
> access:
>   device-mapper: writecache: I/O is not aligned, sector 2, size 1024, block size 65536
>   EXT4-fs (dm-0): unable to read superblock
> 
> This patch changes the logical block size from unsigned short to unsigned
> int to avoid the overflow.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Mikulas, a question about this patch.  In crypt_io_hints() in
drivers/md/dm-crypt.c there is:

       limits->logical_block_size =
                max_t(unsigned short, limits->logical_block_size, cc->sector_size);

Shouldn't that have been changed to 'unsigned int', now that
limits->logical_block_size is 'unsigned int' rather than 'unsigned short'?

- Eric
