From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: Improve processing efficiency for addition and
 deletion of multipath devices
Date: Tue, 29 Nov 2016 09:24:26 +0100
Message-ID: <6039aa0c-97ba-33b3-1c29-5fbb6e1676e1@redhat.com>
References: <OF7C96E124.CD19B12D-ON4825806D.00095E60-4825806D.0009BD8C@zte.com.cn>
	<9797787c-30c5-08fb-f92a-5e68ec0b6333@suse.de>
	<OF1D9DC33E.849B3309-ON4825806D.002C52A8-4825806D.003020B2@zte.com.cn>
	<1479289781.14706.16.camel@suse.com>
	<OF233D7062.48FA865C-ON4825806E.000544C5-4825806E.00093C07@zte.com.cn>
	<1479379712.14706.23.camel@suse.com>
	<20161118222618.GZ1972@octiron.msp.redhat.com>
	<1479979270.13566.7.camel@suse.com>
	<20161128184624.GF1972@octiron.msp.redhat.com>
	<fba771cb-222d-88a9-5e9f-35e57206aecd@suse.de>
	<1480406528.7926.7.camel@suse.com>
	<17134173-b9c9-456f-43f6-55f1fbd180ea@redhat.com>
	<1480407413.7926.9.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1480407413.7926.9.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>, Hannes Reinecke <hare@suse.de>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, tang.junhui@zte.com.cn
List-Id: dm-devel.ids

Dne 29.11.2016 v 09:16 Martin Wilck napsal(a):
> On Tue, 2016-11-29 at 09:10 +0100, Zdenek Kabelac wrote:
>> Dne 29.11.2016 v 09:02 Martin Wilck napsal(a):
>>> On Tue, 2016-11-29 at 07:47 +0100, Hannes Reinecke wrote:
>>>> On 11/28/2016 07:46 PM, Benjamin Marzinski wrote:
>>>>> On Thu, Nov 24, 2016 at 10:21:10AM +0100, Martin Wilck wrote:
>>>>>> On Fri, 2016-11-18 at 16:26 -0600, Benjamin Marzinski wrote:
>>>>>>
>>>>>>> At any rate, I'd rather get rid of the gazillion waiter
>>>>>>> threads
>>>>>>> first.
>>>>>>
>>>>>> Hm, I thought the threads are good because this avoids one
>>>>>> unresponsive
>>>>>> device to stall everything?
>>>>>
>>>>> There is work making dm events pollable, so that you can wait
>>>>> for
>>>>> any
>>>>> number of them with one thread. At the moment, once we get an
>>>>> event, we
>>>>> lock the vecs lock, which pretty much keeps everything else
>>>>> from
>>>>> running, so this doesn't really change that.
>>>>>
>>>>
>>>> Which again leads me to the question:
>>>> Why are we waiting for dm events?
>>>> The code handling them is pretty arcane, and from what I've seen
>>>> there
>>>> is nothing in there which we wouldn't be informed via other
>>>> mechanisms
>>>> (path checker, uevents).
>>>> So why do we still bother with them?
>>>
>>> I was asking myself the same question. From my inspection of the
>>> kernel
>>> code, there are two code paths that trigger a dm event but no
>>> uevent
>>> (bypass_pg() and switch_pg_num(), both related to path group
>>> switching). If these are covered by the path checker, I see no
>>> point in
>>> waiting for DM events. But of course, I may be missing something.
>>>
>>
>> Processing of 'dm' events likely should be postponed to 'dmeventd' -
>> which is a daemon resolving the problem here with waiting for an
>> event.
>>
>> Plugin just takes the action.
>>
>> IMHO there is nothing easier you can have.
>
>> It's then upto dmeventd to maintain the best 'connection' with kernel
>> and events.
>
> But that would simply move the "gazillion waiter threads" from
> multipathd to dmeventd, right? And it would introduce another boot
> sequence dependency for multipathd, I'm not sure if that's desirable.
>


Well - frankly how many multipath devices have you seen on a single machine?

Have you noticed every single  "XFS" mounted device spreads around 9 threads 
these days?

But I'm not going to defend current 'thread' explosion with device monitoring 
and this thing is BEING resolved.

The main point here is - multipathd  does NOT need to solve this issue at all 
and let dmeventd to resolve it - and once kernel will have better mechanism 
with reliable event passing  (which is NOT udev btw)  - it will use it.

The solution is not that everyone will write everything here...


Regards

Zdenek
