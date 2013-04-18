From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [BUG REPORT] Kernel panic on 3.9.0-rc7-4-gbb33db7
Date: Thu, 18 Apr 2013 12:10:44 -0700
Message-ID: <CA+55aFxEThMJid_PiL=ko3duRPzzynkhMovsrm3TR_UXxUGciA@mail.gmail.com>
References: <1366209997.8817.12.camel@pippen.local.home>
	<20130418123738.GV4816@kernel.dk>
	<516FED09.1040008@cn.fujitsu.com>
	<20130418133546.GX4816@kernel.dk>
	<516FFFAC.8040103@cn.fujitsu.com>
	<20130418143014.GZ4816@kernel.dk>
	<CA+55aFwA8njGh4v8ZfR_o4s4m=Hugnadeir=uxbeE4yxHiBKLg@mail.gmail.com>
	<20130418172732.GB9897@mtj.dyndns.org>
	<20130418173811.GF4816@kernel.dk>
	<20130418180752.GD9897@mtj.dyndns.org>
	<20130418181318.GH4816@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130418181318.GH4816@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>, Wanlong Gao <gaowanlong@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung@gmail.com>, Alasdair G Kergon <agk@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Neil Brown <neilb@suse.de>, LKML <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On Thu, Apr 18, 2013 at 11:13 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On Thu, Apr 18 2013, Tejun Heo wrote:
>> On Thu, Apr 18, 2013 at 10:39:00AM -0700, Jens Axboe wrote:
>> >
>> > Yep, thanks Linus for that hint... Must be someone abusing it for a
>> > flag field post submission? Crazy.
>>
>> Let's hope that's not the case because there'll be blood if it is. :)
>
> Yeah, it's beyond the amount of crazy I've come to expect from various
> random users of IO interfaces :-)

I think it's more likely to be some use-after-free after a long timeout.

Wanlong says it happens a few minutes after boot, so maybe something
times out a command, does the blk_complete_request(), and free's the
bio, which gets re-used before the softirq actually ends up running.

I note that Wanlong uses the SLAB allocator, not the SLUB one. I
wonder if the thing goes away with SLUB, and if not, if
CONFIG_SLUB_DEBUG_ON=y might help debug it?

                     Linus
