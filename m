From: Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
Date: Tue, 12 Apr 2011 08:18:37 +0200
Message-ID: <4DA3EEBD.4060005@fusionio.com>
References: <1295659049-2688-6-git-send-email-jaxboe@fusionio.com>	<AANLkTin8FoXX6oqUyW+scwhadyX-TfW16_oKjvngU9-m@mail.gmail.com>	<20110303221353.GA10366@redhat.com>	<4D761E0D.8050200@fusionio.com>	<20110308202100.GA31744@redhat.com>	<4D76912C.9040705@fusionio.com>	<20110308220526.GA393@redhat.com>	<20110310005810.GA17911@redhat.com>	<20110405130541.6c2b5f86@notabene.brown>	<20110411145022.710c30e9@notabene.brown>	<20110411165923.GA15442@infradead.org> <20110412071428.4aa92c6e@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110412071428.4aa92c6e@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "hch@infradead.org" <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: dm-devel.ids

On 2011-04-11 23:14, NeilBrown wrote:
> On Mon, 11 Apr 2011 12:59:23 -0400 "hch@infradead.org" <hch@infradead.org>
> wrote:
> 
>> On Mon, Apr 11, 2011 at 02:50:22PM +1000, NeilBrown wrote:
>>> diff --git a/block/blk-core.c b/block/blk-core.c
>>> index 273d60b..903ce8d 100644
>>> --- a/block/blk-core.c
>>> +++ b/block/blk-core.c
>>> @@ -2674,19 +2674,23 @@ static void flush_plug_list(struct blk_plug *plug)
>>>  	struct request_queue *q;
>>>  	unsigned long flags;
>>>  	struct request *rq;
>>> +	struct list_head head;
>>>  
>>>  	BUG_ON(plug->magic != PLUG_MAGIC);
>>>  
>>>  	if (list_empty(&plug->list))
>>>  		return;
>>> +	list_add(&head, &plug->list);
>>> +	list_del_init(&plug->list);
>>>  
>>>  	if (plug->should_sort)
>>> -		list_sort(NULL, &plug->list, plug_rq_cmp);
>>> +		list_sort(NULL, &head, plug_rq_cmp);
>>> +	plug->should_sort = 0;
>>
>> As Jens mentioned this should be list_splice_init.  But looking over
>> flush_plug_list the code there seems strange to me.
>>
>> What does the local_irq_save in flush_plug_list protect?  Why don't
>> we need it over the list_sort?  And do we still need it when first
>> splicing the list to a local one?
>>
>> It's one of these cases where I'd really like to see more comments
>> explaining why the code is doing what it's doing.
> 
> My understanding of that was that the calling requirement of
> __elv_add_request is that the queue spinlock is held and that interrupts are
> disabled.
> So rather than possible enabling and disabling interrupts several times as
> different queue are handled, the code just disabled interrupts once, and
> then just take the spinlock once for each different queue.
> 
> The whole point of the change to plugging was to take locks less often.
> Disabling interrupts less often is presumably an analogous goal.
> 
> Though I agree that a comment would help.
> 
> 	q = NULL;
> +	/* Disable interrupts just once rather than using spin_lock_irq/sin_unlock_irq
> 	 * variants
> 	 */
> 	local_irq_save(flags);
> 
> 
> assuming my analysis is correct.

Yep that is correct, it's to avoid juggling irq on and off for multiple
queues. I will put a comment there.


-- 
Jens Axboe
