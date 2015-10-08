From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: Queuing of dm-raid1 resyncs to the same underlying
 block devices
Date: Thu, 8 Oct 2015 13:50:02 +0200
Message-ID: <5616586A.4000200@redhat.com>
References: <20150926154902.GA2964@alpha.arachsys.com>
	<64020C6E-98B1-4139-A88C-0EC65493CCF9@redhat.com>
	<560BEB14.3060701@redhat.com> <87si5vk0rz.fsf@notabene.neil.brown.name>
	<560D0668.50300@redhat.com> <87fv1m8ied.fsf@notabene.neil.brown.name>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <87fv1m8ied.fsf@notabene.neil.brown.name>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Neil Brown <neilb@suse.de>, Brassow Jonathan <jbrassow@redhat.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids



On 10/07/2015 11:42 PM, Neil Brown wrote:
> Heinz Mauelshagen <heinzm@redhat.com> writes:
>
>> On 10/01/2015 12:20 AM, Neil Brown wrote:
>>> Heinz Mauelshagen <heinzm@redhat.com> writes:
>>>> BTW:
>>>> When you create a raid1/4/5/6/10 LVs _and_ never read what you have not
>>>> written,
>>>> "--nosync" can be used anyway in order to avoid the initial
>>>> resynchronization load
>>>> on the devices. Any data written in that case will update all
>>>> mirrors/raid redundancy data.
>>>>
>>> While this is true for RAID1 and RAID10, and (I think) for the current
>>> implementation of RAID6, it is definitely not true for RAID4/5.
>> Thanks for the clarification.
>>
>> I find that to be really bad situation.
>>
>>
>>> For RAID4/5 a single-block write will be handled by reading
>>> old-data/parity, subtracting the old data from the parity and adding the
>>> new data, then writing out new data/parity.
>> Obviously for optimization reasons.
>>
>>> So if the parity was wrong before, it will be wrong afterwards.
>> So even overwriting complete stripes in raid4/5/(6)
>> would not ensure correct parity, thus always requiring
>> initial sync.
> No, over-writing complete stripes will result in correct parity.
> Even writing more than half of the data in a stripe will result in
> correct parity.


Useless, as you say, because we can never be sure, that
any filesystem/dbms/... upstack will guarantee >= half stripe
writes initially; even more so with many devices and large chunk sizes...

>
> So if you have a filesystem which only ever writes full stripes, then
> there is no need to sync at the start.  But I don't know any filesysetms
> which promise that.
>
> If you don't sync at creation time, then you may be perfectly safe when
> a device fails, but I can't promise that.  And without guarantees, RAID
> is fairly pointless.

Indeed.

>
>> We should think about a solution to avoid it in lieu
>> of growing disk/array sizes.
> With spinning-rust devices you need to read the entire array ("scrub")
> every few weeks just to make sure the media isn't degrading.  When you
> do that it is useful to check that the parity is still correct - as a
> potential warning sign of problems.
> If you don't sync first, then checking the parity doesn't tell you
> anything.

Yes, aware of this.

My point was avoiding superfluous mass io whenever possible.

E.g. keep track of the 'new' state of the array and initialize
parity/syndrome on first access to any given stripe with
the given performance optimization thereafter.

Metadata kept to housekeep this  could be organized in a b-tree
(e.g. via dm-persistent-data), thus storing just one node
defining the whole array as 'new' and splitting the tree up
as we go and have a size threshold to not allow to grow
such metadata too big.

Heinz

> And as you have to process the entire array occasionally anyway, you
> make as well do it at creation time.
>
> NeilBrown
>
>
>>
>> Heinz
>>
>>
>>> If the device that new data was written to then fails, the data on it is
>>> lost.
>>>
>>> So do this for RAID1/10 if you like, but not for other levels.
>>>
>>> NeilBrown
