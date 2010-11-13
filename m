From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH UPDATED 1/5] mtd: fix bdev exclusive open bugs in block2mtd::add_device()
Date: Sat, 13 Nov 2010 12:18:03 +0100
Message-ID: <4CDE73EB.2090208@kernel.org>
References: <1288628129-12811-1-git-send-email-tj@kernel.org>	 <1288628129-12811-2-git-send-email-tj@kernel.org>	 <4CDE6FAA.9030605@kernel.org> <1289646865.2218.27.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <reiserfs-devel-owner@vger.kernel.org>
In-Reply-To: <1289646865.2218.27.camel@localhost>
Sender: reiserfs-devel-owner@vger.kernel.org
To: dedekind1@gmail.com
Cc: axboe@kernel.dk, hch@infradead.org, linux-kernel@vger.kernel.org, petero2@telia.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, jack@suse.cz, akpm@linux-foundation.org, adilger.kernel@dilger.ca, tytso@mit.edu, mfasheh@suse.com, joel.becker@oracle.com, aelder@sgi.com, dm-devel@redhat.com, drbd-dev@lists.linbit.com, neilb@suse.de, leochen@broadcom.com, sbranden@broadcom.com, chris.mason@oracle.com, swhiteho@redhat.com, shaggy@linux.vnet.ibm.com, joern@logfs.org, konishi.ryusuke@lab.ntt.co.jp, reiserfs-devel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-mtd@lists.infradead.org
List-Id: dm-devel.ids

Hello,

On 11/13/2010 12:14 PM, Artem Bityutskiy wrote:
> On Sat, 2010-11-13 at 11:59 +0100, Tejun Heo wrote:
>> There are two bdev exclusive open bugs.
>>
>> * open_bdev_exclusive() must not be called with NULL holder.  Use dev
>>   as the holder.
>>
>> * open_by_devnum() doesn't open the bdev exclusively but
>>   block2mtd_free_device() always assumes it.  Explicitly claim the
>>   bdev.
>>
>> The latter is rather clumsy but will be simplified with future
>> blkdev_get/put() cleanups.
>>
>> - Updated to use local variable @mode to cache FMODE_* masks as
>>   suggested by Artem Bityutskiy.
> 
> Do you want this patch to go in via Jens' tree with the rest of the
> series, or as an independent patch via the mtd tree?

It probably would be easier if this is routed through Jens' tree as
it's necessary for later patches in the series, but this being a fix,
this should be merged during this cycle rather than the next one.
Jens, how do you want to proceed?

Thank you.

-- 
tejun
