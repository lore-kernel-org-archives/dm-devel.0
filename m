From: Kent Overstreet <koverstreet@google.com>
Subject: Re: [PATCH v7 9/9] block: Avoid deadlocks with bio
 allocation by stacking drivers
Date: Thu, 30 Aug 2012 18:55:48 -0700
Message-ID: <CAH+dOxLgXxhE7h3bboBczy4stn5k-Rbky7mDHYN4nnmismcq4g@mail.gmail.com>
References: <1346175456-1572-1-git-send-email-koverstreet@google.com>
	<1346175456-1572-10-git-send-email-koverstreet@google.com>
	<Pine.LNX.4.64.1208291210180.774@file.rdu.redhat.com>
	<20120829165006.GB20312@google.com>
	<20120829170711.GC12504@redhat.com>
	<20120829171345.GC20312@google.com>
	<20120830220745.GI27257@redhat.com>
	<20120831014359.GB15218@moria.home.lan>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20120831014359.GB15218@moria.home.lan>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>, bharrosh@panasas.com, tj@kernel.org
List-Id: dm-devel.ids

On Thu, Aug 30, 2012 at 6:43 PM, Kent Overstreet <koverstreet@google.com> wrote:
> On Thu, Aug 30, 2012 at 06:07:45PM -0400, Vivek Goyal wrote:
>> On Wed, Aug 29, 2012 at 10:13:45AM -0700, Kent Overstreet wrote:
>>
>> [..]
>> > > Performance aside, punting submission to per device worker in case of deep
>> > > stack usage sounds cleaner solution to me.
>> >
>> > Agreed, but performance tends to matter in the real world. And either
>> > way the tricky bits are going to be confined to a few functions, so I
>> > don't think it matters that much.
>> >
>> > If someone wants to code up the workqueue version and test it, they're
>> > more than welcome...
>>
>> Here is one quick and dirty proof of concept patch. It checks for stack
>> depth and if remaining space is less than 20% of stack size, then it
>> defers the bio submission to per queue worker.
>
> I can't think of any correctness issues. I see some stuff that could be
> simplified (blk_drain_deferred_bios() is redundant, just make it a
> wrapper around blk_deffered_bio_work()).
>
> Still skeptical about the performance impact, though - frankly, on some
> of the hardware I've been running bcache on this would be a visible
> performance regression - probably double digit percentages but I'd have
> to benchmark it.  That kind of of hardware/usage is not normal today,
> but I've put a lot of work into performance and I don't want to make
> things worse without good reason.

Here's another crazy idea - we don't really need another thread, just
more stack space.

We could check if we're running out of stack space, then if we are
just allocate another two pages and memcpy the struct thread_info
over.

I think the main obstacle is that we'd need some per arch code for
mucking with the stack pointer. And it'd break backtraces, but that's
fixable.
