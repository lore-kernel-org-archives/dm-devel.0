From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: dm thin pool discarding
Date: Thu, 10 Jan 2019 12:52:07 +0100
Message-ID: <db63baea-269e-e331-a34b-acdffd62839e@redhat.com>
References: <CA+X5Wn4fqXZa_Ecc75CfmA2LBq7y8qFzzdDcdFugZwaPgq-Aeg@mail.gmail.com>
	<ba0c0646-29f3-f876-6454-8c80b613a46a@redhat.com>
	<46a8e85e0258cd8ccc328052a428fff0cbdd5ad3.camel@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <46a8e85e0258cd8ccc328052a428fff0cbdd5ad3.camel@suse.de>
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
To: Martin Wilck <mwilck@suse.de>, james harvey <jamespharvey20@gmail.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Dne 10. 01. 19 v 12:40 Martin Wilck napsal(a):
> On Thu, 2019-01-10 at 10:18 +0100, Zdenek Kabelac wrote:
>> Dne 10. 01. 19 v 1:39 james harvey napsal(a):
>>>
>>> Q3 - Does a LVM thin volume zero out the bytes that are
>>> discarded?  At
>>> least for me, queue/discard_zeroes_data is 0.  I see there was
>>> discussion on the list of adding this back in 2012, but I'm not
>>> sure
>>> it was ever added for there to be a way to enable it.
>>
>> Unprovisioned chunks always appear as zeroed for reading.
>> Once you provision chunk (by write) for thin volume out of thin-pool
>> - it
>> depends on thin-pool target setting 'skip_zeroing'.
>>
>> So if zeroing is enabled (no skipping) - and you use larger chunks -
>> the
>> initial chunk provisioning becomes quite expensive - that's why lvm2
>> is by
>> default recommending to not use zeroing for chunk sizes > 512K.
> 
> Which begs the question why lvm zeroes at provisioning time, and not at
> discard time, where speed matters less (and the operation could be
> carried out lazily, taking care only that the discarded blocks aren't
> re-provisioned before they are zeroed).

There are few simple answers to this.

If 'zeroing' happens at the moment of provisioning - then if you use 'small 
chunks' like 64K or 128K - in many cases there is actually no-zeroing at all - 
as the chunk is fully written during provisioning time.

So in most cases there is no associated 'extra-cost'.

Of course if chunks are big  - this no longer applies and extra time is wasted 
while zeroes goes to 'unwritten' sectors.


  > So far my understanding was that even without zeroing, an LVM thin
> volume could be considered as a drive with "discard zeroes data"
> property. If there's a flaw in the argument below, please point it out
> to me.
>

As said - if you discard 'less then aligned' chunk - nothing happens,
so it cannot be takes as like it would be always zeroing...


> Now consider a VM that uses a dm-thin volume as storage. If this VM
> issues a discard operation on some chunk of data, future reads on the
> discarded chunks through the same LV will return 0 because these chunks
> have just become unprovisioned. That looks pretty much like "disard

Thin-pool current data structures makes some operation 'cheap' and some other 
quite expensive.

i.e. you could implement some sort of 'offline' zeroing where the chunks that 
are left unused in thin-pool are 'pre-zeroed' when thin-pool has a spare 
bandwidth - but the real benefit is 'questionable' as it has been already 
mentioned - with smaller chunksizes - there are typically not so big extra 
costs....  - it might have some effect with big chunks thought - but those are 
on the other hand very inefficient with snapshots - so it usually does not 
apply for VM users....


> The point I'm uncertain about is what happens if such a chunk is
> (re)provisioned by a partial write (say chunk size is 1M and only 512k
> is written). What data would dm-thin return from a read of the non-
> overwritten part of that chunk?

Clearly unwritten portions chunk are filled with zeroes.


Zdene
