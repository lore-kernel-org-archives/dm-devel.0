From: Ignat Korchagin <ignat@cloudflare.com>
Subject: Re: [RFC PATCH 0/1] dm-crypt excessive overhead
Date: Tue, 23 Jun 2020 17:24:39 +0100
Message-ID: <CALrw=nEjCdg8BuTFT81+tCDtuxgwy05FKZAdvk3oq+pauW0nDA@mail.gmail.com>
References: <20200619164132.1648-1-ignat@cloudflare.com> <20200619165548.GA24779@redhat.com>
 <alpine.LRH.2.02.2006191429060.23991@file01.intranet.prod.int.rdu2.redhat.com>
 <20200620012332.GA25340@gondor.apana.org.au> <20200623153352.GA19783@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200623153352.GA19783@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Mikulas Patocka <mpatocka@redhat.com>, "David S. Miller" <davem@davemloft.net>, agk@redhat.com, dm-devel@redhat.com, dm-crypt@saout.de, linux-kernel <linux-kernel@vger.kernel.org>, kernel-team <kernel-team@cloudflare.com>
List-Id: dm-devel.ids

On Tue, Jun 23, 2020 at 4:34 PM Mike Snitzer <snitzer@redhat.com> wrote:
>
> On Fri, Jun 19 2020 at  9:23pm -0400,
> Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> > On Fri, Jun 19, 2020 at 02:39:39PM -0400, Mikulas Patocka wrote:
> > >
> > > I'm looking at this and I'd like to know why does the crypto API fail in
> > > hard-irq context and why does it work in tasklet context. What's the exact
> > > reason behind this?
> >
> > You're not supposed to do any real work in IRQ handlers.  All
> > the substantial work should be postponed to softirq context.
> >
> > Why do you need to do work in hard IRQ context?
>
> Ignat, think you may have missed Herbert's question?
>
> My understanding is that you're doing work in hard IRQ context (via
> tasklet) precisely to avoid overhead of putting to a workqueue?  Did
> you try using a workqueue and it didn't work adequately?  If so, do you
> have a handle on why that is?  E.g. was it due to increased latency? or
> IO completion occurring on different cpus that submitted (are you
> leaning heavily on blk-mq's ability to pin IO completion to same cpu as
> IO was submitted?)
>
> I'm fishing here but I'd just like to tease out the details for _why_
> you need to do work from hard IRQ via tasklet so that I can potentially
> defend it if needed.

I may be misunderstanding the terminology, but tasklets execute in
soft IRQ, don't they? What we care about is to execute the decryption
as fast as possible, but we can't do it in a hard IRQ context (that
is, the interrupt context where other interrupts are disabled). As far
as I understand, tasklets are executed right after the hard IRQ
context, but with interrupts enabled - which is the first safe-ish
place to do more lengthy processing without the risk of missing an
interrupt.

Workqueues instead of tasklets - is the way how it is mostly
implemented now. But that creates additional IO latency, most probably
due to the fact that we're introducing CPU scheduling latency into the
overall read IO latency. This is confirmed by the fact that our busier
production systems have much worse and more important - spiky and
unstable p99 read latency, which somewhat correlates to high CPU
scheduling latency reported by metrics.

So, by inlining crypto or using a tasklet we're effectively
prioritising IO encryption/decryption. What we want to avoid is mixing
unpredicted additional latency from an unrelated subsystem (CPU
scheduler), because our expectation is that the total latency should
be real HW io latency + crypto operation latency (which is usually
quite stable).

I hope this makes sense.

>
> Thanks,
> Mike
>
