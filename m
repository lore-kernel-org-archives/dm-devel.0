From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH v10 4/8] block: Add bio_reset()
Date: Fri, 07 Sep 2012 15:55:35 -0600
Message-ID: <504A6D57.1030607@kernel.dk>
References: <1346970902-10931-1-git-send-email-koverstreet@google.com> <1346970902-10931-5-git-send-email-koverstreet@google.com> <50494F1A.4080207@kernel.dk> <20120907205823.GD16360@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120907205823.GD16360-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

On 2012-09-07 14:58, Kent Overstreet wrote:
> On Thu, Sep 06, 2012 at 07:34:18PM -0600, Jens Axboe wrote:
>> On 2012-09-06 16:34, Kent Overstreet wrote:
>>> Reusing bios is something that's been highly frowned upon in the past,
>>> but driver code keeps doing it anyways. If it's going to happen anyways,
>>> we should provide a generic method.
>>>
>>> This'll help with getting rid of bi_destructor - drivers/block/pktcdvd.c
>>> was open coding it, by doing a bio_init() and resetting bi_destructor.
>>>
>>> This required reordering struct bio, but the block layer is not yet
>>> nearly fast enough for any cacheline effects to matter here.
>>
>> That's an odd and misplaced comment. Was just doing testing today at 5M
>> IOPS, and even years back we've had cache effects for O_DIRECT in higher
>> speed setups.
> 
> Ah, I wasn't aware that you were pushing that many iops through the
> block layer - most I've tested myself was around 1M. It wouldn't
> surprise me if cache effects in struct bio mattered around 5M...

5M is nothing, just did 13.5M :-)

But we can reshuffle for now. As mentioned, we're way overdue for a
decent look at cache profiling in any case.

>> That said, we haven't done cache analysis in a long time. So moving
>> members around isn't necessarily a huge deal.
> 
> Ok, good to know. I've got another patch coming later that reorders
> struct bio a bit more, for immutable bvecs (bi_sector, bi_size, bi_idx
> go into a struct bvec_iter together).

OK

>> Lastly, this isn't a great commit message for other reasons. Anyone can
>> see that it moves members around. It'd be a lot better to explain _why_
>> it is reordering the struct.
> 
> Yeah, I suppose so. Will keep that in mind for the next patch.

Thanks.

>> BTW, I looked over the rest of the patches, and it looks OK to me.
> 
> Resent them. Thanks!

Got it.

-- 
Jens Axboe
