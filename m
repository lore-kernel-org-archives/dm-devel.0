From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] fs/block_dev.c: Remove WARN_ON() when inode writeback fails
Date: Thu, 15 Oct 2015 12:23:06 -0400
Message-ID: <x498u74gkyd.fsf@segfault.boston.devel.redhat.com>
References: <20150622184118.GA11277@redhat.com>
	<20150810193725.GC19173@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150810193725.GC19173@redhat.com> (Vivek Goyal's message of
	"Mon, 10 Aug 2015 15:37:25 -0400")
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
List-Id: dm-devel.ids

Vivek Goyal <vgoyal@redhat.com> writes:

> Hi Jens,
>
> Do you have concerns with this patch? If not, can you please include it.

The concept is fine, but:

>> -static void bdev_write_inode(struct inode *inode)
>> +static void bdev_write_inode(struct block_device *bdev)
>>  {
>> +	struct inode *inode = bdev->bd_inode;
>> +	int ret;
>> +
>>  	spin_lock(&inode->i_lock);
>>  	while (inode->i_state & I_DIRTY) {
>>  		spin_unlock(&inode->i_lock);
>> -		WARN_ON_ONCE(write_inode_now(inode, true));
>> +		ret = write_inode_now(inode, true);
>> +		if (ret) {
>> +			char name[BDEVNAME_SIZE] = "";

that initializer isn't necessary.

Cheers,
Jeff
