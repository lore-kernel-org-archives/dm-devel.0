From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH 0/1] dm-crypt excessive overhead
Date: Wed, 24 Jun 2020 10:23:01 +1000
Message-ID: <20200624002301.GB12716@gondor.apana.org.au>
References: <20200619164132.1648-1-ignat@cloudflare.com>
 <20200619165548.GA24779@redhat.com>
 <alpine.LRH.2.02.2006191429060.23991@file01.intranet.prod.int.rdu2.redhat.com>
 <20200620012332.GA25340@gondor.apana.org.au>
 <20200623153352.GA19783@redhat.com>
 <CALrw=nEjCdg8BuTFT81+tCDtuxgwy05FKZAdvk3oq+pauW0nDA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALrw=nEjCdg8BuTFT81+tCDtuxgwy05FKZAdvk3oq+pauW0nDA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ignat Korchagin <ignat@cloudflare.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, "David S. Miller" <davem@davemloft.net>, agk@redhat.com, dm-devel@redhat.com, dm-crypt@saout.de, linux-kernel <linux-kernel@vger.kernel.org>, kernel-team <kernel-team@cloudflare.com>
List-Id: dm-devel.ids

On Tue, Jun 23, 2020 at 05:24:39PM +0100, Ignat Korchagin wrote:
> 
> I may be misunderstanding the terminology, but tasklets execute in
> soft IRQ, don't they? What we care about is to execute the decryption
> as fast as possible, but we can't do it in a hard IRQ context (that
> is, the interrupt context where other interrupts are disabled). As far
> as I understand, tasklets are executed right after the hard IRQ
> context, but with interrupts enabled - which is the first safe-ish
> place to do more lengthy processing without the risk of missing an
> interrupt.

Yes you are absolutely right.  In general high-performance work
should be carried out in softirq context.  That's how the networking
stack works for example.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
