From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH v2] dm zoned: Silence a static checker warning
Date: Wed, 10 Apr 2019 08:06:20 +0000
Message-ID: <BYAPR04MB5816FEE78EAE7806B8AB955AE72E0@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20190410074735.GA28842@kadam>
	<BYAPR04MB58160DF520B305A4328FC438E72E0@BYAPR04MB5816.namprd04.prod.outlook.com>
	<20190410080305.GQ6070@kadam>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.com>, "Martin K.
	Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Greg Edwards <gedwards@ddn.com>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>, Ming Lei <ming.lei@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Omar Sandoval <osandov@fb.com>, Alasdair Kergon <agk@redhat.com>, Bart Van Assche <bvanassche@acm.org>
List-Id: dm-devel.ids

On 2019/04/10 17:03, Dan Carpenter wrote:
> On Wed, Apr 10, 2019 at 07:56:14AM +0000, Damien Le Moal wrote:
>> On 2019/04/10 16:48, Dan Carpenter wrote:
>>> My static checker complains about this line from dmz_get_zoned_device()
>>>
>>> 	aligned_capacity = dev->capacity & ~(blk_queue_zone_sectors(q) - 1);
>>>
>>> The problem is that "aligned_capacity" and "dev->capacity" are sector_t
>>> type (which is a u64) but blk_queue_zone_sectors(q) returns a u32 so the
>>> higher 32 bits in "aligned_capacity" are always cleared to zero.  This
>>> patch adds a cast to u64 to address this issue.
>>>
>>> Fixes: 114e025968b5 ("dm zoned: ignore last smaller runt zone")
>>> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>>> ---
>>> v2: In v1 I changed blk_queue_zone_sectors() to return a sector_t type,
>>> but in v2 I just add a cast.  The v2 fix would end up going through
>>> different maintainers and reviewers so the CC list has grown...
>>>
>>> Original discussion: https://marc.info/?l=kernel-janitors&m=155487663405737&w=2
>>>
>>>  drivers/md/dm-zoned-target.c | 3 ++-
>>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
>>> index 8865c1709e16..b6cb44fa946d 100644
>>> --- a/drivers/md/dm-zoned-target.c
>>> +++ b/drivers/md/dm-zoned-target.c
>>> @@ -643,7 +643,8 @@ static int dmz_get_zoned_device(struct dm_target *ti, char *path)
>>>  
>>>  	q = bdev_get_queue(dev->bdev);
>>>  	dev->capacity = i_size_read(dev->bdev->bd_inode) >> SECTOR_SHIFT;
>>> -	aligned_capacity = dev->capacity & ~(blk_queue_zone_sectors(q) - 1);
>>> +	aligned_capacity = dev->capacity &
>>> +				~((u64)blk_queue_zone_sectors(q) - 1);
>>
>> sector_t is an u64 only if CONFIG_LBDAF is defined (I think this option is going
>> away though). Otherwise it is an unsigned long which would be u32 on 32 bits
>> arch. Not a problem in terms of arithmetic, but why not cast to sector_t directly ?
>>
> 
> I would have prefered to do that but I didn't have strong feelings
> either way.  I am always slight annoyed when people don't just copy and
> paste my code when I tell them how to fix a patch so I decided to go
> with your version...  :P

I proposed u64 cast without checking sector_t definition.
After doing that, I liked your sector_t cast more than my own misinformed
proposal :)

-- 
Damien Le Moal
Western Digital Research
