From: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [PATCH] block: add missing block_bio_complete() tracepoint
Date: Mon, 30 Jan 2012 11:49:43 +0900
Message-ID: <4F260547.1030405@gmail.com>
References: <1327830093-12130-1-git-send-email-namhyung@gmail.com> <20120129192447.GB17211@htj.dyndns.org> <4F25F5F3.6060507@gmail.com> <20120130014703.GG17211@htj.dyndns.org> <4F25FEE5.5010309@gmail.com> <20120130023012.GH17211@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120130023012.GH17211@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

2012-01-30 11:30 AM, Tejun Heo wrote:
> On Mon, Jan 30, 2012 at 11:22:29AM +0900, Namhyung Kim wrote:
>>> It's just that this patch as it stands will break the existing tools
>>> and is likely to cause some amount of head scratching for blktrace
>>> users upgrading to new kernel with existing userland, so yeah, I think
>>> it should be filtered in kernel from blktrace.c.
>>
>> Will it break blktrace? Looking at the code, not tested though, it
>> will just add one more 'C' line for bounced bio, and that's it? The
>> blktrace will get way more 'C' lines for normal request based
>> devices and it needs to be handled anyway. Am I missing something?
>
> Hmmm... maybe I'm confused.  Wouldn't it cause duplicate completions
> for all rq based drivers too?
>

Yes, blktrace will see both of completions for rq and bio's it contains 
from now on, and I thought it's your intention? For the bounced bio's, 
it'll see one more completion per bio.

The users of older blktrace might get confused by this, thus changing 
the tool is inevitable regardless of the bounced bio's.

Thanks,
Namhyung
