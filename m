From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: confusion about multipath_prepare_ioctl
Date: Tue, 6 Mar 2018 00:44:22 -0500
Message-ID: <20180306054422.GA19607@redhat.com>
References: <tencent_16F29DEA1877E6C6D13CB47D4E3B41358508@qq.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <tencent_16F29DEA1877E6C6D13CB47D4E3B41358508@qq.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Wang Sheng-Hui <shhuiw@foxmail.com>
Cc: dm-devel <dm-devel@redhat.com>, hch <hch@lst.de>
List-Id: dm-devel.ids

On Mon, Mar 05 2018 at 10:35pm -0500,
Wang Sheng-Hui <shhuiw@foxmail.com> wrote:

> Dear,
> 
> Sorry to trouble you.
> 
> I noticed some code in dm-*.c like:
> "
> static int multipath_prepare_ioctl(struct dm_target *ti,
> 		struct block_device **bdev, fmode_t *mode)
> {
> ...
> 	/*
> 	 * Only pass ioctls through if the device sizes match exactly.
> 	 */
> 	if (!r && ti->len != i_size_read((*bdev)->bd_inode) >> SECTOR_SHIFT)
> 		return 1;
> ...
> }
> "
> Here, return value 1 means 
> "ioctl is being issued against a subset of the parent bdev; require extra privileges."
> (comment in dm_blk_ioctl)
> 
> I'm confused by the comment and '!=' test for multipath. 
> In which cases, the size of low level single device is not equal to the parent 
> size of multipath device?

Given that ti->len is sent down from userspace, the DM multipath
target's ti->len _could_ be smaller than the underlying path(s).  But in
practice that doesn't occur with multipathd.. a partitioned multipath
device is generally done, via kpartx, in terms of linear mappings ontop
of the multipath device.

The same != test is done in the dm linear target and is much more
relevant to concerns about ioctls being sent to partition.

Mike
