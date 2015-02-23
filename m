From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: [dm-devel] [PATCH 0/3] md raid: enhancements to support the device
 mapper dm-raid target
Date: Mon, 23 Feb 2015 12:49:00 +0100
Message-ID: <54EB13AC.4010006@redhat.com>
References: <1423853282-6218-1-git-send-email-heinzm@redhat.com>	<20150218130328.3ce5ab53@notabene.brown>	<54E47C88.1080203@redhat.com> <20150223120718.03806a87@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150223120718.03806a87@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>, "jbras >> Brassow Jonathan" <jbrassow@redhat.com>, linux RAID <linux-raid@vger.kernel.org>
List-Id: dm-devel.ids


On 02/23/2015 02:07 AM, NeilBrown wrote:
> On Wed, 18 Feb 2015 12:50:32 +0100 Heinz Mauelshagen <heinzm@redhat.com>
> wrote:
>
>> On 02/18/2015 03:03 AM, NeilBrown wrote:
>>> On Fri, 13 Feb 2015 19:47:59 +0100 heinzm@redhat.com wrote:
>>>
>>>> From: Heinz Mauelshagen <heinzm@redhat.com>
>>>>
>>>> I'm enhancing the device mapper raid target (dm-raid) to take
>>>> advantage of so far unused md raid kernel funtionality:
>>>> takeover, reshape, resize, addition and removal of devices to/from raid sets.
>>>>
>>>> This series of patches remove constraints doing so.
>>>>
>>>>
>>>> Patch #1:
>>>> add 2 API functions to allow dm-raid to access the raid takeover
>>>> and resize functionality (namely md_takeover() and md_resize());
>>>> reshape APIs are not needed in lieu of the existing personalilty ones
>>>>
>>>> Patch #2:
>>>> because device mapper core manages a request queue per mapped device
>>>> utilizing the md make_request API to pass on bios via the dm-raid target,
>>>> no md instance underneath it needs to manage a request queue of its own.
>>>> Thus dm-raid can't use the md raid0 personality as is, because the latter
>>>> accesses the request queue unconditionally in 3 places via mddev->queue
>>>> which this patch addresses.
>>>>
>>>> Patch #3:
>>>> when dm-raid processes a down takeover to raid0, it needs to destroy
>>>> any existing bitmap, because raid0 does not require one. The patch
>>>> exports the bitmap_destroy() API to allow dm-raid to remove bitmaps.
>>>>
>>>>
>>>> Heinz Mauelshagen (3):
>>>>     md core:   add 2 API functions for takeover and resize to support dm-raid
>>>>     md raid0:  access mddev->queue (request queue member) conditionally
>>>>                because it is not set when accessed from dm-raid
>>>>     md bitmap: export bitmap_destroy() to support dm-raid down takover to raid0
>>>>
>>>>    drivers/md/bitmap.c |  1 +
>>>>    drivers/md/md.c     | 39 ++++++++++++++++++++++++++++++---------
>>>>    drivers/md/md.h     |  3 +++
>>>>    drivers/md/raid0.c  | 48 +++++++++++++++++++++++++++---------------------
>>>>    4 files changed, 61 insertions(+), 30 deletions(-)
>>>>
>>> Hi Heinz,
>>>    I don't object to these patches if you will find the exported functionality
>>>    useful, but I am a little surprised by them.
>> Hi Neil,
>>
>> I find them useful to allow for atomic takeover using the already given
>> md raid
>> code rather than duplicating ACID takeover in dm-raid/lvm. If I'd not
>> use md for this,
>> I'd have to keep copies of the given md superblocks and restore them in case
>> the assembly of the array failed and superblocks have been updated.
> This argument doesn't make much sense to me.
>
> There is no reason that the assembling the array in a new configuration would
> fail, except possible malloc error or similar which would make putting it
> back into the original configuration fail as well.
>
> There is no need to synchronise updating the metadata with a take-over.
> In every case, the "Before" and "After" configurations are functionally
> identical.
> A 2-drive RAID1 behaves identically to a 2-drive RAID5, for example.
> So it doesn't really matter whether or not the metadata match how the kernel
> is configured.  Once you start a reshape (e.g. 2-drive RAID5 to 3-drive
> RAID5) or add a spare, then you need the metadata to be correct, but that is
> just a sequencing issue:
>
> - start: metadata says "raid1".
> - suspend array, reconfigure as RAID5 with 2 drives, resume.
> - if everything went well, update metadata to "raid5".
> - now update metadata to "0 block of progress into reshape from 2-drives to
>    3-drives".
> - now start the reshape, which will further update the metadata as it
>    proceeds.
>
> There really are no atomicity requirements, only sequencing.

Thanks for clarifying these conversions, I was presuming there were
atomicity issues in the md kernel code to conform to.

Canges to run those sequences look straightforward in the dm-raid target.
I'll implement them and test.

>
>
>>>    I would expect that dm-raid wouldn't ask md to 'takeover' from one level to
>>>    another, but instead would
>>>      - suspend the dm device
>>>      - dismantle the array using the old level
>>>      - assemble the array using the new level
>>>      - resume the dm device
>> That scenario is on my TODO, because it is for instance paritcularly
>> useful to
>> convert a "striped" array (or a "raid0" array without metadata for that
>> purpose)
>> directly into a raid6_n_6 one (i.e. dedicated xor and syndrome devices)
>> thus avoding any interim levels.
>> In these cases, I'd only need to drop the metadata devs allocations if
>> the array does not start up properly and restart the previous mapping.
>>
> Given that you plan to do this, I really think the dm and LVM code would be
> simpler if all reconfigurations use this same approach.

You got a point with regards to the dm-raid target:
if an MD takeover API is actually superfluous in the end, the target
won't have 2 code paths for

a) going from a non-metadata config to a metadata one (e.g. striped -> 
raid5)

and

b) a metadata -> metadata one (e.g. raid6 -> raid5)


In lvm2/dm userspace there will be no difference, because it has to
update the userspace metadata and the kernel metadata comiting it
in the proper sequence and does not call any takeover api in userspace
at all which could be avoided as in the kernel.

>
>>>    The reason md needs 'takeover' is because it doesn't have the same
>>>    device/target separation that dm does.
>> Correct.
>> Nonetheless, I found accessing md's takeover functionality still useful
>> for the atomic updates to be simpler in dm/lvm.
>>
>>>    I was particularly surprised that you wanted to use md/raid0.c  It is no
>>>    better than dm/dm-stripe.c and managing two different stripe engines under
>>>    LVM doesn't see like a good idea.
>> I actually see differences in performance which I have not explained yet.
>>
>> In some cases, dm-stripe performs better, in others md raid0 does for
>> the same mappings
>> and load; exact same mappings are possible, because I've got patches to
>> lvconvert back
>> and forth between "striped" and "raid0", hence accesing exactly the same
>> physical extents.
> That is surprising.  I would be great if we could characterise  what sort of
> workloads work better with one or the other...

Agreed, we need more facts.

I've seen indications from "dd oflag=direct iflag=fullblock bs=1G 
count=1 if=/dev/zero of=$LV
converting back and forth to/from raid0/striped mappings on an otherwise 
idle system.

>> So supporting "raid0" in dm-raid is senseful for 3 reasons:
>> - replace dm-stripe with md raid0
>> - atomic md takeover from "raid0" -> "raid5"
>> - potential performance implications
>>
>>>    Is there some reason that I have missed which makes it easier to use
>>>    'takeover' rather than suspend/resume?
>> Use md takover for atomic updates as mentioned above.
>>
>> You don't have issues with md_resize() which I use to shrink existing
>> arrays?
>>
> I have exactly the same issue with md_resize() as with md_takeover(), and for
> the same reasons.

Ok, let me do avoiding patches based on your clarifications
which'll take till next week including testing.

> How about we wait until you do implement the
>   suspend/dismantle/reassemble/resume
> approach, and see if you still want md_resize/md_takeover after that?

Sure.
I'd like to see the raid0 conditonal request queue patch though.

Thanks,
Heinz

>
> Thanks,
> NeilBrown
>

