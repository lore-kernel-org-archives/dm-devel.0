From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] [PATCH] DM-CRYPT: Scale to multiple CPUs
Date: Wed, 2 Jun 2010 01:10:00 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1006020051540.22695@hs20-bc2-1.build.redhat.com>
References: <20100531160425.GA20344@basil.fritz.box>
 <Pine.LNX.4.64.1005312239520.6372@hs20-bc2-1.build.redhat.com>
 <20100601043901.GA25693@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100601043901.GA25693@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: device-mapper development <dm-devel@redhat.com>, linux-kernel@vger.kernel.org, agk@redhat.com, ak@linux.intel.com
List-Id: dm-devel.ids



On Tue, 1 Jun 2010, Herbert Xu wrote:

> On Mon, May 31, 2010 at 10:44:30PM -0400, Mikulas Patocka wrote:
> > Questions:
> > 
> > If you are optimizing it,
> > 
> > 1) why don't you optimize it in such a way that if one CPU submits 
> > requests, the crypto work is spread among all the CPUs? Currently it 
> > spreads the work only if different CPUs submit it.
> 
> Because the crypto layer already provides that functionality,
> through pcrypt.  By instantiating pcrypt for a given algorithm,
> you can parallelise that algorithm across CPUs.

And how can I use pcrypt for dm-crypt? After a quick look at pcrypt 
sources, it seems to be dependent on aead and not useable for general 
encryption algorithms at all.

I tried cryptd --- in theory it should work by requesting the algorithm 
like cryptd(cbc(aes)) --- but if I replace "%s(%s)" with "cryptd(%s(%s))" 
in dm-crypt sources it locks up and doesn't work.

> This would be inappropriate for upper layer code as they do not
> know whether the underlying algorithm should be parallelised,
> e.g., a PCI offload board certainly should not be parallelised.

The upper layer should ideally request "cbc(aes)" and the crypto routine 
should select the most efficient implementation --- sync on single-core 
system, async with cryptd on multi-core system and async with hardware 
implementation if you have HIFN crypto card.

> > 2) why not optimize software async crypto daemon (crypt/cryptd.c) instead 
> > of dm-crypt, so that all kernel subsystems can actually take advantage of 
> > those multi-CPU optimizations, not just dm-crypt?
> 
> Because you cannot do what Andi is doing here in the crypto layer.
> What dm-crypt does today (which hasn't always been the case BTW)
> hides information away (the original submitting CPU) that we cannot
> recreate.

It is pointless to track the submitting CPU.

Majority of time is consumed by raw encyption/decryption. And you must 
optimize that --- i.e. on SMP system make sure that cryptd distributes the 
work across all available cores.

When you get this right --- i.e. when reading encrypted disk, you get 
either read speed equivalent to non-encrypted disk or all the cores are 
saturated, then you can start thinking about other optimizations.

Mikulas
