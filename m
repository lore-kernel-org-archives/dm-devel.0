From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: [dm-devel] [PATCH] md: fix raid5 livelock
Date: Thu, 29 Jan 2015 12:24:00 +0100
Message-ID: <54CA1850.1000909@redhat.com>
References: <54C54CBC.50101@redhat.com>	<20150128133754.25835582@notabene.brown> <54C8CFF8.6000807@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54C8CFF8.6000807@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilBrown <neilb@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>, linux-raid@vger.kernel.org, Brassow Jonathan <jbrassow@redhat.com>, Alasdair G Kergon <agk@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Marian Csontos <mcsontos@redhat.com>
List-Id: dm-devel.ids


Neil,

the patch worked fine in overnight test runs without the previous livelock.
No regressions have been triggered.

Yes, tidying up that optimization logic (e.g. in fetch_block()) is very 
much appreciated :-)

Thanks,
Heinz

On 01/28/2015 01:03 PM, Heinz Mauelshagen wrote:
>
> Neil,
>
> thanks for providing the patch.
>
> Test with it will take some hours in order to tell any success.
>
> Regards,
> Heinz
>
> On 01/28/2015 03:37 AM, NeilBrown wrote:
>> On Sun, 25 Jan 2015 21:06:20 +0100 Heinz Mauelshagen <heinzm@redhat.com>
>> wrote:
>>
>>> From: Heinz Mauelshagen <heinzm@redhat.com>
>>>
>>> Hi Neil,
>>>
>>> the reconstruct write optimization in raid5, function fetch_block 
>>> causes
>>> livelocks in LVM raid4/5 tests.
>>>
>>> Test scenarios:
>>> the tests wait for full initial array resynchronization before making a
>>> filesystem
>>> on the raid4/5 logical volume, mounting it, writing to the filesystem
>>> and failing
>>> one physical volume holding a raiddev.
>>>
>>> In short, we're seeing livelocks on fully synchronized raid4/5 arrays
>>> with a failed device.
>>>
>>> This patch fixes the issue but likely in a suboptimnal way.
>>>
>>> Do you think there is a better solution to avoid livelocks on
>>> reconstruct writes?
>>>
>>> Regards,
>>> Heinz
>>>
>>> Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
>>> Tested-by: Jon Brassow <jbrassow@redhat.com>
>>> Tested-by: Heinz Mauelshagen <heinzm@redhat.com>
>>>
>>> ---
>>>    drivers/md/raid5.c | 2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>>> index c1b0d52..0fc8737 100644
>>> --- a/drivers/md/raid5.c
>>> +++ b/drivers/md/raid5.c
>>> @@ -2915,7 +2915,7 @@ static int fetch_block(struct stripe_head *sh,
>>> struct stripe_head_state *s,
>>>                (s->failed >= 1 && fdev[0]->toread) ||
>>>                (s->failed >= 2 && fdev[1]->toread) ||
>>>                (sh->raid_conf->level <= 5 && s->failed && 
>>> fdev[0]->towrite &&
>>> -             (!test_bit(R5_Insync, &dev->flags) ||
>>> test_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) &&
>>> +             (!test_bit(R5_Insync, &dev->flags) ||
>>> test_bit(STRIPE_PREREAD_ACTIVE, &sh->state) || s->non_overwrite) &&
>>>                 !test_bit(R5_OVERWRITE, &fdev[0]->flags)) ||
>>>                ((sh->raid_conf->level == 6 ||
>>>                  sh->sector >= sh->raid_conf->mddev->recovery_cp)
>>
>> That is a bit heavy handed, but knowing that fixes the problem helps 
>> a lot.
>>
>> I think the problem happens when processes a non-overwrite write to a 
>> failed
>> device.
>>
>> fetch_block() should, in that case, pre-read all of the working 
>> device, but
>> since
>>
>>           (!test_bit(R5_Insync, &dev->flags) || 
>> test_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) &&
>>
>> was added, it sometimes doesn't.  The root problem is that
>> handle_stripe_dirtying is getting confused because neither rmw or rcw 
>> seem to
>> work, so it doesn't start the chain of events to set 
>> STRIPE_PREREAD_ACTIVE.
>>
>> The following (which is against mainline) might fix it.  Can you test?
>>
>> Thanks,
>> NeilBrown
>>
>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> index c1b0d52bfcb0..793cf2861e97 100644
>> --- a/drivers/md/raid5.c
>> +++ b/drivers/md/raid5.c
>> @@ -3195,6 +3195,10 @@ static void handle_stripe_dirtying(struct 
>> r5conf *conf,
>>                         (unsigned long long)sh->sector,
>>                         rcw, qread, test_bit(STRIPE_DELAYED, 
>> &sh->state));
>>       }
>> +    if (rcw > disks && rmw > disks &&
>> +        !test_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
>> +        set_bit(STRIPE_DELAYED, &sh->state);
>> +
>>       /* now if nothing is locked, and if we have enough data,
>>        * we can start a write request
>>        */
>>
>>
>> This code really really needs to be tidied up and commented better!!!
>>
>> Thanks,
>> NeilBrown
>
> -- 
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
