From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/1] blk/core: Gracefully handle unset make_request_fn
Date: Thu, 23 Jan 2020 11:52:26 -0700
Message-ID: <81055166-37fb-ad65-6a53-11c22c626ab1@kernel.dk>
References: <20200123091713.12623-1-stefan.bader@canonical.com>
 <20200123091713.12623-2-stefan.bader@canonical.com>
 <20200123103541.GA28102@redhat.com> <20200123172816.GA31063@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200123172816.GA31063@redhat.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, Stefan Bader <stefan.bader@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com, Tyler Hicks <tyler.hicks@canonical.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On 1/23/20 10:28 AM, Mike Snitzer wrote:
> On Thu, Jan 23 2020 at  5:35am -0500,
> Mike Snitzer <snitzer@redhat.com> wrote:
> 
>> On Thu, Jan 23 2020 at  4:17am -0500,
>> Stefan Bader <stefan.bader@canonical.com> wrote:
>>
>>> When device-mapper adapted for multi-queue functionality, they
>>> also re-organized the way the make-request function was set.
>>> Before, this happened when the device-mapper logical device was
>>> created. Now it is done once the mapping table gets loaded the
>>> first time (this also decides whether the block device is request
>>> or bio based).
>>>
>>> However in generic_make_request(), the request function gets used
>>> without further checks and this happens if one tries to mount such
>>> a partially set up device.
>>>
>>> This can easily be reproduced with the following steps:
>>>  - dmsetup create -n test
>>>  - mount /dev/dm-<#> /mnt
>>>
>>> This maybe is something which also should be fixed up in device-
>>> mapper.
>>
>> I'll look closer at other options.
>>
>>> But given there is already a check for an unset queue
>>> pointer and potentially there could be other drivers which do or
>>> might do the same, it sounds like a good move to add another check
>>> to generic_make_request_checks() and to bail out if the request
>>> function has not been set, yet.
>>>
>>> BugLink: https://bugs.launchpad.net/bugs/1860231
>>
>> >From that bug;
>> "The currently proposed fix introduces no chance of stability
>> regressions. There is a chance of a very small performance regression
>> since an additional pointer comparison is performed on each block layer
>> request but this is unlikely to be noticeable."
>>
>> This captures my immediate concern: slowing down everyone for this DM
>> edge-case isn't desirable.
> 
> SO I had a look and there isn't anything easier than adding the proposed
> NULL check in generic_make_request_checks().  Given the many
> conditionals in that  function.. what's one more? ;)
> 
> I looked at marking the queue frozen to prevent IO via
> blk_queue_enter()'s existing cheeck -- but that quickly felt like an
> abuse, especially in that there isn't a queue unfreeze for bio-based.
> 
> Jens, I'll defer to you to judge this patch further.  If you're OK with
> it: cool.  If not, I'm open to suggestions for how to proceed.  
> 

It does kinda suck... The generic_make_request_checks() is a mess, and
this doesn't make it any better. Any reason why we can't solve this
two step setup in a clean fashion instead of patching around it like
this? Feels like a pretty bad hack, tbh.

-- 
Jens Axboe
