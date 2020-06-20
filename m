From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH 0/1] dm-crypt excessive overhead
Date: Sat, 20 Jun 2020 11:23:33 +1000
Message-ID: <20200620012332.GA25340@gondor.apana.org.au>
References: <20200619164132.1648-1-ignat@cloudflare.com>
 <20200619165548.GA24779@redhat.com>
 <alpine.LRH.2.02.2006191429060.23991@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.2006191429060.23991@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Ignat Korchagin <ignat@cloudflare.com>, "David S. Miller" <davem@davemloft.net>, Mike Snitzer <snitzer@redhat.com>, agk@redhat.com, dm-devel@redhat.com, dm-crypt@saout.de, linux-kernel@vger.kernel.org, kernel-team@cloudflare.com
List-Id: dm-devel.ids

On Fri, Jun 19, 2020 at 02:39:39PM -0400, Mikulas Patocka wrote:
>
> I'm looking at this and I'd like to know why does the crypto API fail in 
> hard-irq context and why does it work in tasklet context. What's the exact 
> reason behind this?

You're not supposed to do any real work in IRQ handlers.  All
the substantial work should be postponed to softirq context.

Why do you need to do work in hard IRQ context?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
