From: Milan Broz <gmazyland@gmail.com>
Subject: Re: dm-crypt: remove per-cpu structure
Date: Sat, 22 Feb 2014 11:28:35 +0100
Message-ID: <53087BD3.1000900@gmail.com>
References: <alpine.LRH.2.02.1402201758190.28312@file01.intranet.prod.int.rdu2.redhat.com>	<20140220235935.GA32743@redhat.com>	<alpine.LRH.2.02.1402201907120.29698@file01.intranet.prod.int.rdu2.redhat.com>	<20140221023240.GA338@redhat.com>
	<alpine.LRH.2.02.1402210238470.5846@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1402210238470.5846@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, device-mapper development <dm-devel@redhat.com>, Lisa Du <chunlingdu1@gmail.com>, "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On 02/21/2014 08:41 AM, Mikulas Patocka wrote:
>>>> Hi Mikulas,
>>>>
>>>> Obviously avoiding crashes is more important than performance.

Yes, but please keep these changes in linux-next for a while
before submitting this for stable or you will fix one rare bug and
slow down all existing users (with possible another fix to fix later)...

I know that taking cpu offline becomes more used these days
but still the performance is critical attribute for dmcrypt.

(And IIRC this cpu work relocation problem is there for years.)

>>>> But are we losing performance by switching away from using percpu?  Do
>>>> we care?  I'd like to see the header to speak to the potential for
>>>> slowdown (if there is any).
>>>
>>> There is one more allocation per request than before. I don't know how 
>>> much does it cost.

Could you please try it on some test machine in lab? I think Red Hat has
enough usable machines for such tests.

>> OK, any reason you didn't fix this up by using cpu hotplug hooks like
>> Tejun suggested?  Too complicated?
> 
> Yes, it would complicate the code. The patch that removes percpu pointers 
> shortens the file, using cpu hotplug hooks would make it bigger.

Since we prefer source file size to correct solution?

That said, dmcrypt becomes already too big. I already thought about separating
some things (keeping the core functionality in one place), e.g. IV generators
implementation is something what could be logically separated.
(Is it worth to do it?)

>>> We could also modify the code to use per_bio_data to save one allocation.
>>
>> OK, sounds like a good win.  Can you write a separate followup patch
>> that makes use of per_bio_data?
> 
> I will try it.

If you have some performance numbers, post it as well please.
(I would not be surprised that removing percpu struct is sometimes even better
for performance but this is just wild guess.)

And if you have better solution to dmcrypt parallel performance, post it too
but with real hw (with and without crypto acceleration) speed up numbers please. ;-)

Thanks,
Milan
