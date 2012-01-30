From: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [PATCH] block: add missing block_bio_complete() tracepoint
Date: Mon, 30 Jan 2012 15:02:19 +0900
Message-ID: <4F26326B.5010806@gmail.com>
References: <1327830093-12130-1-git-send-email-namhyung@gmail.com> <20120129192447.GB17211@htj.dyndns.org> <4F25F5F3.6060507@gmail.com> <20120130014703.GG17211@htj.dyndns.org> <4F25FEE5.5010309@gmail.com> <20120130023012.GH17211@htj.dyndns.org> <4F260547.1030405@gmail.com> <20120130025326.GI17211@htj.dyndns.org> <4F262FEF.9020406@gmail.com> <20120130055459.GJ17211@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120130055459.GJ17211@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

2012-01-30 2:54 PM, Tejun Heo wrote:
> On Mon, Jan 30, 2012 at 02:51:43PM +0900, Namhyung Kim wrote:
>> Hi,
>>
>> 2012-01-30 11:53 AM, Tejun Heo wrote:
>>> Hello,
>>>
>>> On Mon, Jan 30, 2012 at 11:49:43 AM +0900, Namhyung Kim wrote:
>>>> Yes, blktrace will see both of completions for rq and bio's it
>>>> contains from now on, and I thought it's your intention? For the
>>>> bounced bio's, it'll see one more completion per bio.
>>>
>>> Umm... no, blktrace users shouldn't see confusing outputs.  My point
>>> was that we should leave raw tracepoints as raw monitor points so that
>>> they can provide raw data to different users and filter from
>>> blktrace.c so that the existing users aren't disturbed.
>>>
>>
>> That means blktrace should not be changed, and not see duplicated
>> completions for rq based drivers at all?
>
> Yeap
>

I see. I'll prepare the patch soon.

Thanks,
Namhyung
