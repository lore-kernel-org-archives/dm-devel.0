From: Nikos Tsironis <ntsironis@arrikto.com>
Subject: Re: dm kcopyd: Increase sub-job size to 512KiB
Date: Tue, 16 Jul 2019 17:33:03 +0300
Message-ID: <8201d449-d765-8151-6dc2-2176290596b0@arrikto.com>
References: <20190603134017.9323-1-ntsironis@arrikto.com>
	<b6cdb071-f8d3-7c09-c938-71689ceb1c95@arrikto.com>
	<20190715182221.GB15315@redhat.com>
	<54f185d8-5cf7-b617-1dfe-418da7643004@arrikto.com>
	<20190716141150.GA17023@redhat.com> <20190716141415.GB17023@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190716141415.GB17023@redhat.com>
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
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

On 7/16/19 5:14 PM, Mike Snitzer wrote:
> On Tue, Jul 16 2019 at 10:11am -0400,
> Mike Snitzer <snitzer@redhat.com> wrote:
> 
>> On Tue, Jul 16 2019 at  9:59am -0400,
>> Nikos Tsironis <ntsironis@arrikto.com> wrote:
>>
>>> On 7/15/19 9:22 PM, Mike Snitzer wrote:
>>>> On Fri, Jul 12 2019 at  9:45am -0400,
>>>> Nikos Tsironis <ntsironis@arrikto.com> wrote:
>>>>
>>>>> Hi Mike,
>>>>>
>>>>> A kind reminder about this patch. Do you require any changes or will you
>>>>> merge it as is?
>>>>
>>>> I think we need changes to expose knob(s) to tune this value on a global
>>>> _and_ device level via sysfs.  E.g.:
>>>>
>>>> 1) dm_mod module param for global
>>>> 2) but also allow a per-device override, like:
>>>>    echo 512 > /sys/block/dm-X/dm/kcopyd_subjob_size
>>>>
>>>
>>> Hi Mike,
>>>
>>> Thanks for your feedback. I agree, this sounds like the best thing to do.
>>>
>>>> 1 is super easy and is a start.  Layering in 2 is a bit more involved.
>>>
>>> Maybe I could help with (2). We could discuss about it and how you think
>>> it's best to do it and then I could proceed with an implementation.
>>>
>>> Please let me know what you think.
>>>
>>>>
>>>> In hindsight (given how risk-averse I am on changing the default) I
>>>> should've kept the default 128 but allowed override with modparam
>>>> dm_mod.kcopyd_subjob_size=1024
>>>>
>>>> Would this be an OK first step?
>>>
>>> Yes, this would be great.
>>>
>>>>
>>>> If so, we're still in the 5.3 merge window, I'll see what I can do.
>>>
>>> Shall I proceed with a patch adding the dm_mod.kcopyd_subjob_size
>>> modparam?
>>
>> Sure.  And it could be that we won't need 2.
>>
>> Ideally the default would work for every setup.  Less knobs the better.
>> But as a stop-gap I think we need to expose a knob that allows override.
>>
>> Thinking further, I don't think changing the default to 512K is too
>> risky (famous last words).  So please just update your original patch to
>> include the modparam so that users can get the old 64K back if needed.
>>
>> BTW, the param name should probably be "kcopyd_subjob_size_kb" to
>> reflect the value is KB.
> 
> One other thing: not sure what the max should be on this
> modparam.. maybe 1024K?

I think 1024K is a reasonable maximum value.

I will add the "kcopyd_subjob_size_kb" modparam and send a second
version of the patch.

Thanks,
Nikos

> 
> Mike
> 
