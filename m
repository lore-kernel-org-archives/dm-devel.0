From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] block: flush queued bios when the process blocks
Date: Tue, 27 May 2014 09:42:37 -0600
Message-ID: <5384B26D.1000703@kernel.dk>
References: <alpine.LRH.2.02.1405271059190.27492@file01.intranet.prod.int.rdu2.redhat.com> <5384AA79.4010206@kernel.dk> <alpine.LRH.2.02.1405271120390.31404@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1405271120390.31404@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Kent Overstreet <kmo@daterainc.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>
List-Id: dm-devel.ids

On 2014-05-27 09:23, Mikulas Patocka wrote:
>
>
> On Tue, 27 May 2014, Jens Axboe wrote:
>
>> On 2014-05-27 09:03, Mikulas Patocka wrote:
>>> The block layer uses per-process bio list to avoid recursion in
>>> generic_make_request. When generic_make_request is called recursively, the
>>> bio is added to current->bio_list and the function returns immediatelly.
>>> The top-level instance of generic_make_requests takes bios from
>>> current->bio_list and processes them.
>>
>> This really begs the question of why we just don't use the per-process plugs
>> for this. We already have scheduler hooks in place to flush those at the
>> appropriate time. Why are we reinventing something for essentially the same
>> thing?
>>
>> --
>> Jens Axboe
>
> Plugs work with requests, this patch works with bios. They are different
> structures, so you can't use one infrastructure to process them.

Yes... I realize the list and plugs are for requests. But there's 
nothing preventing a non-rq hook, we have uses like that too. And it 
could easily be extended to handle bio lists, too.

> The patch adds bio list flushing to the scheduler just besides plug
> flushsing.

... which is exactly why I'm commenting. It'd be great to avoid yet one 
more scheduler hook for this sort of thing.

-- 
Jens Axboe
