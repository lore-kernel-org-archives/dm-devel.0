From: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [PATCH] block: add missing block_bio_complete() tracepoint
Date: Mon, 30 Jan 2012 11:22:29 +0900
Message-ID: <4F25FEE5.5010309@gmail.com>
References: <1327830093-12130-1-git-send-email-namhyung@gmail.com> <20120129192447.GB17211@htj.dyndns.org> <4F25F5F3.6060507@gmail.com> <20120130014703.GG17211@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120130014703.GG17211@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

2012-01-30 10:47 AM, Tejun Heo wrote:
> On Mon, Jan 30, 2012 at 10:44:19 AM +0900, Namhyung Kim wrote:
>> The userland tool cannot distinguish bounced bio from original one
>> at completion TP, but it can expect there will be a duplicated
>> BLK_TA_COMPLETE as it sees BLK_TA_BOUNCE for the bio before.
>>
>> Filtering it out from kernel side seems to hide a real information
>> that (paranoid?) user might want to get, and it looks like providing
>> "polcy not mechanism" IMHO. That's why I changed my mind finally.
>>
>> I cannot think of the downside, anyway it's not a big deal, if you
>> think it's wrong choice, I'm OK to change it again.
>
> It's just that this patch as it stands will break the existing tools
> and is likely to cause some amount of head scratching for blktrace
> users upgrading to new kernel with existing userland, so yeah, I think
> it should be filtered in kernel from blktrace.c.
>
> Thanks.
>

Will it break blktrace? Looking at the code, not tested though, it will 
just add one more 'C' line for bounced bio, and that's it? The blktrace 
will get way more 'C' lines for normal request based devices and it 
needs to be handled anyway. Am I missing something?

Thanks,
Namhyung
