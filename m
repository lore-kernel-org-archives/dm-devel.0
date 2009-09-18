From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: fragmented i/o with 2.6.31?
Date: Fri, 18 Sep 2009 11:57:06 -0400
Message-ID: <20090918155706.GB28926@redhat.com>
References: <448b15030909160834j2b127c83jab163e1860fc9aa1@mail.gmail.com>
	<448b15030909160922o84c2d6gc8ead8226dd8777a@mail.gmail.com>
	<4AB1ED1F.1010203@ct.jp.nec.com> <4AB1FDEE.5020500@ce.jp.nec.com>
	<20090917131113.GA8163@redhat.com>
	<yq1skek94hw.fsf@sermon.lab.mkp.net>
	<20090918150650.GA28070@redhat.com> <4AB3A978.60006@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4AB3A978.60006@ce.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: device-mapper development <dm-devel@redhat.com>, Alasdair Kergon <agk@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <jens.axboe@oracle.com>
List-Id: dm-devel.ids

On Fri, Sep 18 2009 at 11:38am -0400,
Jun'ichi Nomura <j-nomura@ce.jp.nec.com> wrote:

> Mike Snitzer wrote:
>> On Fri, Sep 18 2009 at  2:00am -0400,
>> Martin K. Petersen <martin.petersen@oracle.com> wrote:
>>
>>>>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:
>>>>>>  	blk_set_default_limits(limits);
>>>>>> + limits->max_sectors = 0;
>>>>>> + limits->max_hw_sectors = 0;
>>> Mike> Seems like we may want some common variant in block even though
>>> Mike> I'm not aware of other block drivers that would benefit...
>>>
>>> Mike> But I'll defer to Martin and/or Jens on whether these helpers are
>>> Mike> fine to stay in dm-table.c or should be worked into blk-settings.c
>>>
>>> In the pre-topology days we set max_sectors to SAFE_MAX_SECTORS upon
>>> creation of a queue.  This is an old ATA-ism that's been around for a
>>> ages.
>>>
>>> Ideally we'd simply nuke it and drivers that really needed to lower the
>>> bar would explicitly call blk_queue_max_sectors().  However, I'm afraid
>>> to change the default because I'm sure there are legacy drivers lurking
>>> somewhere that depend on it.
>>>
>>> Seeing as blk_set_default_limits() is mostly aimed at stacking drivers I
>>> think I'd prefer moving SAFE_MAX_SECTORS back to blk_queue_make_request
>>> and then set max_sectors and max_hw_sectors to 0 in default_limits.
>>>
>>> Would that work for you guys?
>>
>> So you're referring to fact that this commit removed
>> blk_queue_max_sectors(q, SAFE_MAX_SECTORS) from blk_queue_make_request:
>> http://git.kernel.org/linus/e475bba2
>>
>> I think I like your proposal.  But, to clarify things further, are you
>> saying:
>>
>> By moving SAFE_MAX_SECTORS back to blk_queue_make_request (after its
>> existing call to blk_set_default_limits right?) and having
>> blk_set_default_limits set max_sectors and max_hw_sectors to 0:
>>
>> DM will be free to establish the proper limit stacking because the DM
>> limits are not derived from the queue's default limits?  Because the DM
>> device limits are just stacked and copied to the queue, some background
>> for those following along:
>>
>> DM's actual stacking of limits takes place when the DM table is
>> translated to the DM device's final queue (at table resume time), see:
>> http://git.kernel.org/linus/754c5fc7e
>>
>> drivers/md/dm.c:dm_swap_table() calls dm_calculate_queue_limits() to
>> stack the limits.
>>
>> drivers/md/dm.c:__bind() sets the DM device's queue_limits via
>> dm_table_set_restrictions()
>>
>> drivers/md/dm-table.c:dm_table_set_restrictions() simply copies the
>> queue_limits established by DM's stacking with:
>>         /*                                                              
>>                                                    * Copy table's 
>> limits to the DM device's request_queue                                 
>>                                                                         
>>          */
>>         q->limits = *limits;
>>
>> Now coming full circle:
>> AFAIK the only piece I'm missing is how/where your proposed changes will
>> account for the need to establish SAFE_MAX_SECTORS _after_ the stacking
>> of queue_limits: IFF max_sectors and max_hw_sectors are still 0 (like
>> Jun'ichi did in DM with the 2nd patch posted).
>>
>> But I don't pretend to have this all sorted out in my head.  I could
>> easily be missing some other piece(s) implicit in your proposal.
>>
>> Maybe an RFC patch that illustrates your thinking would help further this
>> discussion?
>
> I just sent out revised patchset:
>
> [PATCH 1/2] dm: Set safe default max_sectors for targets with no  
> underlying device
> https://www.redhat.com/archives/dm-devel/2009-September/msg00203.html
>
> [PATCH 2/2] block: blk_set_default_limits sets 0 to max_sectors
> https://www.redhat.com/archives/dm-devel/2009-September/msg00205.html
>
>
> But I wonder better fix might be to provide blk_queue_copy_limits()
> to replace this in dm-table.c:
>
> >         q->limits = *limits;
>
> where blk_queue_copy_limits() looks like this:
>
> void blk_queue_copy_limits(struct request_queue *q, struct queue_limits  
> *lim)
> {
> 	q->limits = *limits;
>
> 	/* fix-up bad values */
> 	if (q->limits.max_sectors == 0 || q->limits.max_hw_sectors == 0)
> 		blk_queue_max_sectors(q, SAFE_MAX_SECTORS);
> }
>
> so that block/blk-settings.c has full-control on default value
> and dm don't need to care about the magic 'SAFE_MAX_SECTORS'.

Even better, I like that much better than your DM specific changes I
just commented on.

But rather than "fix-up bad values" I'd suggest a more helpful comment
block (like the one from your patch that I just commented on).

You likely planned on cleaning the above up with a more robust comment
and I'm jumping the gun on being critical :)

Thanks,
Mike
