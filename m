From: Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
Date: Mon, 11 Apr 2011 14:12:29 +0200
Message-ID: <4DA2F02D.2000903@fusionio.com>
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>	<1295659049-2688-6-git-send-email-jaxboe@fusionio.com>	<AANLkTin8FoXX6oqUyW+scwhadyX-TfW16_oKjvngU9-m@mail.gmail.com>	<20110303221353.GA10366@redhat.com>	<4D761E0D.8050200@fusionio.com>	<20110308202100.GA31744@redhat.com>	<4D76912C.9040705@fusionio.com>	<20110308220526.GA393@redhat.com>	<20110310005810.GA17911@redhat.com>	<20110405130541.6c2b5f86@notabene.brown>	<20110411145022.710c30e9@notabene.brown>	<4DA2C7BE.6060804@fusionio.com>	<20110411205928.13915719@notabene.brown> <20110411215521.78c87573@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110411215521.78c87573@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Mike Snitzer <snitzer@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: dm-devel.ids

On 2011-04-11 13:55, NeilBrown wrote:
> On Mon, 11 Apr 2011 20:59:28 +1000 NeilBrown <neilb@suse.de> wrote:
> 
>> On Mon, 11 Apr 2011 11:19:58 +0200 Jens Axboe <jaxboe@fusionio.com> wrote:
>>
>>> On 2011-04-11 06:50, NeilBrown wrote:
>>
>>>> The only explanation I can come up with is that very occasionally schedule on
>>>> 2 separate cpus calls blk_flush_plug for the same task.  I don't understand
>>>> the scheduler nearly well enough to know if or how that can happen.
>>>> However with this patch in place I can write to a RAID1 constantly for half
>>>> an hour, and without it, the write rarely lasts for 3 minutes.
>>>
>>> Or perhaps if the request_fn blocks, that would be problematic. So the
>>> patch is likely a good idea even for that case.
>>>
>>> I'll merge it, changing it to list_splice_init() as I think that would
>>> be more clear.
>>
>> OK - though I'm not 100% the patch fixes the problem - just that it hides the
>> symptom for me.
>> I might try instrumenting the code a bit more and see if I can find exactly
>> where it is re-entering flush_plug_list - as that seems to be what is
>> happening.
> 
> OK, I found how it re-enters.
> 
> The request_fn doesn't exactly block, but when scsi_request_fn calls
> spin_unlock_irq, this calls preempt_enable which can call schedule, which is
> a recursive call.
> 
> The patch I provided will stop that from recursing again as the blk_plug.list
> will be empty.
> 
> So it is almost what you suggested, however the request_fn doesn't block, it
> just enabled preempt.
> 
> 
> So the comment I would put at the top of that patch would be something like:

Ah, so it was pretty close. That does explain it. I've already queued up
the patch, I'll ammend the commit message.

-- 
Jens Axboe
