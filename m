From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [RFC PATCH 0/1] dm-crypt excessive overhead
Date: Sat, 20 Jun 2020 15:36:21 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.2006201535280.24999@file01.intranet.prod.int.rdu2.redhat.com>
References: <20200619164132.1648-1-ignat@cloudflare.com>
	<20200619165548.GA24779@redhat.com>
	<alpine.LRH.2.02.2006191429060.23991@file01.intranet.prod.int.rdu2.redhat.com>
	<20200620012332.GA25340@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200620012332.GA25340@gondor.apana.org.au>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Mike Snitzer <snitzer@redhat.com>, kernel-team@cloudflare.com, dm-crypt@saout.de, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Ignat Korchagin <ignat@cloudflare.com>, "David S. Miller" <davem@davemloft.net>, agk@redhat.com
List-Id: dm-devel.ids



On Sat, 20 Jun 2020, Herbert Xu wrote:

> On Fri, Jun 19, 2020 at 02:39:39PM -0400, Mikulas Patocka wrote:
> >
> > I'm looking at this and I'd like to know why does the crypto API fail in 
> > hard-irq context and why does it work in tasklet context. What's the exact 
> > reason behind this?
> 
> You're not supposed to do any real work in IRQ handlers.  All
> the substantial work should be postponed to softirq context.

I see.

BTW - should it also warn if it is running in a process context with 
interrupts disabled?

Mikulas

> Why do you need to do work in hard IRQ context?
> 
> Cheers,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> 
