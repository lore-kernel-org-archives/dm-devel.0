From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [RFC PATCH 0/1] dm-crypt excessive overhead
Date: Tue, 23 Jun 2020 11:33:52 -0400
Message-ID: <20200623153352.GA19783@redhat.com>
References: <20200619164132.1648-1-ignat@cloudflare.com>
 <20200619165548.GA24779@redhat.com>
 <alpine.LRH.2.02.2006191429060.23991@file01.intranet.prod.int.rdu2.redhat.com>
 <20200620012332.GA25340@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200620012332.GA25340@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Ignat Korchagin <ignat@cloudflare.com>, "David S. Miller" <davem@davemloft.net>, agk@redhat.com, dm-devel@redhat.com, dm-crypt@saout.de, linux-kernel@vger.kernel.org, kernel-team@cloudflare.com
List-Id: dm-devel.ids

On Fri, Jun 19 2020 at  9:23pm -0400,
Herbert Xu <herbert@gondor.apana.org.au> wrote:

> On Fri, Jun 19, 2020 at 02:39:39PM -0400, Mikulas Patocka wrote:
> >
> > I'm looking at this and I'd like to know why does the crypto API fail in 
> > hard-irq context and why does it work in tasklet context. What's the exact 
> > reason behind this?
> 
> You're not supposed to do any real work in IRQ handlers.  All
> the substantial work should be postponed to softirq context.
> 
> Why do you need to do work in hard IRQ context?

Ignat, think you may have missed Herbert's question?

My understanding is that you're doing work in hard IRQ context (via
tasklet) precisely to avoid overhead of putting to a workqueue?  Did
you try using a workqueue and it didn't work adequately?  If so, do you
have a handle on why that is?  E.g. was it due to increased latency? or
IO completion occurring on different cpus that submitted (are you
leaning heavily on blk-mq's ability to pin IO completion to same cpu as
IO was submitted?)

I'm fishing here but I'd just like to tease out the details for _why_
you need to do work from hard IRQ via tasklet so that I can potentially
defend it if needed.

Thanks,
Mike
